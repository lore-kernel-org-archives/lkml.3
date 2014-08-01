Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaHATWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:22:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321AbaHATVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:21:23 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH -mm v6 01/13] mm/pagewalk: remove pgd_entry() and pud_entry()
Date: Fri,  1 Aug 2014 15:20:37 -0400
Message-Id: <1406920849-25908-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
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

diff --git mmotm-2014-07-30-15-57.orig/include/linux/mm.h mmotm-2014-07-30-15-57/include/linux/mm.h
index 368600628d14..4d5bca99a33d 100644
--- mmotm-2014-07-30-15-57.orig/include/linux/mm.h
+++ mmotm-2014-07-30-15-57/include/linux/mm.h
@@ -1094,8 +1094,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 
 /**
  * mm_walk - callbacks for walk_page_range
- * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
- * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
  *	       this handler is required to be able to handle
  *	       pmd_trans_huge() pmds.  They may simply choose to
@@ -1109,10 +1107,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
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
diff --git mmotm-2014-07-30-15-57.orig/mm/pagewalk.c mmotm-2014-07-30-15-57/mm/pagewalk.c
index 2beeabf502c5..335690650b12 100644
--- mmotm-2014-07-30-15-57.orig/mm/pagewalk.c
+++ mmotm-2014-07-30-15-57/mm/pagewalk.c
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

