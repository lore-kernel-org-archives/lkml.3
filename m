Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3H2Nor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:44:47 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33652 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3H2Nop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:44:45 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] of/fdt: Clean up casting in unflattening path
Date: Thu, 29 Aug 2013 14:44:48 +0100
Message-Id: <1377783888-12899-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flat tree unflatting path is using unsigned longs to carry around
virtual address pointers to the device tree and the allocated memory
used to unpack it. This is a little insane since every access to them
needs to be cast to a pointer type before using it. This patch changes
the data type to void* for the 'start' and 'mem' pointers and reworks
the unflattening functions to use those values directly which results in
slightly simpler code.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/fdt.c | 63 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index d49b3e8..55b028f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -126,13 +126,13 @@ int of_fdt_match(struct boot_param_header *blob, unsigned long node,
 	return score;
 }
 
-static void *unflatten_dt_alloc(unsigned long *mem, unsigned long size,
+static void *unflatten_dt_alloc(void **mem, unsigned long size,
 				       unsigned long align)
 {
 	void *res;
 
-	*mem = ALIGN(*mem, align);
-	res = (void *)*mem;
+	*mem = PTR_ALIGN(*mem, align);
+	res = *mem;
 	*mem += size;
 
 	return res;
@@ -147,9 +147,9 @@ static void *unflatten_dt_alloc(unsigned long *mem, unsigned long size,
  * @allnextpp: pointer to ->allnext from last allocated device_node
  * @fpsize: Size of the node path up at the current depth.
  */
-static unsigned long unflatten_dt_node(struct boot_param_header *blob,
-				unsigned long mem,
-				unsigned long *p,
+static void * unflatten_dt_node(struct boot_param_header *blob,
+				void *mem,
+				void **p,
 				struct device_node *dad,
 				struct device_node ***allnextpp,
 				unsigned long fpsize)
@@ -162,15 +162,15 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 	int has_name = 0;
 	int new_format = 0;
 
-	tag = be32_to_cpup((__be32 *)(*p));
+	tag = be32_to_cpup(*p);
 	if (tag != OF_DT_BEGIN_NODE) {
 		pr_err("Weird tag at start of node: %x\n", tag);
 		return mem;
 	}
 	*p += 4;
-	pathp = (char *)*p;
+	pathp = *p;
 	l = allocl = strlen(pathp) + 1;
-	*p = ALIGN(*p + l, 4);
+	*p = PTR_ALIGN(*p + l, 4);
 
 	/* version 0x10 has a more compact unit name here instead of the full
 	 * path. we accumulate the full path size using "fpsize", we'll rebuild
@@ -240,7 +240,7 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		u32 sz, noff;
 		char *pname;
 
-		tag = be32_to_cpup((__be32 *)(*p));
+		tag = be32_to_cpup(*p);
 		if (tag == OF_DT_NOP) {
 			*p += 4;
 			continue;
@@ -248,11 +248,11 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		if (tag != OF_DT_PROP)
 			break;
 		*p += 4;
-		sz = be32_to_cpup((__be32 *)(*p));
-		noff = be32_to_cpup((__be32 *)((*p) + 4));
+		sz = be32_to_cpup(*p);
+		noff = be32_to_cpup(*p + 4);
 		*p += 8;
 		if (be32_to_cpu(blob->version) < 0x10)
-			*p = ALIGN(*p, sz >= 8 ? 8 : 4);
+			*p = PTR_ALIGN(*p, sz >= 8 ? 8 : 4);
 
 		pname = of_fdt_get_string(blob, noff);
 		if (pname == NULL) {
@@ -282,11 +282,11 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 				np->phandle = be32_to_cpup((__be32 *)*p);
 			pp->name = pname;
 			pp->length = sz;
-			pp->value = (void *)*p;
+			pp->value = *p;
 			*prev_pp = pp;
 			prev_pp = &pp->next;
 		}
-		*p = ALIGN((*p) + sz, 4);
+		*p = PTR_ALIGN((*p) + sz, 4);
 	}
 	/* with version 0x10 we may not have the name property, recreate
 	 * it here from the unit name if absent
@@ -335,7 +335,7 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		else
 			mem = unflatten_dt_node(blob, mem, p, np, allnextpp,
 						fpsize);
-		tag = be32_to_cpup((__be32 *)(*p));
+		tag = be32_to_cpup(*p);
 	}
 	if (tag != OF_DT_END_NODE) {
 		pr_err("Weird tag at end of node: %x\n", tag);
@@ -361,7 +361,8 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 			     struct device_node **mynodes,
 			     void * (*dt_alloc)(u64 size, u64 align))
 {
-	unsigned long start, mem, size;
+	unsigned long size;
+	void *start, *mem;
 	struct device_node **allnextp = mynodes;
 
 	pr_debug(" -> unflatten_device_tree()\n");
@@ -382,32 +383,28 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 	}
 
 	/* First pass, scan for size */
-	start = ((unsigned long)blob) +
-		be32_to_cpu(blob->off_dt_struct);
-	size = unflatten_dt_node(blob, 0, &start, NULL, NULL, 0);
-	size = (size | 3) + 1;
+	start = ((void *)blob) + be32_to_cpu(blob->off_dt_struct);
+	size = (unsigned long)unflatten_dt_node(blob, 0, &start, NULL, NULL, 0);
+	size = ALIGN(size, 4);
 
 	pr_debug("  size is %lx, allocating...\n", size);
 
 	/* Allocate memory for the expanded device tree */
-	mem = (unsigned long)
-		dt_alloc(size + 4, __alignof__(struct device_node));
+	mem = dt_alloc(size + 4, __alignof__(struct device_node));
+	memset(mem, 0, size);
 
-	memset((void *)mem, 0, size);
+	*(__be32 *)(mem + size) = cpu_to_be32(0xdeadbeef);
 
-	((__be32 *)mem)[size / 4] = cpu_to_be32(0xdeadbeef);
-
-	pr_debug("  unflattening %lx...\n", mem);
+	pr_debug("  unflattening %p...\n", mem);
 
 	/* Second pass, do actual unflattening */
-	start = ((unsigned long)blob) +
-		be32_to_cpu(blob->off_dt_struct);
+	start = ((void *)blob) + be32_to_cpu(blob->off_dt_struct);
 	unflatten_dt_node(blob, mem, &start, NULL, &allnextp, 0);
-	if (be32_to_cpup((__be32 *)start) != OF_DT_END)
-		pr_warning("Weird tag at end of tree: %08x\n", *((u32 *)start));
-	if (be32_to_cpu(((__be32 *)mem)[size / 4]) != 0xdeadbeef)
+	if (be32_to_cpup(start) != OF_DT_END)
+		pr_warning("Weird tag at end of tree: %08x\n", be32_to_cpup(start));
+	if (be32_to_cpup(mem + size) != 0xdeadbeef)
 		pr_warning("End of tree marker overwritten: %08x\n",
-			   be32_to_cpu(((__be32 *)mem)[size / 4]));
+			   be32_to_cpu(mem + size));
 	*allnextp = NULL;
 
 	pr_debug(" <- unflatten_device_tree()\n");
-- 
1.8.1.2

