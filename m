Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaDCWW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:22:27 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62546 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaDCWRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:45 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH 14/20] of/fdt: use libfdt accessors for header data
Date: Thu,  3 Apr 2014 17:16:57 -0500
Message-Id: <1396563423-30893-15-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

With libfdt support, we can take advantage of helper accessors in libfdt
for accessing the FDT header data. This makes the code more readable and
makes the FDT blob structure more opaque to the kernel. This also
prepares for removing struct boot_param_header completely.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/of/fdt.c       | 27 ++++++++++++---------------
 include/linux/of_fdt.h |  8 ++++----
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ee8853c..dc5f233 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -35,7 +35,7 @@
  * On match, returns a non-zero value with smaller values returned for more
  * specific compatible values.
  */
-int of_fdt_is_compatible(struct boot_param_header *blob,
+int of_fdt_is_compatible(const void *blob,
 		      unsigned long node, const char *compat)
 {
 	const char *cp;
@@ -60,7 +60,7 @@ int of_fdt_is_compatible(struct boot_param_header *blob,
 /**
  * of_fdt_match - Return true if node matches a list of compatible values
  */
-int of_fdt_match(struct boot_param_header *blob, unsigned long node,
+int of_fdt_match(const void *blob, unsigned long node,
                  const char *const *compat)
 {
 	unsigned int tmp, score = 0;
@@ -99,7 +99,7 @@ static void *unflatten_dt_alloc(void **mem, unsigned long size,
  * @allnextpp: pointer to ->allnext from last allocated device_node
  * @fpsize: Size of the node path up at the current depth.
  */
-static void * unflatten_dt_node(struct boot_param_header *blob,
+static void * unflatten_dt_node(void *blob,
 				void *mem,
 				int *poffset,
 				struct device_node *dad,
@@ -290,7 +290,7 @@ static void * unflatten_dt_node(struct boot_param_header *blob,
  * @dt_alloc: An allocator that provides a virtual address to memory
  * for the resulting tree
  */
-static void __unflatten_device_tree(struct boot_param_header *blob,
+static void __unflatten_device_tree(void *blob,
 			     struct device_node **mynodes,
 			     void * (*dt_alloc)(u64 size, u64 align))
 {
@@ -307,11 +307,11 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 	}
 
 	pr_debug("Unflattening device tree:\n");
-	pr_debug("magic: %08x\n", be32_to_cpu(blob->magic));
-	pr_debug("size: %08x\n", be32_to_cpu(blob->totalsize));
-	pr_debug("version: %08x\n", be32_to_cpu(blob->version));
+	pr_debug("magic: %08x\n", fdt_magic(blob));
+	pr_debug("size: %08x\n", fdt_totalsize(blob));
+	pr_debug("version: %08x\n", fdt_version(blob));
 
-	if (be32_to_cpu(blob->magic) != OF_DT_HEADER) {
+	if (fdt_check_header(blob)) {
 		pr_err("Invalid device tree blob header\n");
 		return;
 	}
@@ -358,9 +358,7 @@ static void *kernel_tree_alloc(u64 size, u64 align)
 void of_fdt_unflatten_tree(unsigned long *blob,
 			struct device_node **mynodes)
 {
-	struct boot_param_header *device_tree =
-		(struct boot_param_header *)blob;
-	__unflatten_device_tree(device_tree, mynodes, &kernel_tree_alloc);
+	__unflatten_device_tree(blob, mynodes, &kernel_tree_alloc);
 }
 EXPORT_SYMBOL_GPL(of_fdt_unflatten_tree);
 
@@ -847,7 +845,7 @@ bool __init early_init_dt_scan(void *params)
 	initial_boot_params = params;
 
 	/* check device tree validity */
-	if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER) {
+	if (fdt_check_header(params)) {
 		initial_boot_params = NULL;
 		return false;
 	}
@@ -902,9 +900,8 @@ void __init unflatten_and_copy_device_tree(void)
 		return;
 	}
 
-	size = __be32_to_cpu(initial_boot_params->totalsize);
-	dt = early_init_dt_alloc_memory_arch(size,
-		__alignof__(struct boot_param_header));
+	size = fdt_totalsize(initial_boot_params);
+	dt = early_init_dt_alloc_memory_arch(size, FDT_V17_SIZE);
 
 	if (dt) {
 		memcpy(dt, initial_boot_params, size);
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index 26cef9a..348dae2 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -62,15 +62,15 @@ struct boot_param_header {
 struct device_node;
 
 /* For scanning an arbitrary device-tree at any time */
-extern char *of_fdt_get_string(struct boot_param_header *blob, u32 offset);
-extern void *of_fdt_get_property(struct boot_param_header *blob,
+extern char *of_fdt_get_string(const void *blob, u32 offset);
+extern void *of_fdt_get_property(const void *blob,
 				 unsigned long node,
 				 const char *name,
 				 int *size);
-extern int of_fdt_is_compatible(struct boot_param_header *blob,
+extern int of_fdt_is_compatible(const void *blob,
 				unsigned long node,
 				const char *compat);
-extern int of_fdt_match(struct boot_param_header *blob, unsigned long node,
+extern int of_fdt_match(const void *blob, unsigned long node,
 			const char *const *compat);
 extern void of_fdt_unflatten_tree(unsigned long *blob,
 			       struct device_node **mynodes);
-- 
1.8.3.2

