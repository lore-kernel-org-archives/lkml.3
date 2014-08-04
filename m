Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaHDI6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:58:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaHDI4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:56:05 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v6 04/13] mm, compaction: do not recheck suitable_migration_target under lock
Date: Mon,  4 Aug 2014 10:55:15 +0200
Message-Id: <1407142524-2025-5-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407142524-2025-1-git-send-email-vbabka@suse.cz>
References: <1407142524-2025-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isolate_freepages_block() rechecks if the pageblock is suitable to be a target
for migration after it has taken the zone->lock. However, the check has been
optimized to occur only once per pageblock, and compact_checklock_irqsave()
might be dropping and reacquiring lock, which means somebody else might have
changed the pageblock's migratetype meanwhile.

Furthermore, nothing prevents the migratetype to change right after
isolate_freepages_block() has finished isolating. Given how imperfect this is,
it's simpler to just rely on the check done in isolate_freepages() without
lock, and not pretend that the recheck under lock guarantees anything. It is
just a heuristic after all.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 mm/compaction.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 68803c8..9484a4f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -276,7 +276,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 	struct page *cursor, *valid_page = NULL;
 	unsigned long flags;
 	bool locked = false;
-	bool checked_pageblock = false;
 
 	cursor = pfn_to_page(blockpfn);
 
@@ -307,18 +306,6 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		if (!locked)
 			break;
 
-		/* Recheck this is a suitable migration target under lock */
-		if (!strict && !checked_pageblock) {
-			/*
-			 * We need to check suitability of pageblock only once
-			 * and this isolate_freepages_block() is called with
-			 * pageblock range, so just check once is sufficient.
-			 */
-			checked_pageblock = true;
-			if (!suitable_migration_target(page))
-				break;
-		}
-
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))
 			goto isolate_fail;
-- 
1.8.4.5

