Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbaAJCl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:41:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:49025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbaAJCkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:40:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="456463666"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 6/6] NVMe: Add support for rw_page
Date: Thu,  9 Jan 2014 21:39:51 -0500
Message-Id: <1389321591-25455-6-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748522.git.matthew.r.wilcox@intel.com>
References: <cover.1387748522.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

This demonstrates the full potential of rw_page in a real device driver.
By adding a dma_addr_t to the preallocated per-command data structure, we
can avoid doing any memory allocation in the rw_page path.  For example,
that lets us swap without allocating any memory.

Also, this is against the version of the driver in the development tree,
not upstream.  So it won't apply.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/block/nvme-core.c | 129 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 105 insertions(+), 24 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index b59a93a..3af7f73 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -117,12 +117,13 @@ static inline void _nvme_check_size(void)
 	BUILD_BUG_ON(sizeof(struct nvme_smart_log) != 512);
 }
 
-typedef void (*nvme_completion_fn)(struct nvme_dev *, void *,
+typedef void (*nvme_completion_fn)(struct nvme_dev *, void *, dma_addr_t,
 						struct nvme_completion *);
 
 struct nvme_cmd_info {
 	nvme_completion_fn fn;
 	void *ctx;
+	dma_addr_t dma;
 	unsigned long timeout;
 	int aborted;
 };
@@ -152,7 +153,7 @@ static unsigned nvme_queue_extra(int depth)
  * May be called with local interrupts disabled and the q_lock held,
  * or with interrupts enabled and no locks held.
  */
-static int alloc_cmdid(struct nvme_queue *nvmeq, void *ctx,
+static int alloc_cmdid(struct nvme_queue *nvmeq, void *ctx, dma_addr_t dma,
 				nvme_completion_fn handler, unsigned timeout)
 {
 	int depth = nvmeq->q_depth - 1;
@@ -167,17 +168,18 @@ static int alloc_cmdid(struct nvme_queue *nvmeq, void *ctx,
 
 	info[cmdid].fn = handler;
 	info[cmdid].ctx = ctx;
+	info[cmdid].dma = dma;
 	info[cmdid].timeout = jiffies + timeout;
 	info[cmdid].aborted = 0;
 	return cmdid;
 }
 
-static int alloc_cmdid_killable(struct nvme_queue *nvmeq, void *ctx,
+static int alloc_cmdid_killable(struct nvme_queue *nvmeq, void *ctx, dma_addr_t dma,
 				nvme_completion_fn handler, unsigned timeout)
 {
 	int cmdid;
 	wait_event_killable(nvmeq->sq_full,
-		(cmdid = alloc_cmdid(nvmeq, ctx, handler, timeout)) >= 0);
+		(cmdid = alloc_cmdid(nvmeq, ctx, dma, handler, timeout)) >= 0);
 	return (cmdid < 0) ? -EINTR : cmdid;
 }
 
@@ -189,7 +191,7 @@ static int alloc_cmdid_killable(struct nvme_queue *nvmeq, void *ctx,
 #define CMD_CTX_FLUSH		(0x318 + CMD_CTX_BASE)
 #define CMD_CTX_ABORT		(0x31C + CMD_CTX_BASE)
 
-static void special_completion(struct nvme_dev *dev, void *ctx,
+static void special_completion(struct nvme_dev *dev, void *ctx, dma_addr_t dma,
 						struct nvme_completion *cqe)
 {
 	if (ctx == CMD_CTX_CANCELLED)
@@ -216,7 +218,7 @@ static void special_completion(struct nvme_dev *dev, void *ctx,
 	dev_warn(&dev->pci_dev->dev, "Unknown special completion %p\n", ctx);
 }
 
-static void async_completion(struct nvme_dev *dev, void *ctx,
+static void async_completion(struct nvme_dev *dev, void *ctx, dma_addr_t dma,
 						struct nvme_completion *cqe)
 {
 	struct async_cmd_info *cmdinfo = ctx;
@@ -228,7 +230,7 @@ static void async_completion(struct nvme_dev *dev, void *ctx,
 /*
  * Called with local interrupts disabled and the q_lock held.  May not sleep.
  */
-static void *free_cmdid(struct nvme_queue *nvmeq, int cmdid,
+static void *free_cmdid(struct nvme_queue *nvmeq, int cmdid, dma_addr_t *dmap,
 						nvme_completion_fn *fn)
 {
 	void *ctx;
@@ -240,6 +242,8 @@ static void *free_cmdid(struct nvme_queue *nvmeq, int cmdid,
 	}
 	if (fn)
 		*fn = info[cmdid].fn;
+	if (dmap)
+		*dmap = info[cmdid].dma;
 	ctx = info[cmdid].ctx;
 	info[cmdid].fn = special_completion;
 	info[cmdid].ctx = CMD_CTX_COMPLETED;
@@ -248,13 +252,15 @@ static void *free_cmdid(struct nvme_queue *nvmeq, int cmdid,
 	return ctx;
 }
 
-static void *cancel_cmdid(struct nvme_queue *nvmeq, int cmdid,
+static void *cancel_cmdid(struct nvme_queue *nvmeq, int cmdid, dma_addr_t *dmap,
 						nvme_completion_fn *fn)
 {
 	void *ctx;
 	struct nvme_cmd_info *info = nvme_cmd_info(nvmeq);
 	if (fn)
 		*fn = info[cmdid].fn;
+	if (dmap)
+		*dmap = info[cmdid].dma;
 	ctx = info[cmdid].ctx;
 	info[cmdid].fn = special_completion;
 	info[cmdid].ctx = CMD_CTX_CANCELLED;
@@ -370,7 +376,7 @@ static void nvme_end_io_acct(struct bio *bio, unsigned long start_time)
 	part_stat_unlock();
 }
 
-static void bio_completion(struct nvme_dev *dev, void *ctx,
+static void bio_completion(struct nvme_dev *dev, void *ctx, dma_addr_t dma,
 						struct nvme_completion *cqe)
 {
 	struct nvme_iod *iod = ctx;
@@ -674,7 +680,7 @@ static int nvme_submit_flush(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 
 int nvme_submit_flush_data(struct nvme_queue *nvmeq, struct nvme_ns *ns)
 {
-	int cmdid = alloc_cmdid(nvmeq, (void *)CMD_CTX_FLUSH,
+	int cmdid = alloc_cmdid(nvmeq, (void *)CMD_CTX_FLUSH, 0,
 					special_completion, NVME_IO_TIMEOUT);
 	if (unlikely(cmdid < 0))
 		return cmdid;
@@ -709,7 +715,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	iod->private = bio;
 
 	result = -EBUSY;
-	cmdid = alloc_cmdid(nvmeq, iod, bio_completion, NVME_IO_TIMEOUT);
+	cmdid = alloc_cmdid(nvmeq, iod, 0, bio_completion, NVME_IO_TIMEOUT);
 	if (unlikely(cmdid < 0))
 		goto free_iod;
 
@@ -765,7 +771,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	return 0;
 
  free_cmdid:
-	free_cmdid(nvmeq, cmdid, NULL);
+	free_cmdid(nvmeq, cmdid, NULL, NULL);
  free_iod:
 	nvme_free_iod(nvmeq->dev, iod);
  nomem:
@@ -781,6 +787,7 @@ static int nvme_process_cq(struct nvme_queue *nvmeq)
 
 	for (;;) {
 		void *ctx;
+		dma_addr_t dma;
 		nvme_completion_fn fn;
 		struct nvme_completion cqe = nvmeq->cqes[head];
 		if ((le16_to_cpu(cqe.status) & 1) != phase)
@@ -791,8 +798,8 @@ static int nvme_process_cq(struct nvme_queue *nvmeq)
 			phase = !phase;
 		}
 
-		ctx = free_cmdid(nvmeq, cqe.command_id, &fn);
-		fn(nvmeq->dev, ctx, &cqe);
+		ctx = free_cmdid(nvmeq, cqe.command_id, &dma, &fn);
+		fn(nvmeq->dev, ctx, dma, &cqe);
 	}
 
 	/* If the controller ignores the cq head doorbell and continuously
@@ -862,7 +869,7 @@ static irqreturn_t nvme_irq_check(int irq, void *data)
 static void nvme_abort_command(struct nvme_queue *nvmeq, int cmdid)
 {
 	spin_lock_irq(&nvmeq->q_lock);
-	cancel_cmdid(nvmeq, cmdid, NULL);
+	cancel_cmdid(nvmeq, cmdid, NULL, NULL);
 	spin_unlock_irq(&nvmeq->q_lock);
 }
 
@@ -872,7 +879,7 @@ struct sync_cmd_info {
 	int status;
 };
 
-static void sync_completion(struct nvme_dev *dev, void *ctx,
+static void sync_completion(struct nvme_dev *dev, void *ctx, dma_addr_t dma,
 						struct nvme_completion *cqe)
 {
 	struct sync_cmd_info *cmdinfo = ctx;
@@ -894,7 +901,7 @@ int nvme_submit_sync_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
 	cmdinfo.task = current;
 	cmdinfo.status = -EINTR;
 
-	cmdid = alloc_cmdid_killable(nvmeq, &cmdinfo, sync_completion,
+	cmdid = alloc_cmdid_killable(nvmeq, &cmdinfo, 0, sync_completion,
 								timeout);
 	if (cmdid < 0)
 		return cmdid;
@@ -919,9 +926,8 @@ int nvme_submit_async_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
 						struct async_cmd_info *cmdinfo,
 						unsigned timeout)
 {
-	int cmdid;
-
-	cmdid = alloc_cmdid_killable(nvmeq, cmdinfo, async_completion, timeout);
+	int cmdid = alloc_cmdid_killable(nvmeq, cmdinfo, 0, async_completion,
+								timeout);
 	if (cmdid < 0)
 		return cmdid;
 	cmdinfo->status = -EINTR;
@@ -1081,8 +1087,8 @@ static void nvme_abort_cmd(int cmdid, struct nvme_queue *nvmeq)
 	if (!dev->abort_limit)
 		return;
 
-	a_cmdid = alloc_cmdid(dev->queues[0], CMD_CTX_ABORT, special_completion,
-								ADMIN_TIMEOUT);
+	a_cmdid = alloc_cmdid(dev->queues[0], CMD_CTX_ABORT, 0,
+				special_completion, ADMIN_TIMEOUT);
 	if (a_cmdid < 0)
 		return;
 
@@ -1115,6 +1121,7 @@ static void nvme_cancel_ios(struct nvme_queue *nvmeq, bool timeout)
 
 	for_each_set_bit(cmdid, nvmeq->cmdid_data, depth) {
 		void *ctx;
+		dma_addr_t dma;
 		nvme_completion_fn fn;
 		static struct nvme_completion cqe = {
 			.status = cpu_to_le16(NVME_SC_ABORT_REQ << 1),
@@ -1130,8 +1137,8 @@ static void nvme_cancel_ios(struct nvme_queue *nvmeq, bool timeout)
 		}
 		dev_warn(nvmeq->q_dmadev, "Cancelling I/O %d QID %d\n", cmdid,
 								nvmeq->qid);
-		ctx = cancel_cmdid(nvmeq, cmdid, &fn);
-		fn(nvmeq->dev, ctx, &cqe);
+		ctx = cancel_cmdid(nvmeq, cmdid, &dma, &fn);
+		fn(nvmeq->dev, ctx, dma, &cqe);
 	}
 }
 
@@ -1617,6 +1624,79 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	return status;
 }
 
+static void pgrd_completion(struct nvme_dev *dev, void *ctx, dma_addr_t dma,
+						struct nvme_completion *cqe)
+{
+	struct page *page = ctx;
+	u16 status = le16_to_cpup(&cqe->status) >> 1;
+
+	dma_unmap_page(&dev->pci_dev->dev, dma,
+			PAGE_CACHE_SIZE, DMA_FROM_DEVICE);
+	page_endio(page, READ, status == NVME_SC_SUCCESS);
+}
+
+static void pgwr_completion(struct nvme_dev *dev, void *ctx, dma_addr_t dma,
+						struct nvme_completion *cqe)
+{
+	struct page *page = ctx;
+	u16 status = le16_to_cpup(&cqe->status) >> 1;
+
+	dma_unmap_page(&dev->pci_dev->dev, dma, PAGE_CACHE_SIZE, DMA_TO_DEVICE);
+	page_endio(page, WRITE, status == NVME_SC_SUCCESS);
+}
+
+static const enum dma_data_direction nvme_to_direction[] = {
+	DMA_NONE, DMA_TO_DEVICE, DMA_FROM_DEVICE, DMA_BIDIRECTIONAL
+};
+
+static int nvme_rw_page(struct block_device *bdev, sector_t sector,
+			struct page *page, int rw)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+	u8 op = (rw & WRITE) ? nvme_cmd_write : nvme_cmd_read;
+	nvme_completion_fn fn = (rw & WRITE) ? pgwr_completion :
+					       pgrd_completion;
+	dma_addr_t dma;
+	int cmdid;
+	struct nvme_command *cmd;
+	enum dma_data_direction dma_dir = nvme_to_direction[op & 3];
+	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
+	dma = dma_map_page(nvmeq->q_dmadev, page, 0, PAGE_CACHE_SIZE, dma_dir);
+
+	if (rw == WRITE)
+		cmdid = alloc_cmdid(nvmeq, page, dma, fn, NVME_IO_TIMEOUT);
+	else
+		cmdid = alloc_cmdid_killable(nvmeq, page, dma, fn,
+							NVME_IO_TIMEOUT);
+	if (unlikely(cmdid < 0)) {
+		dma_unmap_page(nvmeq->q_dmadev, dma, PAGE_CACHE_SIZE,
+							DMA_FROM_DEVICE);
+		put_nvmeq(nvmeq);
+		return -EBUSY;
+	}
+
+	spin_lock_irq(&nvmeq->q_lock);
+	cmd = &nvmeq->sq_cmds[nvmeq->sq_tail];
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->rw.opcode = op;
+	cmd->rw.command_id = cmdid;
+	cmd->rw.nsid = cpu_to_le32(ns->ns_id);
+	cmd->rw.slba = cpu_to_le64(nvme_block_nr(ns, sector));
+	cmd->rw.length = cpu_to_le16((PAGE_CACHE_SIZE >> ns->lba_shift) - 1);
+	cmd->rw.prp1 = cpu_to_le64(dma);
+
+	if (++nvmeq->sq_tail == nvmeq->q_depth)
+		nvmeq->sq_tail = 0;
+	writel(nvmeq->sq_tail, nvmeq->q_db);
+
+	put_nvmeq(nvmeq);
+	nvme_process_cq(nvmeq);
+	spin_unlock_irq(&nvmeq->q_lock);
+
+	return 0;
+}
+
 static int nvme_user_admin_cmd(struct nvme_dev *dev,
 					struct nvme_admin_cmd __user *ucmd)
 {
@@ -1714,6 +1794,7 @@ static int nvme_compat_ioctl(struct block_device *bdev, fmode_t mode,
 
 static const struct block_device_operations nvme_fops = {
 	.owner		= THIS_MODULE,
+	.rw_page	= nvme_rw_page,
 	.ioctl		= nvme_ioctl,
 	.compat_ioctl	= nvme_compat_ioctl,
 };
-- 
1.8.5.2

