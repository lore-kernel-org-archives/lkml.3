Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaCaNY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35823 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaCaNYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, Michal Marek <mmarek@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 61/71] deb-pkg: Fix cross-building linux-headers package
Date: Mon, 31 Mar 2014 14:23:07 +0100
Message-Id: <1396272197-13394-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 scripts/package/builddeb | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index c95fdda..ca29f92 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -62,7 +62,7 @@ create_package() {
 	fi
 
 	# Create the package
-	dpkg-gencontrol -isp $forcearch -p$pname -P"$pdir"
+	dpkg-gencontrol -isp $forcearch -Vkernel:debarch="${debarch:-$(dpkg --print-architecture)}" -p$pname -P"$pdir"
 	dpkg --build "$pdir" ..
 }
 
@@ -252,15 +252,14 @@ mkdir -p "$destdir"
 (cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
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
-- 
1.9.1

