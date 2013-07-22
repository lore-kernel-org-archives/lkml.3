Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3GVIkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:40:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54170 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab3GVIgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:36:39 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-cf-51ecef14667e
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
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 04/10] mm, hugetlb: clean-up alloc_huge_page()
Date: Mon, 22 Jul 2013 17:36:25 +0900
Message-Id: <1374482191-3500-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can unify some codes for succeed allocation.
This makes code more readable.
There is no functional difference.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d21a33a..83edd17 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1146,12 +1146,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
-	if (page) {
-		/* update page cgroup details */
-		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
-					     h_cg, page);
-		spin_unlock(&hugetlb_lock);
-	} else {
+	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
@@ -1162,11 +1157,11 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 			return ERR_PTR(-ENOSPC);
 		}
 		spin_lock(&hugetlb_lock);
-		hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
-					     h_cg, page);
 		list_move(&page->lru, &h->hugepage_activelist);
-		spin_unlock(&hugetlb_lock);
+		/* Fall through */
 	}
+	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
+	spin_unlock(&hugetlb_lock);
 
 	set_page_private(page, (unsigned long)spool);
 
-- 
1.7.9.5

