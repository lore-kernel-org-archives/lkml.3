Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaDFXkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:40:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59455 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754745AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Anisse Astier" <anisse@astier.eu>,
        "Michal Marek" <mmarek@suse.cz>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.733211636@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 09/18] deb-pkg: use KCONFIG_CONFIG instead of .config
 file directly
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit d20917670ee1fd4b090555e551faea04b014ca97 upstream.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/package/builddeb | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -41,9 +41,9 @@ create_package() {
 	parisc*)
 		debarch=hppa ;;
 	mips*)
-		debarch=mips$(grep -q CPU_LITTLE_ENDIAN=y .config && echo el) ;;
+		debarch=mips$(grep -q CPU_LITTLE_ENDIAN=y $KCONFIG_CONFIG && echo el) ;;
 	arm*)
-		debarch=arm$(grep -q CONFIG_AEABI=y .config && echo el) ;;
+		debarch=arm$(grep -q CONFIG_AEABI=y $KCONFIG_CONFIG && echo el) ;;
 	*)
 		echo "" >&2
 		echo "** ** **  WARNING  ** ** **" >&2
@@ -105,12 +105,12 @@ fi
 if [ "$ARCH" = "um" ] ; then
 	$MAKE linux
 	cp System.map "$tmpdir/usr/lib/uml/modules/$version/System.map"
-	cp .config "$tmpdir/usr/share/doc/$packagename/config"
+	cp $KCONFIG_CONFIG "$tmpdir/usr/share/doc/$packagename/config"
 	gzip "$tmpdir/usr/share/doc/$packagename/config"
 	cp $KBUILD_IMAGE "$tmpdir/usr/bin/linux-$version"
 else 
 	cp System.map "$tmpdir/boot/System.map-$version"
-	cp .config "$tmpdir/boot/config-$version"
+	cp $KCONFIG_CONFIG "$tmpdir/boot/config-$version"
 	# Not all arches include the boot path in KBUILD_IMAGE
 	if [ -e $KBUILD_IMAGE ]; then
 		cp $KBUILD_IMAGE "$tmpdir/boot/vmlinuz-$version"
@@ -119,7 +119,7 @@ else
 	fi
 fi
 
-if grep -q '^CONFIG_MODULES=y' .config ; then
+if grep -q '^CONFIG_MODULES=y' $KCONFIG_CONFIG ; then
 	INSTALL_MOD_PATH="$tmpdir" make KBUILD_SRC= modules_install
 	if [ "$ARCH" = "um" ] ; then
 		mv "$tmpdir/lib/modules/$version"/* "$tmpdir/usr/lib/uml/modules/$version/"
@@ -240,11 +240,12 @@ fi
 # Build header package
 (cd $srctree; find . -name Makefile -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
 (cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
-(cd $objtree; find .config Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
+(cd $objtree; find Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
 destdir=$kernel_headers_dir/usr/src/linux-headers-$version
 mkdir -p "$destdir"
 (cd $srctree; tar -c -f - -T "$objtree/debian/hdrsrcfiles") | (cd $destdir; tar -xf -)
 (cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
+(cd $objtree; cp $KCONFIG_CONFIG $destdir/.config) # copy .config manually to be where it's expected to be
 rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
 arch=$(dpkg --print-architecture)
 

