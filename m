Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaLVLuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:50:52 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38580 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbaLVLug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:36 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        drbd-dev@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>,
        Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ming Lei <ming.lei@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [RFC PATCH 14/17] block: kill merge_bvec_fn() completely
Date: Mon, 22 Dec 2014 12:48:41 +0100
Message-Id: <a7118fb6a3353958a19f4d848472da2de76de238.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e35d37b66d621c51f2eb24ff024291bd1d53422e.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
 <d42dae3d2a64fa4c3a0893f1af963151b31869e3.1419241597.git.dongsu.park@profitbricks.com>
 <4334b90a56b96ad7a11e4ba7eb97c2cf4405950d.1419241597.git.dongsu.park@profitbricks.com>
 <abe647cf7cf272220227fad4dac9c43641192f01.1419241597.git.dongsu.park@profitbricks.com>
 <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
 <e35d37b66d621c51f2eb24ff024291bd1d53422e.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

As generic_make_request() is now able to handle arbitrarily sized bios,
it's no longer necessary for each individual block driver to define its
own ->merge_bvec_fn() callback. Remove every invocation completely.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: also remove ->merge_bvec_fn() in dm-thin as well as
 dm-era-target, and resolve merge conflicts]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Yehuda Sadeh <yehuda@inktank.com>
Cc: Sage Weil <sage@inktank.com>
Cc: Alex Elder <elder@kernel.org>
Cc: ceph-devel@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 block/blk-merge.c              |  17 +-----
 block/blk-settings.c           |  22 --------
 drivers/block/drbd/drbd_int.h  |   1 -
 drivers/block/drbd/drbd_main.c |   1 -
 drivers/block/drbd/drbd_req.c  |  35 ------------
 drivers/block/pktcdvd.c        |  21 -------
 drivers/block/rbd.c            |  47 ----------------
 drivers/md/dm-cache-target.c   |  21 -------
 drivers/md/dm-crypt.c          |  16 ------
 drivers/md/dm-era-target.c     |  15 -----
 drivers/md/dm-flakey.c         |  16 ------
 drivers/md/dm-linear.c         |  16 ------
 drivers/md/dm-snap.c           |  15 -----
 drivers/md/dm-stripe.c         |  21 -------
 drivers/md/dm-table.c          |   8 ---
 drivers/md/dm-thin.c           |  31 -----------
 drivers/md/dm-verity.c         |  16 ------
 drivers/md/dm.c                | 120 +---------------------------------------
 drivers/md/dm.h                |   2 -
 drivers/md/linear.c            |  46 ----------------
 drivers/md/md.c                |   2 -
 drivers/md/md.h                |   8 ---
 drivers/md/multipath.c         |  21 -------
 drivers/md/raid0.c             |  57 -------------------
 drivers/md/raid0.h             |   2 -
 drivers/md/raid1.c             |  59 +-------------------
 drivers/md/raid10.c            | 122 +----------------------------------------
 drivers/md/raid5.c             |  28 ----------
 include/linux/blkdev.h         |  10 ----
 include/linux/device-mapper.h  |   4 --
 30 files changed, 9 insertions(+), 791 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3bc2068..8cd7a83 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -69,24 +69,13 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 	struct bio *split;
 	struct bio_vec bv = { 0 }, bvprv = { 0 };
 	struct bvec_iter iter;
-	unsigned seg_size = 0, nsegs = 0;
+	unsigned seg_size = 0, nsegs = 0, sectors = 0;
 	int prev = 0;
 
-	struct bvec_merge_data bvm = {
-		.bi_bdev	= bio->bi_bdev,
-		.bi_sector	= bio->bi_iter.bi_sector,
-		.bi_size	= 0,
-		.bi_rw		= bio->bi_rw,
-	};
-
 	bio_for_each_segment(bv, bio, iter) {
-		if (q->merge_bvec_fn &&
-		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
-			goto split;
-
-		bvm.bi_size += bv.bv_len;
+		sectors += bv.bv_len >> 9;
 
-		if (bvm.bi_size >> 9 > queue_max_sectors(q))
+		if (sectors > queue_max_sectors(q))
 			goto split;
 
 		if (prev && blk_queue_cluster(q)) {
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 6ed2cbe..463a10a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -53,28 +53,6 @@ void blk_queue_unprep_rq(struct request_queue *q, unprep_rq_fn *ufn)
 }
 EXPORT_SYMBOL(blk_queue_unprep_rq);
 
-/**
- * blk_queue_merge_bvec - set a merge_bvec function for queue
- * @q:		queue
- * @mbfn:	merge_bvec_fn
- *
- * Usually queues have static limitations on the max sectors or segments that
- * we can put in a request. Stacking drivers may have some settings that
- * are dynamic, and thus we have to query the queue whether it is ok to
- * add a new bio_vec to a bio at a given offset or not. If the block device
- * has such limitations, it needs to register a merge_bvec_fn to control
- * the size of bio's sent to it. Note that a block device *must* allow a
- * single page to be added to an empty bio. The block device driver may want
- * to use the bio_split() function to deal with these bio's. By default
- * no merge_bvec_fn is defined for a queue, and only the fixed limits are
- * honored.
- */
-void blk_queue_merge_bvec(struct request_queue *q, merge_bvec_fn *mbfn)
-{
-	q->merge_bvec_fn = mbfn;
-}
-EXPORT_SYMBOL(blk_queue_merge_bvec);
-
 void blk_queue_softirq_done(struct request_queue *q, softirq_done_fn *fn)
 {
 	q->softirq_done_fn = fn;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b905e98..63ce2b0 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1449,7 +1449,6 @@ extern void do_submit(struct work_struct *ws);
 extern void __drbd_make_request(struct drbd_device *, struct bio *, unsigned long);
 extern void drbd_make_request(struct request_queue *q, struct bio *bio);
 extern int drbd_read_remote(struct drbd_device *device, struct drbd_request *req);
-extern int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec);
 extern int is_valid_ar_handle(struct drbd_request *, sector_t);
 
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1fc8342..f49f53e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2775,7 +2775,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	   This triggers a max_bio_size message upon first attach or connect */
 	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
-	blk_queue_merge_bvec(q, drbd_merge_bvec);
 	q->queue_lock = &resource->req_lock;
 
 	device->md_io.page = alloc_page(GFP_KERNEL);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index dee706d..b57d30b 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1509,41 +1509,6 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	__drbd_make_request(device, bio, start_jif);
 }
 
-/* This is called by bio_add_page().
- *
- * q->max_hw_sectors and other global limits are already enforced there.
- *
- * We need to call down to our lower level device,
- * in case it has special restrictions.
- *
- * We also may need to enforce configured max-bio-bvecs limits.
- *
- * As long as the BIO is empty we have to allow at least one bvec,
- * regardless of size and offset, so no need to ask lower levels.
- */
-int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec)
-{
-	struct drbd_device *device = (struct drbd_device *) q->queuedata;
-	unsigned int bio_size = bvm->bi_size;
-	int limit = DRBD_MAX_BIO_SIZE;
-	int backing_limit;
-
-	if (bio_size && get_ldev(device)) {
-		unsigned int max_hw_sectors = queue_max_hw_sectors(q);
-		struct request_queue * const b =
-			device->ldev->backing_bdev->bd_disk->queue;
-		if (b->merge_bvec_fn) {
-			bvm->bi_bdev = device->ldev->backing_bdev;
-			backing_limit = b->merge_bvec_fn(b, bvm, bvec);
-			limit = min(limit, backing_limit);
-		}
-		put_ldev(device);
-		if ((limit >> 9) > max_hw_sectors)
-			limit = max_hw_sectors << 9;
-	}
-	return limit;
-}
-
 void request_timer_fn(unsigned long data)
 {
 	struct drbd_device *device = (struct drbd_device *) data;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ea10bd9..85eac23 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2505,26 +2505,6 @@ end_io:
 
 
 
-static int pkt_merge_bvec(struct request_queue *q, struct bvec_merge_data *bmd,
-			  struct bio_vec *bvec)
-{
-	struct pktcdvd_device *pd = q->queuedata;
-	sector_t zone = get_zone(bmd->bi_sector, pd);
-	int used = ((bmd->bi_sector - zone) << 9) + bmd->bi_size;
-	int remaining = (pd->settings.size << 9) - used;
-	int remaining2;
-
-	/*
-	 * A bio <= PAGE_SIZE must be allowed. If it crosses a packet
-	 * boundary, pkt_make_request() will split the bio.
-	 */
-	remaining2 = PAGE_SIZE - bmd->bi_size;
-	remaining = max(remaining, remaining2);
-
-	BUG_ON(remaining < 0);
-	return remaining;
-}
-
 static void pkt_init_queue(struct pktcdvd_device *pd)
 {
 	struct request_queue *q = pd->disk->queue;
@@ -2532,7 +2512,6 @@ static void pkt_init_queue(struct pktcdvd_device *pd)
 	blk_queue_make_request(q, pkt_make_request);
 	blk_queue_logical_block_size(q, CD_FRAMESIZE);
 	blk_queue_max_hw_sectors(q, PACKET_MAX_SECTORS);
-	blk_queue_merge_bvec(q, pkt_merge_bvec);
 	q->queuedata = pd;
 }
 
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3ec85df..0c0e2d0 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3459,52 +3459,6 @@ static void rbd_request_fn(struct request_queue *q)
 		queue_work(rbd_wq, &rbd_dev->rq_work);
 }
 
-/*
- * a queue callback. Makes sure that we don't create a bio that spans across
- * multiple osd objects. One exception would be with a single page bios,
- * which we handle later at bio_chain_clone_range()
- */
-static int rbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bmd,
-			  struct bio_vec *bvec)
-{
-	struct rbd_device *rbd_dev = q->queuedata;
-	sector_t sector_offset;
-	sector_t sectors_per_obj;
-	sector_t obj_sector_offset;
-	int ret;
-
-	/*
-	 * Find how far into its rbd object the partition-relative
-	 * bio start sector is to offset relative to the enclosing
-	 * device.
-	 */
-	sector_offset = get_start_sect(bmd->bi_bdev) + bmd->bi_sector;
-	sectors_per_obj = 1 << (rbd_dev->header.obj_order - SECTOR_SHIFT);
-	obj_sector_offset = sector_offset & (sectors_per_obj - 1);
-
-	/*
-	 * Compute the number of bytes from that offset to the end
-	 * of the object.  Account for what's already used by the bio.
-	 */
-	ret = (int) (sectors_per_obj - obj_sector_offset) << SECTOR_SHIFT;
-	if (ret > bmd->bi_size)
-		ret -= bmd->bi_size;
-	else
-		ret = 0;
-
-	/*
-	 * Don't send back more than was asked for.  And if the bio
-	 * was empty, let the whole thing through because:  "Note
-	 * that a block device *must* allow a single page to be
-	 * added to an empty bio."
-	 */
-	rbd_assert(bvec->bv_len <= PAGE_SIZE);
-	if (ret > (int) bvec->bv_len || !bmd->bi_size)
-		ret = (int) bvec->bv_len;
-
-	return ret;
-}
-
 static void rbd_free_disk(struct rbd_device *rbd_dev)
 {
 	struct gendisk *disk = rbd_dev->disk;
@@ -3771,7 +3725,6 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	q->limits.max_discard_sectors = segment_size / SECTOR_SIZE;
 	q->limits.discard_zeroes_data = 1;
 
-	blk_queue_merge_bvec(q, rbd_merge_bvec);
 	disk->queue = q;
 
 	q->queuedata = rbd_dev;
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1e96d78..72fd9d3 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3277,26 +3277,6 @@ static int cache_iterate_devices(struct dm_target *ti,
 	return r;
 }
 
-/*
- * We assume I/O is going to the origin (which is the volume
- * more likely to have restrictions e.g. by being striped).
- * (Looking up the exact location of the data would be expensive
- * and could always be out of date by the time the bio is submitted.)
- */
-static int cache_bvec_merge(struct dm_target *ti,
-			    struct bvec_merge_data *bvm,
-			    struct bio_vec *biovec, int max_size)
-{
-	struct cache *cache = ti->private;
-	struct request_queue *q = bdev_get_queue(cache->origin_dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = cache->origin_dev->bdev;
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static void set_discard_limits(struct cache *cache, struct queue_limits *limits)
 {
 	/*
@@ -3340,7 +3320,6 @@ static struct target_type cache_target = {
 	.status = cache_status,
 	.message = cache_message,
 	.iterate_devices = cache_iterate_devices,
-	.merge = cache_bvec_merge,
 	.io_hints = cache_io_hints,
 };
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 08981be..723c176 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1951,21 +1951,6 @@ error:
 	return -EINVAL;
 }
 
-static int crypt_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-		       struct bio_vec *biovec, int max_size)
-{
-	struct crypt_config *cc = ti->private;
-	struct request_queue *q = bdev_get_queue(cc->dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = cc->dev->bdev;
-	bvm->bi_sector = cc->start + dm_target_offset(ti, bvm->bi_sector);
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static int crypt_iterate_devices(struct dm_target *ti,
 				 iterate_devices_callout_fn fn, void *data)
 {
@@ -1986,7 +1971,6 @@ static struct target_type crypt_target = {
 	.preresume = crypt_preresume,
 	.resume = crypt_resume,
 	.message = crypt_message,
-	.merge  = crypt_merge,
 	.iterate_devices = crypt_iterate_devices,
 };
 
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index ad913cd..0119ebf 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1673,20 +1673,6 @@ static int era_iterate_devices(struct dm_target *ti,
 	return fn(ti, era->origin_dev, 0, get_dev_size(era->origin_dev), data);
 }
 
-static int era_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-		     struct bio_vec *biovec, int max_size)
-{
-	struct era *era = ti->private;
-	struct request_queue *q = bdev_get_queue(era->origin_dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = era->origin_dev->bdev;
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static void era_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct era *era = ti->private;
@@ -1717,7 +1703,6 @@ static struct target_type era_target = {
 	.status = era_status,
 	.message = era_message,
 	.iterate_devices = era_iterate_devices,
-	.merge = era_merge,
 	.io_hints = era_io_hints
 };
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b257e46..d955b3e 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -387,21 +387,6 @@ static int flakey_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long ar
 	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
 }
 
-static int flakey_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-			struct bio_vec *biovec, int max_size)
-{
-	struct flakey_c *fc = ti->private;
-	struct request_queue *q = bdev_get_queue(fc->dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = fc->dev->bdev;
-	bvm->bi_sector = flakey_map_sector(ti, bvm->bi_sector);
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static int flakey_iterate_devices(struct dm_target *ti, iterate_devices_callout_fn fn, void *data)
 {
 	struct flakey_c *fc = ti->private;
@@ -419,7 +404,6 @@ static struct target_type flakey_target = {
 	.end_io = flakey_end_io,
 	.status = flakey_status,
 	.ioctl	= flakey_ioctl,
-	.merge	= flakey_merge,
 	.iterate_devices = flakey_iterate_devices,
 };
 
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 53e848c..7dd5fc8 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -130,21 +130,6 @@ static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
 	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
 }
 
-static int linear_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-			struct bio_vec *biovec, int max_size)
-{
-	struct linear_c *lc = ti->private;
-	struct request_queue *q = bdev_get_queue(lc->dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = lc->dev->bdev;
-	bvm->bi_sector = linear_map_sector(ti, bvm->bi_sector);
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static int linear_iterate_devices(struct dm_target *ti,
 				  iterate_devices_callout_fn fn, void *data)
 {
@@ -162,7 +147,6 @@ static struct target_type linear_target = {
 	.map    = linear_map,
 	.status = linear_status,
 	.ioctl  = linear_ioctl,
-	.merge  = linear_merge,
 	.iterate_devices = linear_iterate_devices,
 };
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 864b03f..2e6bb7e 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2234,20 +2234,6 @@ static void origin_status(struct dm_target *ti, status_type_t type,
 	}
 }
 
-static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-			struct bio_vec *biovec, int max_size)
-{
-	struct dm_origin *o = ti->private;
-	struct request_queue *q = bdev_get_queue(o->dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = o->dev->bdev;
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static int origin_iterate_devices(struct dm_target *ti,
 				  iterate_devices_callout_fn fn, void *data)
 {
@@ -2265,7 +2251,6 @@ static struct target_type origin_target = {
 	.map     = origin_map,
 	.resume  = origin_resume,
 	.status  = origin_status,
-	.merge	 = origin_merge,
 	.iterate_devices = origin_iterate_devices,
 };
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index f8b37d4..09bb2fe 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -412,26 +412,6 @@ static void stripe_io_hints(struct dm_target *ti,
 	blk_limits_io_opt(limits, chunk_size * sc->stripes);
 }
 
-static int stripe_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-			struct bio_vec *biovec, int max_size)
-{
-	struct stripe_c *sc = ti->private;
-	sector_t bvm_sector = bvm->bi_sector;
-	uint32_t stripe;
-	struct request_queue *q;
-
-	stripe_map_sector(sc, bvm_sector, &stripe, &bvm_sector);
-
-	q = bdev_get_queue(sc->stripe[stripe].dev->bdev);
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = sc->stripe[stripe].dev->bdev;
-	bvm->bi_sector = sc->stripe[stripe].physical_start + bvm_sector;
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static struct target_type stripe_target = {
 	.name   = "striped",
 	.version = {1, 5, 1},
@@ -443,7 +423,6 @@ static struct target_type stripe_target = {
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
-	.merge  = stripe_merge,
 };
 
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3afae9e..6c14cb4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -443,14 +443,6 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		       q->limits.alignment_offset,
 		       (unsigned long long) start << SECTOR_SHIFT);
 
-	/*
-	 * Check if merge fn is supported.
-	 * If not we'll force DM to use PAGE_SIZE or
-	 * smaller I/O, just to be safe.
-	 */
-	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge)
-		blk_limits_max_hw_sectors(limits,
-					  (unsigned int) (PAGE_SIZE >> 9));
 	return 0;
 }
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 8735543..8e0dd5e 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3548,20 +3548,6 @@ static int pool_iterate_devices(struct dm_target *ti,
 	return fn(ti, pt->data_dev, 0, ti->len, data);
 }
 
-static int pool_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-		      struct bio_vec *biovec, int max_size)
-{
-	struct pool_c *pt = ti->private;
-	struct request_queue *q = bdev_get_queue(pt->data_dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = pt->data_dev->bdev;
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
 {
 	struct pool *pool = pt->pool;
@@ -3653,7 +3639,6 @@ static struct target_type pool_target = {
 	.resume = pool_resume,
 	.message = pool_message,
 	.status = pool_status,
-	.merge = pool_merge,
 	.iterate_devices = pool_iterate_devices,
 	.io_hints = pool_io_hints,
 };
@@ -3979,21 +3964,6 @@ err:
 	DMEMIT("Error");
 }
 
-static int thin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-		      struct bio_vec *biovec, int max_size)
-{
-	struct thin_c *tc = ti->private;
-	struct request_queue *q = bdev_get_queue(tc->pool_dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = tc->pool_dev->bdev;
-	bvm->bi_sector = dm_target_offset(ti, bvm->bi_sector);
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static int thin_iterate_devices(struct dm_target *ti,
 				iterate_devices_callout_fn fn, void *data)
 {
@@ -4028,7 +3998,6 @@ static struct target_type thin_target = {
 	.presuspend = thin_presuspend,
 	.postsuspend = thin_postsuspend,
 	.status = thin_status,
-	.merge = thin_merge,
 	.iterate_devices = thin_iterate_devices,
 };
 
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 7a7bab8..25d76a8 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -564,21 +564,6 @@ static int verity_ioctl(struct dm_target *ti, unsigned cmd,
 				     cmd, arg);
 }
 
-static int verity_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
-			struct bio_vec *biovec, int max_size)
-{
-	struct dm_verity *v = ti->private;
-	struct request_queue *q = bdev_get_queue(v->data_dev->bdev);
-
-	if (!q->merge_bvec_fn)
-		return max_size;
-
-	bvm->bi_bdev = v->data_dev->bdev;
-	bvm->bi_sector = verity_map_sector(v, bvm->bi_sector);
-
-	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
-}
-
 static int verity_iterate_devices(struct dm_target *ti,
 				  iterate_devices_callout_fn fn, void *data)
 {
@@ -872,7 +857,6 @@ static struct target_type verity_target = {
 	.map		= verity_map,
 	.status		= verity_status,
 	.ioctl		= verity_ioctl,
-	.merge		= verity_merge,
 	.iterate_devices = verity_iterate_devices,
 	.io_hints	= verity_io_hints,
 };
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5ce28a4..7cf0dde 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -116,9 +116,8 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_FREEING 3
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
-#define DMF_MERGE_IS_OPTIONAL 6
-#define DMF_DEFERRED_REMOVE 7
-#define DMF_SUSPENDED_INTERNALLY 8
+#define DMF_DEFERRED_REMOVE 6
+#define DMF_SUSPENDED_INTERNALLY 7
 
 /*
  * A dummy definition to make RCU happy.
@@ -1586,60 +1585,6 @@ static void __split_and_process_bio(struct mapped_device *md,
  * CRUD END
  *---------------------------------------------------------------*/
 
-static int dm_merge_bvec(struct request_queue *q,
-			 struct bvec_merge_data *bvm,
-			 struct bio_vec *biovec)
-{
-	struct mapped_device *md = q->queuedata;
-	struct dm_table *map = dm_get_live_table_fast(md);
-	struct dm_target *ti;
-	sector_t max_sectors;
-	int max_size = 0;
-
-	if (unlikely(!map))
-		goto out;
-
-	ti = dm_table_find_target(map, bvm->bi_sector);
-	if (!dm_target_is_valid(ti))
-		goto out;
-
-	/*
-	 * Find maximum amount of I/O that won't need splitting
-	 */
-	max_sectors = min(max_io_len(bvm->bi_sector, ti),
-			  (sector_t) queue_max_sectors(q));
-	max_size = (max_sectors << SECTOR_SHIFT) - bvm->bi_size;
-	if (unlikely(max_size < 0)) /* this shouldn't _ever_ happen */
-		max_size = 0;
-
-	/*
-	 * merge_bvec_fn() returns number of bytes
-	 * it can accept at this offset
-	 * max is precomputed maximal io size
-	 */
-	if (max_size && ti->type->merge)
-		max_size = ti->type->merge(ti, bvm, biovec, max_size);
-	/*
-	 * If the target doesn't support merge method and some of the devices
-	 * provided their merge_bvec method (we know this by looking for the
-	 * max_hw_sectors that dm_set_device_limits may set), then we can't
-	 * allow bios with multiple vector entries.  So always set max_size
-	 * to 0, and the code below allows just one page.
-	 */
-	else if (queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
-		max_size = 0;
-
-out:
-	dm_put_live_table_fast(md);
-	/*
-	 * Always allow an entire first page
-	 */
-	if (max_size <= biovec->bv_len && !(bvm->bi_size >> SECTOR_SHIFT))
-		max_size = biovec->bv_len;
-
-	return max_size;
-}
-
 /*
  * The request function that just remaps the bio built up by
  * dm_merge_bvec.
@@ -2030,7 +1975,6 @@ static void dm_init_md_queue(struct mapped_device *md)
 	md->queue->backing_dev_info.congested_data = md;
 	blk_queue_make_request(md->queue, dm_request);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 }
 
 /*
@@ -2241,59 +2185,6 @@ static void __set_size(struct mapped_device *md, sector_t size)
 }
 
 /*
- * Return 1 if the queue has a compulsory merge_bvec_fn function.
- *
- * If this function returns 0, then the device is either a non-dm
- * device without a merge_bvec_fn, or it is a dm device that is
- * able to split any bios it receives that are too big.
- */
-int dm_queue_merge_is_compulsory(struct request_queue *q)
-{
-	struct mapped_device *dev_md;
-
-	if (!q->merge_bvec_fn)
-		return 0;
-
-	if (q->make_request_fn == dm_request) {
-		dev_md = q->queuedata;
-		if (test_bit(DMF_MERGE_IS_OPTIONAL, &dev_md->flags))
-			return 0;
-	}
-
-	return 1;
-}
-
-static int dm_device_merge_is_compulsory(struct dm_target *ti,
-					 struct dm_dev *dev, sector_t start,
-					 sector_t len, void *data)
-{
-	struct block_device *bdev = dev->bdev;
-	struct request_queue *q = bdev_get_queue(bdev);
-
-	return dm_queue_merge_is_compulsory(q);
-}
-
-/*
- * Return 1 if it is acceptable to ignore merge_bvec_fn based
- * on the properties of the underlying devices.
- */
-static int dm_table_merge_is_optional(struct dm_table *table)
-{
-	unsigned i = 0;
-	struct dm_target *ti;
-
-	while (i < dm_table_get_num_targets(table)) {
-		ti = dm_table_get_target(table, i++);
-
-		if (ti->type->iterate_devices &&
-		    ti->type->iterate_devices(ti, dm_device_merge_is_compulsory, NULL))
-			return 0;
-	}
-
-	return 1;
-}
-
-/*
  * Returns old map, which caller must destroy.
  */
 static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
@@ -2302,7 +2193,6 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	struct dm_table *old_map;
 	struct request_queue *q = md->queue;
 	sector_t size;
-	int merge_is_optional;
 
 	size = dm_table_get_size(t);
 
@@ -2328,17 +2218,11 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 
 	__bind_mempools(md, t);
 
-	merge_is_optional = dm_table_merge_is_optional(t);
-
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
 
 	dm_table_set_restrictions(t, q, limits);
-	if (merge_is_optional)
-		set_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
-	else
-		clear_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
 	if (old_map)
 		dm_sync_table(md);
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 84b0f9e4..08f47fc 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -76,8 +76,6 @@ bool dm_table_request_based(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
-int dm_queue_merge_is_compulsory(struct request_queue *q);
-
 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, unsigned type);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 64713b7..d831a5b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -52,51 +52,6 @@ static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
 	return conf->disks + lo;
 }
 
-/**
- *	linear_mergeable_bvec -- tell bio layer if two requests can be merged
- *	@q: request queue
- *	@bvm: properties of new bio
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can take at this offset
- */
-static int linear_mergeable_bvec(struct request_queue *q,
-				 struct bvec_merge_data *bvm,
-				 struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	struct dev_info *dev0;
-	unsigned long maxsectors, bio_sectors = bvm->bi_size >> 9;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	int maxbytes = biovec->bv_len;
-	struct request_queue *subq;
-
-	rcu_read_lock();
-	dev0 = which_dev(mddev, sector);
-	maxsectors = dev0->end_sector - sector;
-	subq = bdev_get_queue(dev0->rdev->bdev);
-	if (subq->merge_bvec_fn) {
-		bvm->bi_bdev = dev0->rdev->bdev;
-		bvm->bi_sector -= dev0->end_sector - dev0->rdev->sectors;
-		maxbytes = min(maxbytes, subq->merge_bvec_fn(subq, bvm,
-							     biovec));
-	}
-	rcu_read_unlock();
-
-	if (maxsectors < bio_sectors)
-		maxsectors = 0;
-	else
-		maxsectors -= bio_sectors;
-
-	if (maxsectors <= (PAGE_SIZE >> 9 ) && bio_sectors == 0)
-		return maxbytes;
-
-	if (maxsectors > (maxbytes >> 9))
-		return maxbytes;
-	else
-		return maxsectors << 9;
-}
-
 static int linear_congested(void *data, int bits)
 {
 	struct mddev *mddev = data;
@@ -217,7 +172,6 @@ static int linear_run (struct mddev *mddev)
 	mddev->private = conf;
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 
-	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->backing_dev_info.congested_fn = linear_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 48234eb..0e34b76 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5033,7 +5033,6 @@ static void md_clean(struct mddev *mddev)
 	mddev->changed = 0;
 	mddev->degraded = 0;
 	mddev->safemode = 0;
-	mddev->merge_check_needed = 0;
 	mddev->bitmap_info.offset = 0;
 	mddev->bitmap_info.default_offset = 0;
 	mddev->bitmap_info.default_space = 0;
@@ -5201,7 +5200,6 @@ static int do_md_stop(struct mddev *mddev, int mode,
 
 		__md_stop_writes(mddev);
 		__md_stop(mddev);
-		mddev->queue->merge_bvec_fn = NULL;
 		mddev->queue->backing_dev_info.congested_fn = NULL;
 
 		/* tell userspace to handle 'inactive' */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 03cec5b..4932445 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -132,10 +132,6 @@ enum flag_bits {
 	Bitmap_sync,		/* ..actually, not quite In_sync.  Need a
 				 * bitmap-based recovery to get fully in sync
 				 */
-	Unmerged,		/* device is being added to array and should
-				 * be considerred for bvec_merge_fn but not
-				 * yet for actual IO
-				 */
 	WriteMostly,		/* Avoid reading if at all possible */
 	AutoDetected,		/* added by auto-detect */
 	Blocked,		/* An error occurred but has not yet
@@ -366,10 +362,6 @@ struct mddev {
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
-	int				merge_check_needed; /* at least one
-							     * member device
-							     * has a
-							     * merge_bvec_fn */
 
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 399272f..2f82954 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -261,18 +261,6 @@ static int multipath_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_segments to one, lying
-		 * within a single page.
-		 * (Note: it is very unlikely that a device with
-		 * merge_bvec_fn will be involved in multipath.)
-		 */
-			if (q->merge_bvec_fn) {
-				blk_queue_max_segments(mddev->queue, 1);
-				blk_queue_segment_boundary(mddev->queue,
-							   PAGE_CACHE_SIZE - 1);
-			}
-
 			spin_lock_irq(&conf->device_lock);
 			mddev->degraded--;
 			rdev->raid_disk = path;
@@ -436,15 +424,6 @@ static int multipath_run (struct mddev *mddev)
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
 
-		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, not that we ever expect a device with
-		 * a merge_bvec_fn to be involved in multipath */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
-			blk_queue_max_segments(mddev->queue, 1);
-			blk_queue_segment_boundary(mddev->queue,
-						   PAGE_CACHE_SIZE - 1);
-		}
-
 		if (!test_bit(Faulty, &rdev->flags))
 			working_disks++;
 	}
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ba6b85d..bc4c0b6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -195,9 +195,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		disk_stack_limits(mddev->gendisk, rdev1->bdev,
 				  rdev1->data_offset << 9);
 
-		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn)
-			conf->has_merge_bvec = 1;
-
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
@@ -354,59 +351,6 @@ static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *zone,
 			     + sector_div(sector, zone->nb_dev)];
 }
 
-/**
- *	raid0_mergeable_bvec -- tell bio layer if two requests can be merged
- *	@q: request queue
- *	@bvm: properties of new bio
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can accept at this offset
- */
-static int raid0_mergeable_bvec(struct request_queue *q,
-				struct bvec_merge_data *bvm,
-				struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	struct r0conf *conf = mddev->private;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	sector_t sector_offset = sector;
-	int max;
-	unsigned int chunk_sectors = mddev->chunk_sectors;
-	unsigned int bio_sectors = bvm->bi_size >> 9;
-	struct strip_zone *zone;
-	struct md_rdev *rdev;
-	struct request_queue *subq;
-
-	if (is_power_of_2(chunk_sectors))
-		max =  (chunk_sectors - ((sector & (chunk_sectors-1))
-						+ bio_sectors)) << 9;
-	else
-		max =  (chunk_sectors - (sector_div(sector, chunk_sectors)
-						+ bio_sectors)) << 9;
-	if (max < 0)
-		max = 0; /* bio_add cannot handle a negative return */
-	if (max <= biovec->bv_len && bio_sectors == 0)
-		return biovec->bv_len;
-	if (max < biovec->bv_len)
-		/* too small already, no need to check further */
-		return max;
-	if (!conf->has_merge_bvec)
-		return max;
-
-	/* May need to check subordinate device */
-	sector = sector_offset;
-	zone = find_zone(mddev->private, &sector_offset);
-	rdev = map_sector(mddev, zone, sector, &sector_offset);
-	subq = bdev_get_queue(rdev->bdev);
-	if (subq->merge_bvec_fn) {
-		bvm->bi_bdev = rdev->bdev;
-		bvm->bi_sector = sector_offset + zone->dev_start +
-			rdev->data_offset;
-		return min(max, subq->merge_bvec_fn(subq, bvm, biovec));
-	} else
-		return max;
-}
-
 static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 {
 	sector_t array_sectors = 0;
@@ -471,7 +415,6 @@ static int raid0_run(struct mddev *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
 
 	ret = md_integrity_register(mddev);
diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
index 05539d9..7127a62 100644
--- a/drivers/md/raid0.h
+++ b/drivers/md/raid0.h
@@ -12,8 +12,6 @@ struct r0conf {
 	struct md_rdev		**devlist; /* lists of rdevs, pointed to
 					    * by strip_zone->dev */
 	int			nr_strip_zones;
-	int			has_merge_bvec;	/* at least one member has
-						 * a merge_bvec_fn */
 };
 
 #endif
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 40b35be..c2f236c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -551,7 +551,6 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 		rdev = rcu_dereference(conf->mirrors[disk].rdev);
 		if (r1_bio->bios[disk] == IO_BLOCKED
 		    || rdev == NULL
-		    || test_bit(Unmerged, &rdev->flags)
 		    || test_bit(Faulty, &rdev->flags))
 			continue;
 		if (!test_bit(In_sync, &rdev->flags) &&
@@ -701,39 +700,6 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	return best_disk;
 }
 
-static int raid1_mergeable_bvec(struct request_queue *q,
-				struct bvec_merge_data *bvm,
-				struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	struct r1conf *conf = mddev->private;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	int max = biovec->bv_len;
-
-	if (mddev->merge_check_needed) {
-		int disk;
-		rcu_read_lock();
-		for (disk = 0; disk < conf->raid_disks * 2; disk++) {
-			struct md_rdev *rdev = rcu_dereference(
-				conf->mirrors[disk].rdev);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = sector +
-						rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
-			}
-		}
-		rcu_read_unlock();
-	}
-	return max;
-
-}
-
 int md_raid1_congested(struct mddev *mddev, int bits)
 {
 	struct r1conf *conf = mddev->private;
@@ -1266,8 +1232,7 @@ read_again:
 			break;
 		}
 		r1_bio->bios[i] = NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags)
-		    || test_bit(Unmerged, &rdev->flags)) {
+		if (!rdev || test_bit(Faulty, &rdev->flags)) {
 			if (i < conf->raid_disks)
 				set_bit(R1BIO_Degraded, &r1_bio->state);
 			continue;
@@ -1611,7 +1576,6 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct raid1_info *p;
 	int first = 0;
 	int last = conf->raid_disks - 1;
-	struct request_queue *q = bdev_get_queue(rdev->bdev);
 
 	if (mddev->recovery_disabled == conf->recovery_disabled)
 		return -EBUSY;
@@ -1619,11 +1583,6 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
-	if (q->merge_bvec_fn) {
-		set_bit(Unmerged, &rdev->flags);
-		mddev->merge_check_needed = 1;
-	}
-
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors+mirror;
 		if (!p->rdev) {
@@ -1655,19 +1614,6 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			break;
 		}
 	}
-	if (err == 0 && test_bit(Unmerged, &rdev->flags)) {
-		/* Some requests might not have seen this new
-		 * merge_bvec_fn.  We must wait for them to complete
-		 * before merging the device fully.
-		 * First we make sure any code which has tested
-		 * our function has submitted the request, then
-		 * we wait for all outstanding requests to complete.
-		 */
-		synchronize_sched();
-		freeze_array(conf, 0);
-		unfreeze_array(conf);
-		clear_bit(Unmerged, &rdev->flags);
-	}
 	md_integrity_add_rdev(rdev, mddev);
 	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
@@ -2810,8 +2756,6 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 			goto abort;
 		disk->rdev = rdev;
 		q = bdev_get_queue(rdev->bdev);
-		if (q->merge_bvec_fn)
-			mddev->merge_check_needed = 1;
 
 		disk->head_position = 0;
 		disk->seq_start = MaxSector;
@@ -2957,7 +2901,6 @@ static int run(struct mddev *mddev)
 	if (mddev->queue) {
 		mddev->queue->backing_dev_info.congested_fn = raid1_congested;
 		mddev->queue->backing_dev_info.congested_data = mddev;
-		blk_queue_merge_bvec(mddev->queue, raid1_mergeable_bvec);
 
 		if (discard_supported)
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4a40354..08772a9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -672,94 +672,6 @@ static sector_t raid10_find_virt(struct r10conf *conf, sector_t sector, int dev)
 	return (vchunk << geo->chunk_shift) + offset;
 }
 
-/**
- *	raid10_mergeable_bvec -- tell bio layer if a two requests can be merged
- *	@q: request queue
- *	@bvm: properties of new bio
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can accept at this offset
- *	This requires checking for end-of-chunk if near_copies != raid_disks,
- *	and for subordinate merge_bvec_fns if merge_check_needed.
- */
-static int raid10_mergeable_bvec(struct request_queue *q,
-				 struct bvec_merge_data *bvm,
-				 struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	struct r10conf *conf = mddev->private;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	int max;
-	unsigned int chunk_sectors;
-	unsigned int bio_sectors = bvm->bi_size >> 9;
-	struct geom *geo = &conf->geo;
-
-	chunk_sectors = (conf->geo.chunk_mask & conf->prev.chunk_mask) + 1;
-	if (conf->reshape_progress != MaxSector &&
-	    ((sector >= conf->reshape_progress) !=
-	     conf->mddev->reshape_backwards))
-		geo = &conf->prev;
-
-	if (geo->near_copies < geo->raid_disks) {
-		max = (chunk_sectors - ((sector & (chunk_sectors - 1))
-					+ bio_sectors)) << 9;
-		if (max < 0)
-			/* bio_add cannot handle a negative return */
-			max = 0;
-		if (max <= biovec->bv_len && bio_sectors == 0)
-			return biovec->bv_len;
-	} else
-		max = biovec->bv_len;
-
-	if (mddev->merge_check_needed) {
-		struct {
-			struct r10bio r10_bio;
-			struct r10dev devs[conf->copies];
-		} on_stack;
-		struct r10bio *r10_bio = &on_stack.r10_bio;
-		int s;
-		if (conf->reshape_progress != MaxSector) {
-			/* Cannot give any guidance during reshape */
-			if (max <= biovec->bv_len && bio_sectors == 0)
-				return biovec->bv_len;
-			return 0;
-		}
-		r10_bio->sector = sector;
-		raid10_find_phys(conf, r10_bio);
-		rcu_read_lock();
-		for (s = 0; s < conf->copies; s++) {
-			int disk = r10_bio->devs[s].devnum;
-			struct md_rdev *rdev = rcu_dereference(
-				conf->mirrors[disk].rdev);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = r10_bio->devs[s].addr
-						+ rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
-			}
-			rdev = rcu_dereference(conf->mirrors[disk].replacement);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = r10_bio->devs[s].addr
-						+ rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
-			}
-		}
-		rcu_read_unlock();
-	}
-	return max;
-}
-
 /*
  * This routine returns the disk from which the requested read should
  * be done. There is a per-array 'next expected sequential IO' sector
@@ -822,12 +734,10 @@ retry:
 		disk = r10_bio->devs[slot].devnum;
 		rdev = rcu_dereference(conf->mirrors[disk].replacement);
 		if (rdev == NULL || test_bit(Faulty, &rdev->flags) ||
-		    test_bit(Unmerged, &rdev->flags) ||
 		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
 			rdev = rcu_dereference(conf->mirrors[disk].rdev);
 		if (rdev == NULL ||
-		    test_bit(Faulty, &rdev->flags) ||
-		    test_bit(Unmerged, &rdev->flags))
+		    test_bit(Faulty, &rdev->flags))
 			continue;
 		if (!test_bit(In_sync, &rdev->flags) &&
 		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
@@ -1336,11 +1246,9 @@ retry_write:
 			blocked_rdev = rrdev;
 			break;
 		}
-		if (rdev && (test_bit(Faulty, &rdev->flags)
-			     || test_bit(Unmerged, &rdev->flags)))
+		if (rdev && (test_bit(Faulty, &rdev->flags)))
 			rdev = NULL;
-		if (rrdev && (test_bit(Faulty, &rrdev->flags)
-			      || test_bit(Unmerged, &rrdev->flags)))
+		if (rrdev && (test_bit(Faulty, &rrdev->flags)))
 			rrdev = NULL;
 
 		r10_bio->devs[i].bio = NULL;
@@ -1787,7 +1695,6 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int mirror;
 	int first = 0;
 	int last = conf->geo.raid_disks - 1;
-	struct request_queue *q = bdev_get_queue(rdev->bdev);
 
 	if (mddev->recovery_cp < MaxSector)
 		/* only hot-add to in-sync arrays, as recovery is
@@ -1800,11 +1707,6 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
-	if (q->merge_bvec_fn) {
-		set_bit(Unmerged, &rdev->flags);
-		mddev->merge_check_needed = 1;
-	}
-
 	if (rdev->saved_raid_disk >= first &&
 	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
 		mirror = rdev->saved_raid_disk;
@@ -1843,19 +1745,6 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		rcu_assign_pointer(p->rdev, rdev);
 		break;
 	}
-	if (err == 0 && test_bit(Unmerged, &rdev->flags)) {
-		/* Some requests might not have seen this new
-		 * merge_bvec_fn.  We must wait for them to complete
-		 * before merging the device fully.
-		 * First we make sure any code which has tested
-		 * our function has submitted the request, then
-		 * we wait for all outstanding requests to complete.
-		 */
-		synchronize_sched();
-		freeze_array(conf, 0);
-		unfreeze_array(conf);
-		clear_bit(Unmerged, &rdev->flags);
-	}
 	md_integrity_add_rdev(rdev, mddev);
 	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
@@ -2404,7 +2293,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (rdev &&
-			    !test_bit(Unmerged, &rdev->flags) &&
 			    test_bit(In_sync, &rdev->flags) &&
 			    is_badblock(rdev, r10_bio->devs[sl].addr + sect, s,
 					&first_bad, &bad_sectors) == 0) {
@@ -2458,7 +2346,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 			d = r10_bio->devs[sl].devnum;
 			rdev = rcu_dereference(conf->mirrors[d].rdev);
 			if (!rdev ||
-			    test_bit(Unmerged, &rdev->flags) ||
 			    !test_bit(In_sync, &rdev->flags))
 				continue;
 
@@ -3657,8 +3544,6 @@ static int run(struct mddev *mddev)
 			disk->rdev = rdev;
 		}
 		q = bdev_get_queue(rdev->bdev);
-		if (q->merge_bvec_fn)
-			mddev->merge_check_needed = 1;
 		diff = (rdev->new_data_offset - rdev->data_offset);
 		if (!mddev->reshape_backwards)
 			diff = -diff;
@@ -3757,7 +3642,6 @@ static int run(struct mddev *mddev)
 		stripe /= conf->geo.near_copies;
 		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
-		blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
 	}
 
 	if (md_integrity_register(mddev))
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 40e464c..6008a30 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4103,32 +4103,6 @@ static int raid5_congested(void *data, int bits)
 		md_raid5_congested(mddev, bits);
 }
 
-/* We want read requests to align with chunks where possible,
- * but write requests don't need to.
- */
-static int raid5_mergeable_bvec(struct request_queue *q,
-				struct bvec_merge_data *bvm,
-				struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	int max;
-	unsigned int chunk_sectors = mddev->chunk_sectors;
-	unsigned int bio_sectors = bvm->bi_size >> 9;
-
-	if ((bvm->bi_rw & 1) == WRITE)
-		return biovec->bv_len; /* always allow writes to be mergeable */
-
-	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
-		chunk_sectors = mddev->new_chunk_sectors;
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
-	if (max < 0) max = 0;
-	if (max <= biovec->bv_len && bio_sectors == 0)
-		return biovec->bv_len;
-	else
-		return max;
-}
-
 static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
 {
 	sector_t sector = bio->bi_iter.bi_sector + get_start_sect(bio->bi_bdev);
@@ -6152,8 +6126,6 @@ static int run(struct mddev *mddev)
 		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 
-		blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
-
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c03e37a..7a8c95c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -239,14 +239,6 @@ typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
 
 struct bio_vec;
-struct bvec_merge_data {
-	struct block_device *bi_bdev;
-	sector_t bi_sector;
-	unsigned bi_size;
-	unsigned long bi_rw;
-};
-typedef int (merge_bvec_fn) (struct request_queue *, struct bvec_merge_data *,
-			     struct bio_vec *);
 typedef void (softirq_done_fn)(struct request *);
 typedef int (dma_drain_needed_fn)(struct request *);
 typedef int (lld_busy_fn) (struct request_queue *q);
@@ -327,7 +319,6 @@ struct request_queue {
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
-	merge_bvec_fn		*merge_bvec_fn;
 	softirq_done_fn		*softirq_done_fn;
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
@@ -1036,7 +1027,6 @@ extern void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *ufn);
-extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ca6d2acc..2f7f2df 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -77,9 +77,6 @@ typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
 typedef int (*dm_ioctl_fn) (struct dm_target *ti, unsigned int cmd,
 			    unsigned long arg);
 
-typedef int (*dm_merge_fn) (struct dm_target *ti, struct bvec_merge_data *bvm,
-			    struct bio_vec *biovec, int max_size);
-
 /*
  * These iteration functions are typically used to check (and combine)
  * properties of underlying devices.
@@ -153,7 +150,6 @@ struct target_type {
 	dm_status_fn status;
 	dm_message_fn message;
 	dm_ioctl_fn ioctl;
-	dm_merge_fn merge;
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
-- 
2.1.0

