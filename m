Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbaGVW1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:27:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44943 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbaGVW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:27:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 054/116] mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL
Date: Tue, 22 Jul 2014 15:21:05 -0700
Message-Id: <1406067727-19683-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 675becce15f320337499bc1a9356260409a5ba29 upstream.

throttle_direct_reclaim() is meant to trigger during swap-over-network
during which the min watermark is treated as a pfmemalloc reserve.  It
throttes on the first node in the zonelist but this is flawed.

The user-visible impact is that a process running on CPU whose local
memory node has no ZONE_NORMAL will stall for prolonged periods of time,
possibly indefintely.  This is due to throttle_direct_reclaim thinking the
pfmemalloc reserves are depleted when in fact they don't exist on that
node.

On a NUMA machine running a 32-bit kernel (I know) allocation requests
from CPUs on node 1 would detect no pfmemalloc reserves and the process
gets throttled.  This patch adjusts throttling of direct reclaim to
throttle based on the first node in the zonelist that has a usable
ZONE_NORMAL or lower zone.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/vmscan.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9dcc836..9cbc502 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2226,10 +2226,17 @@ static bool pfmemalloc_watermark_ok(pg_data_t *pgdat)
 
 	for (i = 0; i <= ZONE_NORMAL; i++) {
 		zone = &pgdat->node_zones[i];
+		if (!populated_zone(zone))
+			continue;
+
 		pfmemalloc_reserve += min_wmark_pages(zone);
 		free_pages += zone_page_state(zone, NR_FREE_PAGES);
 	}
 
+	/* If there are no reserves (unexpected config) then do not throttle */
+	if (!pfmemalloc_reserve)
+		return true;
+
 	wmark_ok = free_pages > pfmemalloc_reserve / 2;
 
 	/* kswapd must be awake if processes are being throttled */
@@ -2254,9 +2261,9 @@ static bool pfmemalloc_watermark_ok(pg_data_t *pgdat)
 static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 					nodemask_t *nodemask)
 {
+	struct zoneref *z;
 	struct zone *zone;
-	int high_zoneidx = gfp_zone(gfp_mask);
-	pg_data_t *pgdat;
+	pg_data_t *pgdat = NULL;
 
 	/*
 	 * Kernel threads should not be throttled as they may be indirectly
@@ -2275,10 +2282,34 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 	if (fatal_signal_pending(current))
 		goto out;
 
-	/* Check if the pfmemalloc reserves are ok */
-	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
-	pgdat = zone->zone_pgdat;
-	if (pfmemalloc_watermark_ok(pgdat))
+	/*
+	 * Check if the pfmemalloc reserves are ok by finding the first node
+	 * with a usable ZONE_NORMAL or lower zone. The expectation is that
+	 * GFP_KERNEL will be required for allocating network buffers when
+	 * swapping over the network so ZONE_HIGHMEM is unusable.
+	 *
+	 * Throttling is based on the first usable node and throttled processes
+	 * wait on a queue until kswapd makes progress and wakes them. There
+	 * is an affinity then between processes waking up and where reclaim
+	 * progress has been made assuming the process wakes on the same node.
+	 * More importantly, processes running on remote nodes will not compete
+	 * for remote pfmemalloc reserves and processes on different nodes
+	 * should make reasonable progress.
+	 */
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+					gfp_mask, nodemask) {
+		if (zone_idx(zone) > ZONE_NORMAL)
+			continue;
+
+		/* Throttle based on the first usable node */
+		pgdat = zone->zone_pgdat;
+		if (pfmemalloc_watermark_ok(pgdat))
+			goto out;
+		break;
+	}
+
+	/* If no zone was usable by the allocation flags then do not throttle */
+	if (!pgdat)
 		goto out;
 
 	/* Account for the throttling */
-- 
1.9.1

