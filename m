Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaH1TIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:08:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaH1SgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:08 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 20/97] mm: compaction: encapsulate defer reset logic
Date: Thu, 28 Aug 2014 19:34:28 +0100
Message-Id: <1409250945-30874-21-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit de6c60a6c115acaa721cfd499e028a413d1fcbf3 upstream.

Currently there are several functions to manipulate the deferred
compaction state variables.  The remaining case where the variables are
touched directly is when a successful allocation occurs in direct
compaction, or is expected to be successful in the future by kswapd.
Here, the lowest order that is expected to fail is updated, and in the
case of successful allocation, the deferred status and counter is reset
completely.

Create a new function compaction_defer_reset() to encapsulate this
functionality and make it easier to understand the code.  No functional
change.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/compaction.h | 16 ++++++++++++++++
 mm/compaction.c            |  9 ++++-----
 mm/page_alloc.c            |  5 +----
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 091d72e..7e1c76e 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -62,6 +62,22 @@ static inline bool compaction_deferred(struct zone *zone, int order)
 	return zone->compact_considered < defer_limit;
 }
 
+/*
+ * Update defer tracking counters after successful compaction of given order,
+ * which means an allocation either succeeded (alloc_success == true) or is
+ * expected to succeed.
+ */
+static inline void compaction_defer_reset(struct zone *zone, int order,
+		bool alloc_success)
+{
+	if (alloc_success) {
+		zone->compact_considered = 0;
+		zone->compact_defer_shift = 0;
+	}
+	if (order >= zone->compact_order_failed)
+		zone->compact_order_failed = order + 1;
+}
+
 /* Returns true if restarting compaction after many failures */
 static inline bool compaction_restarting(struct zone *zone, int order)
 {
diff --git a/mm/compaction.c b/mm/compaction.c
index d656656..c55bd45 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1144,12 +1144,11 @@ static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 			compact_zone(zone, cc);
 
 		if (cc->order > 0) {
-			int ok = zone_watermark_ok(zone, cc->order,
-						low_wmark_pages(zone), 0, 0);
-			if (ok && cc->order >= zone->compact_order_failed)
-				zone->compact_order_failed = cc->order + 1;
+			if (zone_watermark_ok(zone, cc->order,
+						low_wmark_pages(zone), 0, 0))
+				compaction_defer_reset(zone, cc->order, false);
 			/* Currently async compaction is never deferred. */
-			else if (!ok && cc->sync)
+			else if (cc->sync)
 				defer_compaction(zone, cc->order);
 		}
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index baef87e..3078eaf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2251,10 +2251,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 				preferred_zone, migratetype);
 		if (page) {
 			preferred_zone->compact_blockskip_flush = false;
-			preferred_zone->compact_considered = 0;
-			preferred_zone->compact_defer_shift = 0;
-			if (order >= preferred_zone->compact_order_failed)
-				preferred_zone->compact_order_failed = order + 1;
+			compaction_defer_reset(preferred_zone, order, true);
 			count_vm_event(COMPACTSUCCESS);
 			return page;
 		}
-- 
1.8.4.5

