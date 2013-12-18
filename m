Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3LRTn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:43:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab3LRTmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:42:09 -0500
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/6] mm: page_alloc: Use zone node IDs to approximate locality
Date: Wed, 18 Dec 2013 19:42:01 +0000
Message-Id: <1387395723-25391-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387395723-25391-1-git-send-email-mgorman@suse.de>
References: <1387395723-25391-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zone_local is using node_distance which is a more expensive call than
necessary. On x86, it's another function call in the allocator fast path
and increases cache footprint. This patch makes the assumption zones on
the preferred node will share the same node ID. The necessary information
should already be cache hot.

Cc: <stable@kernel.org> # 3.12
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
---
 mm/page_alloc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2cd694c..5aeb2c6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1822,9 +1822,10 @@ static void zlc_clear_zones_full(struct zonelist *zonelist)
 	bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 }
 
-static bool zone_local(struct zone *local_zone, struct zone *zone)
+/* Returns if the zone is is on the same node as the preferred node */
+static bool zone_preferred_node(struct zone *preferred_zone, struct zone *zone)
 {
-	return node_distance(local_zone->node, zone->node) == LOCAL_DISTANCE;
+	return zone_to_nid(preferred_zone) == zone_to_nid(zone);
 }
 
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
@@ -1864,7 +1865,7 @@ static void zlc_clear_zones_full(struct zonelist *zonelist)
 {
 }
 
-static bool zone_local(struct zone *local_zone, struct zone *zone)
+static bool zone_preferred_node(struct zone *preferred_zone, struct zone *zone)
 {
 	return true;
 }
@@ -1909,7 +1910,7 @@ static bool zone_distribute_age(gfp_t gfp_mask, struct zone *preferred_zone,
 	 * back to remote zones that do not partake in the fairness round-robin
 	 * cycle of this zonelist.
 	 */
-	if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
+	if (zone_reclaim_mode && !zone_preferred_node(preferred_zone, zone))
 		return true;
 
 	return false;
@@ -2420,7 +2421,7 @@ static void prepare_slowpath(gfp_t gfp_mask, unsigned int order,
 		 * thrash fairness information for zones that are not
 		 * actually part of this zonelist's round-robin cycle.
 		 */
-		if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
+		if (zone_reclaim_mode && !zone_preferred_node(preferred_zone, zone))
 			continue;
 		mod_zone_page_state(zone, NR_ALLOC_BATCH,
 				    high_wmark_pages(zone) -
-- 
1.8.4

