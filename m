Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3IPXOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:14:03 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:58434 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab3IPXJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:43 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/28] arm64: use early_init_dt_scan
Date: Mon, 16 Sep 2013 18:09:08 -0500
Message-Id: <1379372965-22359-13-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert arm64 to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/kernel/setup.c | 31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 12ad8f3..b4461e1 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -124,37 +124,19 @@ static void __init setup_processor(void)
 
 static void __init setup_machine_fdt(phys_addr_t dt_phys)
 {
-	struct boot_param_header *devtree;
 	unsigned long dt_root;
 
-	/* Check we have a non-NULL DT pointer */
-	if (!dt_phys) {
-		early_print("\n"
-			"Error: NULL or invalid device tree blob\n"
-			"The dtb must be 8-byte aligned and passed in the first 512MB of memory\n"
-			"\nPlease check your bootloader.\n");
-
-		while (true)
-			cpu_relax();
-
-	}
-
-	devtree = phys_to_virt(dt_phys);
-
-	/* Check device tree validity */
-	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER) {
+	if (!dt_phys || !early_init_dt_scan(phys_to_virt(dt_phys))) {
 		early_print("\n"
 			"Error: invalid device tree blob at physical address 0x%p (virtual address 0x%p)\n"
-			"Expected 0x%x, found 0x%x\n"
+			"The dtb must be 8-byte aligned and passed in the first 512MB of memory\n"
 			"\nPlease check your bootloader.\n",
-			dt_phys, devtree, OF_DT_HEADER,
-			be32_to_cpu(devtree->magic));
+			dt_phys, phys_to_virt(dt_phys));
 
 		while (true)
 			cpu_relax();
 	}
 
-	initial_boot_params = devtree;
 	dt_root = of_get_flat_dt_root();
 
 	machine_name = of_get_flat_dt_prop(dt_root, "model", NULL);
@@ -163,13 +145,6 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 	if (!machine_name)
 		machine_name = "<unknown>";
 	pr_info("Machine: %s\n", machine_name);
-
-	/* Retrieve various information from the /chosen node */
-	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
-	/* Initialize {size,address}-cells info */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-	/* Setup memory, calling early_init_dt_add_memory_arch */
-	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 }
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
-- 
1.8.1.2

