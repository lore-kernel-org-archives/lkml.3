Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3C0Rk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:40:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36046 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3C0RkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:18 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 01/22] block: Abstract out bvec iterator
Date: Wed, 27 Mar 2013 10:39:31 -0700
Message-Id: <1364405992-28424-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Immutable biovecs are going to require an explicit iterator. To
implement immutable bvecs, a later patch is going to add a bi_bvec_done
member to this struct; for now, this patch effectively just renames
things.

CC: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 Documentation/block/biodoc.txt      |  7 ++-
 arch/m68k/emu/nfblock.c             |  2 +-
 arch/powerpc/sysdev/axonram.c       |  3 +-
 block/blk-core.c                    | 36 +++++++-------
 block/blk-flush.c                   |  2 +-
 block/blk-lib.c                     | 12 ++---
 block/blk-map.c                     |  6 +--
 block/blk-merge.c                   |  4 +-
 block/blk-throttle.c                | 13 ++---
 block/elevator.c                    |  2 +-
 drivers/block/aoe/aoecmd.c          |  6 +--
 drivers/block/brd.c                 |  4 +-
 drivers/block/drbd/drbd_actlog.c    |  2 +-
 drivers/block/drbd/drbd_bitmap.c    |  2 +-
 drivers/block/drbd/drbd_receiver.c  |  6 +--
 drivers/block/drbd/drbd_req.c       |  6 +--
 drivers/block/drbd/drbd_req.h       |  2 +-
 drivers/block/floppy.c              |  4 +-
 drivers/block/loop.c                |  4 +-
 drivers/block/mtip32xx/mtip32xx.c   |  4 +-
 drivers/block/nvme.c                | 15 +++---
 drivers/block/pktcdvd.c             | 53 +++++++++++----------
 drivers/block/ps3disk.c             |  2 +-
 drivers/block/rbd.c                 | 20 ++++----
 drivers/block/rsxx/dev.c            |  4 +-
 drivers/block/rsxx/dma.c            |  4 +-
 drivers/block/umem.c                |  9 ++--
 drivers/block/virtio_blk.c          |  4 +-
 drivers/block/xen-blkback/blkback.c |  2 +-
 drivers/md/dm-bio-record.h          | 12 ++---
 drivers/md/dm-bufio.c               |  2 +-
 drivers/md/dm-cache-policy-mq.c     |  4 +-
 drivers/md/dm-cache-target.c        | 16 ++++---
 drivers/md/dm-crypt.c               | 20 ++++----
 drivers/md/dm-delay.c               |  7 +--
 drivers/md/dm-flakey.c              |  7 +--
 drivers/md/dm-io.c                  |  7 +--
 drivers/md/dm-linear.c              |  3 +-
 drivers/md/dm-raid1.c               | 16 +++----
 drivers/md/dm-region-hash.c         |  3 +-
 drivers/md/dm-snap.c                | 13 ++---
 drivers/md/dm-stripe.c              | 13 +++--
 drivers/md/dm-thin.c                | 23 +++++----
 drivers/md/dm-verity.c              |  9 ++--
 drivers/md/dm.c                     | 21 ++++----
 drivers/md/faulty.c                 | 19 +++++---
 drivers/md/linear.c                 | 12 ++---
 drivers/md/md.c                     | 25 +++++-----
 drivers/md/multipath.c              | 13 ++---
 drivers/md/raid0.c                  | 16 ++++---
 drivers/md/raid1.c                  | 63 +++++++++++++-----------
 drivers/md/raid10.c                 | 95 ++++++++++++++++++++-----------------
 drivers/md/raid5.c                  | 72 ++++++++++++++--------------
 drivers/s390/block/dcssblk.c        |  5 +-
 drivers/s390/block/xpram.c          |  9 ++--
 drivers/scsi/osd/osd_initiator.c    |  2 +-
 drivers/staging/zram/zram_drv.c     | 12 +++--
 drivers/target/target_core_iblock.c |  2 +-
 fs/bio-integrity.c                  |  8 ++--
 fs/bio.c                            | 41 ++++++++--------
 fs/btrfs/check-integrity.c          | 10 ++--
 fs/btrfs/compression.c              | 17 +++----
 fs/btrfs/extent_io.c                | 18 +++----
 fs/btrfs/file-item.c                | 13 ++---
 fs/btrfs/inode.c                    | 17 +++----
 fs/btrfs/raid56.c                   | 22 ++++-----
 fs/btrfs/scrub.c                    | 12 ++---
 fs/btrfs/volumes.c                  | 12 ++---
 fs/buffer.c                         | 12 ++---
 fs/direct-io.c                      |  4 +-
 fs/ext4/page-io.c                   |  4 +-
 fs/f2fs/data.c                      |  2 +-
 fs/f2fs/segment.c                   |  3 +-
 fs/gfs2/lops.c                      |  2 +-
 fs/gfs2/ops_fstype.c                |  2 +-
 fs/hfsplus/wrapper.c                |  2 +-
 fs/jfs/jfs_logmgr.c                 | 10 ++--
 fs/jfs/jfs_metapage.c               |  9 ++--
 fs/logfs/dev_bdev.c                 | 20 ++++----
 fs/mpage.c                          |  2 +-
 fs/nfs/blocklayout/blocklayout.c    |  9 ++--
 fs/nilfs2/segbuf.c                  |  3 +-
 fs/ocfs2/cluster/heartbeat.c        |  2 +-
 fs/xfs/xfs_aops.c                   |  2 +-
 fs/xfs/xfs_buf.c                    |  4 +-
 include/linux/bio.h                 | 16 +++----
 include/linux/blk_types.h           | 21 ++++----
 include/trace/events/block.h        | 26 +++++-----
 kernel/power/block_io.c             |  2 +-
 kernel/trace/blktrace.c             | 15 +++---
 mm/page_io.c                        | 10 ++--
 net/ceph/messenger.c                |  2 +-
 92 files changed, 591 insertions(+), 524 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 8df5e8e..2101e71 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -447,14 +447,13 @@ struct bio_vec {
  * main unit of I/O for the block layer and lower layers (ie drivers)
  */
 struct bio {
-       sector_t            bi_sector;
        struct bio          *bi_next;    /* request queue link */
        struct block_device *bi_bdev;	/* target device */
        unsigned long       bi_flags;    /* status, command, etc */
        unsigned long       bi_rw;       /* low bits: r/w, high: priority */
 
        unsigned int	bi_vcnt;     /* how may bio_vec's */
-       unsigned int	bi_idx;		/* current index into bio_vec array */
+       struct bvec_iter	bi_iter;	/* current index into bio_vec array */
 
        unsigned int	bi_size;     /* total size in bytes */
        unsigned short 	bi_phys_segments; /* segments after physaddr coalesce*/
@@ -480,7 +479,7 @@ With this multipage bio design:
 - Code that traverses the req list can find all the segments of a bio
   by using rq_for_each_segment.  This handles the fact that a request
   has multiple bios, each of which can have multiple segments.
-- Drivers which can't process a large bio in one shot can use the bi_idx
+- Drivers which can't process a large bio in one shot can use the bi_iter
   field to keep track of the next bio_vec entry to process.
   (e.g a 1MB bio_vec needs to be handled in max 128kB chunks for IDE)
   [TBD: Should preferably also have a bi_voffset and bi_vlen to avoid modifying
@@ -589,7 +588,7 @@ driver should not modify these values. The block layer sets up the
 nr_sectors and current_nr_sectors fields (based on the corresponding
 hard_xxx values and the number of bytes transferred) and updates it on
 every transfer that invokes end_that_request_first. It does the same for the
-buffer, bio, bio->bi_idx fields too.
+buffer, bio, bio->bi_iter fields too.
 
 The buffer field is just a virtual address mapping of the current segment
 of the i/o buffer in cases where the buffer resides in low-memory. For high
diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index e301133..9070d6c 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -64,7 +64,7 @@ static void nfhd_make_request(struct request_queue *queue, struct bio *bio)
 	struct nfhd_device *dev = queue->queuedata;
 	struct bio_vec *bvec;
 	int i, dir, len, shift;
-	sector_t sec = bio->bi_sector;
+	sector_t sec = bio->bi_iter.bi_sector;
 
 	dir = bio_data_dir(bio);
 	shift = dev->bshift;
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 1c16141..f33bcba 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -113,7 +113,8 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 	unsigned int transfered;
 	unsigned short idx;
 
-	phys_mem = bank->io_addr + (bio->bi_sector << AXON_RAM_SECTOR_SHIFT);
+	phys_mem = bank->io_addr + (bio->bi_iter.bi_sector <<
+				    AXON_RAM_SECTOR_SHIFT);
 	phys_end = bank->io_addr + bank->size;
 	transfered = 0;
 	bio_for_each_segment(vec, bio, idx) {
diff --git a/block/blk-core.c b/block/blk-core.c
index f224d17..25a4bb8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -165,7 +165,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 	bio_advance(bio, nbytes);
 
 	/* don't actually finish bio if it's part of flush sequence */
-	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
+	if (bio->bi_iter.bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
 		bio_endio(bio, error);
 }
 
@@ -1332,7 +1332,7 @@ void blk_add_request_payload(struct request *rq, struct page *page,
 	bio->bi_io_vec->bv_offset = 0;
 	bio->bi_io_vec->bv_len = len;
 
-	bio->bi_size = len;
+	bio->bi_iter.bi_size = len;
 	bio->bi_vcnt = 1;
 	bio->bi_phys_segments = 1;
 
@@ -1357,7 +1357,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
 
 	req->biotail->bi_next = bio;
 	req->biotail = bio;
-	req->__data_len += bio->bi_size;
+	req->__data_len += bio->bi_iter.bi_size;
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
@@ -1386,8 +1386,8 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 	 * not touch req->buffer either...
 	 */
 	req->buffer = bio_data(bio);
-	req->__sector = bio->bi_sector;
-	req->__data_len += bio->bi_size;
+	req->__sector = bio->bi_iter.bi_sector;
+	req->__data_len += bio->bi_iter.bi_size;
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
@@ -1456,7 +1456,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 		req->cmd_flags |= REQ_FAILFAST_MASK;
 
 	req->errors = 0;
-	req->__sector = bio->bi_sector;
+	req->__sector = bio->bi_iter.bi_sector;
 	req->ioprio = bio_prio(bio);
 	blk_rq_bio_prep(req->q, req, bio);
 }
@@ -1582,12 +1582,12 @@ static inline void blk_partition_remap(struct bio *bio)
 	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
 		struct hd_struct *p = bdev->bd_part;
 
-		bio->bi_sector += p->start_sect;
+		bio->bi_iter.bi_sector += p->start_sect;
 		bio->bi_bdev = bdev->bd_contains;
 
 		trace_block_bio_remap(bdev_get_queue(bio->bi_bdev), bio,
 				      bdev->bd_dev,
-				      bio->bi_sector - p->start_sect);
+				      bio->bi_iter.bi_sector - p->start_sect);
 	}
 }
 
@@ -1653,7 +1653,7 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
 	/* Test device or partition size, when known. */
 	maxsector = i_size_read(bio->bi_bdev->bd_inode) >> 9;
 	if (maxsector) {
-		sector_t sector = bio->bi_sector;
+		sector_t sector = bio->bi_iter.bi_sector;
 
 		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
 			/*
@@ -1689,7 +1689,7 @@ generic_make_request_checks(struct bio *bio)
 		       "generic_make_request: Trying to access "
 			"nonexistent block-device %s (%Lu)\n",
 			bdevname(bio->bi_bdev, b),
-			(long long) bio->bi_sector);
+			(long long) bio->bi_iter.bi_sector);
 		goto end_io;
 	}
 
@@ -1703,9 +1703,9 @@ generic_make_request_checks(struct bio *bio)
 	}
 
 	part = bio->bi_bdev->bd_part;
-	if (should_fail_request(part, bio->bi_size) ||
+	if (should_fail_request(part, bio->bi_iter.bi_size) ||
 	    should_fail_request(&part_to_disk(part)->part0,
-				bio->bi_size))
+				bio->bi_iter.bi_size))
 		goto end_io;
 
 	/*
@@ -1864,7 +1864,7 @@ void submit_bio(int rw, struct bio *bio)
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
-			task_io_account_read(bio->bi_size);
+			task_io_account_read(bio->bi_iter.bi_size);
 			count_vm_events(PGPGIN, count);
 		}
 
@@ -1873,7 +1873,7 @@ void submit_bio(int rw, struct bio *bio)
 			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
 			current->comm, task_pid_nr(current),
 				(rw & WRITE) ? "WRITE" : "READ",
-				(unsigned long long)bio->bi_sector,
+				(unsigned long long)bio->bi_iter.bi_sector,
 				bdevname(bio->bi_bdev, b),
 				count);
 		}
@@ -2006,7 +2006,7 @@ unsigned int blk_rq_err_bytes(const struct request *rq)
 	for (bio = rq->bio; bio; bio = bio->bi_next) {
 		if ((bio->bi_rw & ff) != ff)
 			break;
-		bytes += bio->bi_size;
+		bytes += bio->bi_iter.bi_size;
 	}
 
 	/* this could lead to infinite loop */
@@ -2331,9 +2331,9 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	total_bytes = 0;
 	while (req->bio) {
 		struct bio *bio = req->bio;
-		unsigned bio_bytes = min(bio->bi_size, nr_bytes);
+		unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
 
-		if (bio_bytes == bio->bi_size)
+		if (bio_bytes == bio->bi_iter.bi_size)
 			req->bio = bio->bi_next;
 
 		req_bio_endio(req, bio, bio_bytes, error);
@@ -2682,7 +2682,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		rq->nr_phys_segments = bio_phys_segments(q, bio);
 		rq->buffer = bio_data(bio);
 	}
-	rq->__data_len = bio->bi_size;
+	rq->__data_len = bio->bi_iter.bi_size;
 	rq->bio = rq->biotail = bio;
 
 	if (bio->bi_bdev)
diff --git a/block/blk-flush.c b/block/blk-flush.c
index db8f1b5..3248998 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -444,7 +444,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	 * copied from blk_rq_pos(rq).
 	 */
 	if (error_sector)
-               *error_sector = bio->bi_sector;
+		*error_sector = bio->bi_iter.bi_sector;
 
 	if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
diff --git a/block/blk-lib.c b/block/blk-lib.c
index d6f50d5..3250620 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -110,12 +110,12 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 			req_sects = end_sect - sector;
 		}
 
-		bio->bi_sector = sector;
+		bio->bi_iter.bi_sector = sector;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
 		bio->bi_private = &bb;
 
-		bio->bi_size = req_sects << 9;
+		bio->bi_iter.bi_size = req_sects << 9;
 		nr_sects -= req_sects;
 		sector = end_sect;
 
@@ -176,7 +176,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 			break;
 		}
 
-		bio->bi_sector = sector;
+		bio->bi_iter.bi_sector = sector;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
 		bio->bi_private = &bb;
@@ -186,11 +186,11 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
 
 		if (nr_sects > max_write_same_sectors) {
-			bio->bi_size = max_write_same_sectors << 9;
+			bio->bi_iter.bi_size = max_write_same_sectors << 9;
 			nr_sects -= max_write_same_sectors;
 			sector += max_write_same_sectors;
 		} else {
-			bio->bi_size = nr_sects << 9;
+			bio->bi_iter.bi_size = nr_sects << 9;
 			nr_sects = 0;
 		}
 
@@ -242,7 +242,7 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			break;
 		}
 
-		bio->bi_sector = sector;
+		bio->bi_iter.bi_sector = sector;
 		bio->bi_bdev   = bdev;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_private = &bb;
diff --git a/block/blk-map.c b/block/blk-map.c
index 623e1cd..ae4ae10 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -20,7 +20,7 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->__data_len += bio->bi_size;
+		rq->__data_len += bio->bi_iter.bi_size;
 	}
 	return 0;
 }
@@ -76,7 +76,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 
 	ret = blk_rq_append_bio(q, rq, bio);
 	if (!ret)
-		return bio->bi_size;
+		return bio->bi_iter.bi_size;
 
 	/* if it was boucned we must call the end io function */
 	bio_endio(bio, 0);
@@ -220,7 +220,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (bio->bi_size != len) {
+	if (bio->bi_iter.bi_size != len) {
 		/*
 		 * Grab an extra reference to this bio, as bio_unmap_user()
 		 * expects to be able to drop it twice as it happens on the
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 936a110..5b04c25 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -532,9 +532,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 
 int blk_try_merge(struct request *rq, struct bio *bio)
 {
-	if (blk_rq_pos(rq) + blk_rq_sectors(rq) == bio->bi_sector)
+	if (blk_rq_pos(rq) + blk_rq_sectors(rq) == bio->bi_iter.bi_sector)
 		return ELEVATOR_BACK_MERGE;
-	else if (blk_rq_pos(rq) - bio_sectors(bio) == bio->bi_sector)
+	else if (blk_rq_pos(rq) - bio_sectors(bio) == bio->bi_iter.bi_sector)
 		return ELEVATOR_FRONT_MERGE;
 	return ELEVATOR_NO_MERGE;
 }
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3114622..fc06b58 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -590,14 +590,14 @@ static bool tg_with_in_bps_limit(struct throtl_data *td, struct throtl_grp *tg,
 	do_div(tmp, HZ);
 	bytes_allowed = tmp;
 
-	if (tg->bytes_disp[rw] + bio->bi_size <= bytes_allowed) {
+	if (tg->bytes_disp[rw] + bio->bi_iter.bi_size <= bytes_allowed) {
 		if (wait)
 			*wait = 0;
 		return 1;
 	}
 
 	/* Calc approx time to dispatch */
-	extra_bytes = tg->bytes_disp[rw] + bio->bi_size - bytes_allowed;
+	extra_bytes = tg->bytes_disp[rw] + bio->bi_iter.bi_size - bytes_allowed;
 	jiffy_wait = div64_u64(extra_bytes * HZ, tg->bps[rw]);
 
 	if (!jiffy_wait)
@@ -705,10 +705,11 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	bool rw = bio_data_dir(bio);
 
 	/* Charge the bio to the group */
-	tg->bytes_disp[rw] += bio->bi_size;
+	tg->bytes_disp[rw] += bio->bi_iter.bi_size;
 	tg->io_disp[rw]++;
 
-	throtl_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size, bio->bi_rw);
+	throtl_update_dispatch_stats(tg_to_blkg(tg),
+				     bio->bi_iter.bi_size, bio->bi_rw);
 }
 
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
@@ -1128,7 +1129,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	if (tg) {
 		if (tg_no_rule_group(tg, rw)) {
 			throtl_update_dispatch_stats(tg_to_blkg(tg),
-						     bio->bi_size, bio->bi_rw);
+					bio->bi_iter.bi_size, bio->bi_rw);
 			goto out_unlock_rcu;
 		}
 	}
@@ -1175,7 +1176,7 @@ queue_bio:
 	throtl_log_tg(td, tg, "[%c] bio. bdisp=%llu sz=%u bps=%llu"
 			" iodisp=%u iops=%u queued=%d/%d",
 			rw == READ ? 'R' : 'W',
-			tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
+			tg->bytes_disp[rw], bio->bi_iter.bi_size, tg->bps[rw],
 			tg->io_disp[rw], tg->iops[rw],
 			tg->nr_queued[READ], tg->nr_queued[WRITE]);
 
diff --git a/block/elevator.c b/block/elevator.c
index eba5b04..ddb92b6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -442,7 +442,7 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
-	__rq = elv_rqhash_find(q, bio->bi_sector);
+	__rq = elv_rqhash_find(q, bio->bi_iter.bi_sector);
 	if (__rq && elv_rq_merge_ok(__rq, bio)) {
 		*req = __rq;
 		return ELEVATOR_BACK_MERGE;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index af96ca1..039ce17 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -924,8 +924,8 @@ bufinit(struct buf *buf, struct request *rq, struct bio *bio)
 	memset(buf, 0, sizeof(*buf));
 	buf->rq = rq;
 	buf->bio = bio;
-	buf->resid = bio->bi_size;
-	buf->sector = bio->bi_sector;
+	buf->resid = bio->bi_iter.bi_size;
+	buf->sector = bio->bi_iter.bi_sector;
 	bio_pageinc(bio);
 	buf->bv = bv = bio_iovec(bio);
 	buf->bv_resid = bv->bv_len;
@@ -1147,7 +1147,7 @@ aoe_end_request(struct aoedev *d, struct request *rq, int fastfail)
 	do {
 		bio = rq->bio;
 		bok = !fastfail && test_bit(BIO_UPTODATE, &bio->bi_flags);
-	} while (__blk_end_request(rq, bok ? 0 : -EIO, bio->bi_size));
+	} while (__blk_end_request(rq, bok ? 0 : -EIO, bio->bi_iter.bi_size));
 
 	/* cf. http://lkml.org/lkml/2006/10/31/28 */
 	if (!fastfail)
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index f1a29f8..ddf2b79 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -333,13 +333,13 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
 	int i;
 	int err = -EIO;
 
-	sector = bio->bi_sector;
+	sector = bio->bi_iter.bi_sector;
 	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk))
 		goto out;
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
 		err = 0;
-		discard_from_brd(brd, sector, bio->bi_size);
+		discard_from_brd(brd, sector, bio->bi_iter.bi_size);
 		goto out;
 	}
 
diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 92510f8..a46ec01 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -160,7 +160,7 @@ static int _drbd_md_sync_page_io(struct drbd_conf *mdev,
 
 	bio = bio_alloc_drbd(GFP_NOIO);
 	bio->bi_bdev = bdev->md_bdev;
-	bio->bi_sector = sector;
+	bio->bi_iter.bi_sector = sector;
 	err = -EIO;
 	if (bio_add_page(bio, page, size, 0) != size)
 		goto out;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 8dc2950..65d8f1d 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1017,7 +1017,7 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 	} else
 		page = b->bm_pages[page_nr];
 	bio->bi_bdev = mdev->ldev->md_bdev;
-	bio->bi_sector = on_disk_sector;
+	bio->bi_iter.bi_sector = on_disk_sector;
 	/* bio_add_page of a single page to an empty bio will always succeed,
 	 * according to api.  Do we want to assert that? */
 	bio_add_page(bio, page, len, 0);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a9eccfc..bd27a65 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1331,7 +1331,7 @@ next_bio:
 		goto fail;
 	}
 	/* > peer_req->i.sector, unless this is the first bio */
-	bio->bi_sector = sector;
+	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = mdev->ldev->backing_bdev;
 	bio->bi_rw = rw;
 	bio->bi_private = peer_req;
@@ -1351,7 +1351,7 @@ next_bio:
 				dev_err(DEV,
 					"bio_add_page failed for len=%u, "
 					"bi_vcnt=0 (bi_sector=%llu)\n",
-					len, (unsigned long long)bio->bi_sector);
+					len, (uint64_t)bio->bi_iter.bi_sector);
 				err = -ENOSPC;
 				goto fail;
 			}
@@ -1613,7 +1613,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
 	mdev->recv_cnt += data_size>>9;
 
 	bio = req->master_bio;
-	D_ASSERT(sector == bio->bi_sector);
+	D_ASSERT(sector == bio->bi_iter.bi_sector);
 
 	bio_for_each_segment(bvec, bio, i) {
 		void *mapped = kmap(bvec->bv_page) + bvec->bv_offset;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 2b8303a..1a98c85 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -77,8 +77,8 @@ static struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 	req->epoch       = 0;
 
 	drbd_clear_interval(&req->i);
-	req->i.sector     = bio_src->bi_sector;
-	req->i.size      = bio_src->bi_size;
+	req->i.sector     = bio_src->bi_iter.bi_sector;
+	req->i.size      = bio_src->bi_iter.bi_size;
 	req->i.local = true;
 	req->i.waiting = false;
 
@@ -1150,7 +1150,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	/*
 	 * what we "blindly" assume:
 	 */
-	D_ASSERT(IS_ALIGNED(bio->bi_size, 512));
+	D_ASSERT(IS_ALIGNED(bio->bi_iter.bi_size, 512));
 
 	inc_ap_bio(mdev);
 	__drbd_make_request(mdev, bio, start_time);
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index c08d229..2a7d772 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -261,7 +261,7 @@ static inline void drbd_req_make_private_bio(struct drbd_request *req, struct bi
 
 /* Short lived temporary struct on the stack.
  * We could squirrel the error to be returned into
- * bio->bi_size, or similar. But that would be too ugly. */
+ * bio->bi_iter.bi_size, or similar. But that would be too ugly. */
 struct bio_and_error {
 	struct bio *bio;
 	int error;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 8323263..f09fb23 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3777,9 +3777,9 @@ static int __floppy_read_block_0(struct block_device *bdev)
 	bio_vec.bv_len = size;
 	bio_vec.bv_offset = 0;
 	bio.bi_vcnt = 1;
-	bio.bi_size = size;
+	bio.bi_iter.bi_size = size;
 	bio.bi_bdev = bdev;
-	bio.bi_sector = 0;
+	bio.bi_iter.bi_sector = 0;
 	bio.bi_flags = (1 << BIO_QUIET);
 	init_completion(&complete);
 	bio.bi_private = &complete;
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 747bb2a..2e4e0be 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -413,7 +413,7 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	loff_t pos;
 	int ret;
 
-	pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
+	pos = ((loff_t) bio->bi_iter.bi_sector << 9) + lo->lo_offset;
 
 	if (bio_rw(bio) == WRITE) {
 		struct file *file = lo->lo_backing_file;
@@ -442,7 +442,7 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 				goto out;
 			}
 			ret = file->f_op->fallocate(file, mode, pos,
-						    bio->bi_size);
+						    bio->bi_iter.bi_size);
 			if (unlikely(ret && ret != -EINVAL &&
 				     ret != -EOPNOTSUPP))
 				ret = -EIO;
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 11cc952..85b9f12 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3758,7 +3758,7 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 	}
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
-		bio_endio(bio, mtip_send_trim(dd, bio->bi_sector,
+		bio_endio(bio, mtip_send_trim(dd, bio->bi_iter.bi_sector,
 						bio_sectors(bio)));
 		return;
 	}
@@ -3791,7 +3791,7 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 		/* Issue the read/write. */
 		mtip_hw_submit_io(dd,
-				bio->bi_sector,
+				bio->bi_iter.bi_sector,
 				bio_sectors(bio),
 				nents,
 				tag,
diff --git a/drivers/block/nvme.c b/drivers/block/nvme.c
index 07fb2df..bc97493 100644
--- a/drivers/block/nvme.c
+++ b/drivers/block/nvme.c
@@ -380,7 +380,7 @@ static void bio_completion(struct nvme_dev *dev, void *ctx,
 	nvme_free_iod(dev, iod);
 	if (status) {
 		bio_endio(bio, -EIO);
-	} else if (bio->bi_vcnt > bio->bi_idx) {
+	} else if (bio->bi_vcnt > bio->bi_iter.bi_idx) {
 		requeue_bio(dev, bio);
 	} else {
 		bio_endio(bio, 0);
@@ -481,7 +481,7 @@ static int nvme_map_bio(struct device *dev, struct nvme_iod *iod,
 	int i, old_idx, length = 0, nsegs = 0;
 
 	sg_init_table(iod->sg, psegs);
-	old_idx = bio->bi_idx;
+	old_idx = bio->bi_iter.bi_idx;
 	bio_for_each_segment(bvec, bio, i) {
 		if (bvprv && BIOVEC_PHYS_MERGEABLE(bvprv, bvec)) {
 			sg->length += bvec->bv_len;
@@ -496,11 +496,11 @@ static int nvme_map_bio(struct device *dev, struct nvme_iod *iod,
 		length += bvec->bv_len;
 		bvprv = bvec;
 	}
-	bio->bi_idx = i;
+	bio->bi_iter.bi_idx = i;
 	iod->nents = nsegs;
 	sg_mark_end(sg);
 	if (dma_map_sg(dev, iod->sg, iod->nents, dma_dir) == 0) {
-		bio->bi_idx = old_idx;
+		bio->bi_iter.bi_idx = old_idx;
 		return -ENOMEM;
 	}
 	return length;
@@ -553,7 +553,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 			return result;
 	}
 
-	iod = nvme_alloc_iod(psegs, bio->bi_size, GFP_ATOMIC);
+	iod = nvme_alloc_iod(psegs, bio->bi_iter.bi_size, GFP_ATOMIC);
 	if (!iod)
 		goto nomem;
 	iod->private = bio;
@@ -596,12 +596,13 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
 	cmnd->rw.nsid = cpu_to_le32(ns->ns_id);
 	length = nvme_setup_prps(nvmeq->dev, &cmnd->common, iod, length,
 								GFP_ATOMIC);
-	cmnd->rw.slba = cpu_to_le64(bio->bi_sector >> (ns->lba_shift - 9));
+	cmnd->rw.slba = cpu_to_le64(bio->bi_iter.bi_sector >>
+				    (ns->lba_shift - 9));
 	cmnd->rw.length = cpu_to_le16((length >> ns->lba_shift) - 1);
 	cmnd->rw.control = cpu_to_le16(control);
 	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
 
-	bio->bi_sector += length >> 9;
+	bio->bi_iter.bi_sector += length >> 9;
 
 	if (++nvmeq->sq_tail == nvmeq->q_depth)
 		nvmeq->sq_tail = 0;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1119042..05e8e59 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -658,7 +658,7 @@ static struct pkt_rb_node *pkt_rbtree_find(struct pktcdvd_device *pd, sector_t s
 
 	for (;;) {
 		tmp = rb_entry(n, struct pkt_rb_node, rb_node);
-		if (s <= tmp->bio->bi_sector)
+		if (s <= tmp->bio->bi_iter.bi_sector)
 			next = n->rb_left;
 		else
 			next = n->rb_right;
@@ -667,12 +667,12 @@ static struct pkt_rb_node *pkt_rbtree_find(struct pktcdvd_device *pd, sector_t s
 		n = next;
 	}
 
-	if (s > tmp->bio->bi_sector) {
+	if (s > tmp->bio->bi_iter.bi_sector) {
 		tmp = pkt_rbtree_next(tmp);
 		if (!tmp)
 			return NULL;
 	}
-	BUG_ON(s > tmp->bio->bi_sector);
+	BUG_ON(s > tmp->bio->bi_iter.bi_sector);
 	return tmp;
 }
 
@@ -683,13 +683,13 @@ static void pkt_rbtree_insert(struct pktcdvd_device *pd, struct pkt_rb_node *nod
 {
 	struct rb_node **p = &pd->bio_queue.rb_node;
 	struct rb_node *parent = NULL;
-	sector_t s = node->bio->bi_sector;
+	sector_t s = node->bio->bi_iter.bi_sector;
 	struct pkt_rb_node *tmp;
 
 	while (*p) {
 		parent = *p;
 		tmp = rb_entry(parent, struct pkt_rb_node, rb_node);
-		if (s < tmp->bio->bi_sector)
+		if (s < tmp->bio->bi_iter.bi_sector)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -867,7 +867,8 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 			spin_lock(&pd->iosched.lock);
 			bio = bio_list_peek(&pd->iosched.write_queue);
 			spin_unlock(&pd->iosched.lock);
-			if (bio && (bio->bi_sector == pd->iosched.last_write))
+			if (bio && (bio->bi_iter.bi_sector ==
+				    pd->iosched.last_write))
 				need_write_seek = 0;
 			if (need_write_seek && reads_queued) {
 				if (atomic_read(&pd->cdrw.pending_bios) > 0) {
@@ -898,7 +899,8 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 			continue;
 
 		if (bio_data_dir(bio) == READ)
-			pd->iosched.successive_reads += bio->bi_size >> 10;
+			pd->iosched.successive_reads +=
+				bio->bi_iter.bi_size >> 10;
 		else {
 			pd->iosched.successive_reads = 0;
 			pd->iosched.last_write = bio_end_sector(bio);
@@ -987,7 +989,8 @@ static void pkt_end_io_read(struct bio *bio, int err)
 	BUG_ON(!pd);
 
 	VPRINTK("pkt_end_io_read: bio=%p sec0=%llx sec=%llx err=%d\n", bio,
-		(unsigned long long)pkt->sector, (unsigned long long)bio->bi_sector, err);
+		(unsigned long long)pkt->sector,
+		(unsigned long long)bio->bi_iter.bi_sector, err);
 
 	if (err)
 		atomic_inc(&pkt->io_errors);
@@ -1035,8 +1038,9 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	memset(written, 0, sizeof(written));
 	spin_lock(&pkt->lock);
 	bio_list_for_each(bio, &pkt->orig_bios) {
-		int first_frame = (bio->bi_sector - pkt->sector) / (CD_FRAMESIZE >> 9);
-		int num_frames = bio->bi_size / CD_FRAMESIZE;
+		int first_frame = (bio->bi_iter.bi_sector - pkt->sector) /
+			(CD_FRAMESIZE >> 9);
+		int num_frames = bio->bi_iter.bi_size / CD_FRAMESIZE;
 		pd->stats.secs_w += num_frames * (CD_FRAMESIZE >> 9);
 		BUG_ON(first_frame < 0);
 		BUG_ON(first_frame + num_frames > pkt->frames);
@@ -1062,7 +1066,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 		bio = pkt->r_bios[f];
 		bio_reset(bio);
-		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
+		bio->bi_iter.bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
 		bio->bi_bdev = pd->bdev;
 		bio->bi_end_io = pkt_end_io_read;
 		bio->bi_private = pkt;
@@ -1159,8 +1163,8 @@ static int pkt_start_recovery(struct packet_data *pkt)
 	bio_reset(pkt->bio);
 	pkt->bio->bi_bdev = pd->bdev;
 	pkt->bio->bi_rw = REQ_WRITE;
-	pkt->bio->bi_sector = new_sector;
-	pkt->bio->bi_size = pkt->frames * CD_FRAMESIZE;
+	pkt->bio->bi_iter.bi_sector = new_sector;
+	pkt->bio->bi_iter.bi_size = pkt->frames * CD_FRAMESIZE;
 	pkt->bio->bi_vcnt = pkt->frames;
 
 	pkt->bio->bi_end_io = pkt_end_io_packet_write;
@@ -1223,7 +1227,7 @@ static int pkt_handle_queue(struct pktcdvd_device *pd)
 	node = first_node;
 	while (node) {
 		bio = node->bio;
-		zone = ZONE(bio->bi_sector, pd);
+		zone = ZONE(bio->bi_iter.bi_sector, pd);
 		list_for_each_entry(p, &pd->cdrw.pkt_active_list, list) {
 			if (p->sector == zone) {
 				bio = NULL;
@@ -1263,13 +1267,13 @@ try_next_bio:
 	while ((node = pkt_rbtree_find(pd, zone)) != NULL) {
 		bio = node->bio;
 		VPRINTK("pkt_handle_queue: found zone=%llx\n",
-			(unsigned long long)ZONE(bio->bi_sector, pd));
-		if (ZONE(bio->bi_sector, pd) != zone)
+			(unsigned long long)ZONE(bio->bi_iter.bi_sector, pd));
+		if (ZONE(bio->bi_iter.bi_sector, pd) != zone)
 			break;
 		pkt_rbtree_erase(pd, node);
 		spin_lock(&pkt->lock);
 		bio_list_add(&pkt->orig_bios, bio);
-		pkt->write_size += bio->bi_size / CD_FRAMESIZE;
+		pkt->write_size += bio->bi_iter.bi_size / CD_FRAMESIZE;
 		spin_unlock(&pkt->lock);
 	}
 	/* check write congestion marks, and if bio_queue_size is
@@ -1303,7 +1307,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	struct bio_vec *bvec = pkt->w_bio->bi_io_vec;
 
 	bio_reset(pkt->w_bio);
-	pkt->w_bio->bi_sector = pkt->sector;
+	pkt->w_bio->bi_iter.bi_sector = pkt->sector;
 	pkt->w_bio->bi_bdev = pd->bdev;
 	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
 	pkt->w_bio->bi_private = pkt;
@@ -2384,20 +2388,20 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 
 	if (!test_bit(PACKET_WRITABLE, &pd->flags)) {
 		printk(DRIVER_NAME": WRITE for ro device %s (%llu)\n",
-			pd->name, (unsigned long long)bio->bi_sector);
+			pd->name, (unsigned long long)bio->bi_iter.bi_sector);
 		goto end_io;
 	}
 
-	if (!bio->bi_size || (bio->bi_size % CD_FRAMESIZE)) {
+	if (!bio->bi_iter.bi_size || (bio->bi_iter.bi_size % CD_FRAMESIZE)) {
 		printk(DRIVER_NAME": wrong bio size\n");
 		goto end_io;
 	}
 
 	blk_queue_bounce(q, &bio);
 
-	zone = ZONE(bio->bi_sector, pd);
+	zone = ZONE(bio->bi_iter.bi_sector, pd);
 	VPRINTK("pkt_make_request: start = %6llx stop = %6llx\n",
-		(unsigned long long)bio->bi_sector,
+		(unsigned long long)bio->bi_iter.bi_sector,
 		(unsigned long long)bio_end_sector(bio));
 
 	/* Check if we have to split the bio */
@@ -2409,7 +2413,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		last_zone = ZONE(bio_end_sector(bio) - 1, pd);
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
-			first_sectors = last_zone - bio->bi_sector;
+			first_sectors = last_zone - bio->bi_iter.bi_sector;
 			bp = bio_split(bio, first_sectors);
 			BUG_ON(!bp);
 			pkt_make_request(q, &bp->bio1);
@@ -2431,7 +2435,8 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 			if ((pkt->state == PACKET_WAITING_STATE) ||
 			    (pkt->state == PACKET_READ_WAIT_STATE)) {
 				bio_list_add(&pkt->orig_bios, bio);
-				pkt->write_size += bio->bi_size / CD_FRAMESIZE;
+				pkt->write_size +=
+					bio->bi_iter.bi_size / CD_FRAMESIZE;
 				if ((pkt->write_size >= pkt->frames) &&
 				    (pkt->state == PACKET_WAITING_STATE)) {
 					atomic_inc(&pkt->run_sm);
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index d754a88..464be78 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -104,7 +104,7 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
 		dev_dbg(&dev->sbd.core,
 			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
 			__func__, __LINE__, i, bio_segments(iter.bio),
-			bio_sectors(iter.bio), iter.bio->bi_sector);
+			bio_sectors(iter.bio), iter.bio->bi_iter.bi_sector);
 
 		size = bvec->bv_len;
 		buf = bvec_kmap_irq(bvec, &flags);
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 11e1798..8115eb2 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -939,14 +939,14 @@ static struct bio *bio_clone_range(struct bio *bio_src,
 
 	/* Handle the easy case for the caller */
 
-	if (!offset && len == bio_src->bi_size)
+	if (!offset && len == bio_src->bi_iter.bi_size)
 		return bio_clone(bio_src, gfpmask);
 
 	if (WARN_ON_ONCE(!len))
 		return NULL;
-	if (WARN_ON_ONCE(len > bio_src->bi_size))
+	if (WARN_ON_ONCE(len > bio_src->bi_iter.bi_size))
 		return NULL;
-	if (WARN_ON_ONCE(offset > bio_src->bi_size - len))
+	if (WARN_ON_ONCE(offset > bio_src->bi_iter.bi_size - len))
 		return NULL;
 
 	/* Find first affected segment... */
@@ -976,7 +976,8 @@ static struct bio *bio_clone_range(struct bio *bio_src,
 		return NULL;	/* ENOMEM */
 
 	bio->bi_bdev = bio_src->bi_bdev;
-	bio->bi_sector = bio_src->bi_sector + (offset >> SECTOR_SHIFT);
+	bio->bi_iter.bi_sector = bio_src->bi_iter.bi_sector +
+		(offset >> SECTOR_SHIFT);
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_flags |= 1 << BIO_CLONED;
 
@@ -995,8 +996,7 @@ static struct bio *bio_clone_range(struct bio *bio_src,
 	}
 
 	bio->bi_vcnt = vcnt;
-	bio->bi_size = len;
-	bio->bi_idx = 0;
+	bio->bi_iter.bi_size = len;
 
 	return bio;
 }
@@ -1027,7 +1027,7 @@ static struct bio *bio_chain_clone_range(struct bio **bio_src,
 
 	/* Build up a chain of clone bios up to the limit */
 
-	if (!bi || off >= bi->bi_size || !len)
+	if (!bi || off >= bi->bi_iter.bi_size || !len)
 		return NULL;		/* Nothing to clone */
 
 	end = &chain;
@@ -1039,7 +1039,7 @@ static struct bio *bio_chain_clone_range(struct bio **bio_src,
 			rbd_warn(NULL, "bio_chain exhausted with %u left", len);
 			goto out_err;	/* EINVAL; ran out of bio's */
 		}
-		bi_size = min_t(unsigned int, bi->bi_size - off, len);
+		bi_size = min_t(unsigned int, bi->bi_iter.bi_size - off, len);
 		bio = bio_clone_range(bi, off, bi_size, gfpmask);
 		if (!bio)
 			goto out_err;	/* ENOMEM */
@@ -1048,7 +1048,7 @@ static struct bio *bio_chain_clone_range(struct bio **bio_src,
 		end = &bio->bi_next;
 
 		off += bi_size;
-		if (off == bi->bi_size) {
+		if (off == bi->bi_iter.bi_size) {
 			bi = bi->bi_next;
 			off = 0;
 		}
@@ -1610,7 +1610,7 @@ static int rbd_img_request_fill_bio(struct rbd_img_request *img_request,
 					      : CEPH_OSD_OP_READ;
 	bio_offset = 0;
 	image_offset = img_request->offset;
-	rbd_assert(image_offset == bio_list->bi_sector << SECTOR_SHIFT);
+	rbd_assert(image_offset == bio_list->bi_iter.bi_sector << SECTOR_SHIFT);
 	resid = img_request->length;
 	rbd_assert(resid > 0);
 	while (resid) {
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index 4346d17..44d045b 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -180,7 +180,7 @@ static void rsxx_make_request(struct request_queue *q, struct bio *bio)
 		goto req_err;
 	}
 
-	if (bio->bi_size == 0) {
+	if (bio->bi_iter.bi_size == 0) {
 		dev_err(CARD_TO_DEV(card), "size zero BIO!\n");
 		goto req_err;
 	}
@@ -200,7 +200,7 @@ static void rsxx_make_request(struct request_queue *q, struct bio *bio)
 
 	dev_dbg(CARD_TO_DEV(card), "BIO[%c]: meta: %p addr8: x%llx size: %d\n",
 		 bio_data_dir(bio) ? 'W' : 'R', bio_meta,
-		 (u64)bio->bi_sector << 9, bio->bi_size);
+		 (u64)bio->bi_iter.bi_sector << 9, bio->bi_iter.bi_size);
 
 	st = rsxx_dma_queue_bio(card, bio, &bio_meta->pending_dmas,
 				    bio_dma_done_cb, bio_meta);
diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index 63176e6..81d92cb 100644
--- a/drivers/block/rsxx/dma.c
+++ b/drivers/block/rsxx/dma.c
@@ -650,7 +650,7 @@ int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
 	int st;
 	int i;
 
-	addr8 = bio->bi_sector << 9; /* sectors are 512 bytes */
+	addr8 = bio->bi_iter.bi_sector << 9; /* sectors are 512 bytes */
 	atomic_set(n_dmas, 0);
 
 	for (i = 0; i < card->n_targets; i++) {
@@ -659,7 +659,7 @@ int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
 	}
 
 	if (bio->bi_rw & REQ_DISCARD) {
-		bv_len = bio->bi_size;
+		bv_len = bio->bi_iter.bi_size;
 
 		while (bv_len > 0) {
 			tgt   = rsxx_get_dma_tgt(card, addr8);
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index ad70868..dab4f1a 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -352,8 +352,8 @@ static int add_bio(struct cardinfo *card)
 	bio = card->currentbio;
 	if (!bio && card->bio) {
 		card->currentbio = card->bio;
-		card->current_idx = card->bio->bi_idx;
-		card->current_sector = card->bio->bi_sector;
+		card->current_idx = card->bio->bi_iter.bi_idx;
+		card->current_sector = card->bio->bi_iter.bi_sector;
 		card->bio = card->bio->bi_next;
 		if (card->bio == NULL)
 			card->biotail = &card->bio;
@@ -451,7 +451,7 @@ static void process_page(unsigned long data)
 		if (page->idx >= bio->bi_vcnt) {
 			page->bio = bio->bi_next;
 			if (page->bio)
-				page->idx = page->bio->bi_idx;
+				page->idx = page->bio->bi_iter.bi_idx;
 		}
 
 		pci_unmap_page(card->dev, desc->data_dma_handle,
@@ -532,7 +532,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct cardinfo *card = q->queuedata;
 	pr_debug("mm_make_request %llu %u\n",
-		 (unsigned long long)bio->bi_sector, bio->bi_size);
+		 (unsigned long long)bio->bi_iter.bi_sector,
+		 bio->bi_iter.bi_size);
 
 	spin_lock_irq(&card->lock);
 	*card->biotail = bio;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 8ad21a2..99c5d89 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -167,7 +167,7 @@ static int virtblk_bio_send_data(struct virtblk_req *vbr)
 
 	vbr->flags &= ~VBLK_IS_FLUSH;
 	vbr->out_hdr.type = 0;
-	vbr->out_hdr.sector = bio->bi_sector;
+	vbr->out_hdr.sector = bio->bi_iter.bi_sector;
 	vbr->out_hdr.ioprio = bio_prio(bio);
 
 	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
@@ -418,7 +418,7 @@ static void virtblk_make_request(struct request_queue *q, struct bio *bio)
 		vbr->flags |= VBLK_REQ_FLUSH;
 	if (bio->bi_rw & REQ_FUA)
 		vbr->flags |= VBLK_REQ_FUA;
-	if (bio->bi_size)
+	if (bio->bi_iter.bi_size)
 		vbr->flags |= VBLK_REQ_DATA;
 
 	if (unlikely(vbr->flags & VBLK_REQ_FLUSH))
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index de1f319..720879e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -957,7 +957,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 			bio->bi_bdev    = preq.bdev;
 			bio->bi_private = pending_req;
 			bio->bi_end_io  = end_block_io_op;
-			bio->bi_sector  = preq.sector_number;
+			bio->bi_iter.bi_sector  = preq.sector_number;
 		}
 
 		preq.sector_number += seg[i].nsec;
diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index 3a8cfa2..5ace48e 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -40,10 +40,10 @@ static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 {
 	unsigned i;
 
-	bd->bi_sector = bio->bi_sector;
+	bd->bi_sector = bio->bi_iter.bi_sector;
 	bd->bi_bdev = bio->bi_bdev;
-	bd->bi_size = bio->bi_size;
-	bd->bi_idx = bio->bi_idx;
+	bd->bi_size = bio->bi_iter.bi_size;
+	bd->bi_idx = bio->bi_iter.bi_idx;
 	bd->bi_flags = bio->bi_flags;
 
 	for (i = 0; i < bio->bi_vcnt; i++) {
@@ -56,10 +56,10 @@ static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 {
 	unsigned i;
 
-	bio->bi_sector = bd->bi_sector;
+	bio->bi_iter.bi_sector = bd->bi_sector;
 	bio->bi_bdev = bd->bi_bdev;
-	bio->bi_size = bd->bi_size;
-	bio->bi_idx = bd->bi_idx;
+	bio->bi_iter.bi_size = bd->bi_size;
+	bio->bi_iter.bi_idx = bd->bi_idx;
 	bio->bi_flags = bd->bi_flags;
 
 	for (i = 0; i < bio->bi_vcnt; i++) {
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 3c955e1..57c04fd 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -515,7 +515,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	bio_init(&b->bio);
 	b->bio.bi_io_vec = b->bio_vec;
 	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
-	b->bio.bi_sector = block << b->c->sectors_per_block_bits;
+	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
 	b->bio.bi_bdev = b->c->bdev;
 	b->bio.bi_end_io = end_io;
 
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 9641532..b0a29c5 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -86,7 +86,7 @@ static enum io_pattern iot_pattern(struct io_tracker *t)
 
 static void iot_update_stats(struct io_tracker *t, struct bio *bio)
 {
-	if (bio->bi_sector == from_oblock(t->last_end_oblock) + 1)
+	if (bio->bi_iter.bi_sector == from_oblock(t->last_end_oblock) + 1)
 		t->nr_seq_samples++;
 	else {
 		/*
@@ -101,7 +101,7 @@ static void iot_update_stats(struct io_tracker *t, struct bio *bio)
 		t->nr_rand_samples++;
 	}
 
-	t->last_end_oblock = to_oblock(bio->bi_sector + bio_sectors(bio) - 1);
+	t->last_end_oblock = to_oblock(bio_end_sector(bio) - 1);
 }
 
 static void iot_check_for_pattern_switch(struct io_tracker *t)
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0f4e84b..c2e31f7 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -529,14 +529,16 @@ static void remap_to_origin(struct cache *cache, struct bio *bio)
 static void remap_to_cache(struct cache *cache, struct bio *bio,
 			   dm_cblock_t cblock)
 {
-	sector_t bi_sector = bio->bi_sector;
+	sector_t bi_sector = bio->bi_iter.bi_sector;
 
 	bio->bi_bdev = cache->cache_dev->bdev;
 	if (!block_size_is_power_of_two(cache))
-		bio->bi_sector = (from_cblock(cblock) * cache->sectors_per_block) +
+		bio->bi_iter.bi_sector = (from_cblock(cblock) *
+					  cache->sectors_per_block) +
 				sector_div(bi_sector, cache->sectors_per_block);
 	else
-		bio->bi_sector = (from_cblock(cblock) << cache->sectors_per_block_shift) |
+		bio->bi_iter.bi_sector = (from_cblock(cblock) <<
+					  cache->sectors_per_block_shift) |
 				(bi_sector & (cache->sectors_per_block - 1));
 }
 
@@ -575,7 +577,7 @@ static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
 
 static dm_oblock_t get_bio_block(struct cache *cache, struct bio *bio)
 {
-	sector_t block_nr = bio->bi_sector;
+	sector_t block_nr = bio->bi_iter.bi_sector;
 
 	if (!block_size_is_power_of_two(cache))
 		(void) sector_div(block_nr, cache->sectors_per_block);
@@ -974,7 +976,7 @@ static void process_flush_bio(struct cache *cache, struct bio *bio)
 {
 	struct per_bio_data *pb = get_per_bio_data(bio);
 
-	BUG_ON(bio->bi_size);
+	BUG_ON(bio->bi_iter.bi_size);
 	if (!pb->req_nr)
 		remap_to_origin(cache, bio);
 	else
@@ -997,9 +999,9 @@ static void process_flush_bio(struct cache *cache, struct bio *bio)
  */
 static void process_discard_bio(struct cache *cache, struct bio *bio)
 {
-	dm_block_t start_block = dm_sector_div_up(bio->bi_sector,
+	dm_block_t start_block = dm_sector_div_up(bio->bi_iter.bi_sector,
 						  cache->discard_block_size);
-	dm_block_t end_block = bio->bi_sector + bio_sectors(bio);
+	dm_block_t end_block = bio_end_sector(bio);
 	dm_block_t b;
 
 	(void) sector_div(end_block, cache->discard_block_size);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6d2d41a..fca3bba 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -652,8 +652,8 @@ static void crypt_convert_init(struct crypt_config *cc,
 	ctx->bio_out = bio_out;
 	ctx->offset_in = 0;
 	ctx->offset_out = 0;
-	ctx->idx_in = bio_in ? bio_in->bi_idx : 0;
-	ctx->idx_out = bio_out ? bio_out->bi_idx : 0;
+	ctx->idx_in = bio_in ? bio_in->bi_iter.bi_idx : 0;
+	ctx->idx_out = bio_out ? bio_out->bi_iter.bi_idx : 0;
 	ctx->cc_sector = sector + cc->iv_offset;
 	init_completion(&ctx->restart);
 }
@@ -845,7 +845,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size,
 		size -= len;
 	}
 
-	if (!clone->bi_size) {
+	if (!clone->bi_iter.bi_size) {
 		bio_put(clone);
 		return NULL;
 	}
@@ -985,7 +985,7 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	crypt_inc_pending(io);
 
 	clone_init(io, clone);
-	clone->bi_sector = cc->start + io->sector;
+	clone->bi_iter.bi_sector = cc->start + io->sector;
 
 	generic_make_request(clone);
 	return 0;
@@ -1033,7 +1033,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	/* crypt_convert should have filled the clone bio */
 	BUG_ON(io->ctx.idx_out < clone->bi_vcnt);
 
-	clone->bi_sector = cc->start + io->sector;
+	clone->bi_iter.bi_sector = cc->start + io->sector;
 
 	if (async)
 		kcryptd_queue_io(io);
@@ -1048,7 +1048,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	struct dm_crypt_io *new_io;
 	int crypt_finished;
 	unsigned out_of_pages = 0;
-	unsigned remaining = io->base_bio->bi_size;
+	unsigned remaining = io->base_bio->bi_iter.bi_size;
 	sector_t sector = io->sector;
 	int r;
 
@@ -1072,7 +1072,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		io->ctx.bio_out = clone;
 		io->ctx.idx_out = 0;
 
-		remaining -= clone->bi_size;
+		remaining -= clone->bi_iter.bi_size;
 		sector += bio_sectors(clone);
 
 		crypt_inc_pending(io);
@@ -1687,11 +1687,13 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	if (unlikely(bio->bi_rw & (REQ_FLUSH | REQ_DISCARD))) {
 		bio->bi_bdev = cc->dev->bdev;
 		if (bio_sectors(bio))
-			bio->bi_sector = cc->start + dm_target_offset(ti, bio->bi_sector);
+			bio->bi_iter.bi_sector = cc->start +
+				dm_target_offset(ti, bio->bi_iter.bi_sector);
 		return DM_MAPIO_REMAPPED;
 	}
 
-	io = crypt_io_alloc(cc, bio, dm_target_offset(ti, bio->bi_sector));
+	io = crypt_io_alloc(cc, bio,
+			    dm_target_offset(ti, bio->bi_iter.bi_sector));
 
 	if (bio_data_dir(io->base_bio) == READ) {
 		if (kcryptd_io_read(io, GFP_NOWAIT))
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 496d5f3..84c8601 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -281,14 +281,15 @@ static int delay_map(struct dm_target *ti, struct bio *bio)
 	if ((bio_data_dir(bio) == WRITE) && (dc->dev_write)) {
 		bio->bi_bdev = dc->dev_write->bdev;
 		if (bio_sectors(bio))
-			bio->bi_sector = dc->start_write +
-					 dm_target_offset(ti, bio->bi_sector);
+			bio->bi_iter.bi_sector = dc->start_write +
+				dm_target_offset(ti, bio->bi_iter.bi_sector);
 
 		return delay_bio(dc, dc->write_delay, bio);
 	}
 
 	bio->bi_bdev = dc->dev_read->bdev;
-	bio->bi_sector = dc->start_read + dm_target_offset(ti, bio->bi_sector);
+	bio->bi_iter.bi_sector = dc->start_read +
+		dm_target_offset(ti, bio->bi_iter.bi_sector);
 
 	return delay_bio(dc, dc->read_delay, bio);
 }
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 7fcf21c..b8785cd 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -248,7 +248,8 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 
 	bio->bi_bdev = fc->dev->bdev;
 	if (bio_sectors(bio))
-		bio->bi_sector = flakey_map_sector(ti, bio->bi_sector);
+		bio->bi_iter.bi_sector =
+			flakey_map_sector(ti, bio->bi_iter.bi_sector);
 }
 
 static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
@@ -265,8 +266,8 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 		DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 			"(rw=%c bi_rw=%lu bi_sector=%llu cur_bytes=%u)\n",
 			bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
-			(bio_data_dir(bio) == WRITE) ? 'w' : 'r',
-			bio->bi_rw, (unsigned long long)bio->bi_sector, bio_bytes);
+			(bio_data_dir(bio) == WRITE) ? 'w' : 'r', bio->bi_rw,
+			(unsigned long long)bio->bi_iter.bi_sector, bio_bytes);
 	}
 }
 
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index ea49834..a6de5c9 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -305,14 +305,15 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 					  dm_sector_div_up(remaining, (PAGE_SIZE >> SECTOR_SHIFT)));
 
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
-		bio->bi_sector = where->sector + (where->count - remaining);
+		bio->bi_iter.bi_sector = where->sector +
+			(where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
 		store_io_and_region_in_bio(bio, io, region);
 
 		if (rw & REQ_DISCARD) {
 			num_sectors = min_t(sector_t, q->limits.max_discard_sectors, remaining);
-			bio->bi_size = num_sectors << SECTOR_SHIFT;
+			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
 		} else if (rw & REQ_WRITE_SAME) {
 			/*
@@ -321,7 +322,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 			dp->get_page(dp, &page, &len, &offset);
 			bio_add_page(bio, page, logical_block_size, offset);
 			num_sectors = min_t(sector_t, q->limits.max_write_same_sectors, remaining);
-			bio->bi_size = num_sectors << SECTOR_SHIFT;
+			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 
 			offset = 0;
 			remaining -= num_sectors;
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 4f99d26..53e848c 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -85,7 +85,8 @@ static void linear_map_bio(struct dm_target *ti, struct bio *bio)
 
 	bio->bi_bdev = lc->dev->bdev;
 	if (bio_sectors(bio))
-		bio->bi_sector = linear_map_sector(ti, bio->bi_sector);
+		bio->bi_iter.bi_sector =
+			linear_map_sector(ti, bio->bi_iter.bi_sector);
 }
 
 static int linear_map(struct dm_target *ti, struct bio *bio)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 699b5be..e3efb91 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -432,7 +432,7 @@ static int mirror_available(struct mirror_set *ms, struct bio *bio)
 	region_t region = dm_rh_bio_to_region(ms->rh, bio);
 
 	if (log->type->in_sync(log, region, 0))
-		return choose_mirror(ms,  bio->bi_sector) ? 1 : 0;
+		return choose_mirror(ms,  bio->bi_iter.bi_sector) ? 1 : 0;
 
 	return 0;
 }
@@ -442,15 +442,15 @@ static int mirror_available(struct mirror_set *ms, struct bio *bio)
  */
 static sector_t map_sector(struct mirror *m, struct bio *bio)
 {
-	if (unlikely(!bio->bi_size))
+	if (unlikely(!bio->bi_iter.bi_size))
 		return 0;
-	return m->offset + dm_target_offset(m->ms->ti, bio->bi_sector);
+	return m->offset + dm_target_offset(m->ms->ti, bio->bi_iter.bi_sector);
 }
 
 static void map_bio(struct mirror *m, struct bio *bio)
 {
 	bio->bi_bdev = m->dev->bdev;
-	bio->bi_sector = map_sector(m, bio);
+	bio->bi_iter.bi_sector = map_sector(m, bio);
 }
 
 static void map_region(struct dm_io_region *io, struct mirror *m,
@@ -527,7 +527,7 @@ static void read_async_bio(struct mirror *m, struct bio *bio)
 	struct dm_io_request io_req = {
 		.bi_rw = READ,
 		.mem.type = DM_IO_BVEC,
-		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
+		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_iter.bi_idx,
 		.notify.fn = read_callback,
 		.notify.context = bio,
 		.client = m->ms->io_client,
@@ -559,7 +559,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 		 * We can only read balance if the region is in sync.
 		 */
 		if (likely(region_in_sync(ms, region, 1)))
-			m = choose_mirror(ms, bio->bi_sector);
+			m = choose_mirror(ms, bio->bi_iter.bi_sector);
 		else if (m && atomic_read(&m->error_count))
 			m = NULL;
 
@@ -630,7 +630,7 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE | (bio->bi_rw & WRITE_FLUSH_FUA),
 		.mem.type = DM_IO_BVEC,
-		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
+		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_iter.bi_idx,
 		.notify.fn = write_callback,
 		.notify.context = bio,
 		.client = ms->io_client,
@@ -1182,7 +1182,7 @@ static int mirror_map(struct dm_target *ti, struct bio *bio)
 	 * The region is in-sync and we can perform reads directly.
 	 * Store enough information so we can retry if it fails.
 	 */
-	m = choose_mirror(ms, bio->bi_sector);
+	m = choose_mirror(ms, bio->bi_iter.bi_sector);
 	if (unlikely(!m))
 		return -EIO;
 
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 69732e0..b929fd5 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -126,7 +126,8 @@ EXPORT_SYMBOL_GPL(dm_rh_region_to_sector);
 
 region_t dm_rh_bio_to_region(struct dm_region_hash *rh, struct bio *bio)
 {
-	return dm_rh_sector_to_region(rh, bio->bi_sector - rh->target_begin);
+	return dm_rh_sector_to_region(rh, bio->bi_iter.bi_sector -
+				      rh->target_begin);
 }
 EXPORT_SYMBOL_GPL(dm_rh_bio_to_region);
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c0e0702..8ebc05a 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1562,10 +1562,10 @@ static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
 			    struct bio *bio, chunk_t chunk)
 {
 	bio->bi_bdev = s->cow->bdev;
-	bio->bi_sector = chunk_to_sector(s->store,
+	bio->bi_iter.bi_sector = chunk_to_sector(s->store,
 					 dm_chunk_number(e->new_chunk) +
 					 (chunk - e->old_chunk)) +
-					 (bio->bi_sector &
+					 (bio->bi_iter.bi_sector &
 					  s->store->chunk_mask);
 }
 
@@ -1584,7 +1584,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_REMAPPED;
 	}
 
-	chunk = sector_to_chunk(s->store, bio->bi_sector);
+	chunk = sector_to_chunk(s->store, bio->bi_iter.bi_sector);
 
 	/* Full snapshots are not usable */
 	/* To get here the table must be live so s->active is always set. */
@@ -1645,7 +1645,8 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 		r = DM_MAPIO_SUBMITTED;
 
 		if (!pe->started &&
-		    bio->bi_size == (s->store->chunk_size << SECTOR_SHIFT)) {
+		    bio->bi_iter.bi_size ==
+		    (s->store->chunk_size << SECTOR_SHIFT)) {
 			pe->started = 1;
 			up_write(&s->lock);
 			start_full_bio(pe, bio);
@@ -1701,7 +1702,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_REMAPPED;
 	}
 
-	chunk = sector_to_chunk(s->store, bio->bi_sector);
+	chunk = sector_to_chunk(s->store, bio->bi_iter.bi_sector);
 
 	down_write(&s->lock);
 
@@ -2038,7 +2039,7 @@ static int do_origin(struct dm_dev *origin, struct bio *bio)
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
 	if (o)
-		r = __origin_write(&o->snapshots, bio->bi_sector, bio);
+		r = __origin_write(&o->snapshots, bio->bi_iter.bi_sector, bio);
 	up_read(&_origins_lock);
 
 	return r;
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index ea5e878..f9e139e 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -257,13 +257,15 @@ static int stripe_map_range(struct stripe_c *sc, struct bio *bio,
 {
 	sector_t begin, end;
 
-	stripe_map_range_sector(sc, bio->bi_sector, target_stripe, &begin);
+	stripe_map_range_sector(sc, bio->bi_iter.bi_sector,
+				target_stripe, &begin);
 	stripe_map_range_sector(sc, bio_end_sector(bio),
 				target_stripe, &end);
 	if (begin < end) {
 		bio->bi_bdev = sc->stripe[target_stripe].dev->bdev;
-		bio->bi_sector = begin + sc->stripe[target_stripe].physical_start;
-		bio->bi_size = to_bytes(end - begin);
+		bio->bi_iter.bi_sector = begin +
+			sc->stripe[target_stripe].physical_start;
+		bio->bi_iter.bi_size = to_bytes(end - begin);
 		return DM_MAPIO_REMAPPED;
 	} else {
 		/* The range doesn't map to the target stripe */
@@ -291,9 +293,10 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 		return stripe_map_range(sc, bio, target_bio_nr);
 	}
 
-	stripe_map_sector(sc, bio->bi_sector, &stripe, &bio->bi_sector);
+	stripe_map_sector(sc, bio->bi_iter.bi_sector,
+			  &stripe, &bio->bi_iter.bi_sector);
 
-	bio->bi_sector += sc->stripe[stripe].physical_start;
+	bio->bi_iter.bi_sector += sc->stripe[stripe].physical_start;
 	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
 
 	return DM_MAPIO_REMAPPED;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 009339d..40f8f1f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -413,7 +413,7 @@ static bool block_size_is_power_of_two(struct pool *pool)
 static dm_block_t get_bio_block(struct thin_c *tc, struct bio *bio)
 {
 	struct pool *pool = tc->pool;
-	sector_t block_nr = bio->bi_sector;
+	sector_t block_nr = bio->bi_iter.bi_sector;
 
 	if (block_size_is_power_of_two(pool))
 		block_nr >>= pool->sectors_per_block_shift;
@@ -426,14 +426,15 @@ static dm_block_t get_bio_block(struct thin_c *tc, struct bio *bio)
 static void remap(struct thin_c *tc, struct bio *bio, dm_block_t block)
 {
 	struct pool *pool = tc->pool;
-	sector_t bi_sector = bio->bi_sector;
+	sector_t bi_sector = bio->bi_iter.bi_sector;
 
 	bio->bi_bdev = tc->pool_dev->bdev;
 	if (block_size_is_power_of_two(pool))
-		bio->bi_sector = (block << pool->sectors_per_block_shift) |
-				(bi_sector & (pool->sectors_per_block - 1));
+		bio->bi_iter.bi_sector =
+			(block << pool->sectors_per_block_shift) |
+			(bi_sector & (pool->sectors_per_block - 1));
 	else
-		bio->bi_sector = (block * pool->sectors_per_block) +
+		bio->bi_iter.bi_sector = (block * pool->sectors_per_block) +
 				 sector_div(bi_sector, pool->sectors_per_block);
 }
 
@@ -721,7 +722,8 @@ static void process_prepared(struct pool *pool, struct list_head *head,
  */
 static int io_overlaps_block(struct pool *pool, struct bio *bio)
 {
-	return bio->bi_size == (pool->sectors_per_block << SECTOR_SHIFT);
+	return bio->bi_iter.bi_size ==
+		(pool->sectors_per_block << SECTOR_SHIFT);
 }
 
 static int io_overwrites_block(struct pool *pool, struct bio *bio)
@@ -1121,7 +1123,7 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 	if (bio_detain(pool, &key, bio, &cell))
 		return;
 
-	if (bio_data_dir(bio) == WRITE && bio->bi_size)
+	if (bio_data_dir(bio) == WRITE && bio->bi_iter.bi_size)
 		break_sharing(tc, bio, block, &key, lookup_result, cell);
 	else {
 		struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
@@ -1144,7 +1146,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	/*
 	 * Remap empty bios (flushes) immediately, without provisioning.
 	 */
-	if (!bio->bi_size) {
+	if (!bio->bi_iter.bi_size) {
 		inc_all_io_entry(pool, bio);
 		cell_defer_no_holder(tc, cell);
 
@@ -1244,7 +1246,8 @@ static void process_bio_read_only(struct thin_c *tc, struct bio *bio)
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
 	switch (r) {
 	case 0:
-		if (lookup_result.shared && (rw == WRITE) && bio->bi_size)
+		if (lookup_result.shared &&
+		    (rw == WRITE) && bio->bi_iter.bi_size)
 			bio_io_error(bio);
 		else {
 			inc_all_io_entry(tc->pool, bio);
@@ -2702,7 +2705,7 @@ out_unlock:
 
 static int thin_map(struct dm_target *ti, struct bio *bio)
 {
-	bio->bi_sector = dm_target_offset(ti, bio->bi_sector);
+	bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
 
 	return thin_bio_map(ti, bio);
 }
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 4f06d9a..b17233a 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -464,9 +464,9 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 	struct dm_verity_io *io;
 
 	bio->bi_bdev = v->data_dev->bdev;
-	bio->bi_sector = verity_map_sector(v, bio->bi_sector);
+	bio->bi_iter.bi_sector = verity_map_sector(v, bio->bi_iter.bi_sector);
 
-	if (((unsigned)bio->bi_sector | bio_sectors(bio)) &
+	if (((unsigned)bio->bi_iter.bi_sector | bio_sectors(bio)) &
 	    ((1 << (v->data_dev_block_bits - SECTOR_SHIFT)) - 1)) {
 		DMERR_LIMIT("unaligned io");
 		return -EIO;
@@ -485,8 +485,9 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 	io->v = v;
 	io->orig_bi_end_io = bio->bi_end_io;
 	io->orig_bi_private = bio->bi_private;
-	io->block = bio->bi_sector >> (v->data_dev_block_bits - SECTOR_SHIFT);
-	io->n_blocks = bio->bi_size >> v->data_dev_block_bits;
+	io->block = bio->bi_iter.bi_sector >>
+		(v->data_dev_block_bits - SECTOR_SHIFT);
+	io->n_blocks = bio->bi_iter.bi_size >> v->data_dev_block_bits;
 
 	bio->bi_end_io = verity_end_io;
 	bio->bi_private = io;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7e46926..01a2451 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -602,7 +602,7 @@ static void dec_pending(struct dm_io *io, int error)
 		if (io_error == DM_ENDIO_REQUEUE)
 			return;
 
-		if ((bio->bi_rw & REQ_FLUSH) && bio->bi_size) {
+		if ((bio->bi_rw & REQ_FLUSH) && bio->bi_iter.bi_size) {
 			/*
 			 * Preflush done for flush with data, reissue
 			 * without REQ_FLUSH.
@@ -656,7 +656,7 @@ static void end_clone_bio(struct bio *clone, int error)
 	struct dm_rq_clone_bio_info *info = clone->bi_private;
 	struct dm_rq_target_io *tio = info->tio;
 	struct bio *bio = info->orig;
-	unsigned int nr_bytes = info->orig->bi_size;
+	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
 
 	bio_put(clone);
 
@@ -987,7 +987,7 @@ static void __map_bio(struct dm_target_io *tio)
 	 * this io.
 	 */
 	atomic_inc(&tio->io->io_count);
-	sector = clone->bi_sector;
+	sector = clone->bi_iter.bi_sector;
 	r = ti->type->map(ti, clone);
 	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
@@ -1019,13 +1019,13 @@ struct clone_info {
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
 {
-	bio->bi_sector = sector;
-	bio->bi_size = to_bytes(len);
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_iter.bi_size = to_bytes(len);
 }
 
 static void bio_setup_bv(struct bio *bio, unsigned short idx, unsigned short bv_count)
 {
-	bio->bi_idx = idx;
+	bio->bi_iter.bi_idx = idx;
 	bio->bi_vcnt = idx + bv_count;
 	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 }
@@ -1061,7 +1061,7 @@ static void clone_split_bio(struct dm_target_io *tio, struct bio *bio,
 	clone->bi_rw = bio->bi_rw;
 	clone->bi_vcnt = 1;
 	clone->bi_io_vec->bv_offset = offset;
-	clone->bi_io_vec->bv_len = clone->bi_size;
+	clone->bi_io_vec->bv_len = clone->bi_iter.bi_size;
 	clone->bi_flags |= 1 << BIO_CLONED;
 
 	clone_bio_integrity(bio, clone, idx, len, offset, 1);
@@ -1081,7 +1081,8 @@ static void clone_bio(struct dm_target_io *tio, struct bio *bio,
 	bio_setup_sector(clone, sector, len);
 	bio_setup_bv(clone, idx, bv_count);
 
-	if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+	if (idx != bio->bi_iter.bi_idx ||
+	    clone->bi_iter.bi_size < bio->bi_iter.bi_size)
 		trim = 1;
 	clone_bio_integrity(bio, clone, idx, len, 0, trim);
 }
@@ -1368,8 +1369,8 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
 	ci.io->bio = bio;
 	ci.io->md = md;
 	spin_lock_init(&ci.io->endio_lock);
-	ci.sector = bio->bi_sector;
-	ci.idx = bio->bi_idx;
+	ci.sector = bio->bi_iter.bi_sector;
+	ci.idx = bio->bi_iter.bi_idx;
 
 	start_io_acct(ci.io);
 
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 3193aef..e8b4574 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -74,8 +74,8 @@ static void faulty_fail(struct bio *bio, int error)
 {
 	struct bio *b = bio->bi_private;
 
-	b->bi_size = bio->bi_size;
-	b->bi_sector = bio->bi_sector;
+	b->bi_iter.bi_size = bio->bi_iter.bi_size;
+	b->bi_iter.bi_sector = bio->bi_iter.bi_sector;
 
 	bio_put(bio);
 
@@ -185,26 +185,31 @@ static void make_request(struct mddev *mddev, struct bio *bio)
 			return;
 		}
 
-		if (check_sector(conf, bio->bi_sector, bio_end_sector(bio), WRITE))
+		if (check_sector(conf, bio->bi_iter.bi_sector,
+				 bio_end_sector(bio), WRITE))
 			failit = 1;
 		if (check_mode(conf, WritePersistent)) {
-			add_sector(conf, bio->bi_sector, WritePersistent);
+			add_sector(conf, bio->bi_iter.bi_sector,
+				   WritePersistent);
 			failit = 1;
 		}
 		if (check_mode(conf, WriteTransient))
 			failit = 1;
 	} else {
 		/* read request */
-		if (check_sector(conf, bio->bi_sector, bio_end_sector(bio), READ))
+		if (check_sector(conf, bio->bi_iter.bi_sector,
+				 bio_end_sector(bio), READ))
 			failit = 1;
 		if (check_mode(conf, ReadTransient))
 			failit = 1;
 		if (check_mode(conf, ReadPersistent)) {
-			add_sector(conf, bio->bi_sector, ReadPersistent);
+			add_sector(conf, bio->bi_iter.bi_sector,
+				   ReadPersistent);
 			failit = 1;
 		}
 		if (check_mode(conf, ReadFixable)) {
-			add_sector(conf, bio->bi_sector, ReadFixable);
+			add_sector(conf, bio->bi_iter.bi_sector,
+				   ReadFixable);
 			failit = 1;
 		}
 	}
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index f03fabd..fb3b0d0 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -297,19 +297,19 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 	}
 
 	rcu_read_lock();
-	tmp_dev = which_dev(mddev, bio->bi_sector);
+	tmp_dev = which_dev(mddev, bio->bi_iter.bi_sector);
 	start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
 
 
-	if (unlikely(bio->bi_sector >= (tmp_dev->end_sector)
-		     || (bio->bi_sector < start_sector))) {
+	if (unlikely(bio->bi_iter.bi_sector >= (tmp_dev->end_sector)
+		     || (bio->bi_iter.bi_sector < start_sector))) {
 		char b[BDEVNAME_SIZE];
 
 		printk(KERN_ERR
 		       "md/linear:%s: make_request: Sector %llu out of bounds on "
 		       "dev %s: %llu sectors, offset %llu\n",
 		       mdname(mddev),
-		       (unsigned long long)bio->bi_sector,
+		       (unsigned long long)bio->bi_iter.bi_sector,
 		       bdevname(tmp_dev->rdev->bdev, b),
 		       (unsigned long long)tmp_dev->rdev->sectors,
 		       (unsigned long long)start_sector);
@@ -326,7 +326,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 
 		rcu_read_unlock();
 
-		bp = bio_split(bio, end_sector - bio->bi_sector);
+		bp = bio_split(bio, end_sector - bio->bi_iter.bi_sector);
 
 		linear_make_request(mddev, &bp->bio1);
 		linear_make_request(mddev, &bp->bio2);
@@ -335,7 +335,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 	}
 		    
 	bio->bi_bdev = tmp_dev->rdev->bdev;
-	bio->bi_sector = bio->bi_sector - start_sector
+	bio->bi_iter.bi_sector = bio->bi_iter.bi_sector - start_sector
 		+ tmp_dev->rdev->data_offset;
 	rcu_read_unlock();
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d323676..4fae0aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -191,21 +191,22 @@ void md_trim_bio(struct bio *bio, int offset, int size)
 	int sofar = 0;
 
 	size <<= 9;
-	if (offset == 0 && size == bio->bi_size)
+	if (offset == 0 && size == bio->bi_iter.bi_size)
 		return;
 
 	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
 
 	bio_advance(bio, offset << 9);
 
-	bio->bi_size = size;
+	bio->bi_iter.bi_size = size;
 
 	/* avoid any complications with bi_idx being non-zero*/
-	if (bio->bi_idx) {
-		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
-			(bio->bi_vcnt - bio->bi_idx) * sizeof(struct bio_vec));
-		bio->bi_vcnt -= bio->bi_idx;
-		bio->bi_idx = 0;
+	if (bio->bi_iter.bi_idx) {
+		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_iter.bi_idx,
+			(bio->bi_vcnt - bio->bi_iter.bi_idx) *
+			sizeof(struct bio_vec));
+		bio->bi_vcnt -= bio->bi_iter.bi_idx;
+		bio->bi_iter.bi_idx = 0;
 	}
 	/* Make sure vcnt and last bv are not too big */
 	bio_for_each_segment(bvec, bio, i) {
@@ -430,7 +431,7 @@ static void md_submit_flush_data(struct work_struct *ws)
 	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
 	struct bio *bio = mddev->flush_bio;
 
-	if (bio->bi_size == 0)
+	if (bio->bi_iter.bi_size == 0)
 		/* an empty barrier - all done */
 		bio_endio(bio, 0);
 	else {
@@ -782,7 +783,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
 
 	bio->bi_bdev = rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev;
-	bio->bi_sector = sector;
+	bio->bi_iter.bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
@@ -821,13 +822,13 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
 		rdev->meta_bdev : rdev->bdev;
 	if (metadata_op)
-		bio->bi_sector = sector + rdev->sb_start;
+		bio->bi_iter.bi_sector = sector + rdev->sb_start;
 	else if (rdev->mddev->reshape_position != MaxSector &&
 		 (rdev->mddev->reshape_backwards ==
 		  (sector >= rdev->mddev->reshape_position)))
-		bio->bi_sector = sector + rdev->new_data_offset;
+		bio->bi_iter.bi_sector = sector + rdev->new_data_offset;
 	else
-		bio->bi_sector = sector + rdev->data_offset;
+		bio->bi_iter.bi_sector = sector + rdev->data_offset;
 	bio_add_page(bio, page, size, 0);
 	init_completion(&event);
 	bio->bi_private = &event;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 1642eae..849ad39 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -100,7 +100,7 @@ static void multipath_end_request(struct bio *bio, int error)
 		md_error (mp_bh->mddev, rdev);
 		printk(KERN_ERR "multipath: %s: rescheduling sector %llu\n", 
 		       bdevname(rdev->bdev,b), 
-		       (unsigned long long)bio->bi_sector);
+		       (unsigned long long)bio->bi_iter.bi_sector);
 		multipath_reschedule_retry(mp_bh);
 	} else
 		multipath_end_bh_io(mp_bh, error);
@@ -132,7 +132,7 @@ static void multipath_make_request(struct mddev *mddev, struct bio * bio)
 	multipath = conf->multipaths + mp_bh->path;
 
 	mp_bh->bio = *bio;
-	mp_bh->bio.bi_sector += multipath->rdev->data_offset;
+	mp_bh->bio.bi_iter.bi_sector += multipath->rdev->data_offset;
 	mp_bh->bio.bi_bdev = multipath->rdev->bdev;
 	mp_bh->bio.bi_rw |= REQ_FAILFAST_TRANSPORT;
 	mp_bh->bio.bi_end_io = multipath_end_request;
@@ -355,21 +355,22 @@ static void multipathd(struct md_thread *thread)
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 
 		bio = &mp_bh->bio;
-		bio->bi_sector = mp_bh->master_bio->bi_sector;
+		bio->bi_iter.bi_sector = mp_bh->master_bio->bi_iter.bi_sector;
 		
 		if ((mp_bh->path = multipath_map (conf))<0) {
 			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
 				" error for block %llu\n",
 				bdevname(bio->bi_bdev,b),
-				(unsigned long long)bio->bi_sector);
+				(unsigned long long)bio->bi_iter.bi_sector);
 			multipath_end_bh_io(mp_bh, -EIO);
 		} else {
 			printk(KERN_ERR "multipath: %s: redirecting sector %llu"
 				" to another IO path\n",
 				bdevname(bio->bi_bdev,b),
-				(unsigned long long)bio->bi_sector);
+				(unsigned long long)bio->bi_iter.bi_sector);
 			*bio = *(mp_bh->master_bio);
-			bio->bi_sector += conf->multipaths[mp_bh->path].rdev->data_offset;
+			bio->bi_iter.bi_sector +=
+				conf->multipaths[mp_bh->path].rdev->data_offset;
 			bio->bi_bdev = conf->multipaths[mp_bh->path].rdev->bdev;
 			bio->bi_rw |= REQ_FAILFAST_TRANSPORT;
 			bio->bi_end_io = multipath_end_request;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index fcf65e51..d8c2ec0 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -501,10 +501,11 @@ static inline int is_io_in_chunk_boundary(struct mddev *mddev,
 			unsigned int chunk_sects, struct bio *bio)
 {
 	if (likely(is_power_of_2(chunk_sects))) {
-		return chunk_sects >= ((bio->bi_sector & (chunk_sects-1))
+		return chunk_sects >=
+			((bio->bi_iter.bi_sector & (chunk_sects-1))
 					+ bio_sectors(bio));
 	} else{
-		sector_t sector = bio->bi_sector;
+		sector_t sector = bio->bi_iter.bi_sector;
 		return chunk_sects >= (sector_div(sector, chunk_sects)
 						+ bio_sectors(bio));
 	}
@@ -524,7 +525,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 
 	chunk_sects = mddev->chunk_sectors;
 	if (unlikely(!is_io_in_chunk_boundary(mddev, chunk_sects, bio))) {
-		sector_t sector = bio->bi_sector;
+		sector_t sector = bio->bi_iter.bi_sector;
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
 		if (bio_segments(bio) > 1)
@@ -544,12 +545,12 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 		return;
 	}
 
-	sector_offset = bio->bi_sector;
+	sector_offset = bio->bi_iter.bi_sector;
 	zone = find_zone(mddev->private, &sector_offset);
-	tmp_dev = map_sector(mddev, zone, bio->bi_sector,
+	tmp_dev = map_sector(mddev, zone, bio->bi_iter.bi_sector,
 			     &sector_offset);
 	bio->bi_bdev = tmp_dev->bdev;
-	bio->bi_sector = sector_offset + zone->dev_start +
+	bio->bi_iter.bi_sector = sector_offset + zone->dev_start +
 		tmp_dev->data_offset;
 
 	if (unlikely((bio->bi_rw & REQ_DISCARD) &&
@@ -566,7 +567,8 @@ bad_map:
 	printk("md/raid0:%s: make_request bug: can't convert block across chunks"
 	       " or bigger than %dk %llu %d\n",
 	       mdname(mddev), chunk_sects / 2,
-	       (unsigned long long)bio->bi_sector, bio_sectors(bio) / 2);
+	       (unsigned long long)bio->bi_iter.bi_sector,
+	       bio_sectors(bio) / 2);
 
 	bio_io_error(bio);
 	return;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index aeb4e3f..b448b87 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -255,8 +255,8 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 	if (!test_and_set_bit(R1BIO_Returned, &r1_bio->state)) {
 		pr_debug("raid1: sync end %s on sectors %llu-%llu\n",
 			 (bio_data_dir(bio) == WRITE) ? "write" : "read",
-			 (unsigned long long) bio->bi_sector,
-			 (unsigned long long) bio->bi_sector +
+			 (unsigned long long) bio->bi_iter.bi_sector,
+			 (unsigned long long) bio->bi_iter.bi_sector +
 			 bio_sectors(bio) - 1);
 
 		call_bio_endio(r1_bio);
@@ -446,9 +446,8 @@ static void raid1_end_write_request(struct bio *bio, int error)
 				struct bio *mbio = r1_bio->master_bio;
 				pr_debug("raid1: behind end write sectors"
 					 " %llu-%llu\n",
-					 (unsigned long long) mbio->bi_sector,
-					 (unsigned long long) mbio->bi_sector +
-					 bio_sectors(mbio) - 1);
+					 (uint64_t) mbio->bi_iter.bi_sector,
+					 bio_end_sector(mbio) - 1);
 				call_bio_endio(r1_bio);
 			}
 		}
@@ -935,7 +934,8 @@ do_sync_io:
 		if (bvecs[i].bv_page)
 			put_page(bvecs[i].bv_page);
 	kfree(bvecs);
-	pr_debug("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
+	pr_debug("%dB behind alloc failed, doing sync I/O\n",
+		 bio->bi_iter.bi_size);
 }
 
 struct raid1_plug_cb {
@@ -1009,7 +1009,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 
 	if (bio_data_dir(bio) == WRITE &&
 	    bio_end_sector(bio) > mddev->suspend_lo &&
-	    bio->bi_sector < mddev->suspend_hi) {
+	    bio->bi_iter.bi_sector < mddev->suspend_hi) {
 		/* As the suspend_* range is controlled by
 		 * userspace, we want an interruptible
 		 * wait.
@@ -1020,7 +1020,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_INTERRUPTIBLE);
 			if (bio_end_sector(bio) <= mddev->suspend_lo ||
-			    bio->bi_sector >= mddev->suspend_hi)
+			    bio->bi_iter.bi_sector >= mddev->suspend_hi)
 				break;
 			schedule();
 		}
@@ -1042,7 +1042,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	r1_bio->sectors = bio_sectors(bio);
 	r1_bio->state = 0;
 	r1_bio->mddev = mddev;
-	r1_bio->sector = bio->bi_sector;
+	r1_bio->sector = bio->bi_iter.bi_sector;
 
 	/* We might need to issue multiple reads to different
 	 * devices if there are bad blocks around, so we keep
@@ -1082,12 +1082,13 @@ read_again:
 		r1_bio->read_disk = rdisk;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(read_bio, r1_bio->sector - bio->bi_sector,
+		md_trim_bio(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
 			    max_sectors);
 
 		r1_bio->bios[rdisk] = read_bio;
 
-		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
+		read_bio->bi_iter.bi_sector = r1_bio->sector +
+			mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
 		read_bio->bi_rw = READ | do_sync;
@@ -1099,7 +1100,7 @@ read_again:
 			 */
 
 			sectors_handled = (r1_bio->sector + max_sectors
-					   - bio->bi_sector);
+					   - bio->bi_iter.bi_sector);
 			r1_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
 			if (bio->bi_phys_segments == 0)
@@ -1120,7 +1121,8 @@ read_again:
 			r1_bio->sectors = bio_sectors(bio) - sectors_handled;
 			r1_bio->state = 0;
 			r1_bio->mddev = mddev;
-			r1_bio->sector = bio->bi_sector + sectors_handled;
+			r1_bio->sector = bio->bi_iter.bi_sector +
+				sectors_handled;
 			goto read_again;
 		} else
 			generic_make_request(read_bio);
@@ -1239,7 +1241,7 @@ read_again:
 			bio->bi_phys_segments++;
 		spin_unlock_irq(&conf->device_lock);
 	}
-	sectors_handled = r1_bio->sector + max_sectors - bio->bi_sector;
+	sectors_handled = r1_bio->sector + max_sectors - bio->bi_iter.bi_sector;
 
 	atomic_set(&r1_bio->remaining, 1);
 	atomic_set(&r1_bio->behind_remaining, 0);
@@ -1251,7 +1253,8 @@ read_again:
 			continue;
 
 		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(mbio, r1_bio->sector - bio->bi_sector, max_sectors);
+		md_trim_bio(mbio, r1_bio->sector - bio->bi_iter.bi_sector,
+			    max_sectors);
 
 		if (first_clone) {
 			/* do behind I/O ?
@@ -1285,7 +1288,7 @@ read_again:
 
 		r1_bio->bios[i] = mbio;
 
-		mbio->bi_sector	= (r1_bio->sector +
+		mbio->bi_iter.bi_sector	= (r1_bio->sector +
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
@@ -1325,7 +1328,7 @@ read_again:
 		r1_bio->sectors = bio_sectors(bio) - sectors_handled;
 		r1_bio->state = 0;
 		r1_bio->mddev = mddev;
-		r1_bio->sector = bio->bi_sector + sectors_handled;
+		r1_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
 		goto retry_write;
 	}
 
@@ -1875,14 +1878,14 @@ static int process_checks(struct r1bio *r1_bio)
 		/* fixup the bio for reuse */
 		bio_reset(sbio);
 		sbio->bi_vcnt = vcnt;
-		sbio->bi_size = r1_bio->sectors << 9;
-		sbio->bi_sector = r1_bio->sector +
+		sbio->bi_iter.bi_size = r1_bio->sectors << 9;
+		sbio->bi_iter.bi_sector = r1_bio->sector +
 			conf->mirrors[i].rdev->data_offset;
 		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		sbio->bi_end_io = end_sync_read;
 		sbio->bi_private = r1_bio;
 
-		size = sbio->bi_size;
+		size = sbio->bi_iter.bi_size;
 		for (j = 0; j < vcnt ; j++) {
 			struct bio_vec *bi;
 			bi = &sbio->bi_io_vec[j];
@@ -2099,11 +2102,11 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		}
 
 		wbio->bi_rw = WRITE;
-		wbio->bi_sector = r1_bio->sector;
-		wbio->bi_size = r1_bio->sectors << 9;
+		wbio->bi_iter.bi_sector = r1_bio->sector;
+		wbio->bi_iter.bi_size = r1_bio->sectors << 9;
 
 		md_trim_bio(wbio, sector - r1_bio->sector, sectors);
-		wbio->bi_sector += rdev->data_offset;
+		wbio->bi_iter.bi_sector += rdev->data_offset;
 		wbio->bi_bdev = rdev->bdev;
 		if (submit_bio_wait(WRITE, wbio) == 0)
 			/* failure! */
@@ -2217,7 +2220,8 @@ read_more:
 		}
 		r1_bio->read_disk = disk;
 		bio = bio_clone_mddev(r1_bio->master_bio, GFP_NOIO, mddev);
-		md_trim_bio(bio, r1_bio->sector - bio->bi_sector, max_sectors);
+		md_trim_bio(bio, r1_bio->sector - bio->bi_iter.bi_sector,
+			    max_sectors);
 		r1_bio->bios[r1_bio->read_disk] = bio;
 		rdev = conf->mirrors[disk].rdev;
 		printk_ratelimited(KERN_ERR
@@ -2226,7 +2230,7 @@ read_more:
 				   mdname(mddev),
 				   (unsigned long long)r1_bio->sector,
 				   bdevname(rdev->bdev, b));
-		bio->bi_sector = r1_bio->sector + rdev->data_offset;
+		bio->bi_iter.bi_sector = r1_bio->sector + rdev->data_offset;
 		bio->bi_bdev = rdev->bdev;
 		bio->bi_end_io = raid1_end_read_request;
 		bio->bi_rw = READ | do_sync;
@@ -2235,7 +2239,7 @@ read_more:
 			/* Drat - have to split this up more */
 			struct bio *mbio = r1_bio->master_bio;
 			int sectors_handled = (r1_bio->sector + max_sectors
-					       - mbio->bi_sector);
+					       - mbio->bi_iter.bi_sector);
 			r1_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
 			if (mbio->bi_phys_segments == 0)
@@ -2253,7 +2257,8 @@ read_more:
 			r1_bio->state = 0;
 			set_bit(R1BIO_ReadError, &r1_bio->state);
 			r1_bio->mddev = mddev;
-			r1_bio->sector = mbio->bi_sector + sectors_handled;
+			r1_bio->sector = mbio->bi_iter.bi_sector +
+				sectors_handled;
 
 			goto read_more;
 		} else
@@ -2477,7 +2482,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 		}
 		if (bio->bi_end_io) {
 			atomic_inc(&rdev->nr_pending);
-			bio->bi_sector = sector_nr + rdev->data_offset;
+			bio->bi_iter.bi_sector = sector_nr + rdev->data_offset;
 			bio->bi_bdev = rdev->bdev;
 			bio->bi_private = r1_bio;
 		}
@@ -2577,7 +2582,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 							continue;
 						/* remove last page from this bio */
 						bio->bi_vcnt--;
-						bio->bi_size -= len;
+						bio->bi_iter.bi_size -= len;
 						bio->bi_flags &= ~(1<< BIO_SEG_VALID);
 					}
 					goto bio_full;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e32e8b1..c6edd00 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1169,7 +1169,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	/* If this request crosses a chunk boundary, we need to
 	 * split it.  This will only happen for 1 PAGE (or less) requests.
 	 */
-	if (unlikely((bio->bi_sector & chunk_mask) + bio_sectors(bio)
+	if (unlikely((bio->bi_iter.bi_sector & chunk_mask) + bio_sectors(bio)
 		     > chunk_sects
 		     && (conf->geo.near_copies < conf->geo.raid_disks
 			 || conf->prev.near_copies < conf->prev.raid_disks))) {
@@ -1180,8 +1180,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio,
-			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
+		bp = bio_split(bio, chunk_sects -
+			       (bio->bi_iter.bi_sector & (chunk_sects - 1)));
 
 		/* Each of these 'make_request' calls will call 'wait_barrier'.
 		 * If the first succeeds but the second blocks due to the resync
@@ -1208,7 +1208,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	bad_map:
 		printk("md/raid10:%s: make_request bug: can't convert block across chunks"
 		       " or bigger than %dk %llu %d\n", mdname(mddev), chunk_sects/2,
-		       (unsigned long long)bio->bi_sector, bio_sectors(bio) / 2);
+		       (unsigned long long)bio->bi_iter.bi_sector,
+		       bio_sectors(bio) / 2);
 
 		bio_io_error(bio);
 		return;
@@ -1225,24 +1226,25 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 
 	sectors = bio_sectors(bio);
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-	    bio->bi_sector < conf->reshape_progress &&
-	    bio->bi_sector + sectors > conf->reshape_progress) {
+	    bio->bi_iter.bi_sector < conf->reshape_progress &&
+	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
 		/* IO spans the reshape position.  Need to wait for
 		 * reshape to pass
 		 */
 		allow_barrier(conf);
 		wait_event(conf->wait_barrier,
-			   conf->reshape_progress <= bio->bi_sector ||
-			   conf->reshape_progress >= bio->bi_sector + sectors);
+			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
+			   conf->reshape_progress >= bio->bi_iter.bi_sector +
+			   sectors);
 		wait_barrier(conf);
 	}
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio_data_dir(bio) == WRITE &&
 	    (mddev->reshape_backwards
-	     ? (bio->bi_sector < conf->reshape_safe &&
-		bio->bi_sector + sectors > conf->reshape_progress)
-	     : (bio->bi_sector + sectors > conf->reshape_safe &&
-		bio->bi_sector < conf->reshape_progress))) {
+	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
+		bio->bi_iter.bi_sector + sectors > conf->reshape_progress)
+	     : (bio->bi_iter.bi_sector + sectors > conf->reshape_safe &&
+		bio->bi_iter.bi_sector < conf->reshape_progress))) {
 		/* Need to update reshape_position in metadata */
 		mddev->reshape_position = conf->reshape_progress;
 		set_bit(MD_CHANGE_DEVS, &mddev->flags);
@@ -1260,7 +1262,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	r10_bio->sectors = sectors;
 
 	r10_bio->mddev = mddev;
-	r10_bio->sector = bio->bi_sector;
+	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
 
 	/* We might need to issue multiple reads to different
@@ -1289,13 +1291,13 @@ read_again:
 		slot = r10_bio->read_slot;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(read_bio, r10_bio->sector - bio->bi_sector,
+		md_trim_bio(read_bio, r10_bio->sector - bio->bi_iter.bi_sector,
 			    max_sectors);
 
 		r10_bio->devs[slot].bio = read_bio;
 		r10_bio->devs[slot].rdev = rdev;
 
-		read_bio->bi_sector = r10_bio->devs[slot].addr +
+		read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
 			choose_data_offset(r10_bio, rdev);
 		read_bio->bi_bdev = rdev->bdev;
 		read_bio->bi_end_io = raid10_end_read_request;
@@ -1307,7 +1309,7 @@ read_again:
 			 * need another r10_bio.
 			 */
 			sectors_handled = (r10_bio->sectors + max_sectors
-					   - bio->bi_sector);
+					   - bio->bi_iter.bi_sector);
 			r10_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
 			if (bio->bi_phys_segments == 0)
@@ -1328,7 +1330,8 @@ read_again:
 			r10_bio->sectors = bio_sectors(bio) - sectors_handled;
 			r10_bio->state = 0;
 			r10_bio->mddev = mddev;
-			r10_bio->sector = bio->bi_sector + sectors_handled;
+			r10_bio->sector = bio->bi_iter.bi_sector +
+				sectors_handled;
 			goto read_again;
 		} else
 			generic_make_request(read_bio);
@@ -1486,7 +1489,8 @@ retry_write:
 			bio->bi_phys_segments++;
 		spin_unlock_irq(&conf->device_lock);
 	}
-	sectors_handled = r10_bio->sector + max_sectors - bio->bi_sector;
+	sectors_handled = r10_bio->sector + max_sectors -
+		bio->bi_iter.bi_sector;
 
 	atomic_set(&r10_bio->remaining, 1);
 	bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
@@ -1497,11 +1501,11 @@ retry_write:
 		if (r10_bio->devs[i].bio) {
 			struct md_rdev *rdev = conf->mirrors[d].rdev;
 			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-				    max_sectors);
+			md_trim_bio(mbio, r10_bio->sector -
+				    bio->bi_iter.bi_sector, max_sectors);
 			r10_bio->devs[i].bio = mbio;
 
-			mbio->bi_sector	= (r10_bio->devs[i].addr+
+			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr+
 					   choose_data_offset(r10_bio,
 							      rdev));
 			mbio->bi_bdev = rdev->bdev;
@@ -1540,11 +1544,11 @@ retry_write:
 				rdev = conf->mirrors[d].rdev;
 			}
 			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-				    max_sectors);
+			md_trim_bio(mbio, r10_bio->sector -
+				    bio->bi_iter.bi_sector, max_sectors);
 			r10_bio->devs[i].repl_bio = mbio;
 
-			mbio->bi_sector	= (r10_bio->devs[i].addr +
+			mbio->bi_iter.bi_sector	= (r10_bio->devs[i].addr +
 					   choose_data_offset(
 						   r10_bio, rdev));
 			mbio->bi_bdev = rdev->bdev;
@@ -1578,7 +1582,7 @@ retry_write:
 		r10_bio->sectors = bio_sectors(bio) - sectors_handled;
 
 		r10_bio->mddev = mddev;
-		r10_bio->sector = bio->bi_sector + sectors_handled;
+		r10_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
 		r10_bio->state = 0;
 		goto retry_write;
 	}
@@ -2080,10 +2084,10 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		bio_reset(tbio);
 
 		tbio->bi_vcnt = vcnt;
-		tbio->bi_size = r10_bio->sectors << 9;
+		tbio->bi_iter.bi_size = r10_bio->sectors << 9;
 		tbio->bi_rw = WRITE;
 		tbio->bi_private = r10_bio;
-		tbio->bi_sector = r10_bio->devs[i].addr;
+		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
 
 		for (j=0; j < vcnt ; j++) {
 			tbio->bi_io_vec[j].bv_offset = 0;
@@ -2100,7 +2104,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
 
-		tbio->bi_sector += conf->mirrors[d].rdev->data_offset;
+		tbio->bi_iter.bi_sector += conf->mirrors[d].rdev->data_offset;
 		tbio->bi_bdev = conf->mirrors[d].rdev->bdev;
 		generic_make_request(tbio);
 	}
@@ -2564,8 +2568,8 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 			sectors = sect_to_write;
 		/* Write at 'sector' for 'sectors' */
 		wbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(wbio, sector - bio->bi_sector, sectors);
-		wbio->bi_sector = (r10_bio->devs[i].addr+
+		md_trim_bio(wbio, sector - bio->bi_iter.bi_sector, sectors);
+		wbio->bi_iter.bi_sector = (r10_bio->devs[i].addr+
 				   choose_data_offset(r10_bio, rdev) +
 				   (sector - r10_bio->sector));
 		wbio->bi_bdev = rdev->bdev;
@@ -2638,11 +2642,11 @@ read_more:
 	bio = bio_clone_mddev(r10_bio->master_bio,
 			      GFP_NOIO, mddev);
 	md_trim_bio(bio,
-		    r10_bio->sector - bio->bi_sector,
+		    r10_bio->sector - bio->bi_iter.bi_sector,
 		    max_sectors);
 	r10_bio->devs[slot].bio = bio;
 	r10_bio->devs[slot].rdev = rdev;
-	bio->bi_sector = r10_bio->devs[slot].addr
+	bio->bi_iter.bi_sector = r10_bio->devs[slot].addr
 		+ choose_data_offset(r10_bio, rdev);
 	bio->bi_bdev = rdev->bdev;
 	bio->bi_rw = READ | do_sync;
@@ -2653,7 +2657,7 @@ read_more:
 		struct bio *mbio = r10_bio->master_bio;
 		int sectors_handled =
 			r10_bio->sector + max_sectors
-			- mbio->bi_sector;
+			- mbio->bi_iter.bi_sector;
 		r10_bio->sectors = max_sectors;
 		spin_lock_irq(&conf->device_lock);
 		if (mbio->bi_phys_segments == 0)
@@ -2671,7 +2675,7 @@ read_more:
 		set_bit(R10BIO_ReadError,
 			&r10_bio->state);
 		r10_bio->mddev = mddev;
-		r10_bio->sector = mbio->bi_sector
+		r10_bio->sector = mbio->bi_iter.bi_sector
 			+ sectors_handled;
 
 		goto read_more;
@@ -3094,7 +3098,8 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_end_io = end_sync_read;
 				bio->bi_rw = READ;
 				from_addr = r10_bio->devs[j].addr;
-				bio->bi_sector = from_addr + rdev->data_offset;
+				bio->bi_iter.bi_sector = from_addr +
+					rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
 				atomic_inc(&rdev->nr_pending);
 				/* and we write to 'i' (if not in_sync) */
@@ -3118,7 +3123,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 					bio->bi_private = r10_bio;
 					bio->bi_end_io = end_sync_write;
 					bio->bi_rw = WRITE;
-					bio->bi_sector = to_addr
+					bio->bi_iter.bi_sector = to_addr
 						+ rdev->data_offset;
 					bio->bi_bdev = rdev->bdev;
 					atomic_inc(&r10_bio->remaining);
@@ -3147,7 +3152,8 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = end_sync_write;
 				bio->bi_rw = WRITE;
-				bio->bi_sector = to_addr + rdev->data_offset;
+				bio->bi_iter.bi_sector = to_addr +
+					rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
 				atomic_inc(&r10_bio->remaining);
 				break;
@@ -3265,7 +3271,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
 			bio->bi_rw = READ;
-			bio->bi_sector = sector +
+			bio->bi_iter.bi_sector = sector +
 				conf->mirrors[d].rdev->data_offset;
 			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
 			count++;
@@ -3287,7 +3293,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_write;
 			bio->bi_rw = WRITE;
-			bio->bi_sector = sector +
+			bio->bi_iter.bi_sector = sector +
 				conf->mirrors[d].replacement->data_offset;
 			bio->bi_bdev = conf->mirrors[d].replacement->bdev;
 			count++;
@@ -3334,7 +3340,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			     bio2 = bio2->bi_next) {
 				/* remove last page from this bio */
 				bio2->bi_vcnt--;
-				bio2->bi_size -= len;
+				bio2->bi_iter.bi_size -= len;
 				bio2->bi_flags &= ~(1<< BIO_SEG_VALID);
 			}
 			goto bio_full;
@@ -4349,7 +4355,7 @@ read_more:
 	read_bio = bio_alloc_mddev(GFP_KERNEL, RESYNC_PAGES, mddev);
 
 	read_bio->bi_bdev = rdev->bdev;
-	read_bio->bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
+	read_bio->bi_iter.bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
 			       + rdev->data_offset);
 	read_bio->bi_private = r10_bio;
 	read_bio->bi_end_io = end_sync_read;
@@ -4357,7 +4363,7 @@ read_more:
 	read_bio->bi_flags &= ~(BIO_POOL_MASK - 1);
 	read_bio->bi_flags |= 1 << BIO_UPTODATE;
 	read_bio->bi_vcnt = 0;
-	read_bio->bi_size = 0;
+	read_bio->bi_iter.bi_size = 0;
 	r10_bio->master_bio = read_bio;
 	r10_bio->read_slot = r10_bio->devs[r10_bio->read_slot].devnum;
 
@@ -4383,7 +4389,8 @@ read_more:
 
 		bio_reset(b);
 		b->bi_bdev = rdev2->bdev;
-		b->bi_sector = r10_bio->devs[s/2].addr + rdev2->new_data_offset;
+		b->bi_iter.bi_sector = r10_bio->devs[s/2].addr +
+			rdev2->new_data_offset;
 		b->bi_private = r10_bio;
 		b->bi_end_io = end_reshape_write;
 		b->bi_rw = WRITE;
@@ -4410,7 +4417,7 @@ read_more:
 			     bio2 = bio2->bi_next) {
 				/* Remove last page from this bio */
 				bio2->bi_vcnt--;
-				bio2->bi_size -= len;
+				bio2->bi_iter.bi_size -= len;
 				bio2->bi_flags &= ~(1<<BIO_SEG_VALID);
 			}
 			goto bio_full;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7bbd285..a98cbbe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -91,7 +91,7 @@ static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
 static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
 {
 	int sectors = bio_sectors(bio);
-	if (bio->bi_sector + sectors < sector + STRIPE_SECTORS)
+	if (bio->bi_iter.bi_sector + sectors < sector + STRIPE_SECTORS)
 		return bio->bi_next;
 	else
 		return NULL;
@@ -183,7 +183,7 @@ static void return_io(struct bio *return_bi)
 
 		return_bi = bi->bi_next;
 		bi->bi_next = NULL;
-		bi->bi_size = 0;
+		bi->bi_iter.bi_size = 0;
 		bio_endio(bi, 0);
 		bi = return_bi;
 	}
@@ -654,17 +654,17 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			if (use_new_offset(conf, sh))
-				bi->bi_sector = (sh->sector
+				bi->bi_iter.bi_sector = (sh->sector
 						 + rdev->new_data_offset);
 			else
-				bi->bi_sector = (sh->sector
+				bi->bi_iter.bi_sector = (sh->sector
 						 + rdev->data_offset);
 			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 				bi->bi_rw |= REQ_FLUSH;
 
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
-			bi->bi_size = STRIPE_SIZE;
+			bi->bi_iter.bi_size = STRIPE_SIZE;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 			trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
@@ -692,14 +692,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				rbi->bi_rw, i);
 			atomic_inc(&sh->count);
 			if (use_new_offset(conf, sh))
-				rbi->bi_sector = (sh->sector
+				rbi->bi_iter.bi_sector = (sh->sector
 						  + rrdev->new_data_offset);
 			else
-				rbi->bi_sector = (sh->sector
+				rbi->bi_iter.bi_sector = (sh->sector
 						  + rrdev->data_offset);
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
-			rbi->bi_size = STRIPE_SIZE;
+			rbi->bi_iter.bi_size = STRIPE_SIZE;
 			trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
 					      rbi, disk_devt(conf->mddev->gendisk),
 					      sh->dev[i].sector);
@@ -727,10 +727,10 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 	struct async_submit_ctl submit;
 	enum async_tx_flags flags = 0;
 
-	if (bio->bi_sector >= sector)
-		page_offset = (signed)(bio->bi_sector - sector) * 512;
+	if (bio->bi_iter.bi_sector >= sector)
+		page_offset = (signed)(bio->bi_iter.bi_sector - sector) * 512;
 	else
-		page_offset = (signed)(sector - bio->bi_sector) * -512;
+		page_offset = (signed)(sector - bio->bi_iter.bi_sector) * -512;
 
 	if (frombio)
 		flags |= ASYNC_TX_FENCE;
@@ -797,7 +797,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 			BUG_ON(!dev->read);
 			rbi = dev->read;
 			dev->read = NULL;
-			while (rbi && rbi->bi_sector <
+			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				rbi2 = r5_next_bio(rbi, dev->sector);
 				if (!raid5_dec_bi_active_stripes(rbi)) {
@@ -833,7 +833,7 @@ static void ops_run_biofill(struct stripe_head *sh)
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
 			spin_unlock_irq(&sh->stripe_lock);
-			while (rbi && rbi->bi_sector <
+			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, dev->page,
 					dev->sector, tx);
@@ -1175,7 +1175,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 			wbi = dev->written = chosen;
 			spin_unlock_irq(&sh->stripe_lock);
 
-			while (wbi && wbi->bi_sector <
+			while (wbi && wbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				if (wbi->bi_rw & REQ_FUA)
 					set_bit(R5_WantFUA, &dev->flags);
@@ -2364,7 +2364,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	int firstwrite=0;
 
 	pr_debug("adding bi b#%llu to stripe s#%llu\n",
-		(unsigned long long)bi->bi_sector,
+		(unsigned long long)bi->bi_iter.bi_sector,
 		(unsigned long long)sh->sector);
 
 	/*
@@ -2382,12 +2382,12 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 			firstwrite = 1;
 	} else
 		bip = &sh->dev[dd_idx].toread;
-	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
-		if (bio_end_sector(*bip) > bi->bi_sector)
+	while (*bip && (*bip)->bi_iter.bi_sector < bi->bi_iter.bi_sector) {
+		if (bio_end_sector(*bip) > bi->bi_iter.bi_sector)
 			goto overlap;
 		bip = & (*bip)->bi_next;
 	}
-	if (*bip && (*bip)->bi_sector < bio_end_sector(bi))
+	if (*bip && (*bip)->bi_iter.bi_sector < bio_end_sector(bi))
 		goto overlap;
 
 	BUG_ON(*bip && bi->bi_next && (*bip) != bi->bi_next);
@@ -2401,7 +2401,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		sector_t sector = sh->dev[dd_idx].sector;
 		for (bi=sh->dev[dd_idx].towrite;
 		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
-			     bi && bi->bi_sector <= sector;
+			     bi && bi->bi_iter.bi_sector <= sector;
 		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
 			if (bio_end_sector(bi) >= sector)
 				sector = bio_end_sector(bi);
@@ -2411,7 +2411,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	}
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
-		(unsigned long long)(*bip)->bi_sector,
+		(unsigned long long)(*bip)->bi_iter.bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
 	spin_unlock_irq(&sh->stripe_lock);
 
@@ -2486,7 +2486,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
 
-		while (bi && bi->bi_sector <
+		while (bi && bi->bi_iter.bi_sector <
 			sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -2505,7 +2505,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
 		if (bi) bitmap_end = 1;
-		while (bi && bi->bi_sector <
+		while (bi && bi->bi_iter.bi_sector <
 		       sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -2529,7 +2529,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			spin_unlock_irq(&sh->stripe_lock);
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
-			while (bi && bi->bi_sector <
+			while (bi && bi->bi_iter.bi_sector <
 			       sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *nextbi =
 					r5_next_bio(bi, sh->dev[i].sector);
@@ -2750,7 +2750,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					clear_bit(R5_UPTODATE, &dev->flags);
 				wbi = dev->written;
 				dev->written = NULL;
-				while (wbi && wbi->bi_sector <
+				while (wbi && wbi->bi_iter.bi_sector <
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
 					if (!raid5_dec_bi_active_stripes(wbi)) {
@@ -3801,7 +3801,7 @@ static int raid5_mergeable_bvec(struct request_queue *q,
 
 static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
 {
-	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
+	sector_t sector = bio->bi_iter.bi_sector + get_start_sect(bio->bi_bdev);
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bio_sectors(bio);
 
@@ -3936,9 +3936,9 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 	/*
 	 *	compute position
 	 */
-	align_bi->bi_sector =  raid5_compute_sector(conf, raid_bio->bi_sector,
-						    0,
-						    &dd_idx, NULL);
+	align_bi->bi_iter.bi_sector =
+		raid5_compute_sector(conf, raid_bio->bi_iter.bi_sector,
+				     0, &dd_idx, NULL);
 
 	end_sector = bio_end_sector(align_bi);
 	rcu_read_lock();
@@ -3963,7 +3963,8 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 		if (!bio_fits_rdev(align_bi) ||
-		    is_badblock(rdev, align_bi->bi_sector, bio_sectors(align_bi),
+		    is_badblock(rdev, align_bi->bi_iter.bi_sector,
+				bio_sectors(align_bi),
 				&first_bad, &bad_sectors)) {
 			/* too big in some way, or has a known bad block */
 			bio_put(align_bi);
@@ -3972,7 +3973,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		}
 
 		/* No reshape active, so we can trust rdev->data_offset */
-		align_bi->bi_sector += rdev->data_offset;
+		align_bi->bi_iter.bi_sector += rdev->data_offset;
 
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
@@ -3983,7 +3984,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 
 		trace_block_bio_remap(bdev_get_queue(align_bi->bi_bdev),
 				      align_bi, disk_devt(mddev->gendisk),
-				      raid_bio->bi_sector);
+				      raid_bio->bi_iter.bi_sector);
 		generic_make_request(align_bi);
 		return 1;
 	} else {
@@ -4117,8 +4118,8 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		/* Skip discard while reshape is happening */
 		return;
 
-	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
-	last_sector = bi->bi_sector + (bi->bi_size>>9);
+	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	last_sector = bi->bi_iter.bi_sector + (bi->bi_iter.bi_size>>9);
 
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
@@ -4214,7 +4215,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 		return;
 	}
 
-	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bio_end_sector(bi);
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
@@ -4675,7 +4676,8 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	int remaining;
 	int handled = 0;
 
-	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	logical_sector = raid_bio->bi_iter.bi_sector &
+		~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(conf, logical_sector,
 				      0, &dd_idx, NULL);
 	last_sector = bio_end_sector(raid_bio);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 12d08b4..bcebfba 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -823,7 +823,8 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	dev_info = bio->bi_bdev->bd_disk->private_data;
 	if (dev_info == NULL)
 		goto fail;
-	if ((bio->bi_sector & 7) != 0 || (bio->bi_size & 4095) != 0)
+	if ((bio->bi_iter.bi_sector & 7) != 0 ||
+	    (bio->bi_iter.bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
 		goto fail;
 	if (bio_end_sector(bio) > get_capacity(bio->bi_bdev->bd_disk)) {
@@ -846,7 +847,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 
-	index = (bio->bi_sector >> 3);
+	index = (bio->bi_iter.bi_sector >> 3);
 	bio_for_each_segment(bvec, bio, i) {
 		page_addr = (unsigned long)
 			page_address(bvec->bv_page) + bvec->bv_offset;
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 690c333..0330859 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -190,15 +190,16 @@ static void xpram_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long bytes;
 	int i;
 
-	if ((bio->bi_sector & 7) != 0 || (bio->bi_size & 4095) != 0)
+	if ((bio->bi_iter.bi_sector & 7) != 0 ||
+	    (bio->bi_iter.bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
 		goto fail;
-	if ((bio->bi_size >> 12) > xdev->size)
+	if ((bio->bi_iter.bi_size >> 12) > xdev->size)
 		/* Request size is no page-aligned. */
 		goto fail;
-	if ((bio->bi_sector >> 3) > 0xffffffffU - xdev->offset)
+	if ((bio->bi_iter.bi_sector >> 3) > 0xffffffffU - xdev->offset)
 		goto fail;
-	index = (bio->bi_sector >> 3) + xdev->offset;
+	index = (bio->bi_iter.bi_sector >> 3) + xdev->offset;
 	bio_for_each_segment(bvec, bio, i) {
 		page_addr = (unsigned long)
 			kmap(bvec->bv_page) + bvec->bv_offset;
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index d8293f2..d6125d8 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -731,7 +731,7 @@ static int _osd_req_list_objects(struct osd_request *or,
 
 	bio->bi_rw &= ~REQ_WRITE;
 	or->in.bio = bio;
-	or->in.total_bytes = bio->bi_size;
+	or->in.total_bytes = bio->bi_iter.bi_size;
 	return 0;
 }
 
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 5918fd7..4d395a5 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -380,8 +380,9 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
 		break;
 	}
 
-	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
-	offset = (bio->bi_sector & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
+	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
+	offset = (bio->bi_iter.bi_sector &
+		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
 	bio_for_each_segment(bvec, bio, i) {
 		int max_transfer_size = PAGE_SIZE - offset;
@@ -426,9 +427,10 @@ out:
 static inline int valid_io_request(struct zram *zram, struct bio *bio)
 {
 	if (unlikely(
-		(bio->bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
-		(bio->bi_sector & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)) ||
-		(bio->bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))) {
+		(bio->bi_iter.bi_sector >= (zram->disksize >> SECTOR_SHIFT)) ||
+		(bio->bi_iter.bi_sector &
+		 (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)) ||
+		(bio->bi_iter.bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))) {
 
 		return 0;
 	}
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8bcc514..b8c8997 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -319,7 +319,7 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
 	bio->bi_bdev = ib_dev->ibd_bd;
 	bio->bi_private = cmd;
 	bio->bi_end_io = &iblock_bio_done;
-	bio->bi_sector = lba;
+	bio->bi_iter.bi_sector = lba;
 
 	return bio;
 }
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 8fb4291..f824c30 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -215,9 +215,9 @@ unsigned int bio_integrity_tag_size(struct bio *bio)
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 
-	BUG_ON(bio->bi_size == 0);
+	BUG_ON(bio->bi_iter.bi_size == 0);
 
-	return bi->tag_size * (bio->bi_size / bi->sector_size);
+	return bi->tag_size * (bio->bi_iter.bi_size / bi->sector_size);
 }
 EXPORT_SYMBOL(bio_integrity_tag_size);
 
@@ -300,7 +300,7 @@ static void bio_integrity_generate(struct bio *bio)
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	struct blk_integrity_exchg bix;
 	struct bio_vec *bv;
-	sector_t sector = bio->bi_sector;
+	sector_t sector = bio->bi_iter.bi_sector;
 	unsigned int i, sectors, total;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
@@ -387,7 +387,7 @@ int bio_integrity_prep(struct bio *bio)
 	bip->bip_owns_buf = 1;
 	bip->bip_buf = buf;
 	bip->bip_size = len;
-	bip->bip_sector = bio->bi_sector;
+	bip->bip_sector = bio->bi_iter.bi_sector;
 
 	/* Map it */
 	offset = offset_in_page(buf);
diff --git a/fs/bio.c b/fs/bio.c
index 9238a54..85dcc10 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -531,13 +531,13 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	 * most users will be overriding ->bi_bdev with a new target,
 	 * so we don't set nor calculate new physical/hw segment counts here
 	 */
-	bio->bi_sector = bio_src->bi_sector;
+	bio->bi_iter.bi_sector = bio_src->bi_iter.bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_vcnt = bio_src->bi_vcnt;
-	bio->bi_size = bio_src->bi_size;
-	bio->bi_idx = bio_src->bi_idx;
+	bio->bi_iter.bi_size = bio_src->bi_iter.bi_size;
+	bio->bi_iter.bi_idx = bio_src->bi_iter.bi_idx;
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -611,7 +611,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (unlikely(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
-	if (((bio->bi_size + len) >> 9) > max_sectors)
+	if (((bio->bi_iter.bi_size + len) >> 9) > max_sectors)
 		return 0;
 
 	/*
@@ -634,8 +634,9 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 					   simulate merging updated prev_bvec
 					   as new bvec. */
 					.bi_bdev = bio->bi_bdev,
-					.bi_sector = bio->bi_sector,
-					.bi_size = bio->bi_size - prev_bv_len,
+					.bi_sector = bio->bi_iter.bi_sector,
+					.bi_size = bio->bi_iter.bi_size -
+						prev_bv_len,
 					.bi_rw = bio->bi_rw,
 				};
 
@@ -683,8 +684,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (q->merge_bvec_fn) {
 		struct bvec_merge_data bvm = {
 			.bi_bdev = bio->bi_bdev,
-			.bi_sector = bio->bi_sector,
-			.bi_size = bio->bi_size,
+			.bi_sector = bio->bi_iter.bi_sector,
+			.bi_size = bio->bi_iter.bi_size,
 			.bi_rw = bio->bi_rw,
 		};
 
@@ -707,7 +708,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	bio->bi_vcnt++;
 	bio->bi_phys_segments++;
  done:
-	bio->bi_size += len;
+	bio->bi_iter.bi_size += len;
 	return len;
 }
 
@@ -806,22 +807,22 @@ void bio_advance(struct bio *bio, unsigned bytes)
 	if (bio_integrity(bio))
 		bio_integrity_advance(bio, bytes);
 
-	bio->bi_sector += bytes >> 9;
-	bio->bi_size -= bytes;
+	bio->bi_iter.bi_sector += bytes >> 9;
+	bio->bi_iter.bi_size -= bytes;
 
 	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
 		return;
 
 	while (bytes) {
-		if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
+		if (unlikely(bio->bi_iter.bi_idx >= bio->bi_vcnt)) {
 			WARN_ONCE(1, "bio idx %d >= vcnt %d\n",
-				  bio->bi_idx, bio->bi_vcnt);
+				  bio->bi_iter.bi_idx, bio->bi_vcnt);
 			break;
 		}
 
 		if (bytes >= bio_iovec(bio)->bv_len) {
 			bytes -= bio_iovec(bio)->bv_len;
-			bio->bi_idx++;
+			bio->bi_iter.bi_idx++;
 		} else {
 			bio_iovec(bio)->bv_len -= bytes;
 			bio_iovec(bio)->bv_offset += bytes;
@@ -1474,7 +1475,7 @@ struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 	if (IS_ERR(bio))
 		return bio;
 
-	if (bio->bi_size == len)
+	if (bio->bi_iter.bi_size == len)
 		return bio;
 
 	/*
@@ -1754,16 +1755,16 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 		return bp;
 
 	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
-				bi->bi_sector + first_sectors);
+				bi->bi_iter.bi_sector + first_sectors);
 
 	BUG_ON(bio_segments(bi) > 1);
 	atomic_set(&bp->cnt, 3);
 	bp->error = 0;
 	bp->bio1 = *bi;
 	bp->bio2 = *bi;
-	bp->bio2.bi_sector += first_sectors;
-	bp->bio2.bi_size -= first_sectors << 9;
-	bp->bio1.bi_size = first_sectors << 9;
+	bp->bio2.bi_iter.bi_sector += first_sectors;
+	bp->bio2.bi_iter.bi_size -= first_sectors << 9;
+	bp->bio1.bi_iter.bi_size = first_sectors << 9;
 
 	if (bi->bi_vcnt != 0) {
 		bp->bv1 = *bio_iovec(bi);
@@ -1816,7 +1817,7 @@ sector_t bio_sector_offset(struct bio *bio, unsigned short index,
 	sector_sz = queue_logical_block_size(bio->bi_bdev->bd_disk->queue);
 	sectors = 0;
 
-	if (index >= bio->bi_idx)
+	if (index >= bio->bi_iter.bi_idx)
 		index = bio->bi_vcnt - 1;
 
 	bio_for_each_segment_all(bv, bio, i) {
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 18af6f4..7c6c60c 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1708,7 +1708,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 			return -1;
 		}
 		bio->bi_bdev = block_ctx->dev->bdev;
-		bio->bi_sector = dev_bytenr >> 9;
+		bio->bi_iter.bi_sector = dev_bytenr >> 9;
 		bio->bi_end_io = btrfsic_complete_bio_end_io;
 		bio->bi_private = &complete;
 
@@ -3112,16 +3112,16 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
 		int bio_is_patched;
 		char **mapped_datav;
 
-		dev_bytenr = 512 * bio->bi_sector;
+		dev_bytenr = 512 * bio->bi_iter.bi_sector;
 		bio_is_patched = 0;
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
 			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
 			       " bi_sector=%lu (bytenr %llu), bi_bdev=%p)\n",
-			       rw, bio->bi_vcnt, (unsigned long)bio->bi_sector,
-			       (unsigned long long)dev_bytenr,
-			       bio->bi_bdev);
+			       rw, bio->bi_vcnt,
+			       (unsigned long)bio->bi_iter.bi_sector,
+			       (unsigned long long)dev_bytenr, bio->bi_bdev);
 
 		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
 				       GFP_NOFS);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 15b9408..46f5837 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -171,7 +171,8 @@ static void end_compressed_bio_read(struct bio *bio, int err)
 		goto out;
 
 	inode = cb->inode;
-	ret = check_compressed_csum(inode, cb, (u64)bio->bi_sector << 9);
+	ret = check_compressed_csum(inode, cb,
+				    (u64)bio->bi_iter.bi_sector << 9);
 	if (ret)
 		goto csum_failed;
 
@@ -371,7 +372,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	for (pg_index = 0; pg_index < cb->nr_pages; pg_index++) {
 		page = compressed_pages[pg_index];
 		page->mapping = inode->i_mapping;
-		if (bio->bi_size)
+		if (bio->bi_iter.bi_size)
 			ret = io_tree->ops->merge_bio_hook(WRITE, page, 0,
 							   PAGE_CACHE_SIZE,
 							   bio, 0);
@@ -505,7 +506,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 
 		if (!em || last_offset < em->start ||
 		    (last_offset + PAGE_CACHE_SIZE > extent_map_end(em)) ||
-		    (em->block_start >> 9) != cb->orig_bio->bi_sector) {
+		    (em->block_start >> 9) != cb->orig_bio->bi_iter.bi_sector) {
 			free_extent_map(em);
 			unlock_extent(tree, last_offset, end);
 			unlock_page(page);
@@ -551,7 +552,7 @@ next:
  * in it.  We don't actually do IO on those pages but allocate new ones
  * to hold the compressed pages on disk.
  *
- * bio->bi_sector points to the compressed extent on disk
+ * bio->bi_iter.bi_sector points to the compressed extent on disk
  * bio->bi_io_vec points to all of the inode pages
  * bio->bi_vcnt is a count of pages
  *
@@ -572,7 +573,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	struct page *page;
 	struct block_device *bdev;
 	struct bio *comp_bio;
-	u64 cur_disk_byte = (u64)bio->bi_sector << 9;
+	u64 cur_disk_byte = (u64)bio->bi_iter.bi_sector << 9;
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
@@ -654,7 +655,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 		page->mapping = inode->i_mapping;
 		page->index = em_start >> PAGE_CACHE_SHIFT;
 
-		if (comp_bio->bi_size)
+		if (comp_bio->bi_iter.bi_size)
 			ret = tree->ops->merge_bio_hook(READ, page, 0,
 							PAGE_CACHE_SIZE,
 							comp_bio, 0);
@@ -682,8 +683,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 							comp_bio, sums);
 				BUG_ON(ret); /* -ENOMEM */
 			}
-			sums += (comp_bio->bi_size + root->sectorsize - 1) /
-				root->sectorsize;
+			sums += (comp_bio->bi_iter.bi_size +
+				 root->sectorsize - 1) / root->sectorsize;
 
 			ret = btrfs_map_bio(root, READ, comp_bio,
 					    mirror_num, 0);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bed072a..91918ec 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1943,7 +1943,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 		return -EIO;
 	bio->bi_private = &compl;
 	bio->bi_end_io = repair_io_failure_callback;
-	bio->bi_size = 0;
+	bio->bi_iter.bi_size = 0;
 	map_length = length;
 
 	ret = btrfs_map_block(fs_info, WRITE, logical,
@@ -1954,7 +1954,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 	}
 	BUG_ON(mirror_num != bbio->mirror_num);
 	sector = bbio->stripes[mirror_num-1].physical >> 9;
-	bio->bi_sector = sector;
+	bio->bi_iter.bi_sector = sector;
 	dev = bbio->stripes[mirror_num-1].dev;
 	kfree(bbio);
 	if (!dev || !dev->bdev || !dev->writeable) {
@@ -2235,9 +2235,9 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 	}
 	bio->bi_private = state;
 	bio->bi_end_io = failed_bio->bi_end_io;
-	bio->bi_sector = failrec->logical >> 9;
+	bio->bi_iter.bi_sector = failrec->logical >> 9;
 	bio->bi_bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
-	bio->bi_size = 0;
+	bio->bi_iter.bi_size = 0;
 
 	bio_add_page(bio, page, failrec->len, start - page_offset(page));
 
@@ -2350,8 +2350,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		struct extent_state *cached = NULL;
 		struct extent_state *state;
 
-		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
-			 "mirror=%ld\n", (u64)bio->bi_sector, err,
+		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, mirror=%ld\n",
+			 (u64)bio->bi_iter.bi_sector, err,
 			 (long int)bio->bi_bdev);
 		tree = &BTRFS_I(page->mapping->host)->io_tree;
 
@@ -2456,9 +2456,9 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 	}
 
 	if (bio) {
-		bio->bi_size = 0;
+		bio->bi_iter.bi_size = 0;
 		bio->bi_bdev = bdev;
-		bio->bi_sector = first_sector;
+		bio->bi_iter.bi_sector = first_sector;
 	}
 	return bio;
 }
@@ -2525,7 +2525,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	if (bio_ret && *bio_ret) {
 		bio = *bio_ret;
 		if (old_compressed)
-			contig = bio->bi_sector == sector;
+			contig = bio->bi_iter.bi_sector == sector;
 		else
 			contig = bio_end_sector(bio) == sector;
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ec16020..17bb6c7 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -192,7 +192,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	if (bio->bi_size > PAGE_CACHE_SIZE * 8)
+	if (bio->bi_iter.bi_size > PAGE_CACHE_SIZE * 8)
 		path->reada = 2;
 
 	WARN_ON(bio->bi_vcnt <= 0);
@@ -208,7 +208,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 		path->skip_locking = 1;
 	}
 
-	disk_bytenr = (u64)bio->bi_sector << 9;
+	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	if (dio)
 		offset = logical_offset;
 	while (bio_index < bio->bi_vcnt) {
@@ -438,13 +438,14 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 	u64 disk_bytenr;
 
 	WARN_ON(bio->bi_vcnt <= 0);
-	sums = kzalloc(btrfs_ordered_sum_size(root, bio->bi_size), GFP_NOFS);
+	sums = kzalloc(btrfs_ordered_sum_size(root, bio->bi_iter.bi_size),
+		       GFP_NOFS);
 	if (!sums)
 		return -ENOMEM;
 
 	sector_sum = sums->sums;
-	disk_bytenr = (u64)bio->bi_sector << 9;
-	sums->len = bio->bi_size;
+	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
+	sums->len = bio->bi_iter.bi_size;
 	INIT_LIST_HEAD(&sums->list);
 
 	if (contig)
@@ -468,7 +469,7 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 			btrfs_add_ordered_sum(inode, ordered, sums);
 			btrfs_put_ordered_extent(ordered);
 
-			bytes_left = bio->bi_size - total_bytes;
+			bytes_left = bio->bi_iter.bi_size - total_bytes;
 
 			sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
 				       GFP_NOFS);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca1b767..c48fe5c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1610,7 +1610,7 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
 			 unsigned long bio_flags)
 {
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
-	u64 logical = (u64)bio->bi_sector << 9;
+	u64 logical = (u64)bio->bi_iter.bi_sector << 9;
 	u64 length = 0;
 	u64 map_length;
 	int ret;
@@ -1618,7 +1618,7 @@ int btrfs_merge_bio_hook(int rw, struct page *page, unsigned long offset,
 	if (bio_flags & EXTENT_BIO_COMPRESSED)
 		return 0;
 
-	length = bio->bi_size;
+	length = bio->bi_iter.bi_size;
 	map_length = length;
 	ret = btrfs_map_block(root->fs_info, rw, logical,
 			      &map_length, NULL, 0);
@@ -7020,7 +7020,8 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 		printk(KERN_ERR "btrfs direct IO failed ino %llu rw %lu "
 		      "sector %#Lx len %u err no %d\n",
 		      (unsigned long long)btrfs_ino(dip->inode), bio->bi_rw,
-		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
+		      (unsigned long long)bio->bi_iter.bi_sector,
+		      bio->bi_iter.bi_size, err);
 		dip->errors = 1;
 
 		/*
@@ -7109,7 +7110,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	struct bio *bio;
 	struct bio *orig_bio = dip->orig_bio;
 	struct bio_vec *bvec = orig_bio->bi_io_vec;
-	u64 start_sector = orig_bio->bi_sector;
+	u64 start_sector = orig_bio->bi_iter.bi_sector;
 	u64 file_offset = dip->logical_offset;
 	u64 submit_len = 0;
 	u64 map_length;
@@ -7117,14 +7118,14 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	int ret = 0;
 	int async_submit = 0;
 
-	map_length = orig_bio->bi_size;
+	map_length = orig_bio->bi_iter.bi_size;
 	ret = btrfs_map_block(root->fs_info, rw, start_sector << 9,
 			      &map_length, NULL, 0);
 	if (ret) {
 		bio_put(orig_bio);
 		return -EIO;
 	}
-	if (map_length >= orig_bio->bi_size) {
+	if (map_length >= orig_bio->bi_iter.bi_size) {
 		bio = orig_bio;
 		goto submit;
 	}
@@ -7176,7 +7177,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			bio->bi_private = dip;
 			bio->bi_end_io = btrfs_end_dio_bio;
 
-			map_length = orig_bio->bi_size;
+			map_length = orig_bio->bi_iter.bi_size;
 			ret = btrfs_map_block(root->fs_info, rw,
 					      start_sector << 9,
 					      &map_length, NULL, 0);
@@ -7240,7 +7241,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 		bvec++;
 	} while (bvec <= (bio->bi_io_vec + bio->bi_vcnt - 1));
 
-	dip->disk_bytenr = (u64)bio->bi_sector << 9;
+	dip->disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
 	bio->bi_private = dip;
 	dip->errors = 0;
 	dip->orig_bio = bio;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 9a79fb7..aa4713a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1033,8 +1033,8 @@ int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 
 	/* see if we can add this page onto our existing bio */
 	if (last) {
-		last_end = (u64)last->bi_sector << 9;
-		last_end += last->bi_size;
+		last_end = (u64)last->bi_iter.bi_sector << 9;
+		last_end += last->bi_iter.bi_size;
 
 		/*
 		 * we can't merge these if they are from different
@@ -1054,9 +1054,9 @@ int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 	if (!bio)
 		return -ENOMEM;
 
-	bio->bi_size = 0;
+	bio->bi_iter.bi_size = 0;
 	bio->bi_bdev = stripe->dev->bdev;
-	bio->bi_sector = disk_start >> 9;
+	bio->bi_iter.bi_sector = disk_start >> 9;
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 
 	bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
@@ -1112,7 +1112,7 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 
 	spin_lock_irq(&rbio->bio_list_lock);
 	bio_list_for_each(bio, &rbio->bio_list) {
-		start = (u64)bio->bi_sector << 9;
+		start = (u64)bio->bi_iter.bi_sector << 9;
 		stripe_offset = start - rbio->raid_map[0];
 		page_index = stripe_offset >> PAGE_CACHE_SHIFT;
 
@@ -1273,7 +1273,7 @@ cleanup:
 static int find_bio_stripe(struct btrfs_raid_bio *rbio,
 			   struct bio *bio)
 {
-	u64 physical = bio->bi_sector;
+	u64 physical = bio->bi_iter.bi_sector;
 	u64 stripe_start;
 	int i;
 	struct btrfs_bio_stripe *stripe;
@@ -1299,7 +1299,7 @@ static int find_bio_stripe(struct btrfs_raid_bio *rbio,
 static int find_logical_bio_stripe(struct btrfs_raid_bio *rbio,
 				   struct bio *bio)
 {
-	u64 logical = bio->bi_sector;
+	u64 logical = bio->bi_iter.bi_sector;
 	u64 stripe_start;
 	int i;
 
@@ -1601,8 +1601,8 @@ static int plug_cmp(void *priv, struct list_head *a, struct list_head *b)
 						 plug_list);
 	struct btrfs_raid_bio *rb = container_of(b, struct btrfs_raid_bio,
 						 plug_list);
-	u64 a_sector = ra->bio_list.head->bi_sector;
-	u64 b_sector = rb->bio_list.head->bi_sector;
+	u64 a_sector = ra->bio_list.head->bi_iter.bi_sector;
+	u64 b_sector = rb->bio_list.head->bi_iter.bi_sector;
 
 	if (a_sector < b_sector)
 		return -1;
@@ -1693,7 +1693,7 @@ int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 		return PTR_ERR(rbio);
 	}
 	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_size;
+	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 
 	/*
 	 * don't plug on full rbios, just get them out the door
@@ -2047,7 +2047,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 
 	rbio->read_rebuild = 1;
 	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_size;
+	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 53c3501..8a0bcf3 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1302,7 +1302,7 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 			continue;
 		}
 		bio->bi_bdev = page->dev->bdev;
-		bio->bi_sector = page->physical >> 9;
+		bio->bi_iter.bi_sector = page->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;
 		bio->bi_private = &complete;
 
@@ -1436,7 +1436,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		if (!bio)
 			return -EIO;
 		bio->bi_bdev = page_bad->dev->bdev;
-		bio->bi_sector = page_bad->physical >> 9;
+		bio->bi_iter.bi_sector = page_bad->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;
 		bio->bi_private = &complete;
 
@@ -1534,7 +1534,7 @@ again:
 		bio->bi_private = sbio;
 		bio->bi_end_io = scrub_wr_bio_end_io;
 		bio->bi_bdev = sbio->dev->bdev;
-		bio->bi_sector = sbio->physical >> 9;
+		bio->bi_iter.bi_sector = sbio->physical >> 9;
 		sbio->err = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical_for_dev_replace ||
@@ -1941,7 +1941,7 @@ again:
 		bio->bi_private = sbio;
 		bio->bi_end_io = scrub_bio_end_io;
 		bio->bi_bdev = sbio->dev->bdev;
-		bio->bi_sector = sbio->physical >> 9;
+		bio->bi_iter.bi_sector = sbio->physical >> 9;
 		sbio->err = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical ||
@@ -3299,8 +3299,8 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	}
 	bio->bi_private = &compl;
 	bio->bi_end_io = scrub_complete_bio_end_io;
-	bio->bi_size = 0;
-	bio->bi_sector = physical_for_dev_replace >> 9;
+	bio->bi_iter.bi_size = 0;
+	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
 	bio->bi_bdev = dev->bdev;
 	ret = bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
 	if (ret != PAGE_CACHE_SIZE) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d90e048..f6ffe0b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5172,7 +5172,7 @@ static int bio_size_ok(struct block_device *bdev, struct bio *bio,
 	if (!q->merge_bvec_fn)
 		return 1;
 
-	bvm.bi_size = bio->bi_size - prev->bv_len;
+	bvm.bi_size = bio->bi_iter.bi_size - prev->bv_len;
 	if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len)
 		return 0;
 	return 1;
@@ -5188,7 +5188,7 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 	bio->bi_private = merge_stripe_index_into_bio_private(
 			bio->bi_private, (unsigned int)dev_nr);
 	bio->bi_end_io = btrfs_end_bio;
-	bio->bi_sector = physical >> 9;
+	bio->bi_iter.bi_sector = physical >> 9;
 #ifdef DEBUG
 	{
 		struct rcu_string *name;
@@ -5226,7 +5226,7 @@ again:
 	while (bvec <= (first_bio->bi_io_vec + first_bio->bi_vcnt - 1)) {
 		if (bio_add_page(bio, bvec->bv_page, bvec->bv_len,
 				 bvec->bv_offset) < bvec->bv_len) {
-			u64 len = bio->bi_size;
+			u64 len = bio->bi_iter.bi_size;
 
 			atomic_inc(&bbio->stripes_pending);
 			submit_stripe_bio(root, bbio, bio, physical, dev_nr,
@@ -5249,7 +5249,7 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 		bio->bi_end_io = bbio->end_io;
 		bio->bi_bdev = (struct block_device *)
 			(unsigned long)bbio->mirror_num;
-		bio->bi_sector = logical >> 9;
+		bio->bi_iter.bi_sector = logical >> 9;
 		kfree(bbio);
 		bio_endio(bio, -EIO);
 	}
@@ -5260,7 +5260,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 {
 	struct btrfs_device *dev;
 	struct bio *first_bio = bio;
-	u64 logical = (u64)bio->bi_sector << 9;
+	u64 logical = (u64)bio->bi_iter.bi_sector << 9;
 	u64 length = 0;
 	u64 map_length;
 	u64 *raid_map = NULL;
@@ -5269,7 +5269,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	int total_devs = 1;
 	struct btrfs_bio *bbio = NULL;
 
-	length = bio->bi_size;
+	length = bio->bi_iter.bi_size;
 	map_length = length;
 
 	ret = __btrfs_map_block(root->fs_info, rw, logical, &map_length, &bbio,
diff --git a/fs/buffer.c b/fs/buffer.c
index ecd3792..b4422f3 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2925,11 +2925,11 @@ static void guard_bh_eod(int rw, struct bio *bio, struct buffer_head *bh)
 	 * let it through, and the IO layer will turn it into
 	 * an EIO.
 	 */
-	if (unlikely(bio->bi_sector >= maxsector))
+	if (unlikely(bio->bi_iter.bi_sector >= maxsector))
 		return;
 
-	maxsector -= bio->bi_sector;
-	bytes = bio->bi_size;
+	maxsector -= bio->bi_iter.bi_sector;
+	bytes = bio->bi_iter.bi_size;
 	if (likely((bytes >> 9) <= maxsector))
 		return;
 
@@ -2937,7 +2937,7 @@ static void guard_bh_eod(int rw, struct bio *bio, struct buffer_head *bh)
 	bytes = maxsector << 9;
 
 	/* Truncate the bio.. */
-	bio->bi_size = bytes;
+	bio->bi_iter.bi_size = bytes;
 	bio->bi_io_vec[0].bv_len = bytes;
 
 	/* ..and clear the end of the buffer for reads */
@@ -2972,14 +2972,14 @@ int submit_bh(int rw, struct buffer_head * bh)
 	 */
 	bio = bio_alloc(GFP_NOIO, 1);
 
-	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_io_vec[0].bv_page = bh->b_page;
 	bio->bi_io_vec[0].bv_len = bh->b_size;
 	bio->bi_io_vec[0].bv_offset = bh_offset(bh);
 
 	bio->bi_vcnt = 1;
-	bio->bi_size = bh->b_size;
+	bio->bi_iter.bi_size = bh->b_size;
 
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 38484b0..ca9721f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -348,7 +348,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
 
 	bio->bi_bdev = bdev;
-	bio->bi_sector = first_sector;
+	bio->bi_iter.bi_sector = first_sector;
 	if (dio->is_async)
 		bio->bi_end_io = dio_bio_end_aio;
 	else
@@ -653,7 +653,7 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
 	if (sdio->bio) {
 		loff_t cur_offset = sdio->cur_page_fs_offset;
 		loff_t bio_next_offset = sdio->logical_offset_in_bio +
-			sdio->bio->bi_size;
+			sdio->bio->bi_iter.bi_size;
 
 		/*
 		 * See whether this new request is contiguous with the old.
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 809b310..5a33a7e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -233,7 +233,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 	ext4_io_end_t *io_end = bio->bi_private;
 	struct inode *inode;
 	int i;
-	sector_t bi_sector = bio->bi_sector;
+	sector_t bi_sector = bio->bi_iter.bi_sector;
 
 	BUG_ON(!io_end);
 	bio->bi_private = NULL;
@@ -321,7 +321,7 @@ static int io_submit_init(struct ext4_io_submit *io,
 	if (!io_end)
 		return -ENOMEM;
 	bio = bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES));
-	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_private = io->io_end = io_end;
 	bio->bi_end_io = ext4_end_bio;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7bd22a2..f5c5a8a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -347,7 +347,7 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 	bio = f2fs_bio_alloc(bdev, 1);
 
 	/* Initialize the bio */
-	bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+	bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
 	bio->bi_end_io = read_end_io;
 
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 777f17e..a2964a8 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -697,7 +697,8 @@ static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
 alloc_new:
 	if (sbi->bio[type] == NULL) {
 		sbi->bio[type] = f2fs_bio_alloc(bdev, bio_get_nr_vecs(bdev));
-		sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
+		sbi->bio[type]->bi_iter.bi_sector =
+			SECTOR_FROM_BLOCK(sbi, blk_addr);
 		/*
 		 * The end_io will be assigned at the sumbission phase.
 		 * Until then, let bio_add_page() merge consecutive IOs as much
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 5c37ef9..7b2399b 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -271,7 +271,7 @@ static struct bio *gfs2_log_alloc_bio(struct gfs2_sbd *sdp, u64 blkno)
 		nrvecs = max(nrvecs/2, 1U);
 	}
 
-	bio->bi_sector = blkno * (sb->s_blocksize >> 9);
+	bio->bi_iter.bi_sector = blkno * (sb->s_blocksize >> 9);
 	bio->bi_bdev = sb->s_bdev;
 	bio->bi_end_io = gfs2_end_log_write;
 	bio->bi_private = sdp;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 60ede2a..0606aea 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -224,7 +224,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 	lock_page(page);
 
 	bio = bio_alloc(GFP_NOFS, 1);
-	bio->bi_sector = sector * (sb->s_blocksize >> 9);
+	bio->bi_iter.bi_sector = sector * (sb->s_blocksize >> 9);
 	bio->bi_bdev = sb->s_bdev;
 	bio_add_page(bio, page, PAGE_SIZE, 0);
 
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 90effcc..d556808 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -71,7 +71,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	sector &= ~((io_size >> HFSPLUS_SECTOR_SHIFT) - 1);
 
 	bio = bio_alloc(GFP_NOIO, 1);
-	bio->bi_sector = sector;
+	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = sb->s_bdev;
 	bio->bi_end_io = hfsplus_end_io_sync;
 	bio->bi_private = &wait;
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 8ae5e35..175fc99 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1997,14 +1997,14 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bio = bio_alloc(GFP_NOFS, 1);
 
-	bio->bi_sector = bp->l_blkno << (log->l2bsize - 9);
+	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
 	bio->bi_io_vec[0].bv_page = bp->l_page;
 	bio->bi_io_vec[0].bv_len = LOGPSIZE;
 	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
 	bio->bi_vcnt = 1;
-	bio->bi_size = LOGPSIZE;
+	bio->bi_iter.bi_size = LOGPSIZE;
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
@@ -2137,21 +2137,21 @@ static void lbmStartIO(struct lbuf * bp)
 	jfs_info("lbmStartIO\n");
 
 	bio = bio_alloc(GFP_NOFS, 1);
-	bio->bi_sector = bp->l_blkno << (log->l2bsize - 9);
+	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
 	bio->bi_io_vec[0].bv_page = bp->l_page;
 	bio->bi_io_vec[0].bv_len = LOGPSIZE;
 	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
 	bio->bi_vcnt = 1;
-	bio->bi_size = LOGPSIZE;
+	bio->bi_iter.bi_size = LOGPSIZE;
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
 
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
-		bio->bi_size = 0;
+		bio->bi_iter.bi_size = 0;
 		lbmIODone(bio, 0);
 	} else {
 		submit_bio(WRITE_SYNC, bio);
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 6740d34..299d9cd 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -416,7 +416,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 			 * count from hitting zero before we're through
 			 */
 			inc_io(page);
-			if (!bio->bi_size)
+			if (!bio->bi_iter.bi_size)
 				goto dump_bio;
 			submit_bio(WRITE, bio);
 			nr_underway++;
@@ -438,7 +438,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 
 		bio = bio_alloc(GFP_NOFS, 1);
 		bio->bi_bdev = inode->i_sb->s_bdev;
-		bio->bi_sector = pblock << (inode->i_blkbits - 9);
+		bio->bi_iter.bi_sector = pblock << (inode->i_blkbits - 9);
 		bio->bi_end_io = metapage_write_end_io;
 		bio->bi_private = page;
 
@@ -452,7 +452,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 	if (bio) {
 		if (bio_add_page(bio, page, bio_bytes, bio_offset) < bio_bytes)
 				goto add_failed;
-		if (!bio->bi_size)
+		if (!bio->bi_iter.bi_size)
 			goto dump_bio;
 
 		submit_bio(WRITE, bio);
@@ -517,7 +517,8 @@ static int metapage_readpage(struct file *fp, struct page *page)
 
 			bio = bio_alloc(GFP_NOFS, 1);
 			bio->bi_bdev = inode->i_sb->s_bdev;
-			bio->bi_sector = pblock << (inode->i_blkbits - 9);
+			bio->bi_iter.bi_sector =
+				pblock << (inode->i_blkbits - 9);
 			bio->bi_end_io = metapage_read_end_io;
 			bio->bi_private = page;
 			len = xlen << inode->i_blkbits;
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 550475c..a1b161f 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -32,9 +32,9 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio_vec.bv_len = PAGE_SIZE;
 	bio_vec.bv_offset = 0;
 	bio.bi_vcnt = 1;
-	bio.bi_size = PAGE_SIZE;
+	bio.bi_iter.bi_size = PAGE_SIZE;
 	bio.bi_bdev = bdev;
-	bio.bi_sector = page->index * (PAGE_SIZE >> 9);
+	bio.bi_iter.bi_sector = page->index * (PAGE_SIZE >> 9);
 	init_completion(&complete);
 	bio.bi_private = &complete;
 	bio.bi_end_io = request_complete;
@@ -107,9 +107,9 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 		if (i >= max_pages) {
 			/* Block layer cannot split bios :( */
 			bio->bi_vcnt = i;
-			bio->bi_size = i * PAGE_SIZE;
+			bio->bi_iter.bi_size = i * PAGE_SIZE;
 			bio->bi_bdev = super->s_bdev;
-			bio->bi_sector = ofs >> 9;
+			bio->bi_iter.bi_sector = ofs >> 9;
 			bio->bi_private = sb;
 			bio->bi_end_io = writeseg_end_io;
 			atomic_inc(&super->s_pending_writes);
@@ -134,9 +134,9 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 		unlock_page(page);
 	}
 	bio->bi_vcnt = nr_pages;
-	bio->bi_size = nr_pages * PAGE_SIZE;
+	bio->bi_iter.bi_size = nr_pages * PAGE_SIZE;
 	bio->bi_bdev = super->s_bdev;
-	bio->bi_sector = ofs >> 9;
+	bio->bi_iter.bi_sector = ofs >> 9;
 	bio->bi_private = sb;
 	bio->bi_end_io = writeseg_end_io;
 	atomic_inc(&super->s_pending_writes);
@@ -199,9 +199,9 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 		if (i >= max_pages) {
 			/* Block layer cannot split bios :( */
 			bio->bi_vcnt = i;
-			bio->bi_size = i * PAGE_SIZE;
+			bio->bi_iter.bi_size = i * PAGE_SIZE;
 			bio->bi_bdev = super->s_bdev;
-			bio->bi_sector = ofs >> 9;
+			bio->bi_iter.bi_sector = ofs >> 9;
 			bio->bi_private = sb;
 			bio->bi_end_io = erase_end_io;
 			atomic_inc(&super->s_pending_writes);
@@ -220,9 +220,9 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 		bio->bi_io_vec[i].bv_offset = 0;
 	}
 	bio->bi_vcnt = nr_pages;
-	bio->bi_size = nr_pages * PAGE_SIZE;
+	bio->bi_iter.bi_size = nr_pages * PAGE_SIZE;
 	bio->bi_bdev = super->s_bdev;
-	bio->bi_sector = ofs >> 9;
+	bio->bi_iter.bi_sector = ofs >> 9;
 	bio->bi_private = sb;
 	bio->bi_end_io = erase_end_io;
 	atomic_inc(&super->s_pending_writes);
diff --git a/fs/mpage.c b/fs/mpage.c
index 0face1c..92b125f 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -94,7 +94,7 @@ mpage_alloc(struct block_device *bdev,
 
 	if (bio) {
 		bio->bi_bdev = bdev;
-		bio->bi_sector = first_sector;
+		bio->bi_iter.bi_sector = first_sector;
 	}
 	return bio;
 }
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 434b93e..6f4e31d 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -134,8 +134,8 @@ bl_submit_bio(int rw, struct bio *bio)
 	if (bio) {
 		get_parallel(bio->bi_private);
 		dprintk("%s submitting %s bio %u@%llu\n", __func__,
-			rw == READ ? "read" : "write",
-			bio->bi_size, (unsigned long long)bio->bi_sector);
+			rw == READ ? "read" : "write", bio->bi_iter.bi_size,
+			(unsigned long long)bio->bi_iter.bi_sector);
 		submit_bio(rw, bio);
 	}
 	return NULL;
@@ -156,7 +156,8 @@ static struct bio *bl_alloc_init_bio(int npg, sector_t isect,
 	}
 
 	if (bio) {
-		bio->bi_sector = isect - be->be_f_offset + be->be_v_offset;
+		bio->bi_iter.bi_sector = isect - be->be_f_offset +
+			be->be_v_offset;
 		bio->bi_bdev = be->be_mdev;
 		bio->bi_end_io = end_io;
 		bio->bi_private = par;
@@ -519,7 +520,7 @@ bl_do_readpage_sync(struct page *page, struct pnfs_block_extent *be,
 	isect = (page->index << PAGE_CACHE_SECTOR_SHIFT) +
 		(offset / SECTOR_SIZE);
 
-	bio->bi_sector = isect - be->be_f_offset + be->be_v_offset;
+	bio->bi_iter.bi_sector = isect - be->be_f_offset + be->be_v_offset;
 	bio->bi_bdev = be->be_mdev;
 	bio->bi_end_io = bl_read_single_end_io;
 
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc9a913..85dabcd 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -417,7 +417,8 @@ static struct bio *nilfs_alloc_seg_bio(struct the_nilfs *nilfs, sector_t start,
 	}
 	if (likely(bio)) {
 		bio->bi_bdev = nilfs->ns_bdev;
-		bio->bi_sector = start << (nilfs->ns_blocksize_bits - 9);
+		bio->bi_iter.bi_sector =
+			start << (nilfs->ns_blocksize_bits - 9);
 	}
 	return bio;
 }
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 42252bf..0e7bac5 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -421,7 +421,7 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	}
 
 	/* Must put everything in 512 byte sectors for the bio... */
-	bio->bi_sector = (reg->hr_start_block + cs) << (bits - 9);
+	bio->bi_iter.bi_sector = (reg->hr_start_block + cs) << (bits - 9);
 	bio->bi_bdev = reg->hr_bdev;
 	bio->bi_private = wc;
 	bio->bi_end_io = o2hb_bio_end_io;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5f707e5..f65eb6f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -414,7 +414,7 @@ xfs_alloc_ioend_bio(
 	struct bio		*bio = bio_alloc(GFP_NOIO, nvecs);
 
 	ASSERT(bio->bi_private == NULL);
-	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
 	return bio;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e8f0df..4912b9b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1282,7 +1282,7 @@ next_chunk:
 
 	bio = bio_alloc(GFP_NOIO, nr_pages);
 	bio->bi_bdev = bp->b_target->bt_bdev;
-	bio->bi_sector = sector;
+	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
 
@@ -1304,7 +1304,7 @@ next_chunk:
 		total_nr_pages--;
 	}
 
-	if (likely(bio->bi_size)) {
+	if (likely(bio->bi_iter.bi_size)) {
 		if (xfs_buf_is_vmapped(bp)) {
 			flush_kernel_vmap_range(bp->b_addr,
 						xfs_buf_vmap_len(bp));
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ef24466..d321e63 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -62,19 +62,19 @@
  * on highmem page vectors
  */
 #define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
-#define bio_iovec(bio)		bio_iovec_idx((bio), (bio)->bi_idx)
+#define bio_iovec(bio)		bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
 #define bio_page(bio)		bio_iovec((bio))->bv_page
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
-#define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
-#define bio_sectors(bio)	((bio)->bi_size >> 9)
-#define bio_end_sector(bio)	((bio)->bi_sector + bio_sectors((bio)))
+#define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_iter.bi_idx)
+#define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
+#define bio_end_sector(bio)	((bio)->bi_iter.bi_sector + bio_sectors((bio)))
 
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
 		return bio_iovec(bio)->bv_len;
 	else /* dataless requests such as discard */
-		return bio->bi_size;
+		return bio->bi_iter.bi_size;
 }
 
 static inline void *bio_data(struct bio *bio)
@@ -108,7 +108,7 @@ static inline void *bio_data(struct bio *bio)
  */
 
 #define __BVEC_END(bio)		bio_iovec_idx((bio), (bio)->bi_vcnt - 1)
-#define __BVEC_START(bio)	bio_iovec_idx((bio), (bio)->bi_idx)
+#define __BVEC_START(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
 
 /* Default implementation of BIOVEC_PHYS_MERGEABLE */
 #define __BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
@@ -150,7 +150,7 @@ static inline void *bio_data(struct bio *bio)
 	     i++)
 
 #define bio_for_each_segment(bvl, bio, i)				\
-	for (i = (bio)->bi_idx;						\
+	for (i = (bio)->bi_iter.bi_idx;					\
 	     bvl = bio_iovec_idx((bio), (i)), i < (bio)->bi_vcnt;	\
 	     i++)
 
@@ -364,7 +364,7 @@ static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
 #define __bio_kunmap_irq(buf, flags)	bvec_kunmap_irq(buf, flags)
 
 #define bio_kmap_irq(bio, flags) \
-	__bio_kmap_irq((bio), (bio)->bi_idx, (flags))
+	__bio_kmap_irq((bio), (bio)->bi_iter.bi_idx, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
 /*
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index e8de670..66bf67a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -28,13 +28,19 @@ struct bio_vec {
 	unsigned int	bv_offset;
 };
 
+struct bvec_iter {
+	sector_t		bi_sector;	/* device address in 512 byte
+						   sectors */
+	unsigned int		bi_size;	/* residual I/O count */
+
+	unsigned int		bi_idx;		/* current index into bvl_vec */
+};
+
 /*
  * main unit of I/O for the block layer and lower layers (ie drivers and
  * stacking drivers)
  */
 struct bio {
-	sector_t		bi_sector;	/* device address in 512 byte
-						   sectors */
 	struct bio		*bi_next;	/* request queue link */
 	struct block_device	*bi_bdev;
 	unsigned long		bi_flags;	/* status, command, etc */
@@ -42,22 +48,21 @@ struct bio {
 						 * top bits priority
 						 */
 
+	struct bvec_iter	bi_iter;
+
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
-	unsigned short		bi_idx;		/* current index into bvl_vec */
 
 	/* Number of segments in this BIO after
 	 * physical address coalescing is performed.
 	 */
-	unsigned int		bi_phys_segments;
-
-	unsigned int		bi_size;	/* residual I/O count */
+	unsigned short		bi_phys_segments;
 
 	/*
 	 * To keep track of the max segment size, we account for the
 	 * sizes of the first and last mergeable segments in this bio.
 	 */
-	unsigned int		bi_seg_front_size;
-	unsigned int		bi_seg_back_size;
+	unsigned short		bi_seg_front_size;
+	unsigned short		bi_seg_back_size;
 
 	bio_end_io_t		*bi_end_io;
 
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 5a28843..3b5fa36 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -243,9 +243,9 @@ TRACE_EVENT(block_bio_bounce,
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev ?
 					  bio->bi_bdev->bd_dev : 0;
-		__entry->sector		= bio->bi_sector;
+		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -280,10 +280,10 @@ TRACE_EVENT(block_bio_complete,
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev ?
 					  bio->bi_bdev->bd_dev : 0;
-		__entry->sector		= bio->bi_sector;
+		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		__entry->error		= error;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%d]",
@@ -308,9 +308,9 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
+		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -375,9 +375,9 @@ TRACE_EVENT(block_bio_queue,
 
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
+		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -403,7 +403,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
 
 	TP_fast_assign(
 		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
-		__entry->sector		= bio ? bio->bi_sector : 0;
+		__entry->sector		= bio ? bio->bi_iter.bi_sector : 0;
 		__entry->nr_sector	= bio ? bio_sectors(bio) : 0;
 		blk_fill_rwbs(__entry->rwbs,
 			      bio ? bio->bi_rw : 0, __entry->nr_sector);
@@ -538,9 +538,9 @@ TRACE_EVENT(block_split,
 
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
+		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->new_sector	= new_sector;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
@@ -579,11 +579,11 @@ TRACE_EVENT(block_bio_remap,
 
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
+		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_iter.bi_size);
 	),
 
 	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index d09dd10..9a58bc2 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -32,7 +32,7 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	struct bio *bio;
 
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
-	bio->bi_sector = sector;
+	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = bdev;
 	bio->bi_end_io = end_swap_bio_read;
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 9e5b8c2..1e78cdb 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -770,8 +770,8 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 	if (!error && !bio_flagged(bio, BIO_UPTODATE))
 		error = EIO;
 
-	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what,
-			error, 0, NULL);
+	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
+			bio->bi_rw, what, error, 0, NULL);
 }
 
 static void blk_add_trace_bio_bounce(void *ignore,
@@ -888,8 +888,9 @@ static void blk_add_trace_split(void *ignore,
 	if (bt) {
 		__be64 rpdu = cpu_to_be64(pdu);
 
-		__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw,
-				BLK_TA_SPLIT, !bio_flagged(bio, BIO_UPTODATE),
+		__blk_add_trace(bt, bio->bi_iter.bi_sector,
+				bio->bi_iter.bi_size, bio->bi_rw, BLK_TA_SPLIT,
+				!bio_flagged(bio, BIO_UPTODATE),
 				sizeof(rpdu), &rpdu);
 	}
 }
@@ -921,9 +922,9 @@ static void blk_add_trace_bio_remap(void *ignore,
 	r.device_to   = cpu_to_be32(bio->bi_bdev->bd_dev);
 	r.sector_from = cpu_to_be64(from);
 
-	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw,
-			BLK_TA_REMAP, !bio_flagged(bio, BIO_UPTODATE),
-			sizeof(r), &r);
+	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
+			bio->bi_rw, BLK_TA_REMAP,
+			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
 }
 
 /**
diff --git a/mm/page_io.c b/mm/page_io.c
index 8d3c0c0..24f1347 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -29,13 +29,13 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 
 	bio = bio_alloc(gfp_flags, 1);
 	if (bio) {
-		bio->bi_sector = map_swap_page(page, &bio->bi_bdev);
-		bio->bi_sector <<= PAGE_SHIFT - 9;
+		bio->bi_iter.bi_sector = map_swap_page(page, &bio->bi_bdev);
+		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_io_vec[0].bv_page = page;
 		bio->bi_io_vec[0].bv_len = PAGE_SIZE;
 		bio->bi_io_vec[0].bv_offset = 0;
 		bio->bi_vcnt = 1;
-		bio->bi_size = PAGE_SIZE;
+		bio->bi_iter.bi_size = PAGE_SIZE;
 		bio->bi_end_io = end_io;
 	}
 	return bio;
@@ -60,7 +60,7 @@ static void end_swap_bio_write(struct bio *bio, int err)
 		printk(KERN_ALERT "Write-error on swap-device (%u:%u:%Lu)\n",
 				imajor(bio->bi_bdev->bd_inode),
 				iminor(bio->bi_bdev->bd_inode),
-				(unsigned long long)bio->bi_sector);
+				(unsigned long long)bio->bi_iter.bi_sector);
 		ClearPageReclaim(page);
 	}
 	end_page_writeback(page);
@@ -78,7 +78,7 @@ void end_swap_bio_read(struct bio *bio, int err)
 		printk(KERN_ALERT "Read-error on swap-device (%u:%u:%Lu)\n",
 				imajor(bio->bi_bdev->bd_inode),
 				iminor(bio->bi_bdev->bd_inode),
-				(unsigned long long)bio->bi_sector);
+				(unsigned long long)bio->bi_iter.bi_sector);
 	} else {
 		SetPageUptodate(page);
 	}
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 2c0669f..0c102ec 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -705,7 +705,7 @@ static void init_bio_iter(struct bio *bio, struct bio **iter, int *seg)
 		return;
 	}
 	*iter = bio;
-	*seg = bio->bi_idx;
+	*seg = bio->bi_iter.bi_idx;
 }
 
 static void iter_bio_next(struct bio **bio_iter, int *seg)
-- 
1.8.1.3

