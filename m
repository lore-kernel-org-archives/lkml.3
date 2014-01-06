Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbaAFXrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:47:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbaAFWjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 119/144] mm: page_alloc: revert NUMA aspect of fair allocation policy
Date: Mon,  6 Jan 2014 14:38:00 -0800
Message-Id: <20140106223748.758385130@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit fff4068cba484e6b0abe334ed6b15d5a215a3b25 upstream.

Commit 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy") meant
to bring aging fairness among zones in system, but it was overzealous
and badly regressed basic workloads on NUMA systems.

Due to the way kswapd and page allocator interacts, we still want to
make sure that all zones in any given node are used equally for all
allocations to maximize memory utilization and prevent thrashing on the
highest zone in the node.

While the same principle applies to NUMA nodes - memory utilization is
obviously improved by spreading allocations throughout all nodes -
remote references can be costly and so many workloads prefer locality
over memory utilization.  The original change assumed that
zone_reclaim_mode would be a good enough predictor for that, but it
turned out to be as indicative as a coin flip.

Revert the NUMA aspect of the fairness until we can find a proper way to
make it configurable and agree on a sane default.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1822,7 +1822,7 @@ static void zlc_clear_zones_full(struct
 
 static bool zone_local(struct zone *local_zone, struct zone *zone)
 {
-	return node_distance(local_zone->node, zone->node) == LOCAL_DISTANCE;
+	return local_zone->node == zone->node;
 }
 
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
@@ -1919,18 +1919,17 @@ zonelist_scan:
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
@@ -2396,7 +2395,7 @@ static void prepare_slowpath(gfp_t gfp_m
 		 * thrash fairness information for zones that are not
 		 * actually part of this zonelist's round-robin cycle.
 		 */
-		if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
+		if (!zone_local(preferred_zone, zone))
 			continue;
 		mod_zone_page_state(zone, NR_ALLOC_BATCH,
 				    high_wmark_pages(zone) -


