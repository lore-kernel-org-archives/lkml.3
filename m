Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaBNGyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:54:14 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44298 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaBNGyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:54:09 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-02-52fdbd8c227f
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 4/5] mm/compaction: check pageblock suitability once per pageblock
Date: Fri, 14 Feb 2014 15:54:02 +0900
Message-Id: <1392360843-22261-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392360843-22261-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392360843-22261-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isolation_suitable() and migrate_async_suitable() is used to be sure
that this pageblock range is fine to be migragted. It isn't needed to
call it on every page. Current code do well if not suitable, but, don't
do well when suitable.

1) It re-checks isolation_suitable() on each page of a pageblock that was
already estabilished as suitable.
2) It re-checks migrate_async_suitable() on each page of a pageblock that
was not entered through the next_pageblock: label, because
last_pageblock_nr is not otherwise updated.

This patch fixes situation by 1) calling isolation_suitable() only once
per pageblock and 2) always updating last_pageblock_nr to the pageblock
that was just checked.

Additionally, move PageBuddy() check after pageblock unit check,
since pageblock check is the first thing we should do and makes things
more simple.

[vbabka@suse.cz: rephrase commit description]
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/compaction.c b/mm/compaction.c
index b1ba297..56536d3 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -520,26 +520,31 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 
 		/* If isolation recently failed, do not retry */
 		pageblock_nr = low_pfn >> pageblock_order;
-		if (!isolation_suitable(cc, page))
-			goto next_pageblock;
+		if (last_pageblock_nr != pageblock_nr) {
+			int mt;
+
+			last_pageblock_nr = pageblock_nr;
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
@@ -621,7 +626,6 @@ check_compact_cluster:
 
 next_pageblock:
 		low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
-		last_pageblock_nr = pageblock_nr;
 	}
 
 	acct_isolated(zone, locked, cc);
-- 
1.7.9.5

