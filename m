Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3HLT5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:57:13 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:27330 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3HLT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:56:51 -0400
Message-ID: <201308121956.r7CJuoS1010321@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 15:08:09 -0400
Subject: [PATCH] tile: add virt_to_kpte() API and clean up and document
 behavior
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use virt_to_pte(NULL, va) a lot, which isn't very obvious.
I added virt_to_kpte(va) as a more obvious wrapper function,
that also validates the va as being a kernel adddress.

And, I fixed the semantics of virt_to_pte() so that we handle
the pud and pmd the same way, and we now document the fact that
we handle the final pte level differently.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/mmu_context.h |  2 +-
 arch/tile/include/asm/page.h        |  1 +
 arch/tile/kernel/setup.c            |  6 +++---
 arch/tile/mm/homecache.c            |  6 +++---
 arch/tile/mm/init.c                 |  4 ++--
 arch/tile/mm/pgtable.c              | 22 ++++++++++++++++++++--
 6 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/tile/include/asm/mmu_context.h b/arch/tile/include/asm/mmu_context.h
index 37f0b74..4734215 100644
--- a/arch/tile/include/asm/mmu_context.h
+++ b/arch/tile/include/asm/mmu_context.h
@@ -45,7 +45,7 @@ static inline void __install_page_table(pgd_t *pgdir, int asid, pgprot_t prot)
 
 static inline void install_page_table(pgd_t *pgdir, int asid)
 {
-	pte_t *ptep = virt_to_pte(NULL, (unsigned long)pgdir);
+	pte_t *ptep = virt_to_kpte((unsigned long)pgdir);
 	__install_page_table(pgdir, asid, *ptep);
 }
 
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index 65ee752..84441b2 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -340,6 +340,7 @@ static inline int pfn_valid(unsigned long pfn)
 
 struct mm_struct;
 extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
+extern pte_t *virt_to_kpte(unsigned long kaddr);
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 2352a81..37a5b78 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1613,7 +1613,7 @@ void __init setup_per_cpu_areas(void)
 
 			/* Update the vmalloc mapping and page home. */
 			unsigned long addr = (unsigned long)ptr + i;
-			pte_t *ptep = virt_to_pte(NULL, addr);
+			pte_t *ptep = virt_to_kpte(addr);
 			pte_t pte = *ptep;
 			BUG_ON(pfn != pte_pfn(pte));
 			pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_TILE_L3);
@@ -1622,12 +1622,12 @@ void __init setup_per_cpu_areas(void)
 
 			/* Update the lowmem mapping for consistency. */
 			lowmem_va = (unsigned long)pfn_to_kaddr(pfn);
-			ptep = virt_to_pte(NULL, lowmem_va);
+			ptep = virt_to_kpte(lowmem_va);
 			if (pte_huge(*ptep)) {
 				printk(KERN_DEBUG "early shatter of huge page"
 				       " at %#lx\n", lowmem_va);
 				shatter_pmd((pmd_t *)ptep);
-				ptep = virt_to_pte(NULL, lowmem_va);
+				ptep = virt_to_kpte(lowmem_va);
 				BUG_ON(pte_huge(*ptep));
 			}
 			BUG_ON(pfn != pte_pfn(*ptep));
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index df46a2d..e3ee55b 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -200,7 +200,7 @@ void homecache_finv_map_page(struct page *page, int home)
 #else
 	va = __fix_to_virt(FIX_HOMECACHE_BEGIN + smp_processor_id());
 #endif
-	ptep = virt_to_pte(NULL, (unsigned long)va);
+	ptep = virt_to_kpte(va);
 	pte = pfn_pte(page_to_pfn(page), PAGE_KERNEL);
 	__set_pte(ptep, pte_set_home(pte, home));
 	homecache_finv_page_va((void *)va, home);
@@ -385,7 +385,7 @@ int page_home(struct page *page)
 		return initial_page_home();
 	} else {
 		unsigned long kva = (unsigned long)page_address(page);
-		return pte_to_home(*virt_to_pte(NULL, kva));
+		return pte_to_home(*virt_to_kpte(kva));
 	}
 }
 EXPORT_SYMBOL(page_home);
@@ -404,7 +404,7 @@ void homecache_change_page_home(struct page *page, int order, int home)
 		     NULL, 0);
 
 	for (i = 0; i < pages; ++i, kva += PAGE_SIZE) {
-		pte_t *ptep = virt_to_pte(NULL, kva);
+		pte_t *ptep = virt_to_kpte(kva);
 		pte_t pteval = *ptep;
 		BUG_ON(!pte_present(pteval) || pte_huge(pteval));
 		__set_pte(ptep, pte_set_home(pteval, home));
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index c6d2160..c8f58c1 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -951,7 +951,7 @@ static void mark_w1data_ro(void)
 	BUG_ON((addr & (PAGE_SIZE-1)) != 0);
 	for (; addr <= (unsigned long)__w1data_end - 1; addr += PAGE_SIZE) {
 		unsigned long pfn = kaddr_to_pfn((void *)addr);
-		pte_t *ptep = virt_to_pte(NULL, addr);
+		pte_t *ptep = virt_to_kpte(addr);
 		BUG_ON(pte_huge(*ptep));   /* not relevant for kdata_huge */
 		set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, PAGE_KERNEL_RO));
 	}
@@ -997,7 +997,7 @@ static void free_init_pages(char *what, unsigned long begin, unsigned long end)
 		 */
 		int pfn = kaddr_to_pfn((void *)addr);
 		struct page *page = pfn_to_page(pfn);
-		pte_t *ptep = virt_to_pte(NULL, addr);
+		pte_t *ptep = virt_to_kpte(addr);
 		if (!initfree) {
 			/*
 			 * If debugging page accesses then do not free
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index d6948d4..33b006a 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -325,6 +325,17 @@ void ptep_set_wrprotect(struct mm_struct *mm,
 
 #endif
 
+/*
+ * Return a pointer to the PTE that corresponds to the given
+ * address in the given page table.  A NULL page table just uses
+ * the standard kernel page table; the preferred API in this case
+ * is virt_to_kpte().
+ *
+ * The returned pointer can point to a huge page in other levels
+ * of the page table than the bottom, if the huge page is present
+ * in the page table.  For bottom-level PTEs, the returned pointer
+ * can point to a PTE that is either present or not.
+ */
 pte_t *virt_to_pte(struct mm_struct* mm, unsigned long addr)
 {
 	pgd_t *pgd;
@@ -341,14 +352,21 @@ pte_t *virt_to_pte(struct mm_struct* mm, unsigned long addr)
 	if (pud_huge_page(*pud))
 		return (pte_t *)pud;
 	pmd = pmd_offset(pud, addr);
-	if (pmd_huge_page(*pmd))
-		return (pte_t *)pmd;
 	if (!pmd_present(*pmd))
 		return NULL;
+	if (pmd_huge_page(*pmd))
+		return (pte_t *)pmd;
 	return pte_offset_kernel(pmd, addr);
 }
 EXPORT_SYMBOL(virt_to_pte);
 
+pte_t *virt_to_kpte(unsigned long kaddr)
+{
+	BUG_ON(kaddr < PAGE_OFFSET);
+	return virt_to_pte(NULL, kaddr);
+}
+EXPORT_SYMBOL(virt_to_kpte);
+
 pgprot_t set_remote_cache_cpu(pgprot_t prot, int cpu)
 {
 	unsigned int width = smp_width;
-- 
1.8.3.1

