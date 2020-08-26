FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["containersamples.csproj", "./"]
RUN dotnet restore "./containersamples.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "containersamples.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "containersamples.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "containersamples.dll"]
