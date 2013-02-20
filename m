Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3BTA2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:28:43 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:45302 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934941Ab3BTAW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:22:57 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Jiri Kosina <jkosina@suse.cz>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/27] block: Add bio_end_sector()
Date: Tue, 19 Feb 2013 16:22:22 -0800
Message-Id: <1361319761-23873-9-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a little convenience macro - main reason to add it now is preparing
for immutable bio vecs, it'll reduce the size of the patch that puts
bi_sector/bi_size/bi_idx into a struct bvec_iter.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Lars Ellenberg <drbd-dev@lists.linbit.com>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Alasdair Kergon <agk@redhat.com>
CC: dm-devel@redhat.com
CC: Neil Brown <neilb@suse.de>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-s390@vger.kernel.org
CC: Chris Mason <chris.mason@fusionio.com>
CC: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
---
 block/blk-core.c             |  2 +-
 block/cfq-iosched.c          |  7 ++-----
 block/deadline-iosched.c     |  2 +-
 drivers/block/brd.c          |  3 +--
 drivers/block/pktcdvd.c      |  6 +++---
 drivers/md/dm-stripe.c       |  2 +-
 drivers/md/dm-verity.c       |  2 +-
 drivers/md/faulty.c          |  6 ++----
 drivers/md/linear.c          |  3 +--
 drivers/md/raid1.c           |  4 ++--
 drivers/md/raid5.c           | 14 +++++++-------
 drivers/s390/block/dcssblk.c |  3 +--
 fs/btrfs/extent_io.c         |  3 +--
 fs/gfs2/lops.c               |  2 +-
 include/linux/bio.h          |  1 +
 15 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8f9f19b..9a285f4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1581,7 +1581,7 @@ static void handle_bad_sector(struct bio *bio)
 	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
 			bdevname(bio->bi_bdev, b),
 			bio->bi_rw,
-			(unsigned long long)bio->bi_sector + bio_sectors(bio),
+			(unsigned long long)bio_end_sector(bio),
 			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
 
 	set_bit(BIO_EOF, &bio->bi_flags);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b66365b..83b8c88 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2271,11 +2271,8 @@ cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 		return NULL;
 
 	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
-	if (cfqq) {
-		sector_t sector = bio->bi_sector + bio_sectors(bio);
-
-		return elv_rb_find(&cfqq->sort_list, sector);
-	}
+	if (cfqq)
+		return elv_rb_find(&cfqq->sort_list, bio_end_sector(bio));
 
 	return NULL;
 }
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 90037b5..ba19a3a 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -132,7 +132,7 @@ deadline_merge(struct request_queue *q, struct request **req, struct bio *bio)
 	 * check for front merge
 	 */
 	if (dd->front_merges) {
-		sector_t sector = bio->bi_sector + bio_sectors(bio);
+		sector_t sector = bio_end_sector(bio);
 
 		__rq = elv_rb_find(&dd->sort_list[bio_data_dir(bio)], sector);
 		if (__rq) {
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 531ceb3..f1a29f8 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -334,8 +334,7 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
 	int err = -EIO;
 
 	sector = bio->bi_sector;
-	if (sector + (bio->bi_size >> SECTOR_SHIFT) >
-						get_capacity(bdev->bd_disk))
+	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk))
 		goto out;
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2e7de7a..26938e8 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -901,7 +901,7 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 			pd->iosched.successive_reads += bio->bi_size >> 10;
 		else {
 			pd->iosched.successive_reads = 0;
-			pd->iosched.last_write = bio->bi_sector + bio_sectors(bio);
+			pd->iosched.last_write = bio_end_sector(bio);
 		}
 		if (pd->iosched.successive_reads >= HI_SPEED_SWITCH) {
 			if (pd->read_speed == pd->write_speed) {
@@ -2454,7 +2454,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	zone = ZONE(bio->bi_sector, pd);
 	VPRINTK("pkt_make_request: start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_sector,
-		(unsigned long long)(bio->bi_sector + bio_sectors(bio)));
+		(unsigned long long)bio_end_sector(bio));
 
 	/* Check if we have to split the bio */
 	{
@@ -2462,7 +2462,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		sector_t last_zone;
 		int first_sectors;
 
-		last_zone = ZONE(bio->bi_sector + bio_sectors(bio) - 1, pd);
+		last_zone = ZONE(bio_end_sector(bio) - 1, pd);
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
 			first_sectors = last_zone - bio->bi_sector;
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index c89cde86..c6ec571 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -258,7 +258,7 @@ static int stripe_map_range(struct stripe_c *sc, struct bio *bio,
 	sector_t begin, end;
 
 	stripe_map_range_sector(sc, bio->bi_sector, target_stripe, &begin);
-	stripe_map_range_sector(sc, bio->bi_sector + bio_sectors(bio),
+	stripe_map_range_sector(sc, bio_end_sector(bio),
 				target_stripe, &end);
 	if (begin < end) {
 		bio->bi_bdev = sc->stripe[target_stripe].dev->bdev;
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 52cde98..03d6d21 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -472,7 +472,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 		return -EIO;
 	}
 
-	if ((bio->bi_sector + bio_sectors(bio)) >>
+	if (bio_end_sector(bio) >>
 	    (v->data_dev_block_bits - SECTOR_SHIFT) > v->data_blocks) {
 		DMERR_LIMIT("io out of range");
 		return -EIO;
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 5e7dc77..3193aef 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -185,8 +185,7 @@ static void make_request(struct mddev *mddev, struct bio *bio)
 			return;
 		}
 
-		if (check_sector(conf, bio->bi_sector, bio->bi_sector+(bio->bi_size>>9),
-				 WRITE))
+		if (check_sector(conf, bio->bi_sector, bio_end_sector(bio), WRITE))
 			failit = 1;
 		if (check_mode(conf, WritePersistent)) {
 			add_sector(conf, bio->bi_sector, WritePersistent);
@@ -196,8 +195,7 @@ static void make_request(struct mddev *mddev, struct bio *bio)
 			failit = 1;
 	} else {
 		/* read request */
-		if (check_sector(conf, bio->bi_sector, bio->bi_sector + (bio->bi_size>>9),
-				 READ))
+		if (check_sector(conf, bio->bi_sector, bio_end_sector(bio), READ))
 			failit = 1;
 		if (check_mode(conf, ReadTransient))
 			failit = 1;
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 2101483..f03fabd 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -317,8 +317,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 		bio_io_error(bio);
 		return;
 	}
-	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
-		     tmp_dev->end_sector)) {
+	if (unlikely(bio_end_sector(bio) > tmp_dev->end_sector)) {
 		/* This bio crosses a device boundary, so we have to
 		 * split it.
 		 */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d5bddfc..2117622 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1016,7 +1016,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	md_write_start(mddev, bio); /* wait on superblock update early */
 
 	if (bio_data_dir(bio) == WRITE &&
-	    bio->bi_sector + bio->bi_size/512 > mddev->suspend_lo &&
+	    bio_end_sector(bio) > mddev->suspend_lo &&
 	    bio->bi_sector < mddev->suspend_hi) {
 		/* As the suspend_* range is controlled by
 		 * userspace, we want an interruptible
@@ -1027,7 +1027,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 			flush_signals(current);
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_INTERRUPTIBLE);
-			if (bio->bi_sector + bio->bi_size/512 <= mddev->suspend_lo ||
+			if (bio_end_sector(bio) <= mddev->suspend_lo ||
 			    bio->bi_sector >= mddev->suspend_hi)
 				break;
 			schedule();
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9ab506d..a203039 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2421,11 +2421,11 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	} else
 		bip = &sh->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
-		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
+		if (bio_end_sector(*bip) > bi->bi_sector)
 			goto overlap;
 		bip = & (*bip)->bi_next;
 	}
-	if (*bip && (*bip)->bi_sector < bi->bi_sector + ((bi->bi_size)>>9))
+	if (*bip && (*bip)->bi_sector < bio_end_sector(bi))
 		goto overlap;
 
 	BUG_ON(*bip && bi->bi_next && (*bip) != bi->bi_next);
@@ -2441,8 +2441,8 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
 			     bi && bi->bi_sector <= sector;
 		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
-			if (bi->bi_sector + (bi->bi_size>>9) >= sector)
-				sector = bi->bi_sector + (bi->bi_size>>9);
+			if (bio_end_sector(bi) >= sector)
+				sector = bio_end_sector(bi);
 		}
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
@@ -3978,7 +3978,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 						    0,
 						    &dd_idx, NULL);
 
-	end_sector = align_bi->bi_sector + (align_bi->bi_size >> 9);
+	end_sector = bio_end_sector(align_bi);
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].replacement);
 	if (!rdev || test_bit(Faulty, &rdev->flags) ||
@@ -4253,7 +4253,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	}
 
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
-	last_sector = bi->bi_sector + (bi->bi_size>>9);
+	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
@@ -4716,7 +4716,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(conf, logical_sector,
 				      0, &dd_idx, NULL);
-	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
+	last_sector = bio_end_sector(raid_bio);
 
 	for (; logical_sector < last_sector;
 	     logical_sector += STRIPE_SECTORS,
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index b6ad0de..12d08b4 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -826,8 +826,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	if ((bio->bi_sector & 7) != 0 || (bio->bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
 		goto fail;
-	if (((bio->bi_size >> 9) + bio->bi_sector)
-			> get_capacity(bio->bi_bdev->bd_disk)) {
+	if (bio_end_sector(bio) > get_capacity(bio->bi_bdev->bd_disk)) {
 		/* Request beyond end of DCSS segment. */
 		goto fail;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1b319df..a291f44 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2526,8 +2526,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 		if (old_compressed)
 			contig = bio->bi_sector == sector;
 		else
-			contig = bio->bi_sector + (bio->bi_size >> 9) ==
-				sector;
+			contig = bio_end_sector(bio) == sector;
 
 		if (prev_bio_flags != bio_flags || !contig ||
 		    merge_bio(tree, page, offset, page_size, bio, bio_flags) ||
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9ceccb1..ada9c6a 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -300,7 +300,7 @@ static struct bio *gfs2_log_get_bio(struct gfs2_sbd *sdp, u64 blkno)
 	u64 nblk;
 
 	if (bio) {
-		nblk = bio->bi_sector + bio_sectors(bio);
+		nblk = bio_end_sector(bio);
 		nblk >>= sdp->sd_fsb2bb_shift;
 		if (blkno == nblk)
 			return bio;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fcb4dba..20507eb 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -67,6 +67,7 @@
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
+#define bio_end_sector(bio)	((bio)->bi_sector + bio_sectors((bio)))
 
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
-- 
1.7.12

