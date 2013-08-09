Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031200Ab3HIVBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:01:16 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:26151 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031145Ab3HIVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:00:03 -0400
Message-ID: <201308092100.r79L02nI011266@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 16:17:03 -0400
Subject: [PATCH] tile: remove set/clear_fixmap APIs
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing in the codebase was using them, and as written they took
"unsigned long" as the physical address rather than "phys_addr_t",
which is wrong on tilepro anyway.  Rather than fixing stale APIs,
just remove them; if there's ever demand for them on this platform,
we can put them back.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/fixmap.h |  8 -------
 arch/tile/mm/init.c            |  5 +----
 arch/tile/mm/pgtable.c         | 49 ------------------------------------------
 3 files changed, 1 insertion(+), 61 deletions(-)

diff --git a/arch/tile/include/asm/fixmap.h b/arch/tile/include/asm/fixmap.h
index e16dbf9..c6b9c1b 100644
--- a/arch/tile/include/asm/fixmap.h
+++ b/arch/tile/include/asm/fixmap.h
@@ -78,14 +78,6 @@ enum fixed_addresses {
 #endif
 };
 
-extern void __set_fixmap(enum fixed_addresses idx,
-			 unsigned long phys, pgprot_t flags);
-
-#define set_fixmap(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL)
-#define clear_fixmap(idx) \
-		__set_fixmap(idx, 0, __pgprot(0))
-
 #define __FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
 #define __FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START		(FIXADDR_TOP + PAGE_SIZE - __FIXADDR_SIZE)
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index e182958..3bfa127 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -777,10 +777,7 @@ void __init paging_init(void)
 
 	kernel_physical_mapping_init(pgd_base);
 
-	/*
-	 * Fixed mappings, only the page table structure has to be
-	 * created - mappings will be set by set_fixmap():
-	 */
+	/* Fixed mappings, only the page table structure has to be created. */
 	page_table_range_init(fix_to_virt(__end_of_fixed_addresses - 1),
 			      FIXADDR_TOP, pgd_base);
 
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 2bd572b..e41487e 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -83,55 +83,6 @@ void show_mem(unsigned int filter)
 	}
 }
 
-/*
- * Associate a virtual page frame with a given physical page frame
- * and protection flags for that frame.
- */
-static void set_pte_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = swapper_pg_dir + pgd_index(vaddr);
-	if (pgd_none(*pgd)) {
-		BUG();
-		return;
-	}
-	pud = pud_offset(pgd, vaddr);
-	if (pud_none(*pud)) {
-		BUG();
-		return;
-	}
-	pmd = pmd_offset(pud, vaddr);
-	if (pmd_none(*pmd)) {
-		BUG();
-		return;
-	}
-	pte = pte_offset_kernel(pmd, vaddr);
-	/* <pfn,flags> stored as-is, to permit clearing entries */
-	set_pte(pte, pfn_pte(pfn, flags));
-
-	/*
-	 * It's enough to flush this one mapping.
-	 * This appears conservative since it is only called
-	 * from __set_fixmap.
-	 */
-	local_flush_tlb_page(NULL, vaddr, PAGE_SIZE);
-}
-
-void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
-{
-	unsigned long address = __fix_to_virt(idx);
-
-	if (idx >= __end_of_fixed_addresses) {
-		BUG();
-		return;
-	}
-	set_pte_pfn(address, phys >> PAGE_SHIFT, flags);
-}
-
 /**
  * shatter_huge_page() - ensure a given address is mapped by a small page.
  *
-- 
1.8.3.1

