Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaIZUnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:43:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbaIZUnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:43:45 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [mmotm][PATCH 1/2] mm/hugetlb: improve suboptimal migration/hwpoisoned entry check
Date: Fri, 26 Sep 2014 16:42:06 -0400
Message-Id: <1411764127-31641-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1411764127-31641-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1411764127-31641-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently hugetlb_fault() checks at first whether pte of the faulted
address is a migration or hwpoisoned entry. The reason of this approach
is that without the checks, the BUG_ON() in huge_pte_alloc() is triggered,
because it assumes that when pte is not none, it always points to a
normal hugepage, which was correct originally but not after hugetlb
supports page migration or hwpoison.

In order to iron out this weird workaround, this patch changes the
wrongly assumed BUG_ON() in huge_pte_alloc(). This allows us to check
pte_present() case only in proper place, which makes code simpler.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/hugetlb.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git mmotm-2014-09-25-16-28.orig/mm/hugetlb.c mmotm-2014-09-25-16-28/mm/hugetlb.c
index 1ecb625bc498..e6543359be4d 100644
--- mmotm-2014-09-25-16-28.orig/mm/hugetlb.c
+++ mmotm-2014-09-25-16-28/mm/hugetlb.c
@@ -3130,20 +3130,10 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	int need_wait_lock = 0;
+	int need_wait_migration = 0;
 
 	address &= huge_page_mask(h);
 
-	ptep = huge_pte_offset(mm, address);
-	if (ptep) {
-		entry = huge_ptep_get(ptep);
-		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(vma, mm, ptep);
-			return 0;
-		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
-			return VM_FAULT_HWPOISON_LARGE |
-				VM_FAULT_SET_HINDEX(hstate_index(h));
-	}
-
 	ptep = huge_pte_alloc(mm, address, huge_page_size(h));
 	if (!ptep)
 		return VM_FAULT_OOM;
@@ -3169,12 +3159,16 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	/*
 	 * entry could be a migration/hwpoison entry at this point, so this
 	 * check prevents the kernel from going below assuming that we have
-	 * a active hugepage in pagecache. This goto expects the 2nd page fault,
-	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
-	 * handle it.
+	 * a active hugepage in pagecache.
 	 */
-	if (!pte_present(entry))
+	if (!pte_present(entry)) {
+		if (is_hugetlb_entry_migration(entry))
+			need_wait_migration = 1;
+		else if (is_hugetlb_entry_hwpoisoned(entry))
+			ret = VM_FAULT_HWPOISON_LARGE |
+				VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_mutex;
+	}
 
 	/*
 	 * If we are going to COW the mapping later, we examine the pending
@@ -3242,6 +3236,8 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 out_mutex:
 	mutex_unlock(&htlb_fault_mutex_table[hash]);
+	if (need_wait_migration)
+		migration_entry_wait_huge(vma, mm, ptep);
 	if (need_wait_lock)
 		wait_on_page_locked(page);
 	return ret;
@@ -3664,7 +3660,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 				pte = (pte_t *)pmd_alloc(mm, pud, addr);
 		}
 	}
-	BUG_ON(pte && !pte_none(*pte) && !pte_huge(*pte));
+	BUG_ON(pte && !pte_none(*pte) && pte_present(*pte) && !pte_huge(*pte));
 
 	return pte;
 }
-- 
1.9.3

