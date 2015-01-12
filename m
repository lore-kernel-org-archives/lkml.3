Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbbALLur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:50:47 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64576 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbbALLuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:50:40 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lin <mlin@minggr.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>,
        Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>,
        Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 1/9] block: make generic_make_request handle arbitrarily sized bios
Date: Mon, 12 Jan 2015 12:49:40 +0100
Message-Id: <4e7cfbce77dcf72474e1b930ef017c9efaea36d7.1421052746.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421052745.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052745.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

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
size bios. Note that we add the call _after_ any call to
blk_queue_bounce(); this means that blk_queue_split() and
blk_recalc_rq_segments() don't need to be concerned with bouncing
affecting segment merging.

Some make_request_fn() callbacks were simple enough to audit and verify
they don't need blk_queue_split() calls. The skipped ones are:

 * nfhd_make_request (arch/m68k/emu/nfblock.c)
 * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
 * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
 * brd_make_request (ramdisk - drivers/block/brd.c)
 * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
 * loop_make_request
 * null_queue_bio
 * bcache's make_request fns

Some others are almost certainly safe to remove now, but will be left
for future patches.

Cc: Ming Lin <mlin@minggr.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: drbd-user@lists.linbit.com
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Jim Paris <jim@jtan.com>
Cc: Joshua Morris <josh.h.morris@us.ibm.com>
Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: skip more mq-based drivers, resolve merge conflicts, etc.]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 block/blk-core.c                            |  19 ++--
 block/blk-merge.c                           | 151 ++++++++++++++++++++++++++--
 block/blk-mq.c                              |   2 +
 drivers/block/drbd/drbd_req.c               |   2 +
 drivers/block/pktcdvd.c                     |   6 +-
 drivers/block/ps3vram.c                     |   2 +
 drivers/block/rsxx/dev.c                    |   2 +
 drivers/block/umem.c                        |   2 +
 drivers/block/zram/zram_drv.c               |   2 +
 drivers/md/dm.c                             |   2 +
 drivers/md/md.c                             |   2 +
 drivers/s390/block/dcssblk.c                |   2 +
 drivers/s390/block/xpram.c                  |   2 +
 drivers/staging/lustre/lustre/llite/lloop.c |   2 +
 include/linux/blkdev.h                      |   3 +
 15 files changed, 179 insertions(+), 22 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 30f6153..e86ad75 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -585,6 +585,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (q->id < 0)
 		goto fail_q;
 
+	q->bio_split = bioset_create(4, 0);
+	if (!q->bio_split)
+		goto fail_id;
+
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
@@ -594,7 +598,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	err = bdi_init(&q->backing_dev_info);
 	if (err)
-		goto fail_id;
+		goto fail_split;
 
 	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, (unsigned long) q);
@@ -636,6 +640,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 fail_bdi:
 	bdi_destroy(&q->backing_dev_info);
+fail_split:
+	bioset_free(q->bio_split);
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
 fail_q:
@@ -1552,6 +1558,8 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	struct request *req;
 	unsigned int request_count = 0;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1775,15 +1783,6 @@ generic_make_request_checks(struct bio *bio)
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
index 89b97b5..3bc2068 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,12 +9,150 @@
 
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
+	struct bio_vec bv = { 0 }, bvprv = { 0 };
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
 					     struct bio *bio,
 					     bool no_sg_merge)
 {
 	struct bio_vec bv, bvprv = { NULL };
-	int cluster, high, highprv = 1;
+	int cluster, prev = 0;
 	unsigned int seg_size, nr_phys_segs;
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
@@ -36,7 +174,6 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	cluster = blk_queue_cluster(q);
 	seg_size = 0;
 	nr_phys_segs = 0;
-	high = 0;
 	for_each_bio(bio) {
 		bio_for_each_segment(bv, bio, iter) {
 			/*
@@ -46,13 +183,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 			if (no_sg_merge)
 				goto new_segment;
 
-			/*
-			 * the trick here is making sure that a high page is
-			 * never considered part of another segment, since
-			 * that might change with the bounce page.
-			 */
-			high = page_to_pfn(bv.bv_page) > queue_bounce_pfn(q);
-			if (!high && !highprv && cluster) {
+			if (prev && cluster) {
 				if (seg_size + bv.bv_len
 				    > queue_max_segment_size(q))
 					goto new_segment;
@@ -72,8 +203,8 @@ new_segment:
 
 			nr_phys_segs++;
 			bvprv = bv;
+			prev = 1;
 			seg_size = bv.bv_len;
-			highprv = high;
 		}
 		bbio = bio;
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index da1ab56..20b3ddb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1259,6 +1259,8 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 		return;
 	}
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (use_plug && !blk_queue_nomerges(q) &&
 	    blk_attempt_plug_merge(q, bio, &request_count))
 		return;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 34f2f0b..dee706d 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1496,6 +1496,8 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	struct drbd_device *device = (struct drbd_device *) q->queuedata;
 	unsigned long start_jif;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	start_jif = jiffies;
 
 	/*
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09e628da..ea10bd9 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2446,6 +2446,10 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	char b[BDEVNAME_SIZE];
 	struct bio *split;
 
+	blk_queue_bounce(q, &bio);
+
+	blk_queue_split(q, &bio, q->bio_split);
+
 	pd = q->queuedata;
 	if (!pd) {
 		pr_err("%s incorrect request queue\n",
@@ -2476,8 +2480,6 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		goto end_io;
 	}
 
-	blk_queue_bounce(q, &bio);
-
 	do {
 		sector_t zone = get_zone(bio->bi_iter.bi_sector, pd);
 		sector_t last_zone = get_zone(bio_end_sector(bio) - 1, pd);
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index ef45cfb..e32e799 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -605,6 +605,8 @@ static void ps3vram_make_request(struct request_queue *q, struct bio *bio)
 
 	dev_dbg(&dev->core, "%s\n", __func__);
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	spin_lock_irq(&priv->lock);
 	busy = !bio_list_empty(&priv->list);
 	bio_list_add(&priv->list, bio);
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index ac8c62c..50ef199 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -148,6 +148,8 @@ static void rsxx_make_request(struct request_queue *q, struct bio *bio)
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
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index bd8bda3..19526d0 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -909,6 +909,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
 
+	blk_queue_split(queue, &bio, queue->bio_split);
+
 	down_read(&zram->init_lock);
 	if (unlikely(!init_done(zram)))
 		goto error;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b98cd9d..fe1e9b7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1680,6 +1680,8 @@ static void dm_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (dm_request_based(md))
 		blk_queue_bio(q, bio);
 	else
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 709755f..48234eb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -249,6 +249,8 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 	struct mddev *mddev = q->queuedata;
 	unsigned int sectors;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (mddev == NULL || mddev->pers == NULL
 	    || !mddev->ready) {
 		bio_io_error(bio);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index b550c8c..658bb7e 100644
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
index 7d4e939..1305ed3 100644
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
index 0312488..fc85916 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -341,6 +341,8 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
 	int rw = bio_rw(old_bio);
 	int inactive;
 
+	blk_queue_split(q, &old_bio, q->bio_split);
+
 	if (!lo)
 		goto err;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9621b73..c03e37a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -484,6 +484,7 @@ struct request_queue {
 
 	struct blk_mq_tag_set	*tag_set;
 	struct list_head	tag_set_list;
+	struct bio_set		*bio_split;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
@@ -807,6 +808,8 @@ extern void blk_rq_unprep_clone(struct request *rq);
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
+extern void blk_queue_split(struct request_queue *, struct bio **,
+			    struct bio_set *);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
-- 
2.1.0

