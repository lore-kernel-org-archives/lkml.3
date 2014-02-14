Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaBNGyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:54:11 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53657 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaBNGyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:54:07 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-ff-52fdbd8c1cdd
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 1/5] mm/compaction: disallow high-order page for migration target
Date: Fri, 14 Feb 2014 15:53:59 +0900
Message-Id: <1392360843-22261-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392360843-22261-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392360843-22261-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Purpose of compaction is to get a high order page. Currently, if we find
high-order page while searching migration target page, we break it to
order-0 pages and use them as migration target. It is contrary to purpose
of compaction, so disallow high-order page to be used for
migration target.

Additionally, clean-up logic in suitable_migration_target() to simplify
the code. There is no functional changes from this clean-up.

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/compaction.c b/mm/compaction.c
index 3a91a2e..bbe1260 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -217,21 +217,12 @@ static inline bool compact_trylock_irqsave(spinlock_t *lock,
 /* Returns true if the page is within a block suitable for migration to */
 static bool suitable_migration_target(struct page *page)
 {
-	int migratetype = get_pageblock_migratetype(page);
-
-	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
-	if (migratetype == MIGRATE_RESERVE)
-		return false;
-
-	if (is_migrate_isolate(migratetype))
-		return false;
-
-	/* If the page is a large free page, then allow migration */
+	/* If the page is a large free page, then disallow migration */
 	if (PageBuddy(page) && page_order(page) >= pageblock_order)
-		return true;
+		return false;
 
 	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
-	if (migrate_async_suitable(migratetype))
+	if (migrate_async_suitable(get_pageblock_migratetype(page)))
 		return true;
 
 	/* Otherwise skip the block */
-- 
1.7.9.5

