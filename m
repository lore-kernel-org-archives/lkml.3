Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaHSFte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:49:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47126 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaHSFtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:49:33 -0400
Date: Mon, 18 Aug 2014 22:49:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] builddeb: put the dbg files into the correct directory
Message-ID: <20140819054928.GO2808@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the conversion of objtree to use relative pathnames (commit
7e1c04779e, "kbuild: Use relative path for $(objtree)"), the debug
info files have been ending up in /debian/dbgtmp/ in the regular
linux-image package instead of the debug files package.  Fix up the
paths so that the debug files end up in the -dbg package.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scripts/package/builddeb |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 5707466..0456322 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -153,15 +153,16 @@ if grep -q '^CONFIG_MODULES=y' $KCONFIG_CONFIG ; then
 	fi
 	if [ -n "$BUILD_DEBUG" ] ; then
 		(
+			old_dir="$(pwd)"
 			cd $tmpdir
 			for module in $(find lib/modules/ -name *.ko); do
-				mkdir -p $(dirname $dbg_dir/usr/lib/debug/$module)
+				mkdir -p $(dirname $old_dir/$dbg_dir/usr/lib/debug/$module)
 				# only keep debug symbols in the debug file
-				$OBJCOPY --only-keep-debug $module $dbg_dir/usr/lib/debug/$module
+				$OBJCOPY --only-keep-debug $module $old_dir/$dbg_dir/usr/lib/debug/$module
 				# strip original module from debug symbols
 				$OBJCOPY --strip-debug $module
 				# then add a link to those
-				$OBJCOPY --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $module
+				$OBJCOPY --add-gnu-debuglink=$old_dir/$dbg_dir/usr/lib/debug/$module $module
 			done
 		)
 	fi
