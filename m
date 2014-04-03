Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaDCWSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:18:25 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41412 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaDCWRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:47 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH 15/20] of/fdt: move memreserve and dtb memory reservations into core
Date: Thu,  3 Apr 2014 17:16:58 -0500
Message-Id: <1396563423-30893-16-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Move the /memreserve/ processing and dtb memory reservations into
early_init_fdt_scan_reserved_mem. This converts arm, arm64, and powerpc
as they are the only users of early_init_fdt_scan_reserved_mem.

memblock_reserve is safe to call on the same region twice, so the
reservation check for the dtb in powerpc 32-bit reservations is safe to
remove.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 arch/arm/include/asm/prom.h |  2 --
 arch/arm/kernel/devtree.c   | 27 ---------------------------
 arch/arm/mm/init.c          |  1 -
 arch/arm64/mm/init.c        | 21 ---------------------
 arch/powerpc/kernel/prom.c  | 22 ----------------------
 drivers/of/fdt.c            | 16 ++++++++++++++++
 6 files changed, 16 insertions(+), 73 deletions(-)

diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
index b681575..cd94ef2 100644
--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -14,7 +14,6 @@
 #ifdef CONFIG_OF
 
 extern const struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
-extern void arm_dt_memblock_reserve(void);
 extern void __init arm_dt_init_cpu_maps(void);
 
 #else /* CONFIG_OF */
@@ -24,7 +23,6 @@ static inline const struct machine_desc *setup_machine_fdt(unsigned int dt_phys)
 	return NULL;
 }
 
-static inline void arm_dt_memblock_reserve(void) { }
 static inline void arm_dt_init_cpu_maps(void) { }
 
 #endif /* CONFIG_OF */
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 38f4711..3e5a205 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -32,33 +32,6 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 	arm_add_memory(base, size);
 }
 
-void __init arm_dt_memblock_reserve(void)
-{
-	u64 *reserve_map, base, size;
-
-	if (!initial_boot_params)
-		return;
-
-	/* Reserve the dtb region */
-	memblock_reserve(virt_to_phys(initial_boot_params),
-			 be32_to_cpu(initial_boot_params->totalsize));
-
-	/*
-	 * Process the reserve map.  This will probably overlap the initrd
-	 * and dtb locations which are already reserved, but overlaping
-	 * doesn't hurt anything
-	 */
-	reserve_map = ((void*)initial_boot_params) +
-			be32_to_cpu(initial_boot_params->off_mem_rsvmap);
-	while (1) {
-		base = be64_to_cpup(reserve_map++);
-		size = be64_to_cpup(reserve_map++);
-		if (!size)
-			break;
-		memblock_reserve(base, size);
-	}
-}
-
 #ifdef CONFIG_SMP
 extern struct of_cpu_method __cpu_method_of_table_begin[];
 extern struct of_cpu_method __cpu_method_of_table_end[];
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 97c293e..6c6ecd3 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -318,7 +318,6 @@ void __init arm_memblock_init(struct meminfo *mi,
 #endif
 
 	arm_mm_memblock_reserve();
-	arm_dt_memblock_reserve();
 
 	/* reserve any platform specific memblock areas */
 	if (mdesc->reserve)
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 51d5352..091d428 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -126,8 +126,6 @@ static void arm64_memory_present(void)
 
 void __init arm64_memblock_init(void)
 {
-	u64 *reserve_map, base, size;
-
 	/* Register the kernel text, kernel data and initrd with memblock */
 	memblock_reserve(__pa(_text), _end - _text);
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -142,25 +140,6 @@ void __init arm64_memblock_init(void)
 	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_DIR_SIZE);
 	memblock_reserve(__pa(idmap_pg_dir), IDMAP_DIR_SIZE);
 
-	/* Reserve the dtb region */
-	memblock_reserve(virt_to_phys(initial_boot_params),
-			 be32_to_cpu(initial_boot_params->totalsize));
-
-	/*
-	 * Process the reserve map.  This will probably overlap the initrd
-	 * and dtb locations which are already reserved, but overlapping
-	 * doesn't hurt anything
-	 */
-	reserve_map = ((void*)initial_boot_params) +
-			be32_to_cpu(initial_boot_params->off_mem_rsvmap);
-	while (1) {
-		base = be64_to_cpup(reserve_map++);
-		size = be64_to_cpup(reserve_map++);
-		if (!size)
-			break;
-		memblock_reserve(base, size);
-	}
-
 	early_init_fdt_scan_reserved_mem();
 	dma_contiguous_reserve(0);
 
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 05c125c..f9a44ce 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -596,19 +596,11 @@ static void __init early_reserve_mem_dt(void)
 
 static void __init early_reserve_mem(void)
 {
-	u64 base, size;
 	__be64 *reserve_map;
-	unsigned long self_base;
-	unsigned long self_size;
 
 	reserve_map = (__be64 *)(((unsigned long)initial_boot_params) +
 			be32_to_cpu(initial_boot_params->off_mem_rsvmap));
 
-	/* before we do anything, lets reserve the dt blob */
-	self_base = __pa((unsigned long)initial_boot_params);
-	self_size = be32_to_cpu(initial_boot_params->totalsize);
-	memblock_reserve(self_base, self_size);
-
 	/* Look for the new "reserved-regions" property in the DT */
 	early_reserve_mem_dt();
 
@@ -637,26 +629,12 @@ static void __init early_reserve_mem(void)
 			size_32 = be32_to_cpup(reserve_map_32++);
 			if (size_32 == 0)
 				break;
-			/* skip if the reservation is for the blob */
-			if (base_32 == self_base && size_32 == self_size)
-				continue;
 			DBG("reserving: %x -> %x\n", base_32, size_32);
 			memblock_reserve(base_32, size_32);
 		}
 		return;
 	}
 #endif
-	DBG("Processing reserve map\n");
-
-	/* Handle the reserve map in the fdt blob if it exists */
-	while (1) {
-		base = be64_to_cpup(reserve_map++);
-		size = be64_to_cpup(reserve_map++);
-		if (size == 0)
-			break;
-		DBG("reserving: %llx -> %llx\n", base, size);
-		memblock_reserve(base, size);
-	}
 }
 
 void __init early_init_devtree(void *params)
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index dc5f233..e940566 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -486,9 +486,25 @@ static int __init __fdt_scan_reserved_mem(unsigned long node, const char *uname,
  */
 void __init early_init_fdt_scan_reserved_mem(void)
 {
+	int n;
+	u64 base, size;
+
 	if (!initial_boot_params)
 		return;
 
+	/* Reserve the dtb region */
+	early_init_dt_reserve_memory_arch(__pa(initial_boot_params),
+					  fdt_totalsize(initial_boot_params),
+					  0);
+
+	/* Process header /memreserve/ fields */
+	for (n = 0; ; n++) {
+		fdt_get_mem_rsv(initial_boot_params, n, &base, &size);
+		if (!size)
+			break;
+		early_init_dt_reserve_memory_arch(base, size, 0);
+	}
+
 	of_scan_flat_dt(__fdt_scan_reserved_mem, NULL);
 	fdt_init_reserved_mem();
 }
-- 
1.8.3.2

