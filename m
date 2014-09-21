Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaIUV3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 17:29:04 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60676 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbaIUV3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 17:29:02 -0400
Message-ID: <1411334939.6049.30.camel@x41>
Subject: Re: [PATCH v3] checkkconfigsymbols.sh: reimplementation in python
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stefan.hengelein@fau.de
Date: Sun, 21 Sep 2014 23:28:59 +0200
In-Reply-To: <1411329197-15102-1-git-send-email-valentinrothberg@gmail.com>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
	 <1411329197-15102-1-git-send-email-valentinrothberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Sep 2014 21:28:59.0833 (UTC) FILETIME=[0EB8FA90:01CFD5E3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valentin Rothberg schreef op zo 21-09-2014 om 21:53 [+0200]:
> The scripts/checkkconfigsymbols.sh script searches Kconfig features
> in the source code that are not defined in Kconfig. Such identifiers
> always evaluate to false and are the source of various kinds of bugs.
> However, the shell script is slow and it does not detect such broken
> references in Kbuild and Kconfig files (e.g., ``depends on UNDEFINED´´).
> Furthermore, it generates false positives (4 of 526 in v3.17-rc1).

Curiosity: what are those four false positives?

> The script is also hard to read and understand, and is thereby difficult
> to maintain.
> 
> This patch replaces the shell script with an implementation in Python,
> which:
>     (a) detects the same bugs, but does not report false positives

Depends a bit on the definition of false positives. Ie, the hit for
    ./arch/sh/kernel/head_64.S:	CACHE_

is caused by
     #error preprocessor flag CONFIG_CACHE_... not recognized!

Should that line, and similar lines, be changed?

>     (b) additionally detects broken references in Kconfig and Kbuild files
>     (c) is up to 75 times faster than the shell script
> 
> The new script reduces the runtime on my machine (i7-2620M, 8GB RAM, SSD)
> from 3m47s to 0m3s, and reports 570 broken references in Linux v3.17-rc1;
> 49 additional reports of which 16 are located in Kconfig files.
> 
> Moreover, we intentionally include references in C comments, which have been
> ignored until now. Such comments may be leftovers of features that have
> been removed or renamed in Kconfig (e.g., ``#endif /* CONFIG_MPC52xx */´´).
> These references can be misleading and should be removed or replaced.

Yes, that's a good idea.

> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
> ---
> Changelog:
> v2: Fix of regural expressions
> v3: Changelog replacement, and add changes of v2
> ---
>  scripts/checkkconfigsymbols.py | 131 +++++++++++++++++++++++++++++++++++++++++
>  scripts/checkkconfigsymbols.sh |  59 -------------------
>  2 files changed, 131 insertions(+), 59 deletions(-)
>  create mode 100644 scripts/checkkconfigsymbols.py
>  delete mode 100755 scripts/checkkconfigsymbols.sh
> 
> diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
> new file mode 100644
> index 0000000..5c51dd1
> --- /dev/null
> +++ b/scripts/checkkconfigsymbols.py
> @@ -0,0 +1,131 @@
> +#!/usr/bin/env python
> +
> +"""Find Kconfig identifieres that are referenced but not defined."""
> +
> +# Copyright (C) 2014 Valentin Rothberg <valentinrothberg@gmail.com>
> +# Copyright (C) 2014 Stefan Hengelein <stefan.hengelein@fau.de>
> +#
> +# This program is free software; you can redistribute it and/or modify it
> +# under the terms and conditions of the GNU General Public License,
> +# version 2, as published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope it will be useful, but WITHOUT
> +# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> +# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
> +# more details.
> +
> +
> +import os
> +import re
> +
> +
> +# REGEX EXPRESSIONS
> +OPERATORS = r"&|\(|\)|\||\!"
> +FEATURE = r"\w*[A-Z]{1}\w*"
> +FEATURE_DEF = r"^\s*(menu){,1}config\s+" + FEATURE + r"\s*"
> +EXPR = r"(" + OPERATORS + r"|\s|" + FEATURE + r")*"
> +STMT = r"^\s*(if|select|depends\s+on)\s+" + EXPR

                          "depends on" with multiple spaces?
> +
> +# REGEX OBJECTS
> +REGEX_FILE_KCONFIG = re.compile(r"Kconfig[\.\w+\-]*$")
> +REGEX_FILE_SOURCE = re.compile(r"\.[cSh]$")
> +REGEX_FILE_MAKE = re.compile(r"Makefile|Kbuild[\.\w+]*$")
> +REGEX_FEATURE = re.compile(r"(" + FEATURE + r")")
> +REGEX_FEATURE_DEF = re.compile(FEATURE_DEF)
> +REGEX_CPP_FEATURE = re.compile(r"\W+CONFIG_(" + FEATURE + r")[.]*")

There are a few uses of "-DCONFIG_[...]" in Makefiles. This will miss
those, won't it? That's not bad, per se, but a comment why you're
skipping those might be nice. Or are those caught too, somewhere else?

> +REGEX_KCONFIG_EXPR = re.compile(EXPR)
> +REGEX_KCONFIG_STMT = re.compile(STMT)
> +REGEX_KCONFIG_HELP = re.compile(r"^[\s|-]*help[\s|-]*")

Won't "^\s\+(---help---|help)$" do? Might help catch creative variants
of the help statement (we had a few in the past).

> +
> +
> +def main():
> +    """Main function of this module."""
> +    output = []
> +    source_files = []
> +    kconfig_files = []
> +    defined_features = set()
> +    referenced_features = dict()
> +
> +    for root, _, files in os.walk("."):

Does this descend into the .git directory?

> +        for fil in files:
> +            if REGEX_FILE_KCONFIG.match(fil):
> +                kconfig_files.append(os.path.join(root, fil))
> +            elif REGEX_FILE_SOURCE.search(fil) or REGEX_FILE_MAKE.match(fil):
> +                source_files.append(os.path.join(root, fil))
> +
> +    for kfile in kconfig_files:
> +        parse_kconfig_file(kfile, defined_features, referenced_features)
> +
> +    for sfile in source_files:
> +        parse_source_file(sfile, referenced_features)
> +
> +    print "File list\tundefined symbol used"
> +    for feature in referenced_features:
> +        if feature not in defined_features:
> +            files = referenced_features.get(feature)
> +            output.append("%s:\t%s" % (", ".join(files), feature))
> +    for out in sorted(output):
> +        print out
> +
> +
> +def parse_source_file(sfile, referenced_features):
> +    """Parse @sfile for referenced Kconfig features."""
> +    lines = []
> +    with open(sfile, "r") as stream:
> +        lines = stream.readlines()
> +
> +    for line in lines:
> +        if not "CONFIG_" in line:
> +            continue
> +        features = REGEX_CPP_FEATURE.findall(line)
> +        for feature in features:
> +            if feature.endswith("_MODULE"):
> +                feature = feature[:-len("_MODULE")]

Uses of CONFIG_FOO_MODULE are now reported as uses of CONFIG_FOO. That
might be confusing. 

> +            paths = referenced_features.get(feature, set())
> +            paths.add(sfile)
> +            referenced_features[feature] = paths
> +
> +
> +def get_features_in_line(line):
> +    """Return mentioned kconfig features in @line."""
> +    return REGEX_FEATURE.findall(line)
> +
> +
> +def parse_kconfig_file(kfile, defined_features, referenced_features):
> +    """Parse @kfile and update feature definitions and references."""
> +    lines = []
> +    skip = False
> +
> +    with open(kfile, "r") as stream:
> +        lines = stream.readlines()
> +
> +    for i in range(len(lines)):
> +        line = lines[i]
> +        line = line.strip('\n')
> +        line = line.split("#")[0]  # Ignore right side of comments
> +
> +        if REGEX_FEATURE_DEF.match(line):
> +            feature_def = REGEX_FEATURE.findall(line)
> +            defined_features.add(feature_def[0])
> +            skip = False
> +        elif REGEX_KCONFIG_HELP.match(line):
> +            skip = True
> +        elif skip:
> +            # Ignore content of help messages
> +            pass
> +        elif REGEX_KCONFIG_STMT.match(line):
> +            features = get_features_in_line(line)
> +            # Multi-line statements
> +            while line.endswith("\\"):
> +                i += 1
> +                line = lines[i]
> +                line = line.strip('\n')
> +                features.extend(get_features_in_line(line))
> +            for feature in set(features):
> +                paths = referenced_features.get(feature, set())
> +                paths.add(kfile)
> +                referenced_features[feature] = paths
> +
> +
> +if __name__ == "__main__":
> +    main()
> diff --git a/scripts/checkkconfigsymbols.sh b/scripts/checkkconfigsymbols.sh
> deleted file mode 100755
> index ccb3391..0000000
> --- a/scripts/checkkconfigsymbols.sh
> +++ /dev/null
>[...]

Suggestion for future work: make this git aware. Ie, make things like
    python scripts/checkkconfigsymbols.py v3.17-rc5
    python scripts/checkkconfigsymbols.py next-20140919
    python scripts/checkkconfigsymbols.py $SHA1SUM

produce useful output.


Paul Bolle

