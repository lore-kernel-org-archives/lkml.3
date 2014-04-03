Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaDCWRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:17:38 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60071 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaDCWR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:27 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 01/20] mips: octeon: convert to use unflatten_and_copy_device_tree
Date: Thu,  3 Apr 2014 17:16:44 -0500
Message-Id: <1396563423-30893-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The octeon FDT code can be simplified by using
unflatten_and_copy_device_tree function. This removes all accesses to
FDT header data by the arch code.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/cavium-octeon/setup.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 331b837..0b27411 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -1058,31 +1058,23 @@ extern const char __dtb_octeon_68xx_begin;
 extern const char __dtb_octeon_68xx_end;
 void __init device_tree_init(void)
 {
-	int dt_size;
-	struct boot_param_header *fdt;
+	void *fdt;
 	bool do_prune;
 
 	if (octeon_bootinfo->minor_version >= 3 && octeon_bootinfo->fdt_addr) {
 		fdt = phys_to_virt(octeon_bootinfo->fdt_addr);
 		if (fdt_check_header(fdt))
 			panic("Corrupt Device Tree passed to kernel.");
-		dt_size = be32_to_cpu(fdt->totalsize);
 		do_prune = false;
 	} else if (OCTEON_IS_MODEL(OCTEON_CN68XX)) {
-		fdt = (struct boot_param_header *)&__dtb_octeon_68xx_begin;
-		dt_size = &__dtb_octeon_68xx_end - &__dtb_octeon_68xx_begin;
+		fdt = &__dtb_octeon_68xx_begin;
 		do_prune = true;
 	} else {
-		fdt = (struct boot_param_header *)&__dtb_octeon_3xxx_begin;
-		dt_size = &__dtb_octeon_3xxx_end - &__dtb_octeon_3xxx_begin;
+		fdt = &__dtb_octeon_3xxx_begin;
 		do_prune = true;
 	}
 
-	/* Copy the default tree from init memory. */
-	initial_boot_params = early_init_dt_alloc_memory_arch(dt_size, 8);
-	if (initial_boot_params == NULL)
-		panic("Could not allocate initial_boot_params");
-	memcpy(initial_boot_params, fdt, dt_size);
+	initial_boot_params = fdt;
 
 	if (do_prune) {
 		octeon_prune_device_tree();
@@ -1090,7 +1082,7 @@ void __init device_tree_init(void)
 	} else {
 		pr_info("Using passed Device Tree.\n");
 	}
-	unflatten_device_tree();
+	unflatten_and_copy_device_tree();
 }
 
 static int __initdata disable_octeon_edac_p;
-- 
1.8.3.2

