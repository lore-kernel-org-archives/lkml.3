Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaCXCPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 22:15:48 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12623 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaCXCPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 22:15:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19JsXA/anFx7kA496oZY3yZBPdZ13Z98IU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 279CA54A085
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        Joe Perches <joe@perches.com>,
        "Yann E . MORIN" <yann.morin.1998@free.fr>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Subject: [PATCH V2] scripts: objdiff: detect object code changes between two commits
Date: Mon, 24 Mar 2014 02:14:48 +0000
Message-Id: <1395627288-19975-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.9.1
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

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
Changes from RFC:

 - separated from staging/skein series

 - assume 'HEAD^ HEAD' for 'objdiff diff' w/o args.

Original submission here:

  https://lkml.kernel.org/r/cc773270b6481ffe69516d994fbe98c13bcfdb5a.1394570067.git.jason@lakedaemon.net

Example usage here:

  https://lkml.kernel.org/r/20140312165501.GC7811@titan.lakedaemon.net

thx,

Jason.

 scripts/objdiff | 131 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100755 scripts/objdiff

diff --git a/scripts/objdiff b/scripts/objdiff
new file mode 100755
index 000000000000..c5d22b1814ba
--- /dev/null
+++ b/scripts/objdiff
@@ -0,0 +1,131 @@
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
+# And to clean up (everything is in /tmp/objdiff-*)
+# $ ./scripts/objdiff clean all
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
+	OBJDIFFD="/tmp/objdiff-$CMT"
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
+
+		# force rebuild
+		rm -f "$f"
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
+	SRCD="/tmp/objdiff-$SRC"
+	DSTD="/tmp/objdiff-$DST"
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
+		rm -rf /tmp/objdiff-*
+	else
+		CMT="`git rev-parse --short $1`"
+
+		if [ -d "/tmp/objdiff-$CMT" ]; then
+			rm -rf /tmp/objdiff-$CMT
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

