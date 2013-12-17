Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3LQQse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:48:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab3LQQs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:48:28 -0500
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/6] mm: page_alloc: Break out zone page aging distribution into its own helper
Date: Tue, 17 Dec 2013 16:48:20 +0000
Message-Id: <1387298904-8824-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1387298904-8824-1-git-send-email-mgorman@suse.de>
References: <1387298904-8824-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the decision on whether to round-robin allocations between
zones and nodes into its own helper functions. It'll make some later patches
easier to understand and it will be automatically inlined.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 63 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f861d02..64020eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1872,6 +1872,42 @@ static inline void init_zone_allows_reclaim(int nid)
 #endif	/* CONFIG_NUMA */
 
 /*
+ * Distribute pages in proportion to the individual zone size to ensure fair
+ * page aging.  The zone a page was allocated in should have no effect on the
+ * time the page has in memory before being reclaimed.
+ * 
+ * Returns true if this zone should be skipped to spread the page ages to
+ * other zones.
+ */
+static bool zone_distribute_age(gfp_t gfp_mask, struct zone *preferred_zone,
+				struct zone *zone, int alloc_flags)
+{
+	/* Only round robin in the allocator fast path */
+	if (!(alloc_flags & ALLOC_WMARK_LOW))
+		return false;
+
+	/* Only round robin pages likely to be LRU or reclaimable slab */
+	if (!(gfp_mask & GFP_MOVABLE_MASK))
+		return false;
+
+	/* Distribute to the next zone if this zone has exhausted its batch */
+	if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
+		return true;
+
+	/*
+	 * When zone_reclaim_mode is enabled, try to stay in local zones in the
+	 * fastpath.  If that fails, the slowpath is entered, which will do
+	 * another pass starting with the local zones, but ultimately fall back
+	 * back to remote zones that do not partake in the fairness round-robin
+	 * cycle of this zonelist.
+	 */
+	if (zone_reclaim_mode && !zone_local(preferred_zone, zone))
+		return true;
+
+	return false;
+}
+
+/*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
  */
@@ -1907,27 +1943,12 @@ zonelist_scan:
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 		if (unlikely(alloc_flags & ALLOC_NO_WATERMARKS))
 			goto try_this_zone;
-		/*
-		 * Distribute pages in proportion to the individual
-		 * zone size to ensure fair page aging.  The zone a
-		 * page was allocated in should have no effect on the
-		 * time the page has in memory before being reclaimed.
-		 *
-		 * When zone_reclaim_mode is enabled, try to stay in
-		 * local zones in the fastpath.  If that fails, the
-		 * slowpath is entered, which will do another pass
-		 * starting with the local zones, but ultimately fall
-		 * back to remote zones that do not partake in the
-		 * fairness round-robin cycle of this zonelist.
-		 */
-		if ((alloc_flags & ALLOC_WMARK_LOW) &&
-		    (gfp_mask & GFP_MOVABLE_MASK)) {
-			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
-				continue;
-			if (zone_reclaim_mode &&
-			    !zone_local(preferred_zone, zone))
-				continue;
-		}
+
+		/* Distribute pages to ensure fair page aging */
+		if (zone_distribute_age(gfp_mask, preferred_zone, zone,
+					alloc_flags))
+			continue;
+
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a zone that is within its dirty
-- 
1.8.4

