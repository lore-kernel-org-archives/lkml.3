Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbaHZOFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:05:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbaHZOFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:05:38 -0400
From: Michal Marek <mmarek@suse.cz>
To: darrick.wong@oracle.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] builddeb: put the dbg files into the correct directory
Date: Tue, 26 Aug 2014 16:05:15 +0200
Message-Id: <1409061915-28137-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <20140822171000.GA10183@birch.djwong.org>
References: <20140822171000.GA10183@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the conversion of objtree to use relative pathnames (commit
7e1c04779e, "kbuild: Use relative path for $(objtree)"), the debug
info files have been ending up in /debian/dbgtmp/ in the regular
linux-image package instead of the debug files package. Fix up the
paths so that the debug files end up in the -dbg package.

This is based on a similar patch by Darrick.

Reported-and-tested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/package/builddeb | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 35d5a58..7c0e6e4 100644
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
1.8.4.5

