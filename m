Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3J2UT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:19:57 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55534 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3J2USx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:53 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH 21/23] block: Introduce new bio_split()
Date: Tue, 29 Oct 2013 13:18:14 -0700
Message-Id: <1383077896-4132-22-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new bio_split() can split arbitrary bios - it's not restricted to
single page bios, like the old bio_split() (previously renamed to
bio_pair_split()). It also has different semantics - it doesn't allocate
a struct bio_pair, leaving it up to the caller to handle completions.

Then convert the existing bio_pair_split() users to the new bio_split()
- and also nvme, which was open coding bio splitting.

(We have to take that BUG_ON() out of bio_integrity_trim() because this
bio_split() needs to use it, and there's no reason it has to be used on
bios marked as cloned; BIO_CLONED doesn't seem to have clearly
documented semantics anyways.)

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Neil Brown <neilb@suse.de>
---
 drivers/block/nvme-core.c   | 106 +++-------------------------------
 drivers/block/pktcdvd.c     | 136 ++++++++++++++++++++++++--------------------
 drivers/md/bcache/bcache.h  |   1 -
 drivers/md/bcache/btree.c   |   2 +-
 drivers/md/bcache/io.c      |  82 +-------------------------
 drivers/md/bcache/request.c |   4 +-
 drivers/md/linear.c         |  96 +++++++++++++++----------------
 drivers/md/raid0.c          |  77 +++++++++----------------
 drivers/md/raid10.c         | 113 +++++++++++++++---------------------
 fs/bio.c                    |  73 ++++++++++++++++++++++++
 include/linux/bio.h         |  22 +++++++
 11 files changed, 306 insertions(+), 406 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index b33e52a..ddcb405 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -441,104 +441,19 @@ int nvme_setup_prps(struct nvme_dev *dev, struct nvme_common_command *cmd,
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
-{
-	struct nvme_bio_pair *bp;
-
-	BUG_ON(len > bio->bi_iter.bi_size);
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
-	bp->b1.bi_iter.bi_size = len;
-	bp->b2.bi_iter.bi_size -= len;
-	bp->b1.bi_vcnt = idx;
-	bp->b2.bi_iter.bi_idx = idx;
-	bp->b2.bi_iter.bi_sector += len >> 9;
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
 static int nvme_split_and_submit(struct bio *bio, struct nvme_queue *nvmeq,
-						int idx, int len, int offset)
+				 int len)
 {
-	struct nvme_bio_pair *bp = nvme_bio_split(bio, idx, len, offset);
-	if (!bp)
+	struct bio *split = bio_split(bio, len >> 9, GFP_ATOMIC, NULL);
+	if (!split)
 		return -ENOMEM;
 
+	bio_chain(split, bio);
+
 	if (bio_list_empty(&nvmeq->sq_cong))
 		add_wait_queue(&nvmeq->sq_full, &nvmeq->sq_cong_wait);
-	bio_list_add(&nvmeq->sq_cong, &bp->b1);
-	bio_list_add(&nvmeq->sq_cong, &bp->b2);
+	bio_list_add(&nvmeq->sq_cong, split);
+	bio_list_add(&nvmeq->sq_cong, bio);
 
 	return 0;
 }
@@ -568,8 +483,7 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 		} else {
 			if (!first && BIOVEC_NOT_VIRT_MERGEABLE(&bvprv, &bvec))
 				return nvme_split_and_submit(bio, nvmeq,
-							     iter.bi_idx,
-							     length, 0);
+							     length);
 
 			sg = sg ? sg + 1 : iod->sg;
 			sg_set_page(sg, bvec.bv_page,
@@ -578,9 +492,7 @@ static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 		}
 
 		if (split_len - length < bvec.bv_len)
-			return nvme_split_and_submit(bio, nvmeq, iter.bi_idx,
-						     split_len,
-						     split_len - length);
+			return nvme_split_and_submit(bio, nvmeq, split_len);
 		length += bvec.bv_len;
 		bvprv = bvec;
 		first = 0;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index fa6fa57..1bf1f22 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2352,75 +2352,29 @@ static void pkt_end_io_read_cloned(struct bio *bio, int err)
 	pkt_bio_finished(pd);
 }
 
-static void pkt_make_request(struct request_queue *q, struct bio *bio)
+static void pkt_make_request_read(struct pktcdvd_device *pd, struct bio *bio)
 {
-	struct pktcdvd_device *pd;
-	char b[BDEVNAME_SIZE];
+	struct bio *cloned_bio = bio_clone(bio, GFP_NOIO);
+	struct packet_stacked_data *psd = mempool_alloc(psd_pool, GFP_NOIO);
+
+	psd->pd = pd;
+	psd->bio = bio;
+	cloned_bio->bi_bdev = pd->bdev;
+	cloned_bio->bi_private = psd;
+	cloned_bio->bi_end_io = pkt_end_io_read_cloned;
+	pd->stats.secs_r += bio_sectors(bio);
+	pkt_queue_bio(pd, cloned_bio);
+}
+
+static void pkt_make_request_write(struct request_queue *q, struct bio *bio)
+{
+	struct pktcdvd_device *pd = q->queuedata;
 	sector_t zone;
 	struct packet_data *pkt;
 	int was_empty, blocked_bio;
 	struct pkt_rb_node *node;
 
-	pd = q->queuedata;
-	if (!pd) {
-		pr_err("%s incorrect request queue\n",
-		       bdevname(bio->bi_bdev, b));
-		goto end_io;
-	}
-
-	/*
-	 * Clone READ bios so we can have our own bi_end_io callback.
-	 */
-	if (bio_data_dir(bio) == READ) {
-		struct bio *cloned_bio = bio_clone(bio, GFP_NOIO);
-		struct packet_stacked_data *psd = mempool_alloc(psd_pool, GFP_NOIO);
-
-		psd->pd = pd;
-		psd->bio = bio;
-		cloned_bio->bi_bdev = pd->bdev;
-		cloned_bio->bi_private = psd;
-		cloned_bio->bi_end_io = pkt_end_io_read_cloned;
-		pd->stats.secs_r += bio_sectors(bio);
-		pkt_queue_bio(pd, cloned_bio);
-		return;
-	}
-
-	if (!test_bit(PACKET_WRITABLE, &pd->flags)) {
-		pkt_notice(pd, "WRITE for ro device (%llu)\n",
-			   (unsigned long long)bio->bi_iter.bi_sector);
-		goto end_io;
-	}
-
-	if (!bio->bi_iter.bi_size || (bio->bi_iter.bi_size % CD_FRAMESIZE)) {
-		pkt_err(pd, "wrong bio size\n");
-		goto end_io;
-	}
-
-	blk_queue_bounce(q, &bio);
-
 	zone = get_zone(bio->bi_iter.bi_sector, pd);
-	pkt_dbg(2, pd, "start = %6llx stop = %6llx\n",
-		(unsigned long long)bio->bi_iter.bi_sector,
-		(unsigned long long)bio_end_sector(bio));
-
-	/* Check if we have to split the bio */
-	{
-		struct bio_pair *bp;
-		sector_t last_zone;
-		int first_sectors;
-
-		last_zone = get_zone(bio_end_sector(bio) - 1, pd);
-		if (last_zone != zone) {
-			BUG_ON(last_zone != zone + pd->settings.size);
-			first_sectors = last_zone - bio->bi_iter.bi_sector;
-			bp = bio_pair_split(bio, first_sectors);
-			BUG_ON(!bp);
-			pkt_make_request(q, &bp->bio1);
-			pkt_make_request(q, &bp->bio2);
-			bio_pair_release(bp);
-			return;
-		}
-	}
 
 	/*
 	 * If we find a matching packet in state WAITING or READ_WAIT, we can
@@ -2494,6 +2448,64 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		 */
 		wake_up(&pd->wqueue);
 	}
+}
+
+static void pkt_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct pktcdvd_device *pd;
+	char b[BDEVNAME_SIZE];
+	struct bio *split;
+
+	pd = q->queuedata;
+	if (!pd) {
+		pr_err("%s incorrect request queue\n",
+		       bdevname(bio->bi_bdev, b));
+		goto end_io;
+	}
+
+	pkt_dbg(2, pd, "start = %6llx stop = %6llx\n",
+		(unsigned long long)bio->bi_iter.bi_sector,
+		(unsigned long long)bio_end_sector(bio));
+
+	/*
+	 * Clone READ bios so we can have our own bi_end_io callback.
+	 */
+	if (bio_data_dir(bio) == READ) {
+		pkt_make_request_read(pd, bio);
+		return;
+	}
+
+	if (!test_bit(PACKET_WRITABLE, &pd->flags)) {
+		pkt_notice(pd, "WRITE for ro device (%llu)\n",
+			   (unsigned long long)bio->bi_iter.bi_sector);
+		goto end_io;
+	}
+
+	if (!bio->bi_iter.bi_size || (bio->bi_iter.bi_size % CD_FRAMESIZE)) {
+		pkt_err(pd, "wrong bio size\n");
+		goto end_io;
+	}
+
+	blk_queue_bounce(q, &bio);
+
+	do {
+		sector_t zone = get_zone(bio->bi_iter.bi_sector, pd);
+		sector_t last_zone = get_zone(bio_end_sector(bio) - 1, pd);
+
+		if (last_zone != zone) {
+			BUG_ON(last_zone != zone + pd->settings.size);
+
+			split = bio_split(bio, last_zone -
+					  bio->bi_iter.bi_sector,
+					  GFP_NOIO, fs_bio_set);
+			bio_chain(split, bio);
+		} else {
+			split = bio;
+		}
+
+		pkt_make_request_write(q, split);
+	} while (split != bio);
+
 	return;
 end_io:
 	bio_io_error(bio);
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 206c82b..a2025bd 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1163,7 +1163,6 @@ void bch_bbio_endio(struct cache_set *, struct bio *, int, const char *);
 void bch_bbio_free(struct bio *, struct cache_set *);
 struct bio *bch_bbio_alloc(struct cache_set *);
 
-struct bio *bch_bio_split(struct bio *, int, gfp_t, struct bio_set *);
 void bch_generic_make_request(struct bio *, struct bio_split_pool *);
 void __bch_submit_bbio(struct bio *, struct cache_set *);
 void bch_submit_bbio(struct bio *, struct cache_set *, struct bkey *, unsigned);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 1f62482..2885921 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2204,7 +2204,7 @@ static int submit_partial_cache_hit(struct btree *b, struct btree_op *op,
 		unsigned sectors = min_t(uint64_t, INT_MAX,
 				KEY_OFFSET(k) - bio->bi_iter.bi_sector);
 
-		n = bch_bio_split(bio, sectors, GFP_NOIO, s->d->bio_split);
+		n = bio_next_split(bio, sectors, GFP_NOIO, s->d->bio_split);
 		if (n == bio)
 			op->lookup_done = true;
 
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 522f957..fa028fa 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -11,84 +11,6 @@
 
 #include <linux/blkdev.h>
 
-/**
- * bch_bio_split - split a bio
- * @bio:	bio to split
- * @sectors:	number of sectors to split from the front of @bio
- * @gfp:	gfp mask
- * @bs:		bio set to allocate from
- *
- * Allocates and returns a new bio which represents @sectors from the start of
- * @bio, and updates @bio to represent the remaining sectors.
- *
- * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
- * unchanged.
- *
- * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
- * bvec boundry; it is the caller's responsibility to ensure that @bio is not
- * freed before the split.
- */
-struct bio *bch_bio_split(struct bio *bio, int sectors,
-			  gfp_t gfp, struct bio_set *bs)
-{
-	unsigned vcnt = 0, nbytes = sectors << 9;
-	struct bio_vec bv;
-	struct bvec_iter iter;
-	struct bio *ret = NULL;
-
-	BUG_ON(sectors <= 0);
-
-	if (sectors >= bio_sectors(bio))
-		return bio;
-
-	if (bio->bi_rw & REQ_DISCARD) {
-		ret = bio_alloc_bioset(gfp, 1, bs);
-		if (!ret)
-			return NULL;
-		goto out;
-	}
-
-	bio_for_each_segment(bv, bio, iter) {
-		vcnt++;
-
-		if (nbytes <= bv.bv_len)
-			break;
-
-		nbytes -= bv.bv_len;
-	}
-
-	ret = bio_alloc_bioset(gfp, vcnt, bs);
-	if (!ret)
-		return NULL;
-
-	bio_for_each_segment(bv, bio, iter) {
-		ret->bi_io_vec[ret->bi_vcnt++] = bv;
-
-		if (ret->bi_vcnt == vcnt)
-			break;
-	}
-
-	ret->bi_io_vec[ret->bi_vcnt - 1].bv_len = nbytes;
-out:
-	ret->bi_bdev	= bio->bi_bdev;
-	ret->bi_iter.bi_sector	= bio->bi_iter.bi_sector;
-	ret->bi_iter.bi_size	= sectors << 9;
-	ret->bi_rw	= bio->bi_rw;
-
-	if (bio_integrity(bio)) {
-		if (bio_integrity_clone(ret, bio, gfp)) {
-			bio_put(ret);
-			return NULL;
-		}
-
-		bio_integrity_trim(ret, 0, bio_sectors(ret));
-	}
-
-	bio_advance(bio, ret->bi_iter.bi_size);
-
-	return ret;
-}
-
 static unsigned bch_bio_max_sectors(struct bio *bio)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
@@ -172,8 +94,8 @@ void bch_generic_make_request(struct bio *bio, struct bio_split_pool *p)
 	bio_get(bio);
 
 	do {
-		n = bch_bio_split(bio, bch_bio_max_sectors(bio),
-				  GFP_NOIO, s->p->bio_split);
+		n = bio_next_split(bio, bch_bio_max_sectors(bio),
+				   GFP_NOIO, s->p->bio_split);
 
 		n->bi_end_io	= bch_bio_submit_split_endio;
 		n->bi_private	= &s->cl;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 4473a6f..417b37b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -514,7 +514,7 @@ static void bch_insert_data_loop(struct closure *cl)
 		if (!bch_alloc_sectors(k, bio_sectors(bio), s))
 			goto err;
 
-		n = bch_bio_split(bio, KEY_SIZE(k), GFP_NOIO, split);
+		n = bio_next_split(bio, KEY_SIZE(k), GFP_NOIO, split);
 
 		n->bi_end_io	= bch_insert_data_endio;
 		n->bi_private	= cl;
@@ -854,7 +854,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 	struct bio *miss;
 
-	miss = bch_bio_split(bio, sectors, GFP_NOIO, s->d->bio_split);
+	miss = bio_next_split(bio, sectors, GFP_NOIO, s->d->bio_split);
 	if (miss == bio)
 		s->op.lookup_done = true;
 
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index e9b53e9..56f534b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -288,65 +288,65 @@ static int linear_stop (struct mddev *mddev)
 
 static void linear_make_request(struct mddev *mddev, struct bio *bio)
 {
+	char b[BDEVNAME_SIZE];
 	struct dev_info *tmp_dev;
-	sector_t start_sector;
+	struct bio *split;
+	sector_t start_sector, end_sector, data_offset;
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
 
-	rcu_read_lock();
-	tmp_dev = which_dev(mddev, bio->bi_iter.bi_sector);
-	start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
-
-
-	if (unlikely(bio->bi_iter.bi_sector >= (tmp_dev->end_sector)
-		     || (bio->bi_iter.bi_sector < start_sector))) {
-		char b[BDEVNAME_SIZE];
-
-		printk(KERN_ERR
-		       "md/linear:%s: make_request: Sector %llu out of bounds on "
-		       "dev %s: %llu sectors, offset %llu\n",
-		       mdname(mddev),
-		       (unsigned long long)bio->bi_iter.bi_sector,
-		       bdevname(tmp_dev->rdev->bdev, b),
-		       (unsigned long long)tmp_dev->rdev->sectors,
-		       (unsigned long long)start_sector);
-		rcu_read_unlock();
-		bio_io_error(bio);
-		return;
-	}
-	if (unlikely(bio_end_sector(bio) > tmp_dev->end_sector)) {
-		/* This bio crosses a device boundary, so we have to
-		 * split it.
-		 */
-		struct bio_pair *bp;
-		sector_t end_sector = tmp_dev->end_sector;
+	do {
+		rcu_read_lock();
 
-		rcu_read_unlock();
-
-		bp = bio_pair_split(bio, end_sector - bio->bi_iter.bi_sector);
+		tmp_dev = which_dev(mddev, bio->bi_iter.bi_sector);
+		start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
+		end_sector = tmp_dev->end_sector;
+		data_offset = tmp_dev->rdev->data_offset;
+		bio->bi_bdev = tmp_dev->rdev->bdev;
 
-		linear_make_request(mddev, &bp->bio1);
-		linear_make_request(mddev, &bp->bio2);
-		bio_pair_release(bp);
-		return;
-	}
-		    
-	bio->bi_bdev = tmp_dev->rdev->bdev;
-	bio->bi_iter.bi_sector = bio->bi_iter.bi_sector - start_sector
-		+ tmp_dev->rdev->data_offset;
-	rcu_read_unlock();
+		rcu_read_unlock();
 
-	if (unlikely((bio->bi_rw & REQ_DISCARD) &&
-		     !blk_queue_discard(bdev_get_queue(bio->bi_bdev)))) {
-		/* Just ignore it */
-		bio_endio(bio, 0);
-		return;
-	}
+		if (unlikely(bio->bi_iter.bi_sector >= end_sector ||
+			     bio->bi_iter.bi_sector < start_sector))
+			goto out_of_bounds;
+
+		if (unlikely(bio_end_sector(bio) > end_sector)) {
+			/* This bio crosses a device boundary, so we have to
+			 * split it.
+			 */
+			split = bio_split(bio, end_sector -
+					  bio->bi_iter.bi_sector,
+					  GFP_NOIO, fs_bio_set);
+			bio_chain(split, bio);
+		} else {
+			split = bio;
+		}
 
-	generic_make_request(bio);
+		split->bi_iter.bi_sector = split->bi_iter.bi_sector -
+			start_sector + data_offset;
+
+		if (unlikely((split->bi_rw & REQ_DISCARD) &&
+			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
+			/* Just ignore it */
+			bio_endio(split, 0);
+		} else
+			generic_make_request(split);
+	} while (split != bio);
+	return;
+
+out_of_bounds:
+	printk(KERN_ERR
+	       "md/linear:%s: make_request: Sector %llu out of bounds on "
+	       "dev %s: %llu sectors, offset %llu\n",
+	       mdname(mddev),
+	       (unsigned long long)bio->bi_iter.bi_sector,
+	       bdevname(tmp_dev->rdev->bdev, b),
+	       (unsigned long long)tmp_dev->rdev->sectors,
+	       (unsigned long long)start_sector);
+	bio_io_error(bio);
 }
 
 static void linear_status (struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ea754dd..407a99e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -513,65 +513,44 @@ static inline int is_io_in_chunk_boundary(struct mddev *mddev,
 
 static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 {
-	unsigned int chunk_sects;
-	sector_t sector_offset;
 	struct strip_zone *zone;
 	struct md_rdev *tmp_dev;
+	struct bio *split;
 
 	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
 
-	chunk_sects = mddev->chunk_sectors;
-	if (unlikely(!is_io_in_chunk_boundary(mddev, chunk_sects, bio))) {
+	do {
 		sector_t sector = bio->bi_iter.bi_sector;
-		struct bio_pair *bp;
-		/* Sanity check -- queue functions should prevent this happening */
-		if (bio_multiple_segments(bio))
-			goto bad_map;
-		/* This is a one page bio that upper layers
-		 * refuse to split for us, so we need to split it.
-		 */
-		if (likely(is_power_of_2(chunk_sects)))
-			bp = bio_pair_split(bio, chunk_sects - (sector &
-							   (chunk_sects-1)));
-		else
-			bp = bio_pair_split(bio, chunk_sects -
-					    sector_div(sector, chunk_sects));
-		raid0_make_request(mddev, &bp->bio1);
-		raid0_make_request(mddev, &bp->bio2);
-		bio_pair_release(bp);
-		return;
-	}
-
-	sector_offset = bio->bi_iter.bi_sector;
-	zone = find_zone(mddev->private, &sector_offset);
-	tmp_dev = map_sector(mddev, zone, bio->bi_iter.bi_sector,
-			     &sector_offset);
-	bio->bi_bdev = tmp_dev->bdev;
-	bio->bi_iter.bi_sector = sector_offset + zone->dev_start +
-		tmp_dev->data_offset;
-
-	if (unlikely((bio->bi_rw & REQ_DISCARD) &&
-		     !blk_queue_discard(bdev_get_queue(bio->bi_bdev)))) {
-		/* Just ignore it */
-		bio_endio(bio, 0);
-		return;
-	}
-
-	generic_make_request(bio);
-	return;
-
-bad_map:
-	printk("md/raid0:%s: make_request bug: can't convert block across chunks"
-	       " or bigger than %dk %llu %d\n",
-	       mdname(mddev), chunk_sects / 2,
-	       (unsigned long long)bio->bi_iter.bi_sector,
-	       bio_sectors(bio) / 2);
+		unsigned chunk_sects = mddev->chunk_sectors;
+
+		unsigned sectors = chunk_sects -
+			(likely(is_power_of_2(chunk_sects))
+			 ? (sector & (chunk_sects-1))
+			 : sector_div(sector, chunk_sects));
+
+		if (sectors < bio_sectors(bio)) {
+			split = bio_split(bio, sectors, GFP_NOIO, fs_bio_set);
+			bio_chain(split, bio);
+		} else {
+			split = bio;
+		}
 
-	bio_io_error(bio);
-	return;
+		zone = find_zone(mddev->private, &sector);
+		tmp_dev = map_sector(mddev, zone, sector, &sector);
+		split->bi_bdev = tmp_dev->bdev;
+		split->bi_iter.bi_sector = sector + zone->dev_start +
+			tmp_dev->data_offset;
+
+		if (unlikely((split->bi_rw & REQ_DISCARD) &&
+			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
+			/* Just ignore it */
+			bio_endio(split, 0);
+		} else
+			generic_make_request(split);
+	} while (split != bio);
 }
 
 static void raid0_status(struct seq_file *seq, struct mddev *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7e49cbe..9870e45 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1152,14 +1152,12 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	kfree(plug);
 }
 
-static void make_request(struct mddev *mddev, struct bio * bio)
+static void __make_request(struct mddev *mddev, struct bio *bio)
 {
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 	struct bio *read_bio;
 	int i;
-	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
-	int chunk_sects = chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
 	const unsigned long do_fua = (bio->bi_rw & REQ_FUA);
@@ -1174,69 +1172,6 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	int max_sectors;
 	int sectors;
 
-	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
-		md_flush_request(mddev, bio);
-		return;
-	}
-
-	/* If this request crosses a chunk boundary, we need to
-	 * split it.  This will only happen for 1 PAGE (or less) requests.
-	 */
-	if (unlikely((bio->bi_iter.bi_sector & chunk_mask) + bio_sectors(bio)
-		     > chunk_sects
-		     && (conf->geo.near_copies < conf->geo.raid_disks
-			 || conf->prev.near_copies < conf->prev.raid_disks))) {
-		struct bio_pair *bp;
-		/* Sanity check -- queue functions should prevent this happening */
-		if (bio_multiple_segments(bio))
-			goto bad_map;
-		/* This is a one page bio that upper layers
-		 * refuse to split for us, so we need to split it.
-		 */
-		bp = bio_pair_split(bio, chunk_sects -
-			       (bio->bi_iter.bi_sector & (chunk_sects - 1)));
-
-		/* Each of these 'make_request' calls will call 'wait_barrier'.
-		 * If the first succeeds but the second blocks due to the resync
-		 * thread raising the barrier, we will deadlock because the
-		 * IO to the underlying device will be queued in generic_make_request
-		 * and will never complete, so will never reduce nr_pending.
-		 * So increment nr_waiting here so no new raise_barriers will
-		 * succeed, and so the second wait_barrier cannot block.
-		 */
-		spin_lock_irq(&conf->resync_lock);
-		conf->nr_waiting++;
-		spin_unlock_irq(&conf->resync_lock);
-
-		make_request(mddev, &bp->bio1);
-		make_request(mddev, &bp->bio2);
-
-		spin_lock_irq(&conf->resync_lock);
-		conf->nr_waiting--;
-		wake_up(&conf->wait_barrier);
-		spin_unlock_irq(&conf->resync_lock);
-
-		bio_pair_release(bp);
-		return;
-	bad_map:
-		printk("md/raid10:%s: make_request bug: can't convert block across chunks"
-		       " or bigger than %dk %llu %d\n", mdname(mddev), chunk_sects/2,
-		       (unsigned long long)bio->bi_iter.bi_sector,
-		       bio_sectors(bio) / 2);
-
-		bio_io_error(bio);
-		return;
-	}
-
-	md_write_start(mddev, bio);
-
-	/*
-	 * Register the new request and wait if the reconstruction
-	 * thread has put up a bar for new requests.
-	 * Continue immediately if no resync is active currently.
-	 */
-	wait_barrier(conf);
-
 	sectors = bio_sectors(bio);
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
@@ -1600,6 +1535,52 @@ retry_write:
 		goto retry_write;
 	}
 	one_write_done(r10_bio);
+}
+
+static void make_request(struct mddev *mddev, struct bio *bio)
+{
+	struct r10conf *conf = mddev->private;
+	sector_t chunk_mask = (conf->geo.chunk_mask & conf->prev.chunk_mask);
+	int chunk_sects = chunk_mask + 1;
+
+	struct bio *split;
+
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
+		return;
+	}
+
+	md_write_start(mddev, bio);
+
+	/*
+	 * Register the new request and wait if the reconstruction
+	 * thread has put up a bar for new requests.
+	 * Continue immediately if no resync is active currently.
+	 */
+	wait_barrier(conf);
+
+	do {
+
+		/*
+		 * If this request crosses a chunk boundary, we need to split
+		 * it.
+		 */
+		if (unlikely((bio->bi_iter.bi_sector & chunk_mask) +
+			     bio_sectors(bio) > chunk_sects
+			     && (conf->geo.near_copies < conf->geo.raid_disks
+				 || conf->prev.near_copies <
+				 conf->prev.raid_disks))) {
+			split = bio_split(bio, chunk_sects -
+					  (bio->bi_iter.bi_sector &
+					   (chunk_sects - 1)),
+					  GFP_NOIO, fs_bio_set);
+			bio_chain(split, bio);
+		} else {
+			split = bio;
+		}
+
+		__make_request(mddev, split);
+	} while (split != bio);
 
 	/* In case raid10d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
diff --git a/fs/bio.c b/fs/bio.c
index 663c944..a840f08 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1758,6 +1758,79 @@ void bio_endio_nodec(struct bio *bio, int error)
 }
 EXPORT_SYMBOL(bio_endio_nodec);
 
+/**
+ * bio_split - split a bio
+ * @bio:	bio to split
+ * @sectors:	number of sectors to split from the front of @bio
+ * @gfp:	gfp mask
+ * @bs:		bio set to allocate from
+ *
+ * Allocates and returns a new bio which represents @sectors from the start of
+ * @bio, and updates @bio to represent the remaining sectors.
+ *
+ * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
+ * unchanged.
+ */
+struct bio *bio_split(struct bio *bio, int sectors,
+		      gfp_t gfp, struct bio_set *bs)
+{
+	unsigned vcnt = 0, nbytes = sectors << 9;
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	struct bio *split = NULL;
+
+	BUG_ON(sectors <= 0);
+	BUG_ON(sectors >= bio_sectors(bio));
+
+	if (bio->bi_rw & REQ_DISCARD) {
+		split = bio_alloc_bioset(gfp, 1, bs);
+		if (!split)
+			return NULL;
+		goto out;
+	}
+
+	bio_for_each_segment(bv, bio, iter) {
+		vcnt++;
+
+		if (nbytes <= bv.bv_len)
+			break;
+
+		nbytes -= bv.bv_len;
+	}
+
+	split = bio_alloc_bioset(gfp, vcnt, bs);
+	if (!split)
+		return NULL;
+
+	bio_for_each_segment(bv, bio, iter) {
+		split->bi_io_vec[split->bi_vcnt++] = bv;
+
+		if (split->bi_vcnt == vcnt)
+			break;
+	}
+
+	split->bi_io_vec[split->bi_vcnt - 1].bv_len = nbytes;
+out:
+	split->bi_bdev		= bio->bi_bdev;
+	split->bi_iter.bi_sector = bio->bi_iter.bi_sector;
+	split->bi_iter.bi_size	= sectors << 9;
+	split->bi_rw		= bio->bi_rw;
+
+	if (bio_integrity(bio)) {
+		if (bio_integrity_clone(split, bio, gfp)) {
+			bio_put(split);
+			return NULL;
+		}
+
+		bio_integrity_trim(split, 0, bio_sectors(split));
+	}
+
+	bio_advance(bio, split->bi_iter.bi_size);
+
+	return split;
+}
+EXPORT_SYMBOL(bio_split);
+
 void bio_pair_release(struct bio_pair *bp)
 {
 	if (atomic_dec_and_test(&bp->cnt)) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 228a4e7..157f068 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -321,6 +321,28 @@ extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 extern void bio_trim(struct bio *bio, int offset, int size);
 
+extern struct bio *bio_split(struct bio *bio, int sectors,
+			     gfp_t gfp, struct bio_set *bs);
+
+/**
+ * bio_next_split - get next @sectors from a bio, splitting if necessary
+ * @bio:	bio to split
+ * @sectors:	number of sectors to split from the front of @bio
+ * @gfp:	gfp mask
+ * @bs:		bio set to allocate from
+ *
+ * Returns a bio representing the next @sectors of @bio - if the bio is smaller
+ * than @sectors, returns the original bio unchanged.
+ */
+static inline struct bio *bio_next_split(struct bio *bio, int sectors,
+					 gfp_t gfp, struct bio_set *bs)
+{
+	if (sectors >= bio_sectors(bio))
+		return bio;
+
+	return bio_split(bio, sectors, gfp, bs);
+}
+
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
 extern mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries);
-- 
1.8.4.rc3

