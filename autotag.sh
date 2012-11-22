#!/bin/bash

PROJ="/home/builder/quickbuild/workspace/SC8810/sprdroid4.0.3_vlx_3.0/"

echo -n "TagFile[default.xml]:"
read INFILE
echo -n "TagName[MocorDroid4.0.3_W12.16]:"
read Tag
echo -n "TagDate[short description]:"
read TagDate

if [ -z "${INFILE}" -o -z "${Tag}" -o -z "${TagDate}" ]; then
  echo "please input arguments"
  exit
else
  echo "git tag -a ${Tag} -m '${Tag} on ${TagDate}' sha1"
fi

while read line
do

      prjpath=$(echo ${line} | sed -e '/<project/!d' -e '/path=/!d' | sed "s/.*path=\"//g" | sed "s/\".*//g")
      [ "${prjpath}" ] || {
          prjpath=$(echo ${line} | sed -e '/<project/!d' -e '/name=/!d' | sed "s/.*name=\"//g" | sed "s/\".*//g")
      }
      prjversion_base=$(echo ${line} | sed -e '/<project/!d' -e '/revision=/!d' | sed "s/.*revision=\"//g" | sed "s/\".*//g")
      if [ "${prjpath}" -a "${prjversion_base}" ]; then
        cd ${PROJ}/${prjpath}
        git tag -a ${Tag} -m "${Tag} on ${TagDate}" ${prjversion_base}
      else
        continue
      fi
done < ${INFILE}
