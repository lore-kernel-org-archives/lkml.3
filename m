Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab3LRG4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:56:50 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62132 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab3LRGyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:54:08 -0500
X-AuditID: 9c93017d-b7c5eae000004296-c9-52b1468d08d3
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
Subject: [PATCH v3 07/14] mm, hugetlb: mm, hugetlb: unify chg and avoid_reserve to use_reserve
Date: Wed, 18 Dec 2013 15:53:53 +0900
Message-Id: <1387349640-8071-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we have two variable to represent whether we can use reserved
page or not, chg and avoid_reserve, respectively. With aggregating these,
we can have more clean code. This makes no functinoal difference.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9d456d4..9927407 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -508,8 +508,7 @@ static inline gfp_t htlb_alloc_mask(struct hstate *h)
 
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, int avoid_reserve,
-				long chg)
+				unsigned long address, bool use_reserve)
 {
 	struct page *page = NULL;
 	struct mempolicy *mpol;
@@ -523,14 +522,10 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	 * A child process with MAP_PRIVATE mappings created by their parent
 	 * have no page reserves. This check ensures that reservations are
 	 * not "stolen". The child may still get SIGKILLed.
-	 * chg represents whether current user has a reserved hugepages or not,
-	 * so that we can use it to ensure that reservations are not "stolen".
+	 * Or, when parent process do COW, we cannot use reserved page.
+	 * In this case, ensure enough pages are in the pool.
 	 */
-	if (chg && h->free_huge_pages - h->resv_huge_pages == 0)
-		goto err;
-
-	/* If reserves cannot be used, ensure enough pages are in the pool */
-	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
+	if (!use_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
 		goto err;
 
 retry_cpuset:
@@ -543,13 +538,7 @@ retry_cpuset:
 		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask(h))) {
 			page = dequeue_huge_page_node(h, zone_to_nid(zone));
 			if (page) {
-				if (avoid_reserve)
-					break;
-				/*
-				 * chg means whether current user allocates
-				 * a hugepage on the reserved pool or not
-				 */
-				if (chg)
+				if (!use_reserve)
 					break;
 
 				SetPagePrivate(page);
@@ -1194,6 +1183,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
 	long chg;
+	bool use_reserve;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg;
 
@@ -1209,18 +1199,19 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
 		return ERR_PTR(-ENOMEM);
-	if (chg || avoid_reserve)
+	use_reserve = (!chg && !avoid_reserve);
+	if (!use_reserve)
 		if (hugepage_subpool_get_pages(spool, 1))
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
 	if (ret) {
-		if (chg || avoid_reserve)
+		if (!use_reserve)
 			hugepage_subpool_put_pages(spool, 1);
 		return ERR_PTR(-ENOSPC);
 	}
 	spin_lock(&hugetlb_lock);
-	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, chg);
+	page = dequeue_huge_page_vma(h, vma, addr, use_reserve);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
@@ -1228,7 +1219,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 			hugetlb_cgroup_uncharge_cgroup(idx,
 						       pages_per_huge_page(h),
 						       h_cg);
-			if (chg || avoid_reserve)
+			if (!use_reserve)
 				hugepage_subpool_put_pages(spool, 1);
 			return ERR_PTR(-ENOSPC);
 		}
-- 
1.7.9.5

