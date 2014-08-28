Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaH1Sri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:47:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbaH1ShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:07 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 76/97] mm: page_alloc: use unsigned int for order in more places
Date: Thu, 28 Aug 2014 19:35:24 +0100
Message-Id: <1409250945-30874-77-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7aeb09f9104b760fc53c98cb7d20d06640baf9e6 upstream.

X86 prefers the use of unsigned types for iterators and there is a
tendency to mix whether a signed or unsigned type if used for page order.
This converts a number of sites in mm/page_alloc.c to use unsigned int for
order where possible.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
 include/linux/mmzone.h |  8 ++++----
 mm/page_alloc.c        | 43 +++++++++++++++++++++++--------------------
 2 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e4d1a88..49aa3e5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -810,10 +810,10 @@ static inline bool pgdat_is_empty(pg_data_t *pgdat)
 extern struct mutex zonelists_mutex;
 void build_all_zonelists(pg_data_t *pgdat, struct zone *zone);
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx);
-bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
-		int classzone_idx, int alloc_flags);
-bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
-		int classzone_idx, int alloc_flags);
+bool zone_watermark_ok(struct zone *z, unsigned int order,
+		unsigned long mark, int classzone_idx, int alloc_flags);
+bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
+		unsigned long mark, int classzone_idx, int alloc_flags);
 enum memmap_context {
 	MEMMAP_EARLY,
 	MEMMAP_HOTPLUG,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 332066b..46b5a56 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -405,7 +405,8 @@ static int destroy_compound_page(struct page *page, unsigned long order)
 	return bad;
 }
 
-static inline void prep_zero_page(struct page *page, int order, gfp_t gfp_flags)
+static inline void prep_zero_page(struct page *page, unsigned int order,
+							gfp_t gfp_flags)
 {
 	int i;
 
@@ -449,7 +450,7 @@ static inline void set_page_guard_flag(struct page *page) { }
 static inline void clear_page_guard_flag(struct page *page) { }
 #endif
 
-static inline void set_page_order(struct page *page, int order)
+static inline void set_page_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
 	__SetPageBuddy(page);
@@ -500,7 +501,7 @@ __find_buddy_index(unsigned long page_idx, unsigned int order)
  * For recording page's order, we use page_private(page).
  */
 static inline int page_is_buddy(struct page *page, struct page *buddy,
-								int order)
+							unsigned int order)
 {
 	if (!pfn_valid_within(page_to_pfn(buddy)))
 		return 0;
@@ -708,7 +709,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	spin_unlock(&zone->lock);
 }
 
-static void free_one_page(struct zone *zone, struct page *page, int order,
+static void free_one_page(struct zone *zone, struct page *page, unsigned int order,
 				int migratetype)
 {
 	spin_lock(&zone->lock);
@@ -879,7 +880,7 @@ static inline int check_new_page(struct page *page)
 	return 0;
 }
 
-static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
+static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
 	int i;
 
@@ -1090,16 +1091,17 @@ static int try_to_steal_freepages(struct zone *zone, struct page *page,
 
 /* Remove an element from the buddy allocator from the fallback list */
 static inline struct page *
-__rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
+__rmqueue_fallback(struct zone *zone, unsigned int order, int start_migratetype)
 {
 	struct free_area *area;
-	int current_order;
+	unsigned int current_order;
 	struct page *page;
 	int migratetype, new_type, i;
 
 	/* Find the largest possible block of pages in the other list */
-	for (current_order = MAX_ORDER-1; current_order >= order;
-						--current_order) {
+	for (current_order = MAX_ORDER-1;
+				current_order >= order && current_order <= MAX_ORDER-1;
+				--current_order) {
 		for (i = 0;; i++) {
 			migratetype = fallbacks[start_migratetype][i];
 
@@ -1327,7 +1329,7 @@ void mark_free_pages(struct zone *zone)
 {
 	unsigned long pfn, max_zone_pfn;
 	unsigned long flags;
-	int order, t;
+	unsigned int order, t;
 	struct list_head *curr;
 
 	if (zone_is_empty(zone))
@@ -1522,8 +1524,8 @@ int split_free_page(struct page *page)
  */
 static inline
 struct page *buffered_rmqueue(struct zone *preferred_zone,
-			struct zone *zone, int order, gfp_t gfp_flags,
-			int migratetype)
+			struct zone *zone, unsigned int order,
+			gfp_t gfp_flags, int migratetype)
 {
 	unsigned long flags;
 	struct page *page;
@@ -1672,8 +1674,9 @@ static inline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
  * Return true if free pages are above 'mark'. This takes into account the order
  * of the allocation.
  */
-static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
-		      int classzone_idx, int alloc_flags, long free_pages)
+static bool __zone_watermark_ok(struct zone *z, unsigned int order,
+			unsigned long mark, int classzone_idx, int alloc_flags,
+			long free_pages)
 {
 	/* free_pages my go negative - that's OK */
 	long min = mark;
@@ -1707,15 +1710,15 @@ static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 	return true;
 }
 
-bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
+bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 		      int classzone_idx, int alloc_flags)
 {
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
 					zone_page_state(z, NR_FREE_PAGES));
 }
 
-bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
-		      int classzone_idx, int alloc_flags)
+bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
+			unsigned long mark, int classzone_idx, int alloc_flags)
 {
 	long free_pages = zone_page_state(z, NR_FREE_PAGES);
 
@@ -4106,7 +4109,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 
 static void __meminit zone_init_free_lists(struct zone *zone)
 {
-	int order, t;
+	unsigned int order, t;
 	for_each_migratetype_order(order, t) {
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
 		zone->free_area[order].nr_free = 0;
@@ -6420,7 +6423,7 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct page *page;
 	struct zone *zone;
-	int order, i;
+	unsigned int order, i;
 	unsigned long pfn;
 	unsigned long flags;
 	/* find the first valid pfn */
@@ -6472,7 +6475,7 @@ bool is_free_buddy_page(struct page *page)
 	struct zone *zone = page_zone(page);
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long flags;
-	int order;
+	unsigned int order;
 
 	spin_lock_irqsave(&zone->lock, flags);
 	for (order = 0; order < MAX_ORDER; order++) {
-- 
1.8.4.5

