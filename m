Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967142AbaFTUZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:25:00 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:38298 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965993AbaFTUY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:24:58 -0400
Date: Fri, 20 Jun 2014 16:24:49 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mm: vmscan: rework compaction-ready signaling in
 direct reclaim
Message-ID: <20140620202449.GA30849@cmpxchg.org>
References: <1403282030-29915-1-git-send-email-hannes@cmpxchg.org>
 <1403282030-29915-2-git-send-email-hannes@cmpxchg.org>
 <53A467A3.1050008@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A467A3.1050008@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 06:56:03PM +0200, Vlastimil Babka wrote:
> On 06/20/2014 06:33 PM, Johannes Weiner wrote:
> > Page reclaim for a higher-order page runs until compaction is ready,
> > then aborts and signals this situation through the return value of
> > shrink_zones().  This is an oddly specific signal to encode in the
> > return value of shrink_zones(), though, and can be quite confusing.
> > 
> > Introduce sc->compaction_ready and signal the compactability of the
> > zones out-of-band to free up the return value of shrink_zones() for
> > actual zone reclaimability.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks, Vlastimil!

> > @@ -2391,22 +2384,24 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
> >  			if (sc->priority != DEF_PRIORITY &&
> >  			    !zone_reclaimable(zone))
> >  				continue;	/* Let kswapd poll it */
> > -			if (IS_ENABLED(CONFIG_COMPACTION)) {
> > -				/*
> > -				 * If we already have plenty of memory free for
> > -				 * compaction in this zone, don't free any more.
> > -				 * Even though compaction is invoked for any
> > -				 * non-zero order, only frequent costly order
> > -				 * reclamation is disruptive enough to become a
> > -				 * noticeable problem, like transparent huge
> > -				 * page allocations.
> > -				 */
> > -				if ((zonelist_zone_idx(z) <= requested_highidx)
> > -				    && compaction_ready(zone, sc)) {
> > -					aborted_reclaim = true;
> > -					continue;
> > -				}
> > +
> > +			/*
> > +			 * If we already have plenty of memory free
> > +			 * for compaction in this zone, don't free any
> > +			 * more.  Even though compaction is invoked
> > +			 * for any non-zero order, only frequent
> > +			 * costly order reclamation is disruptive
> > +			 * enough to become a noticeable problem, like
> > +			 * transparent huge page allocations.
> > +			 */
> 
> You moved this comment block left, yet you further shortened the individual lines, despite
> there is now more space to prolong them.

This is a result of using emacs' auto-fill all the time when writing
comments, I have to watch my reflexes while moving stuff around :-)

Updated patch:

---
>From cd48b73fdca9e23aa21f65e9af1f850dbac5ab8e Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 11 Jun 2014 12:53:59 -0400
Subject: [patch] mm: vmscan: rework compaction-ready signaling in direct
 reclaim

Page reclaim for a higher-order page runs until compaction is ready,
then aborts and signals this situation through the return value of
shrink_zones().  This is an oddly specific signal to encode in the
return value of shrink_zones(), though, and can be quite confusing.

Introduce sc->compaction_ready and signal the compactability of the
zones out-of-band to free up the return value of shrink_zones() for
actual zone reclaimability.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/vmscan.c | 67 ++++++++++++++++++++++++++++---------------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 19b5b8016209..35747a75bf08 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -65,6 +65,9 @@ struct scan_control {
 	/* Number of pages freed so far during a call to shrink_zones() */
 	unsigned long nr_reclaimed;
 
+	/* One of the zones is ready for compaction */
+	int compaction_ready;
+
 	/* How many pages shrink_list() should reclaim */
 	unsigned long nr_to_reclaim;
 
@@ -2292,15 +2295,11 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 }
 
 /* Returns true if compaction should go ahead for a high-order request */
-static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
+static inline bool compaction_ready(struct zone *zone, int order)
 {
 	unsigned long balance_gap, watermark;
 	bool watermark_ok;
 
-	/* Do not consider compaction for orders reclaim is meant to satisfy */
-	if (sc->order <= PAGE_ALLOC_COSTLY_ORDER)
-		return false;
-
 	/*
 	 * Compaction takes time to run and there are potentially other
 	 * callers using the pages just freed. Continue reclaiming until
@@ -2309,18 +2308,18 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 	 */
 	balance_gap = min(low_wmark_pages(zone), DIV_ROUND_UP(
 			zone->managed_pages, KSWAPD_ZONE_BALANCE_GAP_RATIO));
-	watermark = high_wmark_pages(zone) + balance_gap + (2UL << sc->order);
+	watermark = high_wmark_pages(zone) + balance_gap + (2UL << order);
 	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
 
 	/*
 	 * If compaction is deferred, reclaim up to a point where
 	 * compaction will have a chance of success when re-enabled
 	 */
-	if (compaction_deferred(zone, sc->order))
+	if (compaction_deferred(zone, order))
 		return watermark_ok;
 
 	/* If compaction is not ready to start, keep reclaiming */
-	if (!compaction_suitable(zone, sc->order))
+	if (!compaction_suitable(zone, order))
 		return false;
 
 	return watermark_ok;
@@ -2341,20 +2340,14 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
- *
- * This function returns true if a zone is being reclaimed for a costly
- * high-order allocation and compaction is ready to begin. This indicates to
- * the caller that it should consider retrying the allocation instead of
- * further reclaim.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	unsigned long lru_pages = 0;
-	bool aborted_reclaim = false;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	gfp_t orig_mask;
 	struct shrink_control shrink = {
@@ -2391,22 +2384,24 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 			if (sc->priority != DEF_PRIORITY &&
 			    !zone_reclaimable(zone))
 				continue;	/* Let kswapd poll it */
-			if (IS_ENABLED(CONFIG_COMPACTION)) {
-				/*
-				 * If we already have plenty of memory free for
-				 * compaction in this zone, don't free any more.
-				 * Even though compaction is invoked for any
-				 * non-zero order, only frequent costly order
-				 * reclamation is disruptive enough to become a
-				 * noticeable problem, like transparent huge
-				 * page allocations.
-				 */
-				if ((zonelist_zone_idx(z) <= requested_highidx)
-				    && compaction_ready(zone, sc)) {
-					aborted_reclaim = true;
-					continue;
-				}
+
+			/*
+			 * If we already have plenty of memory free for
+			 * compaction in this zone, don't free any more.
+			 * Even though compaction is invoked for any
+			 * non-zero order, only frequent costly order
+			 * reclamation is disruptive enough to become a
+			 * noticeable problem, like transparent huge
+			 * page allocations.
+			 */
+			if (IS_ENABLED(CONFIG_COMPACTION) &&
+			    sc->order > PAGE_ALLOC_COSTLY_ORDER &&
+			    zonelist_zone_idx(z) <= requested_highidx &&
+			    compaction_ready(zone, sc->order)) {
+				sc->compaction_ready = true;
+				continue;
 			}
+
 			/*
 			 * This steals pages from memory cgroups over softlimit
 			 * and returns the number of reclaimed pages and
@@ -2444,8 +2439,6 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	 * promoted it to __GFP_HIGHMEM.
 	 */
 	sc->gfp_mask = orig_mask;
-
-	return aborted_reclaim;
 }
 
 /* All zones in zonelist are unreclaimable? */
@@ -2489,7 +2482,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 {
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
-	bool aborted_reclaim;
 
 	delayacct_freepages_start();
 
@@ -2500,12 +2492,15 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(zonelist, sc);
+		shrink_zones(zonelist, sc);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			goto out;
 
+		if (sc->compaction_ready)
+			goto out;
+
 		/*
 		 * If we're getting trouble reclaiming, start doing
 		 * writepage even in laptop mode.
@@ -2526,7 +2521,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 						WB_REASON_TRY_TO_FREE_PAGES);
 			sc->may_writepage = 1;
 		}
-	} while (--sc->priority >= 0 && !aborted_reclaim);
+	} while (--sc->priority >= 0);
 
 out:
 	delayacct_freepages_end();
@@ -2535,7 +2530,7 @@ out:
 		return sc->nr_reclaimed;
 
 	/* Aborted reclaim to try compaction? don't OOM, then */
-	if (aborted_reclaim)
+	if (sc->compaction_ready)
 		return 1;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-- 
2.0.0
