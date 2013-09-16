Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3IPXKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:10:06 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64479 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3IPXJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:57 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 27/28] metag: use common of_flat_dt_match_machine
Date: Mon, 16 Sep 2013 18:09:23 -0500
Message-Id: <1379372965-22359-28-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert metag to use the common of_flat_dt_get_machine_name function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/devtree.c | 67 ++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 49 deletions(-)

diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
index 2c6ee6d..b26bcb4 100644
--- a/arch/metag/kernel/devtree.c
+++ b/arch/metag/kernel/devtree.c
@@ -28,6 +28,19 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return alloc_bootmem_align(size, align);
 }
 
+static void * __init arch_get_next_mach(const char *const **match)
+{
+	static struct machine_desc *mdesc = __arch_info_begin;
+	struct machine_desc *m = mdesc;
+
+	if (m >= __arch_info_end)
+		return NULL;
+
+	mdesc++;
+	*match = m->dt_compat;
+	return m;
+}
+
 /**
  * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
  * @dt:		virtual address pointer to dt blob
@@ -37,56 +50,12 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
  */
 struct machine_desc * __init setup_machine_fdt(void *dt)
 {
-	struct boot_param_header *devtree = dt;
-	struct machine_desc *mdesc, *mdesc_best = NULL;
-	unsigned int score, mdesc_score = ~1;
-	unsigned long dt_root;
-	const char *model;
-
-	/* check device tree validity */
-	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
-		return NULL;
-
-	/* Search the mdescs for the 'best' compatible value match */
-	initial_boot_params = devtree;
-	dt_root = of_get_flat_dt_root();
-
-	for_each_machine_desc(mdesc) {
-		score = of_flat_dt_match(dt_root, mdesc->dt_compat);
-		if (score > 0 && score < mdesc_score) {
-			mdesc_best = mdesc;
-			mdesc_score = score;
-		}
-	}
-	if (!mdesc_best) {
-		const char *prop;
-		long size;
-
-		pr_err("\nError: unrecognized/unsupported device tree compatible list:\n[ ");
-
-		prop = of_get_flat_dt_prop(dt_root, "compatible", &size);
-		if (prop) {
-			while (size > 0) {
-				printk("'%s' ", prop);
-				size -= strlen(prop) + 1;
-				prop += strlen(prop) + 1;
-			}
-		}
-		printk("]\n\n");
+	struct machine_desc *mdesc;
 
+	early_init_dt_scan(dt);
+	mdesc = of_flat_dt_match_machine(NULL, arch_get_next_mach);
+	if (!mdesc)
 		dump_machine_table(); /* does not return */
-	}
-
-	model = of_get_flat_dt_prop(dt_root, "model", NULL);
-	if (!model)
-		model = of_get_flat_dt_prop(dt_root, "compatible", NULL);
-	if (!model)
-		model = "<unknown>";
-	pr_info("Machine: %s, model: %s\n", mdesc_best->name, model);
-
-	/* Retrieve various information from the /chosen node */
-	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
-
-	return mdesc_best;
 
+	return mdesc;
 }
-- 
1.8.1.2

