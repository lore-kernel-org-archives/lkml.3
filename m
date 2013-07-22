Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3GVIgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:36:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54170 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3GVIgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:36:38 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-c6-51ecef1364dd
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
Subject: [PATCH v2 01/10] mm, hugetlb: move up the code which check availability of free huge page
Date: Mon, 22 Jul 2013 17:36:22 +0900
Message-Id: <1374482191-3500-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this time we are holding a hugetlb_lock, so hstate values can't
be changed. If we don't have any usable free huge page in this time,
we don't need to proceede the processing. So move this code up.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e2bfbf7..fc4988c 100644
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
@@ -556,6 +552,11 @@ retry_cpuset:
 	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
 		goto err;
 
+retry_cpuset:
+	cpuset_mems_cookie = get_mems_allowed();
+	zonelist = huge_zonelist(vma, address,
+					htlb_alloc_mask, &mpol, &nodemask);
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						MAX_NR_ZONES - 1, nodemask) {
 		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
@@ -574,7 +575,6 @@ retry_cpuset:
 	return page;
 
 err:
-	mpol_cond_put(mpol);
 	return NULL;
 }
 
-- 
1.7.9.5

