Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaENHLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:11:16 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46434 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaENHLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:11:14 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com,
        mhocko@suse.cz, aarcange@redhat.com, steve.capper@linaro.org,
        davidlohr@hp.com, kirill.shutemov@linux.intel.com,
        dave.hansen@linux.intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] mm, hugetlb: move the error handle logic out of normal code path
Date: Wed, 14 May 2014 15:10:59 +0800
Message-Id: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_huge_page() now mixes normal code path with error handle logic.
This patches move out the error handle logic, to make normal code
path more clean and redue code duplicate.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/hugetlb.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 26b1464..e81c69e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1246,24 +1246,17 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 			return ERR_PTR(-ENOSPC);
 
 	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
-	if (ret) {
-		if (chg || avoid_reserve)
-			hugepage_subpool_put_pages(spool, 1);
-		return ERR_PTR(-ENOSPC);
-	}
+	if (ret)
+		goto out_subpool_put;
+
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, chg);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
-		if (!page) {
-			hugetlb_cgroup_uncharge_cgroup(idx,
-						       pages_per_huge_page(h),
-						       h_cg);
-			if (chg || avoid_reserve)
-				hugepage_subpool_put_pages(spool, 1);
-			return ERR_PTR(-ENOSPC);
-		}
+		if (!page)
+			goto out_uncharge_cgroup;
+
 		spin_lock(&hugetlb_lock);
 		list_move(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
@@ -1275,6 +1268,13 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 
 	vma_commit_reservation(h, vma, addr);
 	return page;
+
+out_uncharge_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
+out_subpool_put:
+	if (chg || avoid_reserve)
+		hugepage_subpool_put_pages(spool, 1);
+	return ERR_PTR(-ENOSPC);
 }
 
 /*
-- 
2.0.0-rc3

