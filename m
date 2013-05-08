Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab3EHQDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:03:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab3EHQDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:03:11 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave@sr71.net>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 02/22] mm: page allocator: Push down where IRQs are disabled during page free
Date: Wed,  8 May 2013 17:02:47 +0100
Message-Id: <1368028987-8369-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368028987-8369-1-git-send-email-mgorman@suse.de>
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch pushes IRQ disabling down into free_one_page(). This simplifies
the logic in free_hot_cold_page() slightly by making it clear that zone->lock
is an IRQ-safe spinlock. The current arrangement has the IRQ disabling
happen in one function and the spinlock been taken in another. Functionally,
there is no difference.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 277ecee..50c9315 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -686,14 +686,18 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 static void free_one_page(struct zone *zone, struct page *page, int order,
 				int migratetype)
 {
-	spin_lock(&zone->lock);
+	unsigned long flags;
+	set_freepage_migratetype(page, migratetype);
+
+	spin_lock_irqsave(&zone->lock, flags);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
+	__count_vm_events(PGFREE, 1 << order);
 
 	__free_one_page(page, zone, order, migratetype);
 	if (unlikely(!is_migrate_isolate(migratetype)))
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
-	spin_unlock(&zone->lock);
+	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static bool free_pages_prepare(struct page *page, unsigned int order)
@@ -724,7 +728,6 @@ static bool free_pages_prepare(struct page *page, unsigned int order)
 
 static void __free_pages_ok(struct page *page, unsigned int order)
 {
-	unsigned long flags;
 	int migratetype;
 
 	if (!free_pages_prepare(page, order))
@@ -732,11 +735,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 
 	migratetype = get_pageblock_migratetype(page);
 
-	local_irq_save(flags);
-	__count_vm_events(PGFREE, 1 << order);
-	set_freepage_migratetype(page, migratetype);
 	free_one_page(page_zone(page), page, order, migratetype);
-	local_irq_restore(flags);
 }
 
 /*
@@ -1325,8 +1324,6 @@ void free_hot_cold_page(struct page *page, int cold)
 
 	migratetype = get_pageblock_migratetype(page);
 	set_freepage_migratetype(page, migratetype);
-	local_irq_save(flags);
-	__count_vm_event(PGFREE);
 
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
@@ -1338,11 +1335,14 @@ void free_hot_cold_page(struct page *page, int cold)
 	if (migratetype >= MIGRATE_PCPTYPES) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
 			free_one_page(zone, page, 0, migratetype);
-			goto out;
+			return;
 		}
 		migratetype = MIGRATE_MOVABLE;
 	}
 
+	local_irq_save(flags);
+	__count_vm_event(PGFREE);
+
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	if (cold)
 		list_add_tail(&page->lru, &pcp->lists[migratetype]);
@@ -1354,7 +1354,6 @@ void free_hot_cold_page(struct page *page, int cold)
 		pcp->count -= pcp->batch;
 	}
 
-out:
 	local_irq_restore(flags);
 }
 
-- 
1.8.1.4

