Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab3IFFUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:20:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44198 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3IFFUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:20:33 -0400
X-AuditID: 9c930197-b7b44ae00000347f-3c-5229661f0bee
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
Subject: [PATCH v3 03/20] mm, hugetlb: fix subpool accounting handling
Date: Fri,  6 Sep 2013 14:19:57 +0900
Message-Id: <1378444797-3353-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378444797-3353-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <520c10e8.1kKQVx1mpwqXywyM%akpm@linux-foundation.org>
 <1378444797-3353-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a case that we attempt to allocate a hugepage with chg = 0 and
avoid_reserve = 1. Although chg = 0 means that it has a reserved hugepage,
we wouldn't use it, since avoid_reserve = 1 represents that we don't want
to allocate a hugepage from a reserved pool. This happens when the parent
process that created a MAP_PRIVATE mapping is about to perform a COW due to
a shared page count and it attempt to satisfy the allocation without using
the existing reserves.

In this case, we would not dequeue a reserved hugepage and, instead, try
to allocate a new hugepage. Therefore, we should check subpool counter
for a new hugepage. This patch implement it.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
Replenishing commit message and adding reviewed-by tag.

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 12b6581..ea1ae0a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1144,13 +1144,14 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	chg = vma_needs_reservation(h, vma, addr);
 	if (chg < 0)
 		return ERR_PTR(-ENOMEM);
-	if (chg)
-		if (hugepage_subpool_get_pages(spool, chg))
+	if (chg || avoid_reserve)
+		if (hugepage_subpool_get_pages(spool, 1))
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
 	if (ret) {
-		hugepage_subpool_put_pages(spool, chg);
+		if (chg || avoid_reserve)
+			hugepage_subpool_put_pages(spool, 1);
 		return ERR_PTR(-ENOSPC);
 	}
 	spin_lock(&hugetlb_lock);
@@ -1162,7 +1163,8 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 			hugetlb_cgroup_uncharge_cgroup(idx,
 						       pages_per_huge_page(h),
 						       h_cg);
-			hugepage_subpool_put_pages(spool, chg);
+			if (chg || avoid_reserve)
+				hugepage_subpool_put_pages(spool, 1);
 			return ERR_PTR(-ENOSPC);
 		}
 		spin_lock(&hugetlb_lock);
-- 
1.7.9.5

