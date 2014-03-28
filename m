Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaC1Rka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:40:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbaC1RbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3.13 26/46] deb-pkg: Fix cross-building linux-headers package
Date: Fri, 28 Mar 2014 10:32:10 -0700
Message-Id: <20140328173138.182755692@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit f8ce239dfc7ba9add41d9ecdc5e7810738f839fa upstream.

builddeb generates a control file that says the linux-headers package
can only be built for the build system primary architecture.  This
breaks cross-building configurations.  We should use $debarch for this
instead.

Since $debarch is not yet set when generating the control file, set
Architecture: any and use control file variables to fill in the
description.

Fixes: cd8d60a20a45 ('kbuild: create linux-headers package in deb-pkg')
Reported-and-tested-by: "Niew, Sh." <shniew@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/package/builddeb |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -62,7 +62,7 @@ create_package() {
 	fi
 
 	# Create the package
-	dpkg-gencontrol -isp $forcearch -p$pname -P"$pdir"
+	dpkg-gencontrol -isp $forcearch -Vkernel:debarch="${debarch:-$(dpkg --print-architecture)}" -p$pname -P"$pdir"
 	dpkg --build "$pdir" ..
 }
 
@@ -288,15 +288,14 @@ mkdir -p "$destdir"
 (cd $objtree; cp $KCONFIG_CONFIG $destdir/.config) # copy .config manually to be where it's expected to be
 ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
 rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
-arch=$(dpkg --print-architecture)
 
 cat <<EOF >> debian/control
 
 Package: $kernel_headers_packagename
 Provides: linux-headers, linux-headers-2.6
-Architecture: $arch
-Description: Linux kernel headers for $KERNELRELEASE on $arch
- This package provides kernel header files for $KERNELRELEASE on $arch
+Architecture: any
+Description: Linux kernel headers for $KERNELRELEASE on \${kernel:debarch}
+ This package provides kernel header files for $KERNELRELEASE on \${kernel:debarch}
  .
  This is useful for people who need to build external modules
 EOF


