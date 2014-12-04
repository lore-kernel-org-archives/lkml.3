Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaLDPx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:53:26 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:34176 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaLDPxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:53:25 -0500
From: j.glisse@gmail.com
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH] scripts/package: binrpm-pkg do not build source tar file v4
Date: Thu,  4 Dec 2014 10:53:13 -0500
Message-Id: <1417708393-14318-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

When doing make binrpm-pkg we only want to build the binary and header
package as the documentation of binrpm-pkg target claims. Hence this
patch avoid building the source and devel package. This makes binrpm-pkg
target lot faster and way more usefull.

Changed since v3 :
  - Avoid creating /usr/src/kernels directory.
  - Avoid useless pre clean step of source and devel package.

Changed since v2 :
  - Avoid symlinks in /usr/src/kernel.
  - Update subject line and changelog.

Changed since v1 :
  - Avoid building the devel package too.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
---
 scripts/package/mkspec | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 1395760..d9ab94b 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -117,6 +117,7 @@ echo 'mv vmlinux.bz2 $RPM_BUILD_ROOT'"/boot/vmlinux-$KERNELRELEASE.bz2"
 echo 'mv vmlinux.orig vmlinux'
 echo "%endif"
 
+if ! $PREBUILT; then
 echo 'rm -f $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
 echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"
 echo "EXCLUDES=\"$RCS_TAR_IGNORE --exclude .tmp_versions --exclude=*vmlinux* --exclude=*.o --exclude=*.ko --exclude=*.cmd --exclude=Documentation --exclude=firmware --exclude .config.old --exclude .missing-syscalls.d\""
@@ -124,6 +125,7 @@ echo "tar "'$EXCLUDES'" -cf- . | (cd "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNEL
 echo 'cd $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE"
 echo "ln -sf /usr/src/kernels/$KERNELRELEASE build"
 echo "ln -sf /usr/src/kernels/$KERNELRELEASE source"
+fi
 
 echo ""
 echo "%clean"
@@ -151,9 +153,11 @@ echo "%files headers"
 echo '%defattr (-, root, root)'
 echo "/usr/include"
 echo ""
+if ! $PREBUILT; then
 echo "%files devel"
 echo '%defattr (-, root, root)'
 echo "/usr/src/kernels/$KERNELRELEASE"
 echo "/lib/modules/$KERNELRELEASE/build"
 echo "/lib/modules/$KERNELRELEASE/source"
 echo ""
+fi
-- 
1.8.3.1

