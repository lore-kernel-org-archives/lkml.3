Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937407Ab3DIKGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:06:15 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53201 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935693Ab3DIKGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:06:13 -0400
Date: Tue, 9 Apr 2013 12:05:47 +0200
From: Anisse Astier <anisse@astier.eu>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH 1/2] deb-pkg: split debug symbols in their own package
Message-ID: <20130409120547.64ad0d50@serenity>
In-Reply-To: <20130408190645.29570fe5@serenity>
References: <1363946761-7449-1-git-send-email-anisse@astier.eu>
	<51629BFF.1080204@suse.cz>
	<20130408190645.29570fe5@serenity>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Anisse Astier <anisse@astier.eu>
Subject: [PATCH v3] deb-pkg: split debug symbols in their own package

This can reduce almost 3 times the size of the linux-image package,
while keeping the debug symbols available for this particular build, in
their own package.

This mimics the way kernels are built in debian, ubuntu, or with
make-kpkg, and comes at the price of a small slowdown in the building of
packages.

v2:
 - only build when CONFIG_DEBUG_INFO=y
 - build debug package last.
 - more verbose package description
 - put package in section debug
v3:
 - remove duplicate code from v2

Signed-off-by: Anisse Astier <anisse@astier.eu>
---

Sorry for the mixup, there were duplicate mkdir declaration due to moving
code around.


---
 scripts/package/builddeb | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index acb8650..65ff0a4 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -78,17 +78,21 @@ tmpdir="$objtree/debian/tmp"
 fwdir="$objtree/debian/fwtmp"
 kernel_headers_dir="$objtree/debian/hdrtmp"
 libc_headers_dir="$objtree/debian/headertmp"
+dbg_dir="$objtree/debian/dbgtmp"
 packagename=linux-image-$version
 fwpackagename=linux-firmware-image
 kernel_headers_packagename=linux-headers-$version
 libc_headers_packagename=linux-libc-dev
+dbg_packagename=$packagename-dbg
 
 if [ "$ARCH" = "um" ] ; then
 	packagename=user-mode-linux-$version
 fi
 
+BUILD_DEBUG="$(grep -s '^CONFIG_DEBUG_INFO=y' .config || true)"
+
 # Setup the directory structure
-rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir"
+rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir" "$libc_headers_dir" "$dbg_dir"
 mkdir -m 755 -p "$tmpdir/DEBIAN"
 mkdir -p  "$tmpdir/lib" "$tmpdir/boot" "$tmpdir/usr/share/doc/$packagename"
 mkdir -m 755 -p "$fwdir/DEBIAN"
@@ -101,6 +105,10 @@ mkdir -p "$kernel_headers_dir/lib/modules/$version/"
 if [ "$ARCH" = "um" ] ; then
 	mkdir -p "$tmpdir/usr/lib/uml/modules/$version" "$tmpdir/usr/bin"
 fi
+if [ -n "$BUILD_DEBUG" ] ; then
+	mkdir -p "$dbg_dir/usr/share/doc/$dbg_packagename"
+	mkdir -m 755 -p "$dbg_dir/DEBIAN"
+fi
 
 # Build and install the kernel
 if [ "$ARCH" = "um" ] ; then
@@ -128,6 +136,20 @@ if grep -q '^CONFIG_MODULES=y' .config ; then
 		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
 		rmdir "$tmpdir/lib/modules/$version"
 	fi
+	if [ -n "$BUILD_DEBUG" ] ; then
+		(
+			cd $tmpdir
+			for module in $(find lib/modules/ -name *.ko); do
+				mkdir -p $(dirname $dbg_dir/usr/lib/debug/$module)
+				# only keep debug symbols in the debug file
+				objcopy --only-keep-debug $module $dbg_dir/usr/lib/debug/$module
+				# strip original module from debug symbols
+				objcopy --strip-debug $module
+				# then add a link to those
+				objcopy --add-gnu-debuglink=$dbg_dir/usr/lib/debug/$module $module
+			done
+		)
+	fi
 fi
 
 if [ "$ARCH" != "um" ]; then
@@ -299,4 +321,23 @@ fi
 
 create_package "$packagename" "$tmpdir"
 
+if [ -n "$BUILD_DEBUG" ] ; then
+	# Build debug package
+	mkdir -p $dbg_dir/usr/lib/debug/lib/modules/$version/
+	cp vmlinux $dbg_dir/usr/lib/debug/lib/modules/$version/
+
+	cat <<EOF >> debian/control
+
+Package: $dbg_packagename
+Section: debug
+Provides: linux-debug, linux-debug-$version
+Architecture: any
+Description: Linux kernel debugging symbols for $version
+ This package will come in handy if you need to debug the kernel. It provides
+ all the necessary debug symbols for the kernel and its modules.
+EOF
+
+	create_package "$dbg_packagename" "$dbg_dir"
+fi
+
 exit 0
-- 
1.8.1.4


