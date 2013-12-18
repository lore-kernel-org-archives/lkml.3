Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3LRGzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:55:23 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50636 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3LRGyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:54:10 -0500
X-AuditID: 9c93017d-b7c5eae000004296-dd-52b1468e6a9e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 14/14] mm, hugetlb: remove a hugetlb_instantiation_mutex
Date: Wed, 18 Dec 2013 15:54:00 +0900
Message-Id: <1387349640-8071-15-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have an infrastructure in order to remove a this awkward mutex
which serialize all faulting tasks, so remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 843c554..6edf423 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2595,9 +2595,7 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 
 /*
  * Hugetlb_cow() should be called with page lock of the original hugepage held.
- * Called with hugetlb_instantiation_mutex held and pte_page locked so we
- * cannot race with other handlers or page migration.
- * Keep the pte_same checks anyway to make transition from the mutex easier.
+ * Called with pte_page locked so we cannot race with page migration.
  */
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pte_t pte,
@@ -2941,7 +2939,6 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	int ret;
 	struct page *page = NULL;
 	struct page *pagecache_page = NULL;
-	static DEFINE_MUTEX(hugetlb_instantiation_mutex);
 	struct hstate *h = hstate_vma(vma);
 
 	address &= huge_page_mask(h);
@@ -2961,17 +2958,9 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (!ptep)
 		return VM_FAULT_OOM;
 
-	/*
-	 * Serialize hugepage allocation and instantiation, so that we don't
-	 * get spurious allocation failures if two CPUs race to instantiate
-	 * the same page in the page cache.
-	 */
-	mutex_lock(&hugetlb_instantiation_mutex);
 	entry = huge_ptep_get(ptep);
-	if (huge_pte_none(entry)) {
-		ret = hugetlb_no_page(mm, vma, address, ptep, flags);
-		goto out_mutex;
-	}
+	if (huge_pte_none(entry))
+		return hugetlb_no_page(mm, vma, address, ptep, flags);
 
 	ret = 0;
 
@@ -2984,10 +2973,8 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * consumed.
 	 */
 	if ((flags & FAULT_FLAG_WRITE) && !huge_pte_write(entry)) {
-		if (vma_needs_reservation(h, vma, address) < 0) {
-			ret = VM_FAULT_OOM;
-			goto out_mutex;
-		}
+		if (vma_needs_reservation(h, vma, address) < 0)
+			return VM_FAULT_OOM;
 
 		if (!(vma->vm_flags & VM_MAYSHARE))
 			pagecache_page = hugetlbfs_pagecache_page(h,
@@ -3037,9 +3024,6 @@ out_ptl:
 		unlock_page(page);
 	put_page(page);
 
-out_mutex:
-	mutex_unlock(&hugetlb_instantiation_mutex);
-
 	return ret;
 }
 
-- 
1.7.9.5

