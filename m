Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbaH1TFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:05:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaH1SgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:17 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 28/97] mm/compaction: disallow high-order page for migration target
Date: Thu, 28 Aug 2014 19:34:36 +0100
Message-Id: <1409250945-30874-29-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit 7d348b9ea64db0a315d777ce7d4b06697f946503 upstream.

Purpose of compaction is to get a high order page.  Currently, if we
find high-order page while searching migration target page, we break it
to order-0 pages and use them as migration target.  It is contrary to
purpose of compaction, so disallow high-order page to be used for
migration target.

Additionally, clean-up logic in suitable_migration_target() to simplify
the code.  There is no functional changes from this clean-up.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 4885387..5e48834 100644
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
1.8.4.5

