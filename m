Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3LTOy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:54:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab3LTOyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:54:18 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/2] mm: page_alloc: revert NUMA aspect of fair allocation policy
Date: Fri, 20 Dec 2013 14:54:12 +0000
Message-Id: <1387551252-23375-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387551252-23375-1-git-send-email-mgorman@suse.de>
References: <1387551252-23375-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

81c0a2bb ("mm: page_alloc: fair zone allocator policy") meant to bring
aging fairness among zones in system, but it was overzealous and badly
regressed basic workloads on NUMA systems.

Due to the way kswapd and page allocator interacts, we still want to
make sure that all zones in any given node are used equally for all
allocations to maximize memory utilization and prevent thrashing on
the highest zone in the node.

While the same principle applies to NUMA nodes - memory utilization is
obviously improved by spreading allocations throughout all nodes -
remote references can be costly and so many workloads prefer locality
over memory utilization.  The original change assumed that
zone_reclaim_mode would be a good enough predictor for that, but it
turned out to be as indicative as a coin flip.

Revert the NUMA aspect of the fairness until we can find a proper way
to make it configurable and agree on a sane default.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@kernel.org> # 3.12
---
 mm/page_alloc.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 580a5f0..5248fe0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1816,7 +1816,7 @@ static void zlc_clear_zones_full(struct zonelist *zonelist)
 
 static bool zone_local(struct zone *local_zone, struct zone *zone)
 {
-	return node_distance(local_zone->node, zone->node) == LOCAL_DISTANCE;
+	return local_zone->node == zone->node;
 }
 
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
@@ -1913,18 +1913,17 @@ zonelist_scan:
 		 * page was allocated in should have no effect on the
 		 * time the page has in memory before being reclaimed.
 		 *
-		 * When zone_reclaim_mode is enabled, try to stay in
-		 * local zones in the fastpath.  If that fails, the
-		 * slowpath is entered, which will do another pass
-		 * starting with the local zones, but ultimately fall
-		 * back to remote zones that do not partake in the
-		 * fairness round-robin cycle of this zonelist.
+		 * Try to stay in local zones in the fastpath.  If
+		 * that fails, the slowpath is entered, which will do
+		 * another pass starting with the local zones, but
+		 * ultimately fall back to remote zones that do not
+		 * partake in the fairness round-robin cycle of this
+		 * zonelist.
 		 */
 		if (alloc_flags & ALLOC_WMARK_LOW) {
 			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
 				continue;
-			if (zone_reclaim_mode &&
-			    !zone_local(preferred_zone, zone))
+			if (!zone_local(preferred_zone, zone))
 				continue;
 		}
 		/*
@@ -2390,7 +2389,7 @@ static void prepare_slowpath(gfp_t gfp_mask, unsigned int order,
 		 * thrash fairness information for zones that are not
 		 * actually part of this zonelist's round-robin cycle.
 		 */
-		if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
+		if (!zone_local(preferred_zone, zone))
 			continue;
 		mod_zone_page_state(zone, NR_ALLOC_BATCH,
 				    high_wmark_pages(zone) -
-- 
1.8.4

