Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaKSVly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:41:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbaKSVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Yong-Taek Lee <ytk.lee@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 122/122] mm/page_alloc: prevent MIGRATE_RESERVE pages from being misplaced
Date: Wed, 19 Nov 2014 12:52:52 -0800
Message-Id: <20141119205212.887273185@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit 5bcc9f86ef09a933255ee66bd899d4601785dad5 upstream.

For the MIGRATE_RESERVE pages, it is useful when they do not get
misplaced on free_list of other migratetype, otherwise they might get
allocated prematurely and e.g.  fragment the MIGRATE_RESEVE pageblocks.
While this cannot be avoided completely when allocating new
MIGRATE_RESERVE pageblocks in min_free_kbytes sysctl handler, we should
prevent the misplacement where possible.

Currently, it is possible for the misplacement to happen when a
MIGRATE_RESERVE page is allocated on pcplist through rmqueue_bulk() as a
fallback for other desired migratetype, and then later freed back
through free_pcppages_bulk() without being actually used.  This happens
because free_pcppages_bulk() uses get_freepage_migratetype() to choose
the free_list, and rmqueue_bulk() calls set_freepage_migratetype() with
the *desired* migratetype and not the page's original MIGRATE_RESERVE
migratetype.

This patch fixes the problem by moving the call to
set_freepage_migratetype() from rmqueue_bulk() down to
__rmqueue_smallest() and __rmqueue_fallback() where the actual page's
migratetype (e.g.  from which free_list the page is taken from) is used.
Note that this migratetype might be different from the pageblock's
migratetype due to freepage stealing decisions.  This is OK, as page
stealing never uses MIGRATE_RESERVE as a fallback, and also takes care
to leave all MIGRATE_CMA pages on the correct freelist.

Therefore, as an additional benefit, the call to
get_pageblock_migratetype() from rmqueue_bulk() when CMA is enabled, can
be removed completely.  This relies on the fact that MIGRATE_CMA
pageblocks are created only during system init, and the above.  The
related is_migrate_isolate() check is also unnecessary, as memory
isolation has other ways to move pages between freelists, and drain pcp
lists containing pages that should be isolated.  The buffered_rmqueue()
can also benefit from calling get_freepage_migratetype() instead of
get_pageblock_migratetype().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -943,6 +943,7 @@ struct page *__rmqueue_smallest(struct z
 		rmv_page_order(page);
 		area->nr_free--;
 		expand(zone, page, order, current_order, area, migratetype);
+		set_freepage_migratetype(page, migratetype);
 		return page;
 	}
 
@@ -1069,7 +1070,9 @@ static int try_to_steal_freepages(struct
 
 	/*
 	 * When borrowing from MIGRATE_CMA, we need to release the excess
-	 * buddy pages to CMA itself.
+	 * buddy pages to CMA itself. We also ensure the freepage_migratetype
+	 * is set to CMA so it is returned to the correct freelist in case
+	 * the page ends up being not actually allocated from the pcp lists.
 	 */
 	if (is_migrate_cma(fallback_type))
 		return fallback_type;
@@ -1137,6 +1140,12 @@ __rmqueue_fallback(struct zone *zone, in
 
 			expand(zone, page, order, current_order, area,
 			       new_type);
+			/* The freepage_migratetype may differ from pageblock's
+			 * migratetype depending on the decisions in
+			 * try_to_steal_freepages. This is OK as long as it does
+			 * not differ for MIGRATE_CMA type.
+			 */
+			set_freepage_migratetype(page, new_type);
 
 			trace_mm_page_alloc_extfrag(page, order, current_order,
 				start_migratetype, migratetype, new_type);
@@ -1187,7 +1196,7 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, int cold)
 {
-	int mt = migratetype, i;
+	int i;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -1208,14 +1217,8 @@ static int rmqueue_bulk(struct zone *zon
 			list_add(&page->lru, list);
 		else
 			list_add_tail(&page->lru, list);
-		if (IS_ENABLED(CONFIG_CMA)) {
-			mt = get_pageblock_migratetype(page);
-			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
-				mt = migratetype;
-		}
-		set_freepage_migratetype(page, mt);
 		list = &page->lru;
-		if (is_migrate_cma(mt))
+		if (is_migrate_cma(get_freepage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
 	}
@@ -1584,7 +1587,7 @@ again:
 		if (!page)
 			goto failed;
 		__mod_zone_freepage_state(zone, -(1 << order),
-					  get_pageblock_migratetype(page));
+					  get_freepage_migratetype(page));
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));


