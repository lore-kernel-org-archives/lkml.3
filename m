Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaKFWlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaKFWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 049/162] sparc64: Use kernel page tables for vmemmap.
Date: Thu,  6 Nov 2014 14:35:13 -0800
Message-Id: <1415313426-9622-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit c06240c7f5c39c83dfd7849c0770775562441b96 ]

For sparse memory configurations, the vmemmap array behaves terribly
and it takes up an inordinate amount of space in the BSS section of
the kernel image unconditionally.

Just build huge PMDs and look them up just like we do for TLB misses
in the vmalloc area.

Kernel BSS shrinks by about 2MB.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/ktlb.S |  9 ++----
 arch/sparc/mm/init_64.c  | 72 +++++++++++++++++++++++-------------------------
 arch/sparc/mm/init_64.h  | 11 --------
 3 files changed, 36 insertions(+), 56 deletions(-)

diff --git a/arch/sparc/kernel/ktlb.S b/arch/sparc/kernel/ktlb.S
index 94a1e66..2627a7f 100644
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -186,13 +186,8 @@ kvmap_dtlb_load:
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 kvmap_vmemmap:
-	sub		%g4, %g5, %g5
-	srlx		%g5, ILOG2_4MB, %g5
-	sethi		%hi(vmemmap_table), %g1
-	sllx		%g5, 3, %g5
-	or		%g1, %lo(vmemmap_table), %g1
-	ba,pt		%xcc, kvmap_dtlb_load
-	 ldx		[%g1 + %g5], %g5
+	KERN_PGTABLE_WALK(%g4, %g5, %g2, kvmap_dtlb_longpath)
+	ba,a,pt		%xcc, kvmap_dtlb_load
 #endif
 
 kvmap_dtlb_nonlinear:
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 661a6383..75d26ee 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2254,18 +2254,9 @@ unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-unsigned long vmemmap_table[VMEMMAP_SIZE];
-
-static long __meminitdata addr_start, addr_end;
-static int __meminitdata node_start;
-
 int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 			       int node)
 {
-	unsigned long phys_start = (vstart - VMEMMAP_BASE);
-	unsigned long phys_end = (vend - VMEMMAP_BASE);
-	unsigned long addr = phys_start & VMEMMAP_CHUNK_MASK;
-	unsigned long end = VMEMMAP_ALIGN(phys_end);
 	unsigned long pte_base;
 
 	pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4U |
@@ -2276,47 +2267,52 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
 			    _PAGE_CP_4V | _PAGE_CV_4V |
 			    _PAGE_P_4V | _PAGE_W_4V);
 
-	for (; addr < end; addr += VMEMMAP_CHUNK) {
-		unsigned long *vmem_pp =
-			vmemmap_table + (addr >> VMEMMAP_CHUNK_SHIFT);
-		void *block;
+	pte_base |= _PAGE_PMD_HUGE;
 
-		if (!(*vmem_pp & _PAGE_VALID)) {
-			block = vmemmap_alloc_block(1UL << ILOG2_4MB, node);
-			if (!block)
+	vstart = vstart & PMD_MASK;
+	vend = ALIGN(vend, PMD_SIZE);
+	for (; vstart < vend; vstart += PMD_SIZE) {
+		pgd_t *pgd = pgd_offset_k(vstart);
+		unsigned long pte;
+		pud_t *pud;
+		pmd_t *pmd;
+
+		if (pgd_none(*pgd)) {
+			pud_t *new = vmemmap_alloc_block(PAGE_SIZE, node);
+
+			if (!new)
 				return -ENOMEM;
+			pgd_populate(&init_mm, pgd, new);
+		}
 
-			*vmem_pp = pte_base | __pa(block);
+		pud = pud_offset(pgd, vstart);
+		if (pud_none(*pud)) {
+			pmd_t *new = vmemmap_alloc_block(PAGE_SIZE, node);
 
-			/* check to see if we have contiguous blocks */
-			if (addr_end != addr || node_start != node) {
-				if (addr_start)
-					printk(KERN_DEBUG " [%lx-%lx] on node %d\n",
-					       addr_start, addr_end-1, node_start);
-				addr_start = addr;
-				node_start = node;
-			}
-			addr_end = addr + VMEMMAP_CHUNK;
+			if (!new)
+				return -ENOMEM;
+			pud_populate(&init_mm, pud, new);
 		}
-	}
-	return 0;
-}
 
-void __meminit vmemmap_populate_print_last(void)
-{
-	if (addr_start) {
-		printk(KERN_DEBUG " [%lx-%lx] on node %d\n",
-		       addr_start, addr_end-1, node_start);
-		addr_start = 0;
-		addr_end = 0;
-		node_start = 0;
+		pmd = pmd_offset(pud, vstart);
+
+		pte = pmd_val(*pmd);
+		if (!(pte & _PAGE_VALID)) {
+			void *block = vmemmap_alloc_block(PMD_SIZE, node);
+
+			if (!block)
+				return -ENOMEM;
+
+			pmd_val(*pmd) = pte_base | __pa(block);
+		}
 	}
+
+	return 0;
 }
 
 void vmemmap_free(unsigned long start, unsigned long end)
 {
 }
-
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void prot_init_common(unsigned long page_none,
diff --git a/arch/sparc/mm/init_64.h b/arch/sparc/mm/init_64.h
index 3ccbf92..ac49119 100644
--- a/arch/sparc/mm/init_64.h
+++ b/arch/sparc/mm/init_64.h
@@ -31,15 +31,4 @@ extern unsigned long kern_locked_tte_data;
 
 extern void prom_world(int enter);
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-#define VMEMMAP_CHUNK_SHIFT	22
-#define VMEMMAP_CHUNK		(1UL << VMEMMAP_CHUNK_SHIFT)
-#define VMEMMAP_CHUNK_MASK	~(VMEMMAP_CHUNK - 1UL)
-#define VMEMMAP_ALIGN(x)	(((x)+VMEMMAP_CHUNK-1UL)&VMEMMAP_CHUNK_MASK)
-
-#define VMEMMAP_SIZE	((((1UL << MAX_PHYSADDR_BITS) >> PAGE_SHIFT) * \
-			  sizeof(struct page)) >> VMEMMAP_CHUNK_SHIFT)
-extern unsigned long vmemmap_table[VMEMMAP_SIZE];
-#endif
-
 #endif /* _SPARC64_MM_INIT_H */
-- 
1.9.1

