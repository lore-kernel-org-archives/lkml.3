Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbaGARMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:12:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758565AbaGARHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:07:51 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v4 01/13] mm/pagewalk: remove pgd_entry() and pud_entry()
Date: Tue,  1 Jul 2014 13:07:19 -0400
Message-Id: <1404234451-21695-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently no user of page table walker sets ->pgd_entry() or ->pud_entry(),
so checking their existence in each loop is just wasting CPU cycle.
So let's remove it to reduce overhead.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h | 6 ------
 mm/pagewalk.c      | 9 ++-------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git v3.16-rc3.orig/include/linux/mm.h v3.16-rc3/include/linux/mm.h
index e03dd29145a0..c5cb6394e6cb 100644
--- v3.16-rc3.orig/include/linux/mm.h
+++ v3.16-rc3/include/linux/mm.h
@@ -1100,8 +1100,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 
 /**
  * mm_walk - callbacks for walk_page_range
- * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
- * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
  *	       this handler is required to be able to handle
  *	       pmd_trans_huge() pmds.  They may simply choose to
@@ -1115,10 +1113,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
  * (see walk_page_range for more details)
  */
 struct mm_walk {
-	int (*pgd_entry)(pgd_t *pgd, unsigned long addr,
-			 unsigned long next, struct mm_walk *walk);
-	int (*pud_entry)(pud_t *pud, unsigned long addr,
-	                 unsigned long next, struct mm_walk *walk);
 	int (*pmd_entry)(pmd_t *pmd, unsigned long addr,
 			 unsigned long next, struct mm_walk *walk);
 	int (*pte_entry)(pte_t *pte, unsigned long addr,
diff --git v3.16-rc3.orig/mm/pagewalk.c v3.16-rc3/mm/pagewalk.c
index 2beeabf502c5..335690650b12 100644
--- v3.16-rc3.orig/mm/pagewalk.c
+++ v3.16-rc3/mm/pagewalk.c
@@ -86,9 +86,7 @@ static int walk_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 				break;
 			continue;
 		}
-		if (walk->pud_entry)
-			err = walk->pud_entry(pud, addr, next, walk);
-		if (!err && (walk->pmd_entry || walk->pte_entry))
+		if (walk->pmd_entry || walk->pte_entry)
 			err = walk_pmd_range(pud, addr, next, walk);
 		if (err)
 			break;
@@ -234,10 +232,7 @@ int walk_page_range(unsigned long addr, unsigned long end,
 			pgd++;
 			continue;
 		}
-		if (walk->pgd_entry)
-			err = walk->pgd_entry(pgd, addr, next, walk);
-		if (!err &&
-		    (walk->pud_entry || walk->pmd_entry || walk->pte_entry))
+		if (walk->pmd_entry || walk->pte_entry)
 			err = walk_pud_range(pgd, addr, next, walk);
 		if (err)
 			break;
-- 
1.9.3

