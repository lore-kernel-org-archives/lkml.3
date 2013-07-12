Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965560Ab3GLVtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:49:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59155 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965501Ab3GLVt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:49:28 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>
Subject: [RFC/RFT PATCH 5/5] ARM: mm: Remove bootmem code and switch to NO_BOOTMEM
Date: Fri, 12 Jul 2013 17:48:14 -0400
Message-ID: <1373665694-7580-6-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the effort of using memblock instead of bootmem allocator, ARM arch
needs to be converted to use NO_BOOTMEM. With NO_BOOTMEM change,
now we use memblock allocator to reserve space for crash kernel to
have one less dependency with nobootmem allocator wrapper.

Hopefully the NO_BOOTMEM memblock wrapper(nobootmem.c) will vanish in
near future and archs can directly use memblock APIs. Ongoing thread
on this topic is here:
https://lkml.org/lkml/2013/6/29/77

Boot tested with both flat memory and sparse (faked) memory models
with highmem enabled. LAPE systems with memory starting > 4GB still
won't work but this is one of the step to solve that problem for ARM.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Tejun Heo <tj@kernel.org>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/Kconfig        |    1 +
 arch/arm/kernel/setup.c |    2 +-
 arch/arm/mm/init.c      |   58 ++---------------------------------------------
 3 files changed, 4 insertions(+), 57 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0ac9be6..cff9a59 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -63,6 +63,7 @@ config ARM
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
 	select HAVE_CONTEXT_TRACKING
+	select NO_BOOTMEM
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 63af9a7..2ca4b90 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -805,7 +805,7 @@ static void __init reserve_crashkernel(void)
 	if (ret)
 		return;
 
-	ret = reserve_bootmem(crash_base, crash_size, BOOTMEM_EXCLUSIVE);
+	ret = memblock_reserve(crash_base, crash_size);
 	if (ret < 0) {
 		printk(KERN_WARNING "crashkernel reservation failed - "
 		       "memory is in use (0x%lx)\n", (unsigned long)crash_base);
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 588a2c1..84dd56c 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -153,58 +153,6 @@ static void __init find_limits(unsigned long *min, unsigned long *max_low,
 	*max_high = bank_pfn_end(&mi->bank[mi->nr_banks - 1]);
 }
 
-static void __init arm_bootmem_init(unsigned long start_pfn,
-	unsigned long end_pfn)
-{
-	struct memblock_region *reg;
-	unsigned int boot_pages;
-	phys_addr_t bitmap;
-	pg_data_t *pgdat;
-
-	/*
-	 * Allocate the bootmem bitmap page.  This must be in a region
-	 * of memory which has already been mapped.
-	 */
-	boot_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
-	bitmap = memblock_alloc_base(boot_pages << PAGE_SHIFT, L1_CACHE_BYTES,
-				__pfn_to_phys(end_pfn));
-
-	/*
-	 * Initialise the bootmem allocator, handing the
-	 * memory banks over to bootmem.
-	 */
-	node_set_online(0);
-	pgdat = NODE_DATA(0);
-	init_bootmem_node(pgdat, __phys_to_pfn(bitmap), start_pfn, end_pfn);
-
-	/* Free the lowmem regions from memblock into bootmem. */
-	for_each_memblock(memory, reg) {
-		unsigned long start = memblock_region_memory_base_pfn(reg);
-		unsigned long end = memblock_region_memory_end_pfn(reg);
-
-		if (end >= end_pfn)
-			end = end_pfn;
-		if (start >= end)
-			break;
-
-		free_bootmem(__pfn_to_phys(start), (end - start) << PAGE_SHIFT);
-	}
-
-	/* Reserve the lowmem memblock reserved regions in bootmem. */
-	for_each_memblock(reserved, reg) {
-		unsigned long start = memblock_region_reserved_base_pfn(reg);
-		unsigned long end = memblock_region_reserved_end_pfn(reg);
-
-		if (end >= end_pfn)
-			end = end_pfn;
-		if (start >= end)
-			break;
-
-		reserve_bootmem(__pfn_to_phys(start),
-			        (end - start) << PAGE_SHIFT, BOOTMEM_DEFAULT);
-	}
-}
-
 #ifdef CONFIG_ZONE_DMA
 
 unsigned long arm_dma_zone_size __read_mostly;
@@ -242,7 +190,7 @@ void __init setup_dma_zone(struct machine_desc *mdesc)
 #endif
 }
 
-static void __init arm_bootmem_free(unsigned long min, unsigned long max_low,
+static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
 	unsigned long max_high)
 {
 	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
@@ -396,8 +344,6 @@ void __init bootmem_init(void)
 
 	find_limits(&min, &max_low, &max_high);
 
-	arm_bootmem_init(min, max_low);
-
 	/*
 	 * Sparsemem tries to allocate bootmem in memory_present(),
 	 * so must be done after the fixed reservations
@@ -414,7 +360,7 @@ void __init bootmem_init(void)
 	 * the sparse mem_map arrays initialized by sparse_init()
 	 * for memmap_init_zone(), otherwise all PFNs are invalid.
 	 */
-	arm_bootmem_free(min, max_low, max_high);
+	zone_sizes_init(min, max_low, max_high);
 
 	/*
 	 * This doesn't seem to be used by the Linux memory manager any
-- 
1.7.9.5

