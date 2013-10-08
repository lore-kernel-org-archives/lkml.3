Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3JHJf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:35:26 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62605 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3JHJfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:35:17 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: axboe@kernel.dk, willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH RFC 2/2] NVMe: rfc blk-mq support
Date: Tue,  8 Oct 2013 11:34:22 +0200
Message-Id: <1381224862-5299-3-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381224862-5299-1-git-send-email-m@bjorling.me>
References: <1381224862-5299-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to blk mq.

The patch consists of:

 * Initializion of mq data structures.
 * Convert function calls from bio to request data structures.
 * IO queues are split into an admin queue and io queues.
 * bio splits are removed as it should be handled by block layer.

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 drivers/block/nvme-core.c | 404 +++++++++++++++++-----------------------------
 include/linux/nvme.h      |   3 +-
 2 files changed, 153 insertions(+), 254 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index ce79a59..510e41f 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -39,10 +39,14 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <scsi/sg.h>
 #include <asm-generic/io-64-nonatomic-lo-hi.h>
 
 #define NVME_Q_DEPTH 1024
+#define NVME_ADMIN_Q_DEPTH 64
+#define NVME_ADMIN_QUEUE_IDX 0
 #define SQ_SIZE(depth)		(depth * sizeof(struct nvme_command))
 #define CQ_SIZE(depth)		(depth * sizeof(struct nvme_completion))
 #define NVME_MINORS 64
@@ -226,7 +230,8 @@ static void *cancel_cmdid(struct nvme_queue *nvmeq, int cmdid,
 
 struct nvme_queue *get_nvmeq(struct nvme_dev *dev)
 {
-	return dev->queues[get_cpu() + 1];
+	get_cpu();
+	return dev->admin_queue;
 }
 
 void put_nvmeq(struct nvme_queue *nvmeq)
@@ -312,17 +317,19 @@ static void bio_completion(struct nvme_dev *dev, void *ctx,
 						struct nvme_completion *cqe)
 {
 	struct nvme_iod *iod = ctx;
-	struct bio *bio = iod->private;
+	struct request *rq = iod->private;
+
 	u16 status = le16_to_cpup(&cqe->status) >> 1;
 
 	if (iod->nents)
 		dma_unmap_sg(&dev->pci_dev->dev, iod->sg, iod->nents,
-			bio_data_dir(bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+			rq_data_dir(rq) ==
+				WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	nvme_free_iod(dev, iod);
-	if (status)
-		bio_endio(bio, -EIO);
+	if (unlikely(status))
+		blk_mq_end_io(rq, -EIO);
 	else
-		bio_endio(bio, 0);
+		blk_mq_end_io(rq, 0);
 }
 
 /* length is in bytes.  gfp flags indicates whether we may sleep. */
@@ -406,153 +413,15 @@ int nvme_setup_prps(struct nvme_dev *dev, struct nvme_common_command *cmd,
 	return total_len;
 }
 
-struct nvme_bio_pair {
-	struct bio b1, b2, *parent;
-	struct bio_vec *bv1, *bv2;
-	int err;
-	atomic_t cnt;
-};
-
-static void nvme_bio_pair_endio(struct bio *bio, int err)
+static int nvme_map_rq(struct nvme_queue *nvmeq, struct nvme_iod *iod,
+		struct request *rq, enum dma_data_direction dma_dir)
 {
-	struct nvme_bio_pair *bp = bio->bi_private;
-
-	if (err)
-		bp->err = err;
-
-	if (atomic_dec_and_test(&bp->cnt)) {
-		bio_endio(bp->parent, bp->err);
-		if (bp->bv1)
-			kfree(bp->bv1);
-		if (bp->bv2)
-			kfree(bp->bv2);
-		kfree(bp);
-	}
-}
-
-static struct nvme_bio_pair *nvme_bio_split(struct bio *bio, int idx,
-							int len, int offset)
-{
-	struct nvme_bio_pair *bp;
-
-	BUG_ON(len > bio->bi_size);
-	BUG_ON(idx > bio->bi_vcnt);
-
-	bp = kmalloc(sizeof(*bp), GFP_ATOMIC);
-	if (!bp)
-		return NULL;
-	bp->err = 0;
-
-	bp->b1 = *bio;
-	bp->b2 = *bio;
-
-	bp->b1.bi_size = len;
-	bp->b2.bi_size -= len;
-	bp->b1.bi_vcnt = idx;
-	bp->b2.bi_idx = idx;
-	bp->b2.bi_sector += len >> 9;
-
-	if (offset) {
-		bp->bv1 = kmalloc(bio->bi_max_vecs * sizeof(struct bio_vec),
-								GFP_ATOMIC);
-		if (!bp->bv1)
-			goto split_fail_1;
-
-		bp->bv2 = kmalloc(bio->bi_max_vecs * sizeof(struct bio_vec),
-								GFP_ATOMIC);
-		if (!bp->bv2)
-			goto split_fail_2;
-
-		memcpy(bp->bv1, bio->bi_io_vec,
-			bio->bi_max_vecs * sizeof(struct bio_vec));
-		memcpy(bp->bv2, bio->bi_io_vec,
-			bio->bi_max_vecs * sizeof(struct bio_vec));
-
-		bp->b1.bi_io_vec = bp->bv1;
-		bp->b2.bi_io_vec = bp->bv2;
-		bp->b2.bi_io_vec[idx].bv_offset += offset;
-		bp->b2.bi_io_vec[idx].bv_len -= offset;
-		bp->b1.bi_io_vec[idx].bv_len = offset;
-		bp->b1.bi_vcnt++;
-	} else
-		bp->bv1 = bp->bv2 = NULL;
-
-	bp->b1.bi_private = bp;
-	bp->b2.bi_private = bp;
-
-	bp->b1.bi_end_io = nvme_bio_pair_endio;
-	bp->b2.bi_end_io = nvme_bio_pair_endio;
-
-	bp->parent = bio;
-	atomic_set(&bp->cnt, 2);
-
-	return bp;
-
- split_fail_2:
-	kfree(bp->bv1);
- split_fail_1:
-	kfree(bp);
-	return NULL;
-}
-
-static int nvme_split_and_submit(struct bio *bio, struct nvme_queue *nvmeq,
-						int idx, int len, int offset)
-{
-	struct nvme_bio_pair *bp = nvme_bio_split(bio, idx, len, offset);
-	if (!bp)
-		return -ENOMEM;
-
-	if (bio_list_empty(&nvmeq->sq_cong))
-		add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
-	bio_list_add(&nvmeq->sq_cong, &bp->b1);
-	bio_list_add(&nvmeq->sq_cong, &bp->b2);
-
-	return 0;
-}
+	iod->nents = blk_rq_map_sg(rq->q, rq, iod->sg);
 
-/* NVMe scatterlists require no holes in the virtual address */
-#define BIOVEC_NOT_VIRT_MERGEABLE(vec1, vec2)	((vec2)->bv_offset || \
-			(((vec1)->bv_offset + (vec1)->bv_len) % PAGE_SIZE))
-
-static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
-		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
-{
-	struct bio_vec *bvec, *bvprv = NULL;
-	struct scatterlist *sg = NULL;
-	int i, length = 0, nsegs = 0, split_len = bio->bi_size;
-
-	if (nvmeq->dev->stripe_size)
-		split_len = nvmeq->dev->stripe_size -
-			((bio->bi_sector << 9) & (nvmeq->dev->stripe_size - 1));
-
-	sg_init_table(iod->sg, psegs);
-	bio_for_each_segment(bvec, bio, i) {
-		if (bvprv && BIOVEC_PHYS_MERGEABLE(bvprv, bvec)) {
-			sg->length += bvec->bv_len;
-		} else {
-			if (bvprv && BIOVEC_NOT_VIRT_MERGEABLE(bvprv, bvec))
-				return nvme_split_and_submit(bio, nvmeq, i,
-								length, 0);
-
-			sg = sg ? sg + 1 : iod->sg;
-			sg_set_page(sg, bvec->bv_page, bvec->bv_len,
-							bvec->bv_offset);
-			nsegs++;
-		}
-
-		if (split_len - length < bvec->bv_len)
-			return nvme_split_and_submit(bio, nvmeq, i, split_len,
-							split_len - length);
-		length += bvec->bv_len;
-		bvprv = bvec;
-	}
-	iod->nents = nsegs;
-	sg_mark_end(sg);
 	if (dma_map_sg(nvmeq->q_dmadev, iod->sg, iod->nents, dma_dir) == 0)
 		return -ENOMEM;
 
-	BUG_ON(length != bio->bi_size);
-	return length;
+	return 0;
 }
 
 /*
@@ -561,10 +430,11 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
  * the iod.
  */
 static int nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
-		struct bio *bio, struct nvme_iod *iod, int cmdid)
+		struct request *rq, struct nvme_iod *iod, int cmdid)
 {
 	struct nvme_dsm_range *range;
 	struct nvme_command *cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
+	struct bio *bio = rq->bio;
 
 	range = dma_pool_alloc(nvmeq->dev->prp_small_pool, GFP_ATOMIC,
 							&iod->first_dma);
@@ -624,10 +494,11 @@ int nvme_submit_flush_data(struct nvme_queue *nvmeq, struct nvme_ns *ns)
  * Called with local interrupts disabled and the q_lock held.  May not sleep.
  */
 static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
-								struct bio *bio)
+				  struct request *rq)
 {
 	struct nvme_command *cmnd;
-	struct nvme_iod *iod;
+	struct nvme_iod *iod = rq->special;
+	struct bio *bio = rq->bio;
 	enum dma_data_direction dma_dir;
 	int cmdid, length, result;
 	u16 control;
@@ -644,7 +515,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	iod = nvme_alloc_iod(psegs, bio->bi_size, GFP_ATOMIC);
 	if (!iod)
 		goto nomem;
-	iod->private = bio;
+	iod->private = rq;
 
 	result = -EBUSY;
 	cmdid = alloc_cmdid(nvmeq, iod, bio_completion, NVME_IO_TIMEOUT);
@@ -652,7 +523,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 		goto free_iod;
 
 	if (bio->bi_rw & REQ_DISCARD) {
-		result = nvme_submit_discard(nvmeq, ns, bio, iod, cmdid);
+		result = nvme_submit_discard(nvmeq, ns, rq, iod, cmdid);
 		if (result)
 			goto free_cmdid;
 		return result;
@@ -673,7 +544,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
 
 	memset(cmnd, 0, sizeof(*cmnd));
-	if (bio_data_dir(bio)) {
+	if (rq_data_dir(rq) == WRITE) {
 		cmnd->rw.opcode = nvme_cmd_write;
 		dma_dir = DMA_TO_DEVICE;
 	} else {
@@ -681,10 +552,11 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 		dma_dir = DMA_FROM_DEVICE;
 	}
 
-	result = nvme_map_bio(nvmeq, iod, bio, dma_dir, psegs);
-	if (result <= 0)
+	result = nvme_map_rq(nvmeq, iod, rq, dma_dir);
+	if (result < 0)
 		goto free_cmdid;
-	length = result;
+
+	length = blk_rq_bytes(rq);
 
 	cmnd->rw.command_id = cmdid;
 	cmnd->rw.nsid = cpu_to_le32(ns->ns_id);
@@ -709,23 +581,26 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	return result;
 }
 
-static void nvme_make_request(struct request_queue *q, struct bio *bio)
+static int nvme_queue_request(struct blk_mq_hw_ctx *hctx, struct request *rq)
 {
-	struct nvme_ns *ns = q->queuedata;
-	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
+	struct nvme_ns *ns = hctx->queue->queuedata;
+	struct nvme_queue *nvmeq = hctx->driver_data;
 	int result = -EBUSY;
 
 	spin_lock_irq(&nvmeq->q_lock);
-	if (bio_list_empty(&nvmeq->sq_cong))
-		result = nvme_submit_bio_queue(nvmeq, ns, bio);
-	if (unlikely(result)) {
-		if (bio_list_empty(&nvmeq->sq_cong))
-			add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
-		bio_list_add(&nvmeq->sq_cong, bio);
-	}
-
+	result = nvme_submit_bio_queue(nvmeq, ns, rq);
 	spin_unlock_irq(&nvmeq->q_lock);
-	put_nvmeq(nvmeq);
+
+	switch (result) {
+	case 0:
+		return BLK_MQ_RQ_QUEUE_OK;
+	case -EBUSY:
+		return BLK_MQ_RQ_QUEUE_BUSY;
+	case -ENOMEM:
+		/* fallthrough */
+	default:
+		return BLK_MQ_RQ_QUEUE_ERROR;
+	}
 }
 
 static irqreturn_t nvme_process_cq(struct nvme_queue *nvmeq)
@@ -845,7 +720,8 @@ int nvme_submit_sync_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
 int nvme_submit_admin_cmd(struct nvme_dev *dev, struct nvme_command *cmd,
 								u32 *result)
 {
-	return nvme_submit_sync_cmd(dev->queues[0], cmd, result, ADMIN_TIMEOUT);
+	return nvme_submit_sync_cmd(dev->admin_queue,
+			cmd, result, ADMIN_TIMEOUT);
 }
 
 static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)
@@ -995,24 +871,19 @@ static void nvme_free_queue_mem(struct nvme_queue *nvmeq)
 	kfree(nvmeq);
 }
 
-static void nvme_free_queue(struct nvme_dev *dev, int qid)
+static void nvme_free_queue(struct nvme_dev *dev, struct nvme_queue *nvmeq,
+				  int qid)
 {
-	struct nvme_queue *nvmeq = dev->queues[qid];
 	int vector = dev->entry[nvmeq->cq_vector].vector;
 
 	spin_lock_irq(&nvmeq->q_lock);
 	nvme_cancel_ios(nvmeq, false);
-	while (bio_list_peek(&nvmeq->sq_cong)) {
-		struct bio *bio = bio_list_pop(&nvmeq->sq_cong);
-		bio_endio(bio, -EIO);
-	}
 	spin_unlock_irq(&nvmeq->q_lock);
 
 	irq_set_affinity_hint(vector, NULL);
 	free_irq(vector, nvmeq);
 
-	/* Don't tell the adapter to delete the admin queue */
-	if (qid) {
+	if (qid != NVME_ADMIN_QUEUE_IDX) {
 		adapter_delete_sq(dev, qid);
 		adapter_delete_cq(dev, qid);
 	}
@@ -1166,7 +1037,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 	if (result < 0)
 		return result;
 
-	nvmeq = nvme_alloc_queue(dev, 0, 64, 0);
+	nvmeq = nvme_alloc_queue(dev, 0, NVME_ADMIN_Q_DEPTH, 0);
 	if (!nvmeq)
 		return -ENOMEM;
 
@@ -1191,7 +1062,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 	if (result)
 		goto free_q;
 
-	dev->queues[0] = nvmeq;
+	dev->admin_queue = nvmeq;
 	return result;
 
  free_q:
@@ -1431,7 +1302,7 @@ static int nvme_user_admin_cmd(struct nvme_dev *dev,
 	if (length != cmd.data_len)
 		status = -ENOMEM;
 	else
-		status = nvme_submit_sync_cmd(dev->queues[0], &c, &cmd.result,
+		status = nvme_submit_sync_cmd(dev->admin_queue, &c, &cmd.result,
 								timeout);
 
 	if (cmd.data_len) {
@@ -1473,25 +1344,6 @@ static const struct block_device_operations nvme_fops = {
 	.compat_ioctl	= nvme_ioctl,
 };
 
-static void nvme_resubmit_bios(struct nvme_queue *nvmeq)
-{
-	while (bio_list_peek(&nvmeq->sq_cong)) {
-		struct bio *bio = bio_list_pop(&nvmeq->sq_cong);
-		struct nvme_ns *ns = bio->bi_bdev->bd_disk->private_data;
-
-		if (bio_list_empty(&nvmeq->sq_cong))
-			remove_wait_queue(&nvmeq->sq_full,
-							&nvmeq->sq_cong_wait);
-		if (nvme_submit_bio_queue(nvmeq, ns, bio)) {
-			if (bio_list_empty(&nvmeq->sq_cong))
-				add_wait_queue(&nvmeq->sq_full,
-							&nvmeq->sq_cong_wait);
-			bio_list_add_head(&nvmeq->sq_cong, bio);
-			break;
-		}
-	}
-}
-
 static int nvme_kthread(void *data)
 {
 	struct nvme_dev *dev;
@@ -1500,18 +1352,14 @@ static int nvme_kthread(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_lock(&dev_list_lock);
 		list_for_each_entry(dev, &dev_list, node) {
-			int i;
-			for (i = 0; i < dev->queue_count; i++) {
-				struct nvme_queue *nvmeq = dev->queues[i];
-				if (!nvmeq)
-					continue;
-				spin_lock_irq(&nvmeq->q_lock);
-				if (nvme_process_cq(nvmeq))
-					printk("process_cq did something\n");
-				nvme_cancel_ios(nvmeq, true);
-				nvme_resubmit_bios(nvmeq);
-				spin_unlock_irq(&nvmeq->q_lock);
-			}
+			struct nvme_queue *nvmeq = dev->admin_queue;
+			if (!nvmeq)
+				continue;
+			spin_lock_irq(&nvmeq->q_lock);
+			if (nvme_process_cq(nvmeq))
+				printk("process_cq did something\n");
+			nvme_cancel_ios(nvmeq, true);
+			spin_unlock_irq(&nvmeq->q_lock);
 		}
 		spin_unlock(&dev_list_lock);
 		schedule_timeout(round_jiffies_relative(HZ));
@@ -1556,6 +1404,74 @@ static void nvme_config_discard(struct nvme_ns *ns)
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, ns->queue);
 }
 
+static struct blk_mq_hw_ctx *nvme_alloc_hctx(struct blk_mq_reg *reg,
+			  unsigned int i)
+{
+	return kmalloc_node(sizeof(struct blk_mq_hw_ctx),
+				GFP_KERNEL | __GFP_ZERO, i);
+}
+
+/*
+ * Initialize the hctx by creating appropriate submission and
+ * completion queues within the nvme device
+ */
+static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+			  unsigned int i)
+{
+	struct nvme_ns *ns = data;
+	struct nvme_dev *dev = ns->dev;
+	struct nvme_queue *nq;
+
+	nq = nvme_create_queue(dev, i + 1, hctx->queue_depth, i);
+	if (IS_ERR(nq))
+		return PTR_ERR(nq);
+
+	hctx->driver_data = nq;
+
+	return 0;
+}
+
+static void nvme_exit_hctx(struct blk_mq_hw_ctx *hctx, unsigned int i)
+{
+	struct nvme_queue *nq = hctx->driver_data;
+	struct nvme_dev *dev = nq->dev;
+
+	nvme_free_queue(dev, nq, i + 1);
+}
+
+static void nvme_free_hctx(struct blk_mq_hw_ctx *hctx, unsigned int i)
+{
+	kfree(hctx);
+}
+
+static enum blk_eh_timer_return nvme_timeout(struct request *rq)
+{
+	/* Currently the driver handle timeouts by itself */
+	return BLK_EH_NOT_HANDLED;
+}
+
+static struct blk_mq_ops nvme_mq_ops = {
+	.queue_rq		= nvme_queue_request,
+
+	.map_queue		= blk_mq_map_queue,
+
+	.alloc_hctx		= nvme_alloc_hctx,
+	.free_hctx		= nvme_free_hctx,
+
+	.init_hctx		= nvme_init_hctx,
+	.exit_hctx		= nvme_exit_hctx,
+
+	.timeout		= nvme_timeout,
+};
+
+static struct blk_mq_reg nvme_mq_reg = {
+	.ops			= &nvme_mq_ops,
+	.timeout		= NVME_IO_TIMEOUT,
+	.numa_node		= NUMA_NO_NODE,
+	.reserved_tags	= NVME_ADMIN_Q_DEPTH,
+	.flags			= BLK_MQ_F_SHOULD_MERGE,
+};
+
 static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, int nsid,
 			struct nvme_id_ns *id, struct nvme_lba_range_type *rt)
 {
@@ -1569,14 +1485,17 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, int nsid,
 	ns = kzalloc(sizeof(*ns), GFP_KERNEL);
 	if (!ns)
 		return NULL;
-	ns->queue = blk_alloc_queue(GFP_KERNEL);
+
+	ns->dev = dev;
+
+	ns->queue = blk_mq_init_queue(&nvme_mq_reg, ns);
 	if (!ns->queue)
 		goto out_free_ns;
-	ns->queue->queue_flags = QUEUE_FLAG_DEFAULT;
-	queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, ns->queue);
+
+	queue_flag_set_unlocked(QUEUE_FLAG_DEFAULT, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, ns->queue);
-	blk_queue_make_request(ns->queue, nvme_make_request);
-	ns->dev = dev;
+	queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, ns->queue);
+
 	ns->queue->queuedata = ns;
 
 	disk = alloc_disk(NVME_MINORS);
@@ -1607,7 +1526,7 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, int nsid,
 	return ns;
 
  out_free_queue:
-	blk_cleanup_queue(ns->queue);
+	blk_mq_free_queue(ns->queue);
  out_free_ns:
 	kfree(ns);
 	return NULL;
@@ -1615,10 +1534,16 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, int nsid,
 
 static void nvme_ns_free(struct nvme_ns *ns)
 {
+	struct nvme_dev *dev = ns->dev;
+	struct nvme_queue *nq = dev->admin_queue;
 	int index = ns->disk->first_minor / NVME_MINORS;
-	put_disk(ns->disk);
+
+	blk_mq_free_queue(ns->queue);
+
+	nvme_free_queue(dev, nq, NVME_ADMIN_QUEUE_IDX);
+
 	nvme_put_ns_idx(index);
-	blk_cleanup_queue(ns->queue);
+	put_disk(ns->disk);
 	kfree(ns);
 }
 
@@ -1649,14 +1574,14 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 
 	q_count = nr_io_queues;
 	/* Deregister the admin queue's interrupt */
-	free_irq(dev->entry[0].vector, dev->queues[0]);
+	free_irq(dev->entry[0].vector, dev->admin_queue);
 
 	db_bar_size = 4096 + ((nr_io_queues + 1) << (dev->db_stride + 3));
 	if (db_bar_size > 8192) {
 		iounmap(dev->bar);
 		dev->bar = ioremap(pci_resource_start(pdev, 0), db_bar_size);
 		dev->dbs = ((void __iomem *)dev->bar) + 4096;
-		dev->queues[0]->q_db = dev->dbs;
+		dev->admin_queue->q_db = dev->dbs;
 	}
 
 	for (i = 0; i < nr_io_queues; i++)
@@ -1692,7 +1617,7 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 		}
 	}
 
-	result = queue_request_irq(dev, dev->queues[0], "nvme admin");
+	result = queue_request_irq(dev, dev->admin_queue, "nvme admin");
 	/* XXX: handle failure here */
 
 	cpu = cpumask_first(cpu_online_mask);
@@ -1703,29 +1628,13 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 
 	q_depth = min_t(int, NVME_CAP_MQES(readq(&dev->bar->cap)) + 1,
 								NVME_Q_DEPTH);
-	for (i = 0; i < nr_io_queues; i++) {
-		dev->queues[i + 1] = nvme_create_queue(dev, i + 1, q_depth, i);
-		if (IS_ERR(dev->queues[i + 1]))
-			return PTR_ERR(dev->queues[i + 1]);
-		dev->queue_count++;
-	}
 
-	for (; i < num_possible_cpus(); i++) {
-		int target = i % rounddown_pow_of_two(dev->queue_count - 1);
-		dev->queues[i + 1] = dev->queues[target + 1];
-	}
+	nvme_mq_reg.nr_hw_queues = q_count;
+	nvme_mq_reg.queue_depth = q_depth;
 
 	return 0;
 }
 
-static void nvme_free_queues(struct nvme_dev *dev)
-{
-	int i;
-
-	for (i = dev->queue_count - 1; i >= 0; i--)
-		nvme_free_queue(dev, i);
-}
-
 /*
  * Return: error value if an error occurred setting up the queues or calling
  * Identify Device.  0 if these succeeded, even if adding some of the
@@ -1810,8 +1719,6 @@ static int nvme_dev_remove(struct nvme_dev *dev)
 		nvme_ns_free(ns);
 	}
 
-	nvme_free_queues(dev);
-
 	return 0;
 }
 
@@ -1881,7 +1788,7 @@ static void nvme_free_dev(struct kref *kref)
 	nvme_release_prp_pools(dev);
 	pci_disable_device(dev->pci_dev);
 	pci_release_regions(dev->pci_dev);
-	kfree(dev->queues);
+	kfree(dev->admin_queue);
 	kfree(dev->entry);
 	kfree(dev);
 }
@@ -1933,10 +1840,6 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 								GFP_KERNEL);
 	if (!dev->entry)
 		goto free;
-	dev->queues = kcalloc(num_possible_cpus() + 1, sizeof(void *),
-								GFP_KERNEL);
-	if (!dev->queues)
-		goto free;
 
 	if (pci_enable_device_mem(pdev))
 		goto free;
@@ -1975,7 +1878,6 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	result = nvme_configure_admin_queue(dev);
 	if (result)
 		goto unmap;
-	dev->queue_count++;
 
 	spin_lock(&dev_list_lock);
 	list_add(&dev->node, &dev_list);
@@ -2003,8 +1905,6 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock(&dev_list_lock);
 	list_del(&dev->node);
 	spin_unlock(&dev_list_lock);
-
-	nvme_free_queues(dev);
  unmap:
 	iounmap(dev->bar);
  disable_msix:
@@ -2018,7 +1918,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_disable_device(pdev);
 	pci_release_regions(pdev);
  free:
-	kfree(dev->queues);
+	kfree(dev->admin_queue);
 	kfree(dev->entry);
 	kfree(dev);
 	return result;
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index f451c8d..ed8d022 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -520,13 +520,12 @@ struct nvme_admin_cmd {
  */
 struct nvme_dev {
 	struct list_head node;
-	struct nvme_queue **queues;
+	struct nvme_queue *admin_queue;
 	u32 __iomem *dbs;
 	struct pci_dev *pci_dev;
 	struct dma_pool *prp_page_pool;
 	struct dma_pool *prp_small_pool;
 	int instance;
-	int queue_count;
 	int db_stride;
 	u32 ctrl_config;
 	struct msix_entry *entry;
-- 
1.8.1.2

