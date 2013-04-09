require 'pry'
gem 'sinatra', '1.3.0'
require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'open-uri'
require 'uri'

get '/movies/:imdb_id' do
     @url = "http://www.omdbapi.com/?i=#{params[:imdb_id]}"
     file = open(@url)	
     @movie = JSON.load(file.read)
     erb :details
end

get '/' do
  @movies = []
  if !params[:title].nil? 
	  @title = params[:title]
	  @url = "http://www.omdbapi.com/?s=#{URI.escape(@title)}"
	  file = open(@url)	
	  @result = JSON.load(file.read)

	  if @result['Error']
	  	return "Sorry! There was an error: #{@result['Error']}"
	  	#erb :error
	  end

	  # Get the detailed results for each movie
	  @movies = @result['Search'].collect do |s|
	    @url = "http://www.omdbapi.com/?i=#{URI.escape(s['imdbID'])}"
	    file = open(@url)	
	    JSON.load(file.read)
	  end
  end
  erb :home
end