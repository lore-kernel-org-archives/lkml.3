Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3CYIR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:17:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab3CYIR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:17:26 -0400
Date: Mon, 25 Mar 2013 09:17:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/8] Reduce system disruption due to kswapd
Message-ID: <20130325081717.GA2154@dhcp22.suse.cz>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <514F4D37.5030304@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514F4D37.5030304@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 24-03-13 20:00:07, Jiri Slaby wrote:
[...]
> Hi,
> 
> patch 1 does not apply (on the top of -next), so I can't test this :(.

It conflicts with (mm/vmscan.c: minor cleanup for kswapd). The one below
should apply
---
>From 027ce7ca785ecde184f858aa234bdc9461f1e3aa Mon Sep 17 00:00:00 2001
From: Mel Gorman <mgorman@suse.de>
Date: Mon, 11 Mar 2013 15:50:56 +0000
Subject: [PATCH] mm: vmscan: Limit the number of pages kswapd reclaims at
 each priority

The number of pages kswapd can reclaim is bound by the number of pages it
scans which is related to the size of the zone and the scanning priority. In
many cases the priority remains low because it's reset every SWAP_CLUSTER_MAX
reclaimed pages but in the event kswapd scans a large number of pages it
cannot reclaim, it will raise the priority and potentially discard a large
percentage of the zone as sc->nr_to_reclaim is ULONG_MAX. The user-visible
effect is a reclaim "spike" where a large percentage of memory is suddenly
freed. It would be bad enough if this was just unused memory but because
of how anon/file pages are balanced it is possible that applications get
pushed to swap unnecessarily.

This patch limits the number of pages kswapd will reclaim to the high
watermark. Reclaim will still overshoot due to it not being a hard limit as
shrink_lruvec() will ignore the sc.nr_to_reclaim at DEF_PRIORITY but it
prevents kswapd reclaiming the world at higher priorities. The number of
pages it reclaims is not adjusted for high-order allocations as kswapd will
reclaim excessively if it is to balance zones for high-order allocations.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c |   49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index df78d17..4835a7a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2593,6 +2593,32 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
 }
 
 /*
+ * kswapd shrinks the zone by the number of pages required to reach
+ * the high watermark.
+ */
+static void kswapd_shrink_zone(struct zone *zone,
+			       struct scan_control *sc,
+			       unsigned long lru_pages)
+{
+	unsigned long nr_slab;
+	struct reclaim_state *reclaim_state = current->reclaim_state;
+	struct shrink_control shrink = {
+		.gfp_mask = sc->gfp_mask,
+	};
+
+	/* Reclaim above the high watermark. */
+	sc->nr_to_reclaim = max(SWAP_CLUSTER_MAX, high_wmark_pages(zone));
+	shrink_zone(zone, sc);
+
+	reclaim_state->reclaimed_slab = 0;
+	nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
+	sc->nr_reclaimed += reclaim_state->reclaimed_slab;
+
+	if (nr_slab == 0 && !zone_reclaimable(zone))
+		zone->all_unreclaimable = 1;
+}
+
+/*
  * For kswapd, balance_pgdat() will work across all this node's zones until
  * they are all at high_wmark_pages(zone).
  *
@@ -2619,24 +2645,15 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 	bool pgdat_is_balanced = false;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
-	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 1,
 		.may_swap = 1,
-		/*
-		 * kswapd doesn't want to be bailed out while reclaim. because
-		 * we want to put equal scanning pressure on each zone.
-		 */
-		.nr_to_reclaim = ULONG_MAX,
 		.order = order,
 		.target_mem_cgroup = NULL,
 	};
-	struct shrink_control shrink = {
-		.gfp_mask = sc.gfp_mask,
-	};
 loop_again:
 	sc.priority = DEF_PRIORITY;
 	sc.nr_reclaimed = 0;
@@ -2708,7 +2725,7 @@ loop_again:
 		 */
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
-			int nr_slab, testorder;
+			int testorder;
 			unsigned long balance_gap;
 
 			if (!populated_zone(zone))
@@ -2756,16 +2773,8 @@ loop_again:
 
 			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
 			    !zone_balanced(zone, testorder,
-					   balance_gap, end_zone)) {
-				shrink_zone(zone, &sc);
-
-				reclaim_state->reclaimed_slab = 0;
-				nr_slab = shrink_slab(&shrink, sc.nr_scanned, lru_pages);
-				sc.nr_reclaimed += reclaim_state->reclaimed_slab;
-
-				if (nr_slab == 0 && !zone_reclaimable(zone))
-					zone->all_unreclaimable = 1;
-			}
+					   balance_gap, end_zone))
+				kswapd_shrink_zone(zone, &sc, lru_pages);
 
 			/*
 			 * If we're getting trouble reclaiming, start doing
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
