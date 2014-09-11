Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaIKX6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:58:30 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52308 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaIKX5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:57:38 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: hch@infradead.org, bob.liu@oracle.com, felipe.franciosi@citrix.com,
        axboe@fb.com, avanzini.arianna@gmail.com
Subject: [PATCH RFC v2 4/5] xen, blkback: introduce support for multiple block rings
Date: Fri, 12 Sep 2014 01:57:23 +0200
Message-Id: <1410479844-2864-5-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
References: <1410479844-2864-1-git-send-email-avanzini.arianna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds to xen-blkback the support to map and make use
of a variable number of ringbuffers. The number of rings to be
mapped is forcedly set to one.

Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 drivers/block/xen-blkback/blkback.c | 377 ++++++++++++++++---------------
 drivers/block/xen-blkback/common.h  | 110 +++++----
 drivers/block/xen-blkback/xenbus.c  | 432 +++++++++++++++++++++++-------------
 3 files changed, 548 insertions(+), 371 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 64c60ed..b31acfb 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -80,6 +80,9 @@ module_param_named(max_persistent_grants, xen_blkif_max_pgrants, int, 0644);
 MODULE_PARM_DESC(max_persistent_grants,
                  "Maximum number of grants to map persistently");
 
+#define XEN_RING_MAX_PGRANTS(nr_rings) \
+	(max((int)(xen_blkif_max_pgrants / nr_rings), 16))
+
 /*
  * The LRU mechanism to clean the lists of persistent grants needs to
  * be executed periodically. The time interval between consecutive executions
@@ -103,71 +106,71 @@ module_param(log_stats, int, 0644);
 /* Number of free pages to remove on each call to free_xenballooned_pages */
 #define NUM_BATCH_FREE_PAGES 10
 
-static inline int get_free_page(struct xen_blkif *blkif, struct page **page)
+static inline int get_free_page(struct xen_blkif_ring *ring, struct page **page)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&blkif->free_pages_lock, flags);
-	if (list_empty(&blkif->free_pages)) {
-		BUG_ON(blkif->free_pages_num != 0);
-		spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
+	spin_lock_irqsave(&ring->free_pages_lock, flags);
+	if (list_empty(&ring->free_pages)) {
+		BUG_ON(ring->free_pages_num != 0);
+		spin_unlock_irqrestore(&ring->free_pages_lock, flags);
 		return alloc_xenballooned_pages(1, page, false);
 	}
-	BUG_ON(blkif->free_pages_num == 0);
-	page[0] = list_first_entry(&blkif->free_pages, struct page, lru);
+	BUG_ON(ring->free_pages_num == 0);
+	page[0] = list_first_entry(&ring->free_pages, struct page, lru);
 	list_del(&page[0]->lru);
-	blkif->free_pages_num--;
-	spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
+	ring->free_pages_num--;
+	spin_unlock_irqrestore(&ring->free_pages_lock, flags);
 
 	return 0;
 }
 
-static inline void put_free_pages(struct xen_blkif *blkif, struct page **page,
-                                  int num)
+static inline void put_free_pages(struct xen_blkif_ring *ring,
+				  struct page **page, int num)
 {
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&blkif->free_pages_lock, flags);
+	spin_lock_irqsave(&ring->free_pages_lock, flags);
 	for (i = 0; i < num; i++)
-		list_add(&page[i]->lru, &blkif->free_pages);
-	blkif->free_pages_num += num;
-	spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
+		list_add(&page[i]->lru, &ring->free_pages);
+	ring->free_pages_num += num;
+	spin_unlock_irqrestore(&ring->free_pages_lock, flags);
 }
 
-static inline void shrink_free_pagepool(struct xen_blkif *blkif, int num)
+static inline void shrink_free_pagepool(struct xen_blkif_ring *ring, int num)
 {
 	/* Remove requested pages in batches of NUM_BATCH_FREE_PAGES */
 	struct page *page[NUM_BATCH_FREE_PAGES];
 	unsigned int num_pages = 0;
 	unsigned long flags;
 
-	spin_lock_irqsave(&blkif->free_pages_lock, flags);
-	while (blkif->free_pages_num > num) {
-		BUG_ON(list_empty(&blkif->free_pages));
-		page[num_pages] = list_first_entry(&blkif->free_pages,
+	spin_lock_irqsave(&ring->free_pages_lock, flags);
+	while (ring->free_pages_num > num) {
+		BUG_ON(list_empty(&ring->free_pages));
+		page[num_pages] = list_first_entry(&ring->free_pages,
 		                                   struct page, lru);
 		list_del(&page[num_pages]->lru);
-		blkif->free_pages_num--;
+		ring->free_pages_num--;
 		if (++num_pages == NUM_BATCH_FREE_PAGES) {
-			spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
+			spin_unlock_irqrestore(&ring->free_pages_lock, flags);
 			free_xenballooned_pages(num_pages, page);
-			spin_lock_irqsave(&blkif->free_pages_lock, flags);
+			spin_lock_irqsave(&ring->free_pages_lock, flags);
 			num_pages = 0;
 		}
 	}
-	spin_unlock_irqrestore(&blkif->free_pages_lock, flags);
+	spin_unlock_irqrestore(&ring->free_pages_lock, flags);
 	if (num_pages != 0)
 		free_xenballooned_pages(num_pages, page);
 }
 
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
 
-static int do_block_io_op(struct xen_blkif *blkif);
-static int dispatch_rw_block_io(struct xen_blkif *blkif,
+static int do_block_io_op(struct xen_blkif_ring *ring);
+static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 				struct blkif_request *req,
 				struct pending_req *pending_req);
-static void make_response(struct xen_blkif *blkif, u64 id,
+static void make_response(struct xen_blkif_ring *ring, u64 id,
 			  unsigned short op, int st);
 
 #define foreach_grant_safe(pos, n, rbtree, node) \
@@ -188,19 +191,21 @@ static void make_response(struct xen_blkif *blkif, u64 id,
  * bit operations to modify the flags of a persistent grant and to count
  * the number of used grants.
  */
-static int add_persistent_gnt(struct xen_blkif *blkif,
+static int add_persistent_gnt(struct xen_blkif_ring *ring,
 			       struct persistent_gnt *persistent_gnt)
 {
+	struct xen_blkif *blkif = ring->blkif;
 	struct rb_node **new = NULL, *parent = NULL;
 	struct persistent_gnt *this;
 
-	if (blkif->persistent_gnt_c >= xen_blkif_max_pgrants) {
+	if (ring->persistent_gnt_c >=
+		XEN_RING_MAX_PGRANTS(ring->blkif->nr_rings)) {
 		if (!blkif->vbd.overflow_max_grants)
 			blkif->vbd.overflow_max_grants = 1;
 		return -EBUSY;
 	}
 	/* Figure out where to put new node */
-	new = &blkif->persistent_gnts.rb_node;
+	new = &ring->persistent_gnts.rb_node;
 	while (*new) {
 		this = container_of(*new, struct persistent_gnt, node);
 
@@ -219,19 +224,19 @@ static int add_persistent_gnt(struct xen_blkif *blkif,
 	set_bit(PERSISTENT_GNT_ACTIVE, persistent_gnt->flags);
 	/* Add new node and rebalance tree. */
 	rb_link_node(&(persistent_gnt->node), parent, new);
-	rb_insert_color(&(persistent_gnt->node), &blkif->persistent_gnts);
-	blkif->persistent_gnt_c++;
-	atomic_inc(&blkif->persistent_gnt_in_use);
+	rb_insert_color(&(persistent_gnt->node), &ring->persistent_gnts);
+	ring->persistent_gnt_c++;
+	atomic_inc(&ring->persistent_gnt_in_use);
 	return 0;
 }
 
-static struct persistent_gnt *get_persistent_gnt(struct xen_blkif *blkif,
+static struct persistent_gnt *get_persistent_gnt(struct xen_blkif_ring *ring,
 						 grant_ref_t gref)
 {
 	struct persistent_gnt *data;
 	struct rb_node *node = NULL;
 
-	node = blkif->persistent_gnts.rb_node;
+	node = ring->persistent_gnts.rb_node;
 	while (node) {
 		data = container_of(node, struct persistent_gnt, node);
 
@@ -245,25 +250,25 @@ static struct persistent_gnt *get_persistent_gnt(struct xen_blkif *blkif,
 				return NULL;
 			}
 			set_bit(PERSISTENT_GNT_ACTIVE, data->flags);
-			atomic_inc(&blkif->persistent_gnt_in_use);
+			atomic_inc(&ring->persistent_gnt_in_use);
 			return data;
 		}
 	}
 	return NULL;
 }
 
-static void put_persistent_gnt(struct xen_blkif *blkif,
+static void put_persistent_gnt(struct xen_blkif_ring *ring,
                                struct persistent_gnt *persistent_gnt)
 {
 	if(!test_bit(PERSISTENT_GNT_ACTIVE, persistent_gnt->flags))
 	          pr_alert_ratelimited(DRV_PFX " freeing a grant already unused");
 	set_bit(PERSISTENT_GNT_WAS_ACTIVE, persistent_gnt->flags);
 	clear_bit(PERSISTENT_GNT_ACTIVE, persistent_gnt->flags);
-	atomic_dec(&blkif->persistent_gnt_in_use);
+	atomic_dec(&ring->persistent_gnt_in_use);
 }
 
-static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
-                                 unsigned int num)
+static void free_persistent_gnts(struct xen_blkif_ring *ring,
+				 struct rb_root *root, unsigned int num)
 {
 	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
@@ -288,7 +293,7 @@ static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
 			ret = gnttab_unmap_refs(unmap, NULL, pages,
 				segs_to_unmap);
 			BUG_ON(ret);
-			put_free_pages(blkif, pages, segs_to_unmap);
+			put_free_pages(ring, pages, segs_to_unmap);
 			segs_to_unmap = 0;
 		}
 
@@ -305,10 +310,10 @@ void xen_blkbk_unmap_purged_grants(struct work_struct *work)
 	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct persistent_gnt *persistent_gnt;
 	int ret, segs_to_unmap = 0;
-	struct xen_blkif *blkif = container_of(work, typeof(*blkif), persistent_purge_work);
+	struct xen_blkif_ring *ring = container_of(work, typeof(*ring), persistent_purge_work);
 
-	while(!list_empty(&blkif->persistent_purge_list)) {
-		persistent_gnt = list_first_entry(&blkif->persistent_purge_list,
+	while(!list_empty(&ring->persistent_purge_list)) {
+		persistent_gnt = list_first_entry(&ring->persistent_purge_list,
 		                                  struct persistent_gnt,
 		                                  remove_node);
 		list_del(&persistent_gnt->remove_node);
@@ -324,7 +329,7 @@ void xen_blkbk_unmap_purged_grants(struct work_struct *work)
 			ret = gnttab_unmap_refs(unmap, NULL, pages,
 				segs_to_unmap);
 			BUG_ON(ret);
-			put_free_pages(blkif, pages, segs_to_unmap);
+			put_free_pages(ring, pages, segs_to_unmap);
 			segs_to_unmap = 0;
 		}
 		kfree(persistent_gnt);
@@ -332,34 +337,36 @@ void xen_blkbk_unmap_purged_grants(struct work_struct *work)
 	if (segs_to_unmap > 0) {
 		ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap);
 		BUG_ON(ret);
-		put_free_pages(blkif, pages, segs_to_unmap);
+		put_free_pages(ring, pages, segs_to_unmap);
 	}
 }
 
-static void purge_persistent_gnt(struct xen_blkif *blkif)
+static void purge_persistent_gnt(struct xen_blkif_ring *ring)
 {
+	struct xen_blkif *blkif = ring->blkif;
 	struct persistent_gnt *persistent_gnt;
 	struct rb_node *n;
 	unsigned int num_clean, total;
 	bool scan_used = false, clean_used = false;
 	struct rb_root *root;
+	unsigned nr_rings = ring->blkif->nr_rings;
 
-	if (blkif->persistent_gnt_c < xen_blkif_max_pgrants ||
-	    (blkif->persistent_gnt_c == xen_blkif_max_pgrants &&
+	if (ring->persistent_gnt_c < XEN_RING_MAX_PGRANTS(nr_rings) ||
+	    (ring->persistent_gnt_c == XEN_RING_MAX_PGRANTS(nr_rings) &&
 	    !blkif->vbd.overflow_max_grants)) {
 		return;
 	}
 
-	if (work_pending(&blkif->persistent_purge_work)) {
+	if (work_pending(&ring->persistent_purge_work)) {
 		pr_alert_ratelimited(DRV_PFX "Scheduled work from previous purge is still pending, cannot purge list\n");
 		return;
 	}
 
-	num_clean = (xen_blkif_max_pgrants / 100) * LRU_PERCENT_CLEAN;
-	num_clean = blkif->persistent_gnt_c - xen_blkif_max_pgrants + num_clean;
-	num_clean = min(blkif->persistent_gnt_c, num_clean);
+	num_clean = (XEN_RING_MAX_PGRANTS(nr_rings) / 100) * LRU_PERCENT_CLEAN;
+	num_clean = ring->persistent_gnt_c - XEN_RING_MAX_PGRANTS(nr_rings) + num_clean;
+	num_clean = min(ring->persistent_gnt_c, num_clean);
 	if ((num_clean == 0) ||
-	    (num_clean > (blkif->persistent_gnt_c - atomic_read(&blkif->persistent_gnt_in_use))))
+	    (num_clean > (ring->persistent_gnt_c - atomic_read(&ring->persistent_gnt_in_use))))
 		return;
 
 	/*
@@ -375,8 +382,8 @@ static void purge_persistent_gnt(struct xen_blkif *blkif)
 
 	pr_debug(DRV_PFX "Going to purge %u persistent grants\n", num_clean);
 
-	BUG_ON(!list_empty(&blkif->persistent_purge_list));
-	root = &blkif->persistent_gnts;
+	BUG_ON(!list_empty(&ring->persistent_purge_list));
+	root = &ring->persistent_gnts;
 purge_list:
 	foreach_grant_safe(persistent_gnt, n, root, node) {
 		BUG_ON(persistent_gnt->handle ==
@@ -395,7 +402,7 @@ purge_list:
 
 		rb_erase(&persistent_gnt->node, root);
 		list_add(&persistent_gnt->remove_node,
-		         &blkif->persistent_purge_list);
+		         &ring->persistent_purge_list);
 		if (--num_clean == 0)
 			goto finished;
 	}
@@ -416,11 +423,11 @@ finished:
 		goto purge_list;
 	}
 
-	blkif->persistent_gnt_c -= (total - num_clean);
+	ring->persistent_gnt_c -= (total - num_clean);
 	blkif->vbd.overflow_max_grants = 0;
 
 	/* We can defer this work */
-	schedule_work(&blkif->persistent_purge_work);
+	schedule_work(&ring->persistent_purge_work);
 	pr_debug(DRV_PFX "Purged %u/%u\n", (total - num_clean), total);
 	return;
 }
@@ -428,18 +435,18 @@ finished:
 /*
  * Retrieve from the 'pending_reqs' a free pending_req structure to be used.
  */
-static struct pending_req *alloc_req(struct xen_blkif *blkif)
+static struct pending_req *alloc_req(struct xen_blkif_ring *ring)
 {
 	struct pending_req *req = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&blkif->pending_free_lock, flags);
-	if (!list_empty(&blkif->pending_free)) {
-		req = list_entry(blkif->pending_free.next, struct pending_req,
+	spin_lock_irqsave(&ring->pending_free_lock, flags);
+	if (!list_empty(&ring->pending_free)) {
+		req = list_entry(ring->pending_free.next, struct pending_req,
 				 free_list);
 		list_del(&req->free_list);
 	}
-	spin_unlock_irqrestore(&blkif->pending_free_lock, flags);
+	spin_unlock_irqrestore(&ring->pending_free_lock, flags);
 	return req;
 }
 
@@ -447,17 +454,17 @@ static struct pending_req *alloc_req(struct xen_blkif *blkif)
  * Return the 'pending_req' structure back to the freepool. We also
  * wake up the thread if it was waiting for a free page.
  */
-static void free_req(struct xen_blkif *blkif, struct pending_req *req)
+static void free_req(struct xen_blkif_ring *ring, struct pending_req *req)
 {
 	unsigned long flags;
 	int was_empty;
 
-	spin_lock_irqsave(&blkif->pending_free_lock, flags);
-	was_empty = list_empty(&blkif->pending_free);
-	list_add(&req->free_list, &blkif->pending_free);
-	spin_unlock_irqrestore(&blkif->pending_free_lock, flags);
+	spin_lock_irqsave(&ring->pending_free_lock, flags);
+	was_empty = list_empty(&ring->pending_free);
+	list_add(&req->free_list, &ring->pending_free);
+	spin_unlock_irqrestore(&ring->pending_free_lock, flags);
 	if (was_empty)
-		wake_up(&blkif->pending_free_wq);
+		wake_up(&ring->pending_free_wq);
 }
 
 /*
@@ -537,10 +544,10 @@ abort:
 /*
  * Notification from the guest OS.
  */
-static void blkif_notify_work(struct xen_blkif *blkif)
+static void blkif_notify_work(struct xen_blkif_ring *ring)
 {
-	blkif->waiting_reqs = 1;
-	wake_up(&blkif->wq);
+	ring->waiting_reqs = 1;
+	wake_up(&ring->wq);
 }
 
 irqreturn_t xen_blkif_be_int(int irq, void *dev_id)
@@ -553,30 +560,33 @@ irqreturn_t xen_blkif_be_int(int irq, void *dev_id)
  * SCHEDULER FUNCTIONS
  */
 
-static void print_stats(struct xen_blkif *blkif)
+static void print_stats(struct xen_blkif_ring *ring)
 {
+	spin_lock_irq(&ring->stats_lock);
 	pr_info("xen-blkback (%s): oo %3llu  |  rd %4llu  |  wr %4llu  |  f %4llu"
 		 "  |  ds %4llu | pg: %4u/%4d\n",
-		 current->comm, blkif->st_oo_req,
-		 blkif->st_rd_req, blkif->st_wr_req,
-		 blkif->st_f_req, blkif->st_ds_req,
-		 blkif->persistent_gnt_c,
-		 xen_blkif_max_pgrants);
-	blkif->st_print = jiffies + msecs_to_jiffies(10 * 1000);
-	blkif->st_rd_req = 0;
-	blkif->st_wr_req = 0;
-	blkif->st_oo_req = 0;
-	blkif->st_ds_req = 0;
+		 current->comm, ring->st_oo_req,
+		 ring->st_rd_req, ring->st_wr_req,
+		 ring->st_f_req, ring->st_ds_req,
+		 ring->persistent_gnt_c,
+		 XEN_RING_MAX_PGRANTS(ring->blkif->nr_rings));
+	ring->st_print = jiffies + msecs_to_jiffies(10 * 1000);
+	ring->st_rd_req = 0;
+	ring->st_wr_req = 0;
+	ring->st_oo_req = 0;
+	ring->st_ds_req = 0;
+	spin_unlock_irq(&ring->stats_lock);
 }
 
 int xen_blkif_schedule(void *arg)
 {
-	struct xen_blkif *blkif = arg;
+	struct xen_blkif_ring *ring = arg;
+	struct xen_blkif *blkif = ring->blkif;
 	struct xen_vbd *vbd = &blkif->vbd;
 	unsigned long timeout;
 	int ret;
 
-	xen_blkif_get(blkif);
+	xen_ring_get(ring);
 
 	while (!kthread_should_stop()) {
 		if (try_to_freeze())
@@ -587,51 +597,51 @@ int xen_blkif_schedule(void *arg)
 		timeout = msecs_to_jiffies(LRU_INTERVAL);
 
 		timeout = wait_event_interruptible_timeout(
-			blkif->wq,
-			blkif->waiting_reqs || kthread_should_stop(),
+			ring->wq,
+			ring->waiting_reqs || kthread_should_stop(),
 			timeout);
 		if (timeout == 0)
 			goto purge_gnt_list;
 		timeout = wait_event_interruptible_timeout(
-			blkif->pending_free_wq,
-			!list_empty(&blkif->pending_free) ||
+			ring->pending_free_wq,
+			!list_empty(&ring->pending_free) ||
 			kthread_should_stop(),
 			timeout);
 		if (timeout == 0)
 			goto purge_gnt_list;
 
-		blkif->waiting_reqs = 0;
+		ring->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
 
-		ret = do_block_io_op(blkif);
+		ret = do_block_io_op(ring);
 		if (ret > 0)
-			blkif->waiting_reqs = 1;
+			ring->waiting_reqs = 1;
 		if (ret == -EACCES)
-			wait_event_interruptible(blkif->shutdown_wq,
+			wait_event_interruptible(ring->shutdown_wq,
 						 kthread_should_stop());
 
 purge_gnt_list:
 		if (blkif->vbd.feature_gnt_persistent &&
-		    time_after(jiffies, blkif->next_lru)) {
-			purge_persistent_gnt(blkif);
-			blkif->next_lru = jiffies + msecs_to_jiffies(LRU_INTERVAL);
+		    time_after(jiffies, ring->next_lru)) {
+			purge_persistent_gnt(ring);
+			ring->next_lru = jiffies + msecs_to_jiffies(LRU_INTERVAL);
 		}
 
 		/* Shrink if we have more than xen_blkif_max_buffer_pages */
-		shrink_free_pagepool(blkif, xen_blkif_max_buffer_pages);
+		shrink_free_pagepool(ring, xen_blkif_max_buffer_pages);
 
-		if (log_stats && time_after(jiffies, blkif->st_print))
-			print_stats(blkif);
+		if (log_stats && time_after(jiffies, ring->st_print))
+			print_stats(ring);
 	}
 
 	/* Drain pending purge work */
-	flush_work(&blkif->persistent_purge_work);
+	flush_work(&ring->persistent_purge_work);
 
 	if (log_stats)
-		print_stats(blkif);
+		print_stats(ring);
 
-	blkif->xenblkd = NULL;
-	xen_blkif_put(blkif);
+	ring->xenblkd = NULL;
+	xen_ring_put(ring);
 
 	return 0;
 }
@@ -639,25 +649,25 @@ purge_gnt_list:
 /*
  * Remove persistent grants and empty the pool of free pages
  */
-void xen_blkbk_free_caches(struct xen_blkif *blkif)
+void xen_blkbk_free_caches(struct xen_blkif_ring *ring)
 {
 	/* Free all persistent grant pages */
-	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
-		free_persistent_gnts(blkif, &blkif->persistent_gnts,
-			blkif->persistent_gnt_c);
+	if (!RB_EMPTY_ROOT(&ring->persistent_gnts))
+		free_persistent_gnts(ring, &ring->persistent_gnts,
+			ring->persistent_gnt_c);
 
-	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
-	blkif->persistent_gnt_c = 0;
+	BUG_ON(!RB_EMPTY_ROOT(&ring->persistent_gnts));
+	ring->persistent_gnt_c = 0;
 
 	/* Since we are shutting down remove all pages from the buffer */
-	shrink_free_pagepool(blkif, 0 /* All */);
+	shrink_free_pagepool(ring, 0 /* All */);
 }
 
 /*
  * Unmap the grant references, and also remove the M2P over-rides
  * used in the 'pending_req'.
  */
-static void xen_blkbk_unmap(struct xen_blkif *blkif,
+static void xen_blkbk_unmap(struct xen_blkif_ring *ring,
                             struct grant_page *pages[],
                             int num)
 {
@@ -668,7 +678,7 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
 
 	for (i = 0; i < num; i++) {
 		if (pages[i]->persistent_gnt != NULL) {
-			put_persistent_gnt(blkif, pages[i]->persistent_gnt);
+			put_persistent_gnt(ring, pages[i]->persistent_gnt);
 			continue;
 		}
 		if (pages[i]->handle == BLKBACK_INVALID_HANDLE)
@@ -681,21 +691,22 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
 			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages,
 			                        invcount);
 			BUG_ON(ret);
-			put_free_pages(blkif, unmap_pages, invcount);
+			put_free_pages(ring, unmap_pages, invcount);
 			invcount = 0;
 		}
 	}
 	if (invcount) {
 		ret = gnttab_unmap_refs(unmap, NULL, unmap_pages, invcount);
 		BUG_ON(ret);
-		put_free_pages(blkif, unmap_pages, invcount);
+		put_free_pages(ring, unmap_pages, invcount);
 	}
 }
 
-static int xen_blkbk_map(struct xen_blkif *blkif,
+static int xen_blkbk_map(struct xen_blkif_ring *ring,
 			 struct grant_page *pages[],
 			 int num, bool ro)
 {
+	struct xen_blkif *blkif = ring->blkif;
 	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct page *pages_to_gnt[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct persistent_gnt *persistent_gnt = NULL;
@@ -719,7 +730,7 @@ again:
 
 		if (use_persistent_gnts)
 			persistent_gnt = get_persistent_gnt(
-				blkif,
+				ring,
 				pages[i]->gref);
 
 		if (persistent_gnt) {
@@ -730,7 +741,7 @@ again:
 			pages[i]->page = persistent_gnt->page;
 			pages[i]->persistent_gnt = persistent_gnt;
 		} else {
-			if (get_free_page(blkif, &pages[i]->page))
+			if (get_free_page(ring, &pages[i]->page))
 				goto out_of_memory;
 			addr = vaddr(pages[i]->page);
 			pages_to_gnt[segs_to_map] = pages[i]->page;
@@ -772,7 +783,8 @@ again:
 			continue;
 		}
 		if (use_persistent_gnts &&
-		    blkif->persistent_gnt_c < xen_blkif_max_pgrants) {
+		    ring->persistent_gnt_c <
+			XEN_RING_MAX_PGRANTS(ring->blkif->nr_rings)) {
 			/*
 			 * We are using persistent grants, the grant is
 			 * not mapped but we might have room for it.
@@ -790,7 +802,7 @@ again:
 			persistent_gnt->gnt = map[new_map_idx].ref;
 			persistent_gnt->handle = map[new_map_idx].handle;
 			persistent_gnt->page = pages[seg_idx]->page;
-			if (add_persistent_gnt(blkif,
+			if (add_persistent_gnt(ring,
 			                       persistent_gnt)) {
 				kfree(persistent_gnt);
 				persistent_gnt = NULL;
@@ -798,8 +810,8 @@ again:
 			}
 			pages[seg_idx]->persistent_gnt = persistent_gnt;
 			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
-				 persistent_gnt->gnt, blkif->persistent_gnt_c,
-				 xen_blkif_max_pgrants);
+				 persistent_gnt->gnt, ring->persistent_gnt_c,
+				 XEN_RING_MAX_PGRANTS(ring->blkif->nr_rings));
 			goto next;
 		}
 		if (use_persistent_gnts && !blkif->vbd.overflow_max_grants) {
@@ -823,7 +835,7 @@ next:
 
 out_of_memory:
 	pr_alert(DRV_PFX "%s: out of memory\n", __func__);
-	put_free_pages(blkif, pages_to_gnt, segs_to_map);
+	put_free_pages(ring, pages_to_gnt, segs_to_map);
 	return -ENOMEM;
 }
 
@@ -831,7 +843,7 @@ static int xen_blkbk_map_seg(struct pending_req *pending_req)
 {
 	int rc;
 
-	rc = xen_blkbk_map(pending_req->blkif, pending_req->segments,
+	rc = xen_blkbk_map(pending_req->ring, pending_req->segments,
 			   pending_req->nr_pages,
 	                   (pending_req->operation != BLKIF_OP_READ));
 
@@ -844,7 +856,7 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
 				    struct phys_req *preq)
 {
 	struct grant_page **pages = pending_req->indirect_pages;
-	struct xen_blkif *blkif = pending_req->blkif;
+	struct xen_blkif_ring *ring = pending_req->ring;
 	int indirect_grefs, rc, n, nseg, i;
 	struct blkif_request_segment *segments = NULL;
 
@@ -855,7 +867,7 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
 	for (i = 0; i < indirect_grefs; i++)
 		pages[i]->gref = req->u.indirect.indirect_grefs[i];
 
-	rc = xen_blkbk_map(blkif, pages, indirect_grefs, true);
+	rc = xen_blkbk_map(ring, pages, indirect_grefs, true);
 	if (rc)
 		goto unmap;
 
@@ -882,20 +894,21 @@ static int xen_blkbk_parse_indirect(struct blkif_request *req,
 unmap:
 	if (segments)
 		kunmap_atomic(segments);
-	xen_blkbk_unmap(blkif, pages, indirect_grefs);
+	xen_blkbk_unmap(ring, pages, indirect_grefs);
 	return rc;
 }
 
-static int dispatch_discard_io(struct xen_blkif *blkif,
+static int dispatch_discard_io(struct xen_blkif_ring *ring,
 				struct blkif_request *req)
 {
 	int err = 0;
 	int status = BLKIF_RSP_OKAY;
+	struct xen_blkif *blkif = ring->blkif;
 	struct block_device *bdev = blkif->vbd.bdev;
 	unsigned long secure;
 	struct phys_req preq;
 
-	xen_blkif_get(blkif);
+	xen_ring_get(ring);
 
 	preq.sector_number = req->u.discard.sector_number;
 	preq.nr_sects      = req->u.discard.nr_sectors;
@@ -907,7 +920,9 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 			preq.sector_number + preq.nr_sects, blkif->vbd.pdevice);
 		goto fail_response;
 	}
-	blkif->st_ds_req++;
+	spin_lock_irq(&ring->stats_lock);
+	ring->st_ds_req++;
+	spin_unlock_irq(&ring->stats_lock);
 
 	secure = (blkif->vbd.discard_secure &&
 		 (req->u.discard.flag & BLKIF_DISCARD_SECURE)) ?
@@ -923,26 +938,27 @@ fail_response:
 	} else if (err)
 		status = BLKIF_RSP_ERROR;
 
-	make_response(blkif, req->u.discard.id, req->operation, status);
-	xen_blkif_put(blkif);
+	make_response(ring, req->u.discard.id, req->operation, status);
+	xen_ring_put(ring);
 	return err;
 }
 
-static int dispatch_other_io(struct xen_blkif *blkif,
+static int dispatch_other_io(struct xen_blkif_ring *ring,
 			     struct blkif_request *req,
 			     struct pending_req *pending_req)
 {
-	free_req(blkif, pending_req);
-	make_response(blkif, req->u.other.id, req->operation,
+	free_req(ring, pending_req);
+	make_response(ring, req->u.other.id, req->operation,
 		      BLKIF_RSP_EOPNOTSUPP);
 	return -EIO;
 }
 
-static void xen_blk_drain_io(struct xen_blkif *blkif)
+static void xen_blk_drain_io(struct xen_blkif_ring *ring)
 {
+	struct xen_blkif *blkif = ring->blkif;
 	atomic_set(&blkif->drain, 1);
 	do {
-		if (atomic_read(&blkif->inflight) == 0)
+		if (atomic_read(&ring->inflight) == 0)
 			break;
 		wait_for_completion_interruptible_timeout(
 				&blkif->drain_complete, HZ);
@@ -963,12 +979,12 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 	if ((pending_req->operation == BLKIF_OP_FLUSH_DISKCACHE) &&
 	    (error == -EOPNOTSUPP)) {
 		pr_debug(DRV_PFX "flush diskcache op failed, not supported\n");
-		xen_blkbk_flush_diskcache(XBT_NIL, pending_req->blkif->be, 0);
+		xen_blkbk_flush_diskcache(XBT_NIL, pending_req->ring->blkif->be, 0);
 		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
 	} else if ((pending_req->operation == BLKIF_OP_WRITE_BARRIER) &&
 		    (error == -EOPNOTSUPP)) {
 		pr_debug(DRV_PFX "write barrier op failed, not supported\n");
-		xen_blkbk_barrier(XBT_NIL, pending_req->blkif->be, 0);
+		xen_blkbk_barrier(XBT_NIL, pending_req->ring->blkif->be, 0);
 		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
 	} else if (error) {
 		pr_debug(DRV_PFX "Buffer not up-to-date at end of operation,"
@@ -982,14 +998,15 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 	 * the proper response on the ring.
 	 */
 	if (atomic_dec_and_test(&pending_req->pendcnt)) {
-		struct xen_blkif *blkif = pending_req->blkif;
+		struct xen_blkif_ring *ring = pending_req->ring;
+		struct xen_blkif *blkif = ring->blkif;
 
-		xen_blkbk_unmap(blkif,
+		xen_blkbk_unmap(ring,
 		                pending_req->segments,
 		                pending_req->nr_pages);
-		make_response(blkif, pending_req->id,
+		make_response(ring, pending_req->id,
 			      pending_req->operation, pending_req->status);
-		free_req(blkif, pending_req);
+		free_req(ring, pending_req);
 		/*
 		 * Make sure the request is freed before releasing blkif,
 		 * or there could be a race between free_req and the
@@ -1002,10 +1019,10 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 		 * pending_free_wq if there's a drain going on, but it has
 		 * to be taken into account if the current model is changed.
 		 */
-		if (atomic_dec_and_test(&blkif->inflight) && atomic_read(&blkif->drain)) {
+		if (atomic_dec_and_test(&ring->inflight) && atomic_read(&blkif->drain)) {
 			complete(&blkif->drain_complete);
 		}
-		xen_blkif_put(blkif);
+		xen_ring_put(ring);
 	}
 }
 
@@ -1026,9 +1043,10 @@ static void end_block_io_op(struct bio *bio, int error)
  * and transmute  it to the block API to hand it over to the proper block disk.
  */
 static int
-__do_block_io_op(struct xen_blkif *blkif)
+__do_block_io_op(struct xen_blkif_ring *ring)
 {
-	union blkif_back_rings *blk_rings = &blkif->blk_rings;
+	union blkif_back_rings *blk_rings = &ring->blk_rings;
+	struct xen_blkif *blkif = ring->blkif;
 	struct blkif_request req;
 	struct pending_req *pending_req;
 	RING_IDX rc, rp;
@@ -1054,9 +1072,11 @@ __do_block_io_op(struct xen_blkif *blkif)
 			break;
 		}
 
-		pending_req = alloc_req(blkif);
+		pending_req = alloc_req(ring);
 		if (NULL == pending_req) {
-			blkif->st_oo_req++;
+			spin_lock_irq(&ring->stats_lock);
+			ring->st_oo_req++;
+			spin_unlock_irq(&ring->stats_lock);
 			more_to_do = 1;
 			break;
 		}
@@ -1085,16 +1105,16 @@ __do_block_io_op(struct xen_blkif *blkif)
 		case BLKIF_OP_WRITE_BARRIER:
 		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_INDIRECT:
-			if (dispatch_rw_block_io(blkif, &req, pending_req))
+			if (dispatch_rw_block_io(ring, &req, pending_req))
 				goto done;
 			break;
 		case BLKIF_OP_DISCARD:
-			free_req(blkif, pending_req);
-			if (dispatch_discard_io(blkif, &req))
+			free_req(ring, pending_req);
+			if (dispatch_discard_io(ring, &req))
 				goto done;
 			break;
 		default:
-			if (dispatch_other_io(blkif, &req, pending_req))
+			if (dispatch_other_io(ring, &req, pending_req))
 				goto done;
 			break;
 		}
@@ -1107,13 +1127,13 @@ done:
 }
 
 static int
-do_block_io_op(struct xen_blkif *blkif)
+do_block_io_op(struct xen_blkif_ring *ring)
 {
-	union blkif_back_rings *blk_rings = &blkif->blk_rings;
+	union blkif_back_rings *blk_rings = &ring->blk_rings;
 	int more_to_do;
 
 	do {
-		more_to_do = __do_block_io_op(blkif);
+		more_to_do = __do_block_io_op(ring);
 		if (more_to_do)
 			break;
 
@@ -1126,7 +1146,7 @@ do_block_io_op(struct xen_blkif *blkif)
  * Transmutation of the 'struct blkif_request' to a proper 'struct bio'
  * and call the 'submit_bio' to pass it to the underlying storage.
  */
-static int dispatch_rw_block_io(struct xen_blkif *blkif,
+static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 				struct blkif_request *req,
 				struct pending_req *pending_req)
 {
@@ -1140,6 +1160,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	struct blk_plug plug;
 	bool drain = false;
 	struct grant_page **pages = pending_req->segments;
+	struct xen_blkif *blkif = ring->blkif;
 	unsigned short req_operation;
 
 	req_operation = req->operation == BLKIF_OP_INDIRECT ?
@@ -1152,26 +1173,29 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		goto fail_response;
 	}
 
+	spin_lock_irq(&ring->stats_lock);
 	switch (req_operation) {
 	case BLKIF_OP_READ:
-		blkif->st_rd_req++;
+		ring->st_rd_req++;
 		operation = READ;
 		break;
 	case BLKIF_OP_WRITE:
-		blkif->st_wr_req++;
+		ring->st_wr_req++;
 		operation = WRITE_ODIRECT;
 		break;
 	case BLKIF_OP_WRITE_BARRIER:
 		drain = true;
 	case BLKIF_OP_FLUSH_DISKCACHE:
-		blkif->st_f_req++;
+		ring->st_f_req++;
 		operation = WRITE_FLUSH;
 		break;
 	default:
 		operation = 0; /* make gcc happy */
+		spin_unlock_irq(&ring->stats_lock);
 		goto fail_response;
 		break;
 	}
+	spin_unlock_irq(&ring->stats_lock);
 
 	/* Check that the number of segments is sane. */
 	nseg = req->operation == BLKIF_OP_INDIRECT ?
@@ -1190,7 +1214,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 	preq.nr_sects      = 0;
 
-	pending_req->blkif     = blkif;
+	pending_req->ring      = ring;
 	pending_req->id        = req->u.rw.id;
 	pending_req->operation = req_operation;
 	pending_req->status    = BLKIF_RSP_OKAY;
@@ -1243,7 +1267,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * issue the WRITE_FLUSH.
 	 */
 	if (drain)
-		xen_blk_drain_io(pending_req->blkif);
+		xen_blk_drain_io(pending_req->ring);
 
 	/*
 	 * If we have failed at this point, we need to undo the M2P override,
@@ -1255,11 +1279,11 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		goto fail_flush;
 
 	/*
-	 * This corresponding xen_blkif_put is done in __end_block_io_op, or
+	 * This corresponding xen_ring_put is done in __end_block_io_op, or
 	 * below (in "!bio") if we are handling a BLKIF_OP_DISCARD.
 	 */
-	xen_blkif_get(blkif);
-	atomic_inc(&blkif->inflight);
+	xen_ring_get(ring);
+	atomic_inc(&ring->inflight);
 
 	for (i = 0; i < nseg; i++) {
 		while ((bio == NULL) ||
@@ -1306,20 +1330,22 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	/* Let the I/Os go.. */
 	blk_finish_plug(&plug);
 
+	spin_lock_irq(&ring->stats_lock);
 	if (operation == READ)
-		blkif->st_rd_sect += preq.nr_sects;
+		ring->st_rd_sect += preq.nr_sects;
 	else if (operation & WRITE)
-		blkif->st_wr_sect += preq.nr_sects;
+		ring->st_wr_sect += preq.nr_sects;
+	spin_unlock_irq(&ring->stats_lock);
 
 	return 0;
 
  fail_flush:
-	xen_blkbk_unmap(blkif, pending_req->segments,
+	xen_blkbk_unmap(ring, pending_req->segments,
 	                pending_req->nr_pages);
  fail_response:
 	/* Haven't submitted any bio's yet. */
-	make_response(blkif, req->u.rw.id, req_operation, BLKIF_RSP_ERROR);
-	free_req(blkif, pending_req);
+	make_response(ring, req->u.rw.id, req_operation, BLKIF_RSP_ERROR);
+	free_req(ring, pending_req);
 	msleep(1); /* back off a bit */
 	return -EIO;
 
@@ -1337,19 +1363,20 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 /*
  * Put a response on the ring on how the operation fared.
  */
-static void make_response(struct xen_blkif *blkif, u64 id,
+static void make_response(struct xen_blkif_ring *ring, u64 id,
 			  unsigned short op, int st)
 {
 	struct blkif_response  resp;
 	unsigned long     flags;
-	union blkif_back_rings *blk_rings = &blkif->blk_rings;
+	union blkif_back_rings *blk_rings = &ring->blk_rings;
+	struct xen_blkif *blkif = ring->blkif;
 	int notify;
 
 	resp.id        = id;
 	resp.operation = op;
 	resp.status    = st;
 
-	spin_lock_irqsave(&blkif->blk_ring_lock, flags);
+	spin_lock_irqsave(&ring->blk_ring_lock, flags);
 	/* Place on the response ring for the relevant domain. */
 	switch (blkif->blk_protocol) {
 	case BLKIF_PROTOCOL_NATIVE:
@@ -1369,9 +1396,9 @@ static void make_response(struct xen_blkif *blkif, u64 id,
 	}
 	blk_rings->common.rsp_prod_pvt++;
 	RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(&blk_rings->common, notify);
-	spin_unlock_irqrestore(&blkif->blk_ring_lock, flags);
+	spin_unlock_irqrestore(&ring->blk_ring_lock, flags);
 	if (notify)
-		notify_remote_via_irq(blkif->irq);
+		notify_remote_via_irq(ring->irq);
 }
 
 static int __init xen_blkif_init(void)
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index f65b807..6f074ce 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -226,6 +226,7 @@ struct xen_vbd {
 	struct block_device	*bdev;
 	/* Cached size parameter. */
 	sector_t		size;
+	unsigned int		nr_supported_hw_queues;
 	unsigned int		flush_support:1;
 	unsigned int		discard_secure:1;
 	unsigned int		feature_gnt_persistent:1;
@@ -246,6 +247,7 @@ struct backend_info;
 
 /* Number of requests that we can fit in a ring */
 #define XEN_BLKIF_REQS			32
+#define XEN_RING_REQS(nr_rings)	(max((int)(XEN_BLKIF_REQS / nr_rings), 8))
 
 struct persistent_gnt {
 	struct page *page;
@@ -256,32 +258,29 @@ struct persistent_gnt {
 	struct list_head remove_node;
 };
 
-struct xen_blkif {
-	/* Unique identifier for this interface. */
-	domid_t			domid;
-	unsigned int		handle;
+struct xen_blkif_ring {
+	union blkif_back_rings	blk_rings;
 	/* Physical parameters of the comms window. */
 	unsigned int		irq;
-	/* Comms information. */
-	enum blkif_protocol	blk_protocol;
-	union blkif_back_rings	blk_rings;
-	void			*blk_ring;
-	/* The VBD attached to this interface. */
-	struct xen_vbd		vbd;
-	/* Back pointer to the backend_info. */
-	struct backend_info	*be;
-	/* Private fields. */
-	spinlock_t		blk_ring_lock;
-	atomic_t		refcnt;
 
 	wait_queue_head_t	wq;
-	/* for barrier (drain) requests */
-	struct completion	drain_complete;
-	atomic_t		drain;
-	atomic_t		inflight;
 	/* One thread per one blkif. */
 	struct task_struct	*xenblkd;
 	unsigned int		waiting_reqs;
+	void			*blk_ring;
+	spinlock_t		blk_ring_lock;
+
+	struct work_struct	free_work;
+	/* Thread shutdown wait queue. */
+	wait_queue_head_t	shutdown_wq;
+
+	/* buffer of free pages to map grant refs */
+	spinlock_t		free_pages_lock;
+	int			free_pages_num;
+
+	/* used by the kworker that offload work from the persistent purge */
+	struct list_head	persistent_purge_list;
+	struct work_struct	persistent_purge_work;
 
 	/* tree to store persistent grants */
 	struct rb_root		persistent_gnts;
@@ -289,13 +288,6 @@ struct xen_blkif {
 	atomic_t		persistent_gnt_in_use;
 	unsigned long           next_lru;
 
-	/* used by the kworker that offload work from the persistent purge */
-	struct list_head	persistent_purge_list;
-	struct work_struct	persistent_purge_work;
-
-	/* buffer of free pages to map grant refs */
-	spinlock_t		free_pages_lock;
-	int			free_pages_num;
 	struct list_head	free_pages;
 
 	/* List of all 'pending_req' available */
@@ -303,20 +295,54 @@ struct xen_blkif {
 	/* And its spinlock. */
 	spinlock_t		pending_free_lock;
 	wait_queue_head_t	pending_free_wq;
+	atomic_t		inflight;
+
+	/* Private fields. */
+	atomic_t		refcnt;
+
+	struct xen_blkif	*blkif;
+	unsigned		ring_index;
 
+	spinlock_t		stats_lock;
 	/* statistics */
 	unsigned long		st_print;
-	unsigned long long			st_rd_req;
-	unsigned long long			st_wr_req;
-	unsigned long long			st_oo_req;
-	unsigned long long			st_f_req;
-	unsigned long long			st_ds_req;
-	unsigned long long			st_rd_sect;
-	unsigned long long			st_wr_sect;
+	unsigned long long	st_rd_req;
+	unsigned long long	st_wr_req;
+	unsigned long long	st_oo_req;
+	unsigned long long	st_f_req;
+	unsigned long long	st_ds_req;
+	unsigned long long	st_rd_sect;
+	unsigned long long	st_wr_sect;
+};
 
-	struct work_struct	free_work;
-	/* Thread shutdown wait queue. */
-	wait_queue_head_t	shutdown_wq;
+struct xen_blkif {
+	/* Unique identifier for this interface. */
+	domid_t			domid;
+	unsigned int		handle;
+	/* Comms information. */
+	enum blkif_protocol	blk_protocol;
+	/* The VBD attached to this interface. */
+	struct xen_vbd		vbd;
+	/* Rings for this device */
+	struct xen_blkif_ring	*rings;
+	unsigned int		nr_rings;
+	/* Back pointer to the backend_info. */
+	struct backend_info	*be;
+
+	/* for barrier (drain) requests */
+	struct completion	drain_complete;
+	atomic_t		drain;
+
+	atomic_t		refcnt;
+
+	/* statistics */
+	unsigned long long	st_rd_req;
+	unsigned long long	st_wr_req;
+	unsigned long long	st_oo_req;
+	unsigned long long	st_f_req;
+	unsigned long long	st_ds_req;
+	unsigned long long	st_rd_sect;
+	unsigned long long	st_wr_sect;
 };
 
 struct seg_buf {
@@ -338,7 +364,7 @@ struct grant_page {
  * response queued for it, with the saved 'id' passed back.
  */
 struct pending_req {
-	struct xen_blkif	*blkif;
+	struct xen_blkif_ring	*ring;
 	u64			id;
 	int			nr_pages;
 	atomic_t		pendcnt;
@@ -357,11 +383,11 @@ struct pending_req {
 			 (_v)->bdev->bd_part->nr_sects : \
 			  get_capacity((_v)->bdev->bd_disk))
 
-#define xen_blkif_get(_b) (atomic_inc(&(_b)->refcnt))
-#define xen_blkif_put(_b)				\
+#define xen_ring_get(_r) (atomic_inc(&(_r)->refcnt))
+#define xen_ring_put(_r)				\
 	do {						\
-		if (atomic_dec_and_test(&(_b)->refcnt))	\
-			schedule_work(&(_b)->free_work);\
+		if (atomic_dec_and_test(&(_r)->refcnt))	\
+			schedule_work(&(_r)->free_work);\
 	} while (0)
 
 struct phys_req {
@@ -377,7 +403,7 @@ int xen_blkif_xenbus_init(void);
 irqreturn_t xen_blkif_be_int(int irq, void *dev_id);
 int xen_blkif_schedule(void *arg);
 int xen_blkif_purge_persistent(void *arg);
-void xen_blkbk_free_caches(struct xen_blkif *blkif);
+void xen_blkbk_free_caches(struct xen_blkif_ring *ring);
 
 int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 			      struct backend_info *be, int state);
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 3a8b810..a4f13cc 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -35,7 +35,7 @@ static void connect(struct backend_info *);
 static int connect_ring(struct backend_info *);
 static void backend_changed(struct xenbus_watch *, const char **,
 			    unsigned int);
-static void xen_blkif_free(struct xen_blkif *blkif);
+static void xen_ring_free(struct xen_blkif_ring *ring);
 static void xen_vbd_free(struct xen_vbd *vbd);
 
 struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be)
@@ -45,17 +45,17 @@ struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be)
 
 /*
  * The last request could free the device from softirq context and
- * xen_blkif_free() can sleep.
+ * xen_ring_free() can sleep.
  */
-static void xen_blkif_deferred_free(struct work_struct *work)
+static void xen_ring_deferred_free(struct work_struct *work)
 {
-	struct xen_blkif *blkif;
+	struct xen_blkif_ring *ring;
 
-	blkif = container_of(work, struct xen_blkif, free_work);
-	xen_blkif_free(blkif);
+	ring = container_of(work, struct xen_blkif_ring, free_work);
+	xen_ring_free(ring);
 }
 
-static int blkback_name(struct xen_blkif *blkif, char *buf)
+static int blkback_name(struct xen_blkif *blkif, char *buf, bool save_space)
 {
 	char *devpath, *devname;
 	struct xenbus_device *dev = blkif->be->dev;
@@ -70,7 +70,10 @@ static int blkback_name(struct xen_blkif *blkif, char *buf)
 	else
 		devname  = devpath;
 
-	snprintf(buf, TASK_COMM_LEN, "blkback.%d.%s", blkif->domid, devname);
+	if (save_space)
+		snprintf(buf, TASK_COMM_LEN, "blkbk.%d.%s", blkif->domid, devname);
+	else
+		snprintf(buf, TASK_COMM_LEN, "blkback.%d.%s", blkif->domid, devname);
 	kfree(devpath);
 
 	return 0;
@@ -78,11 +81,15 @@ static int blkback_name(struct xen_blkif *blkif, char *buf)
 
 static void xen_update_blkif_status(struct xen_blkif *blkif)
 {
-	int err;
-	char name[TASK_COMM_LEN];
+	int i, err;
+	char name[TASK_COMM_LEN], per_ring_name[TASK_COMM_LEN];
+	struct xen_blkif_ring *ring;
 
-	/* Not ready to connect? */
-	if (!blkif->irq || !blkif->vbd.bdev)
+	/*
+	 * Not ready to connect? Check irq of first ring as the others
+	 * should all be the same.
+	 */
+	if (!blkif->rings || !blkif->rings[0].irq || !blkif->vbd.bdev)
 		return;
 
 	/* Already connected? */
@@ -94,7 +101,7 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
 	if (blkif->be->dev->state != XenbusStateConnected)
 		return;
 
-	err = blkback_name(blkif, name);
+	err = blkback_name(blkif, name, blkif->vbd.nr_supported_hw_queues);
 	if (err) {
 		xenbus_dev_error(blkif->be->dev, err, "get blkback dev name");
 		return;
@@ -107,20 +114,96 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
 	}
 	invalidate_inode_pages2(blkif->vbd.bdev->bd_inode->i_mapping);
 
-	blkif->xenblkd = kthread_run(xen_blkif_schedule, blkif, "%s", name);
-	if (IS_ERR(blkif->xenblkd)) {
-		err = PTR_ERR(blkif->xenblkd);
-		blkif->xenblkd = NULL;
-		xenbus_dev_error(blkif->be->dev, err, "start xenblkd");
-		return;
+	for (i = 0 ; i < blkif->nr_rings ; i++) {
+		ring = &blkif->rings[i];
+		if (blkif->vbd.nr_supported_hw_queues)
+			snprintf(per_ring_name, TASK_COMM_LEN, "%s-%d", name, i);
+		else {
+			BUG_ON(i != 0);
+			snprintf(per_ring_name, TASK_COMM_LEN, "%s", name);
+		}
+		ring->xenblkd = kthread_run(xen_blkif_schedule, ring, "%s", per_ring_name);
+		if (IS_ERR(ring->xenblkd)) {
+			err = PTR_ERR(ring->xenblkd);
+			ring->xenblkd = NULL;
+			xenbus_dev_error(blkif->be->dev, err, "start %s", per_ring_name);
+			return;
+		}
 	}
 }
 
+static struct xen_blkif_ring *xen_blkif_ring_alloc(struct xen_blkif *blkif,
+						   int nr_rings)
+{
+	int r, i, j;
+	struct xen_blkif_ring *rings;
+	struct pending_req *req;
+
+	rings = kzalloc(nr_rings * sizeof(struct xen_blkif_ring),
+			GFP_KERNEL);
+	if (!rings)
+		return NULL;
+
+	for (r = 0 ; r < nr_rings ; r++) {
+		struct xen_blkif_ring *ring = &rings[r];
+
+		spin_lock_init(&ring->blk_ring_lock);
+
+		init_waitqueue_head(&ring->wq);
+		init_waitqueue_head(&ring->shutdown_wq);
+
+		ring->persistent_gnts.rb_node = NULL;
+		spin_lock_init(&ring->free_pages_lock);
+		INIT_LIST_HEAD(&ring->free_pages);
+		INIT_LIST_HEAD(&ring->persistent_purge_list);
+		ring->free_pages_num = 0;
+		atomic_set(&ring->persistent_gnt_in_use, 0);
+		atomic_set(&ring->refcnt, 1);
+		atomic_set(&ring->inflight, 0);
+		INIT_WORK(&ring->persistent_purge_work, xen_blkbk_unmap_purged_grants);
+		spin_lock_init(&ring->pending_free_lock);
+		init_waitqueue_head(&ring->pending_free_wq);
+		INIT_LIST_HEAD(&ring->pending_free);
+		for (i = 0; i < XEN_RING_REQS(nr_rings); i++) {
+			req = kzalloc(sizeof(*req), GFP_KERNEL);
+			if (!req)
+				goto fail;
+			list_add_tail(&req->free_list,
+				      &ring->pending_free);
+			for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
+				req->segments[j] = kzalloc(sizeof(*req->segments[0]),
+				                           GFP_KERNEL);
+				if (!req->segments[j])
+					goto fail;
+			}
+			for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
+				req->indirect_pages[j] = kzalloc(sizeof(*req->indirect_pages[0]),
+				                                 GFP_KERNEL);
+				if (!req->indirect_pages[j])
+					goto fail;
+			}
+		}
+
+		INIT_WORK(&ring->free_work, xen_ring_deferred_free);
+		ring->blkif = blkif;
+		ring->ring_index = r;
+
+		spin_lock_init(&ring->stats_lock);
+		ring->st_print = jiffies;
+
+		atomic_inc(&blkif->refcnt);
+	}
+
+	return rings;
+
+fail:
+	kfree(rings);
+	return NULL;
+}
+
 static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 {
 	struct xen_blkif *blkif;
-	struct pending_req *req, *n;
-	int i, j;
 
 	BUILD_BUG_ON(MAX_INDIRECT_PAGES > BLKIF_MAX_INDIRECT_PAGES_PER_REQUEST);
 
@@ -129,80 +212,26 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 		return ERR_PTR(-ENOMEM);
 
 	blkif->domid = domid;
-	spin_lock_init(&blkif->blk_ring_lock);
-	atomic_set(&blkif->refcnt, 1);
-	init_waitqueue_head(&blkif->wq);
 	init_completion(&blkif->drain_complete);
 	atomic_set(&blkif->drain, 0);
-	blkif->st_print = jiffies;
-	blkif->persistent_gnts.rb_node = NULL;
-	spin_lock_init(&blkif->free_pages_lock);
-	INIT_LIST_HEAD(&blkif->free_pages);
-	INIT_LIST_HEAD(&blkif->persistent_purge_list);
-	blkif->free_pages_num = 0;
-	atomic_set(&blkif->persistent_gnt_in_use, 0);
-	atomic_set(&blkif->inflight, 0);
-	INIT_WORK(&blkif->persistent_purge_work, xen_blkbk_unmap_purged_grants);
-
-	INIT_LIST_HEAD(&blkif->pending_free);
-	INIT_WORK(&blkif->free_work, xen_blkif_deferred_free);
-
-	for (i = 0; i < XEN_BLKIF_REQS; i++) {
-		req = kzalloc(sizeof(*req), GFP_KERNEL);
-		if (!req)
-			goto fail;
-		list_add_tail(&req->free_list,
-		              &blkif->pending_free);
-		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
-			req->segments[j] = kzalloc(sizeof(*req->segments[0]),
-			                           GFP_KERNEL);
-			if (!req->segments[j])
-				goto fail;
-		}
-		for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
-			req->indirect_pages[j] = kzalloc(sizeof(*req->indirect_pages[0]),
-			                                 GFP_KERNEL);
-			if (!req->indirect_pages[j])
-				goto fail;
-		}
-	}
-	spin_lock_init(&blkif->pending_free_lock);
-	init_waitqueue_head(&blkif->pending_free_wq);
-	init_waitqueue_head(&blkif->shutdown_wq);
 
 	return blkif;
-
-fail:
-	list_for_each_entry_safe(req, n, &blkif->pending_free, free_list) {
-		list_del(&req->free_list);
-		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
-			if (!req->segments[j])
-				break;
-			kfree(req->segments[j]);
-		}
-		for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
-			if (!req->indirect_pages[j])
-				break;
-			kfree(req->indirect_pages[j]);
-		}
-		kfree(req);
-	}
-
-	kmem_cache_free(xen_blkif_cachep, blkif);
-
-	return ERR_PTR(-ENOMEM);
 }
 
-static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
-			 unsigned int evtchn)
+static int xen_blkif_map(struct xen_blkif_ring *ring, unsigned long shared_page,
+			 unsigned int evtchn, unsigned int ring_idx)
 {
 	int err;
+	struct xen_blkif *blkif;
+	char dev_name[64];
 
 	/* Already connected through? */
-	if (blkif->irq)
+	if (ring->irq)
 		return 0;
 
-	err = xenbus_map_ring_valloc(blkif->be->dev, shared_page, &blkif->blk_ring);
+	blkif = ring->blkif;
+
+	err = xenbus_map_ring_valloc(ring->blkif->be->dev, shared_page, &ring->blk_ring);
 	if (err < 0)
 		return err;
 
@@ -210,64 +239,73 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
 	case BLKIF_PROTOCOL_NATIVE:
 	{
 		struct blkif_sring *sring;
-		sring = (struct blkif_sring *)blkif->blk_ring;
-		BACK_RING_INIT(&blkif->blk_rings.native, sring, PAGE_SIZE);
+		sring = (struct blkif_sring *)ring->blk_ring;
+		BACK_RING_INIT(&ring->blk_rings.native, sring, PAGE_SIZE);
 		break;
 	}
 	case BLKIF_PROTOCOL_X86_32:
 	{
 		struct blkif_x86_32_sring *sring_x86_32;
-		sring_x86_32 = (struct blkif_x86_32_sring *)blkif->blk_ring;
-		BACK_RING_INIT(&blkif->blk_rings.x86_32, sring_x86_32, PAGE_SIZE);
+		sring_x86_32 = (struct blkif_x86_32_sring *)ring->blk_ring;
+		BACK_RING_INIT(&ring->blk_rings.x86_32, sring_x86_32, PAGE_SIZE);
 		break;
 	}
 	case BLKIF_PROTOCOL_X86_64:
 	{
 		struct blkif_x86_64_sring *sring_x86_64;
-		sring_x86_64 = (struct blkif_x86_64_sring *)blkif->blk_ring;
-		BACK_RING_INIT(&blkif->blk_rings.x86_64, sring_x86_64, PAGE_SIZE);
+		sring_x86_64 = (struct blkif_x86_64_sring *)ring->blk_ring;
+		BACK_RING_INIT(&ring->blk_rings.x86_64, sring_x86_64, PAGE_SIZE);
 		break;
 	}
 	default:
 		BUG();
 	}
 
+	if (blkif->vbd.nr_supported_hw_queues)
+		snprintf(dev_name, 64, "blkif-backend-%d", ring_idx);
+	else
+		snprintf(dev_name, 64, "blkif-backend");
 	err = bind_interdomain_evtchn_to_irqhandler(blkif->domid, evtchn,
 						    xen_blkif_be_int, 0,
-						    "blkif-backend", blkif);
+						    dev_name, ring);
 	if (err < 0) {
-		xenbus_unmap_ring_vfree(blkif->be->dev, blkif->blk_ring);
-		blkif->blk_rings.common.sring = NULL;
+		xenbus_unmap_ring_vfree(blkif->be->dev, ring->blk_ring);
+		ring->blk_rings.common.sring = NULL;
 		return err;
 	}
-	blkif->irq = err;
+	ring->irq = err;
 
 	return 0;
 }
 
 static int xen_blkif_disconnect(struct xen_blkif *blkif)
 {
-	if (blkif->xenblkd) {
-		kthread_stop(blkif->xenblkd);
-		wake_up(&blkif->shutdown_wq);
-		blkif->xenblkd = NULL;
-	}
+	int i;
+
+	for (i = 0 ; i < blkif->nr_rings ; i++) {
+		struct xen_blkif_ring *ring = &blkif->rings[i];
+		if (ring->xenblkd) {
+			kthread_stop(ring->xenblkd);
+			wake_up(&ring->shutdown_wq);
+			ring->xenblkd = NULL;
+		}
 
-	/* The above kthread_stop() guarantees that at this point we
-	 * don't have any discard_io or other_io requests. So, checking
-	 * for inflight IO is enough.
-	 */
-	if (atomic_read(&blkif->inflight) > 0)
-		return -EBUSY;
+		/* The above kthread_stop() guarantees that at this point we
+		 * don't have any discard_io or other_io requests. So, checking
+		 * for inflight IO is enough.
+		 */
+		if (atomic_read(&ring->inflight) > 0)
+			return -EBUSY;
 
-	if (blkif->irq) {
-		unbind_from_irqhandler(blkif->irq, blkif);
-		blkif->irq = 0;
-	}
+		if (ring->irq) {
+			unbind_from_irqhandler(ring->irq, ring);
+			ring->irq = 0;
+		}
 
-	if (blkif->blk_rings.common.sring) {
-		xenbus_unmap_ring_vfree(blkif->be->dev, blkif->blk_ring);
-		blkif->blk_rings.common.sring = NULL;
+		if (ring->blk_rings.common.sring) {
+			xenbus_unmap_ring_vfree(blkif->be->dev, ring->blk_ring);
+			ring->blk_rings.common.sring = NULL;
+		}
 	}
 
 	return 0;
@@ -275,40 +313,52 @@ static int xen_blkif_disconnect(struct xen_blkif *blkif)
 
 static void xen_blkif_free(struct xen_blkif *blkif)
 {
-	struct pending_req *req, *n;
-	int i = 0, j;
 
 	xen_blkif_disconnect(blkif);
 	xen_vbd_free(&blkif->vbd);
 
+	kfree(blkif->rings);
+
+	kmem_cache_free(xen_blkif_cachep, blkif);
+}
+
+static void xen_ring_free(struct xen_blkif_ring *ring)
+{
+	struct pending_req *req, *n;
+	int i, j;
+
 	/* Remove all persistent grants and the cache of ballooned pages. */
-	xen_blkbk_free_caches(blkif);
+	xen_blkbk_free_caches(ring);
 
 	/* Make sure everything is drained before shutting down */
-	BUG_ON(blkif->persistent_gnt_c != 0);
-	BUG_ON(atomic_read(&blkif->persistent_gnt_in_use) != 0);
-	BUG_ON(blkif->free_pages_num != 0);
-	BUG_ON(!list_empty(&blkif->persistent_purge_list));
-	BUG_ON(!list_empty(&blkif->free_pages));
-	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
-
+	BUG_ON(ring->persistent_gnt_c != 0);
+	BUG_ON(atomic_read(&ring->persistent_gnt_in_use) != 0);
+	BUG_ON(ring->free_pages_num != 0);
+	BUG_ON(!list_empty(&ring->persistent_purge_list));
+	BUG_ON(!list_empty(&ring->free_pages));
+	BUG_ON(!RB_EMPTY_ROOT(&ring->persistent_gnts));
+
+	i = 0;
 	/* Check that there is no request in use */
-	list_for_each_entry_safe(req, n, &blkif->pending_free, free_list) {
+	list_for_each_entry_safe(req, n, &ring->pending_free, free_list) {
 		list_del(&req->free_list);
-
-		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++)
+		for (j = 0; j < MAX_INDIRECT_SEGMENTS; j++) {
+			if (!req->segments[j])
+				break;
 			kfree(req->segments[j]);
-
-		for (j = 0; j < MAX_INDIRECT_PAGES; j++)
+		}
+		for (j = 0; j < MAX_INDIRECT_PAGES; j++) {
+			if (!req->segments[j])
+				break;
 			kfree(req->indirect_pages[j]);
-
+		}
 		kfree(req);
 		i++;
 	}
+	WARN_ON(i != XEN_RING_REQS(ring->blkif->nr_rings));
 
-	WARN_ON(i != XEN_BLKIF_REQS);
-
-	kmem_cache_free(xen_blkif_cachep, blkif);
+	if (atomic_dec_and_test(&ring->blkif->refcnt))
+		xen_blkif_free(ring->blkif);
 }
 
 int __init xen_blkif_interface_init(void)
@@ -333,6 +383,29 @@ int __init xen_blkif_interface_init(void)
 	{								\
 		struct xenbus_device *dev = to_xenbus_device(_dev);	\
 		struct backend_info *be = dev_get_drvdata(&dev->dev);	\
+		struct xen_blkif *blkif = be->blkif;			\
+		struct xen_blkif_ring *ring;				\
+		int i;							\
+									\
+		blkif->st_oo_req = 0;					\
+		blkif->st_rd_req = 0;					\
+		blkif->st_wr_req = 0;					\
+		blkif->st_f_req = 0;					\
+		blkif->st_ds_req = 0;					\
+		blkif->st_rd_sect = 0;					\
+		blkif->st_wr_sect = 0;					\
+		for (i = 0 ; i < blkif->nr_rings ; i++) {		\
+			ring = &blkif->rings[i];			\
+			spin_lock_irq(&ring->stats_lock);		\
+			blkif->st_oo_req += ring->st_oo_req;		\
+			blkif->st_rd_req += ring->st_rd_req;		\
+			blkif->st_wr_req += ring->st_wr_req;		\
+			blkif->st_f_req += ring->st_f_req;		\
+			blkif->st_ds_req += ring->st_ds_req;		\
+			blkif->st_rd_sect += ring->st_rd_sect;		\
+			blkif->st_wr_sect += ring->st_wr_sect;		\
+			spin_unlock_irq(&ring->stats_lock);		\
+		}							\
 									\
 		return sprintf(buf, format, ##args);			\
 	}								\
@@ -453,6 +526,7 @@ static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
 		handle, blkif->domid);
 	return 0;
 }
+
 static int xen_blkbk_remove(struct xenbus_device *dev)
 {
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
@@ -468,13 +542,14 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
 		be->backend_watch.node = NULL;
 	}
 
-	dev_set_drvdata(&dev->dev, NULL);
-
 	if (be->blkif) {
+		int i = 0;
 		xen_blkif_disconnect(be->blkif);
-		xen_blkif_put(be->blkif);
+		for (; i < be->blkif->nr_rings ; i++)
+			xen_ring_put(&be->blkif->rings[i]);
 	}
 
+	dev_set_drvdata(&dev->dev, NULL);
 	kfree(be->mode);
 	kfree(be);
 	return 0;
@@ -851,21 +926,46 @@ again:
 static int connect_ring(struct backend_info *be)
 {
 	struct xenbus_device *dev = be->dev;
-	unsigned long ring_ref;
-	unsigned int evtchn;
+	struct xen_blkif *blkif = be->blkif;
+	unsigned long *ring_ref;
+	unsigned int *evtchn;
 	unsigned int pers_grants;
-	char protocol[64] = "";
-	int err;
+	char protocol[64] = "", ring_ref_s[64] = "", evtchn_s[64] = "";
+	int i, err;
 
 	DPRINTK("%s", dev->otherend);
 
-	err = xenbus_gather(XBT_NIL, dev->otherend, "ring-ref", "%lu",
-			    &ring_ref, "event-channel", "%u", &evtchn, NULL);
-	if (err) {
-		xenbus_dev_fatal(dev, err,
-				 "reading %s/ring-ref and event-channel",
-				 dev->otherend);
-		return err;
+	blkif->nr_rings = 1;
+
+	ring_ref = kzalloc(sizeof(unsigned long) * blkif->nr_rings, GFP_KERNEL);
+	if (!ring_ref)
+		return -ENOMEM;
+	evtchn = kzalloc(sizeof(unsigned int) * blkif->nr_rings,
+			 GFP_KERNEL);
+	if (!evtchn) {
+		kfree(ring_ref);
+		return -ENOMEM;
+	}
+
+	for (i = 0 ; i < blkif->nr_rings ; i++) {
+		if (blkif->vbd.nr_supported_hw_queues == 0) {
+			BUG_ON(i != 0);
+			/* Support old XenStore keys for compatibility */
+			snprintf(ring_ref_s, 64, "ring-ref");
+			snprintf(evtchn_s, 64, "event-channel");
+		} else {
+			snprintf(ring_ref_s, 64, "ring-ref-%d", i);
+			snprintf(evtchn_s, 64, "event-channel-%d", i);
+		}
+		err = xenbus_gather(XBT_NIL, dev->otherend,
+				    ring_ref_s, "%lu", &ring_ref[i],
+				    evtchn_s, "%u", &evtchn[i], NULL);
+		if (err) {
+			xenbus_dev_fatal(dev, err,
+					 "reading %s/%s and event-channel",
+					 dev->otherend, ring_ref_s);
+			goto fail;
+		}
 	}
 
 	be->blkif->blk_protocol = BLKIF_PROTOCOL_NATIVE;
@@ -881,7 +981,8 @@ static int connect_ring(struct backend_info *be)
 		be->blkif->blk_protocol = BLKIF_PROTOCOL_X86_64;
 	else {
 		xenbus_dev_fatal(dev, err, "unknown fe protocol %s", protocol);
-		return -1;
+		err = -1;
+		goto fail;
 	}
 	err = xenbus_gather(XBT_NIL, dev->otherend,
 			    "feature-persistent", "%u",
@@ -892,19 +993,42 @@ static int connect_ring(struct backend_info *be)
 	be->blkif->vbd.feature_gnt_persistent = pers_grants;
 	be->blkif->vbd.overflow_max_grants = 0;
 
-	pr_info(DRV_PFX "ring-ref %ld, event-channel %d, protocol %d (%s) %s\n",
-		ring_ref, evtchn, be->blkif->blk_protocol, protocol,
-		pers_grants ? "persistent grants" : "");
+	blkif->rings = xen_blkif_ring_alloc(blkif, blkif->nr_rings);
+	if (!blkif->rings) {
+		err = -ENOMEM;
+		goto fail;
+	}
+	/*
+	 * Enforce postcondition on number of allocated rings; note that if we are
+	 * resuming it might happen that nr_supported_hw_queues != nr_rings,
+	 * so we cannot rely on such a postcondition.
+	 */
+	BUG_ON(!blkif->vbd.nr_supported_hw_queues &&
+		blkif->nr_rings != 1);
 
-	/* Map the shared frame, irq etc. */
-	err = xen_blkif_map(be->blkif, ring_ref, evtchn);
-	if (err) {
-		xenbus_dev_fatal(dev, err, "mapping ring-ref %lu port %u",
-				 ring_ref, evtchn);
-		return err;
+	for (i = 0; i < blkif->nr_rings ; i++) {
+		pr_info(DRV_PFX "ring-ref %ld, event-channel %d, protocol %d (%s) %s\n",
+			ring_ref[i], evtchn[i], blkif->blk_protocol, protocol,
+			pers_grants ? "persistent grants" : "");
+
+		/* Map the shared frame, irq etc. */
+		err = xen_blkif_map(&blkif->rings[i], ring_ref[i], evtchn[i], i);
+		if (err) {
+			xenbus_dev_fatal(dev, err, "mapping ring-ref %lu port %u of ring %d",
+					 ring_ref[i], evtchn[i], i);
+			goto fail;
+		}
 	}
 
+	kfree(ring_ref);
+	kfree(evtchn);
+
 	return 0;
+
+fail:
+	kfree(ring_ref);
+	kfree(evtchn);
+	return err;
 }
 
 
-- 
2.1.0

