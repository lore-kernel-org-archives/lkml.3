Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966253Ab3HIJc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:32:58 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59885 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965632Ab3HIJ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:27:10 -0400
X-AuditID: 9c930197-b7b44ae00000347f-9a-5204b5ea8d8f
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
Subject: [PATCH v2 03/20] mm, hugetlb: fix subpool accounting handling
Date: Fri,  9 Aug 2013 18:26:21 +0900
Message-Id: <1376040398-11212-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we alloc hugepage with avoid_reserve, we don't dequeue reserved one.
So, we should check subpool counter when avoid_reserve.
This patch implement it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

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

