Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaF3Meq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:34:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964896AbaF3Mbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 111/181] mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL
Date: Mon, 30 Jun 2014 13:52:12 +0200
Message-Id: <ae9e3dac0e9e51072f0706028726849c377e5481.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/vmscan.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 05e6095159dc..d873137bf503 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2484,10 +2484,17 @@ static bool pfmemalloc_watermark_ok(pg_data_t *pgdat)
 
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
@@ -2512,9 +2519,9 @@ static bool pfmemalloc_watermark_ok(pg_data_t *pgdat)
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
@@ -2533,10 +2540,34 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
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
2.0.0

