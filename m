Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaI2K2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:28:49 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57629 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429AbaI2K2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:28:48 -0400
Message-ID: <1411986525.6334.32.camel@x220>
Subject: Re: [PATCH v7] checkkconfigsymbols.sh: reimplementation in python
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: akpm@linux-foundation.org, Stefan Hengelein <stefan.hengelein@fau.de>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Sep 2014 12:28:45 +0200
In-Reply-To: <1411919729-5800-1-git-send-email-valentinrothberg@gmail.com>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
	 <1411919729-5800-1-git-send-email-valentinrothberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Sep 2014 10:28:45.0494 (UTC) FILETIME=[260A8D60:01CFDBD0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added  linux-kbuild@vger.kernel.org.]

On Sun, 2014-09-28 at 17:55 +0200, Valentin Rothberg wrote:
> The scripts/checkkconfigsymbols.sh script searches Kconfig features
> in the source code that are not defined in Kconfig. Such identifiers
> always evaluate to false and are the source of various kinds of bugs.
> However, the shell script is slow and it does not detect such broken
> references in Kbuild and Kconfig files (e.g., ``depends on UNDEFINED´´).
> Furthermore, it generates false positives. The script is also hard to
> read and understand, and is thereby difficult to maintain.
> 
> This patch replaces the shell script with an implementation in Python,
> which:
>     (a) detects the same bugs, but does not report previous false positives
>     (b) additionally detects broken references in Kconfig and all
>         non-Kconfig files, such as Kbuild, .[cSh], .txt, .sh, defconfig, etc.
>     (c) is up to 75 times faster than the shell script
>     (d) only checks files under version control ('git ls-files')

(The shell script is .git unaware. If you happen to have one or more
branches with "Kconfig" in their name, as I do, it generates a lot of
noise on stderr.)

> The new script reduces the runtime on my machine (i7-2620M, 8GB RAM, SSD)
> from 3m47s to 0m3s, and reports 939 broken identifiers in Linux v3.17-rc1;
> 420 additional reports of which 16 are located in Kconfig files,
> 287 in defconfigs, 63 in ./Documentation, 1 in Kbuild.
> 
> Moreover, we intentionally include references in comments, which have been
> ignored until now. Such comments may be leftovers of features that have
> been removed or renamed in Kconfig (e.g., ``#endif /* CONFIG_MPC52xx */´´).
> These references can be misleading and should be removed or replaced.
> 
> Note that the output format changed from (file list <tab> feature) to
> (feature <tab> file list) as it simplifies the detection of the Kconfig
> feature for long file lists.
> 
> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
> ---
> Changelog:
> v2: Fix of regular expressions
> v3: Changelog replacement, and add changes of v2
> v4: Based on comments from Paul Bolle <pebolle@tiscali.nl>
>   - Inclusion of all non-Kconfig files, such as .txt, .sh, etc.
>   - Changes of regular expressions
>   - Increases additional reports from 49 to 229 compared to v3
>   - Change of output format from (file list <tab> feature) to
>         (feature <tab> file list)·
> v5: Only analyze files under version control ('git ls-files')
> v6: Cover features with numbers and small letters (e.g., 4xx)
> v7: Add changes of v6 (lost 'git add') and filter FOO/BAR features
> ---
>  scripts/checkkconfigsymbols.py | 138 +++++++++++++++++++++++++++++++++++++++++
>  scripts/checkkconfigsymbols.sh |  59 ------------------
>  2 files changed, 138 insertions(+), 59 deletions(-)
>  create mode 100644 scripts/checkkconfigsymbols.py
>  delete mode 100755 scripts/checkkconfigsymbols.sh
> 
> diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
> new file mode 100644
> index 0000000..01bf9c4
> --- /dev/null
> +++ b/scripts/checkkconfigsymbols.py
> @@ -0,0 +1,138 @@
> +#!/usr/bin/env python
> +
> +"""Find Kconfig identifiers that are referenced but not defined."""
> +
> +# (c) 2014 Valentin Rothberg <valentinrothberg@gmail.com>
> +# (c) 2014 Stefan Hengelein <stefan.hengelein@fau.de>
> +#
> +# Licensed under the terms of the GNU GPL License version 2
> +
> +
> +import os
> +import re
> +from subprocess import Popen, PIPE, STDOUT
> +
> +
> +# regex expressions
> +OPERATORS = r"&|\(|\)|\||\!"
> +FEATURE = r"(?:\w*[A-Z0-9]\w*){2,}"
> +DEF = r"^\s*(?:menu){,1}config\s+(" + FEATURE + r")\s*"
> +EXPR = r"(?:" + OPERATORS + r"|\s|" + FEATURE + r")+"
> +STMT = r"^\s*(?:if|select|depends\s+on)\s+" + EXPR

Could please make that "depends on"? Yes, it seems the yacc grammar
accepts any amount of whitespace, but that doesn't make it right to use
anything other than a single space. (Can the yacc grammar be tweaked to
see "depends on" as one, well, token?)

> +
> +# regex objects
> +REGEX_FILE_KCONFIG = re.compile(r".*Kconfig[\.\w+\-]*$")
> +REGEX_FEATURE = re.compile(r"(" + FEATURE + r")")
> +REGEX_SOURCE_FEATURE = re.compile(r"(?:D|\W|\b)+CONFIG_(" + FEATURE + r")")

That should be "-D", because now you get a hit on
    TPS6507X_ADCONFIG_CONVERT_TS

and friends. What does \W do, by the way?

> +REGEX_KCONFIG_DEF = re.compile(DEF)
> +REGEX_KCONFIG_EXPR = re.compile(EXPR)
> +REGEX_KCONFIG_STMT = re.compile(STMT)
> +REGEX_KCONFIG_HELP = re.compile(r"^\s+(help|---help---)\s*$")
> +REGEX_FILTER_FEATURES = re.compile(r"[A-Za-z0-9]$")
> +
> +
> +def main():
> +    """Main function of this module."""
> +    source_files = []
> +    kconfig_files = []
> +    defined_features = set()
> +    referenced_features = dict()  # {feature: [files]}
> +
> +    # use 'git ls-files' to get the worklist
> +    pop = Popen("git ls-files", stdout=PIPE, stderr=STDOUT, shell=True)
> +    (stdout, _) = pop.communicate()  # wait until finished
> +    if len(stdout) > 0 and stdout[-1] == "\n":
> +        stdout = stdout[:-1]
> +
> +    for gitfile in stdout.rsplit("\n"):
> +        if ".git" in gitfile or "ChangeLog" in gitfile or \
> +                os.path.isdir(gitfile):

(The only directories in the git tree are a few symlinks:
    arch/arm/boot/dts/include/dt-bindings
    arch/metag/boot/dts/include/dt-bindings
    arch/mips/boot/dts/include/dt-bindings
    arch/powerpc/boot/dts/include/dt-bindings

Filtering out symlinks makes sense anyway. But that's probably not worth
the effort.)

You might also consider filtering out "Next/merge.log". It tends to have
references to Kconfig macros. But it's only a few hits anyway.

> +            continue
> +        if REGEX_FILE_KCONFIG.match(gitfile):
> +            kconfig_files.append(gitfile)
> +        else:
> +            # all non-Kconfig files are checked for consistency
> +            source_files.append(gitfile)
> +
> +    for sfile in source_files:
> +        parse_source_file(sfile, referenced_features)
> +
> +    for kfile in kconfig_files:
> +        parse_kconfig_file(kfile, defined_features, referenced_features)
> +
> +    print "Undefined symbol used\tFile list"
> +    for feature in sorted(referenced_features):
> +        # filter some false positives
> +        if feature == "FOO" or feature == "BAR" or \
> +                feature == "FOO_BAR":
> +            continue
> +        if feature not in defined_features:
> +            if feature.endswith("_MODULE"):
> +                # avoid false positives for kernel modules
> +                if feature[:-len("_MODULE")] in defined_features:
> +                    continue
> +            files = referenced_features.get(feature)
> +            print "%s\t%s" % (feature, ", ".join(files))
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
> +        features = REGEX_SOURCE_FEATURE.findall(line)
> +        for feature in features:
> +            if not REGEX_FILTER_FEATURES.search(feature):
> +                continue
> +            sfiles = referenced_features.get(feature, set())
> +            sfiles.add(sfile)
> +            referenced_features[feature] = sfiles
> +
> +
> +def get_features_in_line(line):
> +    """Return mentioned Kconfig features in @line."""
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
> +        line = line.split("#")[0]  # ignore comments
> +
> +        if REGEX_KCONFIG_DEF.match(line):
> +            feature_def = REGEX_KCONFIG_DEF.findall(line)
> +            defined_features.add(feature_def[0])
> +            skip = False
> +        elif REGEX_KCONFIG_HELP.match(line):
> +            skip = True
> +        elif skip:
> +            # ignore content of help messages
> +            pass
> +        elif REGEX_KCONFIG_STMT.match(line):
> +            features = get_features_in_line(line)
> +            # multi-line statements
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
>[...]

This seems to find, roughly, what my local perl script finds. It does
skip references to Kconfig macros in the Kconfig help texts and
comments: grep for CONFIG_ITANIUM_ASTEP_SPECIFIC as an example. But
there are so few of those that it's probable not worth the trouble to
check for them too.

A few test show the speedup is especially nice with the entire tree in
cache: run time drops from over four minutes to just under five seconds
here. Provided you look into my comments, this is:

Acked-by: Paul Bolle <pebolle@tiscali.nl>

Thanks,


Paul Bolle

