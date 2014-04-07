Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbaDGSa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:30:56 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14344 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755433AbaDGSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:30:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/KR+co+x8m+PeQFRrYKfeFnnljDL5I/JI=
X-DKIM: OpenDKIM Filter v2.0.1 titan AF3675540A3
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        Joe Perches <joe@perches.com>,
        "Yann E . MORIN" <yann.morin.1998@free.fr>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH V3] scripts: objdiff: detect object code changes between two commits
Date: Mon,  7 Apr 2014 18:30:29 +0000
Message-Id: <1396895429-27425-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395627288-19975-1-git-send-email-jason@lakedaemon.net>
References: <1395627288-19975-1-git-send-email-jason@lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

objdiff is useful when doing large code cleanups.  For example, when
removing checkpatch warnings and errors from new drivers in the staging
tree.

objdiff can be used in conjunction with a git rebase to confirm that
each commit made no changes to the resulting object code.  It has the
same return values as diff(1).

This was written specifically to support adding the skein and threefish
cryto drivers to the staging tree.  I needed a programmatic way to
confirm that commits changing >90% of the lines didn't inadvertently
change the code.

Temporary files (objdump output) are stored in

  /path/to/linux/.tmp_objdiff

'make mrproper' will remove this directory.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
Changes from V2:

 - use /path/to/linux/.tmp_objdiff instead of /tmp/objdiff (Michal Marek)

 - don't delete object files during record (Michal Marek)

 - remove .tmp_objdiff directory during 'make mrproper' (Michal Marek)

Changes from RFC:

 - separated from staging/skein series

 - assume 'HEAD^ HEAD' for 'objdiff diff' w/o args.

Original submission here:

  https://lkml.kernel.org/r/cc773270b6481ffe69516d994fbe98c13bcfdb5a.1394570067.git.jason@lakedaemon.net

Example usage here:

  https://lkml.kernel.org/r/20140312165501.GC7811@titan.lakedaemon.net

thx,

Jason.


 Makefile        |   2 +-
 scripts/objdiff | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100755 scripts/objdiff

diff --git a/Makefile b/Makefile
index 606ef7c4a544..6cf18007f9aa 100644
--- a/Makefile
+++ b/Makefile
@@ -1065,7 +1065,7 @@ CLEAN_DIRS  += $(MODVERDIR)
 
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config usr/include include/generated          \
-                  arch/*/include/generated
+                  arch/*/include/generated .tmp_objdiff
 MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
diff --git a/scripts/objdiff b/scripts/objdiff
new file mode 100755
index 000000000000..b3e4f10bfc3e
--- /dev/null
+++ b/scripts/objdiff
@@ -0,0 +1,141 @@
+#!/bin/bash
+
+# objdiff - a small script for validating that a commit or series of commits
+# didn't change object code.
+#
+# Copyright 2014, Jason Cooper <jason@lakedaemon.net>
+#
+# Licensed under the terms of the GNU GPL version 2
+
+# usage example:
+#
+# $ git checkout COMMIT_A
+# $ <your fancy build command here>
+# $ ./scripts/objdiff record path/to/*.o
+#
+# $ git checkout COMMIT_B
+# $ <your fancy build command here>
+# $ ./scripts/objdiff record path/to/*.o
+#
+# $ ./scripts/objdiff diff COMMIT_A COMMIT_B
+# $
+
+# And to clean up (everything is in .tmp_objdiff/*)
+# $ ./scripts/objdiff clean all
+#
+# Note: 'make mrproper' will also remove .tmp_objdiff
+
+GIT_DIR="`git rev-parse --git-dir`"
+
+if [ -d "$GIT_DIR" ]; then
+	TMPD="${GIT_DIR%git}tmp_objdiff"
+
+	[ -d "$TMPD" ] || mkdir "$TMPD"
+else
+	echo "ERROR: git directory not found."
+	exit 1
+fi
+
+usage() {
+	echo "Usage: $0 <command> <args>"
+	echo "  record    <list of object files>"
+	echo "  diff      <commitA> <commitB>"
+	echo "  clean     all | <commit>"
+	exit 1
+}
+
+dorecord() {
+	[ $# -eq 0 ] && usage
+
+	FILES="$*"
+
+	CMT="`git rev-parse --short HEAD`"
+
+	OBJDUMP="${CROSS_COMPILE}objdump"
+	OBJDIFFD="$TMPD/$CMT"
+
+	[ ! -d "$OBJDIFFD" ] && mkdir -p "$OBJDIFFD"
+
+	for f in $FILES; do
+		dn="${f%/*}"
+		bn="${f##*/}"
+
+		[ ! -d "$OBJDIFFD/$dn" ] && mkdir -p "$OBJDIFFD/$dn"
+
+		# remove addresses for a more clear diff
+		# http://dummdida.tumblr.com/post/60924060451/binary-diff-between-libc-from-scientificlinux-and
+		$OBJDUMP -D "$f" | sed "s/^[[:space:]]\+[0-9a-f]\+//" \
+			>"$OBJDIFFD/$dn/$bn"
+	done
+}
+
+dodiff() {
+	[ $# -ne 2 ] && [ $# -ne 0 ] && usage
+
+	if [ $# -eq 0 ]; then
+		SRC="`git rev-parse --short HEAD^`"
+		DST="`git rev-parse --short HEAD`"
+	else
+		SRC="`git rev-parse --short $1`"
+		DST="`git rev-parse --short $2`"
+	fi
+
+	DIFF="`which colordiff`"
+
+	if [ ${#DIFF} -eq 0 ] || [ ! -x "$DIFF" ]; then
+		DIFF="`which diff`"
+	fi
+
+	SRCD="$TMPD/$SRC"
+	DSTD="$TMPD/$DST"
+
+	if [ ! -d "$SRCD" ]; then
+		echo "ERROR: $SRCD doesn't exist"
+		exit 1
+	fi
+
+	if [ ! -d "$DSTD" ]; then
+		echo "ERROR: $DSTD doesn't exist"
+		exit 1
+	fi
+
+	$DIFF -Nurd $SRCD $DSTD
+}
+
+doclean() {
+	[ $# -eq 0 ] && usage
+	[ $# -gt 1 ] && usage
+
+	if [ "x$1" = "xall" ]; then
+		rm -rf $TMPD/*
+	else
+		CMT="`git rev-parse --short $1`"
+
+		if [ -d "$TMPD/$CMT" ]; then
+			rm -rf $TMPD/$CMT
+		else
+			echo "$CMT not found"
+		fi
+	fi
+}
+
+[ $# -eq 0 ] &&	usage
+
+case "$1" in
+	record)
+		shift
+		dorecord $*
+		;;
+	diff)
+		shift
+		dodiff $*
+		;;
+	clean)
+		shift
+		doclean $*
+		;;
+	*)
+		echo "Unrecognized command '$1'"
+		exit 1
+		;;
+esac
-- 
1.9.1

