Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbaCUGdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:33:25 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40743 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaCUGdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:33:11 -0400
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for open firmware SSDs
Date: Thu, 20 Mar 2014 23:32:18 -0700
Message-Id: <1395383538-18019-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395383538-18019-1-git-send-email-m@bjorling.me>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LightNVM implements the internal logic of an SSD within the host system.
This includes logic such as translation tables for logical to physical
address translation, garbage collection and wear-leveling.

It is designed to be used either standalone or with a LightNVM
compatible firmware. If used standalone, NVM memory can be simulated
by passing timings to the dm target table. If used with a LightNVM
compatible device, the device will be queued upon initialized for the
relevant values.

The last part is still in progress and a fully working prototype will be
presented in upcoming patches.

Contributions to make this possible by the following people:

Aviad Zuck <aviadzuc@tau.ac.il>
Jesper Madsen <jmad@itu.dk>

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 drivers/md/Kconfig             |   1 +
 drivers/md/Makefile            |   1 +
 drivers/md/lightnvm/Kconfig    |  14 +
 drivers/md/lightnvm/Makefile   |   1 +
 drivers/md/lightnvm/core.c     | 705 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/lightnvm/gc.c       | 208 ++++++++++++
 drivers/md/lightnvm/lightnvm.c | 589 ++++++++++++++++++++++++++++++++++
 drivers/md/lightnvm/lightnvm.h | 592 ++++++++++++++++++++++++++++++++++
 drivers/md/lightnvm/reg.c      |  41 +++
 9 files changed, 2152 insertions(+)
 create mode 100644 drivers/md/lightnvm/Kconfig
 create mode 100644 drivers/md/lightnvm/Makefile
 create mode 100644 drivers/md/lightnvm/core.c
 create mode 100644 drivers/md/lightnvm/gc.c
 create mode 100644 drivers/md/lightnvm/lightnvm.c
 create mode 100644 drivers/md/lightnvm/lightnvm.h
 create mode 100644 drivers/md/lightnvm/reg.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f2ccbc3..ffce728 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -175,6 +175,7 @@ config MD_FAULTY
 	  In unsure, say N.
 
 source "drivers/md/bcache/Kconfig"
+source "drivers/md/lightnvm/Kconfig"
 
 config BLK_DEV_DM
 	tristate "Device mapper support"
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 2acc43f..ee1d9d7 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_BCACHE)		+= bcache/
+obj-$(CONFIG_LIGHTNVM)		+= lightnvm/
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
diff --git a/drivers/md/lightnvm/Kconfig b/drivers/md/lightnvm/Kconfig
new file mode 100644
index 0000000..1f10554
--- /dev/null
+++ b/drivers/md/lightnvm/Kconfig
@@ -0,0 +1,14 @@
+config LIGHTNVM
+	tristate "LightNVM translation layer support (EXPERIMENTAL)"
+	depends on BLK_DEV_DM
+	---help---
+		A target that implements the internals of SSDs within the host.
+		The target can be used with LightNVM compatible device or as an
+		in-memory store. The device mapper is used together with a
+		"bare" firmware. It exposes direct access to the underlying NVM.
+
+		To compile this code as a module, choose M here: the module will
+		be called dm-lightnvm.
+
+		If unsure, say N.
+
diff --git a/drivers/md/lightnvm/Makefile b/drivers/md/lightnvm/Makefile
new file mode 100644
index 0000000..4fb03ba
--- /dev/null
+++ b/drivers/md/lightnvm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_LIGHTNVM)		+= lightnvm.o reg.o core.o gc.o
diff --git a/drivers/md/lightnvm/core.c b/drivers/md/lightnvm/core.c
new file mode 100644
index 0000000..113fde9
--- /dev/null
+++ b/drivers/md/lightnvm/core.c
@@ -0,0 +1,705 @@
+#include "lightnvm.h"
+
+/* alloc pbd, but also decorate it with bio */
+static struct per_bio_data *alloc_init_pbd(struct nvmd *nvmd, struct bio *bio)
+{
+	struct per_bio_data *pb = mempool_alloc(nvmd->per_bio_pool, GFP_NOIO);
+
+	if (!pb) {
+		DMERR("Couldn't allocate per_bio_data");
+		return NULL;
+	}
+
+	pb->bi_end_io = bio->bi_end_io;
+	pb->bi_private = bio->bi_private;
+
+	bio->bi_private = pb;
+
+	return pb;
+}
+
+static void free_pbd(struct nvmd *nvmd, struct per_bio_data *pb)
+{
+	mempool_free(pb, nvmd->per_bio_pool);
+}
+
+/* bio to be stripped from the pbd structure */
+static void exit_pbd(struct per_bio_data *pb, struct bio *bio)
+{
+	bio->bi_private = pb->bi_private;
+	bio->bi_end_io = pb->bi_end_io;
+}
+
+/* deferred bios are used when no available nvm pages. Allowing GC to execute
+ * and resubmit bios */
+void nvm_defer_bio(struct nvmd *nvmd, struct bio *bio, void *private)
+{
+	spin_lock(&nvmd->deferred_lock);
+	bio_list_add(&nvmd->deferred_bios, bio);
+	spin_unlock(&nvmd->deferred_lock);
+}
+
+void nvm_deferred_bio_submit(struct work_struct *work)
+{
+	struct nvmd *nvmd = container_of(work, struct nvmd, deferred_ws);
+	struct bio *bio;
+
+	spin_lock(&nvmd->deferred_lock);
+	bio = bio_list_get(&nvmd->deferred_bios);
+	spin_unlock(&nvmd->deferred_lock);
+
+	while (bio) {
+		struct bio *next = bio->bi_next;
+		bio->bi_next = NULL;
+		if (bio_data_dir(bio) == WRITE)
+			nvmd->type->write_bio(nvmd, bio);
+		else
+			nvmd->type->read_bio(nvmd, bio);
+		bio = next;
+	}
+}
+
+/* delayed bios are used for making pool accesses sequential */
+void nvm_delayed_bio_submit(struct work_struct *work)
+{
+	struct nvm_pool *pool = container_of(work, struct nvm_pool, waiting_ws);
+	struct bio *bio;
+	struct per_bio_data *pb;
+
+	spin_lock(&pool->waiting_lock);
+	bio = bio_list_pop(&pool->waiting_bios);
+
+	pool->cur_bio = bio;
+	if (!bio) {
+		atomic_dec(&pool->is_active);
+		spin_unlock(&pool->waiting_lock);
+		return;
+	}
+
+	spin_unlock(&pool->waiting_lock);
+
+	/* setup timings to track end timings accordently */
+	pb = bio->bi_private;
+	getnstimeofday(&pb->start_tv);
+
+	submit_bio(bio->bi_rw, bio);
+}
+
+/* requires lock on the translation map used */
+void invalidate_block_page(struct nvmd *nvmd, struct nvm_addr *p)
+{
+	unsigned int page_offset;
+	struct nvm_block *block = p->block;
+
+	page_offset = p->addr % nvmd->nr_host_pages_in_blk;
+	spin_lock(&block->lock);
+	WARN_ON(test_and_set_bit(page_offset, block->invalid_pages));
+	block->nr_invalid_pages++;
+	spin_unlock(&block->lock);
+}
+
+void nvm_update_map(struct nvmd *nvmd, sector_t l_addr, struct nvm_addr *p,
+					int is_gc, struct nvm_addr *trans_map)
+{
+	struct nvm_addr *gp;
+	struct nvm_rev_addr *rev;
+
+	BUG_ON(l_addr >= nvmd->nr_pages);
+	BUG_ON(p->addr >= nvmd->nr_pages);
+
+	gp = &trans_map[l_addr];
+	spin_lock(&nvmd->rev_lock);
+	if (gp->block) {
+		invalidate_block_page(nvmd, gp);
+		nvmd->rev_trans_map[gp->addr].addr = LTOP_POISON;
+	}
+
+	gp->addr = p->addr;
+	gp->block = p->block;
+
+	rev = &nvmd->rev_trans_map[p->addr];
+	rev->addr = l_addr;
+	rev->trans_map = trans_map;
+	spin_unlock(&nvmd->rev_lock);
+}
+
+/* requires pool->lock taken */
+inline void nvm_reset_block(struct nvm_block *block)
+{
+	struct nvmd *nvmd = block->pool->nvmd;
+
+	BUG_ON(!block);
+
+	spin_lock(&block->lock);
+	bitmap_zero(block->invalid_pages, nvmd->nr_host_pages_in_blk);
+	block->ap = NULL;
+	block->next_page = 0;
+	block->next_offset = 0;
+	block->nr_invalid_pages = 0;
+	atomic_set(&block->gc_running, 0);
+	atomic_set(&block->data_size, 0);
+	atomic_set(&block->data_cmnt_size, 0);
+	spin_unlock(&block->lock);
+}
+
+/* use pool_[get/put]_block to administer the blocks in use for each pool.
+ * Whenever a block is in used by an append point, we store it within the
+ * used_list. We then move it back when its free to be used by another append
+ * point.
+ *
+ * The newly acclaimed block is always added to the back of user_list. As we
+ * assume that the start of used list is the oldest block, and therefore higher
+ * probability of invalidated pages.
+ */
+struct nvm_block *nvm_pool_get_block(struct nvm_pool *pool, int is_gc)
+{
+	struct nvmd *nvmd = pool->nvmd;
+	struct nvm_block *block = NULL;
+
+	BUG_ON(!pool);
+
+	spin_lock(&pool->lock);
+
+	if (list_empty(&pool->free_list)) {
+		DMERR_LIMIT("Pool have no free pages available");
+		spin_unlock(&pool->lock);
+		show_pool(pool);
+		return NULL;
+	}
+
+	while (!is_gc && pool->nr_free_blocks < nvmd->nr_aps) {
+		spin_unlock(&pool->lock);
+		return NULL;
+	}
+
+	block = list_first_entry(&pool->free_list, struct nvm_block, list);
+	list_move_tail(&block->list, &pool->used_list);
+
+	pool->nr_free_blocks--;
+
+	spin_unlock(&pool->lock);
+
+	nvm_reset_block(block);
+
+	block->data = mempool_alloc(nvmd->block_page_pool, GFP_ATOMIC);
+	BUG_ON(!block->data);
+
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
+
+	spin_lock(&pool->lock);
+
+	list_move_tail(&block->list, &pool->free_list);
+	pool->nr_free_blocks++;
+
+	spin_unlock(&pool->lock);
+}
+
+static sector_t __nvm_alloc_phys_addr(struct nvm_block *block,
+							nvm_page_special_fn ps)
+{
+	struct nvmd *nvmd;
+	sector_t addr = LTOP_EMPTY;
+
+	BUG_ON(!block);
+
+	nvmd = block->pool->nvmd;
+
+	spin_lock(&block->lock);
+
+	if (block_is_full(block))
+		goto out;
+
+	/* If there is multiple host pages within a flash page, we add the
+	 * the offset to the address, instead of requesting a new page
+	 * from the physical block */
+	if (block->next_offset == NR_HOST_PAGES_IN_FLASH_PAGE) {
+		if (ps && !ps(nvmd, block->next_page + 1))
+			goto out;
+
+		block->next_offset = 0;
+		block->next_page++;
+	}
+
+	addr = block_to_addr(block) +
+			(block->next_page * NR_HOST_PAGES_IN_FLASH_PAGE) +
+			block->next_offset;
+	block->next_offset++;
+
+	if (nvmd->type->alloc_phys_addr)
+		nvmd->type->alloc_phys_addr(nvmd, block);
+
+out:
+	spin_unlock(&block->lock);
+	return addr;
+}
+
+sector_t nvm_alloc_phys_addr_special(struct nvm_block *block,
+						nvm_page_special_fn ps)
+{
+	return __nvm_alloc_phys_addr(block, ps);
+}
+
+sector_t nvm_alloc_phys_addr(struct nvm_block *block)
+{
+	return __nvm_alloc_phys_addr(block, NULL);
+}
+
+/* requires ap->lock taken */
+void nvm_set_ap_cur(struct nvm_ap *ap, struct nvm_block *block)
+{
+	BUG_ON(!ap);
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
+/* requires ap->lock held */
+struct nvm_addr *nvm_alloc_addr_from_ap(struct nvm_ap *ap, int is_gc)
+{
+	struct nvmd *nvmd = ap->parent;
+	struct nvm_block *p_block;
+	struct nvm_pool *pool;
+	struct nvm_addr *p;
+	sector_t p_addr;
+
+	p = mempool_alloc(nvmd->addr_pool, GFP_ATOMIC);
+	if (!p)
+		return NULL;
+
+	p_block = ap->cur;
+	pool = p_block->pool;
+	p_addr = nvm_alloc_phys_addr(p_block);
+
+	if (p_addr == LTOP_EMPTY) {
+		p_block = nvm_pool_get_block(pool, 0);
+
+		if (!p_block) {
+			if (is_gc) {
+				p_addr = nvm_alloc_phys_addr(ap->gc_cur);
+				if (p_addr == LTOP_EMPTY) {
+					p_block = nvm_pool_get_block(pool, 1);
+					ap->gc_cur = p_block;
+					ap->gc_cur->ap = ap;
+					if (!p_block) {
+						show_all_pools(ap->parent);
+						DMERR("No more blocks");
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
+		mempool_free(p, nvmd->addr_pool);
+		return NULL;
+	}
+
+	p->addr = p_addr;
+	p->block = p_block;
+	p->private = NULL;
+
+	if (!p_block)
+		WARN_ON(is_gc);
+
+	return p;
+}
+
+void nvm_erase_block(struct nvm_block *block)
+{
+	/* Send erase command to device. */
+}
+
+static void nvm_fill_bio_and_end(struct bio *bio)
+{
+	zero_fill_bio(bio);
+	bio_endio(bio, 0);
+}
+
+struct nvm_addr *nvm_lookup_ltop_map(struct nvmd *nvmd, sector_t l_addr,
+				     struct nvm_addr *map, void *private)
+{
+	struct nvm_addr *gp, *p;
+
+	BUG_ON(!(l_addr >= 0 && l_addr < nvmd->nr_pages));
+
+	p = mempool_alloc(nvmd->addr_pool, GFP_ATOMIC);
+	if (!p)
+		return NULL;
+
+	gp = &map[l_addr];
+
+	p->addr = gp->addr;
+	p->block = gp->block;
+
+	/* if it has not been written, p is inited to 0. */
+	if (p->block) {
+		/* during gc, the mapping will be updated accordently. We
+		 * therefore stop submitting new reads to the address, until it
+		 * is copied to the new place. */
+		if (atomic_read(&p->block->gc_running))
+			goto err;
+	}
+
+	p->private = private;
+
+	return p;
+err:
+	mempool_free(p, nvmd->addr_pool);
+	return NULL;
+
+}
+
+/* lookup the primary translation table. If there isn't an associated block to
+ * the addr. We assume that there is no data and doesn't take a ref */
+struct nvm_addr *nvm_lookup_ltop(struct nvmd *nvmd, sector_t l_addr)
+{
+	return nvm_lookup_ltop_map(nvmd, l_addr, nvmd->trans_map, NULL);
+}
+
+/* Simple round-robin Logical to physical address translation.
+ *
+ * Retrieve the mapping using the active append point. Then update the ap for
+ * the next write to the disk.
+ *
+ * Returns nvm_addr with the physical address and block. Remember to return to
+ * nvmd->addr_cache when bio is finished.
+ */
+struct nvm_addr *nvm_map_ltop_rr(struct nvmd *nvmd, sector_t l_addr, int is_gc,
+				 struct nvm_addr *trans_map, void *private)
+{
+	struct nvm_ap *ap;
+	struct nvm_addr *p;
+	int i = 0;
+
+
+	if (!is_gc) {
+		ap = get_next_ap(nvmd);
+	} else {
+		/* during GC, we don't care about RR, instead we want to make
+		 * sure that we maintain evenness between the block pools. */
+		unsigned int i;
+		struct nvm_pool *pool, *max_free;
+
+		max_free = &nvmd->pools[0];
+		/* prevent GC-ing pool from devouring pages of a pool with
+		 * little free blocks. We don't take the lock as we only need an
+		 * estimate. */
+		nvm_for_each_pool(nvmd, pool, i) {
+			if (pool->nr_free_blocks > max_free->nr_free_blocks)
+				max_free = pool;
+		}
+
+		ap = &nvmd->aps[max_free->id];
+	}
+
+	spin_lock(&ap->lock);
+	p = nvm_alloc_addr_from_ap(ap, is_gc);
+	spin_unlock(&ap->lock);
+
+	if (p)
+		nvm_update_map(nvmd, l_addr, p, is_gc, trans_map);
+
+	return p;
+}
+
+static void nvm_endio(struct bio *bio, int err)
+{
+	struct per_bio_data *pb;
+	struct nvmd *nvmd;
+	struct nvm_ap *ap;
+	struct nvm_pool *pool;
+	struct nvm_addr *p;
+	struct nvm_block *block;
+	struct timespec end_tv, diff_tv;
+	unsigned long diff, dev_wait, total_wait = 0;
+	unsigned int data_cnt;
+
+	pb = get_per_bio_data(bio);
+	p = pb->addr;
+	block = p->block;
+	ap = pb->ap;
+	nvmd = ap->parent;
+	pool = ap->pool;
+
+	nvm_unlock_addr(nvmd, pb->l_addr);
+
+	if (bio_data_dir(bio) == WRITE) {
+		/* maintain data in buffer until block is full */
+		data_cnt = atomic_inc_return(&block->data_cmnt_size);
+		if (data_cnt == nvmd->nr_host_pages_in_blk) {
+			mempool_free(block->data, nvmd->block_page_pool);
+			block->data = NULL;
+
+			spin_lock(&pool->lock);
+			list_add_tail(&block->prio, &pool->prio_list);
+			spin_unlock(&pool->lock);
+		}
+
+		/* physical waits if hardware doesn't have a real backend */
+		dev_wait = ap->t_write;
+	} else {
+		dev_wait = ap->t_read;
+	}
+
+
+	if (nvmd->type->endio)
+		nvmd->type->endio(nvmd, bio, pb, &dev_wait);
+
+	if (!(nvmd->config.flags & NVM_OPT_NO_WAITS) && dev_wait) {
+wait_longer:
+		getnstimeofday(&end_tv);
+		diff_tv = timespec_sub(end_tv, pb->start_tv);
+		diff = timespec_to_ns(&diff_tv) / 1000;
+		if (dev_wait > diff) {
+			total_wait = dev_wait - diff;
+			WARN_ON(total_wait > 1500);
+			if (total_wait > 10)
+				udelay(5);
+			goto wait_longer;
+		}
+	}
+
+	if (nvmd->config.flags & NVM_OPT_POOL_SERIALIZE) {
+		/* we need this. updating pool current only by waiting_bios
+		 * worker leaves a windows where current is bio thats was
+		 * already ended */
+		spin_lock(&pool->waiting_lock);
+		pool->cur_bio = NULL;
+		spin_unlock(&pool->waiting_lock);
+
+		queue_work(nvmd->kbiod_wq, &pool->waiting_ws);
+	}
+
+	/* Finish up */
+	exit_pbd(pb, bio);
+
+	if (bio->bi_end_io)
+		bio->bi_end_io(bio, err);
+
+	if (pb->orig_bio)
+		bio_endio(pb->orig_bio, err);
+
+	if (pb->event) {
+		complete(pb->event);
+		/* all submitted bios allocate their own addr,
+		 * except GC reads */
+		if (bio_data_dir(bio) == READ)
+			goto free_pb;
+	}
+
+	mempool_free(pb->addr, nvmd->addr_pool);
+free_pb:
+	free_pbd(nvmd, pb);
+}
+
+static void nvm_end_read_bio(struct bio *bio, int err)
+{
+	/* FIXME: Implement error handling of reads
+	 * Remember that bio->bi_end_io is overwritten during bio_split()
+	 */
+	nvm_endio(bio, err);
+}
+
+static void nvm_end_write_bio(struct bio *bio, int err)
+{
+	/* FIXME: Implement error handling of writes */
+	nvm_endio(bio, err);
+
+	/* separate bio is allocated on write. Remember to free it */
+	bio_put(bio);
+}
+
+int nvm_read_bio(struct nvmd *nvmd, struct bio *bio)
+{
+	struct nvm_addr *p;
+	sector_t l_addr;
+
+	l_addr = bio->bi_sector / NR_PHY_IN_LOG;
+
+	nvm_lock_addr(nvmd, l_addr);
+
+	p = nvmd->type->lookup_ltop(nvmd, l_addr);
+
+	if (!p) {
+		nvm_unlock_addr(nvmd, l_addr);
+		nvm_defer_bio(nvmd, bio, NULL);
+		nvm_gc_kick(nvmd);
+		goto finished;
+	}
+
+	bio->bi_sector = p->addr * NR_PHY_IN_LOG +
+					(bio->bi_sector % NR_PHY_IN_LOG);
+
+	if (!p->block) {
+		bio->bi_sector = 0;
+		nvm_fill_bio_and_end(bio);
+		mempool_free(p, nvmd->addr_pool);
+		nvm_unlock_addr(nvmd, l_addr);
+		goto finished;
+	}
+
+	nvm_submit_bio(nvmd, p, l_addr, READ, bio, NULL, NULL, nvmd->trans_map);
+finished:
+	return DM_MAPIO_SUBMITTED;
+}
+
+int nvm_bv_copy(struct nvm_addr *p, struct bio_vec *bv)
+{
+	struct nvmd *nvmd = p->block->pool->nvmd;
+	struct nvm_block *block = p->block;
+	unsigned int idx;
+	void *src_p, *dst_p;
+
+	idx = p->addr % nvmd->nr_host_pages_in_blk;
+	src_p = kmap_atomic(bv->bv_page);
+	dst_p = kmap_atomic(&block->data[idx]);
+	memcpy(dst_p, src_p, bv->bv_len);
+
+	kunmap_atomic(dst_p);
+	kunmap_atomic(src_p);
+
+	return atomic_inc_return(&block->data_size);
+}
+
+struct bio *nvm_write_init_bio(struct nvmd *nvmd, struct bio *bio,
+						struct nvm_addr *p)
+{
+	struct bio *issue_bio;
+	int i, size;
+
+	/* FIXME: check for failure */
+	issue_bio = bio_alloc(GFP_NOIO, NR_HOST_PAGES_IN_FLASH_PAGE);
+	issue_bio->bi_bdev = nvmd->dev->bdev;
+	issue_bio->bi_sector = p->addr * NR_PHY_IN_LOG;
+
+	size = nvm_bv_copy(p, bio_iovec(bio));
+	for (i = 0; i < NR_HOST_PAGES_IN_FLASH_PAGE; i++) {
+		unsigned int idx = size - NR_HOST_PAGES_IN_FLASH_PAGE + i;
+		bio_add_page(issue_bio, &p->block->data[idx], PAGE_SIZE, 0);
+	}
+	return issue_bio;
+}
+
+/* Assumes that l_addr is locked with nvm_lock_addr() */
+int nvm_write_bio(struct nvmd *nvmd,
+		  struct bio *bio, int is_gc,
+		  void *private, struct completion *sync,
+		  struct nvm_addr *trans_map, unsigned int complete_bio)
+{
+	struct nvm_addr *p;
+	struct bio *issue_bio;
+	sector_t l_addr = bio->bi_sector / NR_PHY_IN_LOG;
+
+	p = nvmd->type->map_ltop(nvmd, l_addr, is_gc, trans_map, private);
+	if (!p) {
+		BUG_ON(is_gc);
+		nvm_unlock_addr(nvmd, l_addr);
+		nvmd->type->defer_bio(nvmd, bio, trans_map);
+		nvm_gc_kick(nvmd);
+
+		return NVM_WRITE_DEFERRED;
+	}
+
+	issue_bio = nvm_write_init_bio(nvmd, bio, p);
+	if (complete_bio)
+		nvm_submit_bio(nvmd, p, l_addr, WRITE, issue_bio, bio, sync,
+								trans_map);
+	else
+		nvm_submit_bio(nvmd, p, l_addr, WRITE, issue_bio, NULL, sync,
+								trans_map);
+
+	return NVM_WRITE_SUCCESS;
+}
+
+void nvm_bio_wait_add(struct bio_list *bl, struct bio *bio, void *p_private)
+{
+	bio_list_add(bl, bio);
+}
+
+/* remember to lock l_addr before calling nvm_submit_bio */
+void nvm_submit_bio(struct nvmd *nvmd, struct nvm_addr *p, sector_t l_addr,
+			int rw, struct bio *bio,
+			struct bio *orig_bio,
+			struct completion *sync,
+			struct nvm_addr *trans_map)
+{
+	struct nvm_block *block = p->block;
+	struct nvm_ap *ap = block_to_ap(nvmd, block);
+	struct nvm_pool *pool = ap->pool;
+	struct per_bio_data *pb;
+
+	pb = alloc_init_pbd(nvmd, bio);
+	pb->ap = ap;
+	pb->addr = p;
+	pb->l_addr = l_addr;
+	pb->event = sync;
+	pb->orig_bio = orig_bio;
+	pb->trans_map = trans_map;
+
+	/* is set prematurely because we need it if bio is defered */
+	bio->bi_rw |= rw;
+	if (sync)
+		bio->bi_rw |= REQ_SYNC;
+
+	if (rw == WRITE)
+		bio->bi_end_io = nvm_end_write_bio;
+	else
+		bio->bi_end_io = nvm_end_read_bio;
+
+	/* We allow counting to be semi-accurate as theres
+	 * no lock for accounting. */
+	ap->io_accesses[bio_data_dir(bio)]++;
+
+	if (nvmd->config.flags & NVM_OPT_POOL_SERIALIZE) {
+		spin_lock(&pool->waiting_lock);
+		nvmd->type->bio_wait_add(&pool->waiting_bios, bio, p->private);
+
+		if (atomic_inc_return(&pool->is_active) != 1) {
+			atomic_dec(&pool->is_active);
+			spin_unlock(&pool->waiting_lock);
+			return;
+		}
+
+		bio = bio_list_peek(&pool->waiting_bios);
+
+		/* we're not the only bio waiting */
+		if (!bio) {
+			atomic_dec(&pool->is_active);
+			spin_unlock(&pool->waiting_lock);
+			return;
+		}
+
+		/* we're the only bio waiting. queue relevant worker*/
+		queue_work(nvmd->kbiod_wq, &pool->waiting_ws);
+		spin_unlock(&pool->waiting_lock);
+		return;
+	}
+
+	submit_bio(bio->bi_rw, bio);
+}
diff --git a/drivers/md/lightnvm/gc.c b/drivers/md/lightnvm/gc.c
new file mode 100644
index 0000000..04294be
--- /dev/null
+++ b/drivers/md/lightnvm/gc.c
@@ -0,0 +1,208 @@
+#include "lightnvm.h"
+
+/* Run only GC if less than 1/X blocks are free */
+#define GC_LIMIT_INVERSE 10
+
+static void queue_pool_gc(struct nvm_pool *pool)
+{
+	struct nvmd *nvmd = pool->nvmd;
+	queue_work(nvmd->kbiod_wq, &pool->gc_ws);
+}
+
+void nvm_gc_cb(unsigned long data)
+{
+	struct nvmd *nvmd = (struct nvmd *)data;
+	struct nvm_pool *pool;
+	int i;
+
+	nvm_for_each_pool(nvmd, pool, i)
+		queue_pool_gc(pool);
+
+	mod_timer(&nvmd->gc_timer,
+			jiffies + msecs_to_jiffies(nvmd->config.gc_time));
+}
+
+static void __erase_block(struct nvm_block *block)
+{
+	/* TODO: Perform device flash erase */
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
+static void nvm_move_valid_pages(struct nvmd *nvmd, struct nvm_block *block)
+{
+	struct nvm_addr src;
+	struct nvm_rev_addr *rev;
+	struct bio *src_bio;
+	struct page *page;
+	int slot;
+	DECLARE_COMPLETION(sync);
+
+	if (bitmap_full(block->invalid_pages, nvmd->nr_host_pages_in_blk))
+		return;
+
+	while ((slot = find_first_zero_bit(block->invalid_pages,
+					   nvmd->nr_host_pages_in_blk)) <
+						nvmd->nr_host_pages_in_blk) {
+		/* Perform read */
+		src.addr = block_to_addr(block) + slot;
+		src.block = block;
+
+		BUG_ON(src.addr >= nvmd->nr_pages);
+
+		/* TODO: check for memory failure */
+		src_bio = bio_alloc(GFP_NOIO, 1);
+		src_bio->bi_bdev = nvmd->dev->bdev;
+		src_bio->bi_sector = src.addr * NR_PHY_IN_LOG;
+
+		page = mempool_alloc(nvmd->page_pool, GFP_NOIO);
+
+		/* TODO: may fail with EXP_PG_SIZE > PAGE_SIZE */
+		bio_add_page(src_bio, page, EXPOSED_PAGE_SIZE, 0);
+
+		/* We take the reverse lock here, and make sure that we only
+		 * release it when we have locked its logical address. If
+		 * another write on the same logical address is
+		 * occuring, we just let it stall the pipeline.
+		 *
+		 * We do this for both the read and write. Fixing it after each
+		 * IO.
+		 */
+		spin_lock(&nvmd->rev_lock);
+		/* We use the physical address to go to the logical page addr,
+		 * and then update its mapping to its new place. */
+		rev = &nvmd->rev_trans_map[src.addr];
+
+		/* already updated by previous regular write */
+		if (rev->addr == LTOP_POISON) {
+			spin_unlock(&nvmd->rev_lock);
+			goto overwritten;
+		}
+
+		/* unlocked by nvm_submit_bio nvm_endio */
+		__nvm_lock_addr(nvmd, rev->addr, 1);
+		spin_unlock(&nvmd->rev_lock);
+
+		init_completion(&sync);
+		nvm_submit_bio(nvmd, &src, rev->addr, READ, src_bio, NULL,
+							&sync, rev->trans_map);
+		wait_for_completion(&sync);
+
+		/* ok, now fix the write and make sure that it haven't been
+		 * moved in the meantime. */
+		spin_lock(&nvmd->rev_lock);
+
+		/* already updated by previous regular write */
+		if (rev->addr == LTOP_POISON) {
+			spin_unlock(&nvmd->rev_lock);
+			goto overwritten;
+		}
+
+		src_bio->bi_sector = rev->addr * NR_PHY_IN_LOG;
+
+		/* again, unlocked by nvm_endio */
+		__nvm_lock_addr(nvmd, rev->addr, 1);
+		spin_unlock(&nvmd->rev_lock);
+
+		init_completion(&sync);
+		nvm_write_bio(nvmd, src_bio, 1, NULL, &sync,
+							rev->trans_map, 1);
+		wait_for_completion(&sync);
+
+overwritten:
+		bio_put(src_bio);
+		mempool_free(page, nvmd->page_pool);
+	}
+	WARN_ON(!bitmap_full(block->invalid_pages, nvmd->nr_host_pages_in_blk));
+}
+
+void nvm_gc_collect(struct work_struct *work)
+{
+	struct nvm_pool *pool = container_of(work, struct nvm_pool, gc_ws);
+	struct nvmd *nvmd = pool->nvmd;
+	struct nvm_block *block;
+	unsigned int nr_blocks_need;
+
+	nr_blocks_need = pool->nr_blocks / 10;
+
+	if (nr_blocks_need < nvmd->nr_aps)
+		nr_blocks_need = nvmd->nr_aps;
+
+	spin_lock(&pool->lock);
+	while (nr_blocks_need > pool->nr_free_blocks &&
+						!list_empty(&pool->prio_list)) {
+		block = block_prio_find_max(pool);
+
+		if (!block->nr_invalid_pages) {
+			spin_unlock(&pool->lock);
+			show_pool(pool);
+			spin_lock(&pool->lock);
+			DMERR("No invalid pages\n");
+			break;
+		}
+
+		list_del_init(&block->prio);
+
+		BUG_ON(!block_is_full(block));
+		BUG_ON(atomic_inc_return(&block->gc_running) != 1);
+
+		queue_work(nvmd->kgc_wq, &block->ws_gc);
+
+		nr_blocks_need--;
+	}
+	spin_unlock(&pool->lock);
+	nvmd->next_collect_pool++;
+
+	queue_work(nvmd->kbiod_wq, &nvmd->deferred_ws);
+}
+
+void nvm_gc_block(struct work_struct *work)
+{
+	struct nvm_block *block = container_of(work, struct nvm_block, ws_gc);
+	struct nvmd *nvmd = block->pool->nvmd;
+
+	/* TODO: move outside lock to allow multiple pages
+	 * in parallel to be erased. */
+	nvm_move_valid_pages(nvmd, block);
+	__erase_block(block);
+	nvm_pool_put_block(block);
+}
+
+void nvm_gc_kick(struct nvmd *nvmd)
+{
+	struct nvm_pool *pool;
+	unsigned int i;
+	BUG_ON(!nvmd);
+
+	nvm_for_each_pool(nvmd, pool, i)
+		queue_pool_gc(pool);
+}
diff --git a/drivers/md/lightnvm/lightnvm.c b/drivers/md/lightnvm/lightnvm.c
new file mode 100644
index 0000000..a6d919b
--- /dev/null
+++ b/drivers/md/lightnvm/lightnvm.c
@@ -0,0 +1,589 @@
+/*
+ * Copyright (C) 2014 Matias BjÃ¸rling.
+ *
+ * Todo
+ *
+ * - Implement fetching of bad pages from flash
+ * - configurable sector size
+ * - handle case of in-page bv_offset (currently hidden assumption of offset=0,
+ *   and bv_len spans entire page)
+ *
+ * Optimization possibilities
+ * - Move ap_next_write into a conconcurrency friendly data structure. Could be
+ *   handled by more intelligent map_ltop function.
+ * - Implement per-cpu nvm_block data structure ownership. Removes need
+ *   for taking lock on block next_write_id function. I.e. page allocation
+ *   becomes nearly lockless, with occasionally movement of blocks on
+ *   nvm_block lists.
+ */
+
+#include "lightnvm.h"
+
+/* Defaults
+ * Number of append points per pool. We assume that accesses within a pool is
+ * serial (NAND flash/PCM/etc.)
+ */
+#define APS_PER_POOL 1
+
+/* If enabled, we delay bios on each ap to run serialized. */
+#define SERIALIZE_POOL_ACCESS 0
+
+/* Sleep timings before simulating device specific storage (in us) */
+#define TIMING_READ 25
+#define TIMING_WRITE 500
+#define TIMING_ERASE 1500
+
+/* Run GC every X seconds */
+#define GC_TIME 10
+
+/* Minimum pages needed within a pool */
+#define MIN_POOL_PAGES 16
+
+static struct kmem_cache *_per_bio_cache;
+static struct kmem_cache *_addr_cache;
+
+static int nvm_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long arg)
+{
+	struct nvmd *nvmd = ti->private;
+
+	switch (cmd) {
+	case LIGHTNVM_IOCTL_ID:
+		return 0xCECECECE; /* TODO: Fetch ID from disk */
+		break;
+	}
+
+	if (nvmd->type->ioctl)
+		return nvmd->type->ioctl(nvmd, cmd, arg);
+
+	return 0;
+}
+
+static int nvm_map(struct dm_target *ti, struct bio *bio)
+{
+	struct nvmd *nvmd = ti->private;
+	int ret = DM_MAPIO_SUBMITTED;
+
+	if (bio->bi_sector / NR_PHY_IN_LOG >= nvmd->nr_pages) {
+		DMERR("Illegal nvm address: %lu %ld", bio_data_dir(bio),
+						bio->bi_sector / NR_PHY_IN_LOG);
+		bio_io_error(bio);
+		return ret;
+	};
+
+	bio->bi_bdev = nvmd->dev->bdev;
+
+	/* limited currently to 4k write IOs */
+	if (bio_data_dir(bio) == WRITE) {
+		if (bio_sectors(bio) != NR_PHY_IN_LOG) {
+			DMERR("Write sectors size not supported (%u)",
+							bio_sectors(bio));
+			bio_io_error(bio);
+			return ret;
+		}
+		ret = nvmd->type->write_bio(nvmd, bio);
+	} else {
+		ret = nvmd->type->read_bio(nvmd, bio);
+	}
+
+	return ret;
+}
+
+static void nvm_status(struct dm_target *ti, status_type_t type,
+			unsigned status_flags, char *result, unsigned maxlen)
+{
+	struct nvmd *nvmd = ti->private;
+	struct nvm_ap *ap;
+	int i, sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("Use table information");
+		break;
+	case STATUSTYPE_TABLE:
+		nvm_for_each_ap(nvmd, ap, i) {
+			DMEMIT("Reads: %lu Writes: %lu Delayed: %lu",
+				ap->io_accesses[0],
+				ap->io_accesses[1],
+				ap->io_delayed);
+		}
+		break;
+	}
+}
+
+static int nvm_pool_init(struct nvmd *nvmd, struct dm_target *ti)
+{
+	struct nvm_pool *pool;
+	struct nvm_block *block;
+	struct nvm_ap *ap;
+	int i, j;
+
+	spin_lock_init(&nvmd->deferred_lock);
+	spin_lock_init(&nvmd->rev_lock);
+	INIT_WORK(&nvmd->deferred_ws, nvm_deferred_bio_submit);
+	bio_list_init(&nvmd->deferred_bios);
+
+	nvmd->pools = kzalloc(sizeof(struct nvm_pool) * nvmd->nr_pools,
+								GFP_KERNEL);
+	if (!nvmd->pools)
+		goto err_pool;
+
+	nvm_for_each_pool(nvmd, pool, i) {
+		spin_lock_init(&pool->lock);
+		spin_lock_init(&pool->waiting_lock);
+
+		init_completion(&pool->gc_finished);
+
+		INIT_WORK(&pool->gc_ws, nvm_gc_collect);
+		INIT_WORK(&pool->waiting_ws, nvm_delayed_bio_submit);
+
+		INIT_LIST_HEAD(&pool->free_list);
+		INIT_LIST_HEAD(&pool->used_list);
+		INIT_LIST_HEAD(&pool->prio_list);
+
+		pool->id = i;
+		pool->nvmd = nvmd;
+		pool->phy_addr_start = i * nvmd->nr_blks_per_pool;
+		pool->phy_addr_end = (i + 1) * nvmd->nr_blks_per_pool - 1;
+		pool->nr_free_blocks = pool->nr_blocks =
+				pool->phy_addr_end - pool->phy_addr_start + 1;
+		bio_list_init(&pool->waiting_bios);
+		atomic_set(&pool->is_active, 0);
+
+		pool->blocks = kzalloc(sizeof(struct nvm_block) *
+						pool->nr_blocks, GFP_KERNEL);
+		if (!pool->blocks)
+			goto err_blocks;
+
+		spin_lock(&pool->lock);
+		pool_for_each_block(pool, block, j) {
+			spin_lock_init(&block->lock);
+			atomic_set(&block->gc_running, 0);
+			INIT_LIST_HEAD(&block->list);
+			INIT_LIST_HEAD(&block->prio);
+
+			block->pool = pool;
+			block->id = (i * nvmd->nr_blks_per_pool) + j;
+
+			list_add_tail(&block->list, &pool->free_list);
+			INIT_WORK(&block->ws_gc, nvm_gc_block);
+		}
+		spin_unlock(&pool->lock);
+}
+
+	nvmd->nr_aps = nvmd->nr_aps_per_pool * nvmd->nr_pools;
+	nvmd->aps = kzalloc(sizeof(struct nvm_ap) * nvmd->nr_aps, GFP_KERNEL);
+	if (!nvmd->aps)
+		goto err_blocks;
+
+	nvm_for_each_ap(nvmd, ap, i) {
+		spin_lock_init(&ap->lock);
+		ap->parent = nvmd;
+		ap->pool = &nvmd->pools[i / nvmd->nr_aps_per_pool];
+
+		block = nvm_pool_get_block(ap->pool, 0);
+		nvm_set_ap_cur(ap, block);
+		/* Emergency gc block */
+		block = nvm_pool_get_block(ap->pool, 1);
+		ap->gc_cur = block;
+
+		ap->t_read = nvmd->config.t_read;
+		ap->t_write = nvmd->config.t_write;
+		ap->t_erase = nvmd->config.t_erase;
+	}
+
+	/* we make room for each pool context. */
+	nvmd->kbiod_wq = alloc_workqueue("knvm-work", WQ_MEM_RECLAIM|WQ_UNBOUND,
+						nvmd->nr_pools);
+	if (!nvmd->kbiod_wq) {
+		DMERR("Couldn't start knvm-work");
+		goto err_blocks;
+	}
+
+	nvmd->kgc_wq = alloc_workqueue("knvm-gc", WQ_MEM_RECLAIM, 1);
+	if (!nvmd->kgc_wq) {
+		DMERR("Couldn't start knvm-gc");
+		goto err_wq;
+	}
+
+	return 0;
+err_wq:
+	destroy_workqueue(nvmd->kbiod_wq);
+err_blocks:
+	nvm_for_each_pool(nvmd, pool, i) {
+		if (!pool->blocks)
+			break;
+		kfree(pool->blocks);
+	}
+	kfree(nvmd->pools);
+err_pool:
+	ti->error = "Cannot allocate lightnvm data structures";
+	return -ENOMEM;
+}
+
+static int nvm_init(struct dm_target *ti, struct nvmd *nvmd)
+{
+	int i;
+	unsigned int order;
+
+	nvmd->trans_map = vmalloc(sizeof(struct nvm_addr) * nvmd->nr_pages);
+	if (!nvmd->trans_map)
+		return -ENOMEM;
+	memset(nvmd->trans_map, 0, sizeof(struct nvm_addr) * nvmd->nr_pages);
+
+	nvmd->rev_trans_map = vmalloc(sizeof(struct nvm_rev_addr)
+							* nvmd->nr_pages);
+	if (!nvmd->rev_trans_map)
+		goto err_rev_trans_map;
+
+	for (i = 0; i < nvmd->nr_pages; i++) {
+		struct nvm_addr *p = &nvmd->trans_map[i];
+		struct nvm_rev_addr *r = &nvmd->rev_trans_map[i];
+
+		p->addr = LTOP_EMPTY;
+
+		r->addr = 0xDEADBEEF;
+		r->trans_map = NULL;
+	}
+
+	nvmd->per_bio_pool = mempool_create_slab_pool(16, _per_bio_cache);
+	if (!nvmd->per_bio_pool)
+		goto err_dev_lookup;
+
+	nvmd->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
+	if (!nvmd->page_pool)
+		goto err_per_bio_pool;
+
+	nvmd->addr_pool = mempool_create_slab_pool(64, _addr_cache);
+	if (!nvmd->addr_pool)
+		goto err_page_pool;
+
+	order = ffs(nvmd->nr_host_pages_in_blk) - 1;
+	nvmd->block_page_pool = mempool_create_page_pool(nvmd->nr_aps, order);
+	if (!nvmd->block_page_pool)
+		goto err_addr_pool;
+
+	if (bdev_physical_block_size(nvmd->dev->bdev) > EXPOSED_PAGE_SIZE) {
+		ti->error = "bad sector size.";
+		goto err_block_page_pool;
+	}
+	nvmd->sector_size = EXPOSED_PAGE_SIZE;
+
+	/* inflight maintainence */
+	percpu_ida_init(&nvmd->free_inflight, NVM_INFLIGHT_TAGS);
+
+	for (i = 0; i < NVM_INFLIGHT_PARTITIONS; i++) {
+		spin_lock_init(&nvmd->inflight_map[i].lock);
+		INIT_LIST_HEAD(&nvmd->inflight_map[i].addrs);
+	}
+
+	/* simple round-robin strategy */
+	atomic_set(&nvmd->next_write_ap, -1);
+
+	nvmd->ti = ti;
+	ti->private = nvmd;
+
+	/* Initialize pools. */
+	nvm_pool_init(nvmd, ti);
+
+	if (nvmd->type->init && nvmd->type->init(nvmd))
+		goto err_block_page_pool;
+
+	/* FIXME: Clean up pool init on failure. */
+	setup_timer(&nvmd->gc_timer, nvm_gc_cb, (unsigned long)nvmd);
+	mod_timer(&nvmd->gc_timer, jiffies + msecs_to_jiffies(1000));
+
+	return 0;
+err_block_page_pool:
+	mempool_destroy(nvmd->block_page_pool);
+err_addr_pool:
+	mempool_destroy(nvmd->addr_pool);
+err_page_pool:
+	mempool_destroy(nvmd->page_pool);
+err_per_bio_pool:
+	mempool_destroy(nvmd->per_bio_pool);
+err_dev_lookup:
+	vfree(nvmd->rev_trans_map);
+err_rev_trans_map:
+	vfree(nvmd->trans_map);
+	return -ENOMEM;
+}
+
+/*
+ * Accepts an LightNVM-backed block-device. The LightNVM device should run the
+ * corresponding physical firmware that exports the flash as physical without
+ * any mapping and garbage collection as it will be taken care of.
+ */
+static int nvm_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct nvmd *nvmd;
+	unsigned int tmp;
+	char dummy;
+
+	if (argc < 5) {
+		ti->error = "Insufficient arguments";
+		return -EINVAL;
+	}
+
+	nvmd = kzalloc(sizeof(*nvmd), GFP_KERNEL);
+	if (!nvmd) {
+		ti->error = "No enough memory for data structures";
+		return -ENOMEM;
+	}
+
+	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+								&nvmd->dev))
+		goto err_map;
+
+	dm_set_target_max_io_len(ti, NR_PHY_IN_LOG);
+
+	nvmd->type = find_nvm_target_type(argv[1]);
+	if (!nvmd->type) {
+		ti->error = "NVM target type doesn't exist";
+		goto err_map;
+	}
+
+	if (sscanf(argv[2], "%u%c", &tmp, &dummy) != 1) {
+		ti->error = "Cannot read number of pools";
+		goto err_map;
+	}
+	nvmd->nr_pools = tmp;
+
+	if (sscanf(argv[3], "%u%c", &tmp, &dummy) != 1) {
+		ti->error = "Cannot read number of blocks within a pool";
+		goto err_map;
+	}
+	nvmd->nr_blks_per_pool = tmp;
+
+	if (sscanf(argv[4], "%u%c", &tmp, &dummy) != 1) {
+		ti->error = "Cannot read number of pages within a block";
+		goto err_map;
+	}
+	nvmd->nr_pages_per_blk = tmp;
+
+	/* Optional */
+	nvmd->nr_aps_per_pool = APS_PER_POOL;
+	if (argc > 5) {
+		if (sscanf(argv[5], "%u%c", &tmp, &dummy) == 1) {
+			if (!tmp) {
+				DMERR("Number of aps set to 1.");
+				tmp = APS_PER_POOL;
+			}
+			nvmd->nr_aps_per_pool = tmp;
+		} else {
+			ti->error = "Cannot read number of append points";
+			goto err_map;
+		}
+	}
+
+	if (argc > 6) {
+		if (sscanf(argv[6], "%u%c", &tmp, &dummy) == 1) {
+			nvmd->config.flags |= (tmp << NVM_OPT_MISC_OFFSET);
+		} else {
+			ti->error = "Cannot read flags";
+			goto err_map;
+		}
+	}
+
+	nvmd->config.gc_time = GC_TIME;
+	if (argc > 7) {
+		if (sscanf(argv[7], "%u%c", &tmp, &dummy) == 1) {
+			nvmd->config.gc_time = tmp;
+			if (nvmd->config.gc_time <= 0)
+				nvmd->config.gc_time = 1000;
+		} else {
+			ti->error = "Cannot read gc timing";
+			goto err_map;
+		}
+	}
+
+	nvmd->config.t_read = TIMING_READ;
+	if (argc > 8) {
+		if (sscanf(argv[8], "%u%c", &tmp, &dummy) == 1) {
+			nvmd->config.t_read = tmp;
+		} else {
+			ti->error = "Cannot read read access timing";
+			goto err_map;
+		}
+	}
+
+	nvmd->config.t_write = TIMING_WRITE;
+	if (argc > 9) {
+		if (sscanf(argv[9], "%u%c", &tmp, &dummy) == 1) {
+			nvmd->config.t_write = tmp;
+		} else {
+			ti->error = "Cannot read write access timing";
+			goto err_map;
+		}
+	}
+
+	nvmd->config.t_erase = TIMING_ERASE;
+	if (argc > 10) {
+		if (sscanf(argv[10], "%u%c", &tmp, &dummy) == 1) {
+			nvmd->config.t_erase = tmp;
+		} else {
+			ti->error = "Cannot read erase access timing";
+			goto err_map;
+		}
+	}
+
+	nvmd->nr_host_pages_in_blk = NR_HOST_PAGES_IN_FLASH_PAGE
+						* nvmd->nr_pages_per_blk;
+	nvmd->nr_pages = nvmd->nr_pools * nvmd->nr_blks_per_pool
+						* nvmd->nr_host_pages_in_blk;
+
+	/* Invalid pages in block bitmap is preallocated. */
+	if (nvmd->nr_host_pages_in_blk >
+				MAX_INVALID_PAGES_STORAGE * BITS_PER_LONG) {
+		ti->error = "Num pages per block is too high";
+		return -EINVAL;
+	}
+
+
+	if (nvm_init(ti, nvmd) < 0) {
+		ti->error = "Cannot initialize lightnvm structure";
+		goto err_map;
+	}
+
+	DMINFO("Configured with");
+	DMINFO("Pools: %u Blocks: %u Pages: %u APs: %u Pool per AP: %u",
+	       nvmd->nr_pools,
+	       nvmd->nr_blks_per_pool,
+	       nvmd->nr_pages_per_blk,
+	       nvmd->nr_aps,
+	       nvmd->nr_aps_per_pool);
+	DMINFO("Timings: %u/%u/%u",
+			nvmd->config.t_read,
+			nvmd->config.t_write,
+			nvmd->config.t_erase);
+	DMINFO("Target sector size=%d", nvmd->sector_size);
+	DMINFO("Disk logical sector size=%d",
+	       bdev_logical_block_size(nvmd->dev->bdev));
+	DMINFO("Disk physical sector size=%d",
+	       bdev_physical_block_size(nvmd->dev->bdev));
+	DMINFO("Disk flash page size=%d", FLASH_PAGE_SIZE);
+	DMINFO("Allocated %lu physical pages (%lu KB)",
+	       nvmd->nr_pages, nvmd->nr_pages * nvmd->sector_size / 1024);
+
+	return 0;
+err_map:
+	kfree(nvmd);
+	return -ENOMEM;
+}
+
+static void nvm_dtr(struct dm_target *ti)
+{
+	struct nvmd *nvmd = ti->private;
+	struct nvm_pool *pool;
+	int i;
+
+	if (nvmd->type->exit)
+		nvmd->type->exit(nvmd);
+
+	del_timer(&nvmd->gc_timer);
+
+	nvm_for_each_pool(nvmd, pool, i) {
+		while (bio_list_peek(&pool->waiting_bios))
+			flush_scheduled_work();
+	}
+
+	/* TODO: remember outstanding block refs, waiting to be erased... */
+	nvm_for_each_pool(nvmd, pool, i)
+		kfree(pool->blocks);
+
+	kfree(nvmd->pools);
+	kfree(nvmd->aps);
+
+	vfree(nvmd->trans_map);
+	vfree(nvmd->rev_trans_map);
+
+	destroy_workqueue(nvmd->kbiod_wq);
+	destroy_workqueue(nvmd->kgc_wq);
+
+	mempool_destroy(nvmd->per_bio_pool);
+	mempool_destroy(nvmd->page_pool);
+	mempool_destroy(nvmd->addr_pool);
+
+	percpu_ida_destroy(&nvmd->free_inflight);
+
+	dm_put_device(ti, nvmd->dev);
+
+	kfree(nvmd);
+
+	DMINFO("successfully unloaded");
+}
+
+static int nvm_none_write_bio(struct nvmd *nvmd, struct bio *bio)
+{
+	sector_t l_addr = bio->bi_sector / NR_PHY_IN_LOG;
+	nvm_lock_addr(nvmd, l_addr);
+
+	nvm_write_bio(nvmd, bio, 0, NULL, NULL, nvmd->trans_map, 1);
+	return DM_MAPIO_SUBMITTED;
+}
+
+/* none target type, round robin, page-based FTL, and cost-based GC */
+static struct nvm_target_type nvm_target_none = {
+	.name			= "none",
+	.version		= {1, 0, 0},
+	.lookup_ltop	= nvm_lookup_ltop,
+	.map_ltop	= nvm_map_ltop_rr,
+	.write_bio	= nvm_none_write_bio,
+	.read_bio	= nvm_read_bio,
+	.defer_bio	= nvm_defer_bio,
+	.bio_wait_add	= nvm_bio_wait_add,
+};
+
+static struct target_type lightnvm_target = {
+	.name		= "lightnvm",
+	.version	= {1, 0, 0},
+	.module		= THIS_MODULE,
+	.ctr		= nvm_ctr,
+	.dtr		= nvm_dtr,
+	.map		= nvm_map,
+	.ioctl		= nvm_ioctl,
+	.status		= nvm_status,
+};
+
+static int __init dm_lightnvm_init(void)
+{
+	int ret = -ENOMEM;
+
+	_per_bio_cache = kmem_cache_create("lightnvm_per_bio_cache",
+				sizeof(struct per_bio_data), 0, 0, NULL);
+	if (!_per_bio_cache)
+		return ret;
+
+	_addr_cache = kmem_cache_create("lightnvm_addr_cache",
+				sizeof(struct nvm_addr), 0, 0, NULL);
+	if (!_addr_cache)
+		goto err_pbc;
+
+	nvm_register_target(&nvm_target_none);
+
+	ret = dm_register_target(&lightnvm_target);
+	if (ret < 0) {
+		DMERR("register failed %d", ret);
+		goto err_adp;
+	}
+
+	return ret;
+err_adp:
+	kmem_cache_destroy(_addr_cache);
+err_pbc:
+	kmem_cache_destroy(_per_bio_cache);
+	return ret;
+}
+
+static void __exit dm_lightnvm_exit(void)
+{
+	dm_unregister_target(&lightnvm_target);
+	kmem_cache_destroy(_per_bio_cache);
+	kmem_cache_destroy(_addr_cache);
+}
+
+module_init(dm_lightnvm_init);
+module_exit(dm_lightnvm_exit);
+
+MODULE_DESCRIPTION(DM_NAME " target");
+MODULE_AUTHOR("Matias Bjorling <m@bjorling.me>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/lightnvm/lightnvm.h b/drivers/md/lightnvm/lightnvm.h
new file mode 100644
index 0000000..1f6d775
--- /dev/null
+++ b/drivers/md/lightnvm/lightnvm.h
@@ -0,0 +1,592 @@
+/*
+ * Copyright (C) 2014 Matias Bjørling.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_LIGHTNVM_H_
+#define DM_LIGHTNVM_H_
+
+#include <linux/device-mapper.h>
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
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
+
+#define DM_MSG_PREFIX "lightnvm"
+#define LTOP_EMPTY -1
+#define LTOP_POISON 0xD3ADB33F
+
+#define LIGHTNVM_IOC_MAGIC 'O'
+#define LIGHTNVM_IOCTL_ID _IO(LIGHTNVM_IOC_MAGIC, 0x40)
+
+/*
+ * For now we hardcode some of the configuration for the LightNVM device that we
+ * have. In the future this should be made configurable.
+ *
+ * Configuration:
+ * EXPOSED_PAGE_SIZE - the page size of which we tell the layers above the
+ * driver to issue. This usually is 512 bytes for 4K for simplivity.
+ * FLASH_PAGE_SIZE - the flash size of the individual flash pages. These should
+ * match the hardware flash chips. Currently only the same page size as
+ * EXPOSED_PAGE_SIZE is supported.
+ *
+ */
+
+#define EXPOSED_PAGE_SIZE 4096
+#define FLASH_PAGE_SIZE EXPOSED_PAGE_SIZE
+
+/* Useful shorthands */
+#define NR_HOST_PAGES_IN_FLASH_PAGE (FLASH_PAGE_SIZE / EXPOSED_PAGE_SIZE)
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
+#define NVM_WRITE_SUCCESS  0
+#define NVM_WRITE_DEFERRED 1
+#define NVM_WRITE_GC_ABORT 2
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
+		/* points to the next writable flash page within a block */
+		unsigned int next_page;
+		/* if a flash page can have multiple host pages,
+		   fill up the flash page before going to the next
+		   writable flash page */
+		unsigned char next_offset;
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
+	struct page *data;
+	atomic_t data_size; /* data pages inserted into data variable */
+	atomic_t data_cmnt_size; /* data pages committed to stable storage */
+
+	/* Block state handling */
+	atomic_t gc_running;
+	struct work_struct ws_gc;
+};
+
+/* Logical to physical mapping */
+struct nvm_addr {
+	sector_t addr;
+	struct nvm_block *block;
+	void *private;
+};
+
+/* Physical to logical mapping */
+struct nvm_rev_addr {
+	sector_t addr;
+	struct nvm_addr *trans_map;
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
+	struct nvmd *nvmd;
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
+	struct nvmd *parent;
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
+	unsigned long io_accesses[2];
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
+struct nvm_inflight_addr {
+	struct list_head list;
+	sector_t l_addr;
+	int tag;
+};
+
+struct nvm_inflight {
+	spinlock_t lock;
+	struct list_head addrs;
+};
+
+struct nvmd;
+struct per_bio_data;
+
+/* overridable functionality */
+typedef struct nvm_addr *(*nvm_map_ltop_fn)(struct nvmd *, sector_t, int,
+						struct nvm_addr *, void *);
+typedef struct nvm_addr *(*nvm_lookup_ltop_fn)(struct nvmd *, sector_t);
+typedef int (*nvm_write_bio_fn)(struct nvmd *, struct bio *);
+typedef int (*nvm_read_bio_fn)(struct nvmd *, struct bio *);
+typedef void (*nvm_alloc_phys_addr_fn)(struct nvmd *, struct nvm_block *);
+typedef void (*nvm_defer_bio_fn)(struct nvmd *, struct bio *, void *);
+typedef void (*nvm_bio_wait_add_fn)(struct bio_list *, struct bio *, void *);
+typedef int (*nvm_ioctl_fn)(struct nvmd *,
+					unsigned int cmd, unsigned long arg);
+typedef int (*nvm_init_fn)(struct nvmd *);
+typedef void (*nvm_exit_fn)(struct nvmd *);
+typedef void (*nvm_endio_fn)(struct nvmd *, struct bio *,
+				struct per_bio_data *, unsigned long *delay);
+
+typedef int (*nvm_page_special_fn)(struct nvmd *, unsigned int);
+
+struct nvm_target_type {
+	const char *name;
+	unsigned version[3];
+	nvm_map_ltop_fn map_ltop;
+
+	/* lookup functions */
+	nvm_lookup_ltop_fn lookup_ltop;
+
+	/* handling of bios */
+	nvm_write_bio_fn write_bio;
+	nvm_read_bio_fn read_bio;
+	nvm_ioctl_fn ioctl;
+	nvm_endio_fn endio;
+
+	/* engine specific overrides */
+	nvm_alloc_phys_addr_fn alloc_phys_addr;
+	nvm_defer_bio_fn defer_bio;
+	nvm_bio_wait_add_fn bio_wait_add;
+
+	/* module specific init/teardown */
+	nvm_init_fn init;
+	nvm_exit_fn exit;
+
+	/* For lightnvm internal use */
+	struct list_head list;
+};
+
+/* Main structure */
+struct nvmd {
+	struct dm_dev *dev;
+	struct dm_target *ti;
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
+	mempool_t *per_bio_pool;
+	mempool_t *addr_pool;
+	mempool_t *page_pool;
+	mempool_t *block_page_pool;
+
+	/* Frequently used config variables */
+	int nr_pools;
+	int nr_blks_per_pool;
+	int nr_pages_per_blk;
+	int nr_aps;
+	int nr_aps_per_pool;
+
+	/* Calculated values */
+	unsigned int nr_host_pages_in_blk;
+	unsigned long nr_pages;
+
+	unsigned int next_collect_pool;
+
+	/* Write strategy variables. Move these into each for structure for each
+	 * strategy */
+	atomic_t next_write_ap; /* Whenever a page is written, this is updated
+				 * to point to the next write append point */
+	struct workqueue_struct *kbiod_wq;
+	struct workqueue_struct *kgc_wq;
+
+	spinlock_t deferred_lock;
+	struct work_struct deferred_ws;
+	struct bio_list deferred_bios;
+
+	struct timer_list gc_timer;
+
+	/* in-flight data lookup, lookup by logical address. Remember the
+	 * overhead of cachelines being used. Keep it low for better cache
+	 * utilization. */
+	struct percpu_ida free_inflight;
+	struct nvm_inflight inflight_map[NVM_INFLIGHT_PARTITIONS];
+	struct nvm_inflight_addr inflight_addrs[NVM_INFLIGHT_TAGS];
+
+	/* nvm module specific data */
+	void *private;
+
+	/* User configuration */
+	struct nvm_config config;
+};
+
+struct per_bio_data {
+	struct nvm_ap *ap;
+	struct nvm_addr *addr;
+	struct timespec start_tv;
+	sector_t l_addr;
+
+	/* Hook up for our overwritten bio fields */
+	bio_end_io_t *bi_end_io;
+	void *bi_private;
+	struct completion *event;
+	struct bio *orig_bio;
+	unsigned int sync;
+	unsigned int ref_put;
+	struct nvm_addr *trans_map;
+};
+
+/* reg.c */
+int nvm_register_target(struct nvm_target_type *t);
+void nvm_unregister_target(struct nvm_target_type *t);
+struct nvm_target_type *find_nvm_target_type(const char *name);
+
+/* core.c */
+/*   Helpers */
+struct nvm_block *nvm_pool_get_block(struct nvm_pool *, int is_gc);
+void invalidate_block_page(struct nvmd *, struct nvm_addr *);
+void nvm_set_ap_cur(struct nvm_ap *, struct nvm_block *);
+void nvm_defer_bio(struct nvmd *nvmd, struct bio *bio, void *private);
+void nvm_bio_wait_add(struct bio_list *bl, struct bio *bio, void *p_private);
+sector_t nvm_alloc_phys_addr(struct nvm_block *);
+sector_t nvm_alloc_phys_addr_special(struct nvm_block *, nvm_page_special_fn);
+
+/*   Naive implementations */
+void nvm_delayed_bio_submit(struct work_struct *);
+void nvm_deferred_bio_submit(struct work_struct *);
+void nvm_gc_block(struct work_struct *);
+
+/* Allocation of physical addresses from block
+ * when increasing responsibility. */
+struct nvm_addr *nvm_alloc_addr_from_ap(struct nvm_ap *, int is_gc);
+struct nvm_addr *nvm_map_ltop_rr(struct nvmd *, sector_t l_addr, int is_gc,
+				struct nvm_addr *trans_map, void *private);
+
+/* Gets an address from nvm->trans_map and take a ref count on the blocks usage.
+ * Remember to put later */
+struct nvm_addr *nvm_lookup_ltop_map(struct nvmd *, sector_t l_addr,
+				struct nvm_addr *l2p_map, void *private);
+struct nvm_addr *nvm_lookup_ltop(struct nvmd *, sector_t l_addr);
+
+/*   I/O bio related */
+struct nvm_addr *nvm_get_trans_map(struct nvmd *nvmd, void *private);
+struct bio *nvm_write_init_bio(struct nvmd *, struct bio *, struct nvm_addr *);
+int nvm_bv_copy(struct nvm_addr *p, struct bio_vec *bv);
+/* FIXME: Shorten */
+int nvm_write_bio(struct nvmd *, struct bio *bio, int is_gc, void *private,
+		struct completion *sync, struct nvm_addr *trans_map,
+		unsigned int complete_bio);
+int nvm_read_bio(struct nvmd *, struct bio *bio);
+/* FIXME: Shorten */
+void nvm_update_map(struct nvmd *nvmd, sector_t l_addr, struct nvm_addr *p,
+					int is_gc, struct nvm_addr *trans_map);
+/* FIXME: Shorten */
+void nvm_submit_bio(struct nvmd *, struct nvm_addr *, sector_t, int rw,
+		struct bio *, struct bio *orig_bio, struct completion *sync,
+		struct nvm_addr *trans_map);
+void nvm_defer_write_bio(struct nvmd *nvmd, struct bio *bio, void *private);
+
+/*   NVM device related */
+void nvm_block_release(struct kref *);
+
+/*   Block maintanence */
+void nvm_pool_put_block(struct nvm_block *);
+void nvm_reset_block(struct nvm_block *);
+
+/* gc.c */
+void nvm_block_erase(struct kref *);
+void nvm_gc_cb(unsigned long data);
+void nvm_gc_collect(struct work_struct *work);
+void nvm_gc_kick(struct nvmd *nvmd);
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
+static inline struct nvm_ap *get_next_ap(struct nvmd *n)
+{
+	return &n->aps[atomic_inc_return(&n->next_write_ap) % n->nr_aps];
+}
+
+static inline int block_is_full(struct nvm_block *block)
+{
+	struct nvmd *nvmd = block->pool->nvmd;
+	return (block->next_page * NR_HOST_PAGES_IN_FLASH_PAGE) +
+			block->next_offset == nvmd->nr_host_pages_in_blk;
+}
+
+static inline sector_t block_to_addr(struct nvm_block *block)
+{
+	struct nvmd *nvmd;
+	BUG_ON(!block);
+	nvmd = block->pool->nvmd;
+	return block->id * nvmd->nr_host_pages_in_blk;
+}
+
+static inline struct nvm_pool *paddr_to_pool(struct nvmd *n, sector_t p_addr)
+{
+	return &n->pools[p_addr / (n->nr_pages / n->nr_pools)];
+}
+
+static inline struct nvm_ap *block_to_ap(struct nvmd *n, struct nvm_block *b)
+{
+	unsigned int ap_idx, div, mod;
+
+	div = b->id / n->nr_blks_per_pool;
+	mod = b->id % n->nr_blks_per_pool;
+	ap_idx = div + (mod / (n->nr_blks_per_pool / n->nr_aps_per_pool));
+
+	return &n->aps[ap_idx];
+}
+
+static inline int physical_to_slot(struct nvmd *n, sector_t phys)
+{
+	return (phys % (n->nr_pages_per_blk * NR_HOST_PAGES_IN_FLASH_PAGE)) /
+		NR_HOST_PAGES_IN_FLASH_PAGE;
+}
+
+static inline struct per_bio_data *get_per_bio_data(struct bio *bio)
+{
+	return bio->bi_private;
+}
+
+static inline struct nvm_inflight *nvm_hash_addr_to_inflight(struct nvmd *nvmd,
+								sector_t l_addr)
+{
+	return &nvmd->inflight_map[l_addr % NVM_INFLIGHT_PARTITIONS];
+}
+
+static inline void __nvm_lock_addr(struct nvmd *nvmd, sector_t l_addr, int spin)
+{
+	struct nvm_inflight *inflight = nvm_hash_addr_to_inflight(nvmd, l_addr);
+	struct nvm_inflight_addr *a;
+	int tag = percpu_ida_alloc(&nvmd->free_inflight, __GFP_WAIT);
+
+	BUG_ON(l_addr >= nvmd->nr_pages);
+
+retry:
+	spin_lock(&inflight->lock);
+
+	list_for_each_entry(a, &inflight->addrs, list) {
+		if (a->l_addr == l_addr) {
+			spin_unlock(&inflight->lock);
+			/* TODO: give up control and come back. I haven't found
+			 * a good way to complete the work, when the data the
+			 * complete structure is being reused */
+			if (!spin)
+				schedule();
+			goto retry;
+		}
+	}
+
+	a = &nvmd->inflight_addrs[tag];
+
+	a->l_addr = l_addr;
+	a->tag = tag;
+
+	list_add_tail(&a->list, &inflight->addrs);
+	spin_unlock(&inflight->lock);
+}
+
+static inline void nvm_lock_addr(struct nvmd *nvmd, sector_t l_addr)
+{
+	__nvm_lock_addr(nvmd, l_addr, 0);
+}
+
+static inline void nvm_unlock_addr(struct nvmd *nvmd, sector_t l_addr)
+{
+	struct nvm_inflight *inflight =
+			nvm_hash_addr_to_inflight(nvmd, l_addr);
+	struct nvm_inflight_addr *a = NULL;
+
+	spin_lock(&inflight->lock);
+
+	BUG_ON(list_empty(&inflight->addrs));
+
+	list_for_each_entry(a, &inflight->addrs, list)
+		if (a->l_addr == l_addr)
+			break;
+
+	BUG_ON(!a && a->l_addr != l_addr);
+
+	a->l_addr = LTOP_POISON;
+
+	list_del_init(&a->list);
+	spin_unlock(&inflight->lock);
+	percpu_ida_free(&nvmd->free_inflight, a->tag);
+}
+
+static inline void show_pool(struct nvm_pool *pool)
+{
+	struct list_head *head, *cur;
+	unsigned int free_cnt = 0, used_cnt = 0, prio_cnt = 0;
+
+	spin_lock(&pool->lock);
+	list_for_each_safe(head, cur, &pool->free_list)
+		free_cnt++;
+	list_for_each_safe(head, cur, &pool->used_list)
+		used_cnt++;
+	list_for_each_safe(head, cur, &pool->prio_list)
+		prio_cnt++;
+	spin_unlock(&pool->lock);
+
+	DMERR("P-%d F:%u U:%u P:%u", pool->id, free_cnt, used_cnt, prio_cnt);
+}
+
+static inline void show_all_pools(struct nvmd *nvmd)
+{
+	struct nvm_pool *pool;
+	unsigned int i;
+
+	nvm_for_each_pool(nvmd, pool, i)
+		show_pool(pool);
+}
+
+#endif /* DM_LIGHTNVM_H_ */
+
diff --git a/drivers/md/lightnvm/reg.c b/drivers/md/lightnvm/reg.c
new file mode 100644
index 0000000..ce39da0
--- /dev/null
+++ b/drivers/md/lightnvm/reg.c
@@ -0,0 +1,41 @@
+#include <linux/list.h>
+#include <linux/sem.h>
+#include "lightnvm.h"
+
+static LIST_HEAD(_targets);
+static DECLARE_RWSEM(_lock);
+
+inline struct nvm_target_type *find_nvm_target_type(const char *name)
+{
+	struct nvm_target_type *t;
+
+	list_for_each_entry(t, &_targets, list)
+		if (!strcmp(name, t->name))
+			return t;
+
+	return NULL;
+}
+
+int nvm_register_target(struct nvm_target_type *t)
+{
+	int ret = 0;
+
+	down_write(&_lock);
+	if (find_nvm_target_type(t->name))
+		ret = -EEXIST;
+	else
+		list_add(&t->list, &_targets);
+	up_write(&_lock);
+	return ret;
+}
+
+void nvm_unregister_target(struct nvm_target_type *t)
+{
+	if (!t)
+		return;
+
+	down_write(&_lock);
+	list_del(&t->list);
+	up_write(&_lock);
+}
+
-- 
1.8.3.2

