#!/bin/sh
# Check JWT
# Select with jq Expire Time
# Make Timediff check
# If higher than x days its a Critcal
# Example ./jwt_expire.sh $jwt
# require base64 and jq
JWTEXP=$(echo "$1"  | sed '/\..*\./s/^[^.]*\.//'| base64 --decode --ignore-garbage | jq '.exp')
JWTiSS=$(echo "$1"  | sed '/\..*\./s/^[^.]*\.//'| base64 --decode --ignore-garbage | jq '.iss')
#+0 is for troubelshooting +0 = is today
timeago=$(date -d "+0 days"  +%s )
diff=$(( (JWTEXP - timeago) / 86400 ))

if [ $diff -ge 100 ]
then
    echo "OK - $JWTiSS JWT Expire in $diff Days"
    exit 0
elif [ $diff -le 99 ] && [ $diff -ge 21 ]
then
    echo "Warning - $JWTiSS JWT Expire in $diff Days"
    exit 1
elif [ $diff -le 20 ]
then
    echo "CRITICAL - $JWTiSS JWT Expire in $diff Days"
    exit 2
else
    echo "UNKNOWN - $JWTiSS JWT Expire in $diff Days"
    exit 3
fi

