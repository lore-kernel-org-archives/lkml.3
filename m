Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaBGFJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:09:47 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52271 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaBGFIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:08:51 -0500
X-AuditID: 9c93016f-b7b0cae0000024a7-3c-52f46a5fe2c0
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/5] mm/compaction: check pageblock suitability once per pageblock
Date: Fri,  7 Feb 2014 14:08:45 +0900
Message-Id: <1391749726-28910-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isolation_suitable() and migrate_async_suitable() is used to be sure
that this pageblock range is fine to be migragted. It isn't needed to
call it on every page. Current code do well if not suitable, but, don't
do well when suitable. It re-check it on every valid pageblock.
This patch fix this situation by updating last_pageblock_nr.

Additionally, move PageBuddy() check after pageblock unit check,
since pageblock check is the first thing we should do and makes things
more simple.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/compaction.c b/mm/compaction.c
index b1ba297..985b782 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -520,26 +520,32 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 
 		/* If isolation recently failed, do not retry */
 		pageblock_nr = low_pfn >> pageblock_order;
-		if (!isolation_suitable(cc, page))
-			goto next_pageblock;
+		if (last_pageblock_nr != pageblock_nr) {
+			int mt;
+
+			if (!isolation_suitable(cc, page))
+				goto next_pageblock;
+
+			/*
+			 * For async migration, also only scan in MOVABLE
+			 * blocks. Async migration is optimistic to see if
+			 * the minimum amount of work satisfies the allocation
+			 */
+			mt = get_pageblock_migratetype(page);
+			if (!cc->sync && !migrate_async_suitable(mt)) {
+				cc->finished_update_migrate = true;
+				skipped_async_unsuitable = true;
+				goto next_pageblock;
+			}
+
+			last_pageblock_nr = pageblock_nr;
+		}
 
 		/* Skip if free */
 		if (PageBuddy(page))
 			continue;
 
 		/*
-		 * For async migration, also only scan in MOVABLE blocks. Async
-		 * migration is optimistic to see if the minimum amount of work
-		 * satisfies the allocation
-		 */
-		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
-		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
-			cc->finished_update_migrate = true;
-			skipped_async_unsuitable = true;
-			goto next_pageblock;
-		}
-
-		/*
 		 * Check may be lockless but that's ok as we recheck later.
 		 * It's possible to migrate LRU pages and balloon pages
 		 * Skip any other type of page
-- 
1.7.9.5

