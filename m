Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbaJHP5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:57:14 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:57844 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaJHP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:57:09 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: thornber@redhat.com, snitzer@redhat.com, hch@infradead.org,
        hayakawa@valinux.co.jp, axboe@fb.com, andy@rudoff.com,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        linux-nvme@lists.infradead.org
Cc: jmad@itu.dk, =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 3/5] lightnvm: Support for Open-Channel SSDs
Date: Wed,  8 Oct 2014 17:55:34 +0200
Message-Id: <1412783736-18115-4-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412783736-18115-1-git-send-email-m@bjorling.me>
References: <1412783736-18115-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open-channel SSDs are devices which exposes direct access to its physical
flash storage, while keeping a subset of the internal features of SSDs.

A common SSD consists of a flash translation layer (FTL), bad block
management, and hardware units such as flash controller and host
interface controller and a large amount of flash chips.

LightNVM moves part of the FTL responsibility into the host, allowing
the host to manage data placement, garbage collection and parallelism. The
device continues to maintain information about bad block management, implements a
simpler FTL, that allows extensions such as atomic IOs, metadata
persistence and similar to be implemented.

The architecture of LightNVM consists of a core and multiple targets. The core
has the part of the driver that is shared across targets, initialization and
teardown and statistics. The other part is targets. They are how physical flash
are exposed to user-land. This can be as the block device, key-value store,
object-store, or anything else.

LightNVM is currently hooked up through the null_blk and NVMe driver. The NVMe
extension allow development using the LightNVM-extended QEMU implementation,
using Keith Busch's qemu-nvme branch.

Contributions in this patch from:

  Jesper Madsen <jmad@itu.dk>

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 drivers/Kconfig               |   2 +
 drivers/Makefile              |   1 +
 drivers/lightnvm/Kconfig      |  20 ++
 drivers/lightnvm/Makefile     |   5 +
 drivers/lightnvm/core.c       | 212 ++++++++++++++
 drivers/lightnvm/gc.c         | 233 ++++++++++++++++
 drivers/lightnvm/kv.c         | 513 ++++++++++++++++++++++++++++++++++
 drivers/lightnvm/nvm.c        | 540 ++++++++++++++++++++++++++++++++++++
 drivers/lightnvm/nvm.h        | 632 ++++++++++++++++++++++++++++++++++++++++++
 drivers/lightnvm/sysfs.c      |  79 ++++++
 drivers/lightnvm/targets.c    | 246 ++++++++++++++++
 include/linux/lightnvm.h      | 130 +++++++++
 include/uapi/linux/lightnvm.h |  45 +++
 13 files changed, 2658 insertions(+)
 create mode 100644 drivers/lightnvm/Kconfig
 create mode 100644 drivers/lightnvm/Makefile
 create mode 100644 drivers/lightnvm/core.c
 create mode 100644 drivers/lightnvm/gc.c
 create mode 100644 drivers/lightnvm/kv.c
 create mode 100644 drivers/lightnvm/nvm.c
 create mode 100644 drivers/lightnvm/nvm.h
 create mode 100644 drivers/lightnvm/sysfs.c
 create mode 100644 drivers/lightnvm/targets.c
 create mode 100644 include/linux/lightnvm.h
 create mode 100644 include/uapi/linux/lightnvm.h

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
index 0000000..ad31d9b
--- /dev/null
+++ b/drivers/lightnvm/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for LightNVM.
+#
+
+obj-$(CONFIG_LIGHTNVM)		+= nvm.o core.o gc.o sysfs.o kv.o targets.o
diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
new file mode 100644
index 0000000..ec9851a
--- /dev/null
+++ b/drivers/lightnvm/core.c
@@ -0,0 +1,212 @@
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
+	atomic_set(&block->data_size, 0);
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
+			/*defer scheduling of the block for recycling*/
+			queue_work(s->kgc_wq, &block->ws_eio);
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
+	struct nvm_addr *p;
+	sector_t l_addr;
+
+	l_addr = blk_rq_pos(rq) / NR_PHY_IN_LOG;
+
+	nvm_lock_laddr_range(s, l_addr, 1);
+
+	p = s->type->lookup_ltop(s, l_addr);
+	if (!p) {
+		nvm_unlock_laddr_range(s, l_addr, 1);
+		nvm_gc_kick(s);
+		return BLK_MQ_RQ_QUEUE_BUSY;
+	}
+
+	rq->__sector = p->addr * NR_PHY_IN_LOG +
+					(blk_rq_pos(rq) % NR_PHY_IN_LOG);
+
+	if (!p->block)
+		rq->__sector = 0;
+
+	nvm_setup_rq(s, rq, p, l_addr, NVM_RQ_NONE);
+	return BLK_MQ_RQ_QUEUE_OK;
+}
+
+
+int __nvm_write_rq(struct nvm_stor *s, struct request *rq, int is_gc)
+{
+	struct nvm_addr *p;
+	sector_t l_addr = blk_rq_pos(rq) / NR_PHY_IN_LOG;
+
+	nvm_lock_laddr_range(s, l_addr, 1);
+	p = s->type->map_page(s, l_addr, is_gc);
+	if (!p) {
+		BUG_ON(is_gc);
+		nvm_unlock_laddr_range(s, l_addr, 1);
+		nvm_gc_kick(s);
+
+		return BLK_MQ_RQ_QUEUE_BUSY;
+	}
+
+	/*
+	 * MB: Should be revised. We need a different hook into device
+	 * driver
+	 */
+	rq->__sector = p->addr * NR_PHY_IN_LOG;
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
index 0000000..3735979
--- /dev/null
+++ b/drivers/lightnvm/gc.c
@@ -0,0 +1,233 @@
+#include <linux/lightnvm.h>
+#include "nvm.h"
+
+/* Run only GC if less than 1/X blocks are free */
+#define GC_LIMIT_INVERSE 10
+
+static void queue_pool_gc(struct nvm_pool *pool)
+{
+	struct nvm_stor *s = pool->s;
+
+	queue_work(s->krqd_wq, &pool->gc_ws);
+}
+
+void nvm_gc_cb(unsigned long data)
+{
+	struct nvm_stor *s = (struct nvm_stor *)data;
+	struct nvm_pool *pool;
+	int i;
+
+	nvm_for_each_pool(s, pool, i)
+		queue_pool_gc(pool);
+
+	mod_timer(&s->gc_timer,
+			jiffies + msecs_to_jiffies(s->config.gc_time));
+}
+
+/* the block with highest number of invalid pages, will be in the beginning
+ * of the list */
+static struct nvm_block *block_max_invalid(struct nvm_block *a,
+					   struct nvm_block *b)
+{
+	BUG_ON(!a || !b);
+
+	if (a->nr_invalid_pages == b->nr_invalid_pages)
+		return a;
+
+	return (a->nr_invalid_pages < b->nr_invalid_pages) ? b : a;
+}
+
+/* linearly find the block with highest number of invalid pages
+ * requires pool->lock */
+static struct nvm_block *block_prio_find_max(struct nvm_pool *pool)
+{
+	struct list_head *list = &pool->prio_list;
+	struct nvm_block *block, *max;
+
+	BUG_ON(list_empty(list));
+
+	max = list_first_entry(list, struct nvm_block, prio);
+	list_for_each_entry(block, list, prio)
+		max = block_max_invalid(max, block);
+
+	return max;
+}
+
+/* Move data away from flash block to be erased. Additionally update the
+ * l to p and p to l mappings. */
+static void nvm_move_valid_pages(struct nvm_stor *s, struct nvm_block *block)
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
+void nvm_gc_collect(struct work_struct *work)
+{
+	struct nvm_pool *pool = container_of(work, struct nvm_pool, gc_ws);
+	struct nvm_stor *s = pool->s;
+	struct nvm_block *block;
+	unsigned int nr_blocks_need;
+	unsigned long flags;
+
+	nr_blocks_need = pool->nr_blocks / 10;
+
+	if (nr_blocks_need < s->nr_aps)
+		nr_blocks_need = s->nr_aps;
+
+	local_irq_save(flags);
+	spin_lock(&pool->lock);
+	while (nr_blocks_need > pool->nr_free_blocks &&
+						!list_empty(&pool->prio_list)) {
+		block = block_prio_find_max(pool);
+
+		if (!block->nr_invalid_pages) {
+			__show_pool(pool);
+			pr_err("No invalid pages");
+			break;
+		}
+
+		list_del_init(&block->prio);
+
+		BUG_ON(!block_is_full(block));
+		BUG_ON(atomic_inc_return(&block->gc_running) != 1);
+
+		queue_work(s->kgc_wq, &block->ws_gc);
+
+		nr_blocks_need--;
+	}
+	spin_unlock(&pool->lock);
+	s->next_collect_pool++;
+	local_irq_restore(flags);
+
+	/* TODO: Hint that request queue can be started again */
+}
+
+void nvm_gc_block(struct work_struct *work)
+{
+	struct nvm_block *block = container_of(work, struct nvm_block, ws_gc);
+	struct nvm_stor *s = block->pool->s;
+
+	/* TODO: move outside lock to allow multiple pages
+	 * in parallel to be erased. */
+	nvm_move_valid_pages(s, block);
+	nvm_erase_block(s, block);
+	s->type->pool_put_blk(block);
+}
+
+void nvm_gc_recycle_block(struct work_struct *work)
+{
+	struct nvm_block *block = container_of(work, struct nvm_block, ws_eio);
+	struct nvm_pool *pool = block->pool;
+
+	spin_lock(&pool->lock);
+	list_add_tail(&block->prio, &pool->prio_list);
+	spin_unlock(&pool->lock);
+}
+
+void nvm_gc_kick(struct nvm_stor *s)
+{
+	struct nvm_pool *pool;
+	unsigned int i;
+
+	BUG_ON(!s);
+
+	nvm_for_each_pool(s, pool, i)
+		queue_pool_gc(pool);
+}
diff --git a/drivers/lightnvm/kv.c b/drivers/lightnvm/kv.c
new file mode 100644
index 0000000..9c30143
--- /dev/null
+++ b/drivers/lightnvm/kv.c
@@ -0,0 +1,513 @@
+#define DEBUG
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <linux/jhash.h>
+#include <linux/slab.h>
+#include "nvm.h"
+
+/* inflight uses jenkins hash - less to compare, collisions only result
+ * in unecessary serialisation.
+ *
+ * could restrict oneself to only grabbing table lock whenever you specifically
+ * want a new entry -- otherwise no concurrent threads will ever be interested
+ * in the same entry
+ */
+
+#define BUCKET_LEN 16
+#define BUCKET_OCCUPANCY_AVG (BUCKET_LEN / 4)
+
+struct kv_inflight {
+	struct list_head list;
+	u32	h1;
+};
+
+struct kv_entry {
+	u64 hash[2];
+	struct nvm_block *blk;
+};
+
+struct nvmkv_io {
+	int offset;
+	unsigned npages;
+	unsigned length;
+	struct page **pages;
+	struct nvm_block *block;
+	int write;
+};
+
+enum {
+	EXISTING_ENTRY	= 0,
+	NEW_ENTRY	= 1,
+};
+
+static inline unsigned bucket_idx(struct nvmkv_tbl *tbl, u32 hash)
+{
+	return hash % (tbl->tbl_len / BUCKET_LEN);
+}
+
+static void inflight_lock(struct nvmkv_inflight *ilist,
+						struct kv_inflight *ientry)
+{
+	struct kv_inflight *lentry;
+	unsigned long flags;
+
+retry:
+	spin_lock_irqsave(&ilist->lock, flags);
+
+	list_for_each_entry(lentry, &ilist->list, list) {
+		if (lentry->h1 == ientry->h1) {
+			spin_unlock_irqrestore(&ilist->lock, flags);
+			schedule();
+			goto retry;
+		}
+	}
+
+	list_add_tail(&ientry->list, &ilist->list);
+	spin_unlock_irqrestore(&ilist->lock, flags);
+}
+
+static void inflight_unlock(struct nvmkv_inflight *ilist, u32 h1)
+{
+	struct kv_inflight *lentry;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ilist->lock, flags);
+	BUG_ON(list_empty(&ilist->list));
+
+	list_for_each_entry(lentry, &ilist->list, list) {
+		if (lentry->h1 == h1) {
+			list_del(&lentry->list);
+			goto out;
+		}
+	}
+
+	BUG();
+out:
+	spin_unlock_irqrestore(&ilist->lock, flags);
+}
+
+/*TODO reserving '0' for empty entries is technically a no-go as it could be
+  a hash value.*/
+static int __tbl_get_idx(struct nvmkv_tbl *tbl, u32 h1, const u64 *h2,
+							unsigned int type)
+{
+	unsigned b_idx = bucket_idx(tbl, h1);
+	unsigned idx = BUCKET_LEN * b_idx;
+	struct kv_entry *entry = &tbl->entries[idx];
+	unsigned i;
+
+	for (i = 0; i < BUCKET_LEN; i++, entry++) {
+		if (!memcmp(entry->hash, h2, sizeof(u64) * 2)) {
+			if (type == NEW_ENTRY)
+				entry->hash[0] = 1;
+			idx += i;
+			break;
+		}
+	}
+
+	if (i == BUCKET_LEN)
+		idx = -1;
+
+	return idx;
+}
+
+static int tbl_get_idx(struct nvmkv_tbl *tbl, u32 h1, const u64 *h2,
+							unsigned int type)
+{
+	int idx;
+
+	spin_lock(&tbl->lock);
+	idx = __tbl_get_idx(tbl, h1, h2, type);
+	spin_unlock(&tbl->lock);
+	return idx;
+}
+
+
+static int tbl_new_entry(struct nvmkv_tbl *tbl, u32 h1)
+{
+	const u64 empty[2] = { 0, 0 };
+
+	return tbl_get_idx(tbl, h1, empty, NEW_ENTRY);
+}
+
+static u32 hash1(void *key, unsigned key_len)
+{
+	u32 hash;
+	u32 *p = (u32 *) key;
+	u32 len = key_len / sizeof(u32);
+	u32 offset = key_len % sizeof(u32);
+
+	if (offset) {
+		memcpy(&offset, p + len, offset);
+		hash = jhash2(p, len, 0);
+		return jhash2(&offset, 1, hash);
+	}
+	return jhash2(p, len, 0);
+}
+
+static void hash2(void *dst, void *src, size_t src_len)
+{
+	struct scatterlist sg;
+	struct hash_desc hdesc;
+
+	sg_init_one(&sg, src, src_len);
+	hdesc.tfm = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
+	crypto_hash_init(&hdesc);
+	crypto_hash_update(&hdesc, &sg, src_len);
+	crypto_hash_final(&hdesc, (u8 *)dst);
+	crypto_free_hash(hdesc.tfm);
+}
+
+static void *cpy_val(u64 addr, size_t len)
+{
+	void *buf;
+
+	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	if (copy_from_user(buf, (void *)addr, len)) {
+		kfree(buf);
+		return ERR_PTR(-EFAULT);
+	}
+	return buf;
+}
+
+static int do_io(struct nvm_stor *s, int rw, u64 blk_addr, void __user *ubuf,
+							unsigned long len)
+{
+	struct nvm_dev *dev = s->dev;
+	struct request_queue *q = dev->q;
+	struct request *rq;
+	struct bio *orig_bio;
+	int ret;
+
+	rq = blk_mq_alloc_request(q, rw, GFP_KERNEL, false);
+	if (!rq) {
+		pr_err("lightnvm: failed to allocate request\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = blk_rq_map_user(q, rq, NULL, ubuf, len, GFP_KERNEL);
+	if (ret) {
+		pr_err("lightnvm: failed to map userspace memory into request\n");
+		goto err_umap;
+	}
+	orig_bio = rq->bio;
+
+	rq->cmd_flags |= REQ_NVM;
+	rq->__sector = blk_addr * NR_PHY_IN_LOG;
+	rq->errors = 0;
+
+	ret = blk_execute_rq(q, dev->disk, rq, 0);
+	if (ret)
+		pr_err("lightnvm: failed to execute request..\n");
+
+	blk_rq_unmap_user(orig_bio);
+
+err_umap:
+	blk_put_request(rq);
+out:
+	return ret;
+}
+
+/**
+ *	get	-	get value from KV store
+ *	@s: nvm stor
+ *	@cmd: LightNVM KV command
+ *	@key: copy of key supplied from userspace.
+ *	@h1: hash of key value using hash function 1
+ *
+ *	Fetch value identified by the supplied key.
+ */
+static int get(struct nvm_stor *s, struct lightnvm_cmd_kv *cmd, void *key,
+									u32 h1)
+{
+	struct nvmkv_tbl *tbl = &s->kv.tbl;
+	struct kv_entry *entry;
+
+	u64 h2[2];
+	int idx;
+
+	hash2(&h2, key, cmd->key_len);
+
+	idx = tbl_get_idx(tbl, h1, h2, EXISTING_ENTRY);
+	if (idx < 0)
+		return LIGHTNVM_KV_ERR_NOKEY;
+
+	entry = &tbl->entries[idx];
+
+	return do_io(s, READ, block_to_addr(entry->blk),
+			(void __user *)cmd->val_addr, cmd->val_len);
+}
+
+static struct nvm_block *acquire_block(struct nvm_stor *s)
+{
+	struct nvm_ap *ap;
+	struct nvm_pool *pool;
+	struct nvm_block *block = NULL;
+	int i;
+
+	for (i = 0; i < s->nr_aps; i++) {
+		ap = get_next_ap(s);
+		pool = ap->pool;
+
+		block = s->type->pool_get_blk(pool, 0);
+		if (block)
+			break;
+	}
+	return block;
+}
+
+static int update_entry(struct nvm_stor *s, struct lightnvm_cmd_kv *cmd,
+			struct kv_entry *entry)
+{
+	struct nvm_block *block;
+	int ret;
+
+	BUG_ON(!s);
+	BUG_ON(!cmd);
+	BUG_ON(!entry);
+
+	block = acquire_block(s);
+	if (!block) {
+		pr_err("lightnvm: failed to acquire a block\n");
+		ret = -ENOSPC;
+		goto no_block;
+	}
+	ret = do_io(s, WRITE, block_to_addr(block),
+				(void __user *)cmd->val_addr, cmd->val_len);
+	if (ret) {
+		pr_err("lightnvm: failed to write entry\n");
+		ret = -EIO;
+		goto io_err;
+	}
+
+	if (entry->blk)
+		s->type->pool_put_blk(entry->blk);
+
+	entry->blk = block;
+
+	return ret;
+io_err:
+	s->type->pool_put_blk(block);
+no_block:
+	return ret;
+}
+
+/**
+ * put - put/update value in KV store
+ * @s: nvm stor
+ * @cmd: LightNVM KV command
+ * @key: copy of key supplied from userspace.
+ * @h1: hash of key value using hash function 1
+ *
+ * Store the supplied value in an entry identified by the
+ * supplied key. Will overwrite existing entry if necessary.
+ */
+static int put(struct nvm_stor *s, struct lightnvm_cmd_kv *cmd, void *key,
+									u32 h1)
+{
+	struct nvmkv_tbl *tbl = &s->kv.tbl;
+	struct kv_entry *entry;
+	u64 h2[2];
+	int idx, ret;
+
+	hash2(&h2, key, cmd->key_len);
+
+	idx = tbl_get_idx(tbl, h1, h2, EXISTING_ENTRY);
+	if (idx != -1) {
+		entry = &tbl->entries[idx];
+	} else {
+		idx = tbl_new_entry(tbl, h1);
+		if (idx != -1) {
+			entry = &tbl->entries[idx];
+			memcpy(entry->hash, &h2, sizeof(entry->hash));
+		} else {
+			pr_err("lightnvm: no empty entries\n");
+			BUG();
+		}
+	}
+
+	ret = update_entry(s, cmd, entry);
+
+	/* If update_entry failed, we reset the entry->hash, as it was updated
+	 * by the previous statements and is no longer valid */
+	if (!entry->blk)
+		memset(entry->hash, 0, sizeof(entry->hash));
+
+	return ret;
+}
+
+/**
+ *	update	-	 update existing entry
+ *	@s: nvm stor
+ *	@cmd: LightNVM KV command
+ *	@key: copy of key supplied from userspace.
+ *	@h1: hash of key value using hash function 1
+ *
+ *	Updates existing value identified by 'k' to the new value.
+ *	Operation only succeeds if k points to an existing value.
+ */
+static int update(struct nvm_stor *s, struct lightnvm_cmd_kv *cmd, void *key,
+									u32 h1)
+{
+	struct nvmkv_tbl *tbl = &s->kv.tbl;
+	struct kv_entry *entry;
+	u64 h2[2];
+	int ret;
+
+	hash2(&h2, key, cmd->key_len);
+
+	ret = tbl_get_idx(tbl, h1, h2, EXISTING_ENTRY);
+	if (ret < 0) {
+		pr_debug("lightnvm: no entry, skipping\n");
+		return 0;
+	}
+
+	entry = &tbl->entries[ret];
+
+	ret = update_entry(s, cmd, entry);
+	if (ret)
+		memset(entry->hash, 0, sizeof(entry->hash));
+	return ret;
+}
+
+/**
+ *	del	 -	 delete entry.
+ *	@s: nvm stor
+ *	@cmd: LightNVM KV command
+ *	@key: copy of key supplied from userspace.
+ *	@h1: hash of key value using hash function 1
+ *
+ *	Removes the value associated the supplied key.
+ */
+static int del(struct nvm_stor *s, struct lightnvm_cmd_kv *cmd, void *key,
+									u32 h1)
+{
+	struct nvmkv_tbl *tbl = &s->kv.tbl;
+	struct kv_entry *entry;
+	u64 h2[2];
+	int idx;
+
+	hash2(&h2, key, cmd->key_len);
+
+	idx = tbl_get_idx(tbl, h1, h2, EXISTING_ENTRY);
+	if (idx != -1) {
+		entry = &tbl->entries[idx];
+		s->type->pool_put_blk(entry->blk);
+		memset(entry, 0, sizeof(struct kv_entry));
+	} else {
+		pr_debug("lightnvm: could not find entry!\n");
+	}
+
+	return 0;
+}
+
+int nvmkv_unpack(struct nvm_dev *dev, struct lightnvm_cmd_kv __user *ucmd)
+{
+	struct nvm_stor *s = dev->stor;
+	struct nvmkv_inflight *inflight = &s->kv.inflight;
+	struct kv_inflight *ientry;
+	struct lightnvm_cmd_kv cmd;
+	u32 h1;
+	void *key;
+	int ret = 0;
+
+	if (copy_from_user(&cmd, ucmd, sizeof(cmd)))
+		return -EFAULT;
+
+	key = cpy_val(cmd.key_addr, cmd.key_len);
+	if (IS_ERR(key)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	h1 = hash1(key, cmd.key_len);
+	ientry = kmem_cache_alloc(inflight->entry_pool, GFP_KERNEL);
+	if (!ientry) {
+		ret = -ENOMEM;
+		goto err_ientry;
+	}
+	ientry->h1 = h1;
+
+	inflight_lock(inflight, ientry);
+
+	switch (cmd.opcode) {
+	case LIGHTNVM_KV_GET:
+		ret = get(s, &cmd, key, h1);
+		break;
+	case LIGHTNVM_KV_PUT:
+		ret = put(s, &cmd, key, h1);
+		break;
+	case LIGHTNVM_KV_UPDATE:
+		ret = update(s, &cmd, key, h1);
+		break;
+	case LIGHTNVM_KV_DEL:
+		ret = del(s, &cmd, key, h1);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	inflight_unlock(inflight, h1);
+
+err_ientry:
+	kfree(key);
+out:
+	if (ret > 0) {
+		ucmd->errcode = ret;
+		ret = 0;
+	}
+	return ret;
+}
+
+int nvmkv_init(struct nvm_stor *s, unsigned long size)
+{
+	struct nvmkv_tbl *tbl = &s->kv.tbl;
+	struct nvmkv_inflight *inflight = &s->kv.inflight;
+	int ret = 0;
+
+	unsigned long buckets = s->total_blocks
+					/ (BUCKET_LEN / BUCKET_OCCUPANCY_AVG);
+
+	tbl->bucket_len = BUCKET_LEN;
+	tbl->tbl_len = buckets * tbl->bucket_len;
+
+	tbl->entries = vzalloc(tbl->tbl_len * sizeof(struct kv_entry));
+	if (!tbl->entries) {
+		ret = -ENOMEM;
+		goto err_tbl_entries;
+	}
+
+	inflight->entry_pool = kmem_cache_create("nvmkv_inflight_pool",
+				sizeof(struct kv_inflight), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+				NULL);
+	if (!inflight->entry_pool) {
+		ret = -ENOMEM;
+		goto err_inflight_pool;
+	}
+
+	spin_lock_init(&tbl->lock);
+	INIT_LIST_HEAD(&inflight->list);
+	spin_lock_init(&inflight->lock);
+
+	return 0;
+
+err_inflight_pool:
+	vfree(tbl->entries);
+err_tbl_entries:
+	return ret;
+}
+
+void nvmkv_exit(struct nvm_stor *s)
+{
+	struct nvmkv_tbl *tbl = &s->kv.tbl;
+	struct nvmkv_inflight *inflight = &s->kv.inflight;
+
+	vfree(tbl->entries);
+	kmem_cache_destroy(inflight->entry_pool);
+}
diff --git a/drivers/lightnvm/nvm.c b/drivers/lightnvm/nvm.c
new file mode 100644
index 0000000..aaf3aca
--- /dev/null
+++ b/drivers/lightnvm/nvm.c
@@ -0,0 +1,540 @@
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
+#include <trace/events/block.h>
+
+#include "nvm.h"
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
+int nvm_queue_rq(struct nvm_dev *dev, struct request *rq)
+{
+	struct nvm_stor *s = dev->stor;
+	int ret;
+
+	if (rq->cmd_flags & REQ_NVM_MAPPED)
+		return BLK_MQ_RQ_QUEUE_OK;
+
+	if (blk_rq_pos(rq) / NR_PHY_IN_LOG > s->nr_pages) {
+		pr_err("lightnvm: out-of-bound address: %llu",
+					(unsigned long long) blk_rq_pos(rq));
+		return BLK_MQ_RQ_QUEUE_ERROR;
+	}
+
+
+	if (rq_data_dir(rq) == WRITE)
+		ret = s->type->write_rq(s, rq);
+	else
+		ret = s->type->read_rq(s, rq);
+
+	if (ret == BLK_MQ_RQ_QUEUE_OK)
+		rq->cmd_flags |= (REQ_NVM|REQ_NVM_MAPPED);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvm_queue_rq);
+
+void nvm_end_io(struct nvm_dev *nvm_dev, struct request *rq, int error)
+{
+	if (rq->cmd_flags & (REQ_NVM|REQ_NVM_MAPPED))
+		nvm_endio(nvm_dev, rq, error);
+
+	if (!(rq->cmd_flags & REQ_NVM))
+		pr_info("lightnvm: request outside lightnvm detected.\n");
+
+	blk_mq_end_io(rq, error);
+}
+EXPORT_SYMBOL_GPL(nvm_end_io);
+
+void nvm_complete_request(struct nvm_dev *nvm_dev, struct request *rq)
+{
+	if (rq->cmd_flags & (REQ_NVM|REQ_NVM_MAPPED))
+		nvm_endio(nvm_dev, rq, 0);
+
+	if (!(rq->cmd_flags & REQ_NVM))
+		pr_info("lightnvm: request outside lightnvm.\n");
+
+	blk_mq_complete_request(rq);
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
+		kfree(pool->blocks);
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
+	int i, j;
+
+	spin_lock_init(&s->rev_lock);
+
+	s->pools = kcalloc(s->nr_pools, sizeof(struct nvm_pool), GFP_KERNEL);
+	if (!s->pools)
+		goto err_pool;
+
+	nvm_for_each_pool(s, pool, i) {
+		spin_lock_init(&pool->lock);
+		spin_lock_init(&pool->waiting_lock);
+
+		init_completion(&pool->gc_finished);
+
+		INIT_WORK(&pool->gc_ws, nvm_gc_collect);
+
+		INIT_LIST_HEAD(&pool->free_list);
+		INIT_LIST_HEAD(&pool->used_list);
+		INIT_LIST_HEAD(&pool->prio_list);
+
+		pool->id = i;
+		pool->s = s;
+		pool->phy_addr_start = i * s->nr_blks_per_pool;
+		pool->phy_addr_end = (i + 1) * s->nr_blks_per_pool - 1;
+		pool->nr_free_blocks = pool->nr_blocks =
+				pool->phy_addr_end - pool->phy_addr_start + 1;
+		bio_list_init(&pool->waiting_bios);
+		atomic_set(&pool->is_active, 0);
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
+			INIT_LIST_HEAD(&block->prio);
+
+			block->pool = pool;
+			block->id = (i * s->nr_blks_per_pool) + j;
+
+			list_add_tail(&block->list, &pool->free_list);
+			INIT_WORK(&block->ws_gc, nvm_gc_block);
+			INIT_WORK(&block->ws_eio, nvm_gc_recycle_block);
+		}
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
+
+		ap->t_read = s->config.t_read;
+		ap->t_write = s->config.t_write;
+		ap->t_erase = s->config.t_erase;
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
+	s->sector_size = EXPOSED_PAGE_SIZE;
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
+	nvm_pools_init(s);
+
+	if (s->type->init && s->type->init(s))
+		goto err_addr_pool;
+
+	/* FIXME: Clean up pool init on failure. */
+	setup_timer(&s->gc_timer, nvm_gc_cb, (unsigned long)s);
+	mod_timer(&s->gc_timer, jiffies + msecs_to_jiffies(1000));
+
+	return 0;
+err_addr_pool:
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
+#define NVM_NUM_POOLS 8
+#define NVM_NUM_BLOCKS 256
+#define NVM_NUM_PAGES 256
+
+struct nvm_dev *nvm_alloc()
+{
+	return kmalloc(sizeof(struct nvm_dev), GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(nvm_alloc);
+
+void nvm_free(struct nvm_dev *dev)
+{
+	kfree(dev);
+}
+EXPORT_SYMBOL_GPL(nvm_free);
+
+int nvm_queue_init(struct nvm_dev *dev)
+{
+	int nr_sectors_per_page = 8; /* 512 bytes */
+
+	if (queue_logical_block_size(dev->q) > (nr_sectors_per_page << 9)) {
+		pr_err("nvm: logical page size not supported by hardware");
+		return false;
+	}
+
+	return true;
+}
+
+int nvm_init(struct gendisk *disk, struct nvm_dev *dev)
+{
+	struct nvm_stor *s;
+	struct nvm_id nvm_id;
+	struct nvm_id_chnl *nvm_id_chnl;
+	int ret = 0;
+
+	unsigned long size;
+
+	if (!dev->ops->identify)
+		return -EINVAL;
+
+	if (!nvm_queue_init(dev))
+		return -EINVAL;
+
+	nvm_id_chnl = kmalloc(sizeof(struct nvm_id_chnl), GFP_KERNEL);
+	if (!nvm_id_chnl) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	_addr_cache = kmem_cache_create("nvm_addr_cache",
+				sizeof(struct nvm_addr), 0, 0, NULL);
+	if (!_addr_cache) {
+		ret = -ENOMEM;
+		goto err_memcache;
+	}
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
+		goto err_target;
+	}
+
+	if (dev->ops->identify(dev, &nvm_id)) {
+		ret = -EINVAL;
+		goto err_target;
+	}
+
+	s->nr_pools = nvm_id.nchannels;
+
+	/* TODO: We're limited to the same setup for each channel */
+	if (dev->ops->identify_channel(dev, 0, nvm_id_chnl)) {
+		ret = -EINVAL;
+		goto err_target;
+	}
+
+	s->gran_blk = le64_to_cpu(nvm_id_chnl->gran_erase);
+	s->gran_read = le64_to_cpu(nvm_id_chnl->gran_read);
+	s->gran_write = le64_to_cpu(nvm_id_chnl->gran_write);
+
+	size = (nvm_id_chnl->laddr_end - nvm_id_chnl->laddr_begin)
+					* min(s->gran_read, s->gran_write);
+
+	s->total_blocks = size / s->gran_blk;
+	s->nr_blks_per_pool = s->total_blocks / nvm_id.nchannels;
+	/* TODO: gran_{read,write} may differ */
+	s->nr_pages_per_blk = s->gran_blk / s->gran_read *
+					(s->gran_read / EXPOSED_PAGE_SIZE);
+
+	s->nr_aps_per_pool = APS_PER_POOL;
+	/* s->config.flags = NVM_OPT_* */
+	s->config.gc_time = GC_TIME;
+	s->config.t_read = le32_to_cpu(nvm_id_chnl->t_r) / 1000;
+	s->config.t_write = le32_to_cpu(nvm_id_chnl->t_w) / 1000;
+	s->config.t_erase = le32_to_cpu(nvm_id_chnl->t_e) / 1000;
+
+	/* Constants */
+	s->nr_pages = s->nr_pools * s->nr_blks_per_pool * s->nr_pages_per_blk;
+
+	ret = nvmkv_init(s, size);
+	if (ret) {
+		pr_err("lightnvm: kv init failed.\n");
+		goto err_target;
+	}
+
+	if (s->nr_pages_per_blk > MAX_INVALID_PAGES_STORAGE * BITS_PER_LONG) {
+		pr_err("lightnvm: Num. pages per block too high. Increase MAX_INVALID_PAGES_STORAGE.");
+		ret = -EINVAL;
+		goto err_target;
+	}
+
+	ret = nvm_stor_init(dev, s);
+	if (ret < 0) {
+		pr_err("lightnvm: cannot initialize nvm structure.");
+		goto err_map;
+	}
+
+	pr_info("lightnvm: pools: %u\n", s->nr_pools);
+	pr_info("lightnvm: blocks: %u\n", s->nr_blks_per_pool);
+	pr_info("lightnvm: pages per block: %u\n", s->nr_pages_per_blk);
+	pr_info("lightnvm: append points: %u\n", s->nr_aps);
+	pr_info("lightnvm: append points per pool: %u\n", s->nr_aps_per_pool);
+	pr_info("lightnvm: timings: %u/%u/%u\n",
+			s->config.t_read,
+			s->config.t_write,
+			s->config.t_erase);
+	pr_info("lightnvm: target sector size=%d\n", s->sector_size);
+	pr_info("lightnvm: disk flash size=%d map size=%d\n",
+			s->gran_read, EXPOSED_PAGE_SIZE);
+	pr_info("lightnvm: allocated %lu physical pages (%lu KB)\n",
+			s->nr_pages, s->nr_pages * s->sector_size / 1024);
+
+	dev->stor = s;
+	kfree(nvm_id_chnl);
+	return 0;
+
+err_map:
+	nvmkv_exit(s);
+err_target:
+	kfree(s);
+err_stor:
+	kmem_cache_destroy(_addr_cache);
+err_memcache:
+	kfree(nvm_id_chnl);
+err:
+	pr_err("lightnvm: failed to initialize nvm\n");
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvm_init);
+
+void nvm_exit(struct nvm_dev *dev)
+{
+	struct nvm_stor *s = dev->stor;
+
+	if (!s)
+		return;
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
+	kfree(s);
+
+	kmem_cache_destroy(_addr_cache);
+
+	pr_info("lightnvm: successfully unloaded");
+}
+
+int nvm_ioctl(struct nvm_dev *dev, fmode_t mode, unsigned int cmd,
+							unsigned long arg)
+{
+	switch (cmd) {
+	case LIGHTNVM_IOCTL_KV:
+		return nvmkv_unpack(dev, (void __user *)arg);
+	default:
+		return -ENOTTY;
+	}
+}
+EXPORT_SYMBOL_GPL(nvm_ioctl);
+
+#ifdef CONFIG_COMPAT
+int nvm_compat_ioctl(struct nvm_dev *dev, fmode_t mode,
+		unsigned int cmd, unsigned long arg)
+{
+	return nvm_ioctl(dev, mode, cmd, arg);
+}
+EXPORT_SYMBOL_GPL(nvm_compat_ioctl);
+#else
+#define nvm_compat_ioctl	NULL
+#endif
+
+MODULE_DESCRIPTION("LightNVM");
+MODULE_AUTHOR("Matias Bjorling <mabj@itu.dk>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/lightnvm/nvm.h b/drivers/lightnvm/nvm.h
new file mode 100644
index 0000000..7acf34d
--- /dev/null
+++ b/drivers/lightnvm/nvm.h
@@ -0,0 +1,632 @@
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
+#define EXPOSED_PAGE_SIZE 4096
+
+/* We currently assume that we the lightnvm device is accepting data in 512
+ * bytes chunks. This should be set to the smallest command size available for a
+ * given device.
+ */
+#define NR_PHY_IN_LOG (EXPOSED_PAGE_SIZE / 512)
+
+/* We partition the namespace of translation map into these pieces for tracking
+ * in-flight addresses. */
+#define NVM_INFLIGHT_PARTITIONS 8
+#define NVM_INFLIGHT_TAGS 256
+
+#define NVM_OPT_MISC_OFFSET 15
+
+enum ltop_flags {
+	/* Update primary mapping (and init secondary mapping as a result) */
+	MAP_PRIMARY	= 1 << 0,
+	/* Update only shaddow mapping */
+	MAP_SHADOW	= 1 << 1,
+	/* Update only the relevant mapping (primary/shaddow) */
+	MAP_SINGLE	= 1 << 2,
+};
+
+enum target_flags {
+	/* No hints applied */
+	NVM_OPT_ENGINE_NONE		= 0 <<  0,
+	/* Swap aware hints. Detected from block request type */
+	NVM_OPT_ENGINE_SWAP		= 1 <<  0,
+	/* IOCTL aware hints. Applications may submit direct hints */
+	NVM_OPT_ENGINE_IOCTL	= 1 <<  1,
+	/* Latency aware hints. Detected from file type or directly from app */
+	NVM_OPT_ENGINE_LATENCY	= 1 <<  2,
+	/* Pack aware hints. Detected from file type or directly from app */
+	NVM_OPT_ENGINE_PACK	= 1 <<  3,
+
+	/* Control accesses to append points in the host. Enable this for
+	 * devices that doesn't have an internal queue that only lets one
+	 * command run at a time within an append point */
+	NVM_OPT_POOL_SERIALIZE	= 1 << NVM_OPT_MISC_OFFSET,
+	/* Use fast/slow page access pattern */
+	NVM_OPT_FAST_SLOW_PAGES	= 1 << (NVM_OPT_MISC_OFFSET+1),
+	/* Disable dev waits */
+	NVM_OPT_NO_WAITS	= 1 << (NVM_OPT_MISC_OFFSET+2),
+};
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
+	/* Management and GC structures */
+	struct list_head list;
+	struct list_head prio;
+
+	/* Persistent data structures */
+	atomic_t data_size; /* data pages inserted into data variable */
+	atomic_t data_cmnt_size; /* data pages committed to stable storage */
+
+	/* Block state handling */
+	atomic_t gc_running;
+	struct work_struct ws_gc;
+	struct work_struct ws_eio;
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
+	struct list_head prio_list;	/* Blocks that may be GC'ed. */
+
+	unsigned int id;
+	/* References the physical start block */
+	unsigned long phy_addr_start;
+	/* References the physical end block */
+	unsigned int phy_addr_end;
+
+	unsigned int nr_blocks;		/* end_block - start_block. */
+	unsigned int nr_free_blocks;	/* Number of unused blocks */
+
+	struct nvm_block *blocks;
+	struct nvm_stor *s;
+
+	/* Postpone issuing I/O if append point is active */
+	atomic_t is_active;
+
+	spinlock_t waiting_lock;
+	struct work_struct waiting_ws;
+	struct bio_list waiting_bios;
+
+	struct bio *cur_bio;
+
+	unsigned int gc_running;
+	struct completion gc_finished;
+	struct work_struct gc_ws;
+
+	void *private;
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
+	/* Timings used for end_io waiting */
+	unsigned long t_read;
+	unsigned long t_write;
+	unsigned long t_erase;
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
+
+	unsigned int t_read;
+	unsigned int t_write;
+	unsigned int t_erase;
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
+typedef struct nvm_addr *(*nvm_lookup_ltop_fn)(struct nvm_stor *, sector_t);
+typedef struct nvm_addr *(*nvm_map_ltop_page_fn)(struct nvm_stor *, sector_t,
+						int);
+typedef struct nvm_block *(*nvm_map_ltop_block_fn)(struct nvm_stor *, sector_t,
+						int);
+typedef int (*nvm_write_rq_fn)(struct nvm_stor *, struct request *);
+typedef int (*nvm_read_rq_fn)(struct nvm_stor *, struct request *);
+typedef void (*nvm_alloc_phys_addr_fn)(struct nvm_stor *, struct nvm_block *);
+typedef struct nvm_block *(*nvm_pool_get_blk_fn)(struct nvm_pool *pool,
+						int is_gc);
+typedef void (*nvm_pool_put_blk_fn)(struct nvm_block *block);
+typedef int (*nvm_ioctl_fn)(struct nvm_stor *,
+					unsigned int cmd, unsigned long arg);
+typedef int (*nvm_init_fn)(struct nvm_stor *);
+typedef void (*nvm_exit_fn)(struct nvm_stor *);
+typedef void (*nvm_endio_fn)(struct nvm_stor *, struct request *,
+				struct per_rq_data *, unsigned long *delay);
+
+struct nvm_target_type {
+	const char *name;
+	unsigned int version[3];
+	unsigned int per_rq_size;
+
+	/* lookup functions */
+	nvm_lookup_ltop_fn lookup_ltop;
+
+	/* handling of request */
+	nvm_write_rq_fn write_rq;
+	nvm_read_rq_fn read_rq;
+	nvm_ioctl_fn ioctl;
+	nvm_endio_fn end_rq;
+
+	/* engine-specific overrides */
+	nvm_pool_get_blk_fn pool_get_blk;
+	nvm_pool_put_blk_fn pool_put_blk;
+	nvm_map_ltop_page_fn map_page;
+	nvm_map_ltop_block_fn map_block;
+
+	/* module specific init/teardown */
+	nvm_init_fn init;
+	nvm_exit_fn exit;
+
+	/* For lightnvm internal use */
+	struct list_head list;
+};
+
+struct kv_entry;
+
+struct nvmkv_tbl {
+	u8 bucket_len;
+	u64 tbl_len;
+	struct kv_entry *entries;
+	spinlock_t lock;
+};
+
+struct nvmkv_inflight {
+	struct kmem_cache *entry_pool;
+	spinlock_t lock;
+	struct list_head list;
+};
+
+struct nvmkv {
+	struct nvmkv_tbl tbl;
+	struct nvmkv_inflight inflight;
+};
+
+/* Main structure */
+struct nvm_stor {
+	struct nvm_dev *dev;
+	uint32_t sector_size;
+
+	struct nvm_target_type *type;
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
+	unsigned gran_blk;
+	unsigned gran_read;
+	unsigned gran_write;
+
+	/* Calculated/Cached values. These do not reflect the actual usuable
+	 * blocks at run-time. */
+	unsigned long nr_pages;
+	unsigned long total_blocks;
+
+	unsigned int next_collect_pool;
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
+
+	struct nvmkv kv;
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
+void nvm_gc_block(struct work_struct *);
+void nvm_gc_recycle_block(struct work_struct *);
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
+/* gc.c */
+void nvm_block_erase(struct kref *);
+void nvm_gc_cb(unsigned long data);
+void nvm_gc_collect(struct work_struct *work);
+void nvm_gc_kick(struct nvm_stor *s);
+
+/* targets.c */
+struct nvm_block *nvm_pool_get_block(struct nvm_pool *, int is_gc);
+
+/* nvmkv.c */
+int nvmkv_init(struct nvm_stor *s, unsigned long size);
+void nvmkv_exit(struct nvm_stor *s);
+int nvmkv_unpack(struct nvm_dev *dev, struct lightnvm_cmd_kv __user *ucmd);
+void nvm_pool_put_block(struct nvm_block *);
+
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
+	return &s->inflight_map[l_addr % NVM_INFLIGHT_PARTITIONS];
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
+/* TODO: make compatible with multi-block requests */
+static inline void __nvm_lock_laddr_range(struct nvm_stor *s, int spin,
+				sector_t laddr_start, unsigned nsectors)
+{
+	struct nvm_inflight *inflight;
+	struct nvm_inflight_request *r;
+	sector_t laddr_end = laddr_start + nsectors - 1;
+	int tag;
+	unsigned long flags;
+
+	NVM_ASSERT(nsectors >= 1);
+	BUG_ON(laddr_end >= s->nr_pages);
+	/* FIXME: Not yet supported */
+	BUG_ON(nsectors > s->nr_pages_per_blk);
+
+	inflight = nvm_laddr_to_inflight(s, laddr_start);
+	tag = percpu_ida_alloc(&s->free_inflight, __GFP_WAIT);
+
+retry:
+	spin_lock_irqsave(&inflight->lock, flags);
+
+	list_for_each_entry(r, &inflight->reqs, list) {
+		if (request_intersects(r, laddr_start, laddr_end)) {
+			/* existing, overlapping request, come back later */
+			spin_unlock_irqrestore(&inflight->lock, flags);
+			if (!spin)
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
+}
+
+static inline void nvm_lock_laddr_range(struct nvm_stor *s, sector_t laddr_start,
+					unsigned int nsectors)
+{
+	return __nvm_lock_laddr_range(s, 0, laddr_start, nsectors);
+}
+
+static inline void nvm_unlock_laddr_range(struct nvm_stor *s,
+					sector_t laddr_start,
+					unsigned int nsectors)
+{
+	struct nvm_inflight *inflight = nvm_laddr_to_inflight(s, laddr_start);
+	struct nvm_inflight_request *r = NULL;
+	sector_t laddr_end = laddr_start + nsectors - 1;
+	unsigned long flags;
+
+	NVM_ASSERT(nsectors >= 1);
+	NVM_ASSERT(laddr_end >= laddr_start);
+
+	spin_lock_irqsave(&inflight->lock, flags);
+	BUG_ON(list_empty(&inflight->reqs));
+
+	list_for_each_entry(r, &inflight->reqs, list)
+		if (request_equals(r, laddr_start, laddr_end))
+			break;
+
+	BUG_ON(!r || !request_equals(r, laddr_start, laddr_end));
+
+	r->l_start = r->l_end = LTOP_POISON;
+
+	list_del_init(&r->list);
+	spin_unlock_irqrestore(&inflight->lock, flags);
+	percpu_ida_free(&s->free_inflight, r->tag);
+}
+
+static inline void __show_pool(struct nvm_pool *pool)
+{
+	struct list_head *head, *cur;
+	unsigned int free_cnt = 0, used_cnt = 0, prio_cnt = 0;
+
+	NVM_ASSERT(spin_is_locked(&pool->lock));
+
+	list_for_each_safe(head, cur, &pool->free_list)
+		free_cnt++;
+	list_for_each_safe(head, cur, &pool->used_list)
+		used_cnt++;
+	list_for_each_safe(head, cur, &pool->prio_list)
+		prio_cnt++;
+
+	pr_err("lightnvm: P-%d F:%u U:%u P:%u",
+					pool->id, free_cnt, used_cnt, prio_cnt);
+}
+
+static inline void show_pool(struct nvm_pool *pool)
+{
+	spin_lock(&pool->lock);
+	__show_pool(pool);
+	spin_unlock(&pool->lock);
+}
+
+static inline void show_all_pools(struct nvm_stor *s)
+{
+	struct nvm_pool *pool;
+	unsigned int i;
+
+	nvm_for_each_pool(s, pool, i)
+		show_pool(pool);
+}
+
+#endif /* NVM_H_ */
+
diff --git a/drivers/lightnvm/sysfs.c b/drivers/lightnvm/sysfs.c
new file mode 100644
index 0000000..3abe1e4
--- /dev/null
+++ b/drivers/lightnvm/sysfs.c
@@ -0,0 +1,79 @@
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
+void nvm_remove_sysfs(struct nvm_dev *nvm)
+{
+	struct device *dev;
+
+	if (!nvm || !nvm->disk)
+		return;
+
+	dev = disk_to_dev(nvm->disk);
+	sysfs_remove_group(&dev->kobj, &nvm_attribute_group);
+}
+EXPORT_SYMBOL_GPL(nvm_remove_sysfs);
+
+int nvm_add_sysfs(struct nvm_dev *nvm)
+{
+	int ret;
+	struct device *dev;
+
+	if (!nvm || !nvm->disk)
+		return 0;
+
+	dev = disk_to_dev(nvm->disk);
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
index 0000000..016bf46
--- /dev/null
+++ b/drivers/lightnvm/targets.c
@@ -0,0 +1,246 @@
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
+		__show_pool(pool);
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
+						show_all_pools(ap->parent);
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
diff --git a/include/linux/lightnvm.h b/include/linux/lightnvm.h
new file mode 100644
index 0000000..d6d0a2c
--- /dev/null
+++ b/include/linux/lightnvm.h
@@ -0,0 +1,130 @@
+#ifndef LIGHTNVM_H
+#define LIGHTNVM_H
+
+#include <uapi/linux/lightnvm.h>
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
+struct nvm_id {
+	u16	ver_id;
+	u8	nvm_type;
+	u16	nchannels;
+	u8	reserved[11];
+};
+
+struct nvm_id_chnl {
+	u64	queue_size;
+	u64	gran_read;
+	u64	gran_write;
+	u64	gran_erase;
+	u64	oob_size;
+	u32	t_r;
+	u32	t_sqr;
+	u32	t_w;
+	u32	t_sqw;
+	u32	t_e;
+	u8	io_sched;
+	u64	laddr_begin;
+	u64	laddr_end;
+	u8	reserved[4034];
+};
+
+struct nvm_get_features {
+	u64	rsp[4];
+	u64	ext[4];
+};
+
+struct nvm_dev;
+
+typedef int (nvm_id_fn)(struct nvm_dev *dev, struct nvm_id *);
+typedef int (nvm_id_chnl_fn)(struct nvm_dev *dev, int chnl_num, struct nvm_id_chnl *);
+typedef int (nvm_get_features_fn)(struct nvm_dev *dev, struct nvm_get_features *);
+typedef int (nvm_set_rsp_fn)(struct nvm_dev *dev, u8 rsp, u8 val);
+typedef int (nvm_queue_rq_fn)(struct nvm_dev *, struct request *);
+typedef int (nvm_erase_blk_fn)(struct nvm_dev *, sector_t);
+
+struct lightnvm_dev_ops {
+	nvm_id_fn		*identify;
+	nvm_id_chnl_fn		*identify_channel;
+	nvm_get_features_fn 	*get_features;
+	nvm_set_rsp_fn		*set_responsibility;
+
+	/* Requests */
+	nvm_queue_rq_fn		*nvm_queue_rq;
+
+	/* LightNVM commands */
+	nvm_erase_blk_fn	*nvm_erase_block;
+};
+
+struct nvm_dev {
+	struct lightnvm_dev_ops *ops;
+
+	struct request_queue *q;
+	struct gendisk *disk;
+
+	unsigned int drv_cmd_size;
+
+	void *driver_data;
+	void *stor;
+};
+
+/* LightNVM configuration */
+unsigned int nvm_cmd_size(void);
+
+int nvm_init(struct gendisk *disk, struct nvm_dev *);
+void nvm_exit(struct nvm_dev *);
+struct nvm_dev *nvm_alloc(void);
+void nvm_free(struct nvm_dev *);
+
+int nvm_add_sysfs(struct nvm_dev *);
+void nvm_remove_sysfs(struct nvm_dev *);
+
+/* LightNVM blk-mq request management */
+int nvm_queue_rq(struct nvm_dev *, struct request *);
+void nvm_end_io(struct nvm_dev *, struct request *, int);
+void nvm_complete_request(struct nvm_dev *, struct request *);
+
+int nvm_ioctl(struct nvm_dev *dev, fmode_t mode, unsigned int cmd, unsigned long arg);
+int nvm_compat_ioctl(struct nvm_dev *dev, fmode_t mode, unsigned int cmd, unsigned long arg);
+
+#endif
diff --git a/include/uapi/linux/lightnvm.h b/include/uapi/linux/lightnvm.h
new file mode 100644
index 0000000..3e9051b
--- /dev/null
+++ b/include/uapi/linux/lightnvm.h
@@ -0,0 +1,45 @@
+/*
+ * Definitions for the LightNVM host interface
+ * Copyright (c) 2014, IT University of Copenhagen, Matias Bjorling.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _UAPI_LINUX_LIGHTNVM_H
+#define _UAPI_LINUX_LIGHTNVM_H
+
+#include <linux/types.h>
+
+enum {
+	LIGHTNVM_KV_GET		= 0x00,
+	LIGHTNVM_KV_PUT		= 0x01,
+	LIGHTNVM_KV_UPDATE	= 0x02,
+	LIGHTNVM_KV_DEL		= 0x03,
+};
+
+enum {
+	LIGHTNVM_KV_ERR_NONE	= 0,
+	LIGHTNVM_KV_ERR_NOKEY	= 1,
+};
+
+struct lightnvm_cmd_kv {
+	__u8		opcode;
+	__u8		errcode;
+	__u8		res[6];
+	__u32		key_len;
+	__u32		val_len;
+	__u64		key_addr;
+	__u64		val_addr;
+};
+
+#define LIGHTNVM_IOCTL_ID	_IO('O', 0x40)
+#define LIGHTNVM_IOCTL_KV	_IOWR('O', 0x50, struct lightnvm_cmd_kv)
+
+#endif /* _UAPI_LINUX_LIGHTNVM_H */
-- 
1.9.1

