Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaKSOVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:21:52 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53564 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaKSOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:21:50 -0500
From: zhichang.yuan@linaro.org
To: will.deacon@arm.com, Catalin.Marinas@arm.com,
        linux-arm-kernel@lists.infradead.org
Cc: linuxarm@huawei.com, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        "zhichang.yuan" <zhichang.yuan@linaro.org>
Subject: [RFC PATCH v1] arm64:mm: An optimization about kernel direct sapce mapping
Date: Wed, 19 Nov 2014 22:21:55 +0800
Message-Id: <1416406915-10939-1-git-send-email-zhichang.yuan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhichang.yuan" <zhichang.yuan@linaro.org>

This patch make the processing of map_mem more common and support more
discrete memory layout cases.

In current map_mem, the processing is based on two hypotheses:
1) no any early page allocations occur before the first PMD or PUD regime
where the kernel image locate is successfully mapped;
2) there are sufficient available pages in the PMD or PUD regime to satisfy
the need of page tables from other memory ranges mapping.

The current SOC or hardware platform designs had not broken this constraint.
But we can make the software more versatile.

In addition, for the 4K page system, to comply with the constraint No.1, the
start address of some memory ranges is forced to align at PMD boundary, it
will make some marginal pages of that ranges are skipped to build the PTE. It
is not reasonable.

This patch will relieve the system from those constraints. You can load the
kernel image in any memory range, the memory range can be small, can start at
non-alignment boundary, and so on.

In this patch, the kernel space mapping will probably scan all memory ranges
twice. In the first scanning, those memory ranges whose size is larger than a
threshold are mapped, then the second scanning will map the smaller memory
ranges. Since the threshold is so small, in most cases, the second scanning is
NULL operation.

The patch is also accessible @
https://git.linaro.org/people/zhichang.yuan/pgalloc.git/shortlog/refs/heads/mapmem_linux_master

Signed-off-by: Zhichang Yuan <zhichang.yuan@linaro.org>
---
 arch/arm64/include/asm/page.h    |   10 ++
 arch/arm64/include/asm/pgtable.h |    3 +
 arch/arm64/kernel/vmlinux.lds.S  |    4 +
 arch/arm64/mm/mmu.c              |  230 ++++++++++++++++++++++++++++++++------
 include/linux/memblock.h         |    5 +
 5 files changed, 217 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 22b1623..7c55e11 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -44,6 +44,16 @@
 #define SWAPPER_DIR_SIZE	(SWAPPER_PGTABLE_LEVELS * PAGE_SIZE)
 #define IDMAP_DIR_SIZE		(SWAPPER_DIR_SIZE)
 
+/*This macro has strong dependency with BLOCK_SIZE in head.S...*/
+#ifdef CONFIG_ARM64_64K_PAGES
+#define INIT_MAP_PGSZ	(PAGE_SIZE)
+/*we prepare one more page for probable memblock space extension*/
+#define PGT_BRK_SIZE	((SWAPPER_PGTABLE_LEVELS) << PAGE_SHIFT)
+#else
+#define INIT_MAP_PGSZ	(SECTION_SIZE)
+#define PGT_BRK_SIZE	((SWAPPER_PGTABLE_LEVELS + 1) << PAGE_SHIFT)
+#endif
+
 #ifndef __ASSEMBLY__
 
 #include <asm/pgtable-types.h>
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 41a43bf..9f96c6c 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -464,6 +464,9 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 
+/*define for kernel direct space mapping*/
+extern char pgtbrk_base[], pgtbrk_end[];
+
 /*
  * Encode and decode a swap entry:
  *	bits 0-1:	present (must be zero)
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index edf8715..ca5b69c 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -113,6 +113,10 @@ SECTIONS
 	swapper_pg_dir = .;
 	. += SWAPPER_DIR_SIZE;
 
+	pgtbrk_base = .;
+	. += PGT_BRK_SIZE;
+	pgtbrk_end = .;
+
 	_end = .;
 
 	STABS_DEBUG
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f4f8b50..e56fbc8 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -67,6 +67,12 @@ static struct cachepolicy cache_policies[] __initdata = {
 };
 
 /*
+ * points to the specific brk regions. Those pages can be allocated for
+ * page tables usage.
+ */
+static unsigned long pgtbrk_sp = (unsigned long)pgtbrk_base;
+
+/*
  * These are useful for identifying cache coherency problems by allowing the
  * cache or the cache and writebuffer to be turned off. It changes the Normal
  * memory caching attributes in the MAIR_EL1 register.
@@ -131,7 +137,18 @@ EXPORT_SYMBOL(phys_mem_access_prot);
 
 static void __init *early_alloc(unsigned long sz)
 {
-	void *ptr = __va(memblock_alloc(sz, sz));
+	void *ptr;
+
+	if (!(sz & (~PAGE_MASK)) &&
+			pgtbrk_sp + sz <= (unsigned long)pgtbrk_end) {
+		ptr = (void *)pgtbrk_sp;
+		pgtbrk_sp += sz;
+		pr_info("BRK [0x%p, 0x%lx] PGTABLE\n",	ptr, pgtbrk_sp);
+
+	} else {
+		ptr = __va(memblock_alloc(sz, sz));
+	}
+
 	memset(ptr, 0, sz);
 	return ptr;
 }
@@ -287,52 +304,195 @@ void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
 			 addr, addr, size, map_io);
 }
 
+/*
+* In the worst case, mapping one memory range or sub-range will comsume
+* MIN_MAP_INCRSZ pages. To garentee there are sufficient mapped pages
+* for the ranges to be mapped, it is priority to map those range that can
+* supply available pages over this macro value.
+* For 64K, one page less than SWAPPER_PGTABLE_LEVELS;
+* For 4K, SWAPPER_PGTABLE_LEVELS pages
+*/
+#ifdef CONFIG_ARM64_64K_PAGES
+#define MIN_MAP_INCRSZ		((SWAPPER_PGTABLE_LEVELS - 1) << PAGE_SHIFT)
+#else
+#define MIN_MAP_INCRSZ		(SWAPPER_PGTABLE_LEVELS << PAGE_SHIFT)
+#endif
+
+static inline void __init map_cont_memseg(phys_addr_t start,
+				phys_addr_t end, phys_addr_t *plimit)
+{
+	create_mapping(start, __phys_to_virt(start), end - start);
+	if (*plimit < end) {
+		*plimit = end;
+		memblock_set_current_limit(end);
+	}
+}
+
+/*
+* This function will map the designated memory range. If successfully do
+* the mapping, will update the current_limit as the maximal mapped address.
+*
+* each mapped memory range should at least supply (SWAPPER_PGTABLE_LEVELS - 1)
+* new mapped pages for the next range. Otherwise, that range should be reserved
+* for delay mapping.
+* The memory range will probably be divided into several sub-ranges.
+* The division will occur at the PMD, PUD boundaries.
+* In the worst case, one sub-range will spend (SWAPPER_PGTABLE_LEVELS - 1)
+* pages as page tables, we firstly map the sub-range that can provide enough
+* pages for the remaining sub-ranges.
+*/
+static size_t __init map_onerng_reverse(phys_addr_t start,
+			phys_addr_t end, phys_addr_t *plimit)
+{
+	phys_addr_t blk_start, blk_end;
+	phys_addr_t delimit = 0;
+
+	blk_start = round_up(start, PMD_SIZE);
+	blk_end = round_down(end, PMD_SIZE);
+
+	/*
+	* first case: start and end are spread in adjacent PMD
+	* second case: start and end are separated by at least one PMD
+	* third case: start and end are in same PMD
+	*/
+	if (blk_start == blk_end &&
+			blk_start != start && blk_end != end) {
+		delimit = blk_start;
+		/*blk_start is the minimum, blk_end is the maximum*/
+		if (end - delimit >= delimit - start) {
+			blk_end = end - delimit;
+			blk_start = delimit - start;
+		} else {
+			blk_end = delimit - start;
+			blk_start = end - delimit;
+		}
+		/*both sub-ranges can supply enough pages*/
+		if (blk_start >= MIN_MAP_INCRSZ) {
+			map_cont_memseg(delimit, end, plimit);
+			map_cont_memseg(start, delimit, plimit);
+		} else if (blk_end >= (MIN_MAP_INCRSZ << 1)) {
+			if (blk_end == end - delimit) {
+				map_cont_memseg(delimit, end, plimit);
+				map_cont_memseg(start, delimit, plimit);
+			} else {
+				map_cont_memseg(start, delimit, plimit);
+				map_cont_memseg(delimit, end, plimit);
+			}
+		} else
+			return 0;
+	} else if (blk_start < blk_end) {
+		/*
+		* In one PUD regime, only can mapping the sub-range that has
+		* one non-PMD alignment edge at most. Otherwise, the mapping
+		* will probably consume over MIN_MAP_INCRSZ space.
+		*/
+		phys_addr_t pud_start, pud_end;
+
+		pud_end = round_down(blk_end, PUD_SIZE);
+		pud_start = round_up(blk_start, PUD_SIZE);
+		/*first case: [blk_start, blk_end) spread in adjacent PUD */
+		if ((pud_start == pud_end) &&
+				pud_start != blk_start && pud_end != blk_end)
+			delimit = (blk_end > pud_end) ?
+					(blk_end = end, pud_end) : blk_start;
+		else if (pud_start < pud_end)
+			/*spread among multiple PUD*/
+			delimit = (blk_end > pud_end) ?
+					(blk_end = end, pud_end) : pud_start;
+		else {
+			/*
+			* spread in same PUD:
+			* if blk_end aligns to PUD boundary, mapping of
+			* [start,blk_end) should has higher priority.
+			*/
+			blk_end = (blk_end & ~PUD_MASK) ? end : blk_end;
+			delimit = ((blk_start & ~PUD_MASK) && !(blk_end & ~PMD_MASK)) ?
+					start : blk_start;
+		}
+		/*adjust the blk_end, try to map a bigger memory range*/
+		if (end - blk_end >= MIN_MAP_INCRSZ)
+			blk_end = end;
+
+		map_cont_memseg(delimit, blk_end, plimit);
+		/*
+		* now, at least one PMD was mapped. sufficient pages is ready
+		* for mapping the remaining sub-ranges.
+		*/
+		if (blk_end < end)
+			map_cont_memseg(blk_end, end, plimit);
+		if (start < delimit)
+			map_cont_memseg(start, delimit, plimit);
+	} else {
+		if (end - start < MIN_MAP_INCRSZ)
+			return 0;
+		map_cont_memseg(start, end, plimit);
+	}
+
+	return end - start;
+}
+
+
 static void __init map_mem(void)
 {
 	struct memblock_region *reg;
-	phys_addr_t limit;
 
-	/*
-	 * Temporarily limit the memblock range. We need to do this as
-	 * create_mapping requires puds, pmds and ptes to be allocated from
-	 * memory addressable from the initial direct kernel mapping.
-	 *
-	 * The initial direct kernel mapping, located at swapper_pg_dir, gives
-	 * us PUD_SIZE (4K pages) or PMD_SIZE (64K pages) memory starting from
-	 * PHYS_OFFSET (which must be aligned to 2MB as per
-	 * Documentation/arm64/booting.txt).
-	 */
-	if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
-		limit = PHYS_OFFSET + PMD_SIZE;
-	else
-		limit = PHYS_OFFSET + PUD_SIZE;
-	memblock_set_current_limit(limit);
+	size_t incr;
+	size_t mapped_sz = 0;
+	phys_addr_t limit = 0;
 
-	/* map all the memory banks */
-	for_each_memblock(memory, reg) {
-		phys_addr_t start = reg->base;
-		phys_addr_t end = start + reg->size;
+	phys_addr_t start, end;
 
-		if (start >= end)
+	/*set current_limit as the maximum addr mapped in head.S*/
+	limit = round_up(__pa_symbol(_end), INIT_MAP_PGSZ);
+	memblock_set_current_limit(limit);
+
+	for_each_memblock_reverse(memory, reg) {
+		start = reg->base;
+		end = start + reg->size;
+		/*
+		* the range does not cover even one page is invalid.
+		* wrap-wroud is invalid too.
+		*/
+		if (PFN_UP(start) >= PFN_DOWN(end))
 			break;
 
-#ifndef CONFIG_ARM64_64K_PAGES
+		incr = map_onerng_reverse(start, end, &limit);
 		/*
-		 * For the first memory bank align the start address and
-		 * current memblock limit to prevent create_mapping() from
-		 * allocating pte page tables from unmapped memory.
-		 * When 64K pages are enabled, the pte page table for the
-		 * first PGDIR_SIZE is already present in swapper_pg_dir.
-		 */
-		if (start < limit)
-			start = ALIGN(start, PMD_SIZE);
-		if (end < limit) {
-			limit = end & PMD_MASK;
-			memblock_set_current_limit(limit);
+		* if CONFIG_HAVE_MEMBLOCK_NODE_MAP is support in future,need
+		* to change the input parameter of nid.
+		* incr is Zero means the range is too small that can not map
+		* in this scanning. In avoid to be allocated by memblock APIs,
+		* temporarily reserve this range and set the flag in
+		* memblock.memory for the second scanning.
+		*/
+		if (!incr) {
+			memblock_add_range(&memblock.reserved, reg->base,
+				reg->size, NUMA_NO_NODE, reg->flags);
+			memblock_set_region_flags(reg, MEMBLOCK_TMP_UNMAP);
+		} else {
+			mapped_sz += incr;
 		}
-#endif
+	}
+	/*
+	* The second scanning. Supposed there are large memory ranges,
+	* after the first scanning, those large memory ranges were mapped,
+	* and supply sufficient pages to map the remaining small ranges.
+	*/
+	for_each_memblock(memory, reg) {
+		if (!(reg->flags & MEMBLOCK_TMP_UNMAP))
+			continue;
+
+		start = reg->base;
+		end = start + reg->size;
+
+		if (PFN_UP(start) >= PFN_DOWN(end))
+			break;
 
 		create_mapping(start, __phys_to_virt(start), end - start);
+		memblock_clear_region_flags(reg, MEMBLOCK_TMP_UNMAP);
+
+		memblock_remove_range(&memblock.reserved, reg->base,
+			reg->size);
 	}
 
 	/* Limit no longer required. */
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index e8cc453..4c09f7c 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -22,6 +22,7 @@
 
 /* Definition of memblock flags. */
 #define MEMBLOCK_HOTPLUG	0x1	/* hotpluggable region */
+#define MEMBLOCK_TMP_UNMAP	0x2	/* can not be mapped in first scan*/
 
 struct memblock_region {
 	phys_addr_t base;
@@ -356,6 +357,10 @@ static inline unsigned long memblock_region_reserved_end_pfn(const struct memblo
 	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
 	     region++)
 
+#define for_each_memblock_reverse(memblock_type, region)					\
+		for (region = memblock.memblock_type.regions + memblock.memblock_type.cnt - 1;	\
+		     region >= memblock.memblock_type.regions;	\
+		     region--)
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
 #define __init_memblock __meminit
-- 
1.7.9.5

