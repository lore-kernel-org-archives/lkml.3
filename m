Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab3KYO2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:28:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab3KYO0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:26:48 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 1/5] mm: compaction: encapsulate defer reset logic
Date: Mon, 25 Nov 2013 15:26:06 +0100
Message-Id: <1385389570-11393-2-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385389570-11393-1-git-send-email-vbabka@suse.cz>
References: <1385389570-11393-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there are several functions to manipulate the deferred compaction
state variables. The remaining case where the variables are touched directly
is when a successful allocation occurs in direct compaction, or is expected
to be successful in the future by kswapd. Here, the lowest order that is
expected to fail is updated, and in the case of direct compaction, the deferred
status is reset completely.

Create a new function compaction_defer_reset() to encapsulate this
functionality and make it easier to understand the code. No functional change.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/compaction.h | 12 ++++++++++++
 mm/compaction.c            |  9 ++++-----
 mm/page_alloc.c            |  5 +----
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 091d72e..da39978 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -62,6 +62,18 @@ static inline bool compaction_deferred(struct zone *zone, int order)
 	return zone->compact_considered < defer_limit;
 }
 
+/* Update defer tracking counters after successful allocation of given order */
+static inline void compaction_defer_reset(struct zone *zone, int order,
+		bool reset_shift)
+{
+	if (reset_shift) {
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
index 805165b..7c0073e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1116,12 +1116,11 @@ static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
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
index 580a5f0..50c7f67 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2243,10 +2243,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
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
1.8.1.4

