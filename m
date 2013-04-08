Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935984Ab3DHJwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935946Ab3DHJwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 092/102] tile: expect new initramfs name from hypervisor file system
Date: Mon,  8 Apr 2013 10:50:47 +0100
Message-Id: <1365414657-29191-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit ff7f3efb9abf986f4ecd8793a9593f7ca4d6431a upstream.

The current Tilera boot infrastructure now provides the initramfs
to Linux as a Tilera-hypervisor file named "initramfs", rather than
"initramfs.cpio.gz", as before.  (This makes it reasonable to use
other compression techniques than gzip on the file without having to
worry about the name causing confusion.)  Adapt to use the new name,
but also fall back to checking for the old name.

Cc'ing to stable so that older kernels will remain compatible with
newer Tilera boot infrastructure.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/tile/kernel/setup.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index dd87f34..3d2190b 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -990,15 +990,8 @@ void __cpuinit setup_cpu(int boot)
 
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
@@ -1012,9 +1005,9 @@ static int __init setup_initramfs_file(char *str)
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
@@ -1024,10 +1017,16 @@ static void __init load_hv_initrd(void)
 
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
1.8.1.2

