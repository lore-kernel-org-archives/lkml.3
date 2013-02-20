Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab3BTA2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:28:07 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55669 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934942Ab3BTAW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:22:58 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        "Ed L. Cashin" <ecashin@coraid.com>, Nick Piggin <npiggin@kernel.dk>,
        Jiri Kosina <jkosina@suse.cz>, Jim Paris <jim@jtan.com>,
        Geoff Levand <geoff@infradead.org>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 09/27] block: Use bio_sectors() more consistently
Date: Tue, 19 Feb 2013 16:22:23 -0800
Message-Id: <1361319761-23873-10-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bunch of places in the code weren't using it where they could be -
this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
into a struct bvec_iter.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: "Ed L. Cashin" <ecashin@coraid.com>
CC: Nick Piggin <npiggin@kernel.dk>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Jim Paris <jim@jtan.com>
CC: Geoff Levand <geoff@infradead.org>
CC: Alasdair Kergon <agk@redhat.com>
CC: dm-devel@redhat.com
CC: Neil Brown <neilb@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/pktcdvd.c      |  2 +-
 drivers/md/dm-raid1.c        |  2 +-
 drivers/md/raid0.c           |  6 +++---
 drivers/md/raid1.c           | 17 ++++++++---------
 drivers/md/raid10.c          | 24 +++++++++++-------------
 drivers/md/raid5.c           |  8 ++++----
 fs/btrfs/volumes.c           |  2 +-
 include/trace/events/block.h | 12 ++++++------
 8 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 26938e8..2c27744 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2433,7 +2433,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		cloned_bio->bi_bdev = pd->bdev;
 		cloned_bio->bi_private = psd;
 		cloned_bio->bi_end_io = pkt_end_io_read_cloned;
-		pd->stats.secs_r += bio->bi_size >> 9;
+		pd->stats.secs_r += bio_sectors(bio);
 		pkt_queue_bio(pd, cloned_bio);
 		return;
 	}
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index fa51918..b61ed2b 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -455,7 +455,7 @@ static void map_region(struct dm_io_region *io, struct mirror *m,
 {
 	io->bdev = m->dev->bdev;
 	io->sector = map_sector(m, bio);
-	io->count = bio->bi_size >> 9;
+	io->count = bio_sectors(bio);
 }
 
 static void hold_bio(struct mirror_set *ms, struct bio *bio)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 24b3597..1ff39e6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -495,11 +495,11 @@ static inline int is_io_in_chunk_boundary(struct mddev *mddev,
 {
 	if (likely(is_power_of_2(chunk_sects))) {
 		return chunk_sects >= ((bio->bi_sector & (chunk_sects-1))
-					+ (bio->bi_size >> 9));
+					+ bio_sectors(bio));
 	} else{
 		sector_t sector = bio->bi_sector;
 		return chunk_sects >= (sector_div(sector, chunk_sects)
-						+ (bio->bi_size >> 9));
+						+ bio_sectors(bio));
 	}
 }
 
@@ -560,7 +560,7 @@ bad_map:
 	printk("md/raid0:%s: make_request bug: can't convert block across chunks"
 	       " or bigger than %dk %llu %d\n",
 	       mdname(mddev), chunk_sects / 2,
-	       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
+	       (unsigned long long)bio->bi_sector, bio_sectors(bio) / 2);
 
 	bio_io_error(bio);
 	return;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2117622..b47503b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -267,7 +267,7 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 			 (bio_data_dir(bio) == WRITE) ? "write" : "read",
 			 (unsigned long long) bio->bi_sector,
 			 (unsigned long long) bio->bi_sector +
-			 (bio->bi_size >> 9) - 1);
+			 bio_sectors(bio) - 1);
 
 		call_bio_endio(r1_bio);
 	}
@@ -458,7 +458,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
 					 " %llu-%llu\n",
 					 (unsigned long long) mbio->bi_sector,
 					 (unsigned long long) mbio->bi_sector +
-					 (mbio->bi_size >> 9) - 1);
+					 bio_sectors(mbio) - 1);
 				call_bio_endio(r1_bio);
 			}
 		}
@@ -1047,7 +1047,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 
 	r1_bio->master_bio = bio;
-	r1_bio->sectors = bio->bi_size >> 9;
+	r1_bio->sectors = bio_sectors(bio);
 	r1_bio->state = 0;
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
@@ -1125,7 +1125,7 @@ read_again:
 			r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 
 			r1_bio->master_bio = bio;
-			r1_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+			r1_bio->sectors = bio_sectors(bio) - sectors_handled;
 			r1_bio->state = 0;
 			r1_bio->mddev = mddev;
 			r1_bio->sector = bio->bi_sector + sectors_handled;
@@ -1326,14 +1326,14 @@ read_again:
 	/* Mustn't call r1_bio_write_done before this next test,
 	 * as it could result in the bio being freed.
 	 */
-	if (sectors_handled < (bio->bi_size >> 9)) {
+	if (sectors_handled < bio_sectors(bio)) {
 		r1_bio_write_done(r1_bio);
 		/* We need another r1_bio.  It has already been counted
 		 * in bio->bi_phys_segments
 		 */
 		r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 		r1_bio->master_bio = bio;
-		r1_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+		r1_bio->sectors = bio_sectors(bio) - sectors_handled;
 		r1_bio->state = 0;
 		r1_bio->mddev = mddev;
 		r1_bio->sector = bio->bi_sector + sectors_handled;
@@ -1944,7 +1944,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		wbio->bi_rw = WRITE;
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
-		md_sync_acct(conf->mirrors[i].rdev->bdev, wbio->bi_size >> 9);
+		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
 
 		generic_make_request(wbio);
 	}
@@ -2281,8 +2281,7 @@ read_more:
 			r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 
 			r1_bio->master_bio = mbio;
-			r1_bio->sectors = (mbio->bi_size >> 9)
-					  - sectors_handled;
+			r1_bio->sectors = bio_sectors(mbio) - sectors_handled;
 			r1_bio->state = 0;
 			set_bit(R1BIO_ReadError, &r1_bio->state);
 			r1_bio->mddev = mddev;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 64d4824..4c6705f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1121,7 +1121,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	/* If this request crosses a chunk boundary, we need to
 	 * split it.  This will only happen for 1 PAGE (or less) requests.
 	 */
-	if (unlikely((bio->bi_sector & chunk_mask) + (bio->bi_size >> 9)
+	if (unlikely((bio->bi_sector & chunk_mask) + bio_sectors(bio)
 		     > chunk_sects
 		     && (conf->geo.near_copies < conf->geo.raid_disks
 			 || conf->prev.near_copies < conf->prev.raid_disks))) {
@@ -1161,7 +1161,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	bad_map:
 		printk("md/raid10:%s: make_request bug: can't convert block across chunks"
 		       " or bigger than %dk %llu %d\n", mdname(mddev), chunk_sects/2,
-		       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
+		       (unsigned long long)bio->bi_sector, bio_sectors(bio) / 2);
 
 		bio_io_error(bio);
 		return;
@@ -1176,7 +1176,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	 */
 	wait_barrier(conf);
 
-	sectors = bio->bi_size >> 9;
+	sectors = bio_sectors(bio);
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_sector < conf->reshape_progress &&
 	    bio->bi_sector + sectors > conf->reshape_progress) {
@@ -1278,8 +1278,7 @@ read_again:
 			r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 			r10_bio->master_bio = bio;
-			r10_bio->sectors = ((bio->bi_size >> 9)
-					    - sectors_handled);
+			r10_bio->sectors = bio_sectors(bio) - sectors_handled;
 			r10_bio->state = 0;
 			r10_bio->mddev = mddev;
 			r10_bio->sector = bio->bi_sector + sectors_handled;
@@ -1519,7 +1518,7 @@ retry_write:
 	 * after checking if we need to go around again.
 	 */
 
-	if (sectors_handled < (bio->bi_size >> 9)) {
+	if (sectors_handled < bio_sectors(bio)) {
 		one_write_done(r10_bio);
 		/* We need another r10_bio.  It has already been counted
 		 * in bio->bi_phys_segments.
@@ -1527,7 +1526,7 @@ retry_write:
 		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 		r10_bio->master_bio = bio;
-		r10_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+		r10_bio->sectors = bio_sectors(bio) - sectors_handled;
 
 		r10_bio->mddev = mddev;
 		r10_bio->sector = bio->bi_sector + sectors_handled;
@@ -2053,7 +2052,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, tbio->bi_size >> 9);
+		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
 
 		tbio->bi_sector += conf->mirrors[d].rdev->data_offset;
 		tbio->bi_bdev = conf->mirrors[d].rdev->bdev;
@@ -2078,7 +2077,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     tbio->bi_size >> 9);
+			     bio_sectors(tbio));
 		generic_make_request(tbio);
 	}
 
@@ -2204,13 +2203,13 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	wbio2 = r10_bio->devs[1].repl_bio;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
+		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
 		generic_make_request(wbio);
 	}
 	if (wbio2 && wbio2->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     wbio2->bi_size >> 9);
+			     bio_sectors(wbio2));
 		generic_make_request(wbio2);
 	}
 }
@@ -2640,8 +2639,7 @@ read_more:
 		r10_bio = mempool_alloc(conf->r10bio_pool,
 					GFP_NOIO);
 		r10_bio->master_bio = mbio;
-		r10_bio->sectors = (mbio->bi_size >> 9)
-			- sectors_handled;
+		r10_bio->sectors = bio_sectors(mbio) - sectors_handled;
 		r10_bio->state = 0;
 		set_bit(R10BIO_ReadError,
 			&r10_bio->state);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a203039..0ba12c3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -90,7 +90,7 @@ static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
  */
 static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
 {
-	int sectors = bio->bi_size >> 9;
+	int sectors = bio_sectors(bio);
 	if (bio->bi_sector + sectors < sector + STRIPE_SECTORS)
 		return bio->bi_next;
 	else
@@ -3841,7 +3841,7 @@ static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
 {
 	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
 	unsigned int chunk_sectors = mddev->chunk_sectors;
-	unsigned int bio_sectors = bio->bi_size >> 9;
+	unsigned int bio_sectors = bio_sectors(bio);
 
 	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
 		chunk_sectors = mddev->new_chunk_sectors;
@@ -3931,7 +3931,7 @@ static int bio_fits_rdev(struct bio *bi)
 {
 	struct request_queue *q = bdev_get_queue(bi->bi_bdev);
 
-	if ((bi->bi_size>>9) > queue_max_sectors(q))
+	if (bio_sectors(bi) > queue_max_sectors(q))
 		return 0;
 	blk_recount_segments(q, bi);
 	if (bi->bi_phys_segments > queue_max_segments(q))
@@ -4001,7 +4001,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 		if (!bio_fits_rdev(align_bi) ||
-		    is_badblock(rdev, align_bi->bi_sector, align_bi->bi_size>>9,
+		    is_badblock(rdev, align_bi->bi_sector, bio_sectors(align_bi),
 				&first_bad, &bad_sectors)) {
 			/* too big in some way, or has a known bad block */
 			bio_put(align_bi);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cce6aa..07ff012 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4722,7 +4722,7 @@ static int bio_size_ok(struct block_device *bdev, struct bio *bio,
 	}
 
 	prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
-	if ((bio->bi_size >> 9) > max_sectors)
+	if (bio_sectors(bio) > max_sectors)
 		return 0;
 
 	if (!q->merge_bvec_fn)
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 9961726..5a28843 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -244,7 +244,7 @@ TRACE_EVENT(block_bio_bounce,
 		__entry->dev		= bio->bi_bdev ?
 					  bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
@@ -281,7 +281,7 @@ TRACE_EVENT(block_bio_complete,
 		__entry->dev		= bio->bi_bdev ?
 					  bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		__entry->error		= error;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 	),
@@ -309,7 +309,7 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
@@ -376,7 +376,7 @@ TRACE_EVENT(block_bio_queue,
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
@@ -404,7 +404,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
 	TP_fast_assign(
 		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio ? bio->bi_sector : 0;
-		__entry->nr_sector	= bio ? bio->bi_size >> 9 : 0;
+		__entry->nr_sector	= bio ? bio_sectors(bio) : 0;
 		blk_fill_rwbs(__entry->rwbs,
 			      bio ? bio->bi_rw : 0, __entry->nr_sector);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
@@ -580,7 +580,7 @@ TRACE_EVENT(block_bio_remap,
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
-- 
1.7.12

