Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3G2FgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:36:13 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47164 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3G2FcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:32:23 -0400
X-AuditID: 9c930197-b7bfbae000000e88-13-51f5fe64e945
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
Subject: [PATCH 08/18] mm, hugetlb: do hugepage_subpool_get_pages() when avoid_reserve
Date: Mon, 29 Jul 2013 14:31:59 +0900
Message-Id: <1375075929-6119-9-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we try to get a huge page with avoid_reserve, we don't consume
a reserved page. So it is treated like as non-reserve case.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1426c03..749629e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1149,12 +1149,13 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	if (has_reserve < 0)
 		return ERR_PTR(-ENOMEM);
 
-	if (!has_reserve && (hugepage_subpool_get_pages(spool, 1) < 0))
+	if ((!has_reserve || avoid_reserve)
+		&& (hugepage_subpool_get_pages(spool, 1) < 0))
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
 	if (ret) {
-		if (!has_reserve)
+		if (!has_reserve || avoid_reserve)
 			hugepage_subpool_put_pages(spool, 1);
 		return ERR_PTR(-ENOSPC);
 	}
@@ -1167,7 +1168,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 			hugetlb_cgroup_uncharge_cgroup(idx,
 						       pages_per_huge_page(h),
 						       h_cg);
-			if (!has_reserve)
+			if (!has_reserve || avoid_reserve)
 				hugepage_subpool_put_pages(spool, 1);
 			return ERR_PTR(-ENOSPC);
 		}
-- 
1.7.9.5

