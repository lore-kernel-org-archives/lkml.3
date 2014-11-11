Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaKKMPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:15:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57073 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaKKLJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Marek <mmarek@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 002/170] builddeb: put the dbg files into the correct directory
Date: Tue, 11 Nov 2014 11:06:01 +0000
Message-Id: <1415704129-12709-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Marek <mmarek@suse.cz>

commit 2d0871396995139b37f9ceb153c8b07589148343 upstream.

Since the conversion of objtree to use relative pathnames (commit
7e1c04779e, "kbuild: Use relative path for $(objtree)"), the debug
info files have been ending up in /debian/dbgtmp/ in the regular
linux-image package instead of the debug files package. Fix up the
paths so that the debug files end up in the -dbg package.

This is based on a similar patch by Darrick.

Reported-and-tested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 scripts/package/builddeb | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 35d5a5877d04..7c0e6e46905d 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -152,18 +152,16 @@ if grep -q '^CONFIG_MODULES=y' $KCONFIG_CONFIG ; then
 		rmdir "$tmpdir/lib/modules/$version"
 	fi
 	if [ -n "$BUILD_DEBUG" ] ; then
-		(
-			cd $tmpdir
-			for module in $(find lib/modules/ -name *.ko); do
-				mkdir -p $(dirname $dbg_dir/usr/lib/debug/$module)
-				# only keep debug symbols in the debug file
-				$OBJCOPY --only-keep-debug $module $dbg_dir/usr/lib/debug/$module
-				# strip original module from debug symbols
-				$OBJCOPY --strip-debug $module
-				# then add a link to those
-				$OBJCOPY --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $module
-			done
-		)
+		for module in $(find $tmpdir/lib/modules/ -name *.ko -printf '%P\n'); do
+			module=lib/modules/$module
+			mkdir -p $(dirname $dbg_dir/usr/lib/debug/$module)
+			# only keep debug symbols in the debug file
+			$OBJCOPY --only-keep-debug $tmpdir/$module $dbg_dir/usr/lib/debug/$module
+			# strip original module from debug symbols
+			$OBJCOPY --strip-debug $tmpdir/$module
+			# then add a link to those
+			$OBJCOPY --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $tmpdir/$module
+		done
 	fi
 fi
 
-- 
2.1.0

