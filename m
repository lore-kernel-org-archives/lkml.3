Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3JRNOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:14:52 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59466 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3JRNOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:14:48 -0400
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk, willy@linux.intel.com, keith.busch@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Matias Bjorling <m@bjorling.me>
Subject: [PATCH 3/3] NVMe: Convert to blk-mq
Date: Fri, 18 Oct 2013 15:14:22 +0200
Message-Id: <1382102062-22270-4-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382102062-22270-1-git-send-email-m@bjorling.me>
References: <1382102062-22270-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nvme driver implements itself as a bio-based driver. This primarily
because of high lock congestion for high-performance nvm devices. To
remove the congestion within the traditional block layer, a multi-queue
block layer is being implemented.

This patch converts the current bio-based approach to work with the
request-based approach found in the multi-queue block layer. This means
that bio responsibility is moved from the driver, into the block layer.
In return the block layer packs request structures and submit them to
the nvme  according to the features/limits of nvme hardware.

The patch consists of:
 * Initialization of multi-queue data structures
 * Conversion of bio function call into request function calls.
 * Separate cmdid patchs for admin and normal queues.
 * Bio splits according to NOT_VIRT_MERGEABLE are assumed to be handled
   by blk-mq.
 * Uses the timeout framework blk-mq where possible.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 drivers/block/nvme-core.c | 765 +++++++++++++++++++++++-----------------------
 drivers/block/nvme-scsi.c |  39 +--
 include/linux/nvme.h      |   7 +-
 3 files changed, 385 insertions(+), 426 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index e99a30a..36bf45c 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -17,9 +17,10 @@
  */
 
 #include <linux/nvme.h>
-#include <linux/bio.h>
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
+#include <linux/blk-mq.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -60,6 +61,23 @@ static DEFINE_SPINLOCK(dev_list_lock);
 static LIST_HEAD(dev_list);
 static struct task_struct *nvme_thread;
 
+typedef void (*nvme_completion_fn)(struct nvme_dev *, void *,
+						struct nvme_completion *);
+
+struct nvme_cmd_info {
+	nvme_completion_fn fn;
+	void *ctx;
+	unsigned long timeout;
+	struct blk_mq_hw_ctx *hctx;
+};
+
+struct nvme_admin_queue {
+	wait_queue_head_t sq_full;
+	wait_queue_t sq_cong_wait;
+	atomic_t sq_cmdid;
+	struct nvme_cmd_info infos[NVME_ADMIN_Q_DEPTH];
+};
+
 /*
  * An NVM Express queue.  Each device has at least two (one for admin
  * commands and one for I/O commands).
@@ -68,13 +86,11 @@ struct nvme_queue {
 	struct device *q_dmadev;
 	struct nvme_dev *dev;
 	spinlock_t q_lock;
+	struct blk_mq_hw_ctx *hctx;
 	struct nvme_command *sq_cmds;
 	volatile struct nvme_completion *cqes;
 	dma_addr_t sq_dma_addr;
 	dma_addr_t cq_dma_addr;
-	wait_queue_head_t sq_full;
-	wait_queue_t sq_cong_wait;
-	struct bio_list sq_cong;
 	u32 __iomem *q_db;
 	u16 q_depth;
 	u16 cq_vector;
@@ -84,7 +100,7 @@ struct nvme_queue {
 	u8 cq_phase;
 	u8 cqe_seen;
 	u8 q_suspended;
-	unsigned long cmdid_data[];
+	struct nvme_admin_queue *admin;
 };
 
 /*
@@ -105,65 +121,72 @@ static inline void _nvme_check_size(void)
 	BUILD_BUG_ON(sizeof(struct nvme_smart_log) != 512);
 }
 
-typedef void (*nvme_completion_fn)(struct nvme_dev *, void *,
-						struct nvme_completion *);
+static inline struct nvme_cmd_info *nvme_get_rq_from_id(struct nvme_queue
+		*nvmeq, unsigned int cmdid)
+{
+	struct blk_mq_hw_ctx *hctx = nvmeq->hctx;
+	struct request *rq = blk_mq_tag_to_rq(hctx, cmdid);
 
-struct nvme_cmd_info {
-	nvme_completion_fn fn;
-	void *ctx;
-	unsigned long timeout;
-};
+	return rq->special;
+}
 
-static struct nvme_cmd_info *nvme_cmd_info(struct nvme_queue *nvmeq)
+static inline struct nvme_cmd_info *nvme_get_cmd_from_rq(struct request *rq)
 {
-	return (void *)&nvmeq->cmdid_data[BITS_TO_LONGS(nvmeq->q_depth)];
+	return rq->special;
+}
+
+static inline struct request *nvme_get_rq_from_cmd(struct nvme_cmd_info *info)
+{
+	return blk_mq_rq_from_pdu(info);
 }
 
 static unsigned nvme_queue_extra(int depth)
 {
-	return DIV_ROUND_UP(depth, 8) + (depth * sizeof(struct nvme_cmd_info));
+	return DIV_ROUND_UP(depth, 8);
 }
 
 /**
- * alloc_cmdid() - Allocate a Command ID
- * @nvmeq: The queue that will be used for this command
+ * configure_cmd_info() - Configure Command Information
+ * @info: The cmd_info that will be used for this command
  * @ctx: A pointer that will be passed to the handler
  * @handler: The function to call on completion
  *
- * Allocate a Command ID for a queue.  The data passed in will
+ * Configure a cmd info for a queue.  The data passed in will
  * be passed to the completion handler.  This is implemented by using
  * the bottom two bits of the ctx pointer to store the handler ID.
  * Passing in a pointer that's not 4-byte aligned will cause a BUG.
  * We can change this if it becomes a problem.
  *
- * May be called with local interrupts disabled and the q_lock held,
- * or with interrupts enabled and no locks held.
  */
-static int alloc_cmdid(struct nvme_queue *nvmeq, void *ctx,
+static inline void configure_cmd_info(struct nvme_cmd_info *info, void *ctx,
 				nvme_completion_fn handler, unsigned timeout)
 {
-	int depth = nvmeq->q_depth - 1;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
+	info->fn = handler;
+	info->ctx = ctx;
+	info->timeout = jiffies + timeout;
+}
+
+static int try_alloc_cmdid(struct nvme_queue *nvmeq)
+{
+	struct nvme_admin_queue *admin = nvmeq->admin;
 	int cmdid;
 
-	do {
-		cmdid = find_first_zero_bit(nvmeq->cmdid_data, depth);
-		if (cmdid >= depth)
-			return -EBUSY;
-	} while (test_and_set_bit(cmdid, nvmeq->cmdid_data));
-
-	info[cmdid].fn = handler;
-	info[cmdid].ctx = ctx;
-	info[cmdid].timeout = jiffies + timeout;
+	cmdid = atomic_inc_return(&admin->sq_cmdid);
+
+	if (cmdid >= nvmeq->q_depth) {
+		atomic_dec(&admin->sq_cmdid);
+		cmdid = -1;
+	}
+
 	return cmdid;
 }
 
-static int alloc_cmdid_killable(struct nvme_queue *nvmeq, void *ctx,
-				nvme_completion_fn handler, unsigned timeout)
+static int admin_cmdid_get_killable(struct nvme_queue *nvmeq)
 {
+	struct nvme_admin_queue *admin = nvmeq->admin;
 	int cmdid;
-	wait_event_killable(nvmeq->sq_full,
-		(cmdid = alloc_cmdid(nvmeq, ctx, handler, timeout)) >= 0);
+	wait_event_killable(admin->sq_full,
+		(cmdid = try_alloc_cmdid(nvmeq) >= 0));
 	return (cmdid < 0) ? -EINTR : cmdid;
 }
 
@@ -197,52 +220,57 @@ static void special_completion(struct nvme_dev *dev, void *ctx,
 	dev_warn(&dev->pci_dev->dev, "Unknown special completion %p\n", ctx);
 }
 
-/*
- * Called with local interrupts disabled and the q_lock held.  May not sleep.
- */
-static void *free_cmdid(struct nvme_queue *nvmeq, int cmdid,
-						nvme_completion_fn *fn)
+static void admin_cmdid_put(struct nvme_queue *nvmeq)
+{
+	struct nvme_admin_queue *admin = nvmeq->admin;
+	int cmdid = atomic_dec_return(&admin->sq_cmdid);
+	if (cmdid >= nvmeq->q_depth)
+		wake_up(&admin->sq_full);
+}
+
+static inline void *complete_cmd_info(struct nvme_cmd_info *info,
+				nvme_completion_fn *fn, void *ctx_status)
 {
 	void *ctx;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
 
-	if (cmdid >= nvmeq->q_depth) {
-		*fn = special_completion;
-		return CMD_CTX_INVALID;
-	}
 	if (fn)
-		*fn = info[cmdid].fn;
-	ctx = info[cmdid].ctx;
-	info[cmdid].fn = special_completion;
-	info[cmdid].ctx = CMD_CTX_COMPLETED;
-	clear_bit(cmdid, nvmeq->cmdid_data);
-	wake_up(&nvmeq->sq_full);
+		*fn = info->fn;
+	ctx = info->ctx;
+	info->fn = special_completion;
+	info->ctx = ctx_status;
+
 	return ctx;
 }
-
-static void *cancel_cmdid(struct nvme_queue *nvmeq, int cmdid,
+/*
+ * Called with local interrupts disabled and the q_lock held.  May not sleep.
+ */
+static void *complete_admin_cmd_info(struct nvme_queue *nvmeq, int cmdid,
 						nvme_completion_fn *fn)
 {
-	void *ctx;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
-	if (fn)
-		*fn = info[cmdid].fn;
-	ctx = info[cmdid].ctx;
-	info[cmdid].fn = special_completion;
-	info[cmdid].ctx = CMD_CTX_CANCELLED;
-	return ctx;
+	struct nvme_cmd_info *info = &nvmeq->admin->infos[cmdid];
+	return complete_cmd_info(info, fn, CMD_CTX_COMPLETED);
 }
 
-struct nvme_queue *get_nvmeq(struct nvme_dev *dev)
+static inline void *complete_rq_cmd_info(struct nvme_queue *nvmeq, int cmdid,
+						nvme_completion_fn *fn)
 {
-	return dev->queues[get_cpu() + 1];
+	struct nvme_cmd_info *info = nvme_get_rq_from_id(nvmeq, cmdid);
+	return complete_cmd_info(info, fn, CMD_CTX_COMPLETED);
 }
 
-void put_nvmeq(struct nvme_queue *nvmeq)
+static void *cancel_admin_cmd_info(struct nvme_queue *nvmeq, int cmdid,
+						nvme_completion_fn *fn)
 {
-	put_cpu();
+	struct nvme_cmd_info *info = &nvmeq->admin->infos[cmdid];
+	return complete_cmd_info(info, fn, CMD_CTX_CANCELLED);
 }
 
+static inline void *cancel_user_cmd_info(struct nvme_queue *nvmeq, int cmdid,
+						nvme_completion_fn *fn)
+{
+	struct nvme_cmd_info *info = nvme_get_rq_from_id(nvmeq, cmdid);
+	return complete_cmd_info(info, fn, CMD_CTX_CANCELLED);
+}
 /**
  * nvme_submit_cmd() - Copy a command into a queue and ring the doorbell
  * @nvmeq: The queue to use
@@ -318,22 +346,22 @@ void nvme_free_iod(struct nvme_dev *dev, struct nvme_iod *iod)
 	kfree(iod);
 }
 
-static void nvme_start_io_acct(struct bio *bio)
+static void nvme_start_io_acct(struct request *rq)
 {
-	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	const int rw = bio_data_dir(bio);
+	struct gendisk *disk = rq->rq_disk;
+	const int rw = rq_data_dir(rq);
 	int cpu = part_stat_lock();
 	part_round_stats(cpu, &disk->part0);
 	part_stat_inc(cpu, &disk->part0, ios[rw]);
-	part_stat_add(cpu, &disk->part0, sectors[rw], bio_sectors(bio));
+	part_stat_add(cpu, &disk->part0, sectors[rw], blk_rq_sectors(rq));
 	part_inc_in_flight(&disk->part0, rw);
 	part_stat_unlock();
 }
 
-static void nvme_end_io_acct(struct bio *bio, unsigned long start_time)
+static void nvme_end_io_acct(struct request *rq, unsigned long start_time)
 {
-	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	const int rw = bio_data_dir(bio);
+	struct gendisk *disk = rq->rq_disk;
+	const int rw = rq_data_dir(rq);
 	unsigned long duration = jiffies - start_time;
 	int cpu = part_stat_lock();
 	part_stat_add(cpu, &disk->part0, ticks[rw], duration);
@@ -342,23 +370,26 @@ static void nvme_end_io_acct(struct bio *bio, unsigned long start_time)
 	part_stat_unlock();
 }
 
-static void bio_completion(struct nvme_dev *dev, void *ctx,
+static void rq_completion(struct nvme_dev *dev, void *ctx,
 						struct nvme_completion *cqe)
 {
 	struct nvme_iod *iod = ctx;
-	struct bio *bio = iod->private;
+	struct request *rq = iod->private;
+
 	u16 status = le16_to_cpup(&cqe->status) >> 1;
 
 	if (iod->nents) {
 		dma_unmap_sg(&dev->pci_dev->dev, iod->sg, iod->nents,
-			bio_data_dir(bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
-		nvme_end_io_acct(bio, iod->start_time);
+			rq_data_dir(rq) ==
+				WRITE ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
+		nvme_end_io_acct(rq, iod->start_time);
 	}
+
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
@@ -442,151 +473,15 @@ int nvme_setup_prps(struct nvme_dev *dev, struct nvme_common_command *cmd,
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
-{
-	struct nvme_bio_pair *bp = bio->bi_private;
-
-	if (err)
-		bp->err = err;
-
-	if (atomic_dec_and_test(&bp->cnt)) {
-		bio_endio(bp->parent, bp->err);
-		kfree(bp->bv1);
-		kfree(bp->bv2);
-		kfree(bp);
-	}
-}
-
-static struct nvme_bio_pair *nvme_bio_split(struct bio *bio, int idx,
-							int len, int offset)
+static int nvme_map_rq(struct nvme_queue *nvmeq, struct nvme_iod *iod,
+		struct request *rq, enum dma_data_direction dma_dir)
 {
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
-
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
+	iod->nents = blk_rq_map_sg(rq->q, rq, iod->sg);
 
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
@@ -595,7 +490,7 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
  * the iod.
  */
 static int nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
-		struct bio *bio, struct nvme_iod *iod, int cmdid)
+		struct request *rq, struct nvme_iod *iod)
 {
 	struct nvme_dsm_range *range;
 	struct nvme_command *cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
@@ -609,12 +504,12 @@ static int nvme_submit_discard(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	iod->npages = 0;
 
 	range->cattr = cpu_to_le32(0);
-	range->nlb = cpu_to_le32(bio->bi_size >> ns->lba_shift);
-	range->slba = cpu_to_le64(nvme_block_nr(ns, bio->bi_sector));
+	range->nlb = cpu_to_le32(blk_rq_bytes(rq) >> ns->lba_shift);
+	range->slba = cpu_to_le64(nvme_block_nr(ns, blk_rq_sectors(rq)));
 
 	memset(cmnd, 0, sizeof(*cmnd));
 	cmnd->dsm.opcode = nvme_cmd_dsm;
-	cmnd->dsm.command_id = cmdid;
+	cmnd->dsm.command_id = rq->tag;
 	cmnd->dsm.nsid = cpu_to_le32(ns->ns_id);
 	cmnd->dsm.prp1 = cpu_to_le64(iod->first_dma);
 	cmnd->dsm.nr = 0;
@@ -644,70 +539,66 @@ static int nvme_submit_flush(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	return 0;
 }
 
-int nvme_submit_flush_data(struct nvme_queue *nvmeq, struct nvme_ns *ns)
+int nvme_submit_flush_data(struct nvme_queue *nvmeq, struct nvme_ns *ns,
+					struct request *rq)
 {
-	int cmdid = alloc_cmdid(nvmeq, (void *)CMD_CTX_FLUSH,
-					special_completion, NVME_IO_TIMEOUT);
-	if (unlikely(cmdid < 0))
-		return cmdid;
+	struct nvme_cmd_info *info = nvme_get_cmd_from_rq(rq);
+
+	configure_cmd_info(info, (void *)CMD_CTX_FLUSH, special_completion,
+					NVME_IO_TIMEOUT);
 
-	return nvme_submit_flush(nvmeq, ns, cmdid);
+	return nvme_submit_flush(nvmeq, ns, rq->tag);
 }
 
 /*
  * Called with local interrupts disabled and the q_lock held.  May not sleep.
  */
-static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
-								struct bio *bio)
+static int nvme_submit_rq_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
+				  struct request *rq)
 {
 	struct nvme_command *cmnd;
-	struct nvme_iod *iod;
+	struct nvme_iod *iod = rq->special;
+	struct nvme_cmd_info *info = nvme_get_cmd_from_rq(rq);
 	enum dma_data_direction dma_dir;
-	int cmdid, length, result;
+	int length;
 	u16 control;
 	u32 dsmgmt;
-	int psegs = bio_phys_segments(ns->queue, bio);
+	int psegs = rq->nr_phys_segments;
 
-	if ((bio->bi_rw & REQ_FLUSH) && psegs) {
-		result = nvme_submit_flush_data(nvmeq, ns);
-		if (result)
-			return result;
-	}
+	if ((rq->cmd_flags & REQ_FLUSH) && psegs)
+		nvme_submit_flush_data(nvmeq, ns, rq);
 
-	result = -ENOMEM;
-	iod = nvme_alloc_iod(psegs, bio->bi_size, GFP_ATOMIC);
+	if ((rq->cmd_flags & REQ_FLUSH) && !psegs)
+		return nvme_submit_flush(nvmeq, ns, rq->tag);
+
+	iod = nvme_alloc_iod(psegs, blk_rq_bytes(rq), GFP_ATOMIC);
 	if (!iod)
 		goto nomem;
-	iod->private = bio;
 
-	result = -EBUSY;
-	cmdid = alloc_cmdid(nvmeq, iod, bio_completion, NVME_IO_TIMEOUT);
-	if (unlikely(cmdid < 0))
-		goto free_iod;
+	iod->private = rq;
 
-	if (bio->bi_rw & REQ_DISCARD) {
-		result = nvme_submit_discard(nvmeq, ns, bio, iod, cmdid);
-		if (result)
+	configure_cmd_info(info, iod, rq_completion, NVME_IO_TIMEOUT);
+
+	if (rq->cmd_flags & REQ_DISCARD) {
+		if (nvme_submit_discard(nvmeq, ns, rq, iod))
 			goto free_cmdid;
-		return result;
+		goto finished;
 	}
-	if ((bio->bi_rw & REQ_FLUSH) && !psegs)
-		return nvme_submit_flush(nvmeq, ns, cmdid);
 
 	control = 0;
-	if (bio->bi_rw & REQ_FUA)
+	if (rq->cmd_flags & REQ_FUA)
 		control |= NVME_RW_FUA;
-	if (bio->bi_rw & (REQ_FAILFAST_DEV | REQ_RAHEAD))
+	if (rq->cmd_flags & (REQ_FAILFAST_DEV | REQ_RAHEAD))
 		control |= NVME_RW_LR;
 
 	dsmgmt = 0;
-	if (bio->bi_rw & REQ_RAHEAD)
+	if (rq->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
 
 	cmnd = &nvmeq->sq_cmds[nvmeq->sq_tail];
 
 	memset(cmnd, 0, sizeof(*cmnd));
-	if (bio_data_dir(bio)) {
+	if (rq_data_dir(rq) == WRITE) {
 		cmnd->rw.opcode = nvme_cmd_write;
 		dma_dir = DMA_TO_DEVICE;
 	} else {
@@ -715,32 +606,47 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 		dma_dir = DMA_FROM_DEVICE;
 	}
 
-	result = nvme_map_bio(nvmeq, iod, bio, dma_dir, psegs);
-	if (result <= 0)
+	if (nvme_map_rq(nvmeq, iod, rq, dma_dir))
 		goto free_cmdid;
-	length = result;
 
-	cmnd->rw.command_id = cmdid;
+	length = blk_rq_bytes(rq);
+
+	cmnd->rw.command_id = rq->tag;
 	cmnd->rw.nsid = cpu_to_le32(ns->ns_id);
 	length = nvme_setup_prps(nvmeq->dev, &cmnd->common, iod, length,
 								GFP_ATOMIC);
-	cmnd->rw.slba = cpu_to_le64(nvme_block_nr(ns, bio->bi_sector));
+	cmnd->rw.slba = cpu_to_le64(nvme_block_nr(ns, blk_rq_sectors(rq)));
 	cmnd->rw.length = cpu_to_le16((length >> ns->lba_shift) - 1);
 	cmnd->rw.control = cpu_to_le16(control);
 	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
 
-	nvme_start_io_acct(bio);
+	nvme_start_io_acct(rq);
 	if (++nvmeq->sq_tail == nvmeq->q_depth)
 		nvmeq->sq_tail = 0;
 	writel(nvmeq->sq_tail, nvmeq->q_db);
 
-	return 0;
-
+ finished:
+	return BLK_MQ_RQ_QUEUE_OK;
  free_cmdid:
-	free_cmdid(nvmeq, cmdid, NULL);
- free_iod:
+	complete_rq_cmd_info(nvmeq, rq->tag, NULL);
 	nvme_free_iod(nvmeq->dev, iod);
  nomem:
+	return BLK_MQ_RQ_QUEUE_ERROR;
+}
+
+static int nvme_queue_request(struct blk_mq_hw_ctx *hctx, struct request *rq)
+{
+	struct nvme_ns *ns = hctx->queue->queuedata;
+	struct nvme_queue *nvmeq = hctx->driver_data;
+	int result;
+
+	if (unlikely(nvmeq->q_suspended))
+		return BLK_MQ_RQ_QUEUE_BUSY;
+
+	spin_lock_irq(&nvmeq->q_lock);
+	result = nvme_submit_rq_queue(nvmeq, ns, rq);
+	spin_unlock_irq(&nvmeq->q_lock);
+
 	return result;
 }
 
@@ -763,7 +669,11 @@ static int nvme_process_cq(struct nvme_queue *nvmeq)
 			phase = !phase;
 		}
 
-		ctx = free_cmdid(nvmeq, cqe.command_id, &fn);
+		if (unlikely(nvmeq->admin))
+			ctx = complete_admin_cmd_info(nvmeq, cqe.command_id,
+									&fn);
+		else
+			ctx = complete_rq_cmd_info(nvmeq, cqe.command_id, &fn);
 		fn(nvmeq->dev, ctx, &cqe);
 	}
 
@@ -784,32 +694,6 @@ static int nvme_process_cq(struct nvme_queue *nvmeq)
 	return 1;
 }
 
-static void nvme_make_request(struct request_queue *q, struct bio *bio)
-{
-	struct nvme_ns *ns = q->queuedata;
-	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
-	int result = -EBUSY;
-
-	if (!nvmeq) {
-		put_nvmeq(NULL);
-		bio_endio(bio, -EIO);
-		return;
-	}
-
-	spin_lock_irq(&nvmeq->q_lock);
-	if (!nvmeq->q_suspended && bio_list_empty(&nvmeq->sq_cong))
-		result = nvme_submit_bio_queue(nvmeq, ns, bio);
-	if (unlikely(result)) {
-		if (bio_list_empty(&nvmeq->sq_cong))
-			add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
-		bio_list_add(&nvmeq->sq_cong, bio);
-	}
-
-	nvme_process_cq(nvmeq);
-	spin_unlock_irq(&nvmeq->q_lock);
-	put_nvmeq(nvmeq);
-}
-
 static irqreturn_t nvme_irq(int irq, void *data)
 {
 	irqreturn_t result;
@@ -834,7 +718,7 @@ static irqreturn_t nvme_irq_check(int irq, void *data)
 static void nvme_abort_command(struct nvme_queue *nvmeq, int cmdid)
 {
 	spin_lock_irq(&nvmeq->q_lock);
-	cancel_cmdid(nvmeq, cmdid, NULL);
+	cancel_user_cmd_info(nvmeq, cmdid, NULL);
 	spin_unlock_irq(&nvmeq->q_lock);
 }
 
@@ -858,18 +742,16 @@ static void sync_completion(struct nvme_dev *dev, void *ctx,
  * if the result is positive, it's an NVM Express status code
  */
 int nvme_submit_sync_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
-						u32 *result, unsigned timeout)
+		struct nvme_cmd_info *info,
+		int cmdid, u32 *result, unsigned timeout)
 {
-	int cmdid;
 	struct sync_cmd_info cmdinfo;
 
 	cmdinfo.task = current;
 	cmdinfo.status = -EINTR;
 
-	cmdid = alloc_cmdid_killable(nvmeq, &cmdinfo, sync_completion,
-								timeout);
-	if (cmdid < 0)
-		return cmdid;
+	configure_cmd_info(info, &cmdinfo, sync_completion, timeout);
+
 	cmd->common.command_id = cmdid;
 
 	set_current_state(TASK_KILLABLE);
@@ -887,10 +769,57 @@ int nvme_submit_sync_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
 	return cmdinfo.status;
 }
 
-int nvme_submit_admin_cmd(struct nvme_dev *dev, struct nvme_command *cmd,
+int nvme_submit_user_sync_cmd(struct nvme_ns *ns, struct nvme_command *cmd,
 								u32 *result)
 {
-	return nvme_submit_sync_cmd(dev->queues[0], cmd, result, ADMIN_TIMEOUT);
+	struct request *rq;
+	struct nvme_cmd_info *info;
+	struct nvme_queue *nvmeq;
+	int ret;
+
+	rq = blk_mq_alloc_reserved_request(ns->queue, 0, __GFP_WAIT);
+
+	info = nvme_get_cmd_from_rq(rq);
+	nvmeq = info->hctx->driver_data;
+
+	if (nvmeq->q_suspended) {
+		ret = -EBUSY;
+		goto finished;
+	}
+
+	ret = nvme_submit_sync_cmd(nvmeq, cmd, info, rq->tag, result,
+							NVME_IO_TIMEOUT);
+
+ finished:
+	blk_put_request(rq);
+
+	return ret;
+}
+
+int nvme_submit_admin_sync_cmd_timeout(struct nvme_dev *dev,
+			struct nvme_command *cmd, u32 *result, unsigned timeout)
+{
+	struct nvme_queue *nvmeq = dev->queues[0];
+	struct nvme_admin_queue *admin = nvmeq->admin;
+	int cmdid = admin_cmdid_get_killable(nvmeq);
+	int ret;
+
+	/* cmdid return value takes precendent on failure */
+	if (cmdid < 0)
+		return cmdid;
+
+	ret = nvme_submit_sync_cmd(nvmeq, cmd, &admin->infos[cmdid], cmdid,
+					result, timeout);
+
+	admin_cmdid_put(nvmeq);
+	return ret;
+}
+
+int nvme_submit_admin_sync_cmd(struct nvme_dev *dev, struct nvme_command *cmd,
+								u32 *result)
+{
+	return nvme_submit_admin_sync_cmd_timeout(dev, cmd, result,
+								ADMIN_TIMEOUT);
 }
 
 static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)
@@ -902,7 +831,7 @@ static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)
 	c.delete_queue.opcode = opcode;
 	c.delete_queue.qid = cpu_to_le16(id);
 
-	status = nvme_submit_admin_cmd(dev, &c, NULL);
+	status = nvme_submit_admin_sync_cmd(dev, &c, NULL);
 	if (status)
 		return -EIO;
 	return 0;
@@ -923,7 +852,7 @@ static int adapter_alloc_cq(struct nvme_dev *dev, u16 qid,
 	c.create_cq.cq_flags = cpu_to_le16(flags);
 	c.create_cq.irq_vector = cpu_to_le16(nvmeq->cq_vector);
 
-	status = nvme_submit_admin_cmd(dev, &c, NULL);
+	status = nvme_submit_admin_sync_cmd(dev, &c, NULL);
 	if (status)
 		return -EIO;
 	return 0;
@@ -944,7 +873,7 @@ static int adapter_alloc_sq(struct nvme_dev *dev, u16 qid,
 	c.create_sq.sq_flags = cpu_to_le16(flags);
 	c.create_sq.cqid = cpu_to_le16(qid);
 
-	status = nvme_submit_admin_cmd(dev, &c, NULL);
+	status = nvme_submit_admin_sync_cmd(dev, &c, NULL);
 	if (status)
 		return -EIO;
 	return 0;
@@ -971,7 +900,7 @@ int nvme_identify(struct nvme_dev *dev, unsigned nsid, unsigned cns,
 	c.identify.prp1 = cpu_to_le64(dma_addr);
 	c.identify.cns = cpu_to_le32(cns);
 
-	return nvme_submit_admin_cmd(dev, &c, NULL);
+	return nvme_submit_admin_sync_cmd(dev, &c, NULL);
 }
 
 int nvme_get_features(struct nvme_dev *dev, unsigned fid, unsigned nsid,
@@ -985,7 +914,7 @@ int nvme_get_features(struct nvme_dev *dev, unsigned fid, unsigned nsid,
 	c.features.prp1 = cpu_to_le64(dma_addr);
 	c.features.fid = cpu_to_le32(fid);
 
-	return nvme_submit_admin_cmd(dev, &c, result);
+	return nvme_submit_admin_sync_cmd(dev, &c, result);
 }
 
 int nvme_set_features(struct nvme_dev *dev, unsigned fid, unsigned dword11,
@@ -999,7 +928,7 @@ int nvme_set_features(struct nvme_dev *dev, unsigned fid, unsigned dword11,
 	c.features.fid = cpu_to_le32(fid);
 	c.features.dword11 = cpu_to_le32(dword11);
 
-	return nvme_submit_admin_cmd(dev, &c, result);
+	return nvme_submit_admin_sync_cmd(dev, &c, result);
 }
 
 /**
@@ -1007,43 +936,38 @@ int nvme_set_features(struct nvme_dev *dev, unsigned fid, unsigned dword11,
  * @queue: The queue to cancel I/Os on
  * @timeout: True to only cancel I/Os which have timed out
  */
-static void nvme_cancel_ios(struct nvme_queue *nvmeq, bool timeout)
+static void nvme_cancel_admin_ios(struct nvme_queue *nvmeq, bool timeout)
 {
-	int depth = nvmeq->q_depth - 1;
-	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
+	struct nvme_admin_queue *admin = nvmeq->admin;
 	unsigned long now = jiffies;
 	int cmdid;
 
-	for_each_set_bit(cmdid, nvmeq->cmdid_data, depth) {
+	for (cmdid = atomic_read(&admin->sq_cmdid); cmdid >= 0; cmdid--)
+	{
 		void *ctx;
 		nvme_completion_fn fn;
 		static struct nvme_completion cqe = {
 			.status = cpu_to_le16(NVME_SC_ABORT_REQ << 1),
 		};
 
-		if (timeout && !time_after(now, info[cmdid].timeout))
+		if (timeout && !time_after(now, admin->infos[cmdid].timeout))
 			continue;
-		if (info[cmdid].ctx == CMD_CTX_CANCELLED)
+		if (admin->infos[cmdid].ctx == CMD_CTX_CANCELLED)
 			continue;
 		dev_warn(nvmeq->q_dmadev, "Cancelling I/O %d\n", cmdid);
-		ctx = cancel_cmdid(nvmeq, cmdid, &fn);
+		ctx = cancel_admin_cmd_info(nvmeq, cmdid, &fn);
 		fn(nvmeq->dev, ctx, &cqe);
 	}
 }
 
 static void nvme_free_queue(struct nvme_queue *nvmeq)
 {
-	spin_lock_irq(&nvmeq->q_lock);
-	while (bio_list_peek(&nvmeq->sq_cong)) {
-		struct bio *bio = bio_list_pop(&nvmeq->sq_cong);
-		bio_endio(bio, -EIO);
-	}
-	spin_unlock_irq(&nvmeq->q_lock);
-
 	dma_free_coherent(nvmeq->q_dmadev, CQ_SIZE(nvmeq->q_depth),
 				(void *)nvmeq->cqes, nvmeq->cq_dma_addr);
 	dma_free_coherent(nvmeq->q_dmadev, SQ_SIZE(nvmeq->q_depth),
 					nvmeq->sq_cmds, nvmeq->sq_dma_addr);
+
+	kfree(nvmeq->admin);
 	kfree(nvmeq);
 }
 
@@ -1082,7 +1006,8 @@ static void nvme_disable_queue(struct nvme_dev *dev, int qid)
 
 	spin_lock_irq(&nvmeq->q_lock);
 	nvme_process_cq(nvmeq);
-	nvme_cancel_ios(nvmeq, false);
+	if (nvmeq->admin)
+		nvme_cancel_admin_ios(nvmeq, false);
 	spin_unlock_irq(&nvmeq->q_lock);
 }
 
@@ -1111,13 +1036,25 @@ static struct nvme_queue *nvme_alloc_queue(struct nvme_dev *dev, int qid,
 	spin_lock_init(&nvmeq->q_lock);
 	nvmeq->cq_head = 0;
 	nvmeq->cq_phase = 1;
-	init_waitqueue_head(&nvmeq->sq_full);
-	init_waitqueue_entry(&nvmeq->sq_cong_wait, nvme_thread);
-	bio_list_init(&nvmeq->sq_cong);
 	nvmeq->q_db = &dev->dbs[qid << (dev->db_stride + 1)];
 	nvmeq->q_depth = depth;
 	nvmeq->cq_vector = vector;
 	nvmeq->q_suspended = 1;
+
+	if (!qid) {
+		struct nvme_admin_queue *admin = kzalloc(
+				sizeof(struct nvme_admin_queue), GFP_KERNEL);
+
+		if (!admin)
+			goto free_cqdma;
+
+		init_waitqueue_head(&admin->sq_full);
+		init_waitqueue_entry(&admin->sq_cong_wait, nvme_thread);
+		atomic_set(&admin->sq_cmdid, -1);
+
+		nvmeq->admin = admin;
+	}
+
 	dev->queue_count++;
 
 	return nvmeq;
@@ -1145,15 +1082,14 @@ static int queue_request_irq(struct nvme_dev *dev, struct nvme_queue *nvmeq,
 static void nvme_init_queue(struct nvme_queue *nvmeq, u16 qid)
 {
 	struct nvme_dev *dev = nvmeq->dev;
-	unsigned extra = nvme_queue_extra(nvmeq->q_depth);
 
 	nvmeq->sq_tail = 0;
 	nvmeq->cq_head = 0;
 	nvmeq->cq_phase = 1;
 	nvmeq->q_db = &dev->dbs[qid << (dev->db_stride + 1)];
-	memset(nvmeq->cmdid_data, 0, extra);
 	memset((void *)nvmeq->cqes, 0, CQ_SIZE(nvmeq->q_depth));
-	nvme_cancel_ios(nvmeq, false);
+	if (nvmeq->admin)
+		nvme_cancel_admin_ios(nvmeq, false);
 	nvmeq->q_suspended = 0;
 }
 
@@ -1268,6 +1204,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 		nvmeq = nvme_alloc_queue(dev, 0, NVME_ADMIN_Q_DEPTH, 0);
 		if (!nvmeq)
 			return -ENOMEM;
+
 		dev->queues[0] = nvmeq;
 	}
 
@@ -1370,7 +1307,6 @@ void nvme_unmap_user_pages(struct nvme_dev *dev, int write,
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
 	struct nvme_dev *dev = ns->dev;
-	struct nvme_queue *nvmeq;
 	struct nvme_user_io io;
 	struct nvme_command c;
 	unsigned length, meta_len;
@@ -1446,20 +1382,10 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 
 	length = nvme_setup_prps(dev, &c.common, iod, length, GFP_KERNEL);
 
-	nvmeq = get_nvmeq(dev);
-	/*
-	 * Since nvme_submit_sync_cmd sleeps, we can't keep preemption
-	 * disabled.  We may be preempted at any point, and be rescheduled
-	 * to a different CPU.  That will cause cacheline bouncing, but no
-	 * additional races since q_lock already protects against other CPUs.
-	 */
-	put_nvmeq(nvmeq);
 	if (length != (io.nblocks + 1) << ns->lba_shift)
 		status = -ENOMEM;
-	else if (!nvmeq || nvmeq->q_suspended)
-		status = -EBUSY;
 	else
-		status = nvme_submit_sync_cmd(nvmeq, &c, NULL, NVME_IO_TIMEOUT);
+		status = nvme_submit_user_sync_cmd(ns, &c, NULL);
 
 	if (meta_len) {
 		if (status == NVME_SC_SUCCESS && !(io.opcode & 1)) {
@@ -1487,7 +1413,6 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 		nvme_unmap_user_pages(dev, io.opcode & 1, meta_iod);
 		nvme_free_iod(dev, meta_iod);
 	}
-
 	return status;
 }
 
@@ -1533,8 +1458,8 @@ static int nvme_user_admin_cmd(struct nvme_dev *dev,
 	if (length != cmd.data_len)
 		status = -ENOMEM;
 	else
-		status = nvme_submit_sync_cmd(dev->queues[0], &c, &cmd.result,
-								timeout);
+		status = nvme_submit_admin_sync_cmd_timeout(dev, &c,
+							&cmd.result, timeout);
 
 	if (cmd.data_len) {
 		nvme_unmap_user_pages(dev, cmd.opcode & 1, iod);
@@ -1576,25 +1501,6 @@ static const struct block_device_operations nvme_fops = {
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
@@ -1612,8 +1518,8 @@ static int nvme_kthread(void *data)
 				if (nvmeq->q_suspended)
 					goto unlock;
 				nvme_process_cq(nvmeq);
-				nvme_cancel_ios(nvmeq, true);
-				nvme_resubmit_bios(nvmeq);
+				if (unlikely(nvmeq->admin))
+					nvme_cancel_admin_ios(nvmeq, true);
  unlock:
 				spin_unlock_irq(&nvmeq->q_lock);
 			}
@@ -1661,6 +1567,85 @@ static void nvme_config_discard(struct nvme_ns *ns)
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, ns->queue);
 }
 
+static struct blk_mq_hw_ctx *nvme_alloc_hctx(struct blk_mq_reg *reg,
+			  unsigned int i)
+{
+	return kmalloc_node(sizeof(struct blk_mq_hw_ctx),
+				GFP_KERNEL | __GFP_ZERO, cpu_to_node(i));
+}
+
+static void nvme_free_hctx(struct blk_mq_hw_ctx *hctx, unsigned int i)
+{
+	kfree(hctx);
+}
+
+/*
+ * Link nvmeq to hctx and vice versa
+ */
+static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
+			  unsigned int i)
+{
+	struct nvme_ns *ns = data;
+	struct nvme_dev *dev = ns->dev;
+	struct nvme_queue *nq;
+
+	nq = dev->queues[i + 1];
+
+	hctx->driver_data = nq;
+	nq->hctx = hctx;
+
+	return 0;
+}
+
+static enum blk_eh_timer_return nvme_timeout(struct request *rq)
+{
+	void *ctx;
+	struct nvme_cmd_info *info = nvme_get_cmd_from_rq(rq);
+	struct nvme_queue *nvmeq = info->hctx->driver_data;
+	nvme_completion_fn fn;
+	static struct nvme_completion cqe = {
+		.status = cpu_to_le16(NVME_SC_ABORT_REQ << 1)
+	};
+
+	dev_warn(nvmeq->q_dmadev, "Cancelling I/O %d\n", rq->tag);
+	ctx = cancel_user_cmd_info(nvmeq, rq->tag, &fn);
+
+	spin_lock_irq(&nvmeq->q_lock);
+	fn(nvmeq->dev, ctx, &cqe);
+	spin_unlock_irq(&nvmeq->q_lock);
+
+	return BLK_EH_HANDLED;
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
+
+	.timeout		= nvme_timeout,
+};
+
+static struct blk_mq_reg nvme_mq_reg = {
+	.ops			= &nvme_mq_ops,
+	.timeout		= NVME_IO_TIMEOUT,
+	.numa_node		= NUMA_NO_NODE,
+	.reserved_tags	= NVME_ADMIN_Q_DEPTH,
+	.cmd_size		= sizeof(struct nvme_cmd_info),
+	.flags			= BLK_MQ_F_SHOULD_MERGE,
+};
+
+static void nvme_init_cmd_infos(void *data, struct blk_mq_hw_ctx *hctx,
+				struct request *rq, unsigned int i)
+{
+	struct nvme_cmd_info *info = nvme_get_cmd_from_rq(rq);
+	info->hctx = hctx;
+}
+
 static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 			struct nvme_id_ns *id, struct nvme_lba_range_type *rt)
 {
@@ -1674,16 +1659,21 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
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
 
+	blk_mq_init_commands(ns->queue, nvme_init_cmd_infos, ns);
+
 	disk = alloc_disk(NVME_MINORS);
 	if (!disk)
 		goto out_free_queue;
@@ -1712,7 +1702,7 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 	return ns;
 
  out_free_queue:
-	blk_cleanup_queue(ns->queue);
+	blk_mq_free_queue(ns->queue);
  out_free_ns:
 	kfree(ns);
 	return NULL;
@@ -1720,10 +1710,15 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 
 static void nvme_ns_free(struct nvme_ns *ns)
 {
+	struct nvme_dev *dev = ns->dev;
 	int index = ns->disk->first_minor / NVME_MINORS;
-	put_disk(ns->disk);
+
+	blk_mq_free_queue(ns->queue);
+
+	nvme_free_queue(dev->queues[0]);
+
 	nvme_put_ns_idx(index);
-	blk_cleanup_queue(ns->queue);
+	put_disk(ns->disk);
 	kfree(ns);
 }
 
@@ -1817,21 +1812,6 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 		goto free_queues;
 	}
 
-	/* Free previously allocated queues that are no longer usable */
-	spin_lock(&dev_list_lock);
-	for (i = dev->queue_count - 1; i > nr_io_queues; i--) {
-		struct nvme_queue *nvmeq = dev->queues[i];
-
-		spin_lock(&nvmeq->q_lock);
-		nvme_cancel_ios(nvmeq, false);
-		spin_unlock(&nvmeq->q_lock);
-
-		nvme_free_queue(nvmeq);
-		dev->queue_count--;
-		dev->queues[i] = NULL;
-	}
-	spin_unlock(&dev_list_lock);
-
 	cpu = cpumask_first(cpu_online_mask);
 	for (i = 0; i < nr_io_queues; i++) {
 		irq_set_affinity_hint(dev->entry[i].vector, get_cpu_mask(cpu));
@@ -1862,6 +1842,9 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 		}
 	}
 
+	nvme_mq_reg.nr_hw_queues = dev->queue_count - 1;
+	nvme_mq_reg.queue_depth = q_depth;
+
 	return 0;
 
  free_queues:
@@ -2277,9 +2260,9 @@ static struct pci_driver nvme_driver = {
 	.id_table	= nvme_id_table,
 	.probe		= nvme_probe,
 	.remove		= nvme_remove,
-	.driver		= {
+/*	.driver		= {
 		.pm	= &nvme_dev_pm_ops,
-	},
+	},*/
 	.err_handler	= &nvme_err_handler,
 };
 
diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index 4a4ff4e..0420c872 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/nvme.h>
-#include <linux/bio.h>
 #include <linux/bitops.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -1019,7 +1018,7 @@ static int nvme_trans_log_info_exceptions(struct nvme_ns *ns,
 	c.common.prp1 = cpu_to_le64(dma_addr);
 	c.common.cdw10[0] = cpu_to_le32(((sizeof(struct nvme_smart_log) /
 			BYTES_TO_DWORDS) << 16) | NVME_GET_SMART_LOG_PAGE);
-	res = nvme_submit_admin_cmd(dev, &c, NULL);
+	res = nvme_submit_admin_sync_cmd(dev, &c, NULL);
 	if (res != NVME_SC_SUCCESS) {
 		temp_c = LOG_TEMP_UNKNOWN;
 	} else {
@@ -1087,7 +1086,7 @@ static int nvme_trans_log_temperature(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	c.common.prp1 = cpu_to_le64(dma_addr);
 	c.common.cdw10[0] = cpu_to_le32(((sizeof(struct nvme_smart_log) /
 			BYTES_TO_DWORDS) << 16) | NVME_GET_SMART_LOG_PAGE);
-	res = nvme_submit_admin_cmd(dev, &c, NULL);
+	res = nvme_submit_admin_sync_cmd(dev, &c, NULL);
 	if (res != NVME_SC_SUCCESS) {
 		temp_c_cur = LOG_TEMP_UNKNOWN;
 	} else {
@@ -1575,7 +1574,7 @@ static int nvme_trans_send_fw_cmd(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 		c.common.cdw10[0] = cpu_to_le32(cdw10);
 	}
 
-	nvme_sc = nvme_submit_admin_cmd(dev, &c, NULL);
+	nvme_sc = nvme_submit_admin_sync_cmd(dev, &c, NULL);
 	res = nvme_trans_status_code(hdr, nvme_sc);
 	if (res)
 		goto out_unmap;
@@ -1937,7 +1936,7 @@ static int nvme_trans_fmt_send_cmd(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	c.format.nsid = cpu_to_le32(ns->ns_id);
 	c.format.cdw10 = cpu_to_le32(cdw10);
 
-	nvme_sc = nvme_submit_admin_cmd(dev, &c, NULL);
+	nvme_sc = nvme_submit_admin_sync_cmd(dev, &c, NULL);
 	res = nvme_trans_status_code(hdr, nvme_sc);
 	if (res)
 		goto out_dma;
@@ -2032,7 +2031,6 @@ static int nvme_trans_do_nvme_io(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	int res = SNTI_TRANSLATION_SUCCESS;
 	int nvme_sc;
 	struct nvme_dev *dev = ns->dev;
-	struct nvme_queue *nvmeq;
 	u32 num_cmds;
 	struct nvme_iod *iod;
 	u64 unit_len;
@@ -2105,18 +2103,7 @@ static int nvme_trans_do_nvme_io(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 
 		nvme_offset += unit_num_blocks;
 
-		nvmeq = get_nvmeq(dev);
-		/*
-		 * Since nvme_submit_sync_cmd sleeps, we can't keep
-		 * preemption disabled.  We may be preempted at any
-		 * point, and be rescheduled to a different CPU.  That
-		 * will cause cacheline bouncing, but no additional
-		 * races since q_lock already protects against other
-		 * CPUs.
-		 */
-		put_nvmeq(nvmeq);
-		nvme_sc = nvme_submit_sync_cmd(nvmeq, &c, NULL,
-						NVME_IO_TIMEOUT);
+		nvme_sc = nvme_submit_user_sync_cmd(ns, &c, NULL);
 		if (nvme_sc != NVME_SC_SUCCESS) {
 			nvme_unmap_user_pages(dev,
 				(is_write) ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
@@ -2643,7 +2630,6 @@ static int nvme_trans_start_stop(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 {
 	int res = SNTI_TRANSLATION_SUCCESS;
 	int nvme_sc;
-	struct nvme_queue *nvmeq;
 	struct nvme_command c;
 	u8 immed, pcmod, pc, no_flush, start;
 
@@ -2670,9 +2656,7 @@ static int nvme_trans_start_stop(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 			c.common.opcode = nvme_cmd_flush;
 			c.common.nsid = cpu_to_le32(ns->ns_id);
 
-			nvmeq = get_nvmeq(ns->dev);
-			put_nvmeq(nvmeq);
-			nvme_sc = nvme_submit_sync_cmd(nvmeq, &c, NULL, NVME_IO_TIMEOUT);
+			nvme_sc = nvme_submit_user_sync_cmd(ns, &c, NULL);
 
 			res = nvme_trans_status_code(hdr, nvme_sc);
 			if (res)
@@ -2696,15 +2680,12 @@ static int nvme_trans_synchronize_cache(struct nvme_ns *ns,
 	int res = SNTI_TRANSLATION_SUCCESS;
 	int nvme_sc;
 	struct nvme_command c;
-	struct nvme_queue *nvmeq;
 
 	memset(&c, 0, sizeof(c));
 	c.common.opcode = nvme_cmd_flush;
 	c.common.nsid = cpu_to_le32(ns->ns_id);
 
-	nvmeq = get_nvmeq(ns->dev);
-	put_nvmeq(nvmeq);
-	nvme_sc = nvme_submit_sync_cmd(nvmeq, &c, NULL, NVME_IO_TIMEOUT);
+	nvme_sc = nvme_submit_user_sync_cmd(ns, &c, NULL);
 
 	res = nvme_trans_status_code(hdr, nvme_sc);
 	if (res)
@@ -2871,7 +2852,6 @@ static int nvme_trans_unmap(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	struct nvme_dev *dev = ns->dev;
 	struct scsi_unmap_parm_list *plist;
 	struct nvme_dsm_range *range;
-	struct nvme_queue *nvmeq;
 	struct nvme_command c;
 	int i, nvme_sc, res = -ENOMEM;
 	u16 ndesc, list_len;
@@ -2913,10 +2893,7 @@ static int nvme_trans_unmap(struct nvme_ns *ns, struct sg_io_hdr *hdr,
 	c.dsm.nr = cpu_to_le32(ndesc - 1);
 	c.dsm.attributes = cpu_to_le32(NVME_DSMGMT_AD);
 
-	nvmeq = get_nvmeq(dev);
-	put_nvmeq(nvmeq);
-
-	nvme_sc = nvme_submit_sync_cmd(nvmeq, &c, NULL, NVME_IO_TIMEOUT);
+	nvme_sc = nvme_submit_user_sync_cmd(ns, &c, NULL);
 	res = nvme_trans_status_code(hdr, nvme_sc);
 
 	dma_free_coherent(&dev->pci_dev->dev, ndesc * sizeof(*range),
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 26ebcf4..21e2d8c 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -150,10 +150,9 @@ void nvme_unmap_user_pages(struct nvme_dev *dev, int write,
 			struct nvme_iod *iod);
 struct nvme_queue *get_nvmeq(struct nvme_dev *dev);
 void put_nvmeq(struct nvme_queue *nvmeq);
-int nvme_submit_sync_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
-						u32 *result, unsigned timeout);
-int nvme_submit_flush_data(struct nvme_queue *nvmeq, struct nvme_ns *ns);
-int nvme_submit_admin_cmd(struct nvme_dev *, struct nvme_command *,
+int nvme_submit_user_sync_cmd(struct nvme_ns *ns, struct nvme_command *cmd,
+							u32 *result);
+int nvme_submit_admin_sync_cmd(struct nvme_dev *dev, struct nvme_command *cmd,
 							u32 *result);
 int nvme_identify(struct nvme_dev *, unsigned nsid, unsigned cns,
 							dma_addr_t dma_addr);
-- 
1.8.1.2

