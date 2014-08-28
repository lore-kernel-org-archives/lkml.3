Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaH1ShQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaH1ShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:07 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 77/97] mm: page_alloc: reduce number of times page_to_pfn is called
Date: Thu, 28 Aug 2014 19:35:25 +0100
Message-Id: <1409250945-30874-78-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dc4b0caff24d9b2918e9f27bc65499ee63187eba upstream.

In the free path we calculate page_to_pfn multiple times. Reduce that.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mmzone.h          |  9 +++++++--
 include/linux/pageblock-flags.h | 33 +++++++++++++--------------------
 mm/page_alloc.c                 | 34 +++++++++++++++++++---------------
 3 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 49aa3e5..b45c3a7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -78,10 +78,15 @@ extern int page_group_by_mobility_disabled;
 #define NR_MIGRATETYPE_BITS (PB_migrate_end - PB_migrate + 1)
 #define MIGRATETYPE_MASK ((1UL << NR_MIGRATETYPE_BITS) - 1)
 
-static inline int get_pageblock_migratetype(struct page *page)
+#define get_pageblock_migratetype(page)					\
+	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
+			PB_migrate_end, MIGRATETYPE_MASK)
+
+static inline int get_pfnblock_migratetype(struct page *page, unsigned long pfn)
 {
 	BUILD_BUG_ON(PB_migrate_end - PB_migrate != 2);
-	return get_pageblock_flags_mask(page, PB_migrate_end, MIGRATETYPE_MASK);
+	return get_pfnblock_flags_mask(page, pfn, PB_migrate_end,
+					MIGRATETYPE_MASK);
 }
 
 struct free_area {
diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index c08730c..2baeee1 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -65,33 +65,26 @@ extern int pageblock_order;
 /* Forward declaration */
 struct page;
 
-unsigned long get_pageblock_flags_mask(struct page *page,
+unsigned long get_pfnblock_flags_mask(struct page *page,
+				unsigned long pfn,
 				unsigned long end_bitidx,
 				unsigned long mask);
-void set_pageblock_flags_mask(struct page *page,
+
+void set_pfnblock_flags_mask(struct page *page,
 				unsigned long flags,
+				unsigned long pfn,
 				unsigned long end_bitidx,
 				unsigned long mask);
 
 /* Declarations for getting and setting flags. See mm/page_alloc.c */
-static inline unsigned long get_pageblock_flags_group(struct page *page,
-					int start_bitidx, int end_bitidx)
-{
-	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
-	unsigned long mask = (1 << nr_flag_bits) - 1;
-
-	return get_pageblock_flags_mask(page, end_bitidx, mask);
-}
-
-static inline void set_pageblock_flags_group(struct page *page,
-					unsigned long flags,
-					int start_bitidx, int end_bitidx)
-{
-	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
-	unsigned long mask = (1 << nr_flag_bits) - 1;
-
-	set_pageblock_flags_mask(page, flags, end_bitidx, mask);
-}
+#define get_pageblock_flags_group(page, start_bitidx, end_bitidx) \
+	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
+			end_bitidx,					\
+			(1 << (end_bitidx - start_bitidx + 1)) - 1)
+#define set_pageblock_flags_group(page, flags, start_bitidx, end_bitidx) \
+	set_pfnblock_flags_mask(page, flags, page_to_pfn(page),		\
+			end_bitidx,					\
+			(1 << (end_bitidx - start_bitidx + 1)) - 1)
 
 #ifdef CONFIG_COMPACTION
 #define get_pageblock_skip(page) \
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 46b5a56..031ca22 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -557,6 +557,7 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
  */
 
 static inline void __free_one_page(struct page *page,
+		unsigned long pfn,
 		struct zone *zone, unsigned int order,
 		int migratetype)
 {
@@ -573,7 +574,7 @@ static inline void __free_one_page(struct page *page,
 
 	VM_BUG_ON(migratetype == -1);
 
-	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
+	page_idx = pfn & ((1 << MAX_ORDER) - 1);
 
 	VM_BUG_ON(page_idx & ((1 << order) - 1));
 	VM_BUG_ON(bad_range(zone, page));
@@ -697,7 +698,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			list_del(&page->lru);
 			mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
-			__free_one_page(page, zone, 0, mt);
+			__free_one_page(page, page_to_pfn(page), zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
 			if (likely(!is_migrate_isolate_page(page))) {
 				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
@@ -709,13 +710,15 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	spin_unlock(&zone->lock);
 }
 
-static void free_one_page(struct zone *zone, struct page *page, unsigned int order,
+static void free_one_page(struct zone *zone,
+				struct page *page, unsigned long pfn,
+				unsigned int order,
 				int migratetype)
 {
 	spin_lock(&zone->lock);
 	zone->pages_scanned = 0;
 
-	__free_one_page(page, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype);
 	if (unlikely(!is_migrate_isolate(migratetype)))
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 	spin_unlock(&zone->lock);
@@ -752,15 +755,16 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
 	int migratetype;
+	unsigned long pfn = page_to_pfn(page);
 
 	if (!free_pages_prepare(page, order))
 		return;
 
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	migratetype = get_pageblock_migratetype(page);
+	migratetype = get_pfnblock_migratetype(page, pfn);
 	set_freepage_migratetype(page, migratetype);
-	free_one_page(page_zone(page), page, order, migratetype);
+	free_one_page(page_zone(page), page, pfn, order, migratetype);
 	local_irq_restore(flags);
 }
 
@@ -1368,12 +1372,13 @@ void free_hot_cold_page(struct page *page, int cold)
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
+	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
 	if (!free_pages_prepare(page, 0))
 		return;
 
-	migratetype = get_pageblock_migratetype(page);
+	migratetype = get_pfnblock_migratetype(page, pfn);
 	set_freepage_migratetype(page, migratetype);
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
@@ -1387,7 +1392,7 @@ void free_hot_cold_page(struct page *page, int cold)
 	 */
 	if (migratetype >= MIGRATE_PCPTYPES) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(zone, page, 0, migratetype);
+			free_one_page(zone, page, pfn, 0, migratetype);
 			goto out;
 		}
 		migratetype = MIGRATE_MOVABLE;
@@ -6011,17 +6016,16 @@ static inline int pfn_to_bitidx(struct zone *zone, unsigned long pfn)
  * @end_bitidx: The last bit of interest
  * returns pageblock_bits flags
  */
-unsigned long get_pageblock_flags_mask(struct page *page,
+unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
 					unsigned long end_bitidx,
 					unsigned long mask)
 {
 	struct zone *zone;
 	unsigned long *bitmap;
-	unsigned long pfn, bitidx, word_bitidx;
+	unsigned long bitidx, word_bitidx;
 	unsigned long word;
 
 	zone = page_zone(page);
-	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
 	word_bitidx = bitidx / BITS_PER_LONG;
@@ -6033,25 +6037,25 @@ unsigned long get_pageblock_flags_mask(struct page *page,
 }
 
 /**
- * set_pageblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
+ * set_pfnblock_flags_mask - Set the requested group of flags for a pageblock_nr_pages block of pages
  * @page: The page within the block of interest
  * @start_bitidx: The first bit of interest
  * @end_bitidx: The last bit of interest
  * @flags: The flags to set
  */
-void set_pageblock_flags_mask(struct page *page, unsigned long flags,
+void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
+					unsigned long pfn,
 					unsigned long end_bitidx,
 					unsigned long mask)
 {
 	struct zone *zone;
 	unsigned long *bitmap;
-	unsigned long pfn, bitidx, word_bitidx;
+	unsigned long bitidx, word_bitidx;
 	unsigned long old_word, word;
 
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 
 	zone = page_zone(page);
-	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
 	word_bitidx = bitidx / BITS_PER_LONG;
-- 
1.8.4.5

