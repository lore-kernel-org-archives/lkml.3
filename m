Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3C2Rya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:54:30 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:16652 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3C2Ry3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:54:29 -0400
Message-ID: <201303291754.r2THsSbP020753@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 29 Mar 2013 13:50:21 -0400
Subject: [PATCH] tile: expect new initramfs name from hypervisor file system
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current Tilera boot infrastructure now provides the initramfs
to Linux as a Tilera-hypervisor file named "initramfs", rather than
"initramfs.cpio.gz", as before.  (This makes it reasonable to use
other compression techniques than gzip on the file without having to
worry about the name causing confusion.)  Adapt to use the new name,
but also fall back to checking for the old name.

Cc'ing to stable so that older kernels will remain compatible with
newer Tilera boot infrastructure.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: stable@vger.kernel.org
---
 arch/tile/kernel/setup.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index d1e15f7..7a5aa1a 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1004,15 +1004,8 @@ void __cpuinit setup_cpu(int boot)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-/*
- * Note that the kernel can potentially support other compression
- * techniques than gz, though we don't do so by default.  If we ever
- * decide to do so we can either look for other filename extensions,
- * or just allow a file with this name to be compressed with an
- * arbitrary compressor (somewhat counterintuitively).
- */
 static int __initdata set_initramfs_file;
-static char __initdata initramfs_file[128] = "initramfs.cpio.gz";
+static char __initdata initramfs_file[128] = "initramfs";
 
 static int __init setup_initramfs_file(char *str)
 {
@@ -1026,9 +1019,9 @@ static int __init setup_initramfs_file(char *str)
 early_param("initramfs_file", setup_initramfs_file);
 
 /*
- * We look for an "initramfs.cpio.gz" file in the hvfs.
- * If there is one, we allocate some memory for it and it will be
- * unpacked to the initramfs.
+ * We look for a file called "initramfs" in the hvfs.  If there is one, we
+ * allocate some memory for it and it will be unpacked to the initramfs.
+ * If it's compressed, the initd code will uncompress it first.
  */
 static void __init load_hv_initrd(void)
 {
@@ -1038,10 +1031,16 @@ static void __init load_hv_initrd(void)
 
 	fd = hv_fs_findfile((HV_VirtAddr) initramfs_file);
 	if (fd == HV_ENOENT) {
-		if (set_initramfs_file)
+		if (set_initramfs_file) {
 			pr_warning("No such hvfs initramfs file '%s'\n",
 				   initramfs_file);
-		return;
+			return;
+		} else {
+			/* Try old backwards-compatible name. */
+			fd = hv_fs_findfile((HV_VirtAddr)"initramfs.cpio.gz");
+			if (fd == HV_ENOENT)
+				return;
+		}
 	}
 	BUG_ON(fd < 0);
 	stat = hv_fs_fstat(fd);
-- 
1.7.10.3

