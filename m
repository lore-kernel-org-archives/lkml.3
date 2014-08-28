Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaH1ShM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaH1ShI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:08 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 78/97] mm: page_alloc: convert hot/cold parameter and immediate callers to bool
Date: Thu, 28 Aug 2014 19:35:26 +0100
Message-Id: <1409250945-30874-79-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b745bc85f21ea707e4ea1a91948055fa3e72c77b upstream.

cold is a bool, make it one.  Make the likely case the "if" part of the
block instead of the else as according to the optimisation manual this is
preferred.

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
 arch/tile/mm/homecache.c |  2 +-
 fs/fuse/dev.c            |  2 +-
 include/linux/gfp.h      |  4 ++--
 include/linux/pagemap.h  |  2 +-
 include/linux/swap.h     |  2 +-
 mm/page_alloc.c          | 20 ++++++++++----------
 mm/swap.c                |  4 ++--
 mm/swap_state.c          |  2 +-
 mm/vmscan.c              |  6 +++---
 9 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index 004ba56..33294fd 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -417,7 +417,7 @@ void __homecache_free_pages(struct page *page, unsigned int order)
 	if (put_page_testzero(page)) {
 		homecache_change_page_home(page, order, PAGE_HOME_HASH);
 		if (order == 0) {
-			free_hot_cold_page(page, 0);
+			free_hot_cold_page(page, false);
 		} else {
 			init_page_count(page);
 			__free_pages(page, order);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index fa8cb4b..fc8e499 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1613,7 +1613,7 @@ out_finish:
 
 static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	release_pages(req->pages, req->num_pages, 0);
+	release_pages(req->pages, req->num_pages, false);
 }
 
 static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 9b4dd49..fa7ac98 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -364,8 +364,8 @@ void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
-extern void free_hot_cold_page(struct page *page, int cold);
-extern void free_hot_cold_page_list(struct list_head *list, int cold);
+extern void free_hot_cold_page(struct page *page, bool cold);
+extern void free_hot_cold_page_list(struct list_head *list, bool cold);
 
 extern void __free_memcg_kmem_pages(struct page *page, unsigned int order);
 extern void free_memcg_kmem_pages(unsigned long addr, unsigned int order);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 930b884..57e3693 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -99,7 +99,7 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
 
 #define page_cache_get(page)		get_page(page)
 #define page_cache_release(page)	put_page(page)
-void release_pages(struct page **pages, int nr, int cold);
+void release_pages(struct page **pages, int nr, bool cold);
 
 /*
  * speculatively take a reference to a page.
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 13eb44c..c8beed1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -441,7 +441,7 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
 #define free_page_and_swap_cache(page) \
 	page_cache_release(page)
 #define free_pages_and_swap_cache(pages, nr) \
-	release_pages((pages), (nr), 0);
+	release_pages((pages), (nr), false);
 
 static inline void show_swap_cache_info(void)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 031ca22..b1b1522 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1185,7 +1185,7 @@ retry_reserve:
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
-			int migratetype, int cold)
+			int migratetype, bool cold)
 {
 	int i;
 
@@ -1204,7 +1204,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 * merge IO requests if the physical pages are ordered
 		 * properly.
 		 */
-		if (likely(cold == 0))
+		if (likely(!cold))
 			list_add(&page->lru, list);
 		else
 			list_add_tail(&page->lru, list);
@@ -1365,9 +1365,9 @@ void mark_free_pages(struct zone *zone)
 
 /*
  * Free a 0-order page
- * cold == 1 ? free a cold page : free a hot page
+ * cold == true ? free a cold page : free a hot page
  */
-void free_hot_cold_page(struct page *page, int cold)
+void free_hot_cold_page(struct page *page, bool cold)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -1399,10 +1399,10 @@ void free_hot_cold_page(struct page *page, int cold)
 	}
 
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
-	if (cold)
-		list_add_tail(&page->lru, &pcp->lists[migratetype]);
-	else
+	if (!cold)
 		list_add(&page->lru, &pcp->lists[migratetype]);
+	else
+		list_add_tail(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		unsigned long batch = ACCESS_ONCE(pcp->batch);
@@ -1417,7 +1417,7 @@ out:
 /*
  * Free a list of 0-order pages
  */
-void free_hot_cold_page_list(struct list_head *list, int cold)
+void free_hot_cold_page_list(struct list_head *list, bool cold)
 {
 	struct page *page, *next;
 
@@ -1534,7 +1534,7 @@ struct page *buffered_rmqueue(struct zone *preferred_zone,
 {
 	unsigned long flags;
 	struct page *page;
-	int cold = !!(gfp_flags & __GFP_COLD);
+	bool cold = ((gfp_flags & __GFP_COLD) != 0);
 
 again:
 	if (likely(order == 0)) {
@@ -2835,7 +2835,7 @@ void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page)) {
 		if (order == 0)
-			free_hot_cold_page(page, 0);
+			free_hot_cold_page(page, false);
 		else
 			__free_pages_ok(page, order);
 	}
diff --git a/mm/swap.c b/mm/swap.c
index 587dfe0..026113d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -68,7 +68,7 @@ static void __page_cache_release(struct page *page)
 static void __put_single_page(struct page *page)
 {
 	__page_cache_release(page);
-	free_hot_cold_page(page, 0);
+	free_hot_cold_page(page, false);
 }
 
 static void __put_compound_page(struct page *page)
@@ -794,7 +794,7 @@ void lru_add_drain_all(void)
  * grabbed the page via the LRU.  If it did, give up: shrink_inactive_list()
  * will free it.
  */
-void release_pages(struct page **pages, int nr, int cold)
+void release_pages(struct page **pages, int nr, bool cold)
 {
 	int i;
 	LIST_HEAD(pages_to_free);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index fdde6f9..4079edf 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -270,7 +270,7 @@ void free_pages_and_swap_cache(struct page **pages, int nr)
 
 		for (i = 0; i < todo; i++)
 			free_swap_cache(pagep[i]);
-		release_pages(pagep, todo, 0);
+		release_pages(pagep, todo, false);
 		pagep += todo;
 		nr -= todo;
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e568be9..360ef8e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1107,7 +1107,7 @@ keep:
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
 
-	free_hot_cold_page_list(&free_pages, 1);
+	free_hot_cold_page_list(&free_pages, true);
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
@@ -1505,7 +1505,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	free_hot_cold_page_list(&page_list, 1);
+	free_hot_cold_page_list(&page_list, true);
 
 	/*
 	 * If reclaim is isolating dirty pages under writeback, it implies
@@ -1725,7 +1725,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
-	free_hot_cold_page_list(&l_hold, 1);
+	free_hot_cold_page_list(&l_hold, true);
 }
 
 #ifdef CONFIG_SWAP
-- 
1.8.4.5

