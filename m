Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaG1NMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:12:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbaG1NMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:12:09 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v5 13/14] mm, compaction: pass gfp mask to compact_control
Date: Mon, 28 Jul 2014 15:11:40 +0200
Message-Id: <1406553101-29326-14-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

struct compact_control currently converts the gfp mask to a migratetype, but we
need the entire gfp mask in a follow-up patch.

Pass the entire gfp mask as part of struct compact_control.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/compaction.c | 12 +++++++-----
 mm/internal.h   |  2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index e8645fb..dd3e4db 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1028,8 +1028,8 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
 
-static int compact_finished(struct zone *zone,
-			    struct compact_control *cc)
+static int compact_finished(struct zone *zone, struct compact_control *cc,
+			    const int migratetype)
 {
 	unsigned int order;
 	unsigned long watermark;
@@ -1075,7 +1075,7 @@ static int compact_finished(struct zone *zone,
 		struct free_area *area = &zone->free_area[order];
 
 		/* Job done if page is free of the right migratetype */
-		if (!list_empty(&area->free_list[cc->migratetype]))
+		if (!list_empty(&area->free_list[migratetype]))
 			return COMPACT_PARTIAL;
 
 		/* Job done if allocation would set block type */
@@ -1141,6 +1141,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	int ret;
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
+	const int migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 
 	ret = compaction_suitable(zone, cc->order);
@@ -1183,7 +1184,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 
 	migrate_prep_local();
 
-	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
+	while ((ret = compact_finished(zone, cc, migratetype)) ==
+						COMPACT_CONTINUE) {
 		int err;
 
 		switch (isolate_migratepages(zone, cc)) {
@@ -1238,7 +1240,7 @@ static unsigned long compact_zone_order(struct zone *zone, int order,
 		.nr_freepages = 0,
 		.nr_migratepages = 0,
 		.order = order,
-		.migratetype = gfpflags_to_migratetype(gfp_mask),
+		.gfp_mask = gfp_mask,
 		.zone = zone,
 		.mode = mode,
 	};
diff --git a/mm/internal.h b/mm/internal.h
index 86ae964..8293040 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -142,7 +142,7 @@ struct compact_control {
 	bool finished_update_migrate;
 
 	int order;			/* order a direct compactor needs */
-	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
+	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	struct zone *zone;
 	int contended;			/* Signal need_sched() or lock
 					 * contention detected during
-- 
1.8.4.5

