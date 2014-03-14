Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaCNPfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:35:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:34111 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbaCNPfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:35:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] mm: vmscan: do not swap anon pages just because free+file is low
Date: Fri, 14 Mar 2014 11:35:02 -0400
Message-Id: <1394811302-30468-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page reclaim force-scans / swaps anonymous pages when file cache drops
below the high watermark of a zone in order to prevent what little
cache remains from thrashing.

However, on bigger machines the high watermark value can be quite
large and when the workload is dominated by a static anonymous/shmem
set, the file set might just be a small window of used-once cache.  In
such situations, the VM starts swapping heavily when instead it should
be recycling the no longer used cache.

This is a longer-standing problem, but it's more likely to trigger
after 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy")
because file pages can no longer accumulate in a single zone and are
dispersed into smaller fractions among the available zones.

To resolve this, do not force scan anon when file pages are low but
instead rely on the scan/rotation ratios to make the right prediction.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@kernel.org> [3.12+]
---
 mm/vmscan.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9c74b409681..e58e9ad5b5d1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1848,7 +1848,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	struct zone *zone = lruvec_zone(lruvec);
 	unsigned long anon_prio, file_prio;
 	enum scan_balance scan_balance;
-	unsigned long anon, file, free;
+	unsigned long anon, file;
 	bool force_scan = false;
 	unsigned long ap, fp;
 	enum lru_list lru;
@@ -1902,20 +1902,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
 	/*
-	 * If it's foreseeable that reclaiming the file cache won't be
-	 * enough to get the zone back into a desirable shape, we have
-	 * to swap.  Better start now and leave the - probably heavily
-	 * thrashing - remaining file pages alone.
-	 */
-	if (global_reclaim(sc)) {
-		free = zone_page_state(zone, NR_FREE_PAGES);
-		if (unlikely(file + free <= high_wmark_pages(zone))) {
-			scan_balance = SCAN_ANON;
-			goto out;
-		}
-	}
-
-	/*
 	 * There is enough inactive page cache, do not reclaim
 	 * anything from the anonymous working set right now.
 	 */
-- 
1.9.0

