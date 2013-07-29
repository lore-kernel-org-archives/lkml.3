Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3G2Ff4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:35:56 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44032 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab3G2FcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:32:23 -0400
X-AuditID: 9c930197-b7bfbae000000e88-16-51f5fe64e82c
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
Subject: [PATCH 09/18] mm, hugetlb: unify has_reserve and avoid_reserve to use_reserve
Date: Mon, 29 Jul 2013 14:32:00 +0900
Message-Id: <1375075929-6119-10-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we have two variable to represent whether we can use reserved
page or not, has_reserve and avoid_reserve, respectively.
These have same meaning, so we can unify them to use_reserve.
This makes no functinoal difference, is just for clean-up.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 749629e..a66226e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -572,8 +572,7 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
 
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address,
-				int has_reserve, int avoid_reserve)
+				unsigned long address, int use_reserve)
 {
 	struct page *page = NULL;
 	struct mempolicy *mpol;
@@ -586,13 +585,11 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	/*
 	 * A child process with MAP_PRIVATE mappings created by their parent
 	 * have no page reserves. This check ensures that reservations are
-	 * not "stolen". The child may still get SIGKILLed
+	 * not "stolen". The child may still get SIGKILLed.
+	 * Or, when parent process do COW, we cannot use reserved page.
+	 * In this case, ensure enough pages are in the pool.
 	 */
-	if (!has_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
-		return NULL;
-
-	/* If reserves cannot be used, ensure enough pages are in the pool */
-	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
+	if (!use_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
 		return NULL;
 
 retry_cpuset:
@@ -605,9 +602,7 @@ retry_cpuset:
 		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
 			page = dequeue_huge_page_node(h, zone_to_nid(zone));
 			if (page) {
-				if (avoid_reserve)
-					break;
-				if (!has_reserve)
+				if (!use_reserve)
 					break;
 
 				h->resv_huge_pages--;
@@ -1133,7 +1128,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
-	int ret, idx, has_reserve;
+	int ret, idx, use_reserve;
 	struct hugetlb_cgroup *h_cg;
 
 	idx = hstate_index(h);
@@ -1145,22 +1140,22 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 * need pages and subpool limit allocated allocated if no reserve
 	 * mapping overlaps.
 	 */
-	has_reserve = vma_has_reserves(h, vma, addr);
-	if (has_reserve < 0)
+	use_reserve = vma_has_reserves(h, vma, addr);
+	if (use_reserve < 0)
 		return ERR_PTR(-ENOMEM);
 
-	if ((!has_reserve || avoid_reserve)
-		&& (hugepage_subpool_get_pages(spool, 1) < 0))
+	use_reserve = use_reserve && !avoid_reserve;
+	if (!use_reserve && (hugepage_subpool_get_pages(spool, 1) < 0))
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
 	if (ret) {
-		if (!has_reserve || avoid_reserve)
+		if (!use_reserve)
 			hugepage_subpool_put_pages(spool, 1);
 		return ERR_PTR(-ENOSPC);
 	}
 	spin_lock(&hugetlb_lock);
-	page = dequeue_huge_page_vma(h, vma, addr, has_reserve, avoid_reserve);
+	page = dequeue_huge_page_vma(h, vma, addr, use_reserve);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
@@ -1168,7 +1163,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 			hugetlb_cgroup_uncharge_cgroup(idx,
 						       pages_per_huge_page(h),
 						       h_cg);
-			if (!has_reserve || avoid_reserve)
+			if (!use_reserve)
 				hugepage_subpool_put_pages(spool, 1);
 			return ERR_PTR(-ENOSPC);
 		}
-- 
1.7.9.5

