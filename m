Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936700AbaFIJkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:40:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772AbaFIJ0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:34 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 01/10] mm, compaction: do not recheck suitable_migration_target under lock
Date: Mon,  9 Jun 2014 11:26:13 +0200
Message-Id: <1402305982-6928-1-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
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
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
---
I suggest folding mm-compactionc-isolate_freepages_block-small-tuneup.patch into this

 mm/compaction.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 5175019..b73b182 100644
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

