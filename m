Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbaHVLTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:19:34 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39260 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbaHVLTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:19:31 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: bob.liu@oracle.com, felipe.franciosi@citrix.com, axboe@fb.com,
        avanzini.arianna@gmail.com
Subject: [PATCH RFC 3/4] xen, blkfront: introduce support for multiple hw queues
Date: Fri, 22 Aug 2014 13:20:03 +0200
Message-Id: <1408706404-6614-4-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit introduces in xen-blkfront actual support for multiple
hardware queues. The number of available hardware queues is gathered
from the backend via XenStore; in case the expected XenStore key
is not available, the frontend defaults to a single I/O ring.

Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 drivers/block/xen-blkfront.c | 793 +++++++++++++++++++++++++------------------
 1 file changed, 463 insertions(+), 330 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index a047346..e27aaa1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -99,10 +99,27 @@ static unsigned int xen_blkif_max_segments = 32;
 module_param_named(max, xen_blkif_max_segments, int, S_IRUGO);
 MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 32)");
 
-static unsigned int hardware_queues = 1;
-
 #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
+struct blkfront_ring_info
+{
+	spinlock_t io_lock;
+	int ring_ref;
+	struct blkif_front_ring ring;
+	unsigned int evtchn, irq;
+	struct blk_shadow shadow[BLK_RING_SIZE];
+	unsigned long shadow_free;
+
+	struct work_struct work;
+	struct gnttab_free_callback callback;
+	struct list_head grants;
+	struct list_head indirect_pages;
+	unsigned int persistent_gnts_c;
+
+	struct blkfront_info *info;
+	unsigned int hctx_index;
+};
+
 /*
  * We have one of these per vbd, whether ide, scsi or 'other'.  They
  * hang in private_data off the gendisk structure. We may end up
@@ -110,24 +127,15 @@ static unsigned int hardware_queues = 1;
  */
 struct blkfront_info
 {
-	spinlock_t io_lock;
 	struct mutex mutex;
 	struct xenbus_device *xbdev;
 	struct gendisk *gd;
 	int vdevice;
 	blkif_vdev_t handle;
 	enum blkif_state connected;
-	int ring_ref;
-	struct blkif_front_ring ring;
-	unsigned int evtchn, irq;
+	unsigned int nr_rings;
+	struct blkfront_ring_info *rinfo;
 	struct request_queue *rq;
-	struct work_struct work;
-	struct gnttab_free_callback callback;
-	struct blk_shadow shadow[BLK_RING_SIZE];
-	struct list_head grants;
-	struct list_head indirect_pages;
-	unsigned int persistent_gnts_c;
-	unsigned long shadow_free;
 	unsigned int feature_flush;
 	unsigned int flush_op;
 	unsigned int feature_discard:1;
@@ -135,6 +143,7 @@ struct blkfront_info
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	unsigned int feature_persistent:1;
+	unsigned int hardware_queues;
 	unsigned int max_indirect_segments;
 	int is_ready;
 	/* Block layer tags. */
@@ -171,32 +180,35 @@ static DEFINE_SPINLOCK(minor_lock);
 #define INDIRECT_GREFS(_segs) \
 	((_segs + SEGS_PER_INDIRECT_FRAME - 1)/SEGS_PER_INDIRECT_FRAME)
 
-static int blkfront_setup_indirect(struct blkfront_info *info);
+static int blkfront_gather_indirect(struct blkfront_info *info);
+static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo,
+				   unsigned int segs);
 
-static int get_id_from_freelist(struct blkfront_info *info)
+static int get_id_from_freelist(struct blkfront_ring_info *rinfo)
 {
-	unsigned long free = info->shadow_free;
+	unsigned long free = rinfo->shadow_free;
 	BUG_ON(free >= BLK_RING_SIZE);
-	info->shadow_free = info->shadow[free].req.u.rw.id;
-	info->shadow[free].req.u.rw.id = 0x0fffffee; /* debug */
+	rinfo->shadow_free = rinfo->shadow[free].req.u.rw.id;
+	rinfo->shadow[free].req.u.rw.id = 0x0fffffee; /* debug */
 	return free;
 }
 
-static int add_id_to_freelist(struct blkfront_info *info,
+static int add_id_to_freelist(struct blkfront_ring_info *rinfo,
 			       unsigned long id)
 {
-	if (info->shadow[id].req.u.rw.id != id)
+	if (rinfo->shadow[id].req.u.rw.id != id)
 		return -EINVAL;
-	if (info->shadow[id].request == NULL)
+	if (rinfo->shadow[id].request == NULL)
 		return -EINVAL;
-	info->shadow[id].req.u.rw.id  = info->shadow_free;
-	info->shadow[id].request = NULL;
-	info->shadow_free = id;
+	rinfo->shadow[id].req.u.rw.id  = rinfo->shadow_free;
+	rinfo->shadow[id].request = NULL;
+	rinfo->shadow_free = id;
 	return 0;
 }
 
-static int fill_grant_buffer(struct blkfront_info *info, int num)
+static int fill_grant_buffer(struct blkfront_ring_info *rinfo, int num)
 {
+	struct blkfront_info *info = rinfo->info;
 	struct page *granted_page;
 	struct grant *gnt_list_entry, *n;
 	int i = 0;
@@ -216,7 +228,7 @@ static int fill_grant_buffer(struct blkfront_info *info, int num)
 		}
 
 		gnt_list_entry->gref = GRANT_INVALID_REF;
-		list_add(&gnt_list_entry->node, &info->grants);
+		list_add(&gnt_list_entry->node, &rinfo->grants);
 		i++;
 	}
 
@@ -224,7 +236,7 @@ static int fill_grant_buffer(struct blkfront_info *info, int num)
 
 out_of_memory:
 	list_for_each_entry_safe(gnt_list_entry, n,
-	                         &info->grants, node) {
+	                         &rinfo->grants, node) {
 		list_del(&gnt_list_entry->node);
 		if (info->feature_persistent)
 			__free_page(pfn_to_page(gnt_list_entry->pfn));
@@ -237,31 +249,31 @@ out_of_memory:
 
 static struct grant *get_grant(grant_ref_t *gref_head,
                                unsigned long pfn,
-                               struct blkfront_info *info)
+                               struct blkfront_ring_info *rinfo)
 {
 	struct grant *gnt_list_entry;
 	unsigned long buffer_mfn;
 
-	BUG_ON(list_empty(&info->grants));
-	gnt_list_entry = list_first_entry(&info->grants, struct grant,
+	BUG_ON(list_empty(&rinfo->grants));
+	gnt_list_entry = list_first_entry(&rinfo->grants, struct grant,
 	                                  node);
 	list_del(&gnt_list_entry->node);
 
 	if (gnt_list_entry->gref != GRANT_INVALID_REF) {
-		info->persistent_gnts_c--;
+		rinfo->persistent_gnts_c--;
 		return gnt_list_entry;
 	}
 
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
-	if (!info->feature_persistent) {
+	if (!rinfo->info->feature_persistent) {
 		BUG_ON(!pfn);
 		gnt_list_entry->pfn = pfn;
 	}
 	buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
 	gnttab_grant_foreign_access_ref(gnt_list_entry->gref,
-	                                info->xbdev->otherend_id,
+	                                rinfo->info->xbdev->otherend_id,
 	                                buffer_mfn, 0);
 	return gnt_list_entry;
 }
@@ -332,8 +344,8 @@ static void xlbd_release_minors(unsigned int minor, unsigned int nr)
 
 static void blkif_restart_queue_callback(void *arg)
 {
-	struct blkfront_info *info = (struct blkfront_info *)arg;
-	schedule_work(&info->work);
+	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)arg;
+	schedule_work(&rinfo->work);
 }
 
 static int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
@@ -392,9 +404,11 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
  * @req: a request struct
  * @ring_idx: index of the ring the request is to be inserted in
  */
-static int blkif_queue_request(struct request *req)
+static int blkif_queue_request(struct request *req, unsigned int ring_idx)
 {
 	struct blkfront_info *info = req->rq_disk->private_data;
+	struct blkfront_ring_info *rinfo = &info->rinfo[ring_idx];
+	struct blkif_front_ring *ring = &info->rinfo[ring_idx].ring;
 	struct blkif_request *ring_req;
 	unsigned long id;
 	unsigned int fsect, lsect;
@@ -424,15 +438,15 @@ static int blkif_queue_request(struct request *req)
 		max_grefs += INDIRECT_GREFS(req->nr_phys_segments);
 
 	/* Check if we have enough grants to allocate a requests */
-	if (info->persistent_gnts_c < max_grefs) {
+	if (rinfo->persistent_gnts_c < max_grefs) {
 		new_persistent_gnts = 1;
 		if (gnttab_alloc_grant_references(
-		    max_grefs - info->persistent_gnts_c,
+		    max_grefs - rinfo->persistent_gnts_c,
 		    &gref_head) < 0) {
 			gnttab_request_free_callback(
-				&info->callback,
+				&rinfo->callback,
 				blkif_restart_queue_callback,
-				info,
+				rinfo,
 				max_grefs);
 			return 1;
 		}
@@ -440,9 +454,9 @@ static int blkif_queue_request(struct request *req)
 		new_persistent_gnts = 0;
 
 	/* Fill out a communications ring structure. */
-	ring_req = RING_GET_REQUEST(&info->ring, info->ring.req_prod_pvt);
-	id = get_id_from_freelist(info);
-	info->shadow[id].request = req;
+	ring_req = RING_GET_REQUEST(ring, ring->req_prod_pvt);
+	id = get_id_from_freelist(rinfo);
+	rinfo->shadow[id].request = req;
 
 	if (unlikely(req->cmd_flags & (REQ_DISCARD | REQ_SECURE))) {
 		ring_req->operation = BLKIF_OP_DISCARD;
@@ -458,7 +472,7 @@ static int blkif_queue_request(struct request *req)
 		       req->nr_phys_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
 		BUG_ON(info->max_indirect_segments &&
 		       req->nr_phys_segments > info->max_indirect_segments);
-		nseg = blk_rq_map_sg(req->q, req, info->shadow[id].sg);
+		nseg = blk_rq_map_sg(req->q, req, rinfo->shadow[id].sg);
 		ring_req->u.rw.id = id;
 		if (nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST) {
 			/*
@@ -489,7 +503,7 @@ static int blkif_queue_request(struct request *req)
 			}
 			ring_req->u.rw.nr_segments = nseg;
 		}
-		for_each_sg(info->shadow[id].sg, sg, nseg, i) {
+		for_each_sg(rinfo->shadow[id].sg, sg, nseg, i) {
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
 
@@ -505,22 +519,22 @@ static int blkif_queue_request(struct request *req)
 					struct page *indirect_page;
 
 					/* Fetch a pre-allocated page to use for indirect grefs */
-					BUG_ON(list_empty(&info->indirect_pages));
-					indirect_page = list_first_entry(&info->indirect_pages,
+					BUG_ON(list_empty(&rinfo->indirect_pages));
+					indirect_page = list_first_entry(&rinfo->indirect_pages,
 					                                 struct page, lru);
 					list_del(&indirect_page->lru);
 					pfn = page_to_pfn(indirect_page);
 				}
-				gnt_list_entry = get_grant(&gref_head, pfn, info);
-				info->shadow[id].indirect_grants[n] = gnt_list_entry;
+				gnt_list_entry = get_grant(&gref_head, pfn, rinfo);
+				rinfo->shadow[id].indirect_grants[n] = gnt_list_entry;
 				segments = kmap_atomic(pfn_to_page(gnt_list_entry->pfn));
 				ring_req->u.indirect.indirect_grefs[n] = gnt_list_entry->gref;
 			}
 
-			gnt_list_entry = get_grant(&gref_head, page_to_pfn(sg_page(sg)), info);
+			gnt_list_entry = get_grant(&gref_head, page_to_pfn(sg_page(sg)), rinfo);
 			ref = gnt_list_entry->gref;
 
-			info->shadow[id].grants_used[i] = gnt_list_entry;
+			rinfo->shadow[id].grants_used[i] = gnt_list_entry;
 
 			if (rq_data_dir(req) && info->feature_persistent) {
 				char *bvec_data;
@@ -566,10 +580,10 @@ static int blkif_queue_request(struct request *req)
 			kunmap_atomic(segments);
 	}
 
-	info->ring.req_prod_pvt++;
+	ring->req_prod_pvt++;
 
 	/* Keep a private copy so we can reissue requests when recovering. */
-	info->shadow[id].req = *ring_req;
+	rinfo->shadow[id].req = *ring_req;
 
 	if (new_persistent_gnts)
 		gnttab_free_grant_references(gref_head);
@@ -578,14 +592,16 @@ static int blkif_queue_request(struct request *req)
 }
 
 
-static inline void flush_requests(struct blkfront_info *info)
+static inline void flush_requests(struct blkfront_info *info,
+				  unsigned int ring_idx)
 {
+	struct blkfront_ring_info *rinfo = &info->rinfo[ring_idx];
 	int notify;
 
-	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&info->ring, notify);
+	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(&rinfo->ring, notify);
 
 	if (notify)
-		notify_remote_via_irq(info->irq);
+		notify_remote_via_irq(rinfo->irq);
 }
 
 static inline bool blkif_request_flush_mismatch(struct request *req,
@@ -612,8 +628,9 @@ static void do_blkif_request(struct request_queue *rq)
 
 	while ((req = blk_peek_request(rq)) != NULL) {
 		info = req->rq_disk->private_data;
+		BUG_ON(info->nr_rings != 1);
 
-		if (RING_FULL(&info->ring))
+		if (RING_FULL(&info->rinfo[0].ring))
 			goto wait;
 
 		blk_start_request(req);
@@ -629,7 +646,7 @@ static void do_blkif_request(struct request_queue *rq)
 			 blk_rq_cur_sectors(req), blk_rq_sectors(req),
 			 rq_data_dir(req) ? "write" : "read");
 
-		if (blkif_queue_request(req)) {
+		if (blkif_queue_request(req, 0)) {
 			blk_requeue_request(rq, req);
 wait:
 			/* Avoid pointless unplugs. */
@@ -641,23 +658,25 @@ wait:
 	}
 
 	if (queued != 0)
-		flush_requests(info);
+		flush_requests(info, 0);
 }
 
 static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 {
-	struct blkfront_info *info = req->rq_disk->private_data;
+	struct blkfront_ring_info *rinfo =
+			(struct blkfront_ring_info *)hctx->driver_data;
+	struct blkfront_info *info = rinfo->info;
 
 	pr_debug("Entered blkfront_queue_rq\n");
 
-	spin_lock_irq(&info->io_lock);
-	if (RING_FULL(&info->ring))
+	spin_lock_irq(&rinfo->io_lock);
+	if (RING_FULL(&rinfo->ring))
 		goto wait;
 
 	if (blkif_request_flush_mismatch(req, info)) {
 		req->errors = -EIO;
 		blk_mq_complete_request(req);
-		spin_unlock_irq(&info->io_lock);
+		spin_unlock_irq(&rinfo->io_lock);
 		return BLK_MQ_RQ_QUEUE_ERROR;
 	}
 
@@ -666,22 +685,27 @@ static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 			blk_rq_cur_sectors(req), blk_rq_sectors(req),
 			rq_data_dir(req) ? "write" : "read");
 
-	if (blkif_queue_request(req)) {
+	if (blkif_queue_request(req, rinfo->hctx_index)) {
 wait:
 		/* Avoid pointless unplugs. */
 		blk_mq_stop_hw_queue(hctx);
-		spin_unlock_irq(&info->io_lock);
+		spin_unlock_irq(&rinfo->io_lock);
 		return BLK_MQ_RQ_QUEUE_BUSY;
 	}
 
-	flush_requests(info);
-	spin_unlock_irq(&info->io_lock);
+	flush_requests(info, rinfo->hctx_index);
+	spin_unlock_irq(&rinfo->io_lock);
 	return BLK_MQ_RQ_QUEUE_OK;
 }
 
 static int blkfront_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 			  unsigned int index)
 {
+	struct blkfront_info *info = (struct blkfront_info *)data;
+
+	hctx->driver_data = &info->rinfo[index];
+	info->rinfo[index].hctx_index = index;
+
 	return 0;
 }
 
@@ -704,10 +728,10 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 	struct request_queue *rq;
 	struct blkfront_info *info = gd->private_data;
 
-	if (hardware_queues) {
+	if (info->hardware_queues) {
 		memset(&info->tag_set, 0, sizeof(info->tag_set));
 		info->tag_set.ops = &blkfront_mq_ops;
-		info->tag_set.nr_hw_queues = hardware_queues;
+		info->tag_set.nr_hw_queues = info->hardware_queues;
 		info->tag_set.queue_depth = BLK_RING_SIZE;
 		info->tag_set.numa_node = NUMA_NO_NODE;
 		info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
@@ -722,7 +746,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 			return -1;
 		}
 	} else {
-		rq = blk_init_queue(do_blkif_request, &info->io_lock);
+		rq = blk_init_queue(do_blkif_request, &info->rinfo[0].io_lock);
 		if (rq == NULL)
 			return -1;
 	}
@@ -945,28 +969,40 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	return err;
 }
 
+void blk_mq_free_queue(struct request_queue *q);
+
 static void xlvbd_release_gendisk(struct blkfront_info *info)
 {
 	unsigned int minor, nr_minors;
-	unsigned long flags;
+	unsigned long *flags;
+	int i;
 
 	if (info->rq == NULL)
 		return;
 
-	spin_lock_irqsave(&info->io_lock, flags);
+	flags = kzalloc(sizeof(unsigned long) * info->nr_rings,
+			GFP_KERNEL);
+	if (!flags)
+		return;
 
-	/* No more blkif_request(). */
-	if (hardware_queues)
+	/* No more blkif_request() and no more gnttab callback work. */
+	if (info->hardware_queues) {
 		blk_mq_stop_hw_queues(info->rq);
-	else
+		for (i = 0 ; i < info->nr_rings ; i++) {
+			spin_lock_irqsave(&info->rinfo[i].io_lock, flags[i]);
+			gnttab_cancel_free_callback(&info->rinfo[i].callback);
+			spin_unlock_irqrestore(&info->rinfo[i].io_lock, flags[i]);
+		}
+	} else {
+		spin_lock_irqsave(&info->rinfo[0].io_lock, flags[0]);
 		blk_stop_queue(info->rq);
-
-	/* No more gnttab callback work. */
-	gnttab_cancel_free_callback(&info->callback);
-	spin_unlock_irqrestore(&info->io_lock, flags);
+		gnttab_cancel_free_callback(&info->rinfo[0].callback);
+		spin_unlock_irqrestore(&info->rinfo[0].io_lock, flags[0]);
+	}
 
 	/* Flush gnttab callback work. Must be done with no locks held. */
-	flush_work(&info->work);
+	for (i = 0 ; i < info->nr_rings ; i++)
+		flush_work(&info->rinfo[i].work);
 
 	del_gendisk(info->gd);
 
@@ -982,12 +1018,13 @@ static void xlvbd_release_gendisk(struct blkfront_info *info)
 	info->gd = NULL;
 }
 
-static void kick_pending_request_queues(struct blkfront_info *info)
+static void kick_pending_request_queues(struct blkfront_ring_info *rinfo)
 {
-	if (!RING_FULL(&info->ring)) {
-		if (hardware_queues) {
+	if (!RING_FULL(&rinfo->ring)) {
+		struct blkfront_info *info = rinfo->info;
+		if (info->hardware_queues)
 			blk_mq_start_stopped_hw_queues(info->rq, 0);
-		} else {
+		else {
 			/* Re-enable calldowns. */
 			blk_start_queue(info->rq);
 			/* Kick things off immediately. */
@@ -998,83 +1035,42 @@ static void kick_pending_request_queues(struct blkfront_info *info)
 
 static void blkif_restart_queue(struct work_struct *work)
 {
-	struct blkfront_info *info = container_of(work, struct blkfront_info, work);
+	struct blkfront_ring_info *rinfo = container_of(work,
+				struct blkfront_ring_info, work);
+	struct blkfront_info *info = rinfo->info;
 
-	spin_lock_irq(&info->io_lock);
+	spin_lock_irq(&rinfo->io_lock);
 	if (info->connected == BLKIF_STATE_CONNECTED)
-		kick_pending_request_queues(info);
-	spin_unlock_irq(&info->io_lock);
+		kick_pending_request_queues(rinfo);
+	spin_unlock_irq(&rinfo->io_lock);
 }
 
-static void blkif_free(struct blkfront_info *info, int suspend)
+static void blkif_free_ring(struct blkfront_ring_info *rinfo,
+			    int persistent)
 {
 	struct grant *persistent_gnt;
-	struct grant *n;
 	int i, j, segs;
 
-	/* Prevent new requests being issued until we fix things up. */
-	spin_lock_irq(&info->io_lock);
-	info->connected = suspend ?
-		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
-	/* No more blkif_request(). */
-	if (info->rq) {
-		if (hardware_queues)
-			blk_mq_stop_hw_queues(info->rq);
-		else
-			blk_stop_queue(info->rq);
-	}
-
-	/* Remove all persistent grants */
-	if (!list_empty(&info->grants)) {
-		list_for_each_entry_safe(persistent_gnt, n,
-		                         &info->grants, node) {
-			list_del(&persistent_gnt->node);
-			if (persistent_gnt->gref != GRANT_INVALID_REF) {
-				gnttab_end_foreign_access(persistent_gnt->gref,
-				                          0, 0UL);
-				info->persistent_gnts_c--;
-			}
-			if (info->feature_persistent)
-				__free_page(pfn_to_page(persistent_gnt->pfn));
-			kfree(persistent_gnt);
-		}
-	}
-	BUG_ON(info->persistent_gnts_c != 0);
-
-	/*
-	 * Remove indirect pages, this only happens when using indirect
-	 * descriptors but not persistent grants
-	 */
-	if (!list_empty(&info->indirect_pages)) {
-		struct page *indirect_page, *n;
-
-		BUG_ON(info->feature_persistent);
-		list_for_each_entry_safe(indirect_page, n, &info->indirect_pages, lru) {
-			list_del(&indirect_page->lru);
-			__free_page(indirect_page);
-		}
-	}
-
 	for (i = 0; i < BLK_RING_SIZE; i++) {
 		/*
 		 * Clear persistent grants present in requests already
 		 * on the shared ring
 		 */
-		if (!info->shadow[i].request)
+		if (!rinfo->shadow[i].request)
 			goto free_shadow;
 
-		segs = info->shadow[i].req.operation == BLKIF_OP_INDIRECT ?
-		       info->shadow[i].req.u.indirect.nr_segments :
-		       info->shadow[i].req.u.rw.nr_segments;
+		segs = rinfo->shadow[i].req.operation == BLKIF_OP_INDIRECT ?
+		       rinfo->shadow[i].req.u.indirect.nr_segments :
+		       rinfo->shadow[i].req.u.rw.nr_segments;
 		for (j = 0; j < segs; j++) {
-			persistent_gnt = info->shadow[i].grants_used[j];
+			persistent_gnt = rinfo->shadow[i].grants_used[j];
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
-			if (info->feature_persistent)
+			if (persistent)
 				__free_page(pfn_to_page(persistent_gnt->pfn));
 			kfree(persistent_gnt);
 		}
 
-		if (info->shadow[i].req.operation != BLKIF_OP_INDIRECT)
+		if (rinfo->shadow[i].req.operation != BLKIF_OP_INDIRECT)
 			/*
 			 * If this is not an indirect operation don't try to
 			 * free indirect segments
@@ -1082,44 +1078,105 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 			goto free_shadow;
 
 		for (j = 0; j < INDIRECT_GREFS(segs); j++) {
-			persistent_gnt = info->shadow[i].indirect_grants[j];
+			persistent_gnt = rinfo->shadow[i].indirect_grants[j];
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
 			__free_page(pfn_to_page(persistent_gnt->pfn));
 			kfree(persistent_gnt);
 		}
 
 free_shadow:
-		kfree(info->shadow[i].grants_used);
-		info->shadow[i].grants_used = NULL;
-		kfree(info->shadow[i].indirect_grants);
-		info->shadow[i].indirect_grants = NULL;
-		kfree(info->shadow[i].sg);
-		info->shadow[i].sg = NULL;
+		kfree(rinfo->shadow[i].grants_used);
+		rinfo->shadow[i].grants_used = NULL;
+		kfree(rinfo->shadow[i].indirect_grants);
+		rinfo->shadow[i].indirect_grants = NULL;
+		kfree(rinfo->shadow[i].sg);
+		rinfo->shadow[i].sg = NULL;
 	}
 
-	/* No more gnttab callback work. */
-	gnttab_cancel_free_callback(&info->callback);
-	spin_unlock_irq(&info->io_lock);
+	/* Free resources associated with old device channel. */
+	if (rinfo->ring_ref != GRANT_INVALID_REF) {
+		gnttab_end_foreign_access(rinfo->ring_ref, 0,
+					  (unsigned long)rinfo->ring.sring);
+		rinfo->ring_ref = GRANT_INVALID_REF;
+		rinfo->ring.sring = NULL;
+	}
+	if (rinfo->irq)
+		unbind_from_irqhandler(rinfo->irq, rinfo);
+	rinfo->evtchn = rinfo->irq = 0;
 
-	/* Flush gnttab callback work. Must be done with no locks held. */
-	flush_work(&info->work);
+}
 
-	/* Free resources associated with old device channel. */
-	if (info->ring_ref != GRANT_INVALID_REF) {
-		gnttab_end_foreign_access(info->ring_ref, 0,
-					  (unsigned long)info->ring.sring);
-		info->ring_ref = GRANT_INVALID_REF;
-		info->ring.sring = NULL;
+static void blkif_free(struct blkfront_info *info, int suspend)
+{
+	struct grant *persistent_gnt;
+	struct grant *n;
+	int i;
+
+	info->connected = suspend ?
+		BLKIF_STATE_SUSPENDED : BLKIF_STATE_DISCONNECTED;
+
+	/* Prevent new requests being issued until we fix things up. */
+	/* No more blkif_request() and no more gnttab callback work. */
+	if (!info->hardware_queues && info->rq) {
+		spin_lock_irq(&info->rinfo[0].io_lock);
+		blk_stop_queue(info->rq);
+		gnttab_cancel_free_callback(&info->rinfo[0].callback);
+		spin_unlock_irq(&info->rinfo[0].io_lock);
+	} else {
+		blk_mq_stop_hw_queues(info->rq);
+
+		for (i = 0 ; i < info->nr_rings ; i++) {
+			struct blkfront_ring_info *rinfo = &info->rinfo[i];
+
+			spin_lock_irq(&info->rinfo[i].io_lock);
+			/* Remove all persistent grants */
+			if (!list_empty(&rinfo->grants)) {
+				list_for_each_entry_safe(persistent_gnt, n,
+				                         &rinfo->grants, node) {
+					list_del(&persistent_gnt->node);
+					if (persistent_gnt->gref != GRANT_INVALID_REF) {
+						gnttab_end_foreign_access(persistent_gnt->gref,
+						                          0, 0UL);
+						rinfo->persistent_gnts_c--;
+					}
+					if (info->feature_persistent)
+						__free_page(pfn_to_page(persistent_gnt->pfn));
+					kfree(persistent_gnt);
+				}
+			}
+			BUG_ON(rinfo->persistent_gnts_c != 0);
+
+			/*
+			 * Remove indirect pages, this only happens when using indirect
+			 * descriptors but not persistent grants
+			 */
+			if (!list_empty(&rinfo->indirect_pages)) {
+				struct page *indirect_page, *n;
+
+				BUG_ON(info->feature_persistent);
+				list_for_each_entry_safe(indirect_page, n, &rinfo->indirect_pages, lru) {
+					list_del(&indirect_page->lru);
+					__free_page(indirect_page);
+				}
+			}
+
+			blkif_free_ring(&info->rinfo[i], info->feature_persistent);
+		}
+
+		gnttab_cancel_free_callback(&info->rinfo[i].callback);
+		spin_unlock_irq(&info->rinfo[i].io_lock);
 	}
-	if (info->irq)
-		unbind_from_irqhandler(info->irq, info);
-	info->evtchn = info->irq = 0;
 
+	/* Flush gnttab callback work. Must be done with no locks held. */
+	for (i = 0 ; i < info->nr_rings ; i++)
+		flush_work(&info->rinfo[i].work);
 }
 
-static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
+static void blkif_completion(struct blk_shadow *s,
+			     struct blkfront_ring_info *rinfo,
 			     struct blkif_response *bret)
 {
+	struct blkfront_info *info = rinfo->info;
 	int i = 0;
 	struct scatterlist *sg;
 	char *bvec_data;
@@ -1160,8 +1217,8 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			if (!info->feature_persistent)
 				pr_alert_ratelimited("backed has not unmapped grant: %u\n",
 						     s->grants_used[i]->gref);
-			list_add(&s->grants_used[i]->node, &info->grants);
-			info->persistent_gnts_c++;
+			list_add(&s->grants_used[i]->node, &rinfo->grants);
+			rinfo->persistent_gnts_c++;
 		} else {
 			/*
 			 * If the grant is not mapped by the backend we end the
@@ -1171,7 +1228,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			 */
 			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
 			s->grants_used[i]->gref = GRANT_INVALID_REF;
-			list_add_tail(&s->grants_used[i]->node, &info->grants);
+			list_add_tail(&s->grants_used[i]->node, &rinfo->grants);
 		}
 	}
 	if (s->req.operation == BLKIF_OP_INDIRECT) {
@@ -1180,8 +1237,8 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 				if (!info->feature_persistent)
 					pr_alert_ratelimited("backed has not unmapped grant: %u\n",
 							     s->indirect_grants[i]->gref);
-				list_add(&s->indirect_grants[i]->node, &info->grants);
-				info->persistent_gnts_c++;
+				list_add(&s->indirect_grants[i]->node, &rinfo->grants);
+				rinfo->persistent_gnts_c++;
 			} else {
 				struct page *indirect_page;
 
@@ -1191,9 +1248,9 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 				 * available pages for indirect grefs.
 				 */
 				indirect_page = pfn_to_page(s->indirect_grants[i]->pfn);
-				list_add(&indirect_page->lru, &info->indirect_pages);
+				list_add(&indirect_page->lru, &rinfo->indirect_pages);
 				s->indirect_grants[i]->gref = GRANT_INVALID_REF;
-				list_add_tail(&s->indirect_grants[i]->node, &info->grants);
+				list_add_tail(&s->indirect_grants[i]->node, &rinfo->grants);
 			}
 		}
 	}
@@ -1205,24 +1262,25 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 	struct blkif_response *bret;
 	RING_IDX i, rp;
 	unsigned long flags;
-	struct blkfront_info *info = (struct blkfront_info *)dev_id;
+	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
+	struct blkfront_info *info = rinfo->info;
 	int error;
 
-	spin_lock_irqsave(&info->io_lock, flags);
+	spin_lock_irqsave(&rinfo->io_lock, flags);
 
 	if (unlikely(info->connected != BLKIF_STATE_CONNECTED)) {
-		spin_unlock_irqrestore(&info->io_lock, flags);
+		spin_unlock_irqrestore(&rinfo->io_lock, flags);
 		return IRQ_HANDLED;
 	}
 
  again:
-	rp = info->ring.sring->rsp_prod;
+	rp = rinfo->ring.sring->rsp_prod;
 	rmb(); /* Ensure we see queued responses up to 'rp'. */
 
-	for (i = info->ring.rsp_cons; i != rp; i++) {
+	for (i = rinfo->ring.rsp_cons; i != rp; i++) {
 		unsigned long id;
 
-		bret = RING_GET_RESPONSE(&info->ring, i);
+		bret = RING_GET_RESPONSE(&rinfo->ring, i);
 		id   = bret->id;
 		/*
 		 * The backend has messed up and given us an id that we would
@@ -1236,12 +1294,12 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 			 * the id is busted. */
 			continue;
 		}
-		req  = info->shadow[id].request;
+		req  = rinfo->shadow[id].request;
 
 		if (bret->operation != BLKIF_OP_DISCARD)
-			blkif_completion(&info->shadow[id], info, bret);
+			blkif_completion(&rinfo->shadow[id], rinfo, bret);
 
-		if (add_id_to_freelist(info, id)) {
+		if (add_id_to_freelist(rinfo, id)) {
 			WARN(1, "%s: response to %s (id %ld) couldn't be recycled!\n",
 			     info->gd->disk_name, op_name(bret->operation), id);
 			continue;
@@ -1260,7 +1318,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				queue_flag_clear(QUEUE_FLAG_DISCARD, rq);
 				queue_flag_clear(QUEUE_FLAG_SECDISCARD, rq);
 			}
-			if (hardware_queues)
+			if (info->hardware_queues)
 				blk_mq_complete_request(req);
 			else
 				__blk_end_request_all(req, error);
@@ -1273,7 +1331,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				error = req->errors = -EOPNOTSUPP;
 			}
 			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
-				     info->shadow[id].req.u.rw.nr_segments == 0)) {
+				     rinfo->shadow[id].req.u.rw.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
 				       info->gd->disk_name, op_name(bret->operation));
 				error = req->errors = -EOPNOTSUPP;
@@ -1292,7 +1350,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			if (hardware_queues)
+			if (info->hardware_queues)
 				blk_mq_complete_request(req);
 			else
 				__blk_end_request_all(req, error);
@@ -1302,31 +1360,31 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 		}
 	}
 
-	info->ring.rsp_cons = i;
+	rinfo->ring.rsp_cons = i;
 
-	if (i != info->ring.req_prod_pvt) {
+	if (i != rinfo->ring.req_prod_pvt) {
 		int more_to_do;
-		RING_FINAL_CHECK_FOR_RESPONSES(&info->ring, more_to_do);
+		RING_FINAL_CHECK_FOR_RESPONSES(&rinfo->ring, more_to_do);
 		if (more_to_do)
 			goto again;
 	} else
-		info->ring.sring->rsp_event = i + 1;
+		rinfo->ring.sring->rsp_event = i + 1;
 
-	kick_pending_request_queues(info);
+	kick_pending_request_queues(rinfo);
 
-	spin_unlock_irqrestore(&info->io_lock, flags);
+	spin_unlock_irqrestore(&rinfo->io_lock, flags);
 
 	return IRQ_HANDLED;
 }
 
 
 static int setup_blkring(struct xenbus_device *dev,
-			 struct blkfront_info *info)
+			 struct blkfront_ring_info *rinfo)
 {
 	struct blkif_sring *sring;
 	int err;
 
-	info->ring_ref = GRANT_INVALID_REF;
+	rinfo->ring_ref = GRANT_INVALID_REF;
 
 	sring = (struct blkif_sring *)__get_free_page(GFP_NOIO | __GFP_HIGH);
 	if (!sring) {
@@ -1334,32 +1392,32 @@ static int setup_blkring(struct xenbus_device *dev,
 		return -ENOMEM;
 	}
 	SHARED_RING_INIT(sring);
-	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
+	FRONT_RING_INIT(&rinfo->ring, sring, PAGE_SIZE);
 
-	err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
+	err = xenbus_grant_ring(dev, virt_to_mfn(rinfo->ring.sring));
 	if (err < 0) {
 		free_page((unsigned long)sring);
-		info->ring.sring = NULL;
+		rinfo->ring.sring = NULL;
 		goto fail;
 	}
-	info->ring_ref = err;
+	rinfo->ring_ref = err;
 
-	err = xenbus_alloc_evtchn(dev, &info->evtchn);
+	err = xenbus_alloc_evtchn(dev, &rinfo->evtchn);
 	if (err)
 		goto fail;
 
-	err = bind_evtchn_to_irqhandler(info->evtchn, blkif_interrupt, 0,
-					"blkif", info);
+	err = bind_evtchn_to_irqhandler(rinfo->evtchn, blkif_interrupt, 0,
+					"blkif", rinfo);
 	if (err <= 0) {
 		xenbus_dev_fatal(dev, err,
 				 "bind_evtchn_to_irqhandler failed");
 		goto fail;
 	}
-	info->irq = err;
+	rinfo->irq = err;
 
 	return 0;
 fail:
-	blkif_free(info, 0);
+	blkif_free(rinfo->info, 0);
 	return err;
 }
 
@@ -1369,13 +1427,16 @@ static int talk_to_blkback(struct xenbus_device *dev,
 			   struct blkfront_info *info)
 {
 	const char *message = NULL;
+	char ring_ref_s[64] = "", evtchn_s[64] = "";
 	struct xenbus_transaction xbt;
-	int err;
+	int i, err;
 
-	/* Create shared ring, alloc event channel. */
-	err = setup_blkring(dev, info);
-	if (err)
-		goto out;
+	for (i = 0 ; i < info->nr_rings ; i++) {
+		/* Create shared ring, alloc event channel. */
+		err = setup_blkring(dev, &info->rinfo[i]);
+		if (err)
+			goto out;
+	}
 
 again:
 	err = xenbus_transaction_start(&xbt);
@@ -1384,18 +1445,30 @@ again:
 		goto destroy_blkring;
 	}
 
-	err = xenbus_printf(xbt, dev->nodename,
-			    "ring-ref", "%u", info->ring_ref);
-	if (err) {
-		message = "writing ring-ref";
-		goto abort_transaction;
-	}
-	err = xenbus_printf(xbt, dev->nodename,
-			    "event-channel", "%u", info->evtchn);
-	if (err) {
-		message = "writing event-channel";
-		goto abort_transaction;
+	for (i = 0 ; i < info->nr_rings ; i++) {
+		if (!info->hardware_queues) {
+			BUG_ON(i > 0);
+			/* Support old XenStore keys */
+			snprintf(ring_ref_s, 64, "ring-ref");
+			snprintf(evtchn_s, 64, "event-channel");
+		} else {
+			snprintf(ring_ref_s, 64, "ring-ref-%d", i);
+			snprintf(evtchn_s, 64, "event-channel-%d", i);
+		}
+		err = xenbus_printf(xbt, dev->nodename,
+				    ring_ref_s, "%u", info->rinfo[i].ring_ref);
+		if (err) {
+			message = "writing ring-ref";
+			goto abort_transaction;
+		}
+		err = xenbus_printf(xbt, dev->nodename,
+				    evtchn_s, "%u", info->rinfo[i].evtchn);
+		if (err) {
+			message = "writing event-channel";
+			goto abort_transaction;
+		}
 	}
+
 	err = xenbus_printf(xbt, dev->nodename, "protocol", "%s",
 			    XEN_IO_PROTO_ABI_NATIVE);
 	if (err) {
@@ -1439,8 +1512,9 @@ again:
 static int blkfront_probe(struct xenbus_device *dev,
 			  const struct xenbus_device_id *id)
 {
-	int err, vdevice, i;
+	int err, vdevice, i, r;
 	struct blkfront_info *info;
+	unsigned int nr_queues;
 
 	/* FIXME: Use dynamic device id if this is not set. */
 	err = xenbus_scanf(XBT_NIL, dev->nodename,
@@ -1491,23 +1565,47 @@ static int blkfront_probe(struct xenbus_device *dev,
 	}
 
 	mutex_init(&info->mutex);
-	spin_lock_init(&info->io_lock);
 	info->xbdev = dev;
 	info->vdevice = vdevice;
-	INIT_LIST_HEAD(&info->grants);
-	INIT_LIST_HEAD(&info->indirect_pages);
-	info->persistent_gnts_c = 0;
 	info->connected = BLKIF_STATE_DISCONNECTED;
-	INIT_WORK(&info->work, blkif_restart_queue);
-
-	for (i = 0; i < BLK_RING_SIZE; i++)
-		info->shadow[i].req.u.rw.id = i+1;
-	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
 
 	/* Front end dir is a number, which is used as the id. */
 	info->handle = simple_strtoul(strrchr(dev->nodename, '/')+1, NULL, 0);
 	dev_set_drvdata(&dev->dev, info);
 
+	/* Gather the number of hardware queues as soon as possible */
+	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+			    "nr_supported_hw_queues", "%u", &nr_queues,
+			    NULL);
+	if (err)
+		info->hardware_queues = 0;
+	else
+		info->hardware_queues = nr_queues;
+	/*
+	 * The backend has told us the number of hw queues he wants.
+	 * Allocate the correct number of rings.
+	 */
+	info->nr_rings = info->hardware_queues ? : 1;
+	pr_info("blkfront: %d hardware queues, %d rings\n",
+		info->hardware_queues, info->nr_rings);
+
+	info->rinfo = kzalloc(info->nr_rings *
+				sizeof(struct blkfront_ring_info),
+			      GFP_KERNEL);
+	for (r = 0 ; r < info->nr_rings ; r++) {
+		struct blkfront_ring_info *rinfo = &info->rinfo[r];
+
+		rinfo->info = info;
+		rinfo->persistent_gnts_c = 0;
+		INIT_LIST_HEAD(&rinfo->grants);
+		INIT_LIST_HEAD(&rinfo->indirect_pages);
+		INIT_WORK(&rinfo->work, blkif_restart_queue);
+		spin_lock_init(&rinfo->io_lock);
+		for (i = 0; i < BLK_RING_SIZE; i++)
+			rinfo->shadow[i].req.u.rw.id = i+1;
+		rinfo->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
+	}
+
 	err = talk_to_blkback(dev, info);
 	if (err) {
 		kfree(info);
@@ -1533,107 +1631,126 @@ static void split_bio_end(struct bio *bio, int error)
 	bio_put(bio);
 }
 
-static int blkif_recover(struct blkfront_info *info)
+static int blkif_setup_shadow(struct blkfront_ring_info *rinfo,
+			      struct blk_shadow **copy)
 {
 	int i;
+
+	/* Stage 1: Make a safe copy of the shadow state. */
+	*copy = kmemdup(rinfo->shadow, sizeof(rinfo->shadow),
+		       GFP_NOIO | __GFP_REPEAT | __GFP_HIGH);
+	if (!*copy)
+		return -ENOMEM;
+
+	/* Stage 2: Set up free list. */
+	memset(&rinfo->shadow, 0, sizeof(rinfo->shadow));
+	for (i = 0; i < BLK_RING_SIZE; i++)
+		rinfo->shadow[i].req.u.rw.id = i+1;
+	rinfo->shadow_free = rinfo->ring.req_prod_pvt;
+	rinfo->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
+
+	return 0;
+}
+
+static int blkif_recover(struct blkfront_info *info)
+{
+	int i, r;
 	struct request *req, *n;
 	struct blk_shadow *copy;
-	int rc;
+	int rc = 0;
 	struct bio *bio, *cloned_bio;
-	struct bio_list bio_list, merge_bio;
+	struct bio_list uninitialized_var(bio_list), merge_bio;
 	unsigned int segs, offset;
 	int pending, size;
 	struct split_bio *split_bio;
 	struct list_head requests;
 
-	/* Stage 1: Make a safe copy of the shadow state. */
-	copy = kmemdup(info->shadow, sizeof(info->shadow),
-		       GFP_NOIO | __GFP_REPEAT | __GFP_HIGH);
-	if (!copy)
-		return -ENOMEM;
+	segs = blkfront_gather_indirect(info);
 
-	/* Stage 2: Set up free list. */
-	memset(&info->shadow, 0, sizeof(info->shadow));
-	for (i = 0; i < BLK_RING_SIZE; i++)
-		info->shadow[i].req.u.rw.id = i+1;
-	info->shadow_free = info->ring.req_prod_pvt;
-	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
+	for (r = 0 ; r < info->nr_rings ; i++) {
+		rc |= blkif_setup_shadow(&info->rinfo[i], &copy);
 
-	rc = blkfront_setup_indirect(info);
-	if (rc) {
-		kfree(copy);
-		return rc;
-	}
+		rc |= blkfront_setup_indirect(&info->rinfo[i], segs);
+		if (rc) {
+			kfree(copy);
+			return rc;
+		}
 
-	segs = info->max_indirect_segments ? : BLKIF_MAX_SEGMENTS_PER_REQUEST;
-	blk_queue_max_segments(info->rq, segs);
-	bio_list_init(&bio_list);
-	INIT_LIST_HEAD(&requests);
-	for (i = 0; i < BLK_RING_SIZE; i++) {
-		/* Not in use? */
-		if (!copy[i].request)
-			continue;
+		segs = info->max_indirect_segments ? : BLKIF_MAX_SEGMENTS_PER_REQUEST;
+		blk_queue_max_segments(info->rq, segs);
+		bio_list_init(&bio_list);
+		INIT_LIST_HEAD(&requests);
+		for (i = 0; i < BLK_RING_SIZE; i++) {
+			/* Not in use? */
+			if (!copy[i].request)
+				continue;
 
-		/*
-		 * Get the bios in the request so we can re-queue them.
-		 */
-		if (copy[i].request->cmd_flags &
-		    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
 			/*
-			 * Flush operations don't contain bios, so
-			 * we need to requeue the whole request
+			 * Get the bios in the request so we can re-queue them.
 			 */
-			list_add(&copy[i].request->queuelist, &requests);
-			continue;
+			if (copy[i].request->cmd_flags &
+			    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
+				/*
+				 * Flush operations don't contain bios, so
+				 * we need to requeue the whole request
+				 */
+				list_add(&copy[i].request->queuelist, &requests);
+				continue;
+			}
+			merge_bio.head = copy[i].request->bio;
+			merge_bio.tail = copy[i].request->biotail;
+			bio_list_merge(&bio_list, &merge_bio);
+			copy[i].request->bio = NULL;
+			blk_put_request(copy[i].request);
 		}
-		merge_bio.head = copy[i].request->bio;
-		merge_bio.tail = copy[i].request->biotail;
-		bio_list_merge(&bio_list, &merge_bio);
-		copy[i].request->bio = NULL;
-		blk_put_request(copy[i].request);
-	}
 
-	kfree(copy);
+		kfree(copy);
+	}
 
 	/*
-	 * Empty the queue, this is important because we might have
-	 * requests in the queue with more segments than what we
-	 * can handle now.
+	 * If we are using the request interface, empty the queue,
+	 * this is important because we might have requests in the
+	 * queue with more segments than what we can handle now.
 	 */
-	spin_lock_irq(&info->io_lock);
-	while ((req = blk_fetch_request(info->rq)) != NULL) {
-		if (req->cmd_flags &
-		    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
-			list_add(&req->queuelist, &requests);
-			continue;
+	if (!info->hardware_queues) {
+		spin_lock_irq(&info->rinfo[0].io_lock);
+		while ((req = blk_fetch_request(info->rq)) != NULL) {
+			if (req->cmd_flags &
+			    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
+				list_add(&req->queuelist, &requests);
+				continue;
+			}
+			merge_bio.head = req->bio;
+			merge_bio.tail = req->biotail;
+			bio_list_merge(&bio_list, &merge_bio);
+			req->bio = NULL;
+			if (req->cmd_flags & (REQ_FLUSH | REQ_FUA))
+				pr_alert("diskcache flush request found!\n");
+			__blk_put_request(info->rq, req);
 		}
-		merge_bio.head = req->bio;
-		merge_bio.tail = req->biotail;
-		bio_list_merge(&bio_list, &merge_bio);
-		req->bio = NULL;
-		if (req->cmd_flags & (REQ_FLUSH | REQ_FUA))
-			pr_alert("diskcache flush request found!\n");
-		__blk_put_request(info->rq, req);
+		spin_unlock_irq(&info->rinfo[0].io_lock);
 	}
-	spin_unlock_irq(&info->io_lock);
 
 	xenbus_switch_state(info->xbdev, XenbusStateConnected);
 
-	spin_lock_irq(&info->io_lock);
-
 	/* Now safe for us to use the shared ring */
 	info->connected = BLKIF_STATE_CONNECTED;
 
-	/* Kick any other new requests queued since we resumed */
-	kick_pending_request_queues(info);
+	for (i = 0 ; i < info->nr_rings ; i++) {
+		spin_lock_irq(&info->rinfo[i].io_lock);
+
+		/* Kick any other new requests queued since we resumed */
+		kick_pending_request_queues(&info->rinfo[i]);
+
+		list_for_each_entry_safe(req, n, &requests, queuelist) {
+			/* Requeue pending requests (flush or discard) */
+			list_del_init(&req->queuelist);
+			BUG_ON(req->nr_phys_segments > segs);
+			blk_requeue_request(info->rq, req);
+		}
 
-	list_for_each_entry_safe(req, n, &requests, queuelist) {
-		/* Requeue pending requests (flush or discard) */
-		list_del_init(&req->queuelist);
-		BUG_ON(req->nr_phys_segments > segs);
-		blk_requeue_request(info->rq, req);
+		spin_unlock_irq(&info->rinfo[i].io_lock);
 	}
-	spin_unlock_irq(&info->io_lock);
 
 	while ((bio = bio_list_pop(&bio_list)) != NULL) {
 		/* Traverse the list of pending bios and re-queue them */
@@ -1758,14 +1875,15 @@ static void blkfront_setup_discard(struct blkfront_info *info)
 		info->feature_secdiscard = !!discard_secure;
 }
 
-static int blkfront_setup_indirect(struct blkfront_info *info)
+
+static int blkfront_gather_indirect(struct blkfront_info *info)
 {
 	unsigned int indirect_segments, segs;
-	int err, i;
+	int err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+				"feature-max-indirect-segments", "%u",
+				&indirect_segments,
+				NULL);
 
-	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
-			    "feature-max-indirect-segments", "%u", &indirect_segments,
-			    NULL);
 	if (err) {
 		info->max_indirect_segments = 0;
 		segs = BLKIF_MAX_SEGMENTS_PER_REQUEST;
@@ -1775,7 +1893,16 @@ static int blkfront_setup_indirect(struct blkfront_info *info)
 		segs = info->max_indirect_segments;
 	}
 
-	err = fill_grant_buffer(info, (segs + INDIRECT_GREFS(segs)) * BLK_RING_SIZE);
+	return segs;
+}
+
+static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo,
+				   unsigned int segs)
+{
+	struct blkfront_info *info = rinfo->info;
+	int err, i;
+
+	err = fill_grant_buffer(rinfo, (segs + INDIRECT_GREFS(segs)) * BLK_RING_SIZE);
 	if (err)
 		goto out_of_memory;
 
@@ -1787,31 +1914,31 @@ static int blkfront_setup_indirect(struct blkfront_info *info)
 		 */
 		int num = INDIRECT_GREFS(segs) * BLK_RING_SIZE;
 
-		BUG_ON(!list_empty(&info->indirect_pages));
+		BUG_ON(!list_empty(&rinfo->indirect_pages));
 		for (i = 0; i < num; i++) {
 			struct page *indirect_page = alloc_page(GFP_NOIO);
 			if (!indirect_page)
 				goto out_of_memory;
-			list_add(&indirect_page->lru, &info->indirect_pages);
+			list_add(&indirect_page->lru, &rinfo->indirect_pages);
 		}
 	}
 
 	for (i = 0; i < BLK_RING_SIZE; i++) {
-		info->shadow[i].grants_used = kzalloc(
-			sizeof(info->shadow[i].grants_used[0]) * segs,
+		rinfo->shadow[i].grants_used = kzalloc(
+			sizeof(rinfo->shadow[i].grants_used[0]) * segs,
 			GFP_NOIO);
-		info->shadow[i].sg = kzalloc(sizeof(info->shadow[i].sg[0]) * segs, GFP_NOIO);
+		rinfo->shadow[i].sg = kzalloc(sizeof(rinfo->shadow[i].sg[0]) * segs, GFP_NOIO);
 		if (info->max_indirect_segments)
-			info->shadow[i].indirect_grants = kzalloc(
-				sizeof(info->shadow[i].indirect_grants[0]) *
+			rinfo->shadow[i].indirect_grants = kzalloc(
+				sizeof(rinfo->shadow[i].indirect_grants[0]) *
 				INDIRECT_GREFS(segs),
 				GFP_NOIO);
-		if ((info->shadow[i].grants_used == NULL) ||
-			(info->shadow[i].sg == NULL) ||
+		if ((rinfo->shadow[i].grants_used == NULL) ||
+			(rinfo->shadow[i].sg == NULL) ||
 		     (info->max_indirect_segments &&
-		     (info->shadow[i].indirect_grants == NULL)))
+		     (rinfo->shadow[i].indirect_grants == NULL)))
 			goto out_of_memory;
-		sg_init_table(info->shadow[i].sg, segs);
+		sg_init_table(rinfo->shadow[i].sg, segs);
 	}
 
 
@@ -1819,16 +1946,16 @@ static int blkfront_setup_indirect(struct blkfront_info *info)
 
 out_of_memory:
 	for (i = 0; i < BLK_RING_SIZE; i++) {
-		kfree(info->shadow[i].grants_used);
-		info->shadow[i].grants_used = NULL;
-		kfree(info->shadow[i].sg);
-		info->shadow[i].sg = NULL;
-		kfree(info->shadow[i].indirect_grants);
-		info->shadow[i].indirect_grants = NULL;
-	}
-	if (!list_empty(&info->indirect_pages)) {
+		kfree(rinfo->shadow[i].grants_used);
+		rinfo->shadow[i].grants_used = NULL;
+		kfree(rinfo->shadow[i].sg);
+		rinfo->shadow[i].sg = NULL;
+		kfree(rinfo->shadow[i].indirect_grants);
+		rinfo->shadow[i].indirect_grants = NULL;
+	}
+	if (!list_empty(&rinfo->indirect_pages)) {
 		struct page *indirect_page, *n;
-		list_for_each_entry_safe(indirect_page, n, &info->indirect_pages, lru) {
+		list_for_each_entry_safe(indirect_page, n, &rinfo->indirect_pages, lru) {
 			list_del(&indirect_page->lru);
 			__free_page(indirect_page);
 		}
@@ -1846,7 +1973,8 @@ static void blkfront_connect(struct blkfront_info *info)
 	unsigned long sector_size;
 	unsigned int physical_sector_size;
 	unsigned int binfo;
-	int err;
+	unsigned int segs;
+	int i, err;
 	int barrier, flush, discard, persistent;
 
 	switch (info->connected) {
@@ -1950,11 +2078,14 @@ static void blkfront_connect(struct blkfront_info *info)
 	else
 		info->feature_persistent = persistent;
 
-	err = blkfront_setup_indirect(info);
-	if (err) {
-		xenbus_dev_fatal(info->xbdev, err, "setup_indirect at %s",
-				 info->xbdev->otherend);
-		return;
+	segs = blkfront_gather_indirect(info);
+	for (i = 0 ; i < info->nr_rings ; i++) {
+		err = blkfront_setup_indirect(&info->rinfo[i], segs);
+		if (err) {
+			xenbus_dev_fatal(info->xbdev, err, "setup_indirect at %s",
+					 info->xbdev->otherend);
+			return;
+		}
 	}
 
 	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size,
@@ -1967,11 +2098,13 @@ static void blkfront_connect(struct blkfront_info *info)
 
 	xenbus_switch_state(info->xbdev, XenbusStateConnected);
 
-	/* Kick pending requests. */
-	spin_lock_irq(&info->io_lock);
 	info->connected = BLKIF_STATE_CONNECTED;
-	kick_pending_request_queues(info);
-	spin_unlock_irq(&info->io_lock);
+	/* Kick pending requests. */
+	for (i = 0 ; i < info->nr_rings ; i++) {
+		spin_lock_irq(&info->rinfo[i].io_lock);
+		kick_pending_request_queues(&info->rinfo[i]);
+		spin_unlock_irq(&info->rinfo[i].io_lock);
+	}
 
 	add_disk(info->gd);
 
-- 
2.0.4

