Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3LCWAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:00:48 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33494 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3LCWAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:41 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 03/11] btrfs: generic_make_request() handles arbitrary size bios now
Date: Tue,  3 Dec 2013 14:00:09 -0800
Message-Id: <1386108017-27964-4-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 fs/btrfs/volumes.c | 73 ------------------------------------------------------
 1 file changed, 73 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 37972d5..d6dbe80 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5391,34 +5391,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 				   &device->work);
 }
 
-static int bio_size_ok(struct block_device *bdev, struct bio *bio,
-		       sector_t sector)
-{
-	struct bio_vec *prev;
-	struct request_queue *q = bdev_get_queue(bdev);
-	unsigned int max_sectors = queue_max_sectors(q);
-	struct bvec_merge_data bvm = {
-		.bi_bdev = bdev,
-		.bi_sector = sector,
-		.bi_rw = bio->bi_rw,
-	};
-
-	if (WARN_ON(bio->bi_vcnt == 0))
-		return 1;
-
-	prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
-	if (bio_sectors(bio) > max_sectors)
-		return 0;
-
-	if (!q->merge_bvec_fn)
-		return 1;
-
-	bvm.bi_size = bio->bi_iter.bi_size - prev->bv_len;
-	if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len)
-		return 0;
-	return 1;
-}
-
 static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 			      struct bio *bio, u64 physical, int dev_nr,
 			      int rw, int async)
@@ -5449,38 +5421,6 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 		btrfsic_submit_bio(rw, bio);
 }
 
-static int breakup_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
-			      struct bio *first_bio, struct btrfs_device *dev,
-			      int dev_nr, int rw, int async)
-{
-	struct bio_vec *bvec = first_bio->bi_io_vec;
-	struct bio *bio;
-	int nr_vecs = bio_get_nr_vecs(dev->bdev);
-	u64 physical = bbio->stripes[dev_nr].physical;
-
-again:
-	bio = btrfs_bio_alloc(dev->bdev, physical >> 9, nr_vecs, GFP_NOFS);
-	if (!bio)
-		return -ENOMEM;
-
-	while (bvec <= (first_bio->bi_io_vec + first_bio->bi_vcnt - 1)) {
-		if (bio_add_page(bio, bvec->bv_page, bvec->bv_len,
-				 bvec->bv_offset) < bvec->bv_len) {
-			u64 len = bio->bi_iter.bi_size;
-
-			atomic_inc(&bbio->stripes_pending);
-			submit_stripe_bio(root, bbio, bio, physical, dev_nr,
-					  rw, async);
-			physical += len;
-			goto again;
-		}
-		bvec++;
-	}
-
-	submit_stripe_bio(root, bbio, bio, physical, dev_nr, rw, async);
-	return 0;
-}
-
 static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 {
 	atomic_inc(&bbio->error);
@@ -5549,19 +5489,6 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 			continue;
 		}
 
-		/*
-		 * Check and see if we're ok with this bio based on it's size
-		 * and offset with the given device.
-		 */
-		if (!bio_size_ok(dev->bdev, first_bio,
-				 bbio->stripes[dev_nr].physical >> 9)) {
-			ret = breakup_stripe_bio(root, bbio, first_bio, dev,
-						 dev_nr, rw, async_submit);
-			BUG_ON(ret);
-			dev_nr++;
-			continue;
-		}
-
 		if (dev_nr < total_devs - 1) {
 			bio = btrfs_bio_clone(first_bio, GFP_NOFS);
 			BUG_ON(!bio); /* -ENOMEM */
-- 
1.8.4.4

