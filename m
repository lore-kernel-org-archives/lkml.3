Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3KAQpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:45:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56806 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3KAQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:45:50 -0400
Date: Fri, 1 Nov 2013 09:45:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Asias He <asias@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_blk: blk-mq support
Message-ID: <20131101164548.GA28640@infradead.org>
References: <20131025130459.730903511@bombadil.infradead.org>
 <20131025130735.637242058@bombadil.infradead.org>
 <87ob6aglgl.fsf@rustcorp.com.au>
 <20131028085206.GB31270@infradead.org>
 <527029C9.2030102@kernel.dk>
 <20131030085124.GA30084@hj.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030085124.GA30084@hj.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated version to address Asias' comments and rebased ontop of
block/for-next with the immutable bio changes:

---

From: Jens Axboe <axboe@kernel.dk>
Subject: virtio_blk: blk-mq support
    
Switch virtio-blk from the dual support for old-style requests and bios
to use the block-multiqueue.
    
Acked-by: Asias He <asias@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 93fde08..7455fe2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -11,12 +11,11 @@
 #include <linux/string_helpers.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/idr.h>
+#include <linux/blk-mq.h>
+#include <linux/numa.h>
 
 #define PART_BITS 4
 
-static bool use_bio;
-module_param(use_bio, bool, S_IRUGO);
-
 static int major;
 static DEFINE_IDA(vd_index_ida);
 
@@ -26,13 +25,11 @@ struct virtio_blk
 {
 	struct virtio_device *vdev;
 	struct virtqueue *vq;
-	wait_queue_head_t queue_wait;
+	spinlock_t vq_lock;
 
 	/* The disk structure for the kernel. */
 	struct gendisk *disk;
 
-	mempool_t *pool;
-
 	/* Process context for config space updates */
 	struct work_struct config_work;
 
@@ -47,31 +44,17 @@ struct virtio_blk
 
 	/* Ida index - used to track minor number allocations. */
 	int index;
-
-	/* Scatterlist: can be too big for stack. */
-	struct scatterlist sg[/*sg_elems*/];
 };
 
 struct virtblk_req
 {
 	struct request *req;
-	struct bio *bio;
 	struct virtio_blk_outhdr out_hdr;
 	struct virtio_scsi_inhdr in_hdr;
-	struct work_struct work;
-	struct virtio_blk *vblk;
-	int flags;
 	u8 status;
 	struct scatterlist sg[];
 };
 
-enum {
-	VBLK_IS_FLUSH		= 1,
-	VBLK_REQ_FLUSH		= 2,
-	VBLK_REQ_DATA		= 4,
-	VBLK_REQ_FUA		= 8,
-};
-
 static inline int virtblk_result(struct virtblk_req *vbr)
 {
 	switch (vbr->status) {
@@ -84,22 +67,6 @@ static inline int virtblk_result(struct virtblk_req *vbr)
 	}
 }
 
-static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
-						    gfp_t gfp_mask)
-{
-	struct virtblk_req *vbr;
-
-	vbr = mempool_alloc(vblk->pool, gfp_mask);
-	if (!vbr)
-		return NULL;
-
-	vbr->vblk = vblk;
-	if (use_bio)
-		sg_init_table(vbr->sg, vblk->sg_elems);
-
-	return vbr;
-}
-
 static int __virtblk_add_req(struct virtqueue *vq,
 			     struct virtblk_req *vbr,
 			     struct scatterlist *data_sg,
@@ -143,83 +110,8 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
 }
 
-static void virtblk_add_req(struct virtblk_req *vbr, bool have_data)
-{
-	struct virtio_blk *vblk = vbr->vblk;
-	DEFINE_WAIT(wait);
-	int ret;
-
-	spin_lock_irq(vblk->disk->queue->queue_lock);
-	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr, vbr->sg,
-						 have_data)) < 0)) {
-		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
-					  TASK_UNINTERRUPTIBLE);
-
-		spin_unlock_irq(vblk->disk->queue->queue_lock);
-		io_schedule();
-		spin_lock_irq(vblk->disk->queue->queue_lock);
-
-		finish_wait(&vblk->queue_wait, &wait);
-	}
-
-	virtqueue_kick(vblk->vq);
-	spin_unlock_irq(vblk->disk->queue->queue_lock);
-}
-
-static void virtblk_bio_send_flush(struct virtblk_req *vbr)
-{
-	vbr->flags |= VBLK_IS_FLUSH;
-	vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
-	vbr->out_hdr.sector = 0;
-	vbr->out_hdr.ioprio = 0;
-
-	virtblk_add_req(vbr, false);
-}
-
-static void virtblk_bio_send_data(struct virtblk_req *vbr)
-{
-	struct virtio_blk *vblk = vbr->vblk;
-	struct bio *bio = vbr->bio;
-	bool have_data;
-
-	vbr->flags &= ~VBLK_IS_FLUSH;
-	vbr->out_hdr.type = 0;
-	vbr->out_hdr.sector = bio->bi_iter.bi_sector;
-	vbr->out_hdr.ioprio = bio_prio(bio);
-
-	if (blk_bio_map_sg(vblk->disk->queue, bio, vbr->sg)) {
-		have_data = true;
-		if (bio->bi_rw & REQ_WRITE)
-			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
-		else
-			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
-	} else
-		have_data = false;
-
-	virtblk_add_req(vbr, have_data);
-}
-
-static void virtblk_bio_send_data_work(struct work_struct *work)
-{
-	struct virtblk_req *vbr;
-
-	vbr = container_of(work, struct virtblk_req, work);
-
-	virtblk_bio_send_data(vbr);
-}
-
-static void virtblk_bio_send_flush_work(struct work_struct *work)
-{
-	struct virtblk_req *vbr;
-
-	vbr = container_of(work, struct virtblk_req, work);
-
-	virtblk_bio_send_flush(vbr);
-}
-
 static inline void virtblk_request_done(struct virtblk_req *vbr)
 {
-	struct virtio_blk *vblk = vbr->vblk;
 	struct request *req = vbr->req;
 	int error = virtblk_result(vbr);
 
@@ -231,90 +123,43 @@ static inline void virtblk_request_done(struct virtblk_req *vbr)
 		req->errors = (error != 0);
 	}
 
-	__blk_end_request_all(req, error);
-	mempool_free(vbr, vblk->pool);
-}
-
-static inline void virtblk_bio_flush_done(struct virtblk_req *vbr)
-{
-	struct virtio_blk *vblk = vbr->vblk;
-
-	if (vbr->flags & VBLK_REQ_DATA) {
-		/* Send out the actual write data */
-		INIT_WORK(&vbr->work, virtblk_bio_send_data_work);
-		queue_work(virtblk_wq, &vbr->work);
-	} else {
-		bio_endio(vbr->bio, virtblk_result(vbr));
-		mempool_free(vbr, vblk->pool);
-	}
-}
-
-static inline void virtblk_bio_data_done(struct virtblk_req *vbr)
-{
-	struct virtio_blk *vblk = vbr->vblk;
-
-	if (unlikely(vbr->flags & VBLK_REQ_FUA)) {
-		/* Send out a flush before end the bio */
-		vbr->flags &= ~VBLK_REQ_DATA;
-		INIT_WORK(&vbr->work, virtblk_bio_send_flush_work);
-		queue_work(virtblk_wq, &vbr->work);
-	} else {
-		bio_endio(vbr->bio, virtblk_result(vbr));
-		mempool_free(vbr, vblk->pool);
-	}
-}
-
-static inline void virtblk_bio_done(struct virtblk_req *vbr)
-{
-	if (unlikely(vbr->flags & VBLK_IS_FLUSH))
-		virtblk_bio_flush_done(vbr);
-	else
-		virtblk_bio_data_done(vbr);
+	blk_mq_end_io(req, error);
 }
 
 static void virtblk_done(struct virtqueue *vq)
 {
 	struct virtio_blk *vblk = vq->vdev->priv;
-	bool bio_done = false, req_done = false;
+	bool req_done = false;
 	struct virtblk_req *vbr;
 	unsigned long flags;
 	unsigned int len;
 
-	spin_lock_irqsave(vblk->disk->queue->queue_lock, flags);
+	spin_lock_irqsave(&vblk->vq_lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
-			if (vbr->bio) {
-				virtblk_bio_done(vbr);
-				bio_done = true;
-			} else {
-				virtblk_request_done(vbr);
-				req_done = true;
-			}
+			virtblk_request_done(vbr);
+			req_done = true;
 		}
 	} while (!virtqueue_enable_cb(vq));
+	spin_unlock_irqrestore(&vblk->vq_lock, flags);
+
 	/* In case queue is stopped waiting for more buffers. */
 	if (req_done)
-		blk_start_queue(vblk->disk->queue);
-	spin_unlock_irqrestore(vblk->disk->queue->queue_lock, flags);
-
-	if (bio_done)
-		wake_up(&vblk->queue_wait);
+		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
 }
 
-static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
-		   struct request *req)
+static int virtio_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 {
+	struct virtio_blk *vblk = hctx->queue->queuedata;
+	struct virtblk_req *vbr = req->special;
+	unsigned long flags;
 	unsigned int num;
-	struct virtblk_req *vbr;
+	const bool last = (req->cmd_flags & REQ_END) != 0;
 
-	vbr = virtblk_alloc_req(vblk, GFP_ATOMIC);
-	if (!vbr)
-		/* When another request finishes we'll try again. */
-		return false;
+	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
 	vbr->req = req;
-	vbr->bio = NULL;
 	if (req->cmd_flags & REQ_FLUSH) {
 		vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
 		vbr->out_hdr.sector = 0;
@@ -342,7 +187,7 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	num = blk_rq_map_sg(q, vbr->req, vblk->sg);
+	num = blk_rq_map_sg(hctx->queue, vbr->req, vbr->sg);
 	if (num) {
 		if (rq_data_dir(vbr->req) == WRITE)
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
@@ -350,63 +195,18 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
 	}
 
-	if (__virtblk_add_req(vblk->vq, vbr, vblk->sg, num) < 0) {
-		mempool_free(vbr, vblk->pool);
-		return false;
-	}
-
-	return true;
-}
-
-static void virtblk_request(struct request_queue *q)
-{
-	struct virtio_blk *vblk = q->queuedata;
-	struct request *req;
-	unsigned int issued = 0;
-
-	while ((req = blk_peek_request(q)) != NULL) {
-		BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
-
-		/* If this request fails, stop queue and wait for something to
-		   finish to restart it. */
-		if (!do_req(q, vblk, req)) {
-			blk_stop_queue(q);
-			break;
-		}
-		blk_start_request(req);
-		issued++;
-	}
-
-	if (issued)
+	spin_lock_irqsave(&vblk->vq_lock, flags);
+	if (__virtblk_add_req(vblk->vq, vbr, vbr->sg, num) < 0) {
+		spin_unlock_irqrestore(&vblk->vq_lock, flags);
+		blk_mq_stop_hw_queue(hctx);
 		virtqueue_kick(vblk->vq);
-}
-
-static void virtblk_make_request(struct request_queue *q, struct bio *bio)
-{
-	struct virtio_blk *vblk = q->queuedata;
-	struct virtblk_req *vbr;
-
-	BUG_ON(bio->bi_phys_segments + 2 > vblk->sg_elems);
-
-	vbr = virtblk_alloc_req(vblk, GFP_NOIO);
-	if (!vbr) {
-		bio_endio(bio, -ENOMEM);
-		return;
+		return BLK_MQ_RQ_QUEUE_BUSY;
 	}
+	spin_unlock_irqrestore(&vblk->vq_lock, flags);
 
-	vbr->bio = bio;
-	vbr->flags = 0;
-	if (bio->bi_rw & REQ_FLUSH)
-		vbr->flags |= VBLK_REQ_FLUSH;
-	if (bio->bi_rw & REQ_FUA)
-		vbr->flags |= VBLK_REQ_FUA;
-	if (bio->bi_iter.bi_size)
-		vbr->flags |= VBLK_REQ_DATA;
-
-	if (unlikely(vbr->flags & VBLK_REQ_FLUSH))
-		virtblk_bio_send_flush(vbr);
-	else
-		virtblk_bio_send_data(vbr);
+	if (last)
+		virtqueue_kick(vblk->vq);
+	return BLK_MQ_RQ_QUEUE_OK;
 }
 
 /* return id (s/n) string for *disk to *id_str
@@ -680,12 +480,35 @@ static const struct device_attribute dev_attr_cache_type_rw =
 	__ATTR(cache_type, S_IRUGO|S_IWUSR,
 	       virtblk_cache_type_show, virtblk_cache_type_store);
 
+static struct blk_mq_ops virtio_mq_ops = {
+	.queue_rq	= virtio_queue_rq,
+	.map_queue	= blk_mq_map_queue,
+	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
+	.free_hctx	= blk_mq_free_single_hw_queue,
+};
+
+static struct blk_mq_reg virtio_mq_reg = {
+	.ops		= &virtio_mq_ops,
+	.nr_hw_queues	= 1,
+	.queue_depth	= 64,
+	.numa_node	= NUMA_NO_NODE,
+	.flags		= BLK_MQ_F_SHOULD_MERGE,
+};
+
+static void virtblk_init_vbr(void *data, struct blk_mq_hw_ctx *hctx,
+			     struct request *rq, unsigned int nr)
+{
+	struct virtio_blk *vblk = data;
+	struct virtblk_req *vbr = rq->special;
+
+	sg_init_table(vbr->sg, vblk->sg_elems);
+}
+
 static int virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
 	struct request_queue *q;
 	int err, index;
-	int pool_size;
 
 	u64 cap;
 	u32 v, blk_size, sg_elems, opt_io_size;
@@ -709,17 +532,14 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	/* We need an extra sg elements at head and tail. */
 	sg_elems += 2;
-	vdev->priv = vblk = kmalloc(sizeof(*vblk) +
-				    sizeof(vblk->sg[0]) * sg_elems, GFP_KERNEL);
+	vdev->priv = vblk = kmalloc(sizeof(*vblk), GFP_KERNEL);
 	if (!vblk) {
 		err = -ENOMEM;
 		goto out_free_index;
 	}
 
-	init_waitqueue_head(&vblk->queue_wait);
 	vblk->vdev = vdev;
 	vblk->sg_elems = sg_elems;
-	sg_init_table(vblk->sg, vblk->sg_elems);
 	mutex_init(&vblk->config_lock);
 
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
@@ -728,31 +548,27 @@ static int virtblk_probe(struct virtio_device *vdev)
 	err = init_vq(vblk);
 	if (err)
 		goto out_free_vblk;
-
-	pool_size = sizeof(struct virtblk_req);
-	if (use_bio)
-		pool_size += sizeof(struct scatterlist) * sg_elems;
-	vblk->pool = mempool_create_kmalloc_pool(1, pool_size);
-	if (!vblk->pool) {
-		err = -ENOMEM;
-		goto out_free_vq;
-	}
+	spin_lock_init(&vblk->vq_lock);
 
 	/* FIXME: How many partitions?  How long is a piece of string? */
 	vblk->disk = alloc_disk(1 << PART_BITS);
 	if (!vblk->disk) {
 		err = -ENOMEM;
-		goto out_mempool;
+		goto out_free_vq;
 	}
 
-	q = vblk->disk->queue = blk_init_queue(virtblk_request, NULL);
+	virtio_mq_reg.cmd_size =
+		sizeof(struct virtblk_req) +
+		sizeof(struct scatterlist) * sg_elems;
+
+	q = vblk->disk->queue = blk_mq_init_queue(&virtio_mq_reg, vblk);
 	if (!q) {
 		err = -ENOMEM;
 		goto out_put_disk;
 	}
 
-	if (use_bio)
-		blk_queue_make_request(q, virtblk_make_request);
+	blk_mq_init_commands(q, virtblk_init_vbr, vblk);
+
 	q->queuedata = vblk;
 
 	virtblk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);
@@ -857,8 +673,6 @@ out_del_disk:
 	blk_cleanup_queue(vblk->disk->queue);
 out_put_disk:
 	put_disk(vblk->disk);
-out_mempool:
-	mempool_destroy(vblk->pool);
 out_free_vq:
 	vdev->config->del_vqs(vdev);
 out_free_vblk:
@@ -890,7 +704,6 @@ static void virtblk_remove(struct virtio_device *vdev)
 
 	refc = atomic_read(&disk_to_dev(vblk->disk)->kobj.kref.refcount);
 	put_disk(vblk->disk);
-	mempool_destroy(vblk->pool);
 	vdev->config->del_vqs(vdev);
 	kfree(vblk);
 
@@ -914,10 +727,7 @@ static int virtblk_freeze(struct virtio_device *vdev)
 
 	flush_work(&vblk->config_work);
 
-	spin_lock_irq(vblk->disk->queue->queue_lock);
-	blk_stop_queue(vblk->disk->queue);
-	spin_unlock_irq(vblk->disk->queue->queue_lock);
-	blk_sync_queue(vblk->disk->queue);
+	blk_mq_stop_hw_queues(vblk->disk->queue);
 
 	vdev->config->del_vqs(vdev);
 	return 0;
@@ -930,11 +740,9 @@ static int virtblk_restore(struct virtio_device *vdev)
 
 	vblk->config_enable = true;
 	ret = init_vq(vdev->priv);
-	if (!ret) {
-		spin_lock_irq(vblk->disk->queue->queue_lock);
-		blk_start_queue(vblk->disk->queue);
-		spin_unlock_irq(vblk->disk->queue->queue_lock);
-	}
+	if (!ret)
+		blk_mq_start_stopped_hw_queues(vblk->disk->queue);
+
 	return ret;
 }
 #endif
