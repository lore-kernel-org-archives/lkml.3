Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643Ab3CHE74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:59:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43521 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513Ab3CHE7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 14/14] x86, mm: Put pagetable on local node ram
Date: Thu,  7 Mar 2013 20:58:40 -0800
Message-Id: <1362718720-27048-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If node with ram is hotplugable, local node mem for page table and vmemmap
should be on that node ram.

This patch is some kind of refreshment of
| commit 1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
| Date:   Mon Dec 27 16:48:17 2010 -0800
|
|    x86-64, numa: Put pgtable to local node memory
That was reverted before.

We have reason to reintroduce it to make memory hotplug work.

Split calling of init_mem_mapping into early_initmem_info
for nodes after we get numa info there.

First node will be low range.
Need to rework alloc_low_pages to alloc page table in following order:
	BRK, local node, low range

Still only load_cr3 one time, otherwise we would break xen 64bit again.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/pgtable.h |    2 +-
 arch/x86/kernel/setup.c        |    1 -
 arch/x86/mm/init.c             |   83 ++++++++++++++++++++++------------------
 arch/x86/mm/init_32.c          |    8 ++++
 arch/x86/mm/init_64.c          |    9 +++++
 arch/x86/mm/numa.c             |   56 +++++++++++++++++++++++++++
 6 files changed, 119 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 1e67223..868687c 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -621,7 +621,7 @@ static inline int pgd_none(pgd_t pgd)
 #ifndef __ASSEMBLY__
 
 extern int direct_gbpages;
-void init_mem_mapping(void);
+void init_mem_mapping(unsigned long begin, unsigned long end);
 void early_alloc_pgt_buf(void);
 
 /* local pte updates need not use xchg for locking */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 29a6b94..37d993f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1103,7 +1103,6 @@ void __init setup_arch(char **cmdline_p)
 	acpi_boot_table_init();
 	early_acpi_boot_init();
 	early_initmem_init();
-	init_mem_mapping();
 	memblock.current_limit = get_max_mapped();
 	early_trap_pf_init();
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index abcc241..2838bb5 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -24,7 +24,10 @@ static unsigned long __initdata pgt_buf_start;
 static unsigned long __initdata pgt_buf_end;
 static unsigned long __initdata pgt_buf_top;
 
-static unsigned long min_pfn_mapped;
+static unsigned long low_min_pfn_mapped;
+static unsigned long low_max_pfn_mapped;
+static unsigned long local_min_pfn_mapped;
+static unsigned long local_max_pfn_mapped;
 
 static bool __initdata can_use_brk_pgt = true;
 
@@ -52,10 +55,17 @@ __ref void *alloc_low_pages(unsigned int num)
 
 	if ((pgt_buf_end + num) > pgt_buf_top || !can_use_brk_pgt) {
 		unsigned long ret;
-		if (min_pfn_mapped >= max_pfn_mapped)
-			panic("alloc_low_page: ran out of memory");
-		ret = memblock_find_in_range(min_pfn_mapped << PAGE_SHIFT,
-					max_pfn_mapped << PAGE_SHIFT,
+		if (local_min_pfn_mapped >= local_max_pfn_mapped) {
+			if (low_min_pfn_mapped >= low_max_pfn_mapped)
+				panic("alloc_low_page: ran out of memory");
+			ret = memblock_find_in_range(
+					low_min_pfn_mapped << PAGE_SHIFT,
+					low_max_pfn_mapped << PAGE_SHIFT,
+					PAGE_SIZE * num , PAGE_SIZE);
+		} else
+			ret = memblock_find_in_range(
+					local_min_pfn_mapped << PAGE_SHIFT,
+					local_max_pfn_mapped << PAGE_SHIFT,
 					PAGE_SIZE * num , PAGE_SIZE);
 		if (!ret)
 			panic("alloc_low_page: can not alloc memory");
@@ -387,67 +397,64 @@ static unsigned long __init init_range_memory_mapping(
 
 /* (PUD_SHIFT-PMD_SHIFT)/2 */
 #define STEP_SIZE_SHIFT 5
-void __init init_mem_mapping(void)
+void __init init_mem_mapping(unsigned long begin, unsigned long end)
 {
-	unsigned long end, real_end, start, last_start;
+	unsigned long real_end, start, last_start;
 	unsigned long step_size;
 	unsigned long addr;
 	unsigned long mapped_ram_size = 0;
 	unsigned long new_mapped_ram_size;
+	bool is_low = false;
+
+	if (!begin) {
+		probe_page_size_mask();
+		/* the ISA range is always mapped regardless of memory holes */
+		init_memory_mapping(0, ISA_END_ADDRESS);
+		begin = ISA_END_ADDRESS;
+		is_low = true;
+	}
 
-	probe_page_size_mask();
-
-#ifdef CONFIG_X86_64
-	end = max_pfn << PAGE_SHIFT;
-#else
-	end = max_low_pfn << PAGE_SHIFT;
-#endif
-
-	/* the ISA range is always mapped regardless of memory holes */
-	init_memory_mapping(0, ISA_END_ADDRESS);
+	if (begin >= end)
+		return;
 
 	/* xen has big range in reserved near end of ram, skip it at first.*/
-	addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE, PMD_SIZE);
+	addr = memblock_find_in_range(begin, end, PMD_SIZE, PMD_SIZE);
 	real_end = addr + PMD_SIZE;
 
 	/* step_size need to be small so pgt_buf from BRK could cover it */
 	step_size = PMD_SIZE;
-	max_pfn_mapped = 0; /* will get exact value next */
-	min_pfn_mapped = real_end >> PAGE_SHIFT;
+	local_max_pfn_mapped = begin >> PAGE_SHIFT;
+	local_min_pfn_mapped = real_end >> PAGE_SHIFT;
 	last_start = start = real_end;
-	while (last_start > ISA_END_ADDRESS) {
+	while (last_start > begin) {
 		if (last_start > step_size) {
 			start = round_down(last_start - 1, step_size);
-			if (start < ISA_END_ADDRESS)
-				start = ISA_END_ADDRESS;
+			if (start < begin)
+				start = begin;
 		} else
-			start = ISA_END_ADDRESS;
+			start = begin;
 		new_mapped_ram_size = init_range_memory_mapping(start,
 							last_start);
+		if ((last_start >> PAGE_SHIFT) > local_max_pfn_mapped)
+			local_max_pfn_mapped = last_start >> PAGE_SHIFT;
+		local_min_pfn_mapped = start >> PAGE_SHIFT;
 		last_start = start;
-		min_pfn_mapped = last_start >> PAGE_SHIFT;
 		/* only increase step_size after big range get mapped */
 		if (new_mapped_ram_size > mapped_ram_size)
 			step_size <<= STEP_SIZE_SHIFT;
 		mapped_ram_size += new_mapped_ram_size;
 	}
 
-	if (real_end < end)
+	if (real_end < end) {
 		init_range_memory_mapping(real_end, end);
-
-#ifdef CONFIG_X86_64
-	if (max_pfn > max_low_pfn) {
-		/* can we preseve max_low_pfn ?*/
-		max_low_pfn = max_pfn;
+		if ((end >> PAGE_SHIFT) > local_max_pfn_mapped)
+			local_max_pfn_mapped = end >> PAGE_SHIFT;
 	}
-#else
-	early_ioremap_page_table_range_init();
-#endif
 
-	load_cr3(swapper_pg_dir);
-	__flush_tlb_all();
-
-	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
+	if (is_low) {
+		low_min_pfn_mapped = local_min_pfn_mapped;
+		low_max_pfn_mapped = local_max_pfn_mapped;
+	}
 }
 
 /*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3801962..37e5768 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -662,6 +662,14 @@ void __init find_low_pfn_range(void)
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 void __init early_initmem_init(void)
 {
+	init_mem_mapping(0, max_low_pfn<<PAGE_SHIFT);
+
+	early_ioremap_page_table_range_init();
+
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
+
+	early_memtest(0, max_pfn_mapped<<PAGE_SHIFT);
 }
 void __init initmem_init(void)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 218a4e5..a15db8a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -642,6 +642,15 @@ kernel_physical_mapping_init(unsigned long start,
 #ifndef CONFIG_NUMA
 void __init early_initmem_init(void)
 {
+	init_mem_mapping(0, max_pfn<<PAGE_SHIFT);
+
+	if (max_pfn > max_low_pfn)
+		max_low_pfn = max_pfn;
+
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
+
+	early_memtest(0, max_pfn_mapped<<PAGE_SHIFT);
 }
 void __init initmem_init(void)
 {
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 643b39a..0aeb980 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -17,8 +17,10 @@
 #include <asm/dma.h>
 #include <asm/acpi.h>
 #include <asm/amd_nb.h>
+#include <asm/tlbflush.h>
 
 #include "numa_internal.h"
+#include "mm_internal.h"
 
 int __initdata numa_off;
 nodemask_t numa_nodes_parsed __initdata;
@@ -673,9 +675,63 @@ static void __init early_x86_numa_init(void)
 	numa_init(dummy_numa_init);
 }
 
+#ifdef CONFIG_X86_64
+static void __init early_x86_numa_init_mapping(void)
+{
+	unsigned long last_start = 0, last_end = 0;
+	struct numa_meminfo *mi = &numa_meminfo;
+	unsigned long start, end;
+	int last_nid = -1;
+	int i, nid;
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		nid   = mi->blk[i].nid;
+		start = mi->blk[i].start;
+		end   = mi->blk[i].end;
+
+		if (last_nid == nid) {
+			last_end = end;
+			continue;
+		}
+
+		/* other nid now */
+		if (last_nid >= 0) {
+			printk(KERN_DEBUG "Node %d: [mem %#016lx-%#016lx]\n",
+					last_nid, last_start, last_end - 1);
+			init_mem_mapping(last_start, last_end);
+		}
+
+		/* for next nid */
+		last_nid   = nid;
+		last_start = start;
+		last_end   = end;
+	}
+	/* last one */
+	printk(KERN_DEBUG "Node %d: [mem %#016lx-%#016lx]\n",
+			last_nid, last_start, last_end - 1);
+	init_mem_mapping(last_start, last_end);
+
+	if (max_pfn > max_low_pfn)
+		max_low_pfn = max_pfn;
+}
+#else
+static void __init early_x86_numa_init_mapping(void)
+{
+	init_mem_mapping(0, max_low_pfn<<PAGE_SHIFT);
+	early_ioremap_page_table_range_init();
+}
+#endif
+
 void __init early_initmem_init(void)
 {
 	early_x86_numa_init();
+
+	early_x86_numa_init_mapping();
+
+	load_cr3(swapper_pg_dir);
+	__flush_tlb_all();
+
+	early_memtest(0, max_pfn_mapped<<PAGE_SHIFT);
 }
 
 void __init x86_numa_init(void)
-- 
1.7.10.4

