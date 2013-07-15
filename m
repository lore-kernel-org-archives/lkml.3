Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3GOKKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:10:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57535 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3GOKIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:08:07 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-da-51e3c67192e1
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
Subject: [PATCH 1/9] mm, hugetlb: move up the code which check availability of free huge page
Date: Mon, 15 Jul 2013 18:52:39 +0900
Message-Id: <1373881967-16153-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to proceede the processing if we don't have any usable
free huge page. So move this code up.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e2bfbf7..d87f70b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -539,10 +539,6 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	struct zoneref *z;
 	unsigned int cpuset_mems_cookie;
 
-retry_cpuset:
-	cpuset_mems_cookie = get_mems_allowed();
-	zonelist = huge_zonelist(vma, address,
-					htlb_alloc_mask, &mpol, &nodemask);
 	/*
 	 * A child process with MAP_PRIVATE mappings created by their parent
 	 * have no page reserves. This check ensures that reservations are
@@ -550,11 +546,16 @@ retry_cpuset:
 	 */
 	if (!vma_has_reserves(vma) &&
 			h->free_huge_pages - h->resv_huge_pages == 0)
-		goto err;
+		return NULL;
 
 	/* If reserves cannot be used, ensure enough pages are in the pool */
 	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
-		goto err;
+		return NULL;
+
+retry_cpuset:
+	cpuset_mems_cookie = get_mems_allowed();
+	zonelist = huge_zonelist(vma, address,
+					htlb_alloc_mask, &mpol, &nodemask);
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
@@ -572,10 +573,6 @@ retry_cpuset:
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
 	return page;
-
-err:
-	mpol_cond_put(mpol);
-	return NULL;
 }
 
 static void update_and_free_page(struct hstate *h, struct page *page)
-- 
1.7.9.5

