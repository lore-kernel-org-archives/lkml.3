Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab3EHQIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:08:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166Ab3EHQDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:03:18 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave@sr71.net>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 11/22] mm: page allocator: Shrink the magazine to the migratetypes in use
Date: Wed,  8 May 2013 17:02:56 +0100
Message-Id: <1368028987-8369-12-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368028987-8369-1-git-send-email-mgorman@suse.de>
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A full free_area is larger than required. Shrink it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mmzone.h |  9 +++++++--
 mm/page_alloc.c        | 23 +++++++++++++++++++----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a6f84f1..ca04853 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -85,6 +85,11 @@ struct free_area {
 	unsigned long		nr_free;
 };
 
+struct free_area_magazine {
+	struct list_head	free_list[MIGRATE_PCPTYPES];
+	unsigned long		nr_free;
+};
+
 struct pglist_data;
 
 /*
@@ -365,8 +370,8 @@ struct zone {
 	 * Keep some order-0 pages on a separate free list
 	 * protected by an irq-unsafe lock
 	 */
-	spinlock_t		magazine_lock;
-	struct free_area	noirq_magazine;
+	spinlock_t			magazine_lock;
+	struct free_area_magazine	noirq_magazine;
 
 #ifndef CONFIG_SPARSEMEM
 	/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9426174..79dfda7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1100,7 +1100,7 @@ static
 struct page *__rmqueue_magazine(struct zone *zone, int migratetype)
 {
 	struct page *page;
-	struct free_area *area = &(zone->noirq_magazine);
+	struct free_area_magazine *area = &(zone->noirq_magazine);
 
 	if (list_empty(&area->free_list[migratetype]))
 		return NULL;
@@ -1116,7 +1116,7 @@ struct page *__rmqueue_magazine(struct zone *zone, int migratetype)
 
 static void magazine_drain(struct zone *zone, int migratetype)
 {
-	struct free_area *area = &(zone->noirq_magazine);
+	struct free_area_magazine *area = &(zone->noirq_magazine);
 	struct list_head *list;
 	struct page *page;
 	unsigned int batch_free = 0;
@@ -1183,12 +1183,27 @@ void free_hot_cold_page(struct page *page, bool cold)
 {
 	struct zone *zone = page_zone(page);
 	int migratetype;
-	struct free_area *area;
+	struct free_area_magazine *area;
 
 	if (!free_pages_prepare(page, 0))
 		return;
 
 	migratetype = get_pageblock_migratetype(page);
+
+	/*
+	 * We only track unmovable, reclaimable and movable on magazines.
+	 * Free ISOLATE pages back to the allocator because they are being
+	 * offlined but treat RESERVE as movable pages so we can get those
+	 * areas back if necessary. Otherwise, we may have to free
+	 * excessively into the page allocator
+	 */
+	if (migratetype >= MIGRATE_PCPTYPES) {
+		if (unlikely(is_migrate_isolate(migratetype))) {
+			free_one_page(zone, page, 0, migratetype);
+			return;
+		}
+		migratetype = MIGRATE_MOVABLE;
+	}
 	set_freepage_migratetype(page, migratetype);
 
 	/* magazine_lock is not safe against IRQs */
@@ -1334,7 +1349,7 @@ struct page *rmqueue_magazine(struct zone *zone, int migratetype)
 	if (!page) {
 		LIST_HEAD(alloc_list);
 		unsigned long flags;
-		struct free_area *area = &(zone->noirq_magazine);
+		struct free_area_magazine *area = &(zone->noirq_magazine);
 		unsigned int i;
 		unsigned int nr_alloced = 0;
 
-- 
1.8.1.4

