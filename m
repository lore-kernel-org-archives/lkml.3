Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab3C0LN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:13:56 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:59474 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3C0LMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:12:25 -0400
X-IronPort-AV: E=Sophos;i="4.84,917,1355097600"; 
   d="scan'208";a="2955625"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 5/7] xen-blkback: make the queue of free requests per backend
Date: Wed, 27 Mar 2013 12:10:41 +0100
Message-ID: <1364382643-3711-6-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the last dependency from blkbk by moving the list of free
requests to blkif. This change reduces the contention on the list of
available requests.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org
---
Changes since RFC:
 * Replace kzalloc with kcalloc.
---
 drivers/block/xen-blkback/blkback.c |  125 +++++++----------------------------
 drivers/block/xen-blkback/common.h  |   27 ++++++++
 drivers/block/xen-blkback/xenbus.c  |   19 +++++
 3 files changed, 70 insertions(+), 101 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index e6542d5..a1c9dad 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -50,18 +50,14 @@
 #include "common.h"
 
 /*
- * These are rather arbitrary. They are fairly large because adjacent requests
- * pulled from a communication ring are quite likely to end up being part of
- * the same scatter/gather request at the disc.
- *
- * ** TRY INCREASING 'xen_blkif_reqs' IF WRITE SPEEDS SEEM TOO LOW **
- *
- * This will increase the chances of being able to write whole tracks.
- * 64 should be enough to keep us competitive with Linux.
+ * This is the number of requests that will be pre-allocated for each backend.
+ * For better performance this is set to RING_SIZE (32), so requests
+ * in the ring will never have to wait for a free pending_req.
  */
-static int xen_blkif_reqs = 64;
+
+int xen_blkif_reqs = 32;
 module_param_named(reqs, xen_blkif_reqs, int, 0);
-MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate");
+MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate per backend");
 
 /*
  * Maximum number of unused free pages to keep in the internal buffer.
@@ -120,53 +116,11 @@ MODULE_PARM_DESC(lru_percent_clean,
 static unsigned int log_stats;
 module_param(log_stats, int, 0644);
 
-/*
- * Each outstanding request that we've passed to the lower device layers has a
- * 'pending_req' allocated to it. Each buffer_head that completes decrements
- * the pendcnt towards zero. When it hits zero, the specified domain has a
- * response queued for it, with the saved 'id' passed back.
- */
-struct pending_req {
-	struct xen_blkif	*blkif;
-	u64			id;
-	int			nr_pages;
-	atomic_t		pendcnt;
-	unsigned short		operation;
-	int			status;
-	struct list_head	free_list;
-	struct page		*pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct persistent_gnt	*persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	grant_handle_t		grant_handles[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-};
-
 #define BLKBACK_INVALID_HANDLE (~0)
 
 /* Number of free pages to remove on each call to free_xenballooned_pages */
 #define NUM_BATCH_FREE_PAGES 10
 
-struct xen_blkbk {
-	struct pending_req	*pending_reqs;
-	/* List of all 'pending_req' available */
-	struct list_head	pending_free;
-	/* And its spinlock. */
-	spinlock_t		pending_free_lock;
-	wait_queue_head_t	pending_free_wq;
-};
-
-static struct xen_blkbk *blkbk;
-
-/*
- * Little helpful macro to figure out the index and virtual address of the
- * pending_pages[..]. For each 'pending_req' we have have up to
- * BLKIF_MAX_SEGMENTS_PER_REQUEST (11) pages. The seg would be from 0 through
- * 10 and would index in the pending_pages[..].
- */
-static inline int vaddr_pagenr(struct pending_req *req, int seg)
-{
-	return (req - blkbk->pending_reqs) *
-		BLKIF_MAX_SEGMENTS_PER_REQUEST + seg;
-}
-
 static inline int get_free_page(struct xen_blkif *blkif, struct page **page)
 {
 	unsigned long flags;
@@ -471,18 +425,18 @@ finished:
 /*
  * Retrieve from the 'pending_reqs' a free pending_req structure to be used.
  */
-static struct pending_req *alloc_req(void)
+static struct pending_req *alloc_req(struct xen_blkif *blkif)
 {
 	struct pending_req *req = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&blkbk->pending_free_lock, flags);
-	if (!list_empty(&blkbk->pending_free)) {
-		req = list_entry(blkbk->pending_free.next, struct pending_req,
+	spin_lock_irqsave(&blkif->pending_free_lock, flags);
+	if (!list_empty(&blkif->pending_free)) {
+		req = list_entry(blkif->pending_free.next, struct pending_req,
 				 free_list);
 		list_del(&req->free_list);
 	}
-	spin_unlock_irqrestore(&blkbk->pending_free_lock, flags);
+	spin_unlock_irqrestore(&blkif->pending_free_lock, flags);
 	return req;
 }
 
@@ -490,17 +444,17 @@ static struct pending_req *alloc_req(void)
  * Return the 'pending_req' structure back to the freepool. We also
  * wake up the thread if it was waiting for a free page.
  */
-static void free_req(struct pending_req *req)
+static void free_req(struct xen_blkif *blkif, struct pending_req *req)
 {
 	unsigned long flags;
 	int was_empty;
 
-	spin_lock_irqsave(&blkbk->pending_free_lock, flags);
-	was_empty = list_empty(&blkbk->pending_free);
-	list_add(&req->free_list, &blkbk->pending_free);
-	spin_unlock_irqrestore(&blkbk->pending_free_lock, flags);
+	spin_lock_irqsave(&blkif->pending_free_lock, flags);
+	was_empty = list_empty(&blkif->pending_free);
+	list_add(&req->free_list, &blkif->pending_free);
+	spin_unlock_irqrestore(&blkif->pending_free_lock, flags);
 	if (was_empty)
-		wake_up(&blkbk->pending_free_wq);
+		wake_up(&blkif->pending_free_wq);
 }
 
 /*
@@ -635,8 +589,8 @@ int xen_blkif_schedule(void *arg)
 		if (timeout == 0)
 			goto purge_gnt_list;
 		timeout = wait_event_interruptible_timeout(
-			blkbk->pending_free_wq,
-			!list_empty(&blkbk->pending_free) ||
+			blkif->pending_free_wq,
+			!list_empty(&blkif->pending_free) ||
 			kthread_should_stop(),
 			timeout);
 		if (timeout == 0)
@@ -883,7 +837,7 @@ static int dispatch_other_io(struct xen_blkif *blkif,
 			     struct blkif_request *req,
 			     struct pending_req *pending_req)
 {
-	free_req(pending_req);
+	free_req(blkif, pending_req);
 	make_response(blkif, req->u.other.id, req->operation,
 		      BLKIF_RSP_EOPNOTSUPP);
 	return -EIO;
@@ -943,7 +897,7 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 			if (atomic_read(&pending_req->blkif->drain))
 				complete(&pending_req->blkif->drain_complete);
 		}
-		free_req(pending_req);
+		free_req(pending_req->blkif, pending_req);
 	}
 }
 
@@ -986,7 +940,7 @@ __do_block_io_op(struct xen_blkif *blkif)
 			break;
 		}
 
-		pending_req = alloc_req();
+		pending_req = alloc_req(blkif);
 		if (NULL == pending_req) {
 			blkif->st_oo_req++;
 			more_to_do = 1;
@@ -1020,7 +974,7 @@ __do_block_io_op(struct xen_blkif *blkif)
 				goto done;
 			break;
 		case BLKIF_OP_DISCARD:
-			free_req(pending_req);
+			free_req(blkif, pending_req);
 			if (dispatch_discard_io(blkif, &req))
 				goto done;
 			break;
@@ -1222,7 +1176,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
  fail_response:
 	/* Haven't submitted any bio's yet. */
 	make_response(blkif, req->u.rw.id, req->operation, BLKIF_RSP_ERROR);
-	free_req(pending_req);
+	free_req(blkif, pending_req);
 	msleep(1); /* back off a bit */
 	return -EIO;
 
@@ -1279,51 +1233,20 @@ static void make_response(struct xen_blkif *blkif, u64 id,
 
 static int __init xen_blkif_init(void)
 {
-	int i;
 	int rc = 0;
 
 	if (!xen_domain())
 		return -ENODEV;
 
-	blkbk = kzalloc(sizeof(struct xen_blkbk), GFP_KERNEL);
-	if (!blkbk) {
-		pr_alert(DRV_PFX "%s: out of memory!\n", __func__);
-		return -ENOMEM;
-	}
-
-
-	blkbk->pending_reqs          = kzalloc(sizeof(blkbk->pending_reqs[0]) *
-					xen_blkif_reqs, GFP_KERNEL);
-
-	if (!blkbk->pending_reqs) {
-		rc = -ENOMEM;
-		goto out_of_memory;
-	}
-
 	rc = xen_blkif_interface_init();
 	if (rc)
 		goto failed_init;
 
-	INIT_LIST_HEAD(&blkbk->pending_free);
-	spin_lock_init(&blkbk->pending_free_lock);
-	init_waitqueue_head(&blkbk->pending_free_wq);
-
-	for (i = 0; i < xen_blkif_reqs; i++)
-		list_add_tail(&blkbk->pending_reqs[i].free_list,
-			      &blkbk->pending_free);
-
 	rc = xen_blkif_xenbus_init();
 	if (rc)
 		goto failed_init;
 
-	return 0;
-
- out_of_memory:
-	pr_alert(DRV_PFX "%s: out of memory\n", __func__);
  failed_init:
-	kfree(blkbk->pending_reqs);
-	kfree(blkbk);
-	blkbk = NULL;
 	return rc;
 }
 
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index f43782c..debff44 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -236,6 +236,14 @@ struct xen_blkif {
 	int			free_pages_num;
 	struct list_head	free_pages;
 
+	/* Allocation of pending_reqs */
+	struct pending_req	*pending_reqs;
+	/* List of all 'pending_req' available */
+	struct list_head	pending_free;
+	/* And its spinlock. */
+	spinlock_t		pending_free_lock;
+	wait_queue_head_t	pending_free_wq;
+
 	/* statistics */
 	unsigned long		st_print;
 	unsigned long long			st_rd_req;
@@ -249,6 +257,25 @@ struct xen_blkif {
 	wait_queue_head_t	waiting_to_free;
 };
 
+/*
+ * Each outstanding request that we've passed to the lower device layers has a
+ * 'pending_req' allocated to it. Each buffer_head that completes decrements
+ * the pendcnt towards zero. When it hits zero, the specified domain has a
+ * response queued for it, with the saved 'id' passed back.
+ */
+struct pending_req {
+	struct xen_blkif	*blkif;
+	u64			id;
+	int			nr_pages;
+	atomic_t		pendcnt;
+	unsigned short		operation;
+	int			status;
+	struct list_head	free_list;
+	struct page		*pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct persistent_gnt	*persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	grant_handle_t		grant_handles[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+};
+
 
 #define vbd_sz(_v)	((_v)->bdev->bd_part ? \
 			 (_v)->bdev->bd_part->nr_sects : \
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index e0fd92a..bf7344f 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -30,6 +30,8 @@ struct backend_info {
 	char			*mode;
 };
 
+extern int xen_blkif_reqs;
+
 static struct kmem_cache *xen_blkif_cachep;
 static void connect(struct backend_info *);
 static int connect_ring(struct backend_info *);
@@ -105,6 +107,7 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
 static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 {
 	struct xen_blkif *blkif;
+	int i;
 
 	blkif = kmem_cache_zalloc(xen_blkif_cachep, GFP_KERNEL);
 	if (!blkif)
@@ -124,6 +127,21 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
 	blkif->free_pages_num = 0;
 	atomic_set(&blkif->persistent_gnt_in_use, 0);
 
+	blkif->pending_reqs = kcalloc(xen_blkif_reqs,
+	                              sizeof(blkif->pending_reqs[0]),
+	                              GFP_KERNEL);
+	if (!blkif->pending_reqs) {
+		kmem_cache_free(xen_blkif_cachep, blkif);
+		return ERR_PTR(-ENOMEM);
+	}
+	INIT_LIST_HEAD(&blkif->pending_free);
+	spin_lock_init(&blkif->pending_free_lock);
+	init_waitqueue_head(&blkif->pending_free_wq);
+
+	for (i = 0; i < xen_blkif_reqs; i++)
+		list_add_tail(&blkif->pending_reqs[i].free_list,
+			      &blkif->pending_free);
+
 	return blkif;
 }
 
@@ -205,6 +223,7 @@ static void xen_blkif_free(struct xen_blkif *blkif)
 {
 	if (!atomic_dec_and_test(&blkif->refcnt))
 		BUG();
+	kfree(blkif->pending_reqs);
 	kmem_cache_free(xen_blkif_cachep, blkif);
 }
 
-- 
1.7.7.5 (Apple Git-26)

