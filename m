Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3IPXLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:11:10 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:51475 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab3IPXJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:55 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 25/28] arm: use common of_flat_dt_match_machine
Date: Mon, 16 Sep 2013 18:09:21 -0500
Message-Id: <1379372965-22359-26-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert arm to use the common of_flat_dt_match_machine function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/devtree.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 04050f7..cb918f6 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -174,6 +174,19 @@ bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 	return (phys_id & MPIDR_HWID_BITMASK) == cpu_logical_map(cpu);
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
  * @dt_phys: physical address of dt blob
@@ -184,9 +197,6 @@ bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 {
 	const struct machine_desc *mdesc, *mdesc_best = NULL;
-	unsigned int score, mdesc_score = ~1;
-	unsigned long dt_root;
-	const char *model;
 
 #ifdef CONFIG_ARCH_MULTIPLATFORM
 	DT_MACHINE_START(GENERIC_DT, "Generic DT based system")
@@ -199,23 +209,17 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 		return NULL;
 
 	early_init_dt_scan(phys_to_virt(dt_phys));
+	mdesc = of_flat_dt_match_machine(mdesc_best, arch_get_next_mach);
 
-	/* Search the mdescs for the 'best' compatible value match */
-	dt_root = of_get_flat_dt_root();
-	for_each_machine_desc(mdesc) {
-		score = of_flat_dt_match(dt_root, mdesc->dt_compat);
-		if (score > 0 && score < mdesc_score) {
-			mdesc_best = mdesc;
-			mdesc_score = score;
-		}
-	}
-	if (!mdesc_best) {
+	if (!mdesc) {
 		const char *prop;
 		long size;
+		unsigned long dt_root;
 
 		early_print("\nError: unrecognized/unsupported "
 			    "device tree compatible list:\n[ ");
 
+		dt_root = of_get_flat_dt_root();
 		prop = of_get_flat_dt_prop(dt_root, "compatible", &size);
 		while (size > 0) {
 			early_print("'%s' ", prop);
@@ -226,16 +230,10 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 
 		dump_machine_table(); /* does not return */
 	}
-
-	model = of_get_flat_dt_prop(dt_root, "model", NULL);
-	if (!model)
-		model = of_get_flat_dt_prop(dt_root, "compatible", NULL);
-	if (!model)
-		model = "<unknown>";
-	pr_info("Machine: %s, model: %s\n", mdesc_best->name, model);
+	early_print("matched mach %s\n", mdesc->name);
 
 	/* Change machine number to match the mdesc we're using */
-	__machine_arch_type = mdesc_best->nr;
+	__machine_arch_type = mdesc->nr;
 
-	return mdesc_best;
+	return mdesc;
 }
-- 
1.8.1.2

