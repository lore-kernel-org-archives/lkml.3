Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3LRGyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:54:19 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50636 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3LRGyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:54:09 -0500
X-AuditID: 9c93017d-b7c5eae000004296-d2-52b1468d0ff6
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
Subject: [PATCH v3 10/14] mm, hugetlb: move down outside_reserve check
Date: Wed, 18 Dec 2013 15:53:56 +0900
Message-Id: <1387349640-8071-11-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just move down outside_reserve check and don't check
vma_need_reservation() when outside_resever is true. It is slightly
optimized implementation.

This makes code more readable.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0f56bbf..03ab285 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2576,7 +2576,7 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *old_page, *new_page;
 	int outside_reserve = 0;
 	long chg;
-	bool use_reserve;
+	bool use_reserve = false;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
@@ -2591,6 +2591,11 @@ retry_avoidcopy:
 		return 0;
 	}
 
+	page_cache_get(old_page);
+
+	/* Drop page table lock as buddy allocator may be called */
+	spin_unlock(ptl);
+
 	/*
 	 * If the process that created a MAP_PRIVATE mapping is about to
 	 * perform a COW due to a shared page count, attempt to satisfy
@@ -2604,19 +2609,17 @@ retry_avoidcopy:
 			old_page != pagecache_page)
 		outside_reserve = 1;
 
-	page_cache_get(old_page);
-
-	/* Drop page table lock as buddy allocator may be called */
-	spin_unlock(ptl);
-	chg = vma_needs_reservation(h, vma, address);
-	if (chg < 0) {
-		page_cache_release(old_page);
+	if (!outside_reserve) {
+		chg = vma_needs_reservation(h, vma, address);
+		if (chg < 0) {
+			page_cache_release(old_page);
 
-		/* Caller expects lock to be held */
-		spin_lock(ptl);
-		return VM_FAULT_OOM;
+			/* Caller expects lock to be held */
+			spin_lock(ptl);
+			return VM_FAULT_OOM;
+		}
+		use_reserve = !chg;
 	}
-	use_reserve = !chg && !outside_reserve;
 
 	new_page = alloc_huge_page(vma, address, use_reserve);
 
-- 
1.7.9.5

