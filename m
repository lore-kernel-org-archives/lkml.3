Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3EHQDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:03:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773Ab3EHQDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:03:19 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave@sr71.net>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 13/22] mm: page allocator: Use list_splice to refill the magazine
Date: Wed,  8 May 2013 17:02:58 +0100
Message-Id: <1368028987-8369-14-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368028987-8369-1-git-send-email-mgorman@suse.de>
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to operate on one page at a time.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bb2f116..c014b7a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1333,6 +1333,7 @@ struct page *rmqueue_magazine(struct zone *zone, int migratetype)
 	/* Only acquire the lock if there is a reasonable chance of success */
 	if (zone->noirq_magazine.nr_free) {
 		spin_lock(&zone->magazine_lock);
+retry:
 		page = __rmqueue_magazine(zone, migratetype);
 		spin_unlock(&zone->magazine_lock);
 	}
@@ -1350,7 +1351,7 @@ struct page *rmqueue_magazine(struct zone *zone, int migratetype)
 			page = __rmqueue(zone, 0, migratetype);
 			if (!page)
 				break;
-			list_add_tail(&page->lru, &alloc_list);
+			list_add(&page->lru, &alloc_list);
 			nr_alloced++;
 		}
 		if (!is_migrate_cma(mt))
@@ -1358,15 +1359,13 @@ struct page *rmqueue_magazine(struct zone *zone, int migratetype)
 		else
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, -nr_alloced);
 		spin_unlock_irqrestore(&zone->lock, flags);
+		if (!nr_alloced)
+			return NULL;
 
 		spin_lock(&zone->magazine_lock);
-		while (!list_empty(&alloc_list)) {
-			page = list_entry(alloc_list.next, struct page, lru);
-			list_move_tail(&page->lru, &area->free_list[migratetype]);
-			area->nr_free++;
-		}
-		page = __rmqueue_magazine(zone, migratetype);
-		spin_unlock(&zone->magazine_lock);
+		list_splice(&alloc_list, &area->free_list[migratetype]);
+		area->nr_free += nr_alloced;
+		goto retry;
 	}
 
 	return page;
-- 
1.8.1.4

