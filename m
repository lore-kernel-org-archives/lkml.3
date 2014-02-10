Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaBJUIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:08:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaBJTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:45:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 102/124] mm/page-writeback.c: do not count anon pages as dirtyable memory
Date: Mon, 10 Feb 2014 11:40:42 -0800
Message-Id: <1392061264-28124-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit a1c3bfb2f67ef766de03f1f56bdfff9c8595ab14 upstream.

The VM is currently heavily tuned to avoid swapping.  Whether that is
good or bad is a separate discussion, but as long as the VM won't swap
to make room for dirty cache, we can not consider anonymous pages when
calculating the amount of dirtyable memory, the baseline to which
dirty_background_ratio and dirty_ratio are applied.

A simple workload that occupies a significant size (40+%, depending on
memory layout, storage speeds etc.) of memory with anon/tmpfs pages and
uses the remainder for a streaming writer demonstrates this problem.  In
that case, the actual cache pages are a small fraction of what is
considered dirtyable overall, which results in an relatively large
portion of the cache pages to be dirtied.  As kswapd starts rotating
these, random tasks enter direct reclaim and stall on IO.

Only consider free pages and file pages dirtyable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Tested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/vmstat.h |  3 ---
 mm/page-writeback.c    |  6 +++--
 mm/vmscan.c            | 59 ++++++++++++++++----------------------------------
 3 files changed, 23 insertions(+), 45 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index a13291f..4383a39 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -147,9 +147,6 @@ static inline unsigned long zone_page_state_snapshot(struct zone *zone,
 	return x;
 }
 
-extern unsigned long global_reclaimable_pages(void);
-extern unsigned long zone_reclaimable_pages(struct zone *zone);
-
 #ifdef CONFIG_NUMA
 /*
  * Determine the per node value of a stat item. This function
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 779afb0..68fe53b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -201,7 +201,8 @@ static unsigned long zone_dirtyable_memory(struct zone *zone)
 	nr_pages = zone_page_state(zone, NR_FREE_PAGES);
 	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
 
-	nr_pages += zone_reclaimable_pages(zone);
+	nr_pages += zone_page_state(zone, NR_INACTIVE_FILE);
+	nr_pages += zone_page_state(zone, NR_ACTIVE_FILE);
 
 	return nr_pages;
 }
@@ -254,7 +255,8 @@ static unsigned long global_dirtyable_memory(void)
 	x = global_page_state(NR_FREE_PAGES);
 	x -= min(x, dirty_balance_reserve);
 
-	x += global_reclaimable_pages();
+	x += global_page_state(NR_INACTIVE_FILE);
+	x += global_page_state(NR_ACTIVE_FILE);
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8142623..9dcc836 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -146,6 +146,25 @@ static bool global_reclaim(struct scan_control *sc)
 }
 #endif
 
+static unsigned long zone_reclaimable_pages(struct zone *zone)
+{
+	int nr;
+
+	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
+	     zone_page_state(zone, NR_INACTIVE_FILE);
+
+	if (nr_swap_pages > 0)
+		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
+		      zone_page_state(zone, NR_INACTIVE_ANON);
+
+	return nr;
+}
+
+static bool zone_reclaimable(struct zone *zone)
+{
+	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
+}
+
 static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (!mem_cgroup_disabled())
@@ -2066,11 +2085,6 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	return aborted_reclaim;
 }
 
-static bool zone_reclaimable(struct zone *zone)
-{
-	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
-}
-
 /* All zones in zonelist are unreclaimable? */
 static bool all_unreclaimable(struct zonelist *zonelist,
 		struct scan_control *sc)
@@ -3041,41 +3055,6 @@ void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx)
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
-/*
- * The reclaimable count would be mostly accurate.
- * The less reclaimable pages may be
- * - mlocked pages, which will be moved to unevictable list when encountered
- * - mapped pages, which may require several travels to be reclaimed
- * - dirty pages, which is not "instantly" reclaimable
- */
-unsigned long global_reclaimable_pages(void)
-{
-	int nr;
-
-	nr = global_page_state(NR_ACTIVE_FILE) +
-	     global_page_state(NR_INACTIVE_FILE);
-
-	if (nr_swap_pages > 0)
-		nr += global_page_state(NR_ACTIVE_ANON) +
-		      global_page_state(NR_INACTIVE_ANON);
-
-	return nr;
-}
-
-unsigned long zone_reclaimable_pages(struct zone *zone)
-{
-	int nr;
-
-	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
-	     zone_page_state(zone, NR_INACTIVE_FILE);
-
-	if (nr_swap_pages > 0)
-		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
-		      zone_page_state(zone, NR_INACTIVE_ANON);
-
-	return nr;
-}
-
 #ifdef CONFIG_HIBERNATION
 /*
  * Try to free `nr_to_reclaim' of memory, system-wide, and return the number of
-- 
1.8.3.2

