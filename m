Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226Ab3DOII0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:08:26 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52948 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab3DOIIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:08:18 -0400
Date: Mon, 15 Apr 2013 16:08:08 +0800
From: Wang YanQing <udknight@gmail.com>
To: akpm@linux-foundation.org
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm:memblock: add memblock_alloc_in_[range|range_nid]
Message-ID: <20130415080808.GC1994@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	akpm@linux-foundation.org, yinghai@kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a memblock code use pattern in kernel which looks like below:
in nobootmem.c:

       addr = memblock_find_in_range_node(goal, limit, size, align, nid);
       if (!addr)
                return NULL;

       ptr = phys_to_virt(addr);
       memset(ptr, 0, size);
       memblock_reserve(addr, size);

use memblock_alloc_in_[range|range_nid] to do
the search and reserve in one function will
bring the benefit below:

1: clarify the codes
2: we will check memblock_reserve's return value

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 arch/x86/kernel/aperture_64.c |  3 +--
 arch/x86/kernel/setup.c       | 10 ++++------
 arch/x86/mm/init.c            |  3 +--
 arch/x86/mm/numa.c            |  3 +--
 arch/x86/mm/numa_emulation.c  |  3 +--
 arch/x86/realmode/init.c      |  3 +--
 drivers/acpi/osl.c            |  3 +--
 include/linux/memblock.h      |  4 ++++
 mm/memblock.c                 | 38 ++++++++++++++++++++------------------
 mm/nobootmem.c                |  3 +--
 10 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 1523e75..743a505 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -85,7 +85,7 @@ static u32 __init allocate_aperture(void)
 	 * memory. Unfortunately we cannot move it up because that would
 	 * make the IOMMU useless.
 	 */
-	addr = memblock_find_in_range(GART_MIN_ADDR, GART_MAX_ADDR - aper_size,
+	addr = memblock_alloc_in_range(GART_MIN_ADDR, GART_MAX_ADDR - aper_size,
 				      aper_size, aper_size);
 	if (!addr) {
 		printk(KERN_ERR
@@ -93,7 +93,6 @@ static u32 __init allocate_aperture(void)
 				addr, aper_size>>10);
 		return 0;
 	}
-	memblock_reserve(addr, aper_size);
 	printk(KERN_INFO "Mapping aperture over %d KB of RAM @ %lx\n",
 			aper_size >> 10, addr);
 	insert_aperture_resource((u32)addr, aper_size);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d60c85..163b716 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -329,7 +329,7 @@ static void __init relocate_initrd(void)
 	char *p, *q;
 
 	/* We need to move the initrd down into directly mapped mem */
-	ramdisk_here = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
+	ramdisk_here = memblock_alloc_in_range(0, PFN_PHYS(max_pfn_mapped),
 						 area_size, PAGE_SIZE);
 
 	if (!ramdisk_here)
@@ -338,7 +338,6 @@ static void __init relocate_initrd(void)
 
 	/* Note: this includes all the mem currently occupied by
 	   the initrd, we rely on that fact to keep the data intact. */
-	memblock_reserve(ramdisk_here, area_size);
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
@@ -529,7 +528,7 @@ static void __init reserve_crashkernel_low(void)
 	if (ret != 0 || low_size <= 0)
 		return;
 
-	low_base = memblock_find_in_range(low_size, (1ULL<<32),
+	low_base = memblock_alloc_in_range(low_size, (1ULL<<32),
 					low_size, alignment);
 
 	if (!low_base) {
@@ -538,7 +537,6 @@ static void __init reserve_crashkernel_low(void)
 		return;
 	}
 
-	memblock_reserve(low_base, low_size);
 	pr_info("Reserving %ldMB of low memory at %ldMB for crashkernel (System low RAM: %ldMB)\n",
 			(unsigned long)(low_size >> 20),
 			(unsigned long)(low_base >> 20),
@@ -568,7 +566,7 @@ static void __init reserve_crashkernel(void)
 		/*
 		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
-		crash_base = memblock_find_in_range(alignment,
+		crash_base = memblock_alloc_in_range(alignment,
 			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
 
 		if (!crash_base) {
@@ -581,8 +579,8 @@ static void __init reserve_crashkernel(void)
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
+		memblock_reserve(crash_base, crash_size);
 	}
-	memblock_reserve(crash_base, crash_size);
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 59b7fc4..4213503 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -54,12 +54,11 @@ __ref void *alloc_low_pages(unsigned int num)
 		unsigned long ret;
 		if (min_pfn_mapped >= max_pfn_mapped)
 			panic("alloc_low_page: ran out of memory");
-		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
+		ret = memblock_alloc_in_range(min_pfn_mapped << PAGE_SHIFT,
 					max_pfn_mapped << PAGE_SHIFT,
 					PAGE_SIZE * num , PAGE_SIZE);
 		if (!ret)
 			panic("alloc_low_page: can not alloc memory");
-		memblock_reserve(ret, PAGE_SIZE * num);
 		pfn = ret >> PAGE_SHIFT;
 	} else {
 		pfn = pgt_buf_end;
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 72fe01e..380bfe5 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -374,7 +374,7 @@ static int __init numa_alloc_distance(void)
 	cnt++;
 	size = cnt * cnt * sizeof(numa_distance[0]);
 
-	phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
+	phys = memblock_alloc_in_range(0, PFN_PHYS(max_pfn_mapped),
 				      size, PAGE_SIZE);
 	if (!phys) {
 		pr_warning("NUMA: Warning: can't allocate distance table!\n");
@@ -382,7 +382,6 @@ static int __init numa_alloc_distance(void)
 		numa_distance = (void *)1LU;
 		return -ENOMEM;
 	}
-	memblock_reserve(phys, size);
 
 	numa_distance = __va(phys);
 	numa_distance_cnt = cnt;
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index dbbbb47..71e24b1 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -357,13 +357,12 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	if (numa_dist_cnt) {
 		u64 phys;
 
-		phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
+		phys = memblock_alloc_in_range(0, PFN_PHYS(max_pfn_mapped),
 					      phys_size, PAGE_SIZE);
 		if (!phys) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
 			goto no_emu;
 		}
-		memblock_reserve(phys, phys_size);
 		phys_dist = __va(phys);
 
 		for (i = 0; i < numa_dist_cnt; i++)
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index a44f457..c3e1347 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -15,12 +15,11 @@ void __init reserve_real_mode(void)
 	size_t size = PAGE_ALIGN(real_mode_blob_end - real_mode_blob);
 
 	/* Has to be under 1M so we can execute real-mode AP code. */
-	mem = memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
+	mem = memblock_alloc_in_range(0, 1<<20, size, PAGE_SIZE);
 	if (!mem)
 		panic("Cannot allocate trampoline\n");
 
 	base = __va(mem);
-	memblock_reserve(mem, size);
 	real_mode_header = (struct real_mode_header *) base;
 	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
 	       base, (unsigned long long)mem, size);
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 586e7e9..b0d35c6 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -625,7 +625,7 @@ void __init acpi_initrd_override(void *data, size_t size)
 		return;
 
 	acpi_tables_addr =
-		memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
+		memblock_alloc_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
 				       all_tables_size, PAGE_SIZE);
 	if (!acpi_tables_addr) {
 		WARN_ON(1);
@@ -641,7 +641,6 @@ void __init acpi_initrd_override(void *data, size_t size)
 	 * Both memblock_reserve and e820_add_region (via arch_reserve_mem_area)
 	 * works fine.
 	 */
-	memblock_reserve(acpi_tables_addr, acpi_tables_addr + all_tables_size);
 	arch_reserve_mem_area(acpi_tables_addr, all_tables_size);
 
 	p = early_ioremap(acpi_tables_addr, all_tables_size);
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index f388203..e8431c1 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -50,6 +50,10 @@ phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
 				phys_addr_t size, phys_addr_t align, int nid);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
+phys_addr_t memblock_alloc_in_range_nid(phys_addr_t start, phys_addr_t end,
+					phys_addr_t size,phys_addr_t align, int nid);
+phys_addr_t memblock_alloc_in_range(phys_addr_t start, phys_addr_t end,
+					phys_addr_t size,phys_addr_t align);
 phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
diff --git a/mm/memblock.c b/mm/memblock.c
index b8d9147..90c07c3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -765,30 +765,14 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
-					phys_addr_t align, phys_addr_t max_addr,
-					int nid)
-{
-	phys_addr_t found;
-
-	/* align @size to avoid excessive fragmentation on reserved array */
-	size = round_up(size, align);
-
-	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
-	if (found && !memblock_reserve(found, size))
-		return found;
-
-	return 0;
-}
-
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
-	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+	return memblock_alloc_in_range_nid(0, MEMBLOCK_ALLOC_ACCESSIBLE, size, align, nid);
 }
 
 phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
-	return memblock_alloc_base_nid(size, align, max_addr, MAX_NUMNODES);
+	return memblock_alloc_in_range(0, max_addr, size, align);
 }
 
 phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
@@ -818,7 +802,25 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
 	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
+phys_addr_t __init memblock_alloc_in_range(phys_addr_t start, phys_addr_t end,
+					phys_addr_t size,phys_addr_t align)
+{
+	return memblock_alloc_in_range_nid(start, end, size, align, MAX_NUMNODES);
+}
+
+phys_addr_t __init memblock_alloc_in_range_nid(phys_addr_t start, phys_addr_t end,
+					phys_addr_t size,phys_addr_t align, int nid)
+{
+	phys_addr_t found;
+
+	size = round_up(size, align);
 
+	found = memblock_find_in_range_node(start, end, size, align, nid);
+	if (found && !memblock_reserve(found, size))
+		return found;
+
+	return 0;
+}
 /*
  * Remaining API functions
  */
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 5e07d36..305cf18 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -41,13 +41,12 @@ static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 	if (limit > memblock.current_limit)
 		limit = memblock.current_limit;
 
-	addr = memblock_find_in_range_node(goal, limit, size, align, nid);
+	addr = memblock_alloc_in_range_nid(goal, limit, size, align, nid);
 	if (!addr)
 		return NULL;
 
 	ptr = phys_to_virt(addr);
 	memset(ptr, 0, size);
-	memblock_reserve(addr, size);
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
 	 * are never reported as leaks.
-- 
1.7.12.4.dirty
