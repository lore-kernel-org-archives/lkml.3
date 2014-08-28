Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaH1SgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaH1SgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:03 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 15/97] mm: __rmqueue_fallback() should respect pageblock type
Date: Thu, 28 Aug 2014 19:34:23 +0100
Message-Id: <1409250945-30874-16-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 0cbef29a782162a3896487901eca4550bfa397ef upstream.

When __rmqueue_fallback() doesn't find a free block with the required size
it splits a larger page and puts the rest of the page onto the free list.

But it has one serious mistake.  When putting back, __rmqueue_fallback()
always use start_migratetype if type is not CMA.  However,
__rmqueue_fallback() is only called when all of the start_migratetype
queue is empty.  That said, __rmqueue_fallback always puts back memory to
the wrong queue except try_to_steal_freepages() changed pageblock type
(i.e.  requested size is smaller than half of page block).  The end result
is that the antifragmentation framework increases fragmenation instead of
decreasing it.

Mel's original anti fragmentation does the right thing.  But commit
47118af076f6 ("mm: mmzone: MIGRATE_CMA migration type added") broke it.

This patch restores sane and old behavior.  It also removes an incorrect
comment which was introduced by commit fef903efcf0c ("mm/page_alloc.c:
restructure free-page stealing code and fix a bug").

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e285eac..baef87e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1042,6 +1042,10 @@ static int try_to_steal_freepages(struct zone *zone, struct page *page,
 {
 	int current_order = page_order(page);
 
+	/*
+	 * When borrowing from MIGRATE_CMA, we need to release the excess
+	 * buddy pages to CMA itself.
+	 */
 	if (is_migrate_cma(fallback_type))
 		return fallback_type;
 
@@ -1106,17 +1110,8 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 			list_del(&page->lru);
 			rmv_page_order(page);
 
-			/*
-			 * Borrow the excess buddy pages as well, irrespective
-			 * of whether we stole freepages, or took ownership of
-			 * the pageblock or not.
-			 *
-			 * Exception: When borrowing from MIGRATE_CMA, release
-			 * the excess buddy pages to CMA itself.
-			 */
 			expand(zone, page, order, current_order, area,
-			       is_migrate_cma(migratetype)
-			     ? migratetype : start_migratetype);
+			       new_type);
 
 			trace_mm_page_alloc_extfrag(page, order, current_order,
 				start_migratetype, migratetype, new_type);
-- 
1.8.4.5

