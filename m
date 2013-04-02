Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339Ab3DBXX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:23:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760022Ab3DBWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:11:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 002/124] tile: expect new initramfs name from hypervisor file system
Date: Tue,  2 Apr 2013 15:09:44 -0700
Message-Id: <20130402221104.496225825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/tile/kernel/setup.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

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
@@ -1026,9 +1019,9 @@ static int __init setup_initramfs_file(c
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


