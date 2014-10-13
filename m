Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaJMHnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:43:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55765 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaJMHnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:43:42 -0400
Date: Mon, 13 Oct 2014 09:43:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm tree changes for v3.18
Message-ID: <20141013074336.GA15282@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   # HEAD: beb9147e95a75f41c984d7235cf6d59f3ca2d5db x86/mm: Update memory map description to list hypervisor-reserved area

This tree includes the following changes:

 - Fix memory hotplug
 - Fix hibernation bootup memory layout assumptions
 - Fix hyperv numa guest kernel messages
 - Remove dead code
 - Update documentation

  out-of-topic modifications in x86-mm-for-linus:
  -------------------------------------------------
  mm/page_alloc.c                    # 8b375f64dcf4: x86/mm/numa: Drop dead code 

 Thanks,

	Ingo

------------------>
Dave Hansen (1):
      x86/mm: Update memory map description to list hypervisor-reserved area

Lee, Chun-Yi (1):
      x86/mm, hibernate: Do not assume the first e820 area to be RAM

Luiz Capitulino (1):
      x86/mm/numa: Drop dead code and rename setup_node_data() to setup_alloc_data()

Matthew Wilcox (1):
      x86: Remove set_pmd_pfn

Yasuaki Ishimatsu (2):
      x86/mm/hotplug: Pass sync_global_pgds() a correct argument in remove_pagetable()
      x86/mm/hotplug: Modify PGD entry when removing memory


 Documentation/x86/x86_64/mm.txt   |  2 +-
 arch/x86/include/asm/numa.h       |  1 -
 arch/x86/include/asm/pgtable_32.h |  3 ---
 arch/x86/include/asm/pgtable_64.h |  3 ++-
 arch/x86/kernel/e820.c            |  7 +++----
 arch/x86/mm/fault.c               |  2 +-
 arch/x86/mm/init_64.c             | 36 ++++++++++++++++++++++++------------
 arch/x86/mm/numa.c                | 34 ++++++++++++++--------------------
 arch/x86/mm/pgtable_32.c          | 35 -----------------------------------
 mm/page_alloc.c                   |  2 ++
 10 files changed, 47 insertions(+), 78 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index afe68ddbe6a4..052ee643a32e 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -5,7 +5,7 @@
 
 0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm
 hole caused by [48:63] sign extension
-ffff800000000000 - ffff80ffffffffff (=40 bits) guard hole
+ffff800000000000 - ffff87ffffffffff (=43 bits) guard hole, reserved for hypervisor
 ffff880000000000 - ffffc7ffffffffff (=64 TB) direct mapping of all phys. memory
 ffffc80000000000 - ffffc8ffffffffff (=40 bits) hole
 ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 4064acae625d..01b493e5a99b 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -9,7 +9,6 @@
 #ifdef CONFIG_NUMA
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
-#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
 /*
  * Too small node sizes may confuse the VM badly. Usually they
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 9ee322103c6d..b6c0b404898a 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -32,9 +32,6 @@ static inline void pgtable_cache_init(void) { }
 static inline void check_pgt_cache(void) { }
 void paging_init(void);
 
-extern void set_pmd_pfn(unsigned long, unsigned long, pgprot_t);
-
-
 /*
  * Define this if things work differently on an i386 and an i486:
  * it will (on an i486) warn about kernel memory accesses that are
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 5be9063545d2..809abb335627 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -115,7 +115,8 @@ static inline void native_pgd_clear(pgd_t *pgd)
 	native_set_pgd(pgd, native_make_pgd(0));
 }
 
-extern void sync_global_pgds(unsigned long start, unsigned long end);
+extern void sync_global_pgds(unsigned long start, unsigned long end,
+			     int removed);
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 988c00a1f60d..49f886481615 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -682,15 +682,14 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
  * hibernation (32 bit) or software suspend and suspend to RAM (64 bit).
  *
  * This function requires the e820 map to be sorted and without any
- * overlapping entries and assumes the first e820 area to be RAM.
+ * overlapping entries.
  */
 void __init e820_mark_nosave_regions(unsigned long limit_pfn)
 {
 	int i;
-	unsigned long pfn;
+	unsigned long pfn = 0;
 
-	pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
-	for (i = 1; i < e820.nr_map; i++) {
+	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 
 		if (pfn < PFN_UP(ei->addr))
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a24194681513..d393ac669cc0 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -350,7 +350,7 @@ static void dump_pagetable(unsigned long address)
 
 void vmalloc_sync_all(void)
 {
-	sync_global_pgds(VMALLOC_START & PGDIR_MASK, VMALLOC_END);
+	sync_global_pgds(VMALLOC_START & PGDIR_MASK, VMALLOC_END, 0);
 }
 
 /*
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5621c47d7a1a..529625118ff6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -178,7 +178,7 @@ __setup("noexec32=", nonx32_setup);
  * When memory was added/removed make sure all the processes MM have
  * suitable PGD entries in the local PGD level page.
  */
-void sync_global_pgds(unsigned long start, unsigned long end)
+void sync_global_pgds(unsigned long start, unsigned long end, int removed)
 {
 	unsigned long address;
 
@@ -186,7 +186,12 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 		const pgd_t *pgd_ref = pgd_offset_k(address);
 		struct page *page;
 
-		if (pgd_none(*pgd_ref))
+		/*
+		 * When it is called after memory hot remove, pgd_none()
+		 * returns true. In this case (removed == 1), we must clear
+		 * the PGD entries in the local PGD level page.
+		 */
+		if (pgd_none(*pgd_ref) && !removed)
 			continue;
 
 		spin_lock(&pgd_lock);
@@ -199,12 +204,18 @@ void sync_global_pgds(unsigned long start, unsigned long end)
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 			spin_lock(pgt_lock);
 
-			if (pgd_none(*pgd))
-				set_pgd(pgd, *pgd_ref);
-			else
+			if (!pgd_none(*pgd_ref) && !pgd_none(*pgd))
 				BUG_ON(pgd_page_vaddr(*pgd)
 				       != pgd_page_vaddr(*pgd_ref));
 
+			if (removed) {
+				if (pgd_none(*pgd_ref) && !pgd_none(*pgd))
+					pgd_clear(pgd);
+			} else {
+				if (pgd_none(*pgd))
+					set_pgd(pgd, *pgd_ref);
+			}
+
 			spin_unlock(pgt_lock);
 		}
 		spin_unlock(&pgd_lock);
@@ -633,7 +644,7 @@ kernel_physical_mapping_init(unsigned long start,
 	}
 
 	if (pgd_changed)
-		sync_global_pgds(addr, end - 1);
+		sync_global_pgds(addr, end - 1, 0);
 
 	__flush_tlb_all();
 
@@ -976,25 +987,26 @@ static void __meminit
 remove_pagetable(unsigned long start, unsigned long end, bool direct)
 {
 	unsigned long next;
+	unsigned long addr;
 	pgd_t *pgd;
 	pud_t *pud;
 	bool pgd_changed = false;
 
-	for (; start < end; start = next) {
-		next = pgd_addr_end(start, end);
+	for (addr = start; addr < end; addr = next) {
+		next = pgd_addr_end(addr, end);
 
-		pgd = pgd_offset_k(start);
+		pgd = pgd_offset_k(addr);
 		if (!pgd_present(*pgd))
 			continue;
 
 		pud = (pud_t *)pgd_page_vaddr(*pgd);
-		remove_pud_table(pud, start, next, direct);
+		remove_pud_table(pud, addr, next, direct);
 		if (free_pud_table(pud, pgd))
 			pgd_changed = true;
 	}
 
 	if (pgd_changed)
-		sync_global_pgds(start, end - 1);
+		sync_global_pgds(start, end - 1, 1);
 
 	flush_tlb_all();
 }
@@ -1341,7 +1353,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node)
 	else
 		err = vmemmap_populate_basepages(start, end, node);
 	if (!err)
-		sync_global_pgds(start, end - 1);
+		sync_global_pgds(start, end - 1, 0);
 	return err;
 }
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index a32b706c401a..d221374d5ce8 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -185,8 +185,8 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
 
-/* Initialize NODE_DATA for a node on the local memory */
-static void __init setup_node_data(int nid, u64 start, u64 end)
+/* Allocate NODE_DATA for a node on the local memory */
+static void __init alloc_node_data(int nid)
 {
 	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	u64 nd_pa;
@@ -194,18 +194,6 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	int tnid;
 
 	/*
-	 * Don't confuse VM with a node that doesn't have the
-	 * minimum amount of memory:
-	 */
-	if (end && (end - start) < NODE_MIN_SIZE)
-		return;
-
-	start = roundup(start, ZONE_ALIGN);
-
-	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n",
-	       nid, start, end - 1);
-
-	/*
 	 * Allocate node data.  Try node-local memory and then any node.
 	 * Never allocate in DMA zone.
 	 */
@@ -222,7 +210,7 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	nd = __va(nd_pa);
 
 	/* report and initialize */
-	printk(KERN_INFO "  NODE_DATA [mem %#010Lx-%#010Lx]\n",
+	printk(KERN_INFO "NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
 	       nd_pa, nd_pa + nd_size - 1);
 	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
 	if (tnid != nid)
@@ -230,9 +218,6 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 
 	node_data[nid] = nd;
 	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
-	NODE_DATA(nid)->node_id = nid;
-	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
-	NODE_DATA(nid)->node_spanned_pages = (end - start) >> PAGE_SHIFT;
 
 	node_set_online(nid);
 }
@@ -523,8 +508,17 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 			end = max(mi->blk[i].end, end);
 		}
 
-		if (start < end)
-			setup_node_data(nid, start, end);
+		if (start >= end)
+			continue;
+
+		/*
+		 * Don't confuse VM with a node that doesn't have the
+		 * minimum amount of memory:
+		 */
+		if (end && (end - start) < NODE_MIN_SIZE)
+			continue;
+
+		alloc_node_data(nid);
 	}
 
 	/* Dump memblock with node info and return. */
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 4dd8cf652579..75cc0978d45d 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -59,41 +59,6 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 	__flush_tlb_one(vaddr);
 }
 
-/*
- * Associate a large virtual page frame with a given physical page frame 
- * and protection flags for that frame. pfn is for the base of the page,
- * vaddr is what the page gets mapped to - both must be properly aligned. 
- * The pmd must already be instantiated. Assumes PAE mode.
- */ 
-void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	if (vaddr & (PMD_SIZE-1)) {		/* vaddr is misaligned */
-		printk(KERN_WARNING "set_pmd_pfn: vaddr misaligned\n");
-		return; /* BUG(); */
-	}
-	if (pfn & (PTRS_PER_PTE-1)) {		/* pfn is misaligned */
-		printk(KERN_WARNING "set_pmd_pfn: pfn misaligned\n");
-		return; /* BUG(); */
-	}
-	pgd = swapper_pg_dir + pgd_index(vaddr);
-	if (pgd_none(*pgd)) {
-		printk(KERN_WARNING "set_pmd_pfn: pgd_none\n");
-		return; /* BUG(); */
-	}
-	pud = pud_offset(pgd, vaddr);
-	pmd = pmd_offset(pud, vaddr);
-	set_pmd(pmd, pfn_pmd(pfn, flags));
-	/*
-	 * It's enough to flush this one mapping.
-	 * (PGE mappings get flushed as well)
-	 */
-	__flush_tlb_one(vaddr);
-}
-
 unsigned long __FIXADDR_TOP = 0xfffff000;
 EXPORT_SYMBOL(__FIXADDR_TOP);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 18cee0d4c8a2..d0e3d2fee585 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4976,6 +4976,8 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 	pgdat->node_start_pfn = node_start_pfn;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n", nid,
+			(u64) start_pfn << PAGE_SHIFT, (u64) (end_pfn << PAGE_SHIFT) - 1);
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
