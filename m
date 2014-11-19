Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbaKSVEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:04:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbaKSVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3.17 131/141] builddeb: put the dbg files into the correct directory
Date: Wed, 19 Nov 2014 12:52:34 -0800
Message-Id: <20141119205155.191574226@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/package/builddeb |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -152,18 +152,16 @@ if grep -q '^CONFIG_MODULES=y' $KCONFIG_
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
 


