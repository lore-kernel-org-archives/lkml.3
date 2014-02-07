Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaBGLZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:25:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaBGLZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:25:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 71/88] mm/page-writeback.c: fix dirty_balance_reserve subtraction from dirtyable memory
Date: Fri,  7 Feb 2014 11:23:08 +0000
Message-Id: <1391772205-22239-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit a804552b9a15c931cfc2a92a2e0aed1add8b580a upstream.

Tejun reported stuttering and latency spikes on a system where random
tasks would enter direct reclaim and get stuck on dirty pages.  Around
50% of memory was occupied by tmpfs backed by an SSD, and another disk
(rotating) was reading and writing at max speed to shrink a partition.

: The problem was pretty ridiculous.  It's a 8gig machine w/ one ssd and 10k
: rpm harddrive and I could reliably reproduce constant stuttering every
: several seconds for as long as buffered IO was going on on the hard drive
: either with tmpfs occupying somewhere above 4gig or a test program which
: allocates about the same amount of anon memory.  Although swap usage was
: zero, turning off swap also made the problem go away too.
:
: The trigger conditions seem quite plausible - high anon memory usage w/
: heavy buffered IO and swap configured - and it's highly likely that this
: is happening in the wild too.  (this can happen with copying large files
: to usb sticks too, right?)

This patch (of 2):

The dirty_balance_reserve is an approximation of the fraction of free
pages that the page allocator does not make available for page cache
allocations.  As a result, it has to be taken into account when
calculating the amount of "dirtyable memory", the baseline to which
dirty_background_ratio and dirty_ratio are applied.

However, currently the reserve is subtracted from the sum of free and
reclaimable pages, which is non-sensical and leads to erroneous results
when the system is dominated by unreclaimable pages and the
dirty_balance_reserve is bigger than free+reclaimable.  In that case, at
least the already allocated cache should be considered dirtyable.

Fix the calculation by subtracting the reserve from the amount of free
pages, then adding the reclaimable pages on top.

[akpm@linux-foundation.org: fix CONFIG_HIGHMEM build]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Tested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/page-writeback.c | 55 +++++++++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 194cc02..31ea8e2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -173,6 +173,25 @@ static struct prop_descriptor vm_completions;
  * global dirtyable memory first.
  */
 
+/**
+ * zone_dirtyable_memory - number of dirtyable pages in a zone
+ * @zone: the zone
+ *
+ * Returns the zone's number of pages potentially available for dirty
+ * page cache.  This is the base value for the per-zone dirty limits.
+ */
+static unsigned long zone_dirtyable_memory(struct zone *zone)
+{
+	unsigned long nr_pages;
+
+	nr_pages = zone_page_state(zone, NR_FREE_PAGES);
+	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
+
+	nr_pages += zone_reclaimable_pages(zone);
+
+	return nr_pages;
+}
+
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
 #ifdef CONFIG_HIGHMEM
@@ -180,11 +199,9 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 	unsigned long x = 0;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
-		struct zone *z =
-			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+		struct zone *z = &NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
-		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
+		x += zone_dirtyable_memory(z);
 	}
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
@@ -220,9 +237,11 @@ static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x = global_page_state(NR_FREE_PAGES);
 	x -= min(x, dirty_balance_reserve);
 
+	x += global_reclaimable_pages();
+
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
 
@@ -271,32 +290,6 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 }
 
 /**
- * zone_dirtyable_memory - number of dirtyable pages in a zone
- * @zone: the zone
- *
- * Returns the zone's number of pages potentially available for dirty
- * page cache.  This is the base value for the per-zone dirty limits.
- */
-static unsigned long zone_dirtyable_memory(struct zone *zone)
-{
-	/*
-	 * The effective global number of dirtyable pages may exclude
-	 * highmem as a big-picture measure to keep the ratio between
-	 * dirty memory and lowmem reasonable.
-	 *
-	 * But this function is purely about the individual zone and a
-	 * highmem zone can hold its share of dirty pages, so we don't
-	 * care about vm_highmem_is_dirtyable here.
-	 */
-	unsigned long nr_pages = zone_page_state(zone, NR_FREE_PAGES) +
-		zone_reclaimable_pages(zone);
-
-	/* don't allow this to underflow */
-	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
-	return nr_pages;
-}
-
-/**
  * zone_dirty_limit - maximum number of dirty pages allowed in a zone
  * @zone: the zone
  *
-- 
1.8.3.2

