Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbaGAUVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:21:44 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:42089 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaGAUVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:21:42 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: davidlohr@hp.com, aswin@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm,hugetlb: make unmap_ref_private() return void
Date: Tue,  1 Jul 2014 13:21:36 -0700
Message-Id: <1404246097-18810-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function always returns 1, thus no need to check return value
in hugetlb_cow(). By doing so, we can get rid of the unnecessary WARN_ON
call. While this logic perhaps existed as a way of identifying future
unmap_ref_private() mishandling, reality is it serves no apparent purpose.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 mm/hugetlb.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2024bbd..3c4d535 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2753,8 +2753,8 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
-static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
-				struct page *page, unsigned long address)
+static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
+			      struct page *page, unsigned long address)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
@@ -2793,8 +2793,6 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 					     address + huge_page_size(h), page);
 	}
 	mutex_unlock(&mapping->i_mmap_mutex);
-
-	return 1;
 }
 
 /*
@@ -2856,20 +2854,18 @@ retry_avoidcopy:
 		 */
 		if (outside_reserve) {
 			BUG_ON(huge_pte_none(pte));
-			if (unmap_ref_private(mm, vma, old_page, address)) {
-				BUG_ON(huge_pte_none(pte));
-				spin_lock(ptl);
-				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
-				if (likely(ptep &&
-					   pte_same(huge_ptep_get(ptep), pte)))
-					goto retry_avoidcopy;
-				/*
-				 * race occurs while re-acquiring page table
-				 * lock, and our job is done.
-				 */
-				return 0;
-			}
-			WARN_ON_ONCE(1);
+			unmap_ref_private(mm, vma, old_page, address);
+			BUG_ON(huge_pte_none(pte));
+			spin_lock(ptl);
+			ptep = huge_pte_offset(mm, address & huge_page_mask(h));
+			if (likely(ptep &&
+				   pte_same(huge_ptep_get(ptep), pte)))
+				goto retry_avoidcopy;
+			/*
+			 * race occurs while re-acquiring page table
+			 * lock, and our job is done.
+			 */
+			return 0;
 		}
 
 		/* Caller expects lock to be held */
-- 
1.8.1.4

