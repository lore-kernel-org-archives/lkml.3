Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaDCWSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:18:08 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:51000 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaDCWRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:38 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 09/20] of/fdt: create common debugfs
Date: Thu,  3 Apr 2014 17:16:52 -0500
Message-Id: <1396563423-30893-10-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Both powerpc and microblaze have the same FDT blob in debugfs feature.
Move this to common location and remove the powerpc and microblaze
implementations. This feature could become more useful when FDT
overlay support is added.

This changes the path of the blob from "$arch/flat-device-tree" to
"device-tree/flat-device-tree".

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/microblaze/kernel/prom.c | 31 -------------------------------
 arch/powerpc/kernel/prom.c    | 21 ---------------------
 drivers/of/fdt.c              | 24 ++++++++++++++++++++++++
 3 files changed, 24 insertions(+), 52 deletions(-)

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index abdfb10..1312cd2 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -114,34 +114,3 @@ void __init early_init_devtree(void *params)
 
 	pr_debug(" <- early_init_devtree()\n");
 }
-
-/*******
- *
- * New implementation of the OF "find" APIs, return a refcounted
- * object, call of_node_put() when done.  The device tree and list
- * are protected by a rw_lock.
- *
- * Note that property management will need some locking as well,
- * this isn't dealt with yet.
- *
- *******/
-
-#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
-static struct debugfs_blob_wrapper flat_dt_blob;
-
-static int __init export_flat_device_tree(void)
-{
-	struct dentry *d;
-
-	flat_dt_blob.data = initial_boot_params;
-	flat_dt_blob.size = initial_boot_params->totalsize;
-
-	d = debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
-				of_debugfs_root, &flat_dt_blob);
-	if (!d)
-		return 1;
-
-	return 0;
-}
-device_initcall(export_flat_device_tree);
-#endif
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index dd72beb..7c2f90c 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -29,7 +29,6 @@
 #include <linux/bitops.h>
 #include <linux/export.h>
 #include <linux/kexec.h>
-#include <linux/debugfs.h>
 #include <linux/irq.h>
 #include <linux/memblock.h>
 #include <linux/of.h>
@@ -918,23 +917,3 @@ bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 {
 	return (int)phys_id == get_hard_smp_processor_id(cpu);
 }
-
-#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
-static struct debugfs_blob_wrapper flat_dt_blob;
-
-static int __init export_flat_device_tree(void)
-{
-	struct dentry *d;
-
-	flat_dt_blob.data = initial_boot_params;
-	flat_dt_blob.size = be32_to_cpu(initial_boot_params->totalsize);
-
-	d = debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
-				powerpc_debugfs_root, &flat_dt_blob);
-	if (!d)
-		return 1;
-
-	return 0;
-}
-__initcall(export_flat_device_tree);
-#endif
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index fa16a91..2085d47 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/debugfs.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #ifdef CONFIG_PPC
@@ -1084,4 +1085,27 @@ void __init unflatten_and_copy_device_tree(void)
 	unflatten_device_tree();
 }
 
+#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
+static struct debugfs_blob_wrapper flat_dt_blob;
+
+static int __init of_flat_dt_debugfs_export_fdt(void)
+{
+	struct dentry *d = debugfs_create_dir("device-tree", NULL);
+
+	if (!d)
+		return -ENOENT;
+
+	flat_dt_blob.data = initial_boot_params;
+	flat_dt_blob.size = fdt_totalsize(initial_boot_params);
+
+	d = debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
+				d, &flat_dt_blob);
+	if (!d)
+		return -ENOENT;
+
+	return 0;
+}
+module_init(of_flat_dt_debugfs_export_fdt);
+#endif
+
 #endif /* CONFIG_OF_EARLY_FLATTREE */
-- 
1.8.3.2

