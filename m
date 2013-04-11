Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949Ab3DKUzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:55:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935861Ab3DKUt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:28 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hxibCRFKYacA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Y7kaqLkP-NYA:10 a=9AzMRrQhAAAA:8 a=VwQbUJbxAAAA:8 a=aQw1Q--kFJQRljkUzPUA:9 a=SxxB86fLhQ4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202558.510420139@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 075/171 ] tile: expect new initramfs name from hypervisor file system
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0075-tile-expect-new-initramfs-name-from-hypervisor-file-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

[ Upstream commit ff7f3efb9abf986f4ecd8793a9593f7ca4d6431a ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/tile/kernel/setup.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6a649a4..86b1ae4 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -999,15 +999,8 @@ void __cpuinit setup_cpu(int boot)
 
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
@@ -1021,9 +1014,9 @@ static int __init setup_initramfs_file(char *str)
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
@@ -1033,10 +1026,16 @@ static void __init load_hv_initrd(void)
 
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
1.7.10.4


