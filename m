Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaI1Pz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 11:55:58 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49623 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaI1Pz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 11:55:56 -0400
From: Valentin Rothberg <valentinrothberg@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: pebolle@tiscali.nl, Valentin Rothberg <valentinrothberg@gmail.com>,
        Stefan Hengelein <stefan.hengelein@fau.de>
Subject: [PATCH v7] checkkconfigsymbols.sh: reimplementation in python
Date: Sun, 28 Sep 2014 17:55:29 +0200
Message-Id: <1411919729-5800-1-git-send-email-valentinrothberg@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
References: <1411222524-7850-1-git-send-email-valentinrothberg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scripts/checkkconfigsymbols.sh script searches Kconfig features
in the source code that are not defined in Kconfig. Such identifiers
always evaluate to false and are the source of various kinds of bugs.
However, the shell script is slow and it does not detect such broken
references in Kbuild and Kconfig files (e.g., ``depends on UNDEFINED´´).
Furthermore, it generates false positives. The script is also hard to
read and understand, and is thereby difficult to maintain.

This patch replaces the shell script with an implementation in Python,
which:
    (a) detects the same bugs, but does not report previous false positives
    (b) additionally detects broken references in Kconfig and all
        non-Kconfig files, such as Kbuild, .[cSh], .txt, .sh, defconfig, etc.
    (c) is up to 75 times faster than the shell script
    (d) only checks files under version control ('git ls-files')

The new script reduces the runtime on my machine (i7-2620M, 8GB RAM, SSD)
from 3m47s to 0m3s, and reports 939 broken identifiers in Linux v3.17-rc1;
420 additional reports of which 16 are located in Kconfig files,
287 in defconfigs, 63 in ./Documentation, 1 in Kbuild.

Moreover, we intentionally include references in comments, which have been
ignored until now. Such comments may be leftovers of features that have
been removed or renamed in Kconfig (e.g., ``#endif /* CONFIG_MPC52xx */´´).
These references can be misleading and should be removed or replaced.

Note that the output format changed from (file list <tab> feature) to
(feature <tab> file list) as it simplifies the detection of the Kconfig
feature for long file lists.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
---
Changelog:
v2: Fix of regular expressions
v3: Changelog replacement, and add changes of v2
v4: Based on comments from Paul Bolle <pebolle@tiscali.nl>
  - Inclusion of all non-Kconfig files, such as .txt, .sh, etc.
  - Changes of regular expressions
  - Increases additional reports from 49 to 229 compared to v3
  - Change of output format from (file list <tab> feature) to
        (feature <tab> file list)·
v5: Only analyze files under version control ('git ls-files')
v6: Cover features with numbers and small letters (e.g., 4xx)
v7: Add changes of v6 (lost 'git add') and filter FOO/BAR features
---
 scripts/checkkconfigsymbols.py | 138 +++++++++++++++++++++++++++++++++++++++++
 scripts/checkkconfigsymbols.sh |  59 ------------------
 2 files changed, 138 insertions(+), 59 deletions(-)
 create mode 100644 scripts/checkkconfigsymbols.py
 delete mode 100755 scripts/checkkconfigsymbols.sh

diff --git a/scripts/checkkconfigsymbols.py b/scripts/checkkconfigsymbols.py
new file mode 100644
index 0000000..01bf9c4
--- /dev/null
+++ b/scripts/checkkconfigsymbols.py
@@ -0,0 +1,138 @@
+#!/usr/bin/env python
+
+"""Find Kconfig identifiers that are referenced but not defined."""
+
+# (c) 2014 Valentin Rothberg <valentinrothberg@gmail.com>
+# (c) 2014 Stefan Hengelein <stefan.hengelein@fau.de>
+#
+# Licensed under the terms of the GNU GPL License version 2
+
+
+import os
+import re
+from subprocess import Popen, PIPE, STDOUT
+
+
+# regex expressions
+OPERATORS = r"&|\(|\)|\||\!"
+FEATURE = r"(?:\w*[A-Z0-9]\w*){2,}"
+DEF = r"^\s*(?:menu){,1}config\s+(" + FEATURE + r")\s*"
+EXPR = r"(?:" + OPERATORS + r"|\s|" + FEATURE + r")+"
+STMT = r"^\s*(?:if|select|depends\s+on)\s+" + EXPR
+
+# regex objects
+REGEX_FILE_KCONFIG = re.compile(r".*Kconfig[\.\w+\-]*$")
+REGEX_FEATURE = re.compile(r"(" + FEATURE + r")")
+REGEX_SOURCE_FEATURE = re.compile(r"(?:D|\W|\b)+CONFIG_(" + FEATURE + r")")
+REGEX_KCONFIG_DEF = re.compile(DEF)
+REGEX_KCONFIG_EXPR = re.compile(EXPR)
+REGEX_KCONFIG_STMT = re.compile(STMT)
+REGEX_KCONFIG_HELP = re.compile(r"^\s+(help|---help---)\s*$")
+REGEX_FILTER_FEATURES = re.compile(r"[A-Za-z0-9]$")
+
+
+def main():
+    """Main function of this module."""
+    source_files = []
+    kconfig_files = []
+    defined_features = set()
+    referenced_features = dict()  # {feature: [files]}
+
+    # use 'git ls-files' to get the worklist
+    pop = Popen("git ls-files", stdout=PIPE, stderr=STDOUT, shell=True)
+    (stdout, _) = pop.communicate()  # wait until finished
+    if len(stdout) > 0 and stdout[-1] == "\n":
+        stdout = stdout[:-1]
+
+    for gitfile in stdout.rsplit("\n"):
+        if ".git" in gitfile or "ChangeLog" in gitfile or \
+                os.path.isdir(gitfile):
+            continue
+        if REGEX_FILE_KCONFIG.match(gitfile):
+            kconfig_files.append(gitfile)
+        else:
+            # all non-Kconfig files are checked for consistency
+            source_files.append(gitfile)
+
+    for sfile in source_files:
+        parse_source_file(sfile, referenced_features)
+
+    for kfile in kconfig_files:
+        parse_kconfig_file(kfile, defined_features, referenced_features)
+
+    print "Undefined symbol used\tFile list"
+    for feature in sorted(referenced_features):
+        # filter some false positives
+        if feature == "FOO" or feature == "BAR" or \
+                feature == "FOO_BAR":
+            continue
+        if feature not in defined_features:
+            if feature.endswith("_MODULE"):
+                # avoid false positives for kernel modules
+                if feature[:-len("_MODULE")] in defined_features:
+                    continue
+            files = referenced_features.get(feature)
+            print "%s\t%s" % (feature, ", ".join(files))
+
+
+def parse_source_file(sfile, referenced_features):
+    """Parse @sfile for referenced Kconfig features."""
+    lines = []
+    with open(sfile, "r") as stream:
+        lines = stream.readlines()
+
+    for line in lines:
+        if not "CONFIG_" in line:
+            continue
+        features = REGEX_SOURCE_FEATURE.findall(line)
+        for feature in features:
+            if not REGEX_FILTER_FEATURES.search(feature):
+                continue
+            sfiles = referenced_features.get(feature, set())
+            sfiles.add(sfile)
+            referenced_features[feature] = sfiles
+
+
+def get_features_in_line(line):
+    """Return mentioned Kconfig features in @line."""
+    return REGEX_FEATURE.findall(line)
+
+
+def parse_kconfig_file(kfile, defined_features, referenced_features):
+    """Parse @kfile and update feature definitions and references."""
+    lines = []
+    skip = False
+
+    with open(kfile, "r") as stream:
+        lines = stream.readlines()
+
+    for i in range(len(lines)):
+        line = lines[i]
+        line = line.strip('\n')
+        line = line.split("#")[0]  # ignore comments
+
+        if REGEX_KCONFIG_DEF.match(line):
+            feature_def = REGEX_KCONFIG_DEF.findall(line)
+            defined_features.add(feature_def[0])
+            skip = False
+        elif REGEX_KCONFIG_HELP.match(line):
+            skip = True
+        elif skip:
+            # ignore content of help messages
+            pass
+        elif REGEX_KCONFIG_STMT.match(line):
+            features = get_features_in_line(line)
+            # multi-line statements
+            while line.endswith("\\"):
+                i += 1
+                line = lines[i]
+                line = line.strip('\n')
+                features.extend(get_features_in_line(line))
+            for feature in set(features):
+                paths = referenced_features.get(feature, set())
+                paths.add(kfile)
+                referenced_features[feature] = paths
+
+
+if __name__ == "__main__":
+    main()
diff --git a/scripts/checkkconfigsymbols.sh b/scripts/checkkconfigsymbols.sh
deleted file mode 100755
index ccb3391..0000000
--- a/scripts/checkkconfigsymbols.sh
+++ /dev/null
@@ -1,59 +0,0 @@
-#!/bin/sh
-# Find Kconfig variables used in source code but never defined in Kconfig
-# Copyright (C) 2007, Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
-
-# Tested with dash.
-paths="$@"
-[ -z "$paths" ] && paths=.
-
-# Doing this once at the beginning saves a lot of time, on a cache-hot tree.
-Kconfigs="`find . -name 'Kconfig' -o -name 'Kconfig*[^~]'`"
-
-printf "File list \tundefined symbol used\n"
-find $paths -name '*.[chS]' -o -name 'Makefile' -o -name 'Makefile*[^~]'| while read i
-do
-	# Output the bare Kconfig variable and the filename; the _MODULE part at
-	# the end is not removed here (would need perl an not-hungry regexp for that).
-	sed -ne 's!^.*\<\(UML_\)\?CONFIG_\([0-9A-Za-z_]\+\).*!\2 '$i'!p' < $i
-done | \
-# Smart "sort|uniq" implemented in awk and tuned to collect the names of all
-# files which use a given symbol
-awk '{map[$1, count[$1]++] = $2; }
-END {
-	for (combIdx in map) {
-		split(combIdx, separate, SUBSEP);
-		# The value may have been removed.
-		if (! ( (separate[1], separate[2]) in map ) )
-			continue;
-		symb=separate[1];
-		printf "%s ", symb;
-		#Use gawk extension to delete the names vector
-		delete names;
-		#Portably delete the names vector
-		#split("", names);
-		for (i=0; i < count[symb]; i++) {
-			names[map[symb, i]] = 1;
-			# Unfortunately, we may still encounter symb, i in the
-			# outside iteration.
-			delete map[symb, i];
-		}
-		i=0;
-		for (name in names) {
-			if (i > 0)
-				printf ", %s", name;
-			else
-				printf "%s", name;
-			i++;
-		}
-		printf "\n";
-	}
-}' |
-while read symb files; do
-	# Remove the _MODULE suffix when checking the variable name. This should
-	# be done only on tristate symbols, actually, but Kconfig parsing is
-	# beyond the purpose of this script.
-	symb_bare=`echo $symb | sed -e 's/_MODULE//'`
-	if ! grep -q "\<$symb_bare\>" $Kconfigs; then
-		printf "$files: \t$symb\n"
-	fi
-done|sort
--
1.9.3

