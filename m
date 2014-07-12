Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaGLBVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 21:21:34 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:60840 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753170AbaGLBVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 21:21:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2194:2197:2198:2199:2200:2201:2393:2538:2559:2562:2828:2898:2915:3138:3139:3140:3141:3142:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4117:4321:5007:6119:7652:7875:7903:8531:8957:9040:10004:10026:10848:11026:11658:11914:12043:12114:12291:12296:12438:12517:12519:12555:12683:13019:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:
X-HE-Tag: side53_d0a3a46ade5d
X-Filterd-Recvd-Size: 6262
Message-ID: <1405128087.6751.12.camel@joe-AO725>
Subject: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 11 Jul 2014 18:21:27 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple script to run checkpatch --fix for various types of
of cleanups.

This script is useful primarily for staging.

This reformats code to a more CodingStyle conforming style,
compiles it, verifies that the object code hasn't changed,
and git commits it too.

You must have the necessary development tools, git, and a
recent git tree.  Ideally use Greg KH's staging-next, which
can be retrieved via these commands:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
git checkout staging-next

To use this script try a sequence of commands like:

	cd <linux_repository>
	git checkout -b <your_branch>
	make allyesconfig
	mkdir patches
	./scripts/reformat_with_checkpatch.sh drivers/staging/<dir>/*.[ch]
	git format-patch --cover-letter -o patches/<your_branch> staging-next
	git send-email patches/<your_branch>

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/reformat_with_checkpatch.sh | 141 ++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)
 create mode 100755 scripts/reformat_with_checkpatch.sh

diff --git a/scripts/reformat_with_checkpatch.sh b/scripts/reformat_with_checkpatch.sh
new file mode 100755
index 0000000..5415a8e
--- /dev/null
+++ b/scripts/reformat_with_checkpatch.sh
@@ -0,0 +1,141 @@
+#!/bin/bash
+# (c) 2014, Joe Perches <joe@perches.com>
+#
+# Automate checkpatch modifications and git commits to
+# neaten code that doesn't conform to CodingStyle.
+# Useful primarily for files in drivers/staging
+#
+# Licensed under the terms of the GNU GPL License version 2
+
+declare -ar whitespace_types=(	\
+    'whitespace_neatening:spacing,space_before_tab,pointer_location,trailing_whitespace,bracket_space'	\
+    'remove_spaces_before_tabs:space_before_tab'		\
+    'fix_label_positions:indented_label'		\
+    'align_arguments_to_parenthesis:parenthesis_alignment'	\
+)
+
+declare -ar changecode_types=(	\
+    'fix_brace_positions:open_brace,braces,else_after_brace,while_after_brace'		\
+    'fix_blank_lines:line_spacing'		\
+    'use_standard_attributes:prefer_packed,prefer_aligned'		\
+    'remove_unnecessary_externs:avoid_externs'		\
+    'update_c90_comment_style:c99_comments'		\
+)
+
+checkpatch_update ()
+{
+    file=$1
+
+    desc=$(echo $2 | cut -f1 -d: | sed 's/_/ /g')
+    types=$(echo $2 | cut -f2- -d:)
+
+    echo "file: <$file> description: <$desc> types:<$types>"
+
+    ./scripts/checkpatch.pl --file --fix-inplace --strict --types="$types" $file
+
+    checkpatch_fixes=$file.diff
+    git diff --stat -p --exit-code $file > $checkpatch_fixes
+    if [ $? == 0 ] ; then
+	rm -f $checkpatch_fixes
+	return
+    fi
+
+    basename=$(basename $file)
+    if [ "${basename##*.}" == "c" ] ; then
+
+	git checkout $file
+	obj="$(echo $file | sed 's/\.c$/\.o/')"
+	if [ -e $obj ] ; then
+	    rm -f $obj
+	fi
+
+	echo "Compiling original version..."
+
+	${CROSS_COMPILE}make $obj
+
+	${CROSS_COMPILE}objdump -D $obj | \
+	    sed "s/^[[:space:]]\+[0-9a-f]\+//" > $obj.old
+
+	patch -p1 < $checkpatch_fixes
+
+	echo "Compiling modified version..."
+
+	${CROSS_COMPILE}make $obj
+
+	${CROSS_COMPILE}objdump -D $obj | \
+	    sed "s/^[[:space:]]\+[0-9a-f]\+//" > $obj.new
+
+	echo "Comparing objects..."
+	diff -Nurd $obj.new $obj.old
+	if [ $? -ne 0 ] ; then
+	    echo "Object differences exist! - Verify changes before commit!"
+	    read -s -p "Press the 'enter' key to continue: "
+	else
+	    echo "No object differences found"
+	fi
+	rm -f $obj.old
+	rm -f $obj.new
+    fi
+
+    echo "running checkpatch on possible checkpatch fixes..."
+
+    ./scripts/checkpatch.pl --no-summary --no-signoff $checkpatch_fixes
+    rm -f $checkpatch_fixes
+
+    echo "Verify checkpatch output and make any necessary changes"
+    echo "Edit '$file' if appropriate"
+    read -s -p "Press the 'enter' key to continue: "
+
+    commit_log_file=$(mktemp git_commit.XXXXXX)
+
+    if [ -e $commit_log_file ] ; then
+	rm -f $commit_log_file
+    fi
+
+    if [[ $file =~ ^drivers/staging/ ]] ; then
+	echo -n "staging: " >> $commit_log_file
+    fi
+    echo "$(basename $(dirname $file)): checkpatch cleanup: $desc" >> $commit_log_file
+    echo "" >> $commit_log_file
+    git diff --exit-code -w $file > /dev/null
+    if [ $? == 0 ] ; then
+	echo "whitespace changes only - git diff -w shows no difference" >> $commit_log_file
+    fi
+
+    git diff $file | cat
+
+    echo "Ready to commit - First verify all diffs and make any necessary changes"
+    echo ""
+    read -r -p "Would you like to commit these changes <y>: " response
+    response=${response,,}
+    if [[ $response =~ ^(yes|y|)$ ]] ; then
+	git commit -s -F $commit_log_file -e $file
+    else
+	git checkout $file
+    fi
+
+    rm -f $commit_log_file
+}
+
+which git > /dev/null
+if [ $? -ne 0 ] || [ ! -e .git ] ; then
+    echo "git or git directory not found - run this from the top of the source tree"
+    exit 1
+fi
+
+for file in "$@" ; do
+
+    if [ ! -f $file ] ; then 
+	echo "Argument '$file' is not a file"
+	continue
+    fi
+
+    for type in "${whitespace_types[@]}" ; do
+	checkpatch_update $file $type
+    done
+
+    for type in "${changecode_types[@]}" ; do
+	checkpatch_update $file $type
+    done
+
+done
-- 
1.8.1.2.459.gbcd45b4.dirty



