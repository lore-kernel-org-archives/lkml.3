Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbaGAOxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:53:37 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:50540 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbaGAOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:53:31 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, tom.leiming@gmail.com, hch@infradead.org,
        rlnelson@google.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH v10] NVMe: Convert to blk-mq
Date: Tue,  1 Jul 2014 16:53:02 +0200
Message-Id: <1404226382-7179-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404226382-7179-1-git-send-email-m@bjorling.me>
References: <1404226382-7179-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the NVMe driver to a blk-mq request-based driver.

The NVMe driver is currently bio-based and implements queue logic within itself.
By using blk-mq, a lot of these responsibilities can be moved and simplified.

The patch is divided into the following blocks:

 * Per-command data and cmdid have been moved into the struct request field.
   The cmdid_data can be retrieved using blk_mq_rq_to_pdu() and id maintenance
   are now handled by blk-mq through the rq->tag field.

 * The logic for splitting bio's has been moved into the blk-mq layer. The
   driver instead notifies the block layer about limited gap support in SG
   lists.

 * blk-mq handles timeouts and is reimplemented within nvme_timeout(). This both
   includes abort handling and command cancelation.

 * Assignment of nvme queues to CPUs are replaced with the blk-mq version. The
   current blk-mq strategy is to assign the number of mapped queues and CPUs to
   provide synergy, while the nvme driver assign as many nvme hw queues as
   possible. This can be implemented in blk-mq if needed.

 * NVMe queues are merged with the hardware dispatch queue (hctx) structure of
   blk-mq.

 * blk-mq takes care of setup/teardown of nvme queues and guards invalid
   accesses. Therefore, RCU-usage for nvme queues can be removed.

 * IO tracing and accounting are handled by blk-mq and therefore removed.

 * Setup and teardown of nvme queues are now handled by nvme_[init/exit]_hctx.

Contributions in this patch from:

  Sam Bradshaw <sbradshaw@micron.com>
  Jens Axboe <axboe@kernel.dk>
  Keith Busch <keith.busch@intel.com>
  Robert Nelson <rlnelson@google.com>

Acked-by: Keith Busch <keith.busch@intel.com>
Acked-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 drivers/block/nvme-core.c | 1219 ++++++++++++++++++---------------------------
 drivers/block/nvme-scsi.c |    8 +-
 include/linux/nvme.h      |   15 +-
 3 files changed, 489 insertions(+), 753 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 02351e2..337878b 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -13,9 +13,9 @@
  */
 
 #include <linux/nvme.h>
-#include <linux/bio.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
-#include <linux/percpu.h>
 #include <linux/poison.h>
 #include <linux/ptrace.h>
 #include <linux/sched.h>
@@ -42,9 +41,8 @@
 #include <scsi/sg.h>
 #include <asm-generic/io-64-nonatomic-lo-hi.h>
 
-#include <trace/events/block.h>
-
 #define NVME_Q_DEPTH		1024
+#define NVME_AQ_DEPTH		64
 #define SQ_SIZE(depth)		(depth * sizeof(struct nvme_command))
 #define CQ_SIZE(depth)		(depth * sizeof(struct nvme_completion))
 #define ADMIN_TIMEOUT		(admin_timeout * HZ)
@@ -76,10 +74,12 @@ static wait_queue_head_t nvme_kthread_wait;
 static struct notifier_block nvme_nb;
 
 static void nvme_reset_failed_dev(struct work_struct *ws);
+static int nvme_process_cq(struct nvme_queue *nvmeq);
 
 struct async_cmd_info {
 	struct kthread_work work;
 	struct kthread_worker *worker;
+	struct request *req;
 	u32 result;
 	int status;
 	void *ctx;
@@ -90,7 +90,6 @@ struct async_cmd_info {
  * commands and one for I/O commands).
  */
 struct nvme_queue {
-	struct rcu_head r_head;
 	struct device *q_dmadev;
 	struct nvme_dev *dev;
 	char irqname[24];	/* nvme4294967295-65535\0 */
@@ -99,10 +98,6 @@ struct nvme_queue {
 	volatile struct nvme_completion *cqes;
 	dma_addr_t sq_dma_addr;
 	dma_addr_t cq_dma_addr;
-	wait_queue_head_t sq_full;
-	wait_queue_t sq_cong_wait;
-	struct bio_list sq_cong;
-	struct list_head iod_bio;
 	u32 __iomem *q_db;
 	u16 q_depth;
 	u16 cq_vector;
@@ -113,9 +108,8 @@ struct nvme_queue {
 	u8 cq_phase;
 	u8 cqe_seen;
 	u8 q_suspended;
-	cpumask_var_t cpu_mask;
 	struct async_cmd_info cmdinfo;
-	unsigned long cmdid_data[];
+	struct blk_mq_hw_ctx *hctx;
 };
 
 /*
@@ -143,62 +137,73 @@ typedef void (*nvme_completion_fn)(struct nvme_queue *, void *,
 struct nvme_cmd_info {
 	nvme_completion_fn fn;
 	void *ctx;
-	unsigned long timeout;
 	int aborted;
+	struct nvme_queue *nvmeq;
 };
 
-static struct nvme_cmd_info *nvme_cmd_info(struct nvme_queue *nvmeq)
+static int nvme_admin_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+				unsigned int hctx_idx)
 {
-	return (void *)&nvmeq->cmdid_data[BITS_TO_LONGS(nvmeq->q_depth)];
+	struct nvme_dev *dev = data;
+	struct nvme_queue *nvmeq = dev->queues[0];
+
+	WARN_ON(nvmeq->hctx);
+	nvmeq->hctx = hctx;
+	hctx->driver_data = nvmeq;
+	return 0;
 }
 
-static unsigned nvme_queue_extra(int depth)
+static int nvme_admin_init_request(void *data, struct request *req,
+				unsigned int hctx_idx, unsigned int rq_idx,
+				unsigned int numa_node)
 {
-	return DIV_ROUND_UP(depth, 8) + (depth * sizeof(struct nvme_cmd_info));
+	struct nvme_dev *dev = data;
+	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
+	struct nvme_queue *nvmeq = dev->queues[0];
+
+	WARN_ON(!nvmeq);
+	cmd->nvmeq = nvmeq;
+	return 0;
 }
 
-/**
- * alloc_cmdid() - Allocate a Command ID
- * @nvmeq: The queue that will be used for this command
- * @ctx: A pointer that will be passed to the handler
- * @handler: The function to call on completion
- *
- * Allocate a Command ID for a queue.  The data passed in will
- * be passed to the completion handler.  This is implemented by using
- * the bottom two bits of the ctx pointer to store the handler ID.
- * Passing in a pointer that's not 4-byte aligned will cause a BUG.
- * We can change this if it becomes a problem.
- *
- * May be called with local interrupts disabled and the q_lock held,
- * or with interrupts enabled and no locks held.
- */
-static int alloc_cmdid(struct nvme_queue *nvmeq, void *ctx,
-				nvme_completion_fn handler, unsigned timeout)
+static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+			  unsigned int hctx_idx)
 {
-	int depth = nvmeq->q_depth - 1;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
-	int cmdid;
-
-	do {
-		cmdid = find_first_zero_bit(nvmeq->cmdid_data, depth);
-		if (cmdid >= depth)
-			return -EBUSY;
-	} while (test_and_set_bit(cmdid, nvmeq->cmdid_data));
-
-	info[cmdid].fn = handler;
-	info[cmdid].ctx = ctx;
-	info[cmdid].timeout = jiffies + timeout;
-	info[cmdid].aborted = 0;
-	return cmdid;
+	struct nvme_dev *dev = data;
+	struct nvme_queue *nvmeq = dev->queues[
+					(hctx_idx % dev->queue_count) + 1];
+
+	/* nvmeq queues are shared between namespaces. We assume here that
+	 * blk-mq map the tags so they match up with the nvme queue tags */
+	if (!nvmeq->hctx)
+		nvmeq->hctx = hctx;
+	else
+		WARN_ON(nvmeq->hctx->tags != hctx->tags);
+	irq_set_affinity_hint(dev->entry[nvmeq->cq_vector].vector,
+								hctx->cpumask);
+	hctx->driver_data = nvmeq;
+	return 0;
+}
+
+static int nvme_init_request(void *data, struct request *req,
+				unsigned int hctx_idx, unsigned int rq_idx,
+				unsigned int numa_node)
+{
+	struct nvme_dev *dev = data;
+	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
+	struct nvme_queue *nvmeq = dev->queues[hctx_idx + 1];
+
+	WARN_ON(!nvmeq);
+	cmd->nvmeq = nvmeq;
+	return 0;
 }
 
-static int alloc_cmdid_killable(struct nvme_queue *nvmeq, void *ctx,
-				nvme_completion_fn handler, unsigned timeout)
+static void nvme_set_info(struct nvme_cmd_info *cmd, void *ctx,
+				nvme_completion_fn handler)
 {
-	int cmdid;
-	wait_event_killable(nvmeq->sq_full,
-		(cmdid = alloc_cmdid(nvmeq, ctx, handler, timeout)) >= 0);
-	return (cmdid < 0) ? -EINTR : cmdid;
+	cmd->fn = handler;
+	cmd->ctx = ctx;
+	cmd->aborted = 0;
 }
 
 /* Special values must be less than 0x1000 */
@@ -206,17 +211,11 @@ static int alloc_cmdid_killable(struct nvme_queue *nvmeq, void *ctx,
 #define CMD_CTX_CANCELLED	(0x30C + CMD_CTX_BASE)
 #define CMD_CTX_COMPLETED	(0x310 + CMD_CTX_BASE)
 #define CMD_CTX_INVALID		(0x314 + CMD_CTX_BASE)
-#define CMD_CTX_ABORT		(0x318 + CMD_CTX_BASE)
-
 static void special_completion(struct nvme_queue *nvmeq, void *ctx,
 						struct nvme_completion *cqe)
 {
 	if (ctx == CMD_CTX_CANCELLED)
 		return;
-	if (ctx == CMD_CTX_ABORT) {
-		++nvmeq->dev->abort_limit;
-		return;
-	}
 	if (ctx == CMD_CTX_COMPLETED) {
 		dev_warn(nvmeq->q_dmadev,
 				"completed id %d twice on queue %d\n",
@@ -233,6 +232,31 @@ static void special_completion(struct nvme_queue *nvmeq, void *ctx,
 	dev_warn(nvmeq->q_dmadev, "Unknown special completion %p\n", ctx);
 }
 
+static void *cancel_cmd_info(struct nvme_cmd_info *cmd, nvme_completion_fn *fn)
+{
+	void *ctx;
+
+	if (fn)
+		*fn = cmd->fn;
+	ctx = cmd->ctx;
+	cmd->fn = special_completion;
+	cmd->ctx = CMD_CTX_CANCELLED;
+	return ctx;
+}
+
+static void abort_completion(struct nvme_queue *nvmeq, void *ctx,
+						struct nvme_completion *cqe)
+{
+	struct request *req = ctx;
+	u16 status = le16_to_cpup(&cqe->status) >> 1;
+	u32 result = le32_to_cpup(&cqe->result);
+
+	blk_put_request(req);
+
+	dev_warn(nvmeq->q_dmadev, "Abort status:%x result:%x", status, result);
+	++nvmeq->dev->abort_limit;
+}
+
 static void async_completion(struct nvme_queue *nvmeq, void *ctx,
 						struct nvme_completion *cqe)
 {
@@ -240,90 +264,38 @@ static void async_completion(struct nvme_queue *nvmeq, void *ctx,
 	cmdinfo->result = le32_to_cpup(&cqe->result);
 	cmdinfo->status = le16_to_cpup(&cqe->status) >> 1;
 	queue_kthread_work(cmdinfo->worker, &cmdinfo->work);
+	blk_put_request(cmdinfo->req);
+}
+
+static inline struct nvme_cmd_info *get_cmd_from_tag(struct nvme_queue *nvmeq,
+				  unsigned int tag)
+{
+	struct blk_mq_hw_ctx *hctx = nvmeq->hctx;
+	struct request *req = blk_mq_tag_to_rq(hctx->tags, tag);
+
+	return blk_mq_rq_to_pdu(req);
 }
 
 /*
  * Called with local interrupts disabled and the q_lock held.  May not sleep.
  */
-static void *free_cmdid(struct nvme_queue *nvmeq, int cmdid,
+static void *nvme_finish_cmd(struct nvme_queue *nvmeq, int tag,
 						nvme_completion_fn *fn)
 {
+	struct nvme_cmd_info *cmd = get_cmd_from_tag(nvmeq, tag);
 	void *ctx;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
-
-	if (cmdid >= nvmeq->q_depth || !info[cmdid].fn) {
-		if (fn)
-			*fn = special_completion;
+	if (tag >= nvmeq->q_depth) {
+		*fn = special_completion;
 		return CMD_CTX_INVALID;
 	}
 	if (fn)
-		*fn = info[cmdid].fn;
-	ctx = info[cmdid].ctx;
-	info[cmdid].fn = special_completion;
-	info[cmdid].ctx = CMD_CTX_COMPLETED;
-	clear_bit(cmdid, nvmeq->cmdid_data);
-	wake_up(&nvmeq->sq_full);
+		*fn = cmd->fn;
+	ctx = cmd->ctx;
+	cmd->fn = special_completion;
+	cmd->ctx = CMD_CTX_COMPLETED;
 	return ctx;
 }
 
-static void *cancel_cmdid(struct nvme_queue *nvmeq, int cmdid,
-						nvme_completion_fn *fn)
-{
-	void *ctx;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
-	if (fn)
-		*fn = info[cmdid].fn;
-	ctx = info[cmdid].ctx;
-	info[cmdid].fn = special_completion;
-	info[cmdid].ctx = CMD_CTX_CANCELLED;
-	return ctx;
-}
-
-static struct nvme_queue *raw_nvmeq(struct nvme_dev *dev, int qid)
-{
-	return rcu_dereference_raw(dev->queues[qid]);
-}
-
-static struct nvme_queue *get_nvmeq(struct nvme_dev *dev) __acquires(RCU)
-{
-	struct nvme_queue *nvmeq;
-	unsigned queue_id = get_cpu_var(*dev->io_queue);
-
-	rcu_read_lock();
-	nvmeq = rcu_dereference(dev->queues[queue_id]);
-	if (nvmeq)
-		return nvmeq;
-
-	rcu_read_unlock();
-	put_cpu_var(*dev->io_queue);
-	return NULL;
-}
-
-static void put_nvmeq(struct nvme_queue *nvmeq) __releases(RCU)
-{
-	rcu_read_unlock();
-	put_cpu_var(nvmeq->dev->io_queue);
-}
-
-static struct nvme_queue *lock_nvmeq(struct nvme_dev *dev, int q_idx)
-							__acquires(RCU)
-{
-	struct nvme_queue *nvmeq;
-
-	rcu_read_lock();
-	nvmeq = rcu_dereference(dev->queues[q_idx]);
-	if (nvmeq)
-		return nvmeq;
-
-	rcu_read_unlock();
-	return NULL;
-}
-
-static void unlock_nvmeq(struct nvme_queue *nvmeq) __releases(RCU)
-{
-	rcu_read_unlock();
-}
-
 /**
  * nvme_submit_cmd() - Copy a command into a queue and ring the doorbell
  * @nvmeq: The queue to use
@@ -380,7 +352,6 @@ nvme_alloc_iod(unsigned nseg, unsigned nbytes, gfp_t gfp)
 		iod->length = nbytes;
 		iod->nents = 0;
 		iod->first_dma = 0ULL;
-		iod->start_time = jiffies;
 	}
 
 	return iod;
@@ -404,65 +375,37 @@ void nvme_free_iod(struct nvme_dev *dev, struct nvme_iod *iod)
 	kfree(iod);
 }
 
-static void nvme_start_io_acct(struct bio *bio)
-{
-	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	if (blk_queue_io_stat(disk->queue)) {
-		const int rw = bio_data_dir(bio);
-		int cpu = part_stat_lock();
-		part_round_stats(cpu, &disk->part0);
-		part_stat_inc(cpu, &disk->part0, ios[rw]);
-		part_stat_add(cpu, &disk->part0, sectors[rw],
-							bio_sectors(bio));
-		part_inc_in_flight(&disk->part0, rw);
-		part_stat_unlock();
-	}
-}
-
-static void nvme_end_io_acct(struct bio *bio, unsigned long start_time)
-{
-	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	if (blk_queue_io_stat(disk->queue)) {
-		const int rw = bio_data_dir(bio);
-		unsigned long duration = jiffies - start_time;
-		int cpu = part_stat_lock();
-		part_stat_add(cpu, &disk->part0, ticks[rw], duration);
-		part_round_stats(cpu, &disk->part0);
-		part_dec_in_flight(&disk->part0, rw);
-		part_stat_unlock();
-	}
-}
-
-static void bio_completion(struct nvme_queue *nvmeq, void *ctx,
+static void req_completion(struct nvme_queue *nvmeq, void *ctx,
 						struct nvme_completion *cqe)
 {
 	struct nvme_iod *iod = ctx;
-	struct bio *bio = iod->private;
+	struct request *req = iod->private;
+	struct nvme_cmd_info *cmd_rq = blk_mq_rq_to_pdu(req);
+
 	u16 status = le16_to_cpup(&cqe->status) >> 1;
-	int error = 0;
 
 	if (unlikely(status)) {
-		if (!(status & NVME_SC_DNR ||
-				bio->bi_rw & REQ_FAILFAST_MASK) &&
-				(jiffies - iod->start_time) < IOD_TIMEOUT) {
-			if (!waitqueue_active(&nvmeq->sq_full))
-				add_wait_queue(&nvmeq->sq_full,
-							&nvmeq->sq_cong_wait);
-			list_add_tail(&iod->node, &nvmeq->iod_bio);
-			wake_up(&nvmeq->sq_full);
+		if (!(status & NVME_SC_DNR || blk_noretry_request(req))
+		    && (jiffies - req->start_time) < req->timeout) {
+			blk_mq_requeue_request(req);
+			blk_mq_kick_requeue_list(req->q);
 			return;
 		}
-		error = -EIO;
-	}
-	if (iod->nents) {
-		dma_unmap_sg(nvmeq->q_dmadev, iod->sg, iod->nents,
-			bio_data_dir(bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		nvme_end_io_acct(bio, iod->start_time);
-	}
+		req->errors = -EIO;
+	} else
+		req->errors = 0;
+
+	if (cmd_rq->aborted)
+		dev_warn(&nvmeq->dev->pci_dev->dev,
+			"completing aborted command with status:%04x\n",
+			status);
+
+	if (iod->nents)
+		dma_unmap_sg(&nvmeq->dev->pci_dev->dev, iod->sg, iod->nents,
+			rq_data_dir(req) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 	nvme_free_iod(nvmeq->dev, iod);
 
-	trace_block_bio_complete(bdev_get_queue(bio->bi_bdev), bio, error);
-	bio_endio(bio, error);
+	blk_mq_complete_request(req);
 }
 
 /* length is in bytes.  gfp flags indicates whether we may sleep. */
@@ -544,88 +487,25 @@ int nvme_setup_prps(struct nvme_dev *dev, struct nvme_iod *iod, int total_len,
 	return total_len;
 }
 
-static int nvme_split_and_submit(struct bio *bio, struct nvme_queue *nvmeq,
-				 int len)
-{
-	struct bio *split = bio_split(bio, len >> 9, GFP_ATOMIC, NULL);
-	if (!split)
-		return -ENOMEM;
-
-	trace_block_split(bdev_get_queue(bio->bi_bdev), bio,
-					split->bi_iter.bi_sector);
-	bio_chain(split, bio);
-
-	if (!waitqueue_active(&nvmeq->sq_full))
-		add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
-	bio_list_add(&nvmeq->sq_cong, split);
-	bio_list_add(&nvmeq->sq_cong, bio);
-	wake_up(&nvmeq->sq_full);
-
-	return 0;
-}
-
-/* NVMe scatterlists require no holes in the virtual address */
-#define BIOVEC_NOT_VIRT_MERGEABLE(vec1, vec2)	((vec2)->bv_offset || \
-			(((vec1)->bv_offset + (vec1)->bv_len) % PAGE_SIZE))
-
-static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
-		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
-{
-	struct bio_vec bvec, bvprv;
-	struct bvec_iter iter;
-	struct scatterlist *sg = NULL;
-	int length = 0, nsegs = 0, split_len = bio->bi_iter.bi_size;
-	int first = 1;
-
-	if (nvmeq->dev->stripe_size)
-		split_len = nvmeq->dev->stripe_size -
-			((bio->bi_iter.bi_sector << 9) &
-			 (nvmeq->dev->stripe_size - 1));
-
-	sg_init_table(iod->sg, psegs);
-	bio_for_each_segment(bvec, bio, iter) {
-		if (!first && BIOVEC_PHYS_MERGEABLE(&bvprv, &bvec)) {
-			sg->length += bvec.bv_len;
-		} else {
-			if (!first && BIOVEC_NOT_VIRT_MERGEABLE(&bvprv, &bvec))
-				return nvme_split_and_submit(bio, nvmeq,
-							     length);
-
-			sg = sg ? sg + 1 : iod->sg;
-			sg_set_page(sg, bvec.bv_page,
-				    bvec.bv_len, bvec.bv_offset);
-			nsegs++;
-		}
-
-		if (split_len - length < bvec.bv_len)
-			return nvme_split_and_submit(bio, nvmeq, split_len);
-		length += bvec.bv_len;
-		bvprv = bvec;
-		first = 0;
-	}
-	iod->nents = nsegs;
-	sg_mark_end(sg);
-	if (dma_map_sg(nvmeq->q_dmadev, iod->sg, iod->nents, dma_dir) == 0)
-		return -ENOMEM;
-
-	BUG_ON(length != bio->bi_iter.bi_size);
-	return length;
-}
-
-static int nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
-		struct bio *bio, struct nvme_iod *iod, int cmdid)
+/*
+ * We reuse the small pool to allocate the 16-byte range here as it is not
+ * worth having a special pool for these or additional cases to handle freeing
+ * the iod.
+ */
+static void nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
+		struct request *req, struct nvme_iod *iod)
 {
 	struct nvme_dsm_range *range =
 				(struct nvme_dsm_range *)iod_list(iod)[0];
 	struct nvme_command *cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
 
 	range->cattr = cpu_to_le32(0);
-	range->nlb = cpu_to_le32(bio->bi_iter.bi_size >> ns->lba_shift);
-	range->slba = cpu_to_le64(nvme_block_nr(ns, bio->bi_iter.bi_sector));
+	range->nlb = cpu_to_le32(blk_rq_bytes(req) >> ns->lba_shift);
+	range->slba = cpu_to_le64(nvme_block_nr(ns, blk_rq_pos(req)));
 
 	memset(cmnd, 0, sizeof(*cmnd));
 	cmnd->dsm.opcode = nvme_cmd_dsm;
-	cmnd->dsm.command_id = cmdid;
+	cmnd->dsm.command_id = req->tag;
 	cmnd->dsm.nsid = cpu_to_le32(ns->ns_id);
 	cmnd->dsm.prp1 = cpu_to_le64(iod->first_dma);
 	cmnd->dsm.nr = 0;
@@ -634,11 +514,9 @@ static int nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	if (++nvmeq->sq_tail == nvmeq->q_depth)
 		nvmeq->sq_tail = 0;
 	writel(nvmeq->sq_tail, nvmeq->q_db);
-
-	return 0;
 }
 
-static int nvme_submit_flush(struct nvme_queue *nvmeq, struct nvme_ns *ns,
+static void nvme_submit_flush(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 								int cmdid)
 {
 	struct nvme_command *cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
@@ -651,49 +529,34 @@ static int nvme_submit_flush(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	if (++nvmeq->sq_tail == nvmeq->q_depth)
 		nvmeq->sq_tail = 0;
 	writel(nvmeq->sq_tail, nvmeq->q_db);
-
-	return 0;
 }
 
-static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod)
+static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod,
+							struct nvme_ns *ns)
 {
-	struct bio *bio = iod->private;
-	struct nvme_ns *ns = bio->bi_bdev->bd_disk->private_data;
+	struct request *req = iod->private;
 	struct nvme_command *cmnd;
-	int cmdid;
-	u16 control;
-	u32 dsmgmt;
+	u16 control = 0;
+	u32 dsmgmt = 0;
 
-	cmdid = alloc_cmdid(nvmeq, iod, bio_completion, NVME_IO_TIMEOUT);
-	if (unlikely(cmdid < 0))
-		return cmdid;
-
-	if (bio->bi_rw & REQ_DISCARD)
-		return nvme_submit_discard(nvmeq, ns, bio, iod, cmdid);
-	if (bio->bi_rw & REQ_FLUSH)
-		return nvme_submit_flush(nvmeq, ns, cmdid);
-
-	control = 0;
-	if (bio->bi_rw & REQ_FUA)
+	if (req->cmd_flags & REQ_FUA)
 		control |= NVME_RW_FUA;
-	if (bio->bi_rw & (REQ_FAILFAST_DEV | REQ_RAHEAD))
+	if (req->cmd_flags & (REQ_FAILFAST_DEV | REQ_RAHEAD))
 		control |= NVME_RW_LR;
 
-	dsmgmt = 0;
-	if (bio->bi_rw & REQ_RAHEAD)
+	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
 
 	cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
 	memset(cmnd, 0, sizeof(*cmnd));
 
-	cmnd->rw.opcode = bio_data_dir(bio) ? nvme_cmd_write : nvme_cmd_read;
-	cmnd->rw.command_id = cmdid;
+	cmnd->rw.opcode = (rq_data_dir(req) ? nvme_cmd_write : nvme_cmd_read);
+	cmnd->rw.command_id = req->tag;
 	cmnd->rw.nsid = cpu_to_le32(ns->ns_id);
 	cmnd->rw.prp1 = cpu_to_le64(sg_dma_address(iod->sg));
 	cmnd->rw.prp2 = cpu_to_le64(iod->first_dma);
-	cmnd->rw.slba = cpu_to_le64(nvme_block_nr(ns, bio->bi_iter.bi_sector));
-	cmnd->rw.length =
-		cpu_to_le16((bio->bi_iter.bi_size >> ns->lba_shift) - 1);
+	cmnd->rw.slba = cpu_to_le64(nvme_block_nr(ns, blk_rq_pos(req)));
+	cmnd->rw.length = cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
 	cmnd->rw.control = cpu_to_le16(control);
 	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
 
@@ -704,45 +567,32 @@ static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod)
 	return 0;
 }
 
-static int nvme_split_flush_data(struct nvme_queue *nvmeq, struct bio *bio)
-{
-	struct bio *split = bio_clone(bio, GFP_ATOMIC);
-	if (!split)
-		return -ENOMEM;
-
-	split->bi_iter.bi_size = 0;
-	split->bi_phys_segments = 0;
-	bio->bi_rw &= ~REQ_FLUSH;
-	bio_chain(split, bio);
-
-	if (!waitqueue_active(&nvmeq->sq_full))
-		add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
-	bio_list_add(&nvmeq->sq_cong, split);
-	bio_list_add(&nvmeq->sq_cong, bio);
-	wake_up_process(nvme_thread);
-
-	return 0;
-}
-
-/*
- * Called with local interrupts disabled and the q_lock held.  May not sleep.
- */
-static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
-								struct bio *bio)
+static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 {
+	struct nvme_ns *ns = hctx->queue->queuedata;
+	struct nvme_queue *nvmeq = hctx->driver_data;
+	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
 	struct nvme_iod *iod;
-	int psegs = bio_phys_segments(ns->queue, bio);
-	int result;
+	enum dma_data_direction dma_dir;
+	int psegs = req->nr_phys_segments;
+	int result = BLK_MQ_RQ_QUEUE_BUSY;
+	/*
+	 * Requeued IO has already been prepped
+	 */
+	iod = req->special;
+	if (iod)
+		goto submit_iod;
 
-	if ((bio->bi_rw & REQ_FLUSH) && psegs)
-		return nvme_split_flush_data(nvmeq, bio);
-
-	iod = nvme_alloc_iod(psegs, bio->bi_iter.bi_size, GFP_ATOMIC);
+	iod = nvme_alloc_iod(psegs, blk_rq_bytes(req), GFP_ATOMIC);
 	if (!iod)
-		return -ENOMEM;
+		return result;
 
-	iod->private = bio;
-	if (bio->bi_rw & REQ_DISCARD) {
+	iod->private = req;
+	req->special = iod;
+
+	nvme_set_info(cmd, iod, req_completion);
+
+	if (req->cmd_flags & REQ_DISCARD) {
 		void *range;
 		/*
 		 * We reuse the small pool to allocate the 16-byte range here
@@ -752,33 +602,53 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 		range = dma_pool_alloc(nvmeq->dev->prp_small_pool,
 						GFP_ATOMIC,
 						&iod->first_dma);
-		if (!range) {
-			result = -ENOMEM;
-			goto free_iod;
-		}
+		if (!range)
+			goto finish_cmd;
 		iod_list(iod)[0] = (__le64 *)range;
 		iod->npages = 0;
 	} else if (psegs) {
-		result = nvme_map_bio(nvmeq, iod, bio,
-			bio_data_dir(bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-			psegs);
-		if (result <= 0)
-			goto free_iod;
-		if (nvme_setup_prps(nvmeq->dev, iod, result, GFP_ATOMIC) !=
-								result) {
-			result = -ENOMEM;
-			goto free_iod;
+		dma_dir = rq_data_dir(req) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+
+		sg_init_table(iod->sg, psegs);
+		iod->nents = blk_rq_map_sg(req->q, req, iod->sg);
+		if (!iod->nents) {
+			result = BLK_MQ_RQ_QUEUE_ERROR;
+			goto finish_cmd;
 		}
-		nvme_start_io_acct(bio);
+
+		if (!dma_map_sg(nvmeq->q_dmadev, iod->sg, iod->nents, dma_dir))
+			goto finish_cmd;
+
+		if (blk_rq_bytes(req) != nvme_setup_prps(nvmeq->dev, iod,
+						blk_rq_bytes(req), GFP_ATOMIC))
+			goto finish_cmd;
+	}
+
+ submit_iod:
+	spin_lock_irq(&nvmeq->q_lock);
+	if (nvmeq->q_suspended) {
+		spin_unlock_irq(&nvmeq->q_lock);
+		goto finish_cmd;
 	}
-	if (unlikely(nvme_submit_iod(nvmeq, iod))) {
-		if (!waitqueue_active(&nvmeq->sq_full))
-			add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
-		list_add_tail(&iod->node, &nvmeq->iod_bio);
+
+	if (req->cmd_flags & REQ_DISCARD) {
+		nvme_submit_discard(nvmeq, ns, req, iod);
+		goto queued;
+	}
+
+	if (req->cmd_flags & REQ_FLUSH) {
+		nvme_submit_flush(nvmeq, ns, req->tag);
+		goto queued;
 	}
-	return 0;
 
- free_iod:
+	nvme_submit_iod(nvmeq, iod, ns);
+ queued:
+	nvme_process_cq(nvmeq);
+	spin_unlock_irq(&nvmeq->q_lock);
+	return BLK_MQ_RQ_QUEUE_OK;
+
+ finish_cmd:
+	nvme_finish_cmd(nvmeq, req->tag, NULL);
 	nvme_free_iod(nvmeq->dev, iod);
 	return result;
 }
@@ -801,8 +671,7 @@ static int nvme_process_cq(struct nvme_queue *nvmeq)
 			head = 0;
 			phase = !phase;
 		}
-
-		ctx = free_cmdid(nvmeq, cqe.command_id, &fn);
+		ctx = nvme_finish_cmd(nvmeq, cqe.command_id, &fn);
 		fn(nvmeq, ctx, &cqe);
 	}
 
@@ -823,29 +692,12 @@ static int nvme_process_cq(struct nvme_queue *nvmeq)
 	return 1;
 }
 
-static void nvme_make_request(struct request_queue *q, struct bio *bio)
+/* Admin queue isn't initialized as a request queue. If at some point this
+ * happens anyway, make sure to notify the user */
+static int nvme_admin_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 {
-	struct nvme_ns *ns = q->queuedata;
-	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
-	int result = -EBUSY;
-
-	if (!nvmeq) {
-		bio_endio(bio, -EIO);
-		return;
-	}
-
-	spin_lock_irq(&nvmeq->q_lock);
-	if (!nvmeq->q_suspended && bio_list_empty(&nvmeq->sq_cong))
-		result = nvme_submit_bio_queue(nvmeq, ns, bio);
-	if (unlikely(result)) {
-		if (!waitqueue_active(&nvmeq->sq_full))
-			add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
-		bio_list_add(&nvmeq->sq_cong, bio);
-	}
-
-	nvme_process_cq(nvmeq);
-	spin_unlock_irq(&nvmeq->q_lock);
-	put_nvmeq(nvmeq);
+	WARN_ON_ONCE(1);
+	return BLK_MQ_RQ_QUEUE_ERROR;
 }
 
 static irqreturn_t nvme_irq(int irq, void *data)
@@ -869,10 +721,11 @@ static irqreturn_t nvme_irq_check(int irq, void *data)
 	return IRQ_WAKE_THREAD;
 }
 
-static void nvme_abort_command(struct nvme_queue *nvmeq, int cmdid)
+static void nvme_abort_cmd_info(struct nvme_queue *nvmeq, struct nvme_cmd_info *
+								cmd_info)
 {
 	spin_lock_irq(&nvmeq->q_lock);
-	cancel_cmdid(nvmeq, cmdid, NULL);
+	cancel_cmd_info(cmd_info, NULL);
 	spin_unlock_irq(&nvmeq->q_lock);
 }
 
@@ -895,45 +748,31 @@ static void sync_completion(struct nvme_queue *nvmeq, void *ctx,
  * Returns 0 on success.  If the result is negative, it's a Linux error code;
  * if the result is positive, it's an NVM Express status code
  */
-static int nvme_submit_sync_cmd(struct nvme_dev *dev, int q_idx,
-						struct nvme_command *cmd,
+static int nvme_submit_sync_cmd(struct request *req, struct nvme_command *cmd,
 						u32 *result, unsigned timeout)
 {
-	int cmdid, ret;
+	int ret;
 	struct sync_cmd_info cmdinfo;
-	struct nvme_queue *nvmeq;
-
-	nvmeq = lock_nvmeq(dev, q_idx);
-	if (!nvmeq)
-		return -ENODEV;
+	struct nvme_cmd_info *cmd_rq = blk_mq_rq_to_pdu(req);
+	struct nvme_queue *nvmeq = cmd_rq->nvmeq;
 
 	cmdinfo.task = current;
 	cmdinfo.status = -EINTR;
 
-	cmdid = alloc_cmdid(nvmeq, &cmdinfo, sync_completion, timeout);
-	if (cmdid < 0) {
-		unlock_nvmeq(nvmeq);
-		return cmdid;
-	}
-	cmd->common.command_id = cmdid;
+	cmd->common.command_id = req->tag;
+
+	nvme_set_info(cmd_rq, &cmdinfo, sync_completion);
 
 	set_current_state(TASK_KILLABLE);
 	ret = nvme_submit_cmd(nvmeq, cmd);
 	if (ret) {
-		free_cmdid(nvmeq, cmdid, NULL);
-		unlock_nvmeq(nvmeq);
+		nvme_finish_cmd(nvmeq, req->tag, NULL);
 		set_current_state(TASK_RUNNING);
-		return ret;
 	}
-	unlock_nvmeq(nvmeq);
 	schedule_timeout(timeout);
 
 	if (cmdinfo.status == -EINTR) {
-		nvmeq = lock_nvmeq(dev, q_idx);
-		if (nvmeq) {
-			nvme_abort_command(nvmeq, cmdid);
-			unlock_nvmeq(nvmeq);
-		}
+		nvme_abort_cmd_info(nvmeq, blk_mq_rq_to_pdu(req));
 		return -EINTR;
 	}
 
@@ -943,59 +782,78 @@ static int nvme_submit_sync_cmd(struct nvme_dev *dev, int q_idx,
 	return cmdinfo.status;
 }
 
-static int nvme_submit_async_cmd(struct nvme_queue *nvmeq,
+static int nvme_submit_admin_async_cmd(struct nvme_dev *dev,
 			struct nvme_command *cmd,
 			struct async_cmd_info *cmdinfo, unsigned timeout)
 {
-	int cmdid;
+	struct nvme_queue *nvmeq = dev->queues[0];
+	struct request *req;
+	struct nvme_cmd_info *cmd_rq;
 
-	cmdid = alloc_cmdid_killable(nvmeq, cmdinfo, async_completion, timeout);
-	if (cmdid < 0)
-		return cmdid;
+	req = blk_mq_alloc_request(dev->admin_q, WRITE, GFP_KERNEL, false);
+	if (!req)
+		return -ENOMEM;
+
+	req->timeout = timeout;
+	cmd_rq = blk_mq_rq_to_pdu(req);
+	cmdinfo->req = req;
+	nvme_set_info(cmd_rq, cmdinfo, async_completion);
 	cmdinfo->status = -EINTR;
-	cmd->common.command_id = cmdid;
+
+	cmd->common.command_id = req->tag;
+
 	return nvme_submit_cmd(nvmeq, cmd);
 }
 
+int __nvme_submit_admin_cmd(struct nvme_dev *dev, struct nvme_command *cmd,
+						u32 *result, unsigned timeout)
+{
+	int res;
+	struct request *req;
+
+	req = blk_mq_alloc_request(dev->admin_q, WRITE, GFP_KERNEL, false);
+	if (!req)
+		return -ENOMEM;
+	res = nvme_submit_sync_cmd(req, cmd, result, timeout);
+	blk_put_request(req);
+	return res;
+}
+
 int nvme_submit_admin_cmd(struct nvme_dev *dev, struct nvme_command *cmd,
 								u32 *result)
 {
-	return nvme_submit_sync_cmd(dev, 0, cmd, result, ADMIN_TIMEOUT);
+	return __nvme_submit_admin_cmd(dev, cmd, result, ADMIN_TIMEOUT);
 }
 
-int nvme_submit_io_cmd(struct nvme_dev *dev, struct nvme_command *cmd,
-								u32 *result)
+int nvme_submit_io_cmd(struct nvme_dev *dev, struct nvme_ns *ns,
+					struct nvme_command *cmd, u32 *result)
 {
-	return nvme_submit_sync_cmd(dev, smp_processor_id() + 1, cmd, result,
-							NVME_IO_TIMEOUT);
-}
+	int res;
+	struct request *req;
 
-static int nvme_submit_admin_cmd_async(struct nvme_dev *dev,
-		struct nvme_command *cmd, struct async_cmd_info *cmdinfo)
-{
-	return nvme_submit_async_cmd(raw_nvmeq(dev, 0), cmd, cmdinfo,
-								ADMIN_TIMEOUT);
+	req = blk_mq_alloc_request(ns->queue, WRITE, (GFP_KERNEL|__GFP_WAIT),
+									false);
+	if (!req)
+		return -ENOMEM;
+	res = nvme_submit_sync_cmd(req, cmd, result, NVME_IO_TIMEOUT);
+	blk_put_request(req);
+	return res;
 }
 
 static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)
 {
-	int status;
 	struct nvme_command c;
 
 	memset(&c, 0, sizeof(c));
 	c.delete_queue.opcode = opcode;
 	c.delete_queue.qid = cpu_to_le16(id);
 
-	status = nvme_submit_admin_cmd(dev, &c, NULL);
-	if (status)
-		return -EIO;
-	return 0;
+	return nvme_submit_admin_cmd(dev, &c, NULL);
 }
 
 static int adapter_alloc_cq(struct nvme_dev *dev, u16 qid,
 						struct nvme_queue *nvmeq)
 {
-	int status;
 	struct nvme_command c;
 	int flags = NVME_QUEUE_PHYS_CONTIG | NVME_CQ_IRQ_ENABLED;
 
@@ -1007,16 +865,12 @@ static int adapter_alloc_cq(struct nvme_dev *dev, u16 qid,
 	c.create_cq.cq_flags = cpu_to_le16(flags);
 	c.create_cq.irq_vector = cpu_to_le16(nvmeq->cq_vector);
 
-	status = nvme_submit_admin_cmd(dev, &c, NULL);
-	if (status)
-		return -EIO;
-	return 0;
+	return nvme_submit_admin_cmd(dev, &c, NULL);
 }
 
 static int adapter_alloc_sq(struct nvme_dev *dev, u16 qid,
 						struct nvme_queue *nvmeq)
 {
-	int status;
 	struct nvme_command c;
 	int flags = NVME_QUEUE_PHYS_CONTIG | NVME_SQ_PRIO_MEDIUM;
 
@@ -1028,10 +882,7 @@ static int adapter_alloc_sq(struct nvme_dev *dev, u16 qid,
 	c.create_sq.sq_flags = cpu_to_le16(flags);
 	c.create_sq.cqid = cpu_to_le16(qid);
 
-	status = nvme_submit_admin_cmd(dev, &c, NULL);
-	if (status)
-		return -EIO;
-	return 0;
+	return nvme_submit_admin_cmd(dev, &c, NULL);
 }
 
 static int adapter_delete_cq(struct nvme_dev *dev, u16 cqid)
@@ -1087,28 +938,27 @@ int nvme_set_features(struct nvme_dev *dev, unsigned fid, unsigned dword11,
 }
 
 /**
- * nvme_abort_cmd - Attempt aborting a command
- * @cmdid: Command id of a timed out IO
- * @queue: The queue with timed out IO
+ * nvme_abort_req - Attempt aborting a request
  *
  * Schedule controller reset if the command was already aborted once before and
  * still hasn't been returned to the driver, or if this is the admin queue.
  */
-static void nvme_abort_cmd(int cmdid, struct nvme_queue *nvmeq)
+static void nvme_abort_req(struct request *req)
 {
-	int a_cmdid;
+	struct nvme_cmd_info *cmd_rq = blk_mq_rq_to_pdu(req);
+	struct nvme_queue *nvmeq = cmd_rq->nvmeq;
+	struct nvme_dev *dev = nvmeq->dev;
+	struct request *abort_req;
+	struct nvme_cmd_info *abort_cmd;
 	struct nvme_command cmd;
-	struct nvme_dev *dev = nvmeq->dev;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
-	struct nvme_queue *adminq;
 
-	if (!nvmeq->qid || info[cmdid].aborted) {
+	if (!nvmeq->qid || cmd_rq->aborted) {
 		if (work_busy(&dev->reset_work))
 			return;
 		list_del_init(&dev->node);
 		dev_warn(&dev->pci_dev->dev,
-			"I/O %d QID %d timeout, reset controller\n", cmdid,
-								nvmeq->qid);
+			"I/O %d QID %d timeout, reset controller\n",
+							req->tag, nvmeq->qid);
 		dev->reset_workfn = nvme_reset_failed_dev;
 		queue_work(nvme_workq, &dev->reset_work);
 		return;
@@ -1117,89 +967,88 @@ static void nvme_abort_cmd(int cmdid, struct nvme_queue *nvmeq)
 	if (!dev->abort_limit)
 		return;
 
-	adminq = rcu_dereference(dev->queues[0]);
-	a_cmdid = alloc_cmdid(adminq, CMD_CTX_ABORT, special_completion,
-								ADMIN_TIMEOUT);
-	if (a_cmdid < 0)
+	abort_req = blk_mq_alloc_request(dev->admin_q, WRITE, GFP_ATOMIC,
+									false);
+	if (!abort_req)
 		return;
 
+	abort_cmd = blk_mq_rq_to_pdu(abort_req);
+	nvme_set_info(abort_cmd, abort_req, abort_completion);
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.abort.opcode = nvme_admin_abort_cmd;
-	cmd.abort.cid = cmdid;
+	cmd.abort.cid = req->tag;
 	cmd.abort.sqid = cpu_to_le16(nvmeq->qid);
-	cmd.abort.command_id = a_cmdid;
+	cmd.abort.command_id = abort_req->tag;
 
 	--dev->abort_limit;
-	info[cmdid].aborted = 1;
-	info[cmdid].timeout = jiffies + ADMIN_TIMEOUT;
+	cmd_rq->aborted = 1;
 
-	dev_warn(nvmeq->q_dmadev, "Aborting I/O %d QID %d\n", cmdid,
+	dev_warn(nvmeq->q_dmadev, "Aborting I/O %d QID %d\n", req->tag,
 							nvmeq->qid);
-	nvme_submit_cmd(adminq, &cmd);
+	if (nvme_submit_cmd(dev->queues[0], &cmd) < 0) {
+		dev_warn(nvmeq->q_dmadev,
+				"Could not abort I/O %d QID %d",
+				req->tag, nvmeq->qid);
+	}
 }
 
-/**
- * nvme_cancel_ios - Cancel outstanding I/Os
- * @queue: The queue to cancel I/Os on
- * @timeout: True to only cancel I/Os which have timed out
- */
-static void nvme_cancel_ios(struct nvme_queue *nvmeq, bool timeout)
+static void nvme_cancel_queue_ios(void *data, unsigned long *tag_map)
 {
-	int depth = nvmeq->q_depth - 1;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
-	unsigned long now = jiffies;
-	int cmdid;
+	struct nvme_queue *nvmeq = data;
+	struct blk_mq_hw_ctx *hctx = nvmeq->hctx;
+	unsigned int tag = 0;
 
-	for_each_set_bit(cmdid, nvmeq->cmdid_data, depth) {
+	tag = 0;
+	do {
+		struct request *req;
 		void *ctx;
 		nvme_completion_fn fn;
+		struct nvme_cmd_info *cmd;
 		static struct nvme_completion cqe = {
 			.status = cpu_to_le16(NVME_SC_ABORT_REQ << 1),
 		};
+		int qdepth = nvmeq == nvmeq->dev->queues[0] ?
+					nvmeq->dev->admin_tagset.queue_depth :
+					nvmeq->dev->tagset.queue_depth;
 
-		if (timeout && !time_after(now, info[cmdid].timeout))
-			continue;
-		if (info[cmdid].ctx == CMD_CTX_CANCELLED)
-			continue;
-		if (timeout && nvmeq->dev->initialized) {
-			nvme_abort_cmd(cmdid, nvmeq);
+		/* zero'd bits are free tags */
+		tag = find_next_zero_bit(tag_map, qdepth, tag);
+		if (tag >= qdepth)
+			break;
+
+		req = blk_mq_tag_to_rq(hctx->tags, tag++);
+		cmd = blk_mq_rq_to_pdu(req);
+
+		if (cmd->ctx == CMD_CTX_CANCELLED)
 			continue;
-		}
-		dev_warn(nvmeq->q_dmadev, "Cancelling I/O %d QID %d\n", cmdid,
-								nvmeq->qid);
-		ctx = cancel_cmdid(nvmeq, cmdid, &fn);
+
+		dev_warn(nvmeq->q_dmadev, "Cancelling I/O %d QID %d\n",
+							req->tag, nvmeq->qid);
+		ctx = cancel_cmd_info(cmd, &fn);
 		fn(nvmeq, ctx, &cqe);
-	}
+	} while (1);
 }
 
-static void nvme_free_queue(struct rcu_head *r)
+static enum blk_eh_timer_return nvme_timeout(struct request *req)
 {
-	struct nvme_queue *nvmeq = container_of(r, struct nvme_queue, r_head);
+	struct nvme_cmd_info *cmd = blk_mq_rq_to_pdu(req);
+	struct nvme_queue *nvmeq = cmd->nvmeq;
 
-	spin_lock_irq(&nvmeq->q_lock);
-	while (bio_list_peek(&nvmeq->sq_cong)) {
-		struct bio *bio = bio_list_pop(&nvmeq->sq_cong);
-		bio_endio(bio, -EIO);
-	}
-	while (!list_empty(&nvmeq->iod_bio)) {
-		static struct nvme_completion cqe = {
-			.status = cpu_to_le16(
-				(NVME_SC_ABORT_REQ | NVME_SC_DNR) << 1),
-		};
-		struct nvme_iod *iod = list_first_entry(&nvmeq->iod_bio,
-							struct nvme_iod,
-							node);
-		list_del(&iod->node);
-		bio_completion(nvmeq, iod, &cqe);
-	}
-	spin_unlock_irq(&nvmeq->q_lock);
+	dev_warn(nvmeq->q_dmadev, "Timeout I/O %d QID %d\n", req->tag,
+							nvmeq->qid);
+	if (nvmeq->dev->initialized)
+		nvme_abort_req(req);
 
+	return BLK_EH_RESET_TIMER;
+}
+
+static void nvme_free_queue(struct nvme_queue *nvmeq)
+{
 	dma_free_coherent(nvmeq->q_dmadev, CQ_SIZE(nvmeq->q_depth),
 				(void *)nvmeq->cqes, nvmeq->cq_dma_addr);
 	dma_free_coherent(nvmeq->q_dmadev, SQ_SIZE(nvmeq->q_depth),
 					nvmeq->sq_cmds, nvmeq->sq_dma_addr);
-	if (nvmeq->qid)
-		free_cpumask_var(nvmeq->cpu_mask);
 	kfree(nvmeq);
 }
 
@@ -1208,10 +1057,10 @@ static void nvme_free_queues(struct nvme_dev *dev, int lowest)
 	int i;
 
 	for (i = dev->queue_count - 1; i >= lowest; i--) {
-		struct nvme_queue *nvmeq = raw_nvmeq(dev, i);
-		rcu_assign_pointer(dev->queues[i], NULL);
-		call_rcu(&nvmeq->r_head, nvme_free_queue);
+		struct nvme_queue *nvmeq = dev->queues[i];
 		dev->queue_count--;
+		dev->queues[i] = NULL;
+		nvme_free_queue(nvmeq);
 	}
 }
 
@@ -1242,15 +1091,18 @@ static int nvme_suspend_queue(struct nvme_queue *nvmeq)
 
 static void nvme_clear_queue(struct nvme_queue *nvmeq)
 {
+	struct blk_mq_hw_ctx *hctx = nvmeq->hctx;
+
 	spin_lock_irq(&nvmeq->q_lock);
 	nvme_process_cq(nvmeq);
-	nvme_cancel_ios(nvmeq, false);
+	if (hctx && hctx->tags)
+		blk_mq_tag_busy_iter(hctx->tags, nvme_cancel_queue_ios, nvmeq);
 	spin_unlock_irq(&nvmeq->q_lock);
 }
 
 static void nvme_disable_queue(struct nvme_dev *dev, int qid)
 {
-	struct nvme_queue *nvmeq = raw_nvmeq(dev, qid);
+	struct nvme_queue *nvmeq = dev->queues[qid];
 
 	if (!nvmeq)
 		return;
@@ -1270,8 +1122,7 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,
 							int depth, int vector)
 {
 	struct device *dmadev = &dev->pci_dev->dev;
-	unsigned extra = nvme_queue_extra(depth);
-	struct nvme_queue *nvmeq = kzalloc(sizeof(*nvmeq) + extra, GFP_KERNEL);
+	struct nvme_queue *nvmeq = kzalloc(sizeof(*nvmeq), GFP_KERNEL);
 	if (!nvmeq)
 		return NULL;
 
@@ -1286,9 +1137,6 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,
 	if (!nvmeq->sq_cmds)
 		goto free_cqdma;
 
-	if (qid && !zalloc_cpumask_var(&nvmeq->cpu_mask, GFP_KERNEL))
-		goto free_sqdma;
-
 	nvmeq->q_dmadev = dmadev;
 	nvmeq->dev = dev;
 	snprintf(nvmeq->irqname, sizeof(nvmeq->irqname), "nvme%dq%d",
@@ -1296,23 +1144,16 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,
 	spin_lock_init(&nvmeq->q_lock);
 	nvmeq->cq_head = 0;
 	nvmeq->cq_phase = 1;
-	init_waitqueue_head(&nvmeq->sq_full);
-	init_waitqueue_entry(&nvmeq->sq_cong_wait, nvme_thread);
-	bio_list_init(&nvmeq->sq_cong);
-	INIT_LIST_HEAD(&nvmeq->iod_bio);
 	nvmeq->q_db = &dev->dbs[qid * 2 * dev->db_stride];
 	nvmeq->q_depth = depth;
 	nvmeq->cq_vector = vector;
 	nvmeq->qid = qid;
 	nvmeq->q_suspended = 1;
 	dev->queue_count++;
-	rcu_assign_pointer(dev->queues[qid], nvmeq);
+	dev->queues[qid] = nvmeq;
 
 	return nvmeq;
 
- free_sqdma:
-	dma_free_coherent(dmadev, SQ_SIZE(depth), (void *)nvmeq->sq_cmds,
-							nvmeq->sq_dma_addr);
  free_cqdma:
 	dma_free_coherent(dmadev, CQ_SIZE(depth), (void *)nvmeq->cqes,
 							nvmeq->cq_dma_addr);
@@ -1335,15 +1176,12 @@ static int queue_request_irq(struct nvme_dev *dev, struct nvme_queue *nvmeq,
 static void nvme_init_queue(struct nvme_queue *nvmeq, u16 qid)
 {
 	struct nvme_dev *dev = nvmeq->dev;
-	unsigned extra = nvme_queue_extra(nvmeq->q_depth);
 
 	nvmeq->sq_tail = 0;
 	nvmeq->cq_head = 0;
 	nvmeq->cq_phase = 1;
 	nvmeq->q_db = &dev->dbs[qid * 2 * dev->db_stride];
-	memset(nvmeq->cmdid_data, 0, extra);
 	memset((void *)nvmeq->cqes, 0, CQ_SIZE(nvmeq->q_depth));
-	nvme_cancel_ios(nvmeq, false);
 	nvmeq->q_suspended = 0;
 	dev->online_queues++;
 }
@@ -1444,6 +1282,52 @@ static int nvme_shutdown_ctrl(struct nvme_dev *dev)
 	return 0;
 }
 
+static struct blk_mq_ops nvme_mq_admin_ops = {
+	.queue_rq	= nvme_admin_queue_rq,
+	.map_queue	= blk_mq_map_queue,
+	.init_hctx	= nvme_admin_init_hctx,
+	.init_request	= nvme_admin_init_request,
+	.timeout	= nvme_timeout,
+};
+
+static struct blk_mq_ops nvme_mq_ops = {
+	.queue_rq	= nvme_queue_rq,
+	.map_queue	= blk_mq_map_queue,
+	.init_hctx	= nvme_init_hctx,
+	.init_request	= nvme_init_request,
+	.timeout	= nvme_timeout,
+};
+
+static int nvme_alloc_admin_tags(struct nvme_dev *dev)
+{
+	if (!dev->admin_q) {
+		dev->admin_tagset.ops = &nvme_mq_admin_ops;
+		dev->admin_tagset.nr_hw_queues = 1;
+		dev->admin_tagset.queue_depth = NVME_AQ_DEPTH;
+		dev->admin_tagset.timeout = ADMIN_TIMEOUT;
+		dev->admin_tagset.numa_node = dev_to_node(&dev->pci_dev->dev);
+		dev->admin_tagset.cmd_size = sizeof(struct nvme_cmd_info);
+		dev->admin_tagset.driver_data = dev;
+
+		if (blk_mq_alloc_tag_set(&dev->admin_tagset))
+			return -ENOMEM;
+
+		dev->admin_q = blk_mq_init_queue(&dev->admin_tagset);
+		if (!dev->admin_q) {
+			blk_mq_free_tag_set(&dev->admin_tagset);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static void nvme_free_admin_tags(struct nvme_dev *dev)
+{
+	if (dev->admin_q)
+		blk_mq_free_tag_set(&dev->admin_tagset);
+}
+
 static int nvme_configure_admin_queue(struct nvme_dev *dev)
 {
 	int result;
@@ -1455,9 +1339,9 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 	if (result < 0)
 		return result;
 
-	nvmeq = raw_nvmeq(dev, 0);
+	nvmeq = dev->queues[0];
 	if (!nvmeq) {
-		nvmeq = nvme_alloc_queue(dev, 0, 64, 0);
+		nvmeq = nvme_alloc_queue(dev, 0, NVME_AQ_DEPTH, 0);
 		if (!nvmeq)
 			return -ENOMEM;
 	}
@@ -1477,16 +1361,26 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 
 	result = nvme_enable_ctrl(dev, cap);
 	if (result)
-		return result;
+		goto free_nvmeq;
+
+	result = nvme_alloc_admin_tags(dev);
+	if (result)
+		goto free_nvmeq;
 
 	result = queue_request_irq(dev, nvmeq, nvmeq->irqname);
 	if (result)
-		return result;
+		goto free_tags;
 
 	spin_lock_irq(&nvmeq->q_lock);
 	nvme_init_queue(nvmeq, 0);
 	spin_unlock_irq(&nvmeq->q_lock);
 	return result;
+
+ free_tags:
+	nvme_free_admin_tags(dev);
+ free_nvmeq:
+	nvme_free_queues(dev, 0);
+	return result;
 }
 
 struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
@@ -1644,7 +1538,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	if (length != (io.nblocks + 1) << ns->lba_shift)
 		status = -ENOMEM;
 	else
-		status = nvme_submit_io_cmd(dev, &c, NULL);
+		status = nvme_submit_io_cmd(dev, ns, &c, NULL);
 
 	if (meta_len) {
 		if (status == NVME_SC_SUCCESS && !(io.opcode & 1)) {
@@ -1716,10 +1610,11 @@ static int nvme_user_admin_cmd(struct nvme_dev *dev,
 
 	timeout = cmd.timeout_ms ? msecs_to_jiffies(cmd.timeout_ms) :
 								ADMIN_TIMEOUT;
+
 	if (length != cmd.data_len)
 		status = -ENOMEM;
 	else
-		status = nvme_submit_sync_cmd(dev, 0, &c, &cmd.result, timeout);
+		status = __nvme_submit_admin_cmd(dev, &c, &cmd.result, timeout);
 
 	if (cmd.data_len) {
 		nvme_unmap_user_pages(dev, cmd.opcode & 1, iod);
@@ -1808,41 +1703,6 @@ static const struct block_device_operations nvme_fops = {
 	.getgeo		= nvme_getgeo,
 };
 
-static void nvme_resubmit_iods(struct nvme_queue *nvmeq)
-{
-	struct nvme_iod *iod, *next;
-
-	list_for_each_entry_safe(iod, next, &nvmeq->iod_bio, node) {
-		if (unlikely(nvme_submit_iod(nvmeq, iod)))
-			break;
-		list_del(&iod->node);
-		if (bio_list_empty(&nvmeq->sq_cong) &&
-						list_empty(&nvmeq->iod_bio))
-			remove_wait_queue(&nvmeq->sq_full,
-						&nvmeq->sq_cong_wait);
-	}
-}
-
-static void nvme_resubmit_bios(struct nvme_queue *nvmeq)
-{
-	while (bio_list_peek(&nvmeq->sq_cong)) {
-		struct bio *bio = bio_list_pop(&nvmeq->sq_cong);
-		struct nvme_ns *ns = bio->bi_bdev->bd_disk->private_data;
-
-		if (bio_list_empty(&nvmeq->sq_cong) &&
-						list_empty(&nvmeq->iod_bio))
-			remove_wait_queue(&nvmeq->sq_full,
-							&nvmeq->sq_cong_wait);
-		if (nvme_submit_bio_queue(nvmeq, ns, bio)) {
-			if (!waitqueue_active(&nvmeq->sq_full))
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
 	struct nvme_dev *dev, *next;
@@ -1858,28 +1718,23 @@ static int nvme_kthread(void *data)
 					continue;
 				list_del_init(&dev->node);
 				dev_warn(&dev->pci_dev->dev,
-					"Failed status, reset controller\n");
+					"Failed status: %x, reset controller\n",
+					readl(&dev->bar->csts));
 				dev->reset_workfn = nvme_reset_failed_dev;
 				queue_work(nvme_workq, &dev->reset_work);
 				continue;
 			}
-			rcu_read_lock();
 			for (i = 0; i < dev->queue_count; i++) {
-				struct nvme_queue *nvmeq =
-						rcu_dereference(dev->queues[i]);
+				struct nvme_queue *nvmeq = dev->queues[i];
 				if (!nvmeq)
 					continue;
 				spin_lock_irq(&nvmeq->q_lock);
 				if (nvmeq->q_suspended)
 					goto unlock;
 				nvme_process_cq(nvmeq);
-				nvme_cancel_ios(nvmeq, true);
-				nvme_resubmit_bios(nvmeq);
-				nvme_resubmit_iods(nvmeq);
  unlock:
 				spin_unlock_irq(&nvmeq->q_lock);
 			}
-			rcu_read_unlock();
 		}
 		spin_unlock(&dev_list_lock);
 		schedule_timeout(round_jiffies_relative(HZ));
@@ -1902,27 +1757,30 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 {
 	struct nvme_ns *ns;
 	struct gendisk *disk;
+	int node = dev_to_node(&dev->pci_dev->dev);
 	int lbaf;
 
 	if (rt->attributes & NVME_LBART_ATTRIB_HIDE)
 		return NULL;
 
-	ns = kzalloc(sizeof(*ns), GFP_KERNEL);
+	ns = kzalloc_node(sizeof(*ns), GFP_KERNEL, node);
 	if (!ns)
 		return NULL;
-	ns->queue = blk_alloc_queue(GFP_KERNEL);
+	ns->queue = blk_mq_init_queue(&dev->tagset);
 	if (!ns->queue)
 		goto out_free_ns;
-	ns->queue->queue_flags = QUEUE_FLAG_DEFAULT;
+	queue_flag_set_unlocked(QUEUE_FLAG_DEFAULT, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, ns->queue);
-	blk_queue_make_request(ns->queue, nvme_make_request);
+	queue_flag_set_unlocked(QUEUE_FLAG_SG_GAPS, ns->queue);
+	queue_flag_clear_unlocked(QUEUE_FLAG_IO_STAT, ns->queue);
 	ns->dev = dev;
 	ns->queue->queuedata = ns;
 
-	disk = alloc_disk(0);
+	disk = alloc_disk_node(0, node);
 	if (!disk)
 		goto out_free_queue;
+
 	ns->ns_id = nsid;
 	ns->disk = disk;
 	lbaf = id->flbas & 0xf;
@@ -1931,6 +1789,8 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 	blk_queue_logical_block_size(ns->queue, 1 << ns->lba_shift);
 	if (dev->max_hw_sectors)
 		blk_queue_max_hw_sectors(ns->queue, dev->max_hw_sectors);
+	if (dev->stripe_size)
+		blk_queue_chunk_sectors(ns->queue, dev->stripe_size >> 9);
 	if (dev->vwc & NVME_CTRL_VWC_PRESENT)
 		blk_queue_flush(ns->queue, REQ_FLUSH | REQ_FUA);
 
@@ -1956,143 +1816,19 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 	return NULL;
 }
 
-static int nvme_find_closest_node(int node)
-{
-	int n, val, min_val = INT_MAX, best_node = node;
-
-	for_each_online_node(n) {
-		if (n == node)
-			continue;
-		val = node_distance(node, n);
-		if (val < min_val) {
-			min_val = val;
-			best_node = n;
-		}
-	}
-	return best_node;
-}
-
-static void nvme_set_queue_cpus(cpumask_t *qmask, struct nvme_queue *nvmeq,
-								int count)
-{
-	int cpu;
-	for_each_cpu(cpu, qmask) {
-		if (cpumask_weight(nvmeq->cpu_mask) >= count)
-			break;
-		if (!cpumask_test_and_set_cpu(cpu, nvmeq->cpu_mask))
-			*per_cpu_ptr(nvmeq->dev->io_queue, cpu) = nvmeq->qid;
-	}
-}
-
-static void nvme_add_cpus(cpumask_t *mask, const cpumask_t *unassigned_cpus,
-	const cpumask_t *new_mask, struct nvme_queue *nvmeq, int cpus_per_queue)
-{
-	int next_cpu;
-	for_each_cpu(next_cpu, new_mask) {
-		cpumask_or(mask, mask, get_cpu_mask(next_cpu));
-		cpumask_or(mask, mask, topology_thread_cpumask(next_cpu));
-		cpumask_and(mask, mask, unassigned_cpus);
-		nvme_set_queue_cpus(mask, nvmeq, cpus_per_queue);
-	}
-}
-
 static void nvme_create_io_queues(struct nvme_dev *dev)
 {
-	unsigned i, max;
+	unsigned i;
 
-	max = min(dev->max_qid, num_online_cpus());
-	for (i = dev->queue_count; i <= max; i++)
+	for (i = dev->queue_count; i <= dev->max_qid; i++)
 		if (!nvme_alloc_queue(dev, i, dev->q_depth, i - 1))
 			break;
 
-	max = min(dev->queue_count - 1, num_online_cpus());
-	for (i = dev->online_queues; i <= max; i++)
-		if (nvme_create_queue(raw_nvmeq(dev, i), i))
+	for (i = dev->online_queues; i <= dev->queue_count - 1; i++)
+		if (nvme_create_queue(dev->queues[i], i))
 			break;
 }
 
-/*
- * If there are fewer queues than online cpus, this will try to optimally
- * assign a queue to multiple cpus by grouping cpus that are "close" together:
- * thread siblings, core, socket, closest node, then whatever else is
- * available.
- */
-static void nvme_assign_io_queues(struct nvme_dev *dev)
-{
-	unsigned cpu, cpus_per_queue, queues, remainder, i;
-	cpumask_var_t unassigned_cpus;
-
-	nvme_create_io_queues(dev);
-
-	queues = min(dev->online_queues - 1, num_online_cpus());
-	if (!queues)
-		return;
-
-	cpus_per_queue = num_online_cpus() / queues;
-	remainder = queues - (num_online_cpus() - queues * cpus_per_queue);
-
-	if (!alloc_cpumask_var(&unassigned_cpus, GFP_KERNEL))
-		return;
-
-	cpumask_copy(unassigned_cpus, cpu_online_mask);
-	cpu = cpumask_first(unassigned_cpus);
-	for (i = 1; i <= queues; i++) {
-		struct nvme_queue *nvmeq = lock_nvmeq(dev, i);
-		cpumask_t mask;
-
-		cpumask_clear(nvmeq->cpu_mask);
-		if (!cpumask_weight(unassigned_cpus)) {
-			unlock_nvmeq(nvmeq);
-			break;
-		}
-
-		mask = *get_cpu_mask(cpu);
-		nvme_set_queue_cpus(&mask, nvmeq, cpus_per_queue);
-		if (cpus_weight(mask) < cpus_per_queue)
-			nvme_add_cpus(&mask, unassigned_cpus,
-				topology_thread_cpumask(cpu),
-				nvmeq, cpus_per_queue);
-		if (cpus_weight(mask) < cpus_per_queue)
-			nvme_add_cpus(&mask, unassigned_cpus,
-				topology_core_cpumask(cpu),
-				nvmeq, cpus_per_queue);
-		if (cpus_weight(mask) < cpus_per_queue)
-			nvme_add_cpus(&mask, unassigned_cpus,
-				cpumask_of_node(cpu_to_node(cpu)),
-				nvmeq, cpus_per_queue);
-		if (cpus_weight(mask) < cpus_per_queue)
-			nvme_add_cpus(&mask, unassigned_cpus,
-				cpumask_of_node(
-					nvme_find_closest_node(
-						cpu_to_node(cpu))),
-				nvmeq, cpus_per_queue);
-		if (cpus_weight(mask) < cpus_per_queue)
-			nvme_add_cpus(&mask, unassigned_cpus,
-				unassigned_cpus,
-				nvmeq, cpus_per_queue);
-
-		WARN(cpumask_weight(nvmeq->cpu_mask) != cpus_per_queue,
-			"nvme%d qid:%d mis-matched queue-to-cpu assignment\n",
-			dev->instance, i);
-
-		irq_set_affinity_hint(dev->entry[nvmeq->cq_vector].vector,
-							nvmeq->cpu_mask);
-		cpumask_andnot(unassigned_cpus, unassigned_cpus,
-						nvmeq->cpu_mask);
-		cpu = cpumask_next(cpu, unassigned_cpus);
-		if (remainder && !--remainder)
-			cpus_per_queue++;
-		unlock_nvmeq(nvmeq);
-	}
-	WARN(cpumask_weight(unassigned_cpus), "nvme%d unassigned online cpus\n",
-								dev->instance);
-	i = 0;
-	cpumask_andnot(unassigned_cpus, cpu_possible_mask, cpu_online_mask);
-	for_each_cpu(cpu, unassigned_cpus)
-		*per_cpu_ptr(dev->io_queue, cpu) = (i++ % queues) + 1;
-	free_cpumask_var(unassigned_cpus);
-}
-
 static int set_queue_count(struct nvme_dev *dev, int count)
 {
 	int status;
@@ -2116,33 +1852,9 @@ static size_t db_bar_size(struct nvme_dev *dev, unsigned nr_io_queues)
 	return 4096 + ((nr_io_queues + 1) * 8 * dev->db_stride);
 }
 
-static void nvme_cpu_workfn(struct work_struct *work)
-{
-	struct nvme_dev *dev = container_of(work, struct nvme_dev, cpu_work);
-	if (dev->initialized)
-		nvme_assign_io_queues(dev);
-}
-
-static int nvme_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *hcpu)
-{
-	struct nvme_dev *dev;
-
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_DEAD:
-		spin_lock(&dev_list_lock);
-		list_for_each_entry(dev, &dev_list, node)
-			schedule_work(&dev->cpu_work);
-		spin_unlock(&dev_list_lock);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
 static int nvme_setup_io_queues(struct nvme_dev *dev)
 {
-	struct nvme_queue *adminq = raw_nvmeq(dev, 0);
+	struct nvme_queue *adminq = dev->queues[0];
 	struct pci_dev *pdev = dev->pci_dev;
 	int result, i, vecs, nr_io_queues, size;
 
@@ -2201,7 +1913,7 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 
 	/* Free previously allocated queues that are no longer usable */
 	nvme_free_queues(dev, nr_io_queues + 1);
-	nvme_assign_io_queues(dev);
+	nvme_create_io_queues(dev);
 
 	return 0;
 
@@ -2250,8 +1962,29 @@ static int nvme_dev_add(struct nvme_dev *dev)
 	if (ctrl->mdts)
 		dev->max_hw_sectors = 1 << (ctrl->mdts + shift - 9);
 	if ((pdev->vendor == PCI_VENDOR_ID_INTEL) &&
-			(pdev->device == 0x0953) && ctrl->vs[3])
+			(pdev->device == 0x0953) && ctrl->vs[3]) {
+		unsigned int max_hw_sectors;
+
 		dev->stripe_size = 1 << (ctrl->vs[3] + shift);
+		max_hw_sectors = dev->stripe_size >> (shift - 9);
+		if (dev->max_hw_sectors) {
+			dev->max_hw_sectors = min(max_hw_sectors,
+							dev->max_hw_sectors);
+		} else
+			dev->max_hw_sectors = max_hw_sectors;
+	}
+
+	dev->tagset.ops = &nvme_mq_ops;
+	dev->tagset.nr_hw_queues = dev->online_queues - 1;
+	dev->tagset.timeout = NVME_IO_TIMEOUT;
+	dev->tagset.numa_node = dev_to_node(&dev->pci_dev->dev);
+	dev->tagset.queue_depth = min_t(int, dev->q_depth, BLK_MQ_MAX_DEPTH);
+	dev->tagset.cmd_size = sizeof(struct nvme_cmd_info);
+	dev->tagset.flags = BLK_MQ_F_SHOULD_MERGE;
+	dev->tagset.driver_data = dev;
+
+	if (blk_mq_alloc_tag_set(&dev->tagset))
+		goto out;
 
 	id_ns = mem;
 	for (i = 1; i <= nn; i++) {
@@ -2401,7 +2134,8 @@ static int adapter_async_del_queue(struct nvme_queue *nvmeq, u8 opcode,
 	c.delete_queue.qid = cpu_to_le16(nvmeq->qid);
 
 	init_kthread_work(&nvmeq->cmdinfo.work, fn);
-	return nvme_submit_admin_cmd_async(nvmeq->dev, &c, &nvmeq->cmdinfo);
+	return nvme_submit_admin_async_cmd(nvmeq->dev, &c, &nvmeq->cmdinfo,
+								ADMIN_TIMEOUT);
 }
 
 static void nvme_del_cq_work_handler(struct kthread_work *work)
@@ -2464,7 +2198,7 @@ static void nvme_disable_io_queues(struct nvme_dev *dev)
 	atomic_set(&dq.refcount, 0);
 	dq.worker = &worker;
 	for (i = dev->queue_count - 1; i > 0; i--) {
-		struct nvme_queue *nvmeq = raw_nvmeq(dev, i);
+		struct nvme_queue *nvmeq = dev->queues[i];
 
 		if (nvme_suspend_queue(nvmeq))
 			continue;
@@ -2506,7 +2240,7 @@ static void nvme_dev_shutdown(struct nvme_dev *dev)
 
 	if (!dev->bar || (dev->bar && readl(&dev->bar->csts) == -1)) {
 		for (i = dev->queue_count - 1; i >= 0; i--) {
-			struct nvme_queue *nvmeq = raw_nvmeq(dev, i);
+			struct nvme_queue *nvmeq = dev->queues[i];
 			nvme_suspend_queue(nvmeq);
 			nvme_clear_queue(nvmeq);
 		}
@@ -2518,6 +2252,12 @@ static void nvme_dev_shutdown(struct nvme_dev *dev)
 	nvme_dev_unmap(dev);
 }
 
+static void nvme_dev_remove_admin(struct nvme_dev *dev)
+{
+	if (dev->admin_q && !blk_queue_dying(dev->admin_q))
+		blk_cleanup_queue(dev->admin_q);
+}
+
 static void nvme_dev_remove(struct nvme_dev *dev)
 {
 	struct nvme_ns *ns;
@@ -2599,7 +2339,7 @@ static void nvme_free_dev(struct kref *kref)
 	struct nvme_dev *dev = container_of(kref, struct nvme_dev, kref);
 
 	nvme_free_namespaces(dev);
-	free_percpu(dev->io_queue);
+	blk_mq_free_tag_set(&dev->tagset);
 	kfree(dev->queues);
 	kfree(dev->entry);
 	kfree(dev);
@@ -2726,7 +2466,7 @@ static void nvme_dev_reset(struct nvme_dev *dev)
 {
 	nvme_dev_shutdown(dev);
 	if (nvme_dev_resume(dev)) {
-		dev_err(&dev->pci_dev->dev, "Device failed to resume\n");
+		dev_warn(&dev->pci_dev->dev, "Device failed to resume\n");
 		kref_get(&dev->kref);
 		if (IS_ERR(kthread_run(nvme_remove_dead_ctrl, dev, "nvme%d",
 							dev->instance))) {
@@ -2751,28 +2491,28 @@ static void nvme_reset_workfn(struct work_struct *work)
 
 static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int result = -ENOMEM;
+	int node, result = -ENOMEM;
 	struct nvme_dev *dev;
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	node = dev_to_node(&pdev->dev);
+	if (node == NUMA_NO_NODE)
+		set_dev_node(&pdev->dev, 0);
+
+	dev = kzalloc_node(sizeof(*dev), GFP_KERNEL, node);
 	if (!dev)
 		return -ENOMEM;
-	dev->entry = kcalloc(num_possible_cpus(), sizeof(*dev->entry),
-								GFP_KERNEL);
+	dev->entry = kzalloc_node(num_possible_cpus() * sizeof(*dev->entry),
+							GFP_KERNEL, node);
 	if (!dev->entry)
 		goto free;
-	dev->queues = kcalloc(num_possible_cpus() + 1, sizeof(void *),
-								GFP_KERNEL);
+	dev->queues = kzalloc_node((num_possible_cpus() + 1) * sizeof(void *),
+							GFP_KERNEL, node);
 	if (!dev->queues)
 		goto free;
-	dev->io_queue = alloc_percpu(unsigned short);
-	if (!dev->io_queue)
-		goto free;
 
 	INIT_LIST_HEAD(&dev->namespaces);
 	dev->reset_workfn = nvme_reset_failed_dev;
 	INIT_WORK(&dev->reset_work, nvme_reset_workfn);
-	INIT_WORK(&dev->cpu_work, nvme_cpu_workfn);
 	dev->pci_dev = pdev;
 	pci_set_drvdata(pdev, dev);
 	result = nvme_set_instance(dev);
@@ -2810,6 +2550,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
  remove:
 	nvme_dev_remove(dev);
+	nvme_dev_remove_admin(dev);
 	nvme_free_namespaces(dev);
  shutdown:
 	nvme_dev_shutdown(dev);
@@ -2819,7 +2560,6 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  release:
 	nvme_release_instance(dev);
  free:
-	free_percpu(dev->io_queue);
 	kfree(dev->queues);
 	kfree(dev->entry);
 	kfree(dev);
@@ -2828,12 +2568,12 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void nvme_reset_notify(struct pci_dev *pdev, bool prepare)
 {
-       struct nvme_dev *dev = pci_get_drvdata(pdev);
+	struct nvme_dev *dev = pci_get_drvdata(pdev);
 
-       if (prepare)
-               nvme_dev_shutdown(dev);
-       else
-               nvme_dev_resume(dev);
+	if (prepare)
+		nvme_dev_shutdown(dev);
+	else
+		nvme_dev_resume(dev);
 }
 
 static void nvme_shutdown(struct pci_dev *pdev)
@@ -2852,12 +2592,12 @@ static void nvme_remove(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 	flush_work(&dev->reset_work);
-	flush_work(&dev->cpu_work);
 	misc_deregister(&dev->miscdev);
 	nvme_dev_remove(dev);
 	nvme_dev_shutdown(dev);
+	nvme_dev_remove_admin(dev);
 	nvme_free_queues(dev, 0);
-	rcu_barrier();
+	nvme_free_admin_tags(dev);
 	nvme_release_instance(dev);
 	nvme_release_prp_pools(dev);
 	kref_put(&dev->kref, nvme_free_dev);
@@ -2941,18 +2681,11 @@ static int __init nvme_init(void)
 	else if (result > 0)
 		nvme_major = result;
 
-	nvme_nb.notifier_call = &nvme_cpu_notify;
-	result = register_hotcpu_notifier(&nvme_nb);
-	if (result)
-		goto unregister_blkdev;
-
 	result = pci_register_driver(&nvme_driver);
 	if (result)
-		goto unregister_hotcpu;
+		goto unregister_blkdev;
 	return 0;
 
- unregister_hotcpu:
-	unregister_hotcpu_notifier(&nvme_nb);
  unregister_blkdev:
 	unregister_blkdev(nvme_major, "nvme");
  kill_workq:
diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index a4cd6d6..52c0356 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -2105,7 +2105,7 @@ static int nvme_trans_do_nvme_io(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 
 		nvme_offset += unit_num_blocks;
 
-		nvme_sc = nvme_submit_io_cmd(dev, &c, NULL);
+		nvme_sc = nvme_submit_io_cmd(dev, ns, &c, NULL);
 		if (nvme_sc != NVME_SC_SUCCESS) {
 			nvme_unmap_user_pages(dev,
 				(is_write) ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
@@ -2658,7 +2658,7 @@ static int nvme_trans_start_stop(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 			c.common.opcode = nvme_cmd_flush;
 			c.common.nsid = cpu_to_le32(ns->ns_id);
 
-			nvme_sc = nvme_submit_io_cmd(ns->dev, &c, NULL);
+			nvme_sc = nvme_submit_io_cmd(ns->dev, ns, &c, NULL);
 			res = nvme_trans_status_code(hdr, nvme_sc);
 			if (res)
 				goto out;
@@ -2686,7 +2686,7 @@ static int nvme_trans_synchronize_cache(struct nvme_ns *ns,
 	c.common.opcode = nvme_cmd_flush;
 	c.common.nsid = cpu_to_le32(ns->ns_id);
 
-	nvme_sc = nvme_submit_io_cmd(ns->dev, &c, NULL);
+	nvme_sc = nvme_submit_io_cmd(ns->dev, ns, &c, NULL);
 
 	res = nvme_trans_status_code(hdr, nvme_sc);
 	if (res)
@@ -2894,7 +2894,7 @@ static int nvme_trans_unmap(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	c.dsm.nr = cpu_to_le32(ndesc - 1);
 	c.dsm.attributes = cpu_to_le32(NVME_DSMGMT_AD);
 
-	nvme_sc = nvme_submit_io_cmd(dev, &c, NULL);
+	nvme_sc = nvme_submit_io_cmd(dev, ns, &c, NULL);
 	res = nvme_trans_status_code(hdr, nvme_sc);
 
 	dma_free_coherent(&dev->pci_dev->dev, ndesc * sizeof(*range),
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 2bf4031..299e6f5 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -19,6 +19,7 @@
 #include <linux/pci.h>
 #include <linux/miscdevice.h>
 #include <linux/kref.h>
+#include <linux/blk-mq.h>
 
 struct nvme_bar {
 	__u64			cap;	/* Controller Capabilities */
@@ -70,8 +71,10 @@ extern unsigned char nvme_io_timeout;
  */
 struct nvme_dev {
 	struct list_head node;
-	struct nvme_queue __rcu **queues;
-	unsigned short __percpu *io_queue;
+	struct nvme_queue **queues;
+	struct request_queue *admin_q;
+	struct blk_mq_tag_set tagset;
+	struct blk_mq_tag_set admin_tagset;
 	u32 __iomem *dbs;
 	struct pci_dev *pci_dev;
 	struct dma_pool *prp_page_pool;
@@ -90,7 +93,6 @@ struct nvme_dev {
 	struct miscdevice miscdev;
 	work_func_t reset_workfn;
 	struct work_struct reset_work;
-	struct work_struct cpu_work;
 	char name[12];
 	char serial[20];
 	char model[40];
@@ -132,7 +134,6 @@ struct nvme_iod {
 	int offset;		/* Of PRP list */
 	int nents;		/* Used in scatterlist */
 	int length;		/* Of data, in bytes */
-	unsigned long start_time;
 	dma_addr_t first_dma;
 	struct list_head node;
 	struct scatterlist sg[0];
@@ -150,12 +151,14 @@ static inline u64 nvme_block_nr(struct nvme_ns *ns, sector_t sector)
  */
 void nvme_free_iod(struct nvme_dev *dev, struct nvme_iod *iod);
 
-int nvme_setup_prps(struct nvme_dev *, struct nvme_iod *, int , gfp_t);
+int nvme_setup_prps(struct nvme_dev *, struct nvme_iod *, int, gfp_t);
 struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
 				unsigned long addr, unsigned length);
 void nvme_unmap_user_pages(struct nvme_dev *dev, int write,
 			struct nvme_iod *iod);
-int nvme_submit_io_cmd(struct nvme_dev *, struct nvme_command *, u32 *);
+int nvme_submit_io_cmd(struct nvme_dev *, struct nvme_ns *,
+						struct nvme_command *, u32 *);
+int nvme_submit_flush_data(struct nvme_queue *nvmeq, struct nvme_ns *ns);
 int nvme_submit_admin_cmd(struct nvme_dev *, struct nvme_command *,
 							u32 *result);
 int nvme_identify(struct nvme_dev *, unsigned nsid, unsigned cns,
-- 
1.9.1

