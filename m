Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab3HGUkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:40:39 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60698 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab3HGUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:40:37 -0400
Message-ID: <201308072040.r77KeaiE016083@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 11:00:45 -0400
Subject: [PATCH] tile: fix some issues in hugepage support
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, in huge_pte_offset(), we were erroneously checking
pgd_present(), which is always true, rather than pud_present(),
which is the thing that tells us if there is a top-level (L0) PTE.
Fixing this means we properly look up huge page entries only when
the Present bit is actually set in the PTE.

Second, use the standard pte_alloc_map() instead of the hand-rolled
pte_alloc_hugetlb() routine that basically was written to avoid
worrying about CONFIG_HIGHPTE.  However, we no longer plan to support
HIGHPTE, so a separate routine was just unnecessary code duplication.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/hugetlbpage.c | 38 +++-----------------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/arch/tile/mm/hugetlbpage.c b/arch/tile/mm/hugetlbpage.c
index 650ccff..e514899 100644
--- a/arch/tile/mm/hugetlbpage.c
+++ b/arch/tile/mm/hugetlbpage.c
@@ -49,38 +49,6 @@ int huge_shift[HUGE_SHIFT_ENTRIES] = {
 #endif
 };
 
-/*
- * This routine is a hybrid of pte_alloc_map() and pte_alloc_kernel().
- * It assumes that L2 PTEs are never in HIGHMEM (we don't support that).
- * It locks the user pagetable, and bumps up the mm->nr_ptes field,
- * but otherwise allocate the page table using the kernel versions.
- */
-static pte_t *pte_alloc_hugetlb(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long address)
-{
-	pte_t *new;
-
-	if (pmd_none(*pmd)) {
-		new = pte_alloc_one_kernel(mm, address);
-		if (!new)
-			return NULL;
-
-		smp_wmb(); /* See comment in __pte_alloc */
-
-		spin_lock(&mm->page_table_lock);
-		if (likely(pmd_none(*pmd))) {  /* Has another populated it ? */
-			mm->nr_ptes++;
-			pmd_populate_kernel(mm, pmd, new);
-			new = NULL;
-		} else
-			VM_BUG_ON(pmd_trans_splitting(*pmd));
-		spin_unlock(&mm->page_table_lock);
-		if (new)
-			pte_free_kernel(mm, new);
-	}
-
-	return pte_offset_kernel(pmd, address);
-}
 #endif
 
 pte_t *huge_pte_alloc(struct mm_struct *mm,
@@ -109,7 +77,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 		else {
 			if (sz != PAGE_SIZE << huge_shift[HUGE_SHIFT_PAGE])
 				panic("Unexpected page size %#lx\n", sz);
-			return pte_alloc_hugetlb(mm, pmd, addr);
+			return pte_alloc_map(mm, NULL, pmd, addr);
 		}
 	}
 #else
@@ -144,14 +112,14 @@ pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
 
 	/* Get the top-level page table entry. */
 	pgd = (pgd_t *)get_pte((pte_t *)mm->pgd, pgd_index(addr), 0);
-	if (!pgd_present(*pgd))
-		return NULL;
 
 	/* We don't have four levels. */
 	pud = pud_offset(pgd, addr);
 #ifndef __PAGETABLE_PUD_FOLDED
 # error support fourth page table level
 #endif
+	if (!pud_present(*pud))
+		return NULL;
 
 	/* Check for an L0 huge PTE, if we have three levels. */
 #ifndef __PAGETABLE_PMD_FOLDED
-- 
1.8.3.1

