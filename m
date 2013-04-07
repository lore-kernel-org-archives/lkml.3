Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934997Ab3DGXde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:33:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46850 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934983Ab3DGXda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:33:30 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Metcalf" <cmetcalf@tilera.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.182410446@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [40/74] tile: expect new initramfs name from hypervisor file system
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/kernel/setup.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -914,7 +914,7 @@ void __cpuinit setup_cpu(int boot)
 #ifdef CONFIG_BLK_DEV_INITRD
 
 static int __initdata set_initramfs_file;
-static char __initdata initramfs_file[128] = "initramfs.cpio.gz";
+static char __initdata initramfs_file[128] = "initramfs";
 
 static int __init setup_initramfs_file(char *str)
 {
@@ -928,9 +928,9 @@ static int __init setup_initramfs_file(c
 early_param("initramfs_file", setup_initramfs_file);
 
 /*
- * We look for an additional "initramfs.cpio.gz" file in the hvfs.
- * If there is one, we allocate some memory for it and it will be
- * unpacked to the initramfs after any built-in initramfs_data.
+ * We look for a file called "initramfs" in the hvfs.  If there is one, we
+ * allocate some memory for it and it will be unpacked to the initramfs.
+ * If it's compressed, the initd code will uncompress it first.
  */
 static void __init load_hv_initrd(void)
 {
@@ -940,10 +940,16 @@ static void __init load_hv_initrd(void)
 
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

