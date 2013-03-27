Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3C0LMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:12:31 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:22412 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3C0LMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:12:24 -0400
X-IronPort-AV: E=Sophos;i="4.84,917,1355097600"; 
   d="scan'208";a="2955623"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 3/7] xen-blkback: implement LRU mechanism for persistent grants
Date: Wed, 27 Mar 2013 12:10:39 +0100
Message-ID: <1364382643-3711-4-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mechanism allows blkback to change the number of grants
persistently mapped at run time.

The algorithm uses a simple LRU mechanism that removes (if needed) the
persistent grants that have not been used since the last LRU run, or
if all grants have been used it removes the first grants in the list
(that are not in use).

The algorithm allows the user to change the maximum number of
persistent grants, by changing max_persistent_grants in sysfs.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org
---
Changes since RFC:
 * Offload part of the purge work to a kworker thread.
 * Add documentation about sysfs tunable.
---
 Documentation/ABI/stable/sysfs-bus-xen-backend |    7 +
 drivers/block/xen-blkback/blkback.c            |  278 +++++++++++++++++++-----
 drivers/block/xen-blkback/common.h             |   12 +
 drivers/block/xen-blkback/xenbus.c             |    2 +
 4 files changed, 240 insertions(+), 59 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-bus-xen-backend b/Documentation/ABI/stable/sysfs-bus-xen-backend
index e04afe0..7595b38 100644
--- a/Documentation/ABI/stable/sysfs-bus-xen-backend
+++ b/Documentation/ABI/stable/sysfs-bus-xen-backend
@@ -81,3 +81,10 @@ Contact:        Roger Pau Monné <roger.pau@citrix.com>
 Description:
                 Maximum number of free pages to keep in each block
                 backend buffer.
+
+What:           /sys/module/xen_blkback/parameters/max_persistent_grants
+Date:           March 2013
+KernelVersion:  3.10
+Contact:        Roger Pau Monné <roger.pau@citrix.com>
+Description:
+                Maximum number of grants to map persistently in blkback.
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 8a1892a..fd1dd38 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -78,6 +78,44 @@ module_param_named(max_buffer_pages, xen_blkif_max_buffer_pages, int, 0644);
 MODULE_PARM_DESC(max_buffer_pages,
 "Maximum number of free pages to keep in each block backend buffer");
 
+/*
+ * Maximum number of grants to map persistently in blkback. For maximum
+ * performance this should be the total numbers of grants that can be used
+ * to fill the ring, but since this might become too high, specially with
+ * the use of indirect descriptors, we set it to a value that provides good
+ * performance without using too much memory.
+ *
+ * When the list of persistent grants is full we clean it using a LRU
+ * algorithm.
+ */
+
+static int xen_blkif_max_pgrants = 352;
+module_param_named(max_persistent_grants, xen_blkif_max_pgrants, int, 0644);
+MODULE_PARM_DESC(max_persistent_grants,
+                 "Maximum number of grants to map persistently");
+
+/*
+ * The LRU mechanism to clean the lists of persistent grants needs to
+ * be executed periodically. The time interval between consecutive executions
+ * of the purge mechanism is set in ms.
+ */
+
+static int xen_blkif_lru_interval = 100;
+module_param_named(lru_interval, xen_blkif_lru_interval, int, 0);
+MODULE_PARM_DESC(lru_interval,
+"Execution interval (in ms) of the LRU mechanism to clean the list of persistent grants");
+
+/*
+ * When the persistent grants list is full we will remove unused grants
+ * from the list. The percent number of grants to be removed at each LRU
+ * execution.
+ */
+
+static int xen_blkif_lru_percent_clean = 5;
+module_param_named(lru_percent_clean, xen_blkif_lru_percent_clean, int, 0);
+MODULE_PARM_DESC(lru_percent_clean,
+"Number of persistent grants to unmap when the list is full");
+
 /* Run-time switchable: /sys/module/blkback/parameters/ */
 static unsigned int log_stats;
 module_param(log_stats, int, 0644);
@@ -96,8 +134,8 @@ struct pending_req {
 	unsigned short		operation;
 	int			status;
 	struct list_head	free_list;
-	DECLARE_BITMAP(unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
 	struct page		*pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt	*persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
 #define BLKBACK_INVALID_HANDLE (~0)
@@ -119,36 +157,6 @@ struct xen_blkbk {
 static struct xen_blkbk *blkbk;
 
 /*
- * Maximum number of grant pages that can be mapped in blkback.
- * BLKIF_MAX_SEGMENTS_PER_REQUEST * RING_SIZE is the maximum number of
- * pages that blkback will persistently map.
- * Currently, this is:
- * RING_SIZE = 32 (for all known ring types)
- * BLKIF_MAX_SEGMENTS_PER_REQUEST = 11
- * sizeof(struct persistent_gnt) = 48
- * So the maximum memory used to store the grants is:
- * 32 * 11 * 48 = 16896 bytes
- */
-static inline unsigned int max_mapped_grant_pages(enum blkif_protocol protocol)
-{
-	switch (protocol) {
-	case BLKIF_PROTOCOL_NATIVE:
-		return __CONST_RING_SIZE(blkif, PAGE_SIZE) *
-			   BLKIF_MAX_SEGMENTS_PER_REQUEST;
-	case BLKIF_PROTOCOL_X86_32:
-		return __CONST_RING_SIZE(blkif_x86_32, PAGE_SIZE) *
-			   BLKIF_MAX_SEGMENTS_PER_REQUEST;
-	case BLKIF_PROTOCOL_X86_64:
-		return __CONST_RING_SIZE(blkif_x86_64, PAGE_SIZE) *
-			   BLKIF_MAX_SEGMENTS_PER_REQUEST;
-	default:
-		BUG();
-	}
-	return 0;
-}
-
-
-/*
  * Little helpful macro to figure out the index and virtual address of the
  * pending_pages[..]. For each 'pending_req' we have have up to
  * BLKIF_MAX_SEGMENTS_PER_REQUEST (11) pages. The seg would be from 0 through
@@ -239,13 +247,19 @@ static void make_response(struct xen_blkif *blkif, u64 id,
 	     (n) = (&(pos)->node != NULL) ? rb_next(&(pos)->node) : NULL)
 
 
-static int add_persistent_gnt(struct rb_root *root,
+static int add_persistent_gnt(struct xen_blkif *blkif,
 			       struct persistent_gnt *persistent_gnt)
 {
-	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct rb_node **new = NULL, *parent = NULL;
 	struct persistent_gnt *this;
 
+	if (blkif->persistent_gnt_c >= xen_blkif_max_pgrants) {
+		if (!blkif->vbd.overflow_max_grants)
+			blkif->vbd.overflow_max_grants = 1;
+		return -EBUSY;
+	}
 	/* Figure out where to put new node */
+	new = &blkif->persistent_gnts.rb_node;
 	while (*new) {
 		this = container_of(*new, struct persistent_gnt, node);
 
@@ -259,19 +273,23 @@ static int add_persistent_gnt(struct rb_root *root,
 			return -EINVAL;
 		}
 	}
-
+	bitmap_zero(persistent_gnt->flags, PERSISTENT_GNT_FLAGS_SIZE);
+	set_bit(PERSISTENT_GNT_ACTIVE, persistent_gnt->flags);
 	/* Add new node and rebalance tree. */
 	rb_link_node(&(persistent_gnt->node), parent, new);
-	rb_insert_color(&(persistent_gnt->node), root);
+	rb_insert_color(&(persistent_gnt->node), &blkif->persistent_gnts);
+	blkif->persistent_gnt_c++;
+	atomic_inc(&blkif->persistent_gnt_in_use);
 	return 0;
 }
 
-static struct persistent_gnt *get_persistent_gnt(struct rb_root *root,
+static struct persistent_gnt *get_persistent_gnt(struct xen_blkif *blkif,
 						 grant_ref_t gref)
 {
 	struct persistent_gnt *data;
-	struct rb_node *node = root->rb_node;
+	struct rb_node *node = NULL;
 
+	node = blkif->persistent_gnts.rb_node;
 	while (node) {
 		data = container_of(node, struct persistent_gnt, node);
 
@@ -279,12 +297,25 @@ static struct persistent_gnt *get_persistent_gnt(struct rb_root *root,
 			node = node->rb_left;
 		else if (gref > data->gnt)
 			node = node->rb_right;
-		else
+		else {
+			WARN_ON(test_bit(PERSISTENT_GNT_ACTIVE, data->flags));
+			set_bit(PERSISTENT_GNT_ACTIVE, data->flags);
+			atomic_inc(&blkif->persistent_gnt_in_use);
 			return data;
+		}
 	}
 	return NULL;
 }
 
+static void put_persistent_gnt(struct xen_blkif *blkif,
+                               struct persistent_gnt *persistent_gnt)
+{
+	WARN_ON(!test_bit(PERSISTENT_GNT_ACTIVE, persistent_gnt->flags));
+	set_bit(PERSISTENT_GNT_USED, persistent_gnt->flags);
+	clear_bit(PERSISTENT_GNT_ACTIVE, persistent_gnt->flags);
+	atomic_dec(&blkif->persistent_gnt_in_use);
+}
+
 static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
                                  unsigned int num)
 {
@@ -322,6 +353,122 @@ static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
 	BUG_ON(num != 0);
 }
 
+static void unmap_purged_grants(struct work_struct *work)
+{
+	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct page *pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt *persistent_gnt;
+	int ret, segs_to_unmap = 0;
+	struct xen_blkif *blkif =
+		container_of(work, typeof(*blkif), persistent_purge_work);
+
+	while(!list_empty(&blkif->persistent_purge_list)) {
+		persistent_gnt = list_first_entry(&blkif->persistent_purge_list,
+		                                  struct persistent_gnt,
+		                                  remove_node);
+		list_del(&persistent_gnt->remove_node);
+
+		gnttab_set_unmap_op(&unmap[segs_to_unmap],
+			vaddr(persistent_gnt->page),
+			GNTMAP_host_map,
+			persistent_gnt->handle);
+
+		pages[segs_to_unmap] = persistent_gnt->page;
+
+		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
+			ret = gnttab_unmap_refs(unmap, NULL, pages,
+				segs_to_unmap);
+			BUG_ON(ret);
+			put_free_pages(blkif, pages, segs_to_unmap);
+			segs_to_unmap = 0;
+		}
+		kfree(persistent_gnt);
+	}
+	if (segs_to_unmap > 0) {
+		ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap);
+		BUG_ON(ret);
+		put_free_pages(blkif, pages, segs_to_unmap);
+	}
+}
+
+static void purge_persistent_gnt(struct xen_blkif *blkif)
+{
+	struct persistent_gnt *persistent_gnt;
+	struct rb_node *n;
+	int num_clean, total;
+	bool scan_used = false;
+	struct rb_root *root;
+
+	if (blkif->persistent_gnt_c < xen_blkif_max_pgrants ||
+	    (blkif->persistent_gnt_c == xen_blkif_max_pgrants &&
+	    !blkif->vbd.overflow_max_grants)) {
+		return;
+	}
+
+	if (work_pending(&blkif->persistent_purge_work)) {
+		pr_alert_ratelimited(DRV_PFX "Scheduled work from previous purge is still pending, cannot purge list\n");
+		return;
+	}
+
+	num_clean = (xen_blkif_max_pgrants / 100) * xen_blkif_lru_percent_clean;
+	num_clean = blkif->persistent_gnt_c - xen_blkif_max_pgrants + num_clean;
+	num_clean = num_clean > blkif->persistent_gnt_c ?
+	            blkif->persistent_gnt_c : num_clean;
+	if (num_clean >
+	    (blkif->persistent_gnt_c -
+	    atomic_read(&blkif->persistent_gnt_in_use)))
+		return;
+
+	total = num_clean;
+
+	pr_debug(DRV_PFX "Going to purge %d persistent grants\n", num_clean);
+
+	INIT_LIST_HEAD(&blkif->persistent_purge_list);
+	root = &blkif->persistent_gnts;
+purge_list:
+	foreach_grant_safe(persistent_gnt, n, root, node) {
+		BUG_ON(persistent_gnt->handle ==
+			BLKBACK_INVALID_HANDLE);
+
+		if (test_bit(PERSISTENT_GNT_ACTIVE, persistent_gnt->flags))
+			continue;
+		if (!scan_used &&
+		    (test_bit(PERSISTENT_GNT_USED, persistent_gnt->flags)))
+			continue;
+
+		rb_erase(&persistent_gnt->node, root);
+		list_add(&persistent_gnt->remove_node,
+		         &blkif->persistent_purge_list);
+		if (--num_clean == 0)
+			goto finished;
+	}
+	/*
+	 * If we get here it means we also need to start cleaning
+	 * grants that were used since last purge in order to cope
+	 * with the requested num
+	 */
+	if (!scan_used) {
+		pr_debug(DRV_PFX "Still missing %d purged frames\n", num_clean);
+		scan_used = true;
+		goto purge_list;
+	}
+finished:
+	/* Remove the "used" flag from all the persistent grants */
+	foreach_grant_safe(persistent_gnt, n, root, node) {
+		BUG_ON(persistent_gnt->handle ==
+			BLKBACK_INVALID_HANDLE);
+		clear_bit(PERSISTENT_GNT_USED, persistent_gnt->flags);
+	}
+	blkif->persistent_gnt_c -= (total - num_clean);
+	blkif->vbd.overflow_max_grants = 0;
+
+	/* We can defer this work */
+	INIT_WORK(&blkif->persistent_purge_work, unmap_purged_grants);
+	schedule_work(&blkif->persistent_purge_work);
+	pr_debug(DRV_PFX "Purged %d/%d\n", (total - num_clean), total);
+	return;
+}
+
 /*
  * Retrieve from the 'pending_reqs' a free pending_req structure to be used.
  */
@@ -453,12 +600,12 @@ irqreturn_t xen_blkif_be_int(int irq, void *dev_id)
 static void print_stats(struct xen_blkif *blkif)
 {
 	pr_info("xen-blkback (%s): oo %3llu  |  rd %4llu  |  wr %4llu  |  f %4llu"
-		 "  |  ds %4llu | pg: %4u/%4u\n",
+		 "  |  ds %4llu | pg: %4u/%4d\n",
 		 current->comm, blkif->st_oo_req,
 		 blkif->st_rd_req, blkif->st_wr_req,
 		 blkif->st_f_req, blkif->st_ds_req,
 		 blkif->persistent_gnt_c,
-		 max_mapped_grant_pages(blkif->blk_protocol));
+		 xen_blkif_max_pgrants);
 	blkif->st_print = jiffies + msecs_to_jiffies(10 * 1000);
 	blkif->st_rd_req = 0;
 	blkif->st_wr_req = 0;
@@ -470,6 +617,7 @@ int xen_blkif_schedule(void *arg)
 {
 	struct xen_blkif *blkif = arg;
 	struct xen_vbd *vbd = &blkif->vbd;
+	unsigned long timeout;
 
 	xen_blkif_get(blkif);
 
@@ -479,13 +627,21 @@ int xen_blkif_schedule(void *arg)
 		if (unlikely(vbd->size != vbd_sz(vbd)))
 			xen_vbd_resize(blkif);
 
-		wait_event_interruptible(
+		timeout = msecs_to_jiffies(xen_blkif_lru_interval);
+
+		timeout = wait_event_interruptible_timeout(
 			blkif->wq,
-			blkif->waiting_reqs || kthread_should_stop());
-		wait_event_interruptible(
+			blkif->waiting_reqs || kthread_should_stop(),
+			timeout);
+		if (timeout == 0)
+			goto purge_gnt_list;
+		timeout = wait_event_interruptible_timeout(
 			blkbk->pending_free_wq,
 			!list_empty(&blkbk->pending_free) ||
-			kthread_should_stop());
+			kthread_should_stop(),
+			timeout);
+		if (timeout == 0)
+			goto purge_gnt_list;
 
 		blkif->waiting_reqs = 0;
 		smp_mb(); /* clear flag *before* checking for work */
@@ -493,6 +649,14 @@ int xen_blkif_schedule(void *arg)
 		if (do_block_io_op(blkif))
 			blkif->waiting_reqs = 1;
 
+purge_gnt_list:
+		if (blkif->vbd.feature_gnt_persistent &&
+		    time_after(jiffies, blkif->next_lru)) {
+			purge_persistent_gnt(blkif);
+			blkif->next_lru = jiffies +
+				msecs_to_jiffies(xen_blkif_lru_interval);
+		}
+
 		shrink_free_pagepool(blkif, xen_blkif_max_buffer_pages);
 
 		if (log_stats && time_after(jiffies, blkif->st_print))
@@ -504,7 +668,7 @@ int xen_blkif_schedule(void *arg)
 	/* Free all persistent grant pages */
 	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
 		free_persistent_gnts(blkif, &blkif->persistent_gnts,
-			blkif->persistent_gnt_c);
+		                     blkif->persistent_gnt_c);
 
 	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
 	blkif->persistent_gnt_c = 0;
@@ -536,8 +700,10 @@ static void xen_blkbk_unmap(struct pending_req *req)
 	int ret;
 
 	for (i = 0; i < req->nr_pages; i++) {
-		if (!test_bit(i, req->unmap_seg))
+		if (req->persistent_gnts[i] != NULL) {
+			put_persistent_gnt(blkif, req->persistent_gnts[i]);
 			continue;
+		}
 		handle = pending_handle(req, i);
 		pages[invcount] = req->pages[i];
 		if (handle == BLKBACK_INVALID_HANDLE)
@@ -559,8 +725,8 @@ static int xen_blkbk_map(struct blkif_request *req,
 			 struct page *pages[])
 {
 	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct persistent_gnt *persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct page *pages_to_gnt[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt **persistent_gnts = pending_req->persistent_gnts;
 	struct persistent_gnt *persistent_gnt = NULL;
 	struct xen_blkif *blkif = pending_req->blkif;
 	phys_addr_t addr = 0;
@@ -572,9 +738,6 @@ static int xen_blkbk_map(struct blkif_request *req,
 
 	use_persistent_gnts = (blkif->vbd.feature_gnt_persistent);
 
-	BUG_ON(blkif->persistent_gnt_c >
-		   max_mapped_grant_pages(pending_req->blkif->blk_protocol));
-
 	/*
 	 * Fill out preq.nr_sects with proper amount of sectors, and setup
 	 * assign map[..] with the PFN of the page in our domain with the
@@ -585,7 +748,7 @@ static int xen_blkbk_map(struct blkif_request *req,
 
 		if (use_persistent_gnts)
 			persistent_gnt = get_persistent_gnt(
-				&blkif->persistent_gnts,
+				blkif,
 				req->u.rw.seg[i].gref);
 
 		if (persistent_gnt) {
@@ -621,7 +784,6 @@ static int xen_blkbk_map(struct blkif_request *req,
 	 * so that when we access vaddr(pending_req,i) it has the contents of
 	 * the page from the other domain.
 	 */
-	bitmap_zero(pending_req->unmap_seg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
 	for (i = 0, j = 0; i < nseg; i++) {
 		if (!persistent_gnts[i]) {
 			/* This is a newly mapped grant */
@@ -639,11 +801,10 @@ static int xen_blkbk_map(struct blkif_request *req,
 		if (persistent_gnts[i])
 			goto next;
 		if (use_persistent_gnts &&
-		    blkif->persistent_gnt_c <
-		    max_mapped_grant_pages(blkif->blk_protocol)) {
+		    blkif->persistent_gnt_c < xen_blkif_max_pgrants) {
 			/*
 			 * We are using persistent grants, the grant is
-			 * not mapped but we have room for it
+			 * not mapped but we might have room for it.
 			 */
 			persistent_gnt = kmalloc(sizeof(struct persistent_gnt),
 				                 GFP_KERNEL);
@@ -659,16 +820,16 @@ static int xen_blkbk_map(struct blkif_request *req,
 			persistent_gnt->gnt = map[j].ref;
 			persistent_gnt->handle = map[j].handle;
 			persistent_gnt->page = pages[i];
-			if (add_persistent_gnt(&blkif->persistent_gnts,
+			if (add_persistent_gnt(blkif,
 			                       persistent_gnt)) {
 				kfree(persistent_gnt);
 				j++;
 				goto next;
 			}
-			blkif->persistent_gnt_c++;
+			persistent_gnts[i] = persistent_gnt;
 			pr_debug(DRV_PFX " grant %u added to the tree of persistent grants, using %u/%u\n",
 				 persistent_gnt->gnt, blkif->persistent_gnt_c,
-				 max_mapped_grant_pages(blkif->blk_protocol));
+				 xen_blkif_max_pgrants);
 			j++;
 			goto next;
 		}
@@ -677,7 +838,6 @@ static int xen_blkbk_map(struct blkif_request *req,
 			pr_debug(DRV_PFX " domain %u, device %#x is using maximum number of persistent grants\n",
 			         blkif->domid, blkif->vbd.handle);
 		}
-		bitmap_set(pending_req->unmap_seg, i, 1);
 		j++;
 next:
 		seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 6c73c38..f43782c 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -182,12 +182,17 @@ struct xen_vbd {
 
 struct backend_info;
 
+#define PERSISTENT_GNT_FLAGS_SIZE	2
+#define PERSISTENT_GNT_ACTIVE		0
+#define PERSISTENT_GNT_USED		1
 
 struct persistent_gnt {
 	struct page *page;
 	grant_ref_t gnt;
 	grant_handle_t handle;
+	DECLARE_BITMAP(flags, PERSISTENT_GNT_FLAGS_SIZE);
 	struct rb_node node;
+	struct list_head remove_node;
 };
 
 struct xen_blkif {
@@ -219,6 +224,12 @@ struct xen_blkif {
 	/* tree to store persistent grants */
 	struct rb_root		persistent_gnts;
 	unsigned int		persistent_gnt_c;
+	atomic_t		persistent_gnt_in_use;
+	unsigned long           next_lru;
+
+	/* used by the kworker that offload work from the persistent purge */
+	struct list_head	persistent_purge_list;
+	struct work_struct	persistent_purge_work;
 
 	/* buffer of free pages to map grant refs */
 	spinlock_t		free_pages_lock;
@@ -262,6 +273,7 @@ int xen_blkif_xenbus_init(void);
 
 irqreturn_t xen_blkif_be_int(int irq, void *dev_id);
 int xen_blkif_schedule(void *arg);
+int xen_blkif_purge_persistent(void *arg);
 
 int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
 			      struct backend_info *be, int state);
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 24f7f6d..e0fd92a 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -98,6 +98,7 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
 		err = PTR_ERR(blkif->xenblkd);
 		blkif->xenblkd = NULL;
 		xenbus_dev_error(blkif->be->dev, err, "start xenblkd");
+		return;
 	}
 }
 
@@ -121,6 +122,7 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	spin_lock_init(&blkif->free_pages_lock);
 	INIT_LIST_HEAD(&blkif->free_pages);
 	blkif->free_pages_num = 0;
+	atomic_set(&blkif->persistent_gnt_in_use, 0);
 
 	return blkif;
 }
-- 
1.7.7.5 (Apple Git-26)

