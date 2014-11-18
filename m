Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaKRToz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:44:55 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64494 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbaKRTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:42:39 -0500
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: hch@infradead.org, axboe@fb.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: thornber@redhat.com, bvanassche@acm.org, jmad@itu.dk,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [RFC PATCH 3/5] lightnvm: Support for Open-Channel SSDs
Date: Tue, 18 Nov 2014 20:41:57 +0100
Message-Id: <1416339719-8488-4-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416339719-8488-1-git-send-email-m@bjorling.me>
References: <1416339719-8488-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open-channel SSDs are devices exposes direct access to its physical
flash storage, while keeping a subset of the internal features of SSDs.

A common SSD consists of a flash translation layer (FTL), bad block
management, and hardware units such as flash controller and host
interface controller and a large amount of flash chips.

LightNVM moves part of the FTL responsibility into the host, allowing
the host to manage data placement, garbage collection and parallelism.
The device continues to maintain information about bad block management,
implements a simpler FTL, that allows extensions such as atomic IOs, metadata
persistence and similar to be implemented.

The architecture of LightNVM consists of a core and multiple targets.
The core has the part of the driver that is shared across targets,
initialization and teardown and statistics. The other part is targets. They are
how physical flash are exposed to user-land. This can be as the block device,
key-value store, object-store, or anything else.

Contributions in this patch from:

  Jesper Madsen <jmad@itu.dk>

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 block/Makefile             |   1 +
 block/blk-lightnvm.c       |  81 +++++++
 block/blk-mq.c             |  35 ++-
 block/blk-sysfs.c          |  13 +
 block/blk.h                |  14 ++
 block/ioctl.c              |   1 +
 drivers/Kconfig            |   2 +
 drivers/Makefile           |   1 +
 drivers/lightnvm/Kconfig   |  20 ++
 drivers/lightnvm/Makefile  |   5 +
 drivers/lightnvm/core.c    | 208 ++++++++++++++++
 drivers/lightnvm/gc.c      | 370 ++++++++++++++++++++++++++++
 drivers/lightnvm/nvm.c     | 460 +++++++++++++++++++++++++++++++++++
 drivers/lightnvm/nvm.h     | 588 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/lightnvm/sysfs.c   |  68 ++++++
 drivers/lightnvm/targets.c | 244 +++++++++++++++++++
 include/linux/blk-mq.h     |   1 +
 include/linux/blkdev.h     |  23 ++
 include/linux/lightnvm.h   | 112 +++++++++
 include/trace/events/nvm.h |  70 ++++++
 20 files changed, 2313 insertions(+), 4 deletions(-)
 create mode 100644 block/blk-lightnvm.c
 create mode 100644 drivers/lightnvm/Kconfig
 create mode 100644 drivers/lightnvm/Makefile
 create mode 100644 drivers/lightnvm/core.c
 create mode 100644 drivers/lightnvm/gc.c
 create mode 100644 drivers/lightnvm/nvm.c
 create mode 100644 drivers/lightnvm/nvm.h
 create mode 100644 drivers/lightnvm/sysfs.c
 create mode 100644 drivers/lightnvm/targets.c
 create mode 100644 include/linux/lightnvm.h
 create mode 100644 include/trace/events/nvm.h

diff --git a/block/Makefile b/block/Makefile
index a2ce6ac..eb9bdd2 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
 obj-$(CONFIG_BLK_CMDLINE_PARSER)	+= cmdline-parser.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o
+obj-$(CONFIG_LIGHTNVM) 		+= blk-lightnvm.o
diff --git a/block/blk-lightnvm.c b/block/blk-lightnvm.c
new file mode 100644
index 0000000..2a079f5
--- /dev/null
+++ b/block/blk-lightnvm.c
@@ -0,0 +1,81 @@
+/*
+ * blk-lightnvm.c - Block layer LightNVM Open-channel SSD integration
+ *
+ * Copyright (C) 2014 IT University of Copenhagen
+ * Written by: Matias Bjorling <mabj@itu.dk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
+ * USA.
+ *
+ */
+
+#include <linux/lightnvm.h>
+#include <linux/blkdev.h>
+
+int blk_lightnvm_register(struct request_queue *q, struct lightnvm_dev_ops *ops)
+{
+	struct nvm_dev *nvm;
+	int ret;
+
+	if (!ops->identify || !ops->get_features || !ops->set_responsibility)
+		return -EINVAL;
+
+	/* TODO: LightNVM does not yet support multi-page IOs. */
+	blk_queue_max_hw_sectors(q, queue_logical_block_size(q) >> 9);
+
+	nvm = kmalloc(sizeof(struct nvm_dev), GFP_KERNEL);
+	if (!nvm)
+		return -ENOMEM;
+
+	nvm->q = q;
+	nvm->ops = ops;
+
+	ret = nvm_init(nvm);
+	if (ret)
+		goto err_init;
+
+	q->nvm = nvm;
+
+	return 0;
+err_init:
+	kfree(nvm);
+	return ret;
+}
+EXPORT_SYMBOL(blk_lightnvm_register);
+
+void blk_lightnvm_unregister(struct request_queue *q)
+{
+	if (!q->nvm)
+		return;
+
+	nvm_exit(q->nvm);
+}
+
+int blk_lightnvm_map(struct nvm_dev *nvm, struct request *rq)
+{
+	if (rq->cmd_flags & REQ_NVM_MAPPED)
+		return -EINVAL;
+
+	return nvm_map_rq(nvm, rq);
+}
+
+int blk_lightnvm_init_sysfs(struct device *dev)
+{
+	return nvm_add_sysfs(dev);
+}
+
+void blk_lightnvm_remove_sysfs(struct device *dev)
+{
+	nvm_remove_sysfs(dev);
+}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index df8e1e0..09b1217 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -20,6 +20,7 @@
 #include <linux/cache.h>
 #include <linux/sched/sysctl.h>
 #include <linux/delay.h>
+#include <linux/lightnvm.h>
 
 #include <trace/events/block.h>
 
@@ -199,6 +200,9 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
 
+#if CONFIG_LIGHTNVM
+	rq->phys_sector = 0;
+#endif
 	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
 }
 
@@ -307,6 +311,11 @@ void blk_mq_clone_flush_request(struct request *flush_rq,
 
 inline void __blk_mq_end_io(struct request *rq, int error)
 {
+	struct request_queue *q = rq->q;
+
+	if (blk_queue_lightnvm(q))
+		nvm_complete_request(q->nvm, rq, error);
+
 	blk_account_io_done(rq);
 
 	if (rq->end_io) {
@@ -1082,10 +1091,16 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 static void blk_mq_bio_to_request(struct request *rq, struct bio *bio)
 {
+	struct request_queue *q = rq->q;
+
 	init_request_from_bio(rq, bio);
 
 	if (blk_do_io_stat(rq))
 		blk_account_io_start(rq, 1);
+
+	/* TODO: error handling */
+	if (blk_queue_lightnvm(q))
+		blk_lightnvm_map(q->nvm, rq);
 }
 
 static inline bool hctx_allow_merges(struct blk_mq_hw_ctx *hctx)
@@ -1361,6 +1376,7 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 	struct blk_mq_tags *tags;
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
+	unsigned int cmd_size = set->cmd_size;
 
 	tags = blk_mq_init_tags(set->queue_depth, set->reserved_tags,
 				set->numa_node);
@@ -1377,11 +1393,14 @@ static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
 		return NULL;
 	}
 
+	if (set->flags & BLK_MQ_F_LIGHTNVM)
+		cmd_size += nvm_cmd_size();
+
 	/*
 	 * rq_size is the size of the request plus driver payload, rounded
 	 * to the cacheline size
 	 */
-	rq_size = round_up(sizeof(struct request) + set->cmd_size,
+	rq_size = round_up(sizeof(struct request) + cmd_size,
 				cache_line_size());
 	left = rq_size * set->queue_depth;
 
@@ -1597,7 +1616,10 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 		hctx->queue = q;
 		hctx->queue_num = i;
 		hctx->flags = set->flags;
-		hctx->cmd_size = set->cmd_size;
+		if (set->flags & BLK_MQ_F_LIGHTNVM)
+			hctx->cmd_size = set->cmd_size + nvm_cmd_size();
+		else
+			hctx->cmd_size = set->cmd_size;
 
 		blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
 						blk_mq_hctx_notify, hctx);
@@ -1769,6 +1791,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	struct request_queue *q;
 	unsigned int *map;
 	int i;
+	unsigned int cmd_size = set->cmd_size;
 
 	ctx = alloc_percpu(struct blk_mq_ctx);
 	if (!ctx)
@@ -1823,6 +1846,11 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	if (!(set->flags & BLK_MQ_F_SG_MERGE))
 		q->queue_flags |= 1 << QUEUE_FLAG_NO_SG_MERGE;
 
+	if (set->flags & BLK_MQ_F_LIGHTNVM) {
+		q->queue_flags |= 1 << QUEUE_FLAG_LIGHTNVM;
+		cmd_size += nvm_cmd_size();
+	}
+
 	q->sg_reserved_size = INT_MAX;
 
 	INIT_WORK(&q->requeue_work, blk_mq_requeue_work);
@@ -1850,8 +1878,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 
 	q->flush_rq = kzalloc(round_up(sizeof(struct request) +
-				set->cmd_size, cache_line_size()),
-				GFP_KERNEL);
+				cmd_size, cache_line_size()), GFP_KERNEL);
 	if (!q->flush_rq)
 		goto err_hw;
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 17f5c84..e07e6f01 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -7,6 +7,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
+#include <linux/lightnvm.h>
 #include <linux/blk-mq.h>
 
 #include "blk.h"
@@ -550,6 +551,10 @@ int blk_register_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return -ENXIO;
 
+	/* FIXME: How to get from queue to disk (used by lightnvm gc)? */
+	if (q->nvm)
+		q->nvm->disk = disk;
+
 	/*
 	 * Initialization must be complete by now.  Finish the initial
 	 * bypass from queue allocation.
@@ -563,6 +568,10 @@ int blk_register_queue(struct gendisk *disk)
 	if (ret)
 		return ret;
 
+	ret = blk_lightnvm_init_sysfs(dev);
+	if (ret)
+		return ret;
+
 	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
 	if (ret < 0) {
 		blk_trace_remove_sysfs(dev);
@@ -596,6 +605,9 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return;
 
+	if (q->nvm)
+		blk_lightnvm_unregister(q);
+
 	if (q->mq_ops)
 		blk_mq_unregister_disk(disk);
 
@@ -604,6 +616,7 @@ void blk_unregister_queue(struct gendisk *disk)
 
 	kobject_uevent(&q->kobj, KOBJ_REMOVE);
 	kobject_del(&q->kobj);
+	blk_lightnvm_remove_sysfs(disk_to_dev(disk));
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 	kobject_put(&disk_to_dev(disk)->kobj);
 }
diff --git a/block/blk.h b/block/blk.h
index 6748c4f..a68bb02 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -252,4 +252,18 @@ static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
+#ifdef CONFIG_LIGHTNVM
+struct lightnvm_dev_ops;
+
+extern void blk_lightnvm_unregister(struct request_queue *);
+extern int blk_lightnvm_map(struct nvm_dev *nvm, struct request *rq);
+extern int blk_lightnvm_init_sysfs(struct device *);
+extern void blk_lightnvm_remove_sysfs(struct device *);
+#else
+static void blk_lightnvm_unregister(struct request_queue *q) { }
+static int blk_lightnvm_map(struct nvm_dev *nvm, struct request *rq) { return -EINVAL; }
+static int blk_lightnvm_init_sysfs(struct device *) { return 0; }
+static void blk_lightnvm_remove_sysfs(struct device *) { }
+#endif /* CONFIG_LIGHTNVM */
+
 #endif /* BLK_INTERNAL_H */
diff --git a/block/ioctl.c b/block/ioctl.c
index d6cda81..1a2979e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -7,6 +7,7 @@
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/blktrace_api.h>
+#include <linux/lightnvm.h>
 #include <asm/uaccess.h>
 
 static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user *arg)
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 622fa26..24815f8 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -38,6 +38,8 @@ source "drivers/message/i2o/Kconfig"
 
 source "drivers/macintosh/Kconfig"
 
+source "drivers/lightnvm/Kconfig"
+
 source "drivers/net/Kconfig"
 
 source "drivers/isdn/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index ebee555..278c31e 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_MTD)		+= mtd/
 obj-$(CONFIG_SPI)		+= spi/
 obj-$(CONFIG_SPMI)		+= spmi/
 obj-y				+= hsi/
+obj-$(CONFIG_LIGHTNVM)		+= lightnvm/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
diff --git a/drivers/lightnvm/Kconfig b/drivers/lightnvm/Kconfig
new file mode 100644
index 0000000..3ee597a
--- /dev/null
+++ b/drivers/lightnvm/Kconfig
@@ -0,0 +1,20 @@
+#
+# LightNVM configuration
+#
+
+menuconfig LIGHTNVM
+	bool "LightNVM support"
+	depends on BLK_DEV
+	default y
+	---help---
+	  Say Y here to get to enable Open-channel SSDs compatible with LightNVM
+	  to be recognized.
+
+	  LightNVM implements some internals of SSDs within the host.
+	  Devices are required to support LightNVM, and allow them to managed by
+	  the host. LightNVM is used together with an open-channel firmware, that
+	  exposes direct access to the underlying non-volatile memory.
+
+	  If you say N, all options in this submenu will be skipped and disabled;
+	  only do this if you know what you are doing.
+
diff --git a/drivers/lightnvm/Makefile b/drivers/lightnvm/Makefile
new file mode 100644
index 0000000..58c27c7
--- /dev/null
+++ b/drivers/lightnvm/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for LightNVM.
+#
+
+obj-$(CONFIG_LIGHTNVM)		+= nvm.o core.o gc.o sysfs.o targets.o
diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
new file mode 100644
index 0000000..50dca97
--- /dev/null
+++ b/drivers/lightnvm/core.c
@@ -0,0 +1,208 @@
+#include <linux/lightnvm.h>
+#include <trace/events/block.h>
+#include "nvm.h"
+
+static void invalidate_block_page(struct nvm_stor *s, struct nvm_addr *p)
+{
+	struct nvm_block *block = p->block;
+	unsigned int page_offset;
+
+	NVM_ASSERT(spin_is_locked(&s->rev_lock));
+
+	spin_lock(&block->lock);
+
+	page_offset = p->addr % s->nr_pages_per_blk;
+	WARN_ON(test_and_set_bit(page_offset, block->invalid_pages));
+	block->nr_invalid_pages++;
+
+	spin_unlock(&block->lock);
+}
+
+void nvm_update_map(struct nvm_stor *s, sector_t l_addr, struct nvm_addr *p,
+					int is_gc)
+{
+	struct nvm_addr *gp;
+	struct nvm_rev_addr *rev;
+
+	BUG_ON(l_addr >= s->nr_pages);
+	BUG_ON(p->addr >= s->nr_pages);
+
+	gp = &s->trans_map[l_addr];
+	spin_lock(&s->rev_lock);
+	if (gp->block) {
+		invalidate_block_page(s, gp);
+		s->rev_trans_map[gp->addr].addr = LTOP_POISON;
+	}
+
+	gp->addr = p->addr;
+	gp->block = p->block;
+
+	rev = &s->rev_trans_map[p->addr];
+	rev->addr = l_addr;
+	spin_unlock(&s->rev_lock);
+}
+
+/* requires pool->lock lock */
+void nvm_reset_block(struct nvm_block *block)
+{
+	struct nvm_stor *s = block->pool->s;
+
+	spin_lock(&block->lock);
+	bitmap_zero(block->invalid_pages, s->nr_pages_per_blk);
+	block->ap = NULL;
+	block->next_page = 0;
+	block->nr_invalid_pages = 0;
+	atomic_set(&block->gc_running, 0);
+	atomic_set(&block->data_cmnt_size, 0);
+	spin_unlock(&block->lock);
+}
+
+sector_t nvm_alloc_phys_addr(struct nvm_block *block)
+{
+	sector_t addr = LTOP_EMPTY;
+
+	spin_lock(&block->lock);
+
+	if (block_is_full(block))
+		goto out;
+
+	addr = block_to_addr(block) + block->next_page;
+
+	block->next_page++;
+
+out:
+	spin_unlock(&block->lock);
+	return addr;
+}
+
+/* requires ap->lock taken */
+void nvm_set_ap_cur(struct nvm_ap *ap, struct nvm_block *block)
+{
+	BUG_ON(!block);
+
+	if (ap->cur) {
+		spin_lock(&ap->cur->lock);
+		WARN_ON(!block_is_full(ap->cur));
+		spin_unlock(&ap->cur->lock);
+		ap->cur->ap = NULL;
+	}
+	ap->cur = block;
+	ap->cur->ap = ap;
+}
+
+/* Send erase command to device */
+int nvm_erase_block(struct nvm_stor *s, struct nvm_block *block)
+{
+	struct nvm_dev *dev = s->dev;
+
+	if (dev->ops->nvm_erase_block)
+		return dev->ops->nvm_erase_block(dev, block->id);
+
+	return 0;
+}
+
+void nvm_endio(struct nvm_dev *nvm_dev, struct request *rq, int err)
+{
+	struct nvm_stor *s = nvm_dev->stor;
+	struct per_rq_data *pb = get_per_rq_data(nvm_dev, rq);
+	struct nvm_addr *p = pb->addr;
+	struct nvm_block *block = p->block;
+	unsigned int data_cnt;
+
+	/* pr_debug("p: %p s: %llu l: %u pp:%p e:%u (%u)\n",
+			p, p->addr, pb->l_addr, p, err, rq_data_dir(rq)); */
+	nvm_unlock_laddr_range(s, pb->l_addr, 1);
+
+	if (rq_data_dir(rq) == WRITE) {
+		/* maintain data in buffer until block is full */
+		data_cnt = atomic_inc_return(&block->data_cmnt_size);
+		if (data_cnt == s->nr_pages_per_blk) {
+			/* cannot take the pool lock here, defer if necessary */
+			s->gc_ops->queue(block);
+		}
+	}
+
+	/* all submitted requests allocate their own addr,
+	 * except GC reads */
+	if (pb->flags & NVM_RQ_GC)
+		return;
+
+	mempool_free(pb->addr, s->addr_pool);
+}
+
+/* remember to lock l_add before calling nvm_submit_rq */
+void nvm_setup_rq(struct nvm_stor *s, struct request *rq, struct nvm_addr *p,
+		  sector_t l_addr, unsigned int flags)
+{
+	struct nvm_block *block = p->block;
+	struct nvm_ap *ap;
+	struct per_rq_data *pb;
+
+	if (block)
+		ap = block_to_ap(s, block);
+	else
+		ap = &s->aps[0];
+
+	pb = get_per_rq_data(s->dev, rq);
+	pb->ap = ap;
+	pb->addr = p;
+	pb->l_addr = l_addr;
+	pb->flags = flags;
+}
+
+int nvm_read_rq(struct nvm_stor *s, struct request *rq)
+{
+	sector_t npages = blk_rq_bytes(rq) / EXPOSED_PAGE_SIZE;
+	struct nvm_addr *p;
+	sector_t l_addr;
+
+	l_addr = blk_rq_pos(rq) / NR_PHY_IN_LOG;
+
+	nvm_lock_laddr_range(s, l_addr, npages);
+
+	p = s->type->lookup_ltop(s, l_addr);
+	if (!p) {
+		nvm_unlock_laddr_range(s, l_addr, npages);
+		s->gc_ops->kick(s);
+		return BLK_MQ_RQ_QUEUE_BUSY;
+	}
+
+	if (p->block)
+		rq->phys_sector = p->addr * NR_PHY_IN_LOG +
+					(blk_rq_pos(rq) % NR_PHY_IN_LOG);
+
+	nvm_setup_rq(s, rq, p, l_addr, NVM_RQ_NONE);
+	/* printk("nvm: R{LBA:%llu,sec:%llu}\n", p->addr, p->addr * NR_PHY_IN_LOG); */
+	return BLK_MQ_RQ_QUEUE_OK;
+}
+
+
+int __nvm_write_rq(struct nvm_stor *s, struct request *rq, int is_gc)
+{
+	sector_t npages =  blk_rq_bytes(rq) / EXPOSED_PAGE_SIZE;
+	sector_t l_addr = blk_rq_pos(rq) / NR_PHY_IN_LOG;
+	struct nvm_addr *p;
+
+	nvm_lock_laddr_range(s, l_addr, npages);
+	p = s->type->map_page(s, l_addr, is_gc);
+	if (!p) {
+		BUG_ON(is_gc);
+		nvm_unlock_laddr_range(s, l_addr, npages);
+		s->gc_ops->kick(s);
+
+		return BLK_MQ_RQ_QUEUE_BUSY;
+	}
+
+	rq->phys_sector = p->addr * NR_PHY_IN_LOG;
+	/*printk("nvm: W %llu(%llu) B: %u\n", p->addr, p->addr * NR_PHY_IN_LOG,
+			p->block->id);*/
+
+	nvm_setup_rq(s, rq, p, l_addr, NVM_RQ_NONE);
+
+	return BLK_MQ_RQ_QUEUE_OK;
+}
+
+int nvm_write_rq(struct nvm_stor *s, struct request *rq)
+{
+	return __nvm_write_rq(s, rq, 0);
+}
diff --git a/drivers/lightnvm/gc.c b/drivers/lightnvm/gc.c
new file mode 100644
index 0000000..7e9cc22
--- /dev/null
+++ b/drivers/lightnvm/gc.c
@@ -0,0 +1,370 @@
+#include <linux/lightnvm.h>
+#include "nvm.h"
+
+/* Run only GC if less than 1/X blocks are free */
+#define GC_LIMIT_INVERSE 10
+
+struct greedy_block {
+	struct nvm_block *block;
+	struct list_head prio;
+	struct work_struct ws_gc;		/* Schedule when to reclaim */
+	struct work_struct ws_queue_gc;	/* Schedule when GC'ing is allowed */
+};
+
+struct greedy_pool {
+	struct nvm_pool *pool;
+	struct list_head prio_list;		/* Blocks that may be GC'ed */
+	struct work_struct ws_gc;		/* Schedule GC'ing of pool */
+	struct greedy_block *block_mem;	/* Reference to block allocation */
+};
+
+/**
+ * nvm_gc_timer - default gc timer function.
+ * @data: ptr to the 'nvm_stor' structure
+ *
+ * Description:
+ *   NVM core configures a timer to call '.gc_timer', the default
+ *   implementation kicks the GC to force proactive behavior.
+ *
+ **/
+void nvm_gc_timer(unsigned long data)
+{
+	struct nvm_stor *s = (struct nvm_stor *)data;
+
+	s->gc_ops->kick(s);
+
+	mod_timer(&s->gc_timer,
+			jiffies + msecs_to_jiffies(s->config.gc_time));
+}
+
+/* Move data away from flash block to be erased. Additionally update the
+ * l to p and p to l mappings. */
+/**
+ * nvm_move_valid_pages -- migrate live data off the block
+ * @s: the 'nvm_stor' structure
+ * @block: the block from which to migrate live pages
+ *
+ * Description:
+ *   GC algorithms may call this function to migrate remaining live
+ *   pages off the block prior to erasing it. This function blocks
+ *   further execution until the operation is complete.
+ */
+void nvm_move_valid_pages(struct nvm_stor *s, struct nvm_block *block)
+{
+	struct nvm_dev *dev = s->dev;
+	struct request_queue *q = dev->q;
+	struct nvm_addr src;
+	struct nvm_rev_addr *rev;
+	struct bio *src_bio;
+	struct request *src_rq, *dst_rq = NULL;
+	struct page *page;
+	int slot;
+	DECLARE_COMPLETION(sync);
+
+	if (bitmap_full(block->invalid_pages, s->nr_pages_per_blk))
+		return;
+
+	while ((slot = find_first_zero_bit(block->invalid_pages,
+					   s->nr_pages_per_blk)) <
+						s->nr_pages_per_blk) {
+		/* Perform read */
+		src.addr = block_to_addr(block) + slot;
+		src.block = block;
+
+		BUG_ON(src.addr >= s->nr_pages);
+
+		src_bio = bio_alloc(GFP_NOIO, 1);
+		if (!src_bio) {
+			pr_err("nvm: failed to alloc gc bio request");
+			break;
+		}
+		src_bio->bi_iter.bi_sector = src.addr * NR_PHY_IN_LOG;
+		page = mempool_alloc(s->page_pool, GFP_NOIO);
+
+		/* TODO: may fail whem EXP_PG_SIZE > PAGE_SIZE */
+		bio_add_pc_page(q, src_bio, page, EXPOSED_PAGE_SIZE, 0);
+
+		src_rq = blk_mq_alloc_request(q, READ, GFP_KERNEL, false);
+		if (!src_rq) {
+			mempool_free(page, s->page_pool);
+			pr_err("nvm: failed to alloc gc request");
+			break;
+		}
+
+		blk_init_request_from_bio(src_rq, src_bio);
+
+		/* We take the reverse lock here, and make sure that we only
+		 * release it when we have locked its logical address. If
+		 * another write on the same logical address is
+		 * occuring, we just let it stall the pipeline.
+		 *
+		 * We do this for both the read and write. Fixing it after each
+		 * IO.
+		 */
+		spin_lock(&s->rev_lock);
+		/* We use the physical address to go to the logical page addr,
+		 * and then update its mapping to its new place. */
+		rev = &s->rev_trans_map[src.addr];
+
+		/* already updated by previous regular write */
+		if (rev->addr == LTOP_POISON) {
+			spin_unlock(&s->rev_lock);
+			goto overwritten;
+		}
+
+		/* unlocked by nvm_submit_bio nvm_endio */
+		__nvm_lock_laddr_range(s, 1, rev->addr, 1);
+		spin_unlock(&s->rev_lock);
+
+		nvm_setup_rq(s, src_rq, &src, rev->addr, NVM_RQ_GC);
+		blk_execute_rq(q, dev->disk, src_rq, 0);
+		blk_put_request(src_rq);
+
+		dst_rq = blk_mq_alloc_request(q, WRITE, GFP_KERNEL, false);
+		blk_init_request_from_bio(dst_rq, src_bio);
+
+		/* ok, now fix the write and make sure that it haven't been
+		 * moved in the meantime. */
+		spin_lock(&s->rev_lock);
+
+		/* already updated by previous regular write */
+		if (rev->addr == LTOP_POISON) {
+			spin_unlock(&s->rev_lock);
+			goto overwritten;
+		}
+
+		src_bio->bi_iter.bi_sector = rev->addr * NR_PHY_IN_LOG;
+
+		/* again, unlocked by nvm_endio */
+		__nvm_lock_laddr_range(s, 1, rev->addr, 1);
+
+		spin_unlock(&s->rev_lock);
+
+		__nvm_write_rq(s, dst_rq, 1);
+		blk_execute_rq(q, dev->disk, dst_rq, 0);
+
+overwritten:
+		blk_put_request(dst_rq);
+		bio_put(src_bio);
+		mempool_free(page, s->page_pool);
+	}
+
+	WARN_ON(!bitmap_full(block->invalid_pages, s->nr_pages_per_blk));
+}
+
+static inline struct greedy_pool *greedy_pool(struct nvm_pool *pool)
+{
+	return (struct greedy_pool *)pool->gc_private;
+}
+
+static inline struct greedy_block *greedy_block(struct nvm_block *block)
+{
+	return (struct greedy_block *)block->gc_private;
+}
+
+static void nvm_greedy_queue_pool_gc(struct nvm_pool *pool)
+{
+	struct greedy_pool *gpool = greedy_pool(pool);
+	struct nvm_stor *s = pool->s;
+
+	queue_work(s->krqd_wq, &gpool->ws_gc);
+}
+
+static void nvm_greedy_kick(struct nvm_stor *s)
+{
+	struct nvm_pool *pool;
+	unsigned int i;
+
+	BUG_ON(!s);
+
+	nvm_for_each_pool(s, pool, i)
+		nvm_greedy_queue_pool_gc(pool);
+}
+
+void nvm_greedy_block_gc(struct work_struct *work)
+{
+	struct greedy_block *block_data = container_of(work, struct greedy_block, ws_gc);
+	struct nvm_block *block = block_data->block;
+	struct nvm_stor *s = block->pool->s;
+
+	pr_debug("nvm: block '%d' being reclaimed now\n", block->id);
+	nvm_move_valid_pages(s, block);
+	nvm_erase_block(s, block);
+	s->type->pool_put_blk(block);
+}
+
+/* the block with highest number of invalid pages, will be in the beginning
+ * of the list */
+static struct greedy_block *gblock_max_invalid(struct greedy_block *ga,
+					       struct greedy_block *gb)
+{
+	struct nvm_block *a = ga->block;
+	struct nvm_block *b = gb->block;
+
+	BUG_ON(!a || !b);
+
+	if (a->nr_invalid_pages == b->nr_invalid_pages)
+		return ga;
+
+	return (a->nr_invalid_pages < b->nr_invalid_pages) ? gb : ga;
+}
+
+/* linearly find the block with highest number of invalid pages
+ * requires pool->lock */
+static struct greedy_block *block_prio_find_max(struct greedy_pool *gpool)
+{
+	struct list_head *prio_list = &gpool->prio_list;
+	struct greedy_block *gblock, *max;
+
+	BUG_ON(list_empty(prio_list));
+
+	max = list_first_entry(prio_list, struct greedy_block, prio);
+	list_for_each_entry(gblock, prio_list, prio)
+		max = gblock_max_invalid(max, gblock);
+
+	return max;
+}
+
+static void nvm_greedy_pool_gc(struct work_struct *work)
+{
+	struct greedy_pool *gpool = container_of(work, struct greedy_pool, ws_gc);
+	struct nvm_pool *pool = gpool->pool;
+	struct nvm_stor *s = pool->s;
+	unsigned int nr_blocks_need;
+	unsigned long flags;
+
+	nr_blocks_need = pool->nr_blocks / GC_LIMIT_INVERSE;
+
+	if (nr_blocks_need < s->nr_aps)
+		nr_blocks_need = s->nr_aps;
+
+	local_irq_save(flags);
+	spin_lock(&pool->lock);
+	while (nr_blocks_need > pool->nr_free_blocks &&
+					!list_empty(&gpool->prio_list)) {
+		struct greedy_block *gblock = block_prio_find_max(gpool);
+		struct nvm_block *block = gblock->block;
+
+		if (!block->nr_invalid_pages) {
+			pr_err("No invalid pages");
+			break;
+		}
+
+		list_del_init(&gblock->prio);
+
+		BUG_ON(!block_is_full(block));
+		BUG_ON(atomic_inc_return(&block->gc_running) != 1);
+
+		pr_debug("selected block '%d' as GC victim\n", block->id);
+		queue_work(s->kgc_wq, &gblock->ws_gc);
+
+		nr_blocks_need--;
+	}
+	spin_unlock(&pool->lock);
+	local_irq_restore(flags);
+
+	/* TODO: Hint that request queue can be started again */
+}
+
+static void nvm_greedy_queue_gc(struct work_struct *work)
+{
+	struct greedy_block *gblock = container_of(work, struct greedy_block, ws_queue_gc);
+	struct nvm_pool *pool = gblock->block->pool;
+	struct greedy_pool *gpool = pool->gc_private;
+
+	spin_lock(&pool->lock);
+	list_add_tail(&gblock->prio, &gpool->prio_list);
+	spin_unlock(&pool->lock);
+	pr_debug("nvm: block '%d' is full, allow GC (DONE)\n", gblock->block->id);
+}
+
+static void nvm_greedy_queue(struct nvm_block *block)
+{
+	struct greedy_block *gblock = greedy_block(block);
+	struct nvm_pool *pool = block->pool;
+	struct nvm_stor *s = pool->s;
+
+	pr_debug("nvm: block '%d' is full, allow GC (sched)\n", block->id);
+
+	queue_work(s->kgc_wq, &gblock->ws_queue_gc);
+}
+
+static void nvm_greedy_free(struct nvm_stor *s)
+{
+	struct nvm_pool *pool;
+	int i;
+
+	nvm_for_each_pool(s, pool, i) {
+		struct greedy_pool *gpool = greedy_pool(pool);
+		if (!gpool || !gpool->block_mem)
+			break;
+		vfree(gpool->block_mem);
+	}
+
+	/* All per-pool GC-data space was allocated in one go, so this suffices */
+	if (s->nr_pools && s->pools && s->pools[0].gc_private)
+		kfree(s->pools[0].gc_private);
+}
+
+static int nvm_greedy_init(struct nvm_stor *s)
+{
+	struct greedy_pool *pool_mem;
+	struct nvm_pool *pool;
+	int i, j;
+
+	pool_mem = kcalloc(s->nr_pools, sizeof(struct greedy_pool),
+						GFP_KERNEL);
+	if (!pool_mem) {
+		pr_err("nvm: failed allocating pools for greedy GC\n");
+		return -ENOMEM;
+	}
+
+	nvm_for_each_pool(s, pool, i) {
+		struct greedy_pool *gpool = &pool_mem[i];
+		struct nvm_block *block;
+
+		pool->gc_private = gpool;
+		gpool->pool = pool;
+
+		INIT_LIST_HEAD(&gpool->prio_list);
+		INIT_WORK(&gpool->ws_gc, nvm_greedy_pool_gc);
+
+		gpool->block_mem = vzalloc(sizeof(struct greedy_block) * s->nr_blks_per_pool);
+		if (!gpool->block_mem) {
+			pr_err("nvm: failed allocating blocks for greedy "
+				"GC (in pool %d of %d)!\n", i, s->nr_pools);
+			nvm_greedy_free(s);
+			return -ENOMEM;
+		}
+
+		pool_for_each_block(pool, block, j) {
+			struct greedy_block *gblock = &gpool->block_mem[j];
+
+			block->gc_private = gblock;
+			gblock->block = block;
+
+			INIT_LIST_HEAD(&gblock->prio);
+			INIT_WORK(&gblock->ws_gc, nvm_greedy_block_gc);
+			INIT_WORK(&gblock->ws_queue_gc, nvm_greedy_queue_gc);
+		}
+	}
+
+	return 0;
+}
+
+static void nvm_greedy_exit(struct nvm_stor *s)
+{
+	nvm_greedy_free(s);
+}
+
+struct nvm_gc_type nvm_gc_greedy = {
+	.name		= "greedy",
+	.version	= {1, 0, 0},
+
+	.gc_timer	= nvm_gc_timer,
+	.queue		= nvm_greedy_queue,
+	.kick		= nvm_greedy_kick,
+
+	.init		= nvm_greedy_init,
+	.exit		= nvm_greedy_exit,
+};
diff --git a/drivers/lightnvm/nvm.c b/drivers/lightnvm/nvm.c
new file mode 100644
index 0000000..99db99b
--- /dev/null
+++ b/drivers/lightnvm/nvm.c
@@ -0,0 +1,460 @@
+/*
+ * Copyright (C) 2014 Matias Bjørling.
+ *
+ * Todo
+ *
+ * - Implement fetching of bad pages from flash
+ * - configurable sector size
+ * - handle case of in-page bv_offset (currently hidden assumption of offset=0,
+ *   and bv_len spans entire page)
+ *
+ * Optimization possibilities
+ * - Implement per-cpu nvm_block data structure ownership. Removes need
+ *   for taking lock on block next_write_id function. I.e. page allocation
+ *   becomes nearly lockless, with occasionally movement of blocks on
+ *   nvm_block lists.
+ */
+
+#include <linux/blk-mq.h>
+#include <linux/list.h>
+#include <linux/sem.h>
+#include <linux/types.h>
+#include <linux/lightnvm.h>
+
+#include <linux/ktime.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/nvm.h>
+
+#include "nvm.h"
+
+
+/* Defaults
+ * Number of append points per pool. We assume that accesses within a pool is
+ * serial (NAND flash/PCM/etc.)
+ */
+#define APS_PER_POOL 1
+
+/* Run GC every X seconds */
+#define GC_TIME 10
+
+/* Minimum pages needed within a pool */
+#define MIN_POOL_PAGES 16
+
+extern struct nvm_target_type nvm_target_rrpc;
+extern struct nvm_gc_type nvm_gc_greedy;
+
+static struct kmem_cache *_addr_cache;
+
+static LIST_HEAD(_targets);
+static DECLARE_RWSEM(_lock);
+
+struct nvm_target_type *find_nvm_target_type(const char *name)
+{
+	struct nvm_target_type *tt;
+
+	list_for_each_entry(tt, &_targets, list)
+		if (!strcmp(name, tt->name))
+			return tt;
+
+	return NULL;
+}
+
+int nvm_register_target(struct nvm_target_type *tt)
+{
+	int ret = 0;
+
+	down_write(&_lock);
+	if (find_nvm_target_type(tt->name))
+		ret = -EEXIST;
+	else
+		list_add(&tt->list, &_targets);
+	up_write(&_lock);
+	return ret;
+}
+
+void nvm_unregister_target(struct nvm_target_type *tt)
+{
+	if (!tt)
+		return;
+
+	down_write(&_lock);
+	list_del(&tt->list);
+	up_write(&_lock);
+}
+
+int nvm_map_rq(struct nvm_dev *dev, struct request *rq)
+{
+	struct nvm_stor *s = dev->stor;
+	int ret;
+
+	trace_nvm_rq_map_begin(rq);
+
+	if (rq_data_dir(rq) == WRITE)
+		ret = s->type->write_rq(s, rq);
+	else
+		ret = s->type->read_rq(s, rq);
+
+	if (!ret)
+		rq->cmd_flags |= (REQ_NVM|REQ_NVM_MAPPED);
+
+	trace_nvm_rq_map_end(rq);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvm_map_rq);
+
+void nvm_complete_request(struct nvm_dev *nvm_dev, struct request *rq, int error)
+{
+	if (rq->cmd_flags & (REQ_NVM|REQ_NVM_MAPPED))
+		nvm_endio(nvm_dev, rq, error);
+
+	if (!(rq->cmd_flags & REQ_NVM))
+		pr_info("lightnvm: request outside lightnvm detected.\n");
+}
+EXPORT_SYMBOL_GPL(nvm_complete_request);
+
+unsigned int nvm_cmd_size(void)
+{
+	return sizeof(struct per_rq_data);
+}
+EXPORT_SYMBOL_GPL(nvm_cmd_size);
+
+static void nvm_pools_free(struct nvm_stor *s)
+{
+	struct nvm_pool *pool;
+	int i;
+
+	if (s->krqd_wq)
+		destroy_workqueue(s->krqd_wq);
+
+	if (s->kgc_wq)
+		destroy_workqueue(s->kgc_wq);
+
+	nvm_for_each_pool(s, pool, i) {
+		if (!pool->blocks)
+			break;
+		vfree(pool->blocks);
+	}
+	kfree(s->pools);
+	kfree(s->aps);
+}
+
+static int nvm_pools_init(struct nvm_stor *s)
+{
+	struct nvm_pool *pool;
+	struct nvm_block *block;
+	struct nvm_ap *ap;
+	struct nvm_id_chnl *chnl;
+	int i, j, cur_block_id = 0;
+
+	spin_lock_init(&s->rev_lock);
+
+	s->pools = kcalloc(s->nr_pools, sizeof(struct nvm_pool), GFP_KERNEL);
+	if (!s->pools)
+		goto err_pool;
+
+	nvm_for_each_pool(s, pool, i) {
+		chnl = &s->id.chnls[i];
+		pr_info("lightnvm: p %u qsize %llu gr %llu ge %llu begin %llu end %llu\n",
+			i, chnl->queue_size, chnl->gran_read, chnl->gran_erase,
+			chnl->laddr_begin, chnl->laddr_end);
+
+		spin_lock_init(&pool->lock);
+
+		INIT_LIST_HEAD(&pool->free_list);
+		INIT_LIST_HEAD(&pool->used_list);
+
+		pool->id = i;
+		pool->s = s;
+		pool->chnl = chnl;
+		pool->nr_free_blocks = pool->nr_blocks =
+				(chnl->laddr_end - chnl->laddr_begin + 1) /
+				(chnl->gran_erase / chnl->gran_read);
+
+		pool->blocks = vzalloc(sizeof(struct nvm_block) *
+							pool->nr_blocks);
+		if (!pool->blocks)
+			goto err_blocks;
+
+		pool_for_each_block(pool, block, j) {
+			spin_lock_init(&block->lock);
+			atomic_set(&block->gc_running, 0);
+			INIT_LIST_HEAD(&block->list);
+
+			block->pool = pool;
+			block->id = cur_block_id++;
+
+			list_add_tail(&block->list, &pool->free_list);
+		}
+
+		s->total_blocks += pool->nr_blocks;
+		/* TODO: make blks per pool variable amond channels */
+		s->nr_blks_per_pool = pool->nr_free_blocks;
+		/* TODO: gran_{read,write} may differ */
+		s->nr_pages_per_blk = chnl->gran_erase / chnl->gran_read *
+					(chnl->gran_read / s->sector_size);
+	}
+
+	s->nr_aps = s->nr_aps_per_pool * s->nr_pools;
+	s->aps = kcalloc(s->nr_aps, sizeof(struct nvm_ap), GFP_KERNEL);
+	if (!s->aps)
+		goto err_blocks;
+
+	nvm_for_each_ap(s, ap, i) {
+		spin_lock_init(&ap->lock);
+		ap->parent = s;
+		ap->pool = &s->pools[i / s->nr_aps_per_pool];
+
+		block = s->type->pool_get_blk(ap->pool, 0);
+		nvm_set_ap_cur(ap, block);
+
+		/* Emergency gc block */
+		block = s->type->pool_get_blk(ap->pool, 1);
+		ap->gc_cur = block;
+	}
+
+	/* we make room for each pool context. */
+	s->krqd_wq = alloc_workqueue("knvm-work", WQ_MEM_RECLAIM|WQ_UNBOUND,
+						s->nr_pools);
+	if (!s->krqd_wq) {
+		pr_err("Couldn't alloc knvm-work");
+		goto err_blocks;
+	}
+
+	s->kgc_wq = alloc_workqueue("knvm-gc", WQ_MEM_RECLAIM, 1);
+	if (!s->kgc_wq) {
+		pr_err("Couldn't alloc knvm-gc");
+		goto err_blocks;
+	}
+
+	return 0;
+err_blocks:
+	nvm_pools_free(s);
+err_pool:
+	pr_err("lightnvm: cannot allocate lightnvm data structures");
+	return -ENOMEM;
+}
+
+static int nvm_stor_init(struct nvm_dev *dev, struct nvm_stor *s)
+{
+	int i;
+
+	s->trans_map = vzalloc(sizeof(struct nvm_addr) * s->nr_pages);
+	if (!s->trans_map)
+		return -ENOMEM;
+
+	s->rev_trans_map = vmalloc(sizeof(struct nvm_rev_addr)
+							* s->nr_pages);
+	if (!s->rev_trans_map)
+		goto err_rev_trans_map;
+
+	for (i = 0; i < s->nr_pages; i++) {
+		struct nvm_addr *p = &s->trans_map[i];
+		struct nvm_rev_addr *r = &s->rev_trans_map[i];
+
+		p->addr = LTOP_EMPTY;
+		r->addr = 0xDEADBEEF;
+	}
+
+	s->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
+	if (!s->page_pool)
+		goto err_dev_lookup;
+
+	s->addr_pool = mempool_create_slab_pool(64, _addr_cache);
+	if (!s->addr_pool)
+		goto err_page_pool;
+
+	/* inflight maintenance */
+	percpu_ida_init(&s->free_inflight, NVM_INFLIGHT_TAGS);
+
+	for (i = 0; i < NVM_INFLIGHT_PARTITIONS; i++) {
+		spin_lock_init(&s->inflight_map[i].lock);
+		INIT_LIST_HEAD(&s->inflight_map[i].reqs);
+	}
+
+	/* simple round-robin strategy */
+	atomic_set(&s->next_write_ap, -1);
+
+	s->dev = (void *)dev;
+	dev->stor = s;
+
+	/* Initialize pools. */
+
+	if (s->type->init && s->type->init(s))
+		goto err_addr_pool_tgt;
+
+	if (s->gc_ops->init && s->gc_ops->init(s))
+		goto err_addr_pool_gc;
+
+	/* FIXME: Clean up pool init on failure. */
+	setup_timer(&s->gc_timer, s->gc_ops->gc_timer, (unsigned long)s);
+	mod_timer(&s->gc_timer, jiffies + msecs_to_jiffies(1000));
+
+	return 0;
+err_addr_pool_gc:
+	s->type->exit(s);
+err_addr_pool_tgt:
+	nvm_pools_free(s);
+	mempool_destroy(s->addr_pool);
+err_page_pool:
+	mempool_destroy(s->page_pool);
+err_dev_lookup:
+	vfree(s->rev_trans_map);
+err_rev_trans_map:
+	vfree(s->trans_map);
+	return -ENOMEM;
+}
+
+#define NVM_TARGET_TYPE "rrpc"
+#define NVM_GC_TYPE "greedy"
+#define NVM_NUM_POOLS 8
+#define NVM_NUM_BLOCKS 256
+#define NVM_NUM_PAGES 256
+
+void nvm_free_nvm_id(struct nvm_id *id)
+{
+	kfree(id->chnls);
+}
+
+int nvm_init(struct nvm_dev *nvm)
+{
+	struct nvm_stor *s;
+	int ret = 0;
+
+	if (!nvm->q || !nvm->ops)
+		return -EINVAL;
+
+	down_write(&_lock);
+	if (!_addr_cache) {
+		_addr_cache = kmem_cache_create("nvm_addr_cache",
+				sizeof(struct nvm_addr), 0, 0, NULL);
+		if (!_addr_cache) {
+			ret = -ENOMEM;
+			up_write(&_lock);
+			goto err;
+		}
+	}
+	up_write(&_lock);
+
+	nvm_register_target(&nvm_target_rrpc);
+
+	s = kzalloc(sizeof(struct nvm_stor), GFP_KERNEL);
+	if (!s) {
+		ret = -ENOMEM;
+		goto err_stor;
+	}
+
+	/* hardcode initialization values until user-space util is avail. */
+	s->type = &nvm_target_rrpc;
+	if (!s->type) {
+		pr_err("nvm: %s doesn't exist.", NVM_TARGET_TYPE);
+		ret = -EINVAL;
+		goto err_cfg;
+	}
+
+	s->gc_ops = &nvm_gc_greedy;
+	if (!s->gc_ops) {
+		pr_err("nvm: %s doesn't exist.", NVM_GC_TYPE);
+		ret = -EINVAL;
+		goto err_cfg;
+	}
+
+	/* TODO: We're limited to the same setup for each channel */
+	if (nvm->ops->identify(nvm->q, &s->id)) {
+		ret = -EINVAL;
+		goto err_cfg;
+	}
+
+	pr_debug("lightnvm dev: ver %u type %u chnls %u\n",
+			s->id.ver_id, s->id.nvm_type, s->id.nchannels);
+
+	s->nr_pools = s->id.nchannels;
+	s->nr_aps_per_pool = APS_PER_POOL;
+	s->config.gc_time = GC_TIME;
+	s->sector_size = EXPOSED_PAGE_SIZE;
+
+	ret = nvm_pools_init(s);
+	if (ret) {
+		pr_err("lightnvm: cannot initialized pools structure.");
+		goto err_init;
+	}
+
+	s->nr_pages = s->nr_pools * s->nr_blks_per_pool * s->nr_pages_per_blk;
+
+	if (s->nr_pages_per_blk > MAX_INVALID_PAGES_STORAGE * BITS_PER_LONG) {
+		pr_err("lightnvm: Num. pages per block too high. Increase MAX_INVALID_PAGES_STORAGE.");
+		ret = -EINVAL;
+		goto err_init;
+	}
+
+	ret = nvm_stor_init(nvm, s);
+	if (ret) {
+		pr_err("lightnvm: cannot initialize nvm structure.");
+		goto err_init;
+	}
+
+	pr_info("lightnvm: allocated %lu physical pages (%lu KB)\n",
+			s->nr_pages, s->nr_pages * s->sector_size / 1024);
+	pr_info("lightnvm: pools: %u\n", s->nr_pools);
+	pr_info("lightnvm: blocks: %u\n", s->nr_blks_per_pool);
+	pr_info("lightnvm: pages per block: %u\n", s->nr_pages_per_blk);
+	pr_info("lightnvm: append points: %u\n", s->nr_aps);
+	pr_info("lightnvm: append points per pool: %u\n", s->nr_aps_per_pool);
+	pr_info("lightnvm: target sector size=%d\n", s->sector_size);
+
+	nvm->stor = s;
+	return 0;
+
+err_init:
+	nvm_free_nvm_id(&s->id);
+err_cfg:
+	kfree(s);
+err_stor:
+	kmem_cache_destroy(_addr_cache);
+err:
+	pr_err("lightnvm: failed to initialize nvm\n");
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvm_init);
+
+void nvm_exit(struct nvm_dev *nvm)
+{
+	struct nvm_stor *s;
+
+	s = nvm->stor;
+	if (!s)
+		return;
+
+	if (s->gc_ops->exit)
+		s->gc_ops->exit(s);
+
+	if (s->type->exit)
+		s->type->exit(s);
+
+	del_timer(&s->gc_timer);
+
+	/* TODO: remember outstanding block refs, waiting to be erased... */
+	nvm_pools_free(s);
+
+	vfree(s->trans_map);
+	vfree(s->rev_trans_map);
+
+	mempool_destroy(s->page_pool);
+	mempool_destroy(s->addr_pool);
+
+	percpu_ida_destroy(&s->free_inflight);
+
+	nvm_free_nvm_id(&s->id);
+
+	kfree(s);
+
+	kmem_cache_destroy(_addr_cache);
+
+	pr_info("lightnvm: successfully unloaded\n");
+}
+EXPORT_SYMBOL_GPL(nvm_exit);
+
+MODULE_DESCRIPTION("LightNVM");
+MODULE_AUTHOR("Matias Bjorling <mabj@itu.dk>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/lightnvm/nvm.h b/drivers/lightnvm/nvm.h
new file mode 100644
index 0000000..ffa86cd
--- /dev/null
+++ b/drivers/lightnvm/nvm.h
@@ -0,0 +1,588 @@
+/*
+ * Copyright (C) 2014 Matias Bj�rling.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef NVM_H_
+#define NVM_H_
+
+#include <linux/blkdev.h>
+#include <linux/list.h>
+#include <linux/list_sort.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/atomic.h>
+#include <linux/delay.h>
+#include <linux/time.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <linux/mempool.h>
+#include <linux/kref.h>
+#include <linux/completion.h>
+#include <linux/hashtable.h>
+#include <linux/percpu_ida.h>
+#include <linux/lightnvm.h>
+#include <linux/blk-mq.h>
+#include <linux/slab.h>
+
+#ifdef NVM_DEBUG
+#define NVM_ASSERT(c) BUG_ON((c) == 0)
+#else
+#define NVM_ASSERT(c)
+#endif
+
+#define NVM_MSG_PREFIX "nvm"
+#define LTOP_EMPTY -1
+#define LTOP_POISON 0xD3ADB33F
+
+/*
+ * For now we hardcode some of the configuration for the LightNVM device that we
+ * have. In the future this should be made configurable.
+ *
+ * Configuration:
+ * EXPOSED_PAGE_SIZE - the page size of which we tell the layers above the
+ * driver to issue. This usually is 512 bytes for 4K for simplivity.
+ */
+
+/* We currently assume that we the lightnvm device is accepting data in 512
+ * bytes chunks. This should be set to the smallest command size available for a
+ * given device.
+ */
+#define NVM_SECTOR 512
+#define EXPOSED_PAGE_SIZE 4096
+
+#define NR_PHY_IN_LOG (EXPOSED_PAGE_SIZE / NVM_SECTOR)
+
+/* We partition the namespace of translation map into these pieces for tracking
+ * in-flight addresses. */
+#define NVM_INFLIGHT_PARTITIONS 8
+#define NVM_INFLIGHT_TAGS 256
+
+/* Pool descriptions */
+struct nvm_block {
+	struct {
+		spinlock_t lock;
+		/* points to the next writable page within a block */
+		unsigned int next_page;
+		/* number of pages that are invalid, wrt host page size */
+		unsigned int nr_invalid_pages;
+#define MAX_INVALID_PAGES_STORAGE 8
+		/* Bitmap for invalid page intries */
+		unsigned long invalid_pages[MAX_INVALID_PAGES_STORAGE];
+	} ____cacheline_aligned_in_smp;
+
+	unsigned int id;
+	struct nvm_pool *pool;
+	struct nvm_ap *ap;
+
+	/* Management structures */
+	struct list_head list;
+
+	/* Persistent data structures */
+	atomic_t data_cmnt_size; /* data pages committed to stable storage */
+
+	/* Block state handling */
+	atomic_t gc_running;
+
+	/* For target and GC algorithms  */
+	void *tgt_private;
+	void *gc_private;
+};
+
+/* Logical to physical mapping */
+struct nvm_addr {
+	sector_t addr;
+	struct nvm_block *block;
+};
+
+/* Physical to logical mapping */
+struct nvm_rev_addr {
+	sector_t addr;
+};
+
+struct nvm_pool {
+	/* Pool block lists */
+	struct {
+		spinlock_t lock;
+	} ____cacheline_aligned_in_smp;
+
+	struct list_head used_list;	/* In-use blocks */
+	struct list_head free_list;	/* Not used blocks i.e. released
+					 *  and ready for use */
+
+	unsigned int id;
+
+	struct nvm_id_chnl *chnl;
+
+	unsigned int nr_blocks;		/* end_block - start_block. */
+	unsigned int nr_free_blocks;	/* Number of unused blocks */
+
+	struct nvm_block *blocks;
+	struct nvm_stor *s;
+
+	void *tgt_private;	/*target-specific per-pool data*/
+	void *gc_private;	/*GC-specific per-pool data*/
+};
+
+/*
+ * nvm_ap. ap is an append point. A pool can have 1..X append points attached.
+ * An append point has a current block, that it writes to, and when its full,
+ * it requests a new block, of which it continues its writes.
+ *
+ * one ap per pool may be reserved for pack-hints related writes.
+ * In those that are not not, private is NULL.
+ */
+struct nvm_ap {
+	spinlock_t lock;
+	struct nvm_stor *parent;
+	struct nvm_pool *pool;
+	struct nvm_block *cur;
+	struct nvm_block *gc_cur;
+
+	unsigned long io_delayed;
+
+	/* Private field for submodules */
+	void *private;
+};
+
+struct nvm_config {
+	unsigned long flags;
+
+	unsigned int gc_time; /* GC every X microseconds */
+};
+
+struct nvm_inflight_request {
+	struct list_head list;
+	sector_t l_start;
+	sector_t l_end;
+	int tag;
+};
+
+struct nvm_inflight {
+	spinlock_t lock;
+	struct list_head reqs;
+};
+
+struct nvm_stor;
+struct per_rq_data;
+struct nvm_block;
+struct nvm_pool;
+
+/* overridable functionality */
+typedef struct nvm_addr *(nvm_lookup_ltop_fn)(struct nvm_stor *, sector_t);
+typedef struct nvm_addr *(nvm_map_ltop_page_fn)(struct nvm_stor *, sector_t,
+						int);
+typedef struct nvm_block *(nvm_map_ltop_block_fn)(struct nvm_stor *, sector_t,
+						int);
+typedef int (nvm_write_rq_fn)(struct nvm_stor *, struct request *);
+typedef int (nvm_read_rq_fn)(struct nvm_stor *, struct request *);
+typedef void (nvm_alloc_phys_addr_fn)(struct nvm_stor *, struct nvm_block *);
+typedef struct nvm_block *(nvm_pool_get_blk_fn)(struct nvm_pool *pool,
+						int is_gc);
+typedef void (nvm_pool_put_blk_fn)(struct nvm_block *block);
+typedef int (nvm_ioctl_fn)(struct nvm_stor *,
+					unsigned int cmd, unsigned long arg);
+typedef int (nvm_tgt_init_fn)(struct nvm_stor *);
+typedef void (nvm_tgt_exit_fn)(struct nvm_stor *);
+typedef void (nvm_endio_fn)(struct nvm_stor *, struct request *,
+				struct per_rq_data *, unsigned long *delay);
+
+typedef void (nvm_gc_timer_fn)(unsigned long s_addr);
+typedef void (nvm_deferred_fn)(struct work_struct *work);
+typedef void (nvm_gc_queue_fn)(struct nvm_block *block);
+typedef void (nvm_gc_kick_fn)(struct nvm_stor *s);
+typedef int (nvm_gc_init_fn)(struct nvm_stor *s);
+typedef void (nvm_gc_exit_fn)(struct nvm_stor *s);
+
+struct nvm_target_type {
+	const char *name;
+	unsigned int version[3];
+
+	/* lookup functions */
+	nvm_lookup_ltop_fn *lookup_ltop;
+
+	/* handling of request */
+	nvm_write_rq_fn *write_rq;
+	nvm_read_rq_fn *read_rq;
+	nvm_ioctl_fn *ioctl;
+	nvm_endio_fn *end_rq;
+
+	/* engine-specific overrides */
+	nvm_pool_get_blk_fn *pool_get_blk;
+	nvm_pool_put_blk_fn *pool_put_blk;
+	nvm_map_ltop_page_fn *map_page;
+	nvm_map_ltop_block_fn *map_block;
+
+	/* module-specific init/teardown */
+	nvm_tgt_init_fn *init;
+	nvm_tgt_exit_fn *exit;
+
+	/* For lightnvm internal use */
+	struct list_head list;
+};
+
+struct nvm_gc_type {
+	const char *name;
+	unsigned int version[3];
+
+	/*GC interface*/
+	nvm_gc_timer_fn *gc_timer;
+	nvm_gc_queue_fn *queue;
+	nvm_gc_kick_fn *kick;
+
+	/* module-specific init/teardown */
+	nvm_gc_init_fn *init;
+	nvm_gc_exit_fn *exit;
+};
+
+/* Main structure */
+struct nvm_stor {
+	struct nvm_dev *dev;
+	uint32_t sector_size;
+
+	struct nvm_target_type *type;
+	struct nvm_gc_type *gc_ops;
+
+	/* Simple translation map of logical addresses to physical addresses.
+	 * The logical addresses is known by the host system, while the physical
+	 * addresses are used when writing to the disk block device. */
+	struct nvm_addr *trans_map;
+	/* also store a reverse map for garbage collection */
+	struct nvm_rev_addr *rev_trans_map;
+	spinlock_t rev_lock;
+	/* Usually instantiated to the number of available parallel channels
+	 * within the hardware device. i.e. a controller with 4 flash channels,
+	 * would have 4 pools.
+	 *
+	 * We assume that the device exposes its channels as a linear address
+	 * space. A pool therefore have a phy_addr_start and phy_addr_end that
+	 * denotes the start and end. This abstraction is used to let the
+	 * lightnvm (or any other device) expose its read/write/erase interface
+	 * and be administrated by the host system.
+	 */
+	struct nvm_pool *pools;
+
+	/* Append points */
+	struct nvm_ap *aps;
+
+	mempool_t *addr_pool;
+	mempool_t *page_pool;
+
+	/* Frequently used config variables */
+	int nr_pools;
+	int nr_blks_per_pool;
+	int nr_pages_per_blk;
+	int nr_aps;
+	int nr_aps_per_pool;
+
+	struct nvm_id id;
+	/* Calculated/Cached values. These do not reflect the actual usuable
+	 * blocks at run-time. */
+	unsigned long nr_pages;
+	unsigned long total_blocks;
+
+	/* Write strategy variables. Move these into each for structure for each
+	 * strategy */
+	atomic_t next_write_ap; /* Whenever a page is written, this is updated
+				 * to point to the next write append point */
+	struct workqueue_struct *krqd_wq;
+	struct workqueue_struct *kgc_wq;
+
+	struct timer_list gc_timer;
+
+	/* in-flight data lookup, lookup by logical address. Remember the
+	 * overhead of cachelines being used. Keep it low for better cache
+	 * utilization. */
+	struct percpu_ida free_inflight;
+	struct nvm_inflight inflight_map[NVM_INFLIGHT_PARTITIONS];
+	struct nvm_inflight_request inflight_addrs[NVM_INFLIGHT_TAGS];
+
+	/* nvm module specific data */
+	void *private;
+
+	/* User configuration */
+	struct nvm_config config;
+
+	unsigned int per_rq_offset;
+};
+
+struct per_rq_data_nvm {
+	struct nvm_dev *dev;
+};
+
+enum {
+	NVM_RQ_NONE = 0,
+	NVM_RQ_GC = 1,
+};
+
+struct per_rq_data {
+	struct nvm_ap *ap;
+	struct nvm_addr *addr;
+	sector_t l_addr;
+	unsigned int flags;
+};
+
+/* reg.c */
+int nvm_register_target(struct nvm_target_type *t);
+void nvm_unregister_target(struct nvm_target_type *t);
+struct nvm_target_type *find_nvm_target_type(const char *name);
+
+/* core.c */
+/*   Helpers */
+void nvm_set_ap_cur(struct nvm_ap *, struct nvm_block *);
+sector_t nvm_alloc_phys_addr(struct nvm_block *);
+
+/*   Naive implementations */
+void nvm_delayed_bio_submit(struct work_struct *);
+void nvm_deferred_bio_submit(struct work_struct *);
+
+/* Allocation of physical addresses from block
+ * when increasing responsibility. */
+struct nvm_addr *nvm_alloc_addr_from_ap(struct nvm_ap *, int is_gc);
+
+/*   I/O request related */
+int nvm_write_rq(struct nvm_stor *, struct request *);
+int __nvm_write_rq(struct nvm_stor *, struct request *, int);
+int nvm_read_rq(struct nvm_stor *, struct request *rq);
+int nvm_erase_block(struct nvm_stor *, struct nvm_block *);
+void nvm_update_map(struct nvm_stor *, sector_t, struct nvm_addr *, int);
+void nvm_setup_rq(struct nvm_stor *, struct request *, struct nvm_addr *, sector_t, unsigned int flags);
+
+/*   Block maintanence */
+void nvm_reset_block(struct nvm_block *);
+
+void nvm_endio(struct nvm_dev *, struct request *, int);
+
+/* targets.c */
+struct nvm_block *nvm_pool_get_block(struct nvm_pool *, int is_gc);
+
+/* nvmkv.c */
+int nvmkv_init(struct nvm_stor *s, unsigned long size);
+void nvmkv_exit(struct nvm_stor *s);
+void nvm_pool_put_block(struct nvm_block *);
+
+#define nvm_for_each_pool(n, pool, i) \
+		for ((i) = 0, pool = &(n)->pools[0]; \
+			(i) < (n)->nr_pools; (i)++, pool = &(n)->pools[(i)])
+
+#define nvm_for_each_ap(n, ap, i) \
+		for ((i) = 0, ap = &(n)->aps[0]; \
+			(i) < (n)->nr_aps; (i)++, ap = &(n)->aps[(i)])
+
+#define pool_for_each_block(p, b, i) \
+		for ((i) = 0, b = &(p)->blocks[0]; \
+			(i) < (p)->nr_blocks; (i)++, b = &(p)->blocks[(i)])
+
+#define block_for_each_page(b, p) \
+		for ((p)->addr = block_to_addr((b)), (p)->block = (b); \
+			(p)->addr < block_to_addr((b)) \
+				+ (b)->pool->s->nr_pages_per_blk; \
+			(p)->addr++)
+
+static inline struct nvm_ap *get_next_ap(struct nvm_stor *s)
+{
+	return &s->aps[atomic_inc_return(&s->next_write_ap) % s->nr_aps];
+}
+
+static inline int block_is_full(struct nvm_block *block)
+{
+	struct nvm_stor *s = block->pool->s;
+
+	return block->next_page == s->nr_pages_per_blk;
+}
+
+static inline sector_t block_to_addr(struct nvm_block *block)
+{
+	struct nvm_stor *s = block->pool->s;
+
+	return block->id * s->nr_pages_per_blk;
+}
+
+static inline struct nvm_pool *paddr_to_pool(struct nvm_stor *s,
+							sector_t p_addr)
+{
+	return &s->pools[p_addr / (s->nr_pages / s->nr_pools)];
+}
+
+static inline struct nvm_ap *block_to_ap(struct nvm_stor *s,
+							struct nvm_block *b)
+{
+	unsigned int ap_idx, div, mod;
+
+	div = b->id / s->nr_blks_per_pool;
+	mod = b->id % s->nr_blks_per_pool;
+	ap_idx = div + (mod / (s->nr_blks_per_pool / s->nr_aps_per_pool));
+
+	return &s->aps[ap_idx];
+}
+
+static inline int physical_to_slot(struct nvm_stor *s, sector_t phys)
+{
+	return phys % s->nr_pages_per_blk;
+}
+
+static inline void *get_per_rq_data(struct nvm_dev *dev, struct request *rq)
+{
+	BUG_ON(!dev);
+	return blk_mq_rq_to_pdu(rq) + dev->drv_cmd_size;
+}
+
+static inline struct nvm_inflight *nvm_laddr_to_inflight(struct nvm_stor *s,
+							sector_t l_addr)
+{
+	return &s->inflight_map[(l_addr / s->nr_pages_per_blk)
+				% NVM_INFLIGHT_PARTITIONS];
+}
+
+static inline int request_equals(struct nvm_inflight_request *r,
+			sector_t laddr_start, sector_t laddr_end)
+{
+	return (r->l_end == laddr_end && r->l_start == laddr_start);
+}
+
+static inline int request_intersects(struct nvm_inflight_request *r,
+				sector_t laddr_start, sector_t laddr_end)
+{
+	return (laddr_end >= r->l_start && laddr_end <= r->l_end) &&
+		(laddr_start >= r->l_start && laddr_start <= r->l_end);
+}
+
+/*lock a range within a single inflight list (=> within a single block)*/
+static void __nvm_lock_rq_sgmt(struct nvm_stor *s, struct nvm_inflight *inflight,
+			int spin, sector_t laddr_start, unsigned nsectors)
+{
+	struct nvm_inflight_request *r;
+	sector_t laddr_end = laddr_start + nsectors - 1;
+	unsigned long flags;
+	int tag;
+
+	tag = percpu_ida_alloc(&s->free_inflight, __GFP_WAIT);
+retry:
+	spin_lock_irqsave(&inflight->lock, flags);
+
+	list_for_each_entry(r, &inflight->reqs, list) {
+		if (request_intersects(r, laddr_start, laddr_end)) {
+			/*existing, overlapping request, come back later*/
+			spin_unlock_irqrestore(&inflight->lock, flags);
+			if (!spin)
+				/*TODO: not allowed, but something is needed */
+				schedule();
+			goto retry;
+		}
+	}
+
+	r = &s->inflight_addrs[tag];
+
+	r->l_start = laddr_start;
+	r->l_end = laddr_end;
+	r->tag = tag;
+
+	list_add_tail(&r->list, &inflight->reqs);
+	spin_unlock_irqrestore(&inflight->lock, flags);
+	/*pr_debug("%s: \tlocked sgmt_range{start:%zu, end:%zu}\n", __func__, r->l_start, r->l_end);*/
+}
+
+static inline unsigned incr_iflight_ndx(unsigned curr_ndx)
+{
+	if (unlikely(++curr_ndx == NVM_INFLIGHT_PARTITIONS))
+		return 0;
+
+	return curr_ndx;
+}
+
+static void __nvm_lock_laddr_range(struct nvm_stor *s, int spin,
+					sector_t laddr, unsigned nsectors)
+{
+	struct nvm_inflight *inflight;
+	sector_t blk_laddr;
+	unsigned blk_id, map_ndx;
+
+	NVM_ASSERT(nsectors >= 1);
+	BUG_ON((laddr + nsectors) > s->nr_pages);
+
+	blk_id = laddr / s->nr_pages_per_blk;
+	blk_laddr = blk_id * s->nr_pages_per_blk;
+	map_ndx = blk_id % NVM_INFLIGHT_PARTITIONS;
+	inflight = &s->inflight_map[map_ndx];
+
+	while (nsectors) {
+		/*TODO: optimize? off can only be non-zero on first iteration*/
+		unsigned off = laddr - blk_laddr;
+		unsigned segment_len = min(s->nr_pages_per_blk - off, nsectors);
+
+		__nvm_lock_rq_sgmt(s, inflight, spin, laddr, segment_len);
+
+		laddr += segment_len;
+		blk_id++;
+		blk_laddr += s->nr_pages_per_blk;
+		nsectors -= segment_len;
+		map_ndx = incr_iflight_ndx(map_ndx);
+		inflight = &s->inflight_map[map_ndx];
+	}
+}
+
+static inline void nvm_lock_laddr_range(struct nvm_stor *s, sector_t laddr_start,
+					unsigned int nsectors)
+{
+	return __nvm_lock_laddr_range(s, 0, laddr_start, nsectors);
+}
+
+static void __nvm_unlock_rq_sgmt(struct nvm_stor *s, struct nvm_inflight *inflight,
+				sector_t laddr_start, unsigned int nsectors)
+{
+	sector_t laddr_end = laddr_start + nsectors - 1;
+	struct nvm_inflight_request *r = NULL;
+	unsigned long flags;
+
+
+	spin_lock_irqsave(&inflight->lock, flags);
+	BUG_ON(list_empty(&inflight->reqs));
+
+	list_for_each_entry(r, &inflight->reqs, list)
+		if (request_equals(r, laddr_start, laddr_end))
+			break;
+
+	/* On bug -> The submission size and complete size properly differs */
+	BUG_ON(!r || !request_equals(r, laddr_start, laddr_end));
+
+	r->l_start = r->l_end = LTOP_POISON;
+
+	list_del_init(&r->list);
+	spin_unlock_irqrestore(&inflight->lock, flags);
+	percpu_ida_free(&s->free_inflight, r->tag);
+}
+
+static inline void nvm_unlock_laddr_range(struct nvm_stor *s, sector_t laddr,
+					unsigned int nsectors)
+{
+	struct nvm_inflight *inflight;
+	sector_t blk_laddr;
+	unsigned blk_id, map_ndx;
+
+	NVM_ASSERT(nsectors >= 1);
+	BUG_ON((laddr + nsectors) > s->nr_pages);
+
+	blk_id = laddr / s->nr_pages_per_blk;
+	blk_laddr = blk_id * s->nr_pages_per_blk;
+	map_ndx = blk_id % NVM_INFLIGHT_PARTITIONS;
+	inflight = &s->inflight_map[map_ndx];
+
+	while (nsectors) {
+		/*TODO: optimize? off can only be non-zero on first iteration*/
+		unsigned off = laddr - blk_laddr;
+		unsigned sgmt_len = min(s->nr_pages_per_blk - off, nsectors);
+
+		__nvm_unlock_rq_sgmt(s, inflight, laddr, sgmt_len);
+
+		laddr += sgmt_len;
+		blk_id++;
+		blk_laddr += s->nr_pages_per_blk;
+		nsectors -= sgmt_len;
+		map_ndx = incr_iflight_ndx(map_ndx);
+		inflight = &s->inflight_map[map_ndx];
+	}
+}
+#endif /* NVM_H_ */
+
diff --git a/drivers/lightnvm/sysfs.c b/drivers/lightnvm/sysfs.c
new file mode 100644
index 0000000..d55e779
--- /dev/null
+++ b/drivers/lightnvm/sysfs.c
@@ -0,0 +1,68 @@
+#include <linux/lightnvm.h>
+#include <linux/sysfs.h>
+
+#include "nvm.h"
+
+static ssize_t nvm_attr_free_blocks_show(struct nvm_dev *nvm, char *buf)
+{
+	char *buf_start = buf;
+	struct nvm_stor *stor = nvm->stor;
+	struct nvm_pool *pool;
+	unsigned int i;
+
+	nvm_for_each_pool(stor, pool, i)
+		buf += sprintf(buf, "%8u\t%u\n", i, pool->nr_free_blocks);
+
+	return buf - buf_start;
+}
+
+static ssize_t nvm_attr_show(struct device *dev, char *page,
+			      ssize_t (*fn)(struct nvm_dev *, char *))
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct nvm_dev *nvm = disk->private_data;
+
+	return fn(nvm, page);
+}
+
+#define NVM_ATTR_RO(_name)						\
+static ssize_t nvm_attr_##_name##_show(struct nvm_dev *, char *);	\
+static ssize_t nvm_attr_do_show_##_name(struct device *d,		\
+				struct device_attribute *attr, char *b)	\
+{									\
+	return nvm_attr_show(d, b, nvm_attr_##_name##_show);		\
+}									\
+static struct device_attribute nvm_attr_##_name =			\
+	__ATTR(_name, S_IRUGO, nvm_attr_do_show_##_name, NULL)
+
+NVM_ATTR_RO(free_blocks);
+
+static struct attribute *nvm_attrs[] = {
+	&nvm_attr_free_blocks.attr,
+	NULL,
+};
+
+static struct attribute_group nvm_attribute_group = {
+	.name = "nvm",
+	.attrs = nvm_attrs,
+};
+
+void nvm_remove_sysfs(struct device *dev)
+{
+	sysfs_remove_group(&dev->kobj, &nvm_attribute_group);
+}
+EXPORT_SYMBOL_GPL(nvm_remove_sysfs);
+
+int nvm_add_sysfs(struct device *dev)
+{
+	int ret;
+
+	ret = sysfs_create_group(&dev->kobj, &nvm_attribute_group);
+	if (ret)
+		return ret;
+
+	kobject_uevent(&dev->kobj, KOBJ_CHANGE);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvm_add_sysfs);
diff --git a/drivers/lightnvm/targets.c b/drivers/lightnvm/targets.c
new file mode 100644
index 0000000..4384e93
--- /dev/null
+++ b/drivers/lightnvm/targets.c
@@ -0,0 +1,244 @@
+#include "nvm.h"
+
+/* use pool_[get/put]_block to administer the blocks in use for each pool.
+ * Whenever a block is in used by an append point, we store it within the
+ * used_list. We then move it back when its free to be used by another append
+ * point.
+ *
+ * The newly claimed block is always added to the back of used_list. As we
+ * assume that the start of used list is the oldest block, and therefore
+ * more likely to contain invalidated pages.
+ */
+struct nvm_block *nvm_pool_get_block(struct nvm_pool *pool, int is_gc)
+{
+	struct nvm_stor *s;
+	struct nvm_block *block = NULL;
+	unsigned long flags;
+
+	BUG_ON(!pool);
+
+	s = pool->s;
+	spin_lock_irqsave(&pool->lock, flags);
+
+	if (list_empty(&pool->free_list)) {
+		pr_err_ratelimited("Pool have no free pages available");
+		spin_unlock_irqrestore(&pool->lock, flags);
+		goto out;
+	}
+
+	while (!is_gc && pool->nr_free_blocks < s->nr_aps) {
+		spin_unlock_irqrestore(&pool->lock, flags);
+		goto out;
+	}
+
+	block = list_first_entry(&pool->free_list, struct nvm_block, list);
+	list_move_tail(&block->list, &pool->used_list);
+
+	pool->nr_free_blocks--;
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	nvm_reset_block(block);
+
+out:
+	return block;
+}
+
+/* We assume that all valid pages have already been moved when added back to the
+ * free list. We add it last to allow round-robin use of all pages. Thereby
+ * provide simple (naive) wear-leveling.
+ */
+void nvm_pool_put_block(struct nvm_block *block)
+{
+	struct nvm_pool *pool = block->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+
+	list_move_tail(&block->list, &pool->free_list);
+	pool->nr_free_blocks++;
+
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+/* lookup the primary translation table. If there isn't an associated block to
+ * the addr. We assume that there is no data and doesn't take a ref */
+struct nvm_addr *nvm_lookup_ltop(struct nvm_stor *s, sector_t l_addr)
+{
+	struct nvm_addr *gp, *p;
+
+	BUG_ON(!(l_addr >= 0 && l_addr < s->nr_pages));
+
+	p = mempool_alloc(s->addr_pool, GFP_ATOMIC);
+	if (!p)
+		return NULL;
+
+	gp = &s->trans_map[l_addr];
+
+	p->addr = gp->addr;
+	p->block = gp->block;
+
+	/* if it has not been written, p is initialized to 0. */
+	if (p->block) {
+		/* during gc, the mapping will be updated accordently. We
+		 * therefore stop submitting new reads to the address, until it
+		 * is copied to the new place. */
+		if (atomic_read(&p->block->gc_running))
+			goto err;
+	}
+
+	return p;
+err:
+	mempool_free(p, s->addr_pool);
+	return NULL;
+
+}
+
+static inline unsigned int nvm_rq_sectors(const struct request *rq)
+{
+	/*TODO: remove hardcoding, query nvm_dev for setting*/
+	return blk_rq_bytes(rq) >> 9;
+}
+
+static struct nvm_ap *__nvm_get_ap_rr(struct nvm_stor *s, int is_gc)
+{
+	unsigned int i;
+	struct nvm_pool *pool, *max_free;
+
+	if (!is_gc)
+		return get_next_ap(s);
+
+	/* during GC, we don't care about RR, instead we want to make
+	 * sure that we maintain evenness between the block pools. */
+	max_free = &s->pools[0];
+	/* prevent GC-ing pool from devouring pages of a pool with
+	 * little free blocks. We don't take the lock as we only need an
+	 * estimate. */
+	nvm_for_each_pool(s, pool, i) {
+		if (pool->nr_free_blocks > max_free->nr_free_blocks)
+			max_free = pool;
+	}
+
+	return &s->aps[max_free->id];
+}
+
+/*read/write RQ has locked addr range already*/
+
+static struct nvm_block *nvm_map_block_rr(struct nvm_stor *s, sector_t l_addr,
+					int is_gc)
+{
+	struct nvm_ap *ap = NULL;
+	struct nvm_block *block;
+
+	ap = __nvm_get_ap_rr(s, is_gc);
+
+	spin_lock(&ap->lock);
+	block = s->type->pool_get_blk(ap->pool, is_gc);
+	spin_unlock(&ap->lock);
+	return block; /*NULL iff. no free blocks*/
+}
+
+/* Simple round-robin Logical to physical address translation.
+ *
+ * Retrieve the mapping using the active append point. Then update the ap for
+ * the next write to the disk.
+ *
+ * Returns nvm_addr with the physical address and block. Remember to return to
+ * s->addr_cache when request is finished.
+ */
+static struct nvm_addr *nvm_map_page_rr(struct nvm_stor *s, sector_t l_addr,
+					int is_gc)
+{
+	struct nvm_addr *p;
+	struct nvm_ap *ap;
+	struct nvm_pool *pool;
+	struct nvm_block *p_block;
+	sector_t p_addr;
+
+	p = mempool_alloc(s->addr_pool, GFP_ATOMIC);
+	if (!p)
+		return NULL;
+
+	ap = __nvm_get_ap_rr(s, is_gc);
+	pool = ap->pool;
+
+	spin_lock(&ap->lock);
+
+	p_block = ap->cur;
+	p_addr = nvm_alloc_phys_addr(p_block);
+
+	if (p_addr == LTOP_EMPTY) {
+		p_block = s->type->pool_get_blk(pool, 0);
+
+		if (!p_block) {
+			if (is_gc) {
+				p_addr = nvm_alloc_phys_addr(ap->gc_cur);
+				if (p_addr == LTOP_EMPTY) {
+					p_block = s->type->pool_get_blk(pool, 1);
+					ap->gc_cur = p_block;
+					ap->gc_cur->ap = ap;
+					if (!p_block) {
+						pr_err("nvm: no more blocks");
+						goto finished;
+					} else {
+						p_addr =
+						nvm_alloc_phys_addr(ap->gc_cur);
+					}
+				}
+				p_block = ap->gc_cur;
+			}
+			goto finished;
+		}
+
+		nvm_set_ap_cur(ap, p_block);
+		p_addr = nvm_alloc_phys_addr(p_block);
+	}
+
+finished:
+	if (p_addr == LTOP_EMPTY) {
+		mempool_free(p, s->addr_pool);
+		return NULL;
+	}
+
+	p->addr = p_addr;
+	p->block = p_block;
+
+	if (!p_block)
+		WARN_ON(is_gc);
+
+	spin_unlock(&ap->lock);
+	if (p)
+		nvm_update_map(s, l_addr, p, is_gc);
+	return p;
+}
+
+/* none target type, round robin, page-based FTL, and cost-based GC */
+struct nvm_target_type nvm_target_rrpc = {
+	.name		= "rrpc",
+	.version	= {1, 0, 0},
+	.lookup_ltop	= nvm_lookup_ltop,
+	.map_page	= nvm_map_page_rr,
+	.map_block	= nvm_map_block_rr,
+
+	.write_rq	= nvm_write_rq,
+	.read_rq	= nvm_read_rq,
+
+	.pool_get_blk	= nvm_pool_get_block,
+	.pool_put_blk	= nvm_pool_put_block,
+};
+
+/* none target type, round robin, block-based FTL, and cost-based GC */
+struct nvm_target_type nvm_target_rrbc = {
+	.name		= "rrbc",
+	.version	= {1, 0, 0},
+	.lookup_ltop	= nvm_lookup_ltop,
+	.map_page	= NULL,
+	.map_block	= nvm_map_block_rr,
+
+	/*rewrite these to support multi-page writes*/
+	.write_rq	= nvm_write_rq,
+	.read_rq	= nvm_read_rq,
+
+	.pool_get_blk	= nvm_pool_get_block,
+	.pool_put_blk	= nvm_pool_put_block,
+};
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a1e31f2..0c0efac 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -130,6 +130,7 @@ enum {
 	BLK_MQ_F_TAG_SHARED	= 1 << 1,
 	BLK_MQ_F_SG_MERGE	= 1 << 2,
 	BLK_MQ_F_SYSFS_UP	= 1 << 3,
+	BLK_MQ_F_LIGHTNVM	= 1 << 4,
 
 	BLK_MQ_S_STOPPED	= 0,
 	BLK_MQ_S_TAG_ACTIVE	= 1,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 75296c0..74a3b35 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -208,6 +208,9 @@ struct request {
 
 	/* for bidi */
 	struct request *next_rq;
+#if CONFIG_LIGHTNVM
+	sector_t phys_sector;
+#endif
 };
 
 static inline unsigned short req_get_ioprio(struct request *req)
@@ -304,6 +307,10 @@ struct queue_limits {
 	unsigned char		raid_partial_stripes_expensive;
 };
 
+#ifdef CONFIG_LIGHTNVM
+#include <linux/lightnvm.h>
+#endif
+
 struct request_queue {
 	/*
 	 * Together with queue_head for cacheline sharing
@@ -450,6 +457,9 @@ struct request_queue {
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	struct blk_trace	*blk_trace;
 #endif
+#ifdef CONFIG_LIGHTNVM
+	struct nvm_dev *nvm;
+#endif
 	/*
 	 * for flush operations
 	 */
@@ -515,6 +525,7 @@ struct request_queue {
 #define QUEUE_FLAG_INIT_DONE   20	/* queue is initialized */
 #define QUEUE_FLAG_NO_SG_MERGE 21	/* don't attempt to merge SG segments*/
 #define QUEUE_FLAG_SG_GAPS     22	/* queue doesn't support SG gaps */
+#define QUEUE_FLAG_LIGHTNVM    23	/* lightnvm managed queue */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -602,6 +613,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
+#define blk_queue_lightnvm(q)	test_bit(QUEUE_FLAG_LIGHTNVM, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
@@ -1610,6 +1622,17 @@ static inline bool blk_integrity_is_initialized(struct gendisk *g)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+#ifdef CONFIG_LIGHTNVM
+struct lightnvm_dev_ops;
+extern int blk_lightnvm_register(struct request_queue *, struct lightnvm_dev_ops *);
+#else
+struct lightnvm_dev_ops;
+static int blk_lightnvm_register(struct request_queue *q, struct lightnvm_dev_ops *ops)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_LIGHTNVM */
+
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
diff --git a/include/linux/lightnvm.h b/include/linux/lightnvm.h
new file mode 100644
index 0000000..72d9c88
--- /dev/null
+++ b/include/linux/lightnvm.h
@@ -0,0 +1,112 @@
+#ifndef LIGHTNVM_H
+#define LIGHTNVM_H
+
+#include <linux/types.h>
+#include <linux/blk-mq.h>
+#include <linux/genhd.h>
+
+/* HW Responsibilities */
+enum {
+	NVM_RSP_L2P	= 0x00,
+	NVM_RSP_P2L	= 0x01,
+	NVM_RSP_GC	= 0x02,
+	NVM_RSP_ECC	= 0x03,
+};
+
+/* Physical NVM Type */
+enum {
+	NVM_NVMT_BLK	= 0,
+	NVM_NVMT_BYTE	= 1,
+};
+
+/* Internal IO Scheduling algorithm */
+enum {
+	NVM_IOSCHED_CHANNEL	= 0,
+	NVM_IOSCHED_CHIP	= 1,
+};
+
+/* Status codes */
+enum {
+	NVM_SUCCESS		= 0x0000,
+	NVM_INVALID_OPCODE	= 0x0001,
+	NVM_INVALID_FIELD	= 0x0002,
+	NVM_INTERNAL_DEV_ERROR	= 0x0006,
+	NVM_INVALID_CHNLID	= 0x000b,
+	NVM_LBA_RANGE		= 0x0080,
+	NVM_MAX_QSIZE_EXCEEDED	= 0x0102,
+	NVM_RESERVED		= 0x0104,
+	NVM_CONFLICTING_ATTRS	= 0x0180,
+	NVM_RID_NOT_SAVEABLE	= 0x010d,
+	NVM_RID_NOT_CHANGEABLE	= 0x010e,
+	NVM_ACCESS_DENIED	= 0x0286,
+	NVM_MORE		= 0x2000,
+	NVM_DNR			= 0x4000,
+	NVM_NO_COMPLETE		= 0xffff,
+};
+
+struct nvm_id_chnl {
+	u64	queue_size;
+	u64	gran_read;
+	u64	gran_write;
+	u64	gran_erase;
+	u64	oob_size;
+	u64	laddr_begin;
+	u64	laddr_end;
+	u32	t_r;
+	u32	t_sqr;
+	u32	t_w;
+	u32	t_sqw;
+	u32	t_e;
+	u8	io_sched;
+};
+
+struct nvm_id {
+	u16	ver_id;
+	u16	nchannels;
+	u8	nvm_type;
+	struct nvm_id_chnl *chnls;
+};
+
+struct nvm_get_features {
+	u64	rsp[4];
+	u64	ext[4];
+};
+
+struct nvm_dev;
+
+typedef int (nvm_id_fn)(struct request_queue *q, struct nvm_id *id);
+typedef int (nvm_get_features_fn)(struct request_queue *q, struct nvm_get_features *);
+typedef int (nvm_set_rsp_fn)(struct request_queue *q, u8 rsp, u8 val);
+typedef int (nvm_erase_blk_fn)(struct nvm_dev *, sector_t);
+
+struct lightnvm_dev_ops {
+	nvm_id_fn		*identify;
+	nvm_get_features_fn	*get_features;
+	nvm_set_rsp_fn		*set_responsibility;
+
+	nvm_erase_blk_fn	*nvm_erase_block;
+};
+
+struct nvm_dev {
+	struct lightnvm_dev_ops *ops;
+	struct gendisk *disk;
+	struct request_queue *q;
+
+	/* LightNVM stores extra data after the private driver data */
+	unsigned int drv_cmd_size;
+
+	void *stor;
+};
+
+/* LightNVM configuration */
+unsigned int nvm_cmd_size(void);
+
+int nvm_init(struct nvm_dev *);
+void nvm_exit(struct nvm_dev *);
+int nvm_map_rq(struct nvm_dev *, struct request *);
+void nvm_complete_request(struct nvm_dev *, struct request *, int err);
+
+int nvm_add_sysfs(struct device *);
+void nvm_remove_sysfs(struct device *);
+
+#endif
diff --git a/include/trace/events/nvm.h b/include/trace/events/nvm.h
new file mode 100644
index 0000000..23a12fb
--- /dev/null
+++ b/include/trace/events/nvm.h
@@ -0,0 +1,70 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM nvm
+
+#if !defined(_TRACE_NVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NVM_H
+
+#include <linux/blkdev.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(nvm__rq_map,
+	TP_PROTO(struct request *rq),
+	TP_ARGS(rq),
+
+	TP_STRUCT__entry(
+		__field(sector_t, sector)
+		__field(sector_t, phys_sector)
+		__field(unsigned int, data_len)
+		__field(u64, flags)
+	),
+
+	TP_fast_assign(
+		__entry->sector = rq->__sector;
+		__entry->phys_sector = rq->phys_sector;
+		__entry->data_len = rq->__data_len;
+		__entry->flags = rq->cmd_flags;
+	),
+
+	TP_printk("sector %llu phys_sector %llu data_len %u flags: %s",
+		(unsigned long long)__entry->sector,
+		(unsigned long long)__entry->phys_sector,
+		__entry->data_len,
+		__print_flags(__entry->flags, " ",
+			{REQ_NVM, "N"},
+			{REQ_NVM_MAPPED, "M"}
+		)
+	)
+);
+
+/**
+ * nvm_rq_map_begin - NVM mapping logic entered
+ * @rq: block IO request
+ *
+ * Called immediately after entering the NVM mapping function.
+ */
+DEFINE_EVENT(nvm__rq_map, nvm_rq_map_begin,
+
+	TP_PROTO(struct request *rq),
+
+	TP_ARGS(rq)
+);
+
+/**
+ * nvm_rq_map_end - NVM mapping logic exited
+ * @rq: block IO request
+ *
+ * Called immediately before the NVM mapping function exits. The flags of
+ * the request marks whether it has been treated as an actual NVM request
+ * and/or mapped or passed down directly.
+ */
+DEFINE_EVENT(nvm__rq_map, nvm_rq_map_end,
+
+	TP_PROTO(struct request *rq),
+
+	TP_ARGS(rq)
+);
+
+#endif /* _TRACE_NVM_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.9.1

