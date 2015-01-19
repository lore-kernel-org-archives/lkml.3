Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbbASKGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:06:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbbASKFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:05:43 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 3/5] mm, compaction: encapsulate resetting cached scanner positions
Date: Mon, 19 Jan 2015 11:05:18 +0100
Message-Id: <1421661920-4114-4-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1421661920-4114-1-git-send-email-vbabka@suse.cz>
References: <1421661920-4114-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reseting the cached compaction scanner positions is now done implicitly in
__reset_isolation_suitable() and compact_finished(). Encapsulate the
functionality in a new function reset_cached_positions() and call it
explicitly where needed.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 45799a4..5626220 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -123,6 +123,13 @@ static inline bool isolation_suitable(struct compact_control *cc,
 	return !get_pageblock_skip(page);
 }
 
+static void reset_cached_positions(struct zone *zone)
+{
+	zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
+	zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
+	zone->compact_cached_free_pfn = zone_end_pfn(zone);
+}
+
 /*
  * This function is called to clear all cached information on pageblocks that
  * should be skipped for page isolation when the migrate and free page scanner
@@ -134,9 +141,6 @@ static void __reset_isolation_suitable(struct zone *zone)
 	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long pfn;
 
-	zone->compact_cached_migrate_pfn[0] = start_pfn;
-	zone->compact_cached_migrate_pfn[1] = start_pfn;
-	zone->compact_cached_free_pfn = end_pfn;
 	zone->compact_blockskip_flush = false;
 
 	/* Walk the zone and mark every pageblock as suitable for isolation */
@@ -166,8 +170,10 @@ void reset_isolation_suitable(pg_data_t *pgdat)
 			continue;
 
 		/* Only flush if a full compaction finished recently */
-		if (zone->compact_blockskip_flush)
+		if (zone->compact_blockskip_flush) {
 			__reset_isolation_suitable(zone);
+			reset_cached_positions(zone);
+		}
 	}
 }
 
@@ -1059,9 +1065,7 @@ static int compact_finished(struct zone *zone, struct compact_control *cc,
 	/* Compaction run completes if the migrate and free scanner meet */
 	if (compact_scanners_met(cc)) {
 		/* Let the next compaction start anew. */
-		zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
-		zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
-		zone->compact_cached_free_pfn = zone_end_pfn(zone);
+		reset_cached_positions(zone);
 
 		/*
 		 * Mark that the PG_migrate_skip information should be cleared
@@ -1187,8 +1191,10 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	 * is about to be retried after being deferred. kswapd does not do
 	 * this reset as it'll reset the cached information when going to sleep.
 	 */
-	if (compaction_restarting(zone, cc->order) && !current_is_kswapd())
+	if (compaction_restarting(zone, cc->order) && !current_is_kswapd()) {
 		__reset_isolation_suitable(zone);
+		reset_cached_positions(zone);
+	}
 
 	/*
 	 * Setup to move all movable pages to the end of the zone. Used cached
-- 
2.1.2

