Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaDWBW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:22:58 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55493 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaDWBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:19:05 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 14/21] of/fdt: create common debugfs
Date: Tue, 22 Apr 2014 20:18:14 -0500
Message-Id: <1398215901-25609-15-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
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
v2: move to after libfdt conversion

 arch/microblaze/kernel/prom.c | 31 -------------------------------
 arch/powerpc/kernel/prom.c    | 21 ---------------------
 drivers/of/fdt.c              | 24 ++++++++++++++++++++++++
 3 files changed, 24 insertions(+), 52 deletions(-)

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index c766306..68f0999 100644
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
index f971134..03624ce 100644
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
@@ -924,23 +923,3 @@ bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
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
index 0b38a6a..4129f74 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/libfdt.h>
+#include <linux/debugfs.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -916,4 +917,27 @@ void __init unflatten_and_copy_device_tree(void)
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
1.9.1

