Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaKJMM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:12:27 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55797 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaKJMM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:12:26 -0500
MIME-Version: 1.0
In-Reply-To: <1415619745.21229.3.camel@x220>
References: <1415476595-21587-1-git-send-email-valentinrothberg@gmail.com> <1415619745.21229.3.camel@x220>
From: Valentin Rothberg <valentinrothberg@gmail.com>
Date: Mon, 10 Nov 2014 13:11:54 +0100
Message-ID: <CAD3Xx4Lm9W4tVxgBevU9_P_UEy4oTOwxVs9R2G0miG5HpCb8bw@mail.gmail.com>
Subject: Re: [PATCH] checkkconfigsymbols.py: improve detection of defects
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        hengelein Stefan <stefan.hengelein@fau.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:42 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sat, 2014-11-08 at 20:56 +0100, Valentin Rothberg wrote:
>> This patch improves the detection of defects by updating the
>> regular expression to find Kconfig identifiers in the source
>> code, and fixes some cases of false positives. The following
>> changes are made:
>> - improve regex to find Kconfig identifiers in the source
>> - exclude .log files from analysis
>> - improve filtering of false positives (e.g, CONFIG_XXX)
>> - change output format from (feature:\tlist) to (feature\tlist)
>>
>> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
>> ---
>> Changelog:
>> This patch bases on version 6 (https://lkml.org/lkml/2014/9/27/93)
>> of a patch which has been picked up by Greg in his misc-char tree
>> in the char-misc-next branch.
>
> It is apparently that v6 which is included in linux-next as of today.
>
>>  Version 6 replaces the old shell
>> script with a new implementation in python.
>
> Am I right in thinking this patch basically updates this script to the
> v8 of your patch, that we discussed in
> https://lkml.org/lkml/2014/9/29/506 ?

Yes, you are right.

>>  scripts/checkkconfigsymbols.py | 57 ++++++++++++++++++++----------------------
>>  1 file changed, 27 insertions(+), 30 deletions(-)
>>
>> diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
>> index f944089..e9cc689 100644
>> --- a/scripts/checkkconfigsymbols.py
>> +++ b/scripts/checkkconfigsymbols.py
>> @@ -1,36 +1,31 @@
>>  #!/usr/bin/env python
>>
>> -"""Find Kconfig identifieres that are referenced but not defined."""
>> +"""Find Kconfig identifiers that are referenced but not defined."""
>>
>> -# Copyright (C) 2014 Valentin Rothberg <valentinrothberg@gmail.com>
>> -# Copyright (C) 2014 Stefan Hengelein <stefan.hengelein@fau.de>
>> +# (c) 2014 Valentin Rothberg <valentinrothberg@gmail.com>
>> +# (c) 2014 Stefan Hengelein <stefan.hengelein@fau.de>
>>  #
>> -# This program is free software; you can redistribute it and/or modify it
>> -# under the terms and conditions of the GNU General Public License,
>> -# version 2, as published by the Free Software Foundation.
>> -#
>> -# This program is distributed in the hope it will be useful, but WITHOUT
>> -# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> -# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
>> -# more details.
>> +# Licensed under the terms of the GNU GPL License version 2
>>
>>
>>  import os
>>  import re
>>  from subprocess import Popen, PIPE, STDOUT
>>
>> -# REGEX EXPRESSIONS
>> +
>> +# regex expressions
>>  OPERATORS = r"&|\(|\)|\||\!"
>> -FEATURE = r"\w*[A-Z]{1}\w*"
>> -CONFIG_DEF = r"^\s*(?:menu){,1}config\s+(" + FEATURE + r")\s*"
>> +FEATURE = r"(?:\w*[A-Z0-9]\w*){2,}"
>> +DEF = r"^\s*(?:menu){,1}config\s+(" + FEATURE + r")\s*"
>>  EXPR = r"(?:" + OPERATORS + r"|\s|" + FEATURE + r")+"
>>  STMT = r"^\s*(?:if|select|depends\s+on)\s+" + EXPR
>> +SOURCE_FEATURE = r"(?:\W|\b)+[D]{,1}CONFIG_(" + FEATURE + r")"
>>
>> -# REGEX OBJECTS
>> +# regex objects
>>  REGEX_FILE_KCONFIG = re.compile(r".*Kconfig[\.\w+\-]*$")
>>  REGEX_FEATURE = re.compile(r"(" + FEATURE + r")")
>> -REGEX_SOURCE_FEATURE = re.compile(r"(?:D|\W|\b)+CONFIG_(" + FEATURE + r")")
>> -REGEX_KCONFIG_DEF = re.compile(CONFIG_DEF)
>> +REGEX_SOURCE_FEATURE = re.compile(SOURCE_FEATURE)
>> +REGEX_KCONFIG_DEF = re.compile(DEF)
>>  REGEX_KCONFIG_EXPR = re.compile(EXPR)
>>  REGEX_KCONFIG_STMT = re.compile(STMT)
>>  REGEX_KCONFIG_HELP = re.compile(r"^\s+(help|---help---)\s*$")
>> @@ -42,7 +37,7 @@ def main():
>>      source_files = []
>>      kconfig_files = []
>>      defined_features = set()
>> -    referenced_features = dict()
>> +    referenced_features = dict()  # {feature: [files]}
>>
>>      # use 'git ls-files' to get the worklist
>>      pop = Popen("git ls-files", stdout=PIPE, stderr=STDOUT, shell=True)
>> @@ -52,12 +47,12 @@ def main():
>>
>>      for gitfile in stdout.rsplit("\n"):
>>          if ".git" in gitfile or "ChangeLog" in gitfile or \
>> -                os.path.isdir(gitfile):
>> +                ".log" in gitfile or os.path.isdir(gitfile):
>>              continue
>>          if REGEX_FILE_KCONFIG.match(gitfile):
>>              kconfig_files.append(gitfile)
>>          else:
>> -            # All non-Kconfig files are checked for consistency
>> +            # all non-Kconfig files are checked for consistency
>>              source_files.append(gitfile)
>>
>>      for sfile in source_files:
>> @@ -68,15 +63,17 @@ def main():
>>
>>      print "Undefined symbol used\tFile list"
>>      for feature in sorted(referenced_features):
>> +        # filter some false positives
>> +        if feature == "FOO" or feature == "BAR" or \
>> +                feature == "FOO_BAR" or feature == "XXX":
>> +            continue
>>          if feature not in defined_features:
>>              if feature.endswith("_MODULE"):
>> -                # Avoid false positives for kernel modules
>> +                # avoid false positives for kernel modules
>>                  if feature[:-len("_MODULE")] in defined_features:
>>                      continue
>> -            if "FOO" in feature or "BAR" in feature:
>> -                continue
>>              files = referenced_features.get(feature)
>> -            print "%s:\t%s" % (feature, ", ".join(files))
>> +            print "%s\t%s" % (feature, ", ".join(files))
>>
>>
>>  def parse_source_file(sfile, referenced_features):
>> @@ -92,9 +89,9 @@ def parse_source_file(sfile, referenced_features):
>>          for feature in features:
>>              if not REGEX_FILTER_FEATURES.search(feature):
>>                  continue
>> -            paths = referenced_features.get(feature, set())
>> -            paths.add(sfile)
>> -            referenced_features[feature] = paths
>> +            sfiles = referenced_features.get(feature, set())
>> +            sfiles.add(sfile)
>> +            referenced_features[feature] = sfiles
>>
>>
>>  def get_features_in_line(line):
>> @@ -113,7 +110,7 @@ def parse_kconfig_file(kfile, defined_features, referenced_features):
>>      for i in range(len(lines)):
>>          line = lines[i]
>>          line = line.strip('\n')
>> -        line = line.split("#")[0]  # Ignore Kconfig comments
>> +        line = line.split("#")[0]  # ignore comments
>>
>>          if REGEX_KCONFIG_DEF.match(line):
>>              feature_def = REGEX_KCONFIG_DEF.findall(line)
>> @@ -122,11 +119,11 @@ def parse_kconfig_file(kfile, defined_features, referenced_features):
>>          elif REGEX_KCONFIG_HELP.match(line):
>>              skip = True
>>          elif skip:
>> -            # Ignore content of help messages
>> +            # ignore content of help messages
>>              pass
>>          elif REGEX_KCONFIG_STMT.match(line):
>>              features = get_features_in_line(line)
>> -            # Multi-line statements
>> +            # multi-line statements
>>              while line.endswith("\\"):
>>                  i += 1
>>                  line = lines[i]
>
>
> Paul Bolle
>
