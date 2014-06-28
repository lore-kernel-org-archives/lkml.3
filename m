Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaF1TQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:16:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaF1Rrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 14/77] mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL
Date: Sat, 28 Jun 2014 10:46:07 -0700
Message-Id: <20140628174522.352181945@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2286,10 +2286,17 @@ static bool pfmemalloc_watermark_ok(pg_d
 
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
@@ -2314,9 +2321,9 @@ static bool pfmemalloc_watermark_ok(pg_d
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
@@ -2335,10 +2342,34 @@ static bool throttle_direct_reclaim(gfp_
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


