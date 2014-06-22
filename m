Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaFVFmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 01:42:15 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:42413 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaFVFmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 01:42:14 -0400
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] init: Introduce 'noinitramfs' kernel parameter
Date: Sun, 22 Jun 2014 02:41:25 -0300
Message-Id: <1403415685-21455-1-git-send-email-ezequiel@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we have no kernel paramater to avoid loading a configured initial
RAM filesystem. Therefore, if a kernel is built with an appended initramfs,
there's no way to avoid unpacking and mounting it as the rootfs.

This commit adds a new kernel parameter to provide such option, following the
naming of the current 'initrd' which serves a similar purpose, for an initial
RAM disk.

This commit changes the build so noinitramfs.c is unconditionally included.
If the new 'noinitramfs' option is passed in the command line, the kernel
avoids unpacking an initramfs and calls default_rootfs().

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 Documentation/kernel-parameters.txt |  4 ++++
 include/linux/initrd.h              |  2 ++
 init/Makefile                       |  3 ---
 init/initramfs.c                    | 14 +++++++++++++-
 init/noinitramfs.c                  |  4 +++-
 5 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8849049..a8cb75e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -102,6 +102,7 @@ parameter is applicable:
 	PPT	Parallel port support is enabled.
 	PS2	Appropriate PS/2 support is enabled.
 	RAM	RAM disk support is enabled.
+	RAMFS	Initial RAM filesystem support is enabled.
 	S390	S390 architecture is enabled.
 	SCSI	Appropriate SCSI support is enabled.
 			A lot of drivers have their options described inside
@@ -2211,6 +2212,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	noisapnp	[ISAPNP] Disables ISA PnP code.
 
+	noinitramfs	[RAMFS] Tells the kernel not to load any configured
+			initial RAM filesystem.
+
 	noinitrd	[RAM] Tells the kernel not to load any configured
 			initial RAM disk.
 
diff --git a/include/linux/initrd.h b/include/linux/initrd.h
index 55289d2..f627ce6 100644
--- a/include/linux/initrd.h
+++ b/include/linux/initrd.h
@@ -17,4 +17,6 @@ extern int initrd_below_start_ok;
 extern unsigned long initrd_start, initrd_end;
 extern void free_initrd_mem(unsigned long, unsigned long);
 
+extern int default_rootfs(void);
+
 extern unsigned int real_root_dev;
diff --git a/init/Makefile b/init/Makefile
index 7bc47ee..692b91f 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -3,11 +3,8 @@
 #
 
 obj-y                          := main.o version.o mounts.o
-ifneq ($(CONFIG_BLK_DEV_INITRD),y)
 obj-y                          += noinitramfs.o
-else
 obj-$(CONFIG_BLK_DEV_INITRD)   += initramfs.o
-endif
 obj-$(CONFIG_GENERIC_CALIBRATE_DELAY) += calibrate.o
 
 ifneq ($(CONFIG_ARCH_INIT_TASK),y)
diff --git a/init/initramfs.c b/init/initramfs.c
index a8497fa..cae8cee 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -580,9 +580,21 @@ static void __init clean_rootfs(void)
 }
 #endif
 
+static int __initdata skip_initramfs;
+static int __init noinitramfs_param(char *str)
+{
+	skip_initramfs = 1;
+	return 1;
+}
+__setup("noinitramfs", noinitramfs_param);
+
 static int __init populate_rootfs(void)
 {
-	char *err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
+	char *err;
+
+	if (skip_initramfs)
+		return default_rootfs();
+	err = unpack_to_rootfs(__initramfs_start, __initramfs_size);
 	if (err)
 		panic("%s", err); /* Failed to decompress INTERNAL initramfs */
 	if (initrd_start) {
diff --git a/init/noinitramfs.c b/init/noinitramfs.c
index 267739d..e7e828a 100644
--- a/init/noinitramfs.c
+++ b/init/noinitramfs.c
@@ -25,7 +25,7 @@
 /*
  * Create a simple rootfs that is similar to the default initramfs
  */
-static int __init default_rootfs(void)
+int __init default_rootfs(void)
 {
 	int err;
 
@@ -49,4 +49,6 @@ out:
 	printk(KERN_WARNING "Failed to create a rootfs\n");
 	return err;
 }
+#ifndef CONFIG_BLK_DEV_INITRD
 rootfs_initcall(default_rootfs);
+#endif
-- 
1.9.1

