Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3G2FgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:36:16 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58282 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3G2FcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:32:22 -0400
X-AuditID: 9c930197-b7bfbae000000e88-11-51f5fe644ff9
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
Subject: [PATCH 07/18] mm, hugetlb: pass has_reserve to dequeue_huge_page_vma()
Date: Mon, 29 Jul 2013 14:31:58 +0900
Message-Id: <1375075929-6119-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to call vma_has_reserve() each time we need information.
Passing has_reserve unburden this effort.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ff46a2c..1426c03 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -572,7 +572,8 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
 
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, int avoid_reserve)
+				unsigned long address,
+				int has_reserve, int avoid_reserve)
 {
 	struct page *page = NULL;
 	struct mempolicy *mpol;
@@ -587,8 +588,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	 * have no page reserves. This check ensures that reservations are
 	 * not "stolen". The child may still get SIGKILLed
 	 */
-	if (!vma_has_reserves(h, vma, address) &&
-			h->free_huge_pages - h->resv_huge_pages == 0)
+	if (!has_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
 		return NULL;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
@@ -607,7 +607,7 @@ retry_cpuset:
 			if (page) {
 				if (avoid_reserve)
 					break;
-				if (!vma_has_reserves(h, vma, address))
+				if (!has_reserve)
 					break;
 
 				h->resv_huge_pages--;
@@ -1159,7 +1159,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 		return ERR_PTR(-ENOSPC);
 	}
 	spin_lock(&hugetlb_lock);
-	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
+	page = dequeue_huge_page_vma(h, vma, addr, has_reserve, avoid_reserve);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
-- 
1.7.9.5

