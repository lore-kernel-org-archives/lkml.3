Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3LCWE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:04:29 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59030 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab3LCWAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:39 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH 01/11] block: Make generic_make_request handle arbitrary sized bios
Date: Tue,  3 Dec 2013 14:00:07 -0800
Message-Id: <1386108017-27964-2-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way the block layer is currently written, it goes to great lengths
to avoid having to split bios; upper layer code (such as bio_add_page())
checks what the underlying device can handle and tries to always create
bios that don't need to be split.

But this approach becomes unwieldy and eventually breaks down with
stacked devices and devices with dynamic limits, and it adds a lot of
complexity. If the block layer could split bios as needed, we could
eliminate a lot of complexity elsewhere - particularly in stacked
drivers. Code that creates bios can then create whatever size bios are
convenient, and more importantly stacked drivers don't have to deal with
both their own bio size limitations and the limitations of the
(potentially multiple) devices underneath them.  In the future this will
let us delete merge_bvec_fn and a bunch of other code.

We do this by adding calls to blk_queue_split() to the various
make_request functions that need it - a few can already handle arbitrary
size bios. Note that we add the call _after_ any call to blk_queue_bounce();
this means that blk_queue_split() and blk_recalc_rq_segments() don't need to be
concerned with bouncing affecting segment merging.

Some make_request_fns were simple enough to audit and verify they don't
need blk_queue_split() calls. The skipped ones are:

 * nfhd_make_request (arch/m68k/emu/nfblock.c)
 * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
 * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
 * brd_make_request (ramdisk - drivers/block/brd.c)
 * loop_make_request
 * null_queue_bio
 * bcache's make_request fns

Some others are almost certainly safe to remove now, but will be left for future
patches.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Neil Brown <neilb@suse.de>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 block/blk-core.c                            |  19 ++--
 block/blk-merge.c                           | 150 ++++++++++++++++++++++++++--
 block/blk-mq.c                              |   2 +
 drivers/block/drbd/drbd_req.c               |   2 +
 drivers/block/mtip32xx/mtip32xx.c           |   6 +-
 drivers/block/nvme-core.c                   |   2 +
 drivers/block/pktcdvd.c                     |   6 +-
 drivers/block/ps3vram.c                     |   2 +
 drivers/block/rsxx/dev.c                    |   2 +
 drivers/block/umem.c                        |   2 +
 drivers/md/dm.c                             |   2 +
 drivers/md/md.c                             |   2 +
 drivers/s390/block/dcssblk.c                |   2 +
 drivers/s390/block/xpram.c                  |   2 +
 drivers/staging/lustre/lustre/llite/lloop.c |   2 +
 drivers/staging/zram/zram_drv.c             |   2 +
 include/linux/blkdev.h                      |   3 +
 17 files changed, 185 insertions(+), 23 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5da8e90..5cc7171 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -566,6 +566,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (q->id < 0)
 		goto fail_c;
 
+	q->bio_split = bioset_create(4, 0);
+	if (!q->bio_split)
+		goto fail_id;
+
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
@@ -575,7 +579,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	err = bdi_init(&q->backing_dev_info);
 	if (err)
-		goto fail_id;
+		goto fail_split;
 
 	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, (unsigned long) q);
@@ -620,6 +624,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 fail_bdi:
 	bdi_destroy(&q->backing_dev_info);
+fail_split:
+	bioset_free(q->bio_split);
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
 fail_c:
@@ -1472,6 +1478,8 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	struct request *req;
 	unsigned int request_count = 0;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1694,15 +1702,6 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (likely(bio_is_rw(bio) &&
-		   nr_sectors > queue_max_hw_sectors(q))) {
-		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
-		       bdevname(bio->bi_bdev, b),
-		       bio_sectors(bio),
-		       queue_max_hw_sectors(q));
-		goto end_io;
-	}
-
 	part = bio->bi_bdev->bd_part;
 	if (should_fail_request(part, bio->bi_iter.bi_size) ||
 	    should_fail_request(&part_to_disk(part)->part0,
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8f8adaa..c1403ee 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,11 +9,149 @@
 
 #include "blk.h"
 
+static struct bio *blk_bio_discard_split(struct request_queue *q,
+					 struct bio *bio,
+					 struct bio_set *bs)
+{
+	unsigned int max_discard_sectors, granularity;
+	int alignment;
+	sector_t tmp;
+	unsigned split_sectors;
+
+	/* Zero-sector (unknown) and one-sector granularities are the same.  */
+	granularity = max(q->limits.discard_granularity >> 9, 1U);
+
+	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	max_discard_sectors -= max_discard_sectors % granularity;
+
+	if (unlikely(!max_discard_sectors)) {
+		/* XXX: warn */
+		return NULL;
+	}
+
+	if (bio_sectors(bio) <= max_discard_sectors)
+		return NULL;
+
+	split_sectors = max_discard_sectors;
+
+	/*
+	 * If the next starting sector would be misaligned, stop the discard at
+	 * the previous aligned sector.
+	 */
+	alignment = (q->limits.discard_alignment >> 9) % granularity;
+
+	tmp = bio->bi_iter.bi_sector + split_sectors - alignment;
+	tmp = sector_div(tmp, granularity);
+
+	if (split_sectors > tmp)
+		split_sectors -= tmp;
+
+	return bio_split(bio, split_sectors, GFP_NOIO, bs);
+}
+
+static struct bio *blk_bio_write_same_split(struct request_queue *q,
+					    struct bio *bio,
+					    struct bio_set *bs)
+{
+	if (!q->limits.max_write_same_sectors)
+		return NULL;
+
+	if (bio_sectors(bio) <= q->limits.max_write_same_sectors)
+		return NULL;
+
+	return bio_split(bio, q->limits.max_write_same_sectors, GFP_NOIO, bs);
+}
+
+static struct bio *blk_bio_segment_split(struct request_queue *q,
+					 struct bio *bio,
+					 struct bio_set *bs)
+{
+	struct bio *split;
+	struct bio_vec bv, bvprv;
+	struct bvec_iter iter;
+	unsigned seg_size = 0, nsegs = 0;
+	int prev = 0;
+
+	struct bvec_merge_data bvm = {
+		.bi_bdev	= bio->bi_bdev,
+		.bi_sector	= bio->bi_iter.bi_sector,
+		.bi_size	= 0,
+		.bi_rw		= bio->bi_rw,
+	};
+
+	bio_for_each_segment(bv, bio, iter) {
+		if (q->merge_bvec_fn &&
+		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
+			goto split;
+
+		bvm.bi_size += bv.bv_len;
+
+		if (bvm.bi_size >> 9 > queue_max_sectors(q))
+			goto split;
+
+		if (prev && blk_queue_cluster(q)) {
+			if (seg_size + bv.bv_len > queue_max_segment_size(q))
+				goto new_segment;
+			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bv))
+				goto new_segment;
+			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bv))
+				goto new_segment;
+
+			seg_size += bv.bv_len;
+			bvprv = bv;
+			prev = 1;
+			continue;
+		}
+new_segment:
+		if (nsegs == queue_max_segments(q))
+			goto split;
+
+		nsegs++;
+		bvprv = bv;
+		prev = 1;
+		seg_size = bv.bv_len;
+	}
+
+	return NULL;
+split:
+	split = bio_clone_bioset(bio, GFP_NOIO, bs);
+
+	split->bi_iter.bi_size -= iter.bi_size;
+	bio->bi_iter = iter;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_advance(bio, split->bi_iter.bi_size);
+		bio_integrity_trim(split, 0, bio_sectors(split));
+	}
+
+	return split;
+}
+
+void blk_queue_split(struct request_queue *q, struct bio **bio,
+		     struct bio_set *bs)
+{
+	struct bio *split;
+
+	if ((*bio)->bi_rw & REQ_DISCARD)
+		split = blk_bio_discard_split(q, *bio, bs);
+	else if ((*bio)->bi_rw & REQ_WRITE_SAME)
+		split = blk_bio_write_same_split(q, *bio, bs);
+	else
+		split = blk_bio_segment_split(q, *bio, q->bio_split);
+
+	if (split) {
+		bio_chain(split, *bio);
+		generic_make_request(*bio);
+		*bio = split;
+	}
+}
+EXPORT_SYMBOL(blk_queue_split);
+
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
 	struct bio_vec bv, bvprv = { NULL };
-	int cluster, high, highprv = 1;
+	int cluster, prev = 0;
 	unsigned int seg_size, nr_phys_segs;
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
@@ -27,13 +165,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	nr_phys_segs = 0;
 	for_each_bio(bio) {
 		bio_for_each_segment(bv, bio, iter) {
-			/*
-			 * the trick here is making sure that a high page is
-			 * never considered part of another segment, since that
-			 * might change with the bounce page.
-			 */
-			high = page_to_pfn(bv.bv_page) > queue_bounce_pfn(q);
-			if (!high && !highprv && cluster) {
+			if (prev && cluster) {
 				if (seg_size + bv.bv_len
 				    > queue_max_segment_size(q))
 					goto new_segment;
@@ -53,8 +185,8 @@ new_segment:
 
 			nr_phys_segs++;
 			bvprv = bv;
+			prev = 1;
 			seg_size = bv.bv_len;
-			highprv = high;
 		}
 		bbio = bio;
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e4fbcc3..d29be09 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -912,6 +912,8 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
 	blk_queue_bounce(q, &bio);
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (use_plug && blk_attempt_plug_merge(q, bio, &request_count))
 		return;
 
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 104a040..941a69c 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1275,6 +1275,8 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	struct drbd_conf *mdev = (struct drbd_conf *) q->queuedata;
 	unsigned long start_time;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	start_time = jiffies;
 
 	/*
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 52b2f2a..3ff8120 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3967,6 +3967,10 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 	int nents = 0;
 	int tag = 0, unaligned = 0;
 
+	blk_queue_bounce(queue, &bio);
+
+	blk_queue_split(queue, &bio, queue->bio_split);
+
 	if (unlikely(dd->dd_flag & MTIP_DDF_STOP_IO)) {
 		if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 							&dd->dd_flag))) {
@@ -4016,8 +4020,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
 	if (likely(sg != NULL)) {
-		blk_queue_bounce(queue, &bio);
-
 		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
 			dev_warn(&dd->pdev->dev,
 				"Maximum number of SGL entries exceeded\n");
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 1f14ac4..cfb8f7b 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -707,6 +707,8 @@ static void nvme_make_request(struct request_queue *q, struct bio *bio)
 	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
 	int result = -EBUSY;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (!nvmeq) {
 		put_nvmeq(NULL);
 		bio_endio(bio, -EIO);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 3dda09a..38799f8 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2442,6 +2442,10 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	char b[BDEVNAME_SIZE];
 	struct bio *split;
 
+	blk_queue_bounce(q, &bio);
+
+	blk_queue_split(q, &bio, q->bio_split);
+
 	pd = q->queuedata;
 	if (!pd) {
 		pr_err("%s incorrect request queue\n",
@@ -2472,8 +2476,6 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		goto end_io;
 	}
 
-	blk_queue_bounce(q, &bio);
-
 	do {
 		sector_t zone = get_zone(bio->bi_iter.bi_sector, pd);
 		sector_t last_zone = get_zone(bio_end_sector(bio) - 1, pd);
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index ef45cfb..a995972 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -603,6 +603,8 @@ static void ps3vram_make_request(struct request_queue *q, struct bio *bio)
 	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
 	int busy;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	dev_dbg(&dev->core, "%s\n", __func__);
 
 	spin_lock_irq(&priv->lock);
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 2839d37..ff074a3 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -169,6 +169,8 @@ static void rsxx_make_request(struct request_queue *q, struct bio *bio)
 	struct rsxx_bio_meta *bio_meta;
 	int st = -EINVAL;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	might_sleep();
 
 	if (!card)
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 4cf81b5..13d577c 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -531,6 +531,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
 		 (unsigned long long)bio->bi_iter.bi_sector,
 		 bio->bi_iter.bi_size);
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	spin_lock_irq(&card->lock);
 	*card->biotail = bio;
 	bio->bi_next = NULL;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 44a2fa6..0bfb050 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1500,6 +1500,8 @@ static void dm_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (dm_request_based(md))
 		blk_queue_bio(q, bio);
 	else
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b07fed3..de39a8a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -256,6 +256,8 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 	int cpu;
 	unsigned int sectors;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (mddev == NULL || mddev->pers == NULL
 	    || !mddev->ready) {
 		bio_io_error(bio);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index ebf41e2..db33cd3 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -815,6 +815,8 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long source_addr;
 	unsigned long bytes_done;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	bytes_done = 0;
 	dev_info = bio->bi_bdev->bd_disk->private_data;
 	if (dev_info == NULL)
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 3e530f9..3ae29a0 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -190,6 +190,8 @@ static void xpram_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long page_addr;
 	unsigned long bytes;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if ((bio->bi_iter.bi_sector & 7) != 0 ||
 	    (bio->bi_iter.bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 581ff78..776d44c 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -344,6 +344,8 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
 	int rw = bio_rw(old_bio);
 	int inactive;
 
+	blk_queue_split(q, &old_bio, q->bio_split);
+
 	if (!lo)
 		goto err;
 
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 6f98838..56eb09e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -734,6 +734,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
 
+	blk_queue_split(queue, &bio, queue->bio_split);
+
 	down_read(&zram->init_lock);
 	if (unlikely(!zram->init_done))
 		goto error;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 02cb6f0..88d4e7b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -476,6 +476,7 @@ struct request_queue {
 	wait_queue_head_t	mq_freeze_wq;
 	struct percpu_counter	mq_usage_counter;
 	struct list_head	all_q_node;
+	struct bio_set		*bio_split;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
@@ -787,6 +788,8 @@ extern void blk_rq_unprep_clone(struct request *rq);
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
+extern void blk_queue_split(struct request_queue *, struct bio **,
+			    struct bio_set *);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
-- 
1.8.4.4

