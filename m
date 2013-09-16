Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3IPXO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:14:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46053 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3IPXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:42 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/28] arm: use early_init_dt_scan
Date: Mon, 16 Sep 2013 18:09:07 -0500
Message-Id: <1379372965-22359-12-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert arm to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/devtree.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index f35906b..04050f7 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -183,7 +183,6 @@ bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
  */
 const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 {
-	struct boot_param_header *devtree;
 	const struct machine_desc *mdesc, *mdesc_best = NULL;
 	unsigned int score, mdesc_score = ~1;
 	unsigned long dt_root;
@@ -199,14 +198,9 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 	if (!dt_phys)
 		return NULL;
 
-	devtree = phys_to_virt(dt_phys);
-
-	/* check device tree validity */
-	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
-		return NULL;
+	early_init_dt_scan(phys_to_virt(dt_phys));
 
 	/* Search the mdescs for the 'best' compatible value match */
-	initial_boot_params = devtree;
 	dt_root = of_get_flat_dt_root();
 	for_each_machine_desc(mdesc) {
 		score = of_flat_dt_match(dt_root, mdesc->dt_compat);
@@ -240,13 +234,6 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 		model = "<unknown>";
 	pr_info("Machine: %s, model: %s\n", mdesc_best->name, model);
 
-	/* Retrieve various information from the /chosen node */
-	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
-	/* Initialize {size,address}-cells info */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-	/* Setup memory, calling early_init_dt_add_memory_arch */
-	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
-
 	/* Change machine number to match the mdesc we're using */
 	__machine_arch_type = mdesc_best->nr;
 
-- 
1.8.1.2

