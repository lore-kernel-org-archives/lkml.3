Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaFBJoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:44:19 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:48944 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:44:15 -0400
Message-ID: <538C4767.5050207@acm.org>
Date: Mon, 02 Jun 2014 11:44:07 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] block: Eliminate first argument of submit_bio()
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The submit_bio() API is confusing. Merge functions like
raid5_mergeable_bvec() can only work correctly if bi_rw is set
before bio_add_page() has been called. submit_bio() modifies
bi_rw after bio_add_page() has been called. Hence remove the
first argument of submit_bio() and let the caller set bi_rw.
Note: some but not all submit_bio() callers have been fixed
such that bi_rw is set before bio_add_page() is called.

See also http://thread.gmane.org/gmane.comp.file-systems.ocfs2.devel/7988
for a prior discussion of this topic.

Compile tested only, hence the "RFC".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 block/blk-core.c                    | 10 +++++++---
 block/blk-flush.c                   |  3 ++-
 block/blk-lib.c                     |  9 ++++++---
 drivers/block/drbd/drbd_actlog.c    |  2 +-
 drivers/block/drbd/drbd_bitmap.c    |  4 ++--
 drivers/block/floppy.c              |  3 ++-
 drivers/block/xen-blkback/blkback.c |  4 +++-
 drivers/block/xen-blkfront.c        |  4 ++--
 drivers/md/bcache/debug.c           |  7 +++++--
 drivers/md/bcache/journal.c         |  2 +-
 drivers/md/bcache/super.c           |  4 ++--
 drivers/md/dm-bufio.c               |  3 ++-
 drivers/md/dm-io.c                  |  3 ++-
 drivers/md/md.c                     |  9 ++++++---
 drivers/md/raid1.c                  |  2 +-
 drivers/md/raid10.c                 |  3 ++-
 drivers/target/target_core_iblock.c |  9 ++++++---
 fs/bio.c                            |  7 +++----
 fs/btrfs/check-integrity.c          | 15 ++++++++-------
 fs/btrfs/check-integrity.h          |  4 ++--
 fs/btrfs/disk-io.c                  |  3 ++-
 fs/btrfs/extent_io.c                |  6 ++++--
 fs/btrfs/inode.c                    |  5 +++--
 fs/btrfs/raid56.c                   |  9 ++++++---
 fs/btrfs/scrub.c                    | 15 ++++++++++-----
 fs/btrfs/volumes.c                  |  9 ++++++---
 fs/buffer.c                         |  3 ++-
 fs/direct-io.c                      |  5 +++--
 fs/ext4/page-io.c                   |  3 ++-
 fs/f2fs/data.c                      | 11 ++++++-----
 fs/f2fs/segment.c                   |  3 ++-
 fs/gfs2/lops.c                      |  3 ++-
 fs/gfs2/ops_fstype.c                |  3 ++-
 fs/hfsplus/wrapper.c                |  3 ++-
 fs/jfs/jfs_logmgr.c                 |  7 ++++---
 fs/jfs/jfs_metapage.c               | 10 ++++++----
 fs/logfs/dev_bdev.c                 | 13 ++++++++-----
 fs/mpage.c                          |  3 ++-
 fs/nfs/blocklayout/blocklayout.c    |  6 ++++--
 fs/nilfs2/segbuf.c                  |  3 ++-
 fs/ocfs2/cluster/heartbeat.c        |  6 ++++--
 fs/xfs/xfs_aops.c                   |  3 ++-
 fs/xfs/xfs_buf.c                    |  3 ++-
 include/linux/bio.h                 |  4 ++--
 include/linux/fs.h                  |  4 ++--
 kernel/power/block_io.c             |  6 +++---
 mm/page_io.c                        |  8 +++++---
 47 files changed, 163 insertions(+), 101 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0e3096..f6f53af 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1866,17 +1866,21 @@ EXPORT_SYMBOL(generic_make_request);
 
 /**
  * submit_bio - submit a bio to the block device layer for I/O
- * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
  * @bio: The &struct bio which describes the I/O
  *
  * submit_bio() is very similar in purpose to generic_make_request(), and
  * uses that function to do most of the work. Both are fairly rough
  * interfaces; @bio must be presetup and ready for I/O.
  *
+ * Note: @bio->rw must be initialized before bio_add_page() is called because
+ * bio_add_page() invokes request_queue.merge_bvec_fn() and some
+ * merge_bvec_fn() implementations (e.g. raid5_mergeable_bvec()) only work
+ * correctly if @bio->rw has been set before bio_add_page() is invoked.
+ *
  */
-void submit_bio(int rw, struct bio *bio)
+void submit_bio(struct bio *bio)
 {
-	bio->bi_rw |= rw;
+	const int rw = bio->bi_rw;
 
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 43e6b47..2694ede 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -516,8 +516,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 
 	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_bdev = bdev;
+	bio->bi_rw = WRITE_FLUSH;
 
-	ret = submit_bio_wait(WRITE_FLUSH, bio);
+	ret = submit_bio_wait(bio);
 
 	/*
 	 * The driver must store the error location in ->bi_sector, if
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 97a733c..e51c71d 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -111,6 +111,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
+		bio->bi_rw = type;
 		bio->bi_private = &bb;
 
 		bio->bi_iter.bi_size = req_sects << 9;
@@ -118,7 +119,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector = end_sect;
 
 		atomic_inc(&bb.done);
-		submit_bio(type, bio);
+		submit_bio(bio);
 
 		/*
 		 * We can loop for a long time in here, if someone does
@@ -185,6 +186,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
+		bio->bi_rw = REQ_WRITE | REQ_WRITE_SAME;
 		bio->bi_private = &bb;
 		bio->bi_vcnt = 1;
 		bio->bi_io_vec->bv_page = page;
@@ -201,7 +203,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		}
 
 		atomic_inc(&bb.done);
-		submit_bio(REQ_WRITE | REQ_WRITE_SAME, bio);
+		submit_bio(bio);
 	}
 
 	/* Wait for bios in-flight */
@@ -250,6 +252,7 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_bdev   = bdev;
+		bio->bi_rw     = WRITE;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_private = &bb;
 
@@ -263,7 +266,7 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		}
 		ret = 0;
 		atomic_inc(&bb.done);
-		submit_bio(WRITE, bio);
+		submit_bio(bio);
 	}
 
 	/* Wait for bios in-flight */
diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 90ae4ba..e860d86 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -184,7 +184,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
 		bio_endio(bio, -EIO);
 	else
-		submit_bio(rw, bio);
+		submit_bio(bio);
 	wait_until_done_or_force_detached(device, bdev, &device->md_io.done);
 	if (bio_flagged(bio, BIO_UPTODATE))
 		err = device->md_io.error;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 1aa29f8..d711d57 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1034,12 +1034,12 @@ static void bm_page_io_async(struct bm_aio_ctx *ctx, int page_nr, int rw) __must
 	bio_add_page(bio, page, len, 0);
 	bio->bi_private = ctx;
 	bio->bi_end_io = bm_async_io_complete;
+	bio->bi_rw |= rw;
 
 	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
-		bio->bi_rw |= rw;
 		bio_endio(bio, -EIO);
 	} else {
-		submit_bio(rw, bio);
+		submit_bio(bio);
 		/* this should not count as user activity and cause the
 		 * resync to throttle -- see drbd_rs_should_slow_down(). */
 		atomic_add(len >> 9, &device->rs_sect_ev);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index fa9bb74..0be1edd 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3811,12 +3811,13 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	bio.bi_vcnt = 1;
 	bio.bi_iter.bi_size = size;
 	bio.bi_bdev = bdev;
+	bio.bi_rw = READ;
 	bio.bi_iter.bi_sector = 0;
 	bio.bi_flags = (1 << BIO_QUIET);
 	bio.bi_private = &cbdata;
 	bio.bi_end_io = floppy_rb0_cb;
 
-	submit_bio(READ, &bio);
+	submit_bio(&bio);
 	process_fd_request();
 
 	init_completion(&cbdata.complete);
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 64c60ed..36e7ad8 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1275,6 +1275,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 			biolist[nbio++] = bio;
 			bio->bi_bdev    = preq.bdev;
+			bio->bi_rw	= operation;
 			bio->bi_private = pending_req;
 			bio->bi_end_io  = end_block_io_op;
 			bio->bi_iter.bi_sector  = preq.sector_number;
@@ -1293,6 +1294,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 
 		biolist[nbio++] = bio;
 		bio->bi_bdev    = preq.bdev;
+		bio->bi_rw	= operation;
 		bio->bi_private = pending_req;
 		bio->bi_end_io  = end_block_io_op;
 	}
@@ -1301,7 +1303,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	blk_start_plug(&plug);
 
 	for (i = 0; i < nbio; i++)
-		submit_bio(operation, biolist[i]);
+		submit_bio(biolist[i]);
 
 	/* Let the I/Os go.. */
 	blk_finish_plug(&plug);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index efe1b47..f8763c7 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1553,7 +1553,7 @@ static int blkif_recover(struct blkfront_info *info)
 				bio_trim(cloned_bio, offset, size);
 				cloned_bio->bi_private = split_bio;
 				cloned_bio->bi_end_io = split_bio_end;
-				submit_bio(cloned_bio->bi_rw, cloned_bio);
+				submit_bio(cloned_bio);
 			}
 			/*
 			 * Now we have to wait for all those smaller bios to
@@ -1562,7 +1562,7 @@ static int blkif_recover(struct blkfront_info *info)
 			continue;
 		}
 		/* We don't need to split this bio */
-		submit_bio(bio->bi_rw, bio);
+		submit_bio(bio);
 	}
 
 	return 0;
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b1f1d5..b655f90 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -50,11 +50,12 @@ void bch_btree_verify(struct btree *b)
 
 	bio = bch_bbio_alloc(b->c);
 	bio->bi_bdev		= PTR_CACHE(b->c, &b->key, 0)->bdev;
+	bio->bi_rw		= REQ_META|READ_SYNC;
 	bio->bi_iter.bi_sector	= PTR_OFFSET(&b->key, 0);
 	bio->bi_iter.bi_size	= KEY_SIZE(&v->key) << 9;
 	bch_bio_map(bio, sorted);
 
-	submit_bio_wait(REQ_META|READ_SYNC, bio);
+	submit_bio_wait(bio);
 	bch_bbio_free(bio, b->c);
 
 	memcpy(ondisk, sorted, KEY_SIZE(&v->key) << 9);
@@ -114,10 +115,12 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	if (!check)
 		return;
 
+	check->bi_rw = READ_SYNC;
+
 	if (bio_alloc_pages(check, GFP_NOIO))
 		goto out_put;
 
-	submit_bio_wait(READ_SYNC, check);
+	submit_bio_wait(check);
 
 	bio_for_each_segment(bv, bio, iter) {
 		void *p1 = kmap_atomic(bv.bv_page);
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 59e8202..ee581ab 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -412,7 +412,7 @@ static void journal_discard_work(struct work_struct *work)
 	struct journal_device *ja =
 		container_of(work, struct journal_device, discard_work);
 
-	submit_bio(0, &ja->discard_bio);
+	submit_bio(&ja->discard_bio);
 }
 
 static void do_journal_discard(struct cache *ca)
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 926ded8..9aa13a5 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -235,7 +235,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	unsigned i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
-	bio->bi_rw		= REQ_SYNC|REQ_META;
+	bio->bi_rw		= REQ_SYNC|REQ_META|REQ_WRITE;
 	bio->bi_iter.bi_size	= SB_SIZE;
 	bch_bio_map(bio, NULL);
 
@@ -261,7 +261,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	pr_debug("ver %llu, flags %llu, seq %llu",
 		 sb->version, sb->flags, sb->seq);
 
-	submit_bio(REQ_WRITE, bio);
+	submit_bio(bio);
 }
 
 static void bch_write_bdev_super_unlock(struct closure *cl)
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 66c5d13..ee9a9fa 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -542,6 +542,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
 	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
 	b->bio.bi_bdev = b->c->bdev;
+	b->bio.bi_rw = rw;
 	b->bio.bi_end_io = end_io;
 
 	/*
@@ -569,7 +570,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 		ptr += PAGE_SIZE;
 	} while (len > 0);
 
-	submit_bio(rw, &b->bio);
+	submit_bio(&b->bio);
 }
 
 static void submit_io(struct dm_buffer *b, int rw, sector_t block,
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 3842ac7..52b8d2f 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -308,6 +308,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_iter.bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
+		bio->bi_rw = rw;
 		bio->bi_end_io = endio;
 		store_io_and_region_in_bio(bio, io, region);
 
@@ -342,7 +343,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		}
 
 		atomic_inc(&io->count);
-		submit_bio(rw, bio);
+		submit_bio(bio);
 	} while (remaining);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 237b7e0..5b923ea 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -378,8 +378,9 @@ static void submit_flushes(struct work_struct *ws)
 			bi->bi_end_io = md_end_flush;
 			bi->bi_private = rdev;
 			bi->bi_bdev = rdev->bdev;
+			bi->bi_rw = WRITE_FLUSH;
 			atomic_inc(&mddev->flush_pending);
-			submit_bio(WRITE_FLUSH, bi);
+			submit_bio(bi);
 			rcu_read_lock();
 			rdev_dec_pending(rdev, mddev);
 		}
@@ -754,13 +755,14 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
 
 	bio->bi_bdev = rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev;
+	bio->bi_rw = WRITE_FLUSH_FUA;
 	bio->bi_iter.bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
 
 	atomic_inc(&mddev->pending_writes);
-	submit_bio(WRITE_FLUSH_FUA, bio);
+	submit_bio(bio);
 }
 
 void md_super_wait(struct mddev *mddev)
@@ -784,6 +786,7 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 
 	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
 		rdev->meta_bdev : rdev->bdev;
+	bio->bi_rw = rw;
 	if (metadata_op)
 		bio->bi_iter.bi_sector = sector + rdev->sb_start;
 	else if (rdev->mddev->reshape_position != MaxSector &&
@@ -793,7 +796,7 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 	else
 		bio->bi_iter.bi_sector = sector + rdev->data_offset;
 	bio_add_page(bio, page, size, 0);
-	submit_bio_wait(rw, bio);
+	submit_bio_wait(bio);
 
 	ret = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio_put(bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 56e24c0..5704942 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2243,7 +2243,7 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_iter.bi_sector += rdev->data_offset;
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) == 0)
+		if (submit_bio_wait(wbio) == 0)
 			/* failure! */
 			ok = rdev_set_badblocks(rdev, sector,
 						sectors, 0)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cb882aa..b5fe3ec 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2605,7 +2605,8 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 				   choose_data_offset(r10_bio, rdev) +
 				   (sector - r10_bio->sector));
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) == 0)
+		wbio->bi_rw = WRITE;
+		if (submit_bio_wait(wbio) == 0)
 			/* Failure! */
 			ok = rdev_set_badblocks(rdev, sector,
 						sectors, 0)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 9e0232c..a27015b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -364,8 +364,10 @@ static void iblock_submit_bios(struct bio_list *list, int rw)
 	struct bio *bio;
 
 	blk_start_plug(&plug);
-	while ((bio = bio_list_pop(list)))
-		submit_bio(rw, bio);
+	while ((bio = bio_list_pop(list))) {
+		bio->bi_rw |= rw;
+		submit_bio(bio);
+	}
 	blk_finish_plug(&plug);
 }
 
@@ -407,9 +409,10 @@ iblock_execute_sync_cache(struct se_cmd *cmd)
 	bio = bio_alloc(GFP_KERNEL, 0);
 	bio->bi_end_io = iblock_end_io_flush;
 	bio->bi_bdev = ib_dev->ibd_bd;
+	bio->bi_rw = WRITE_FLUSH;
 	if (!immed)
 		bio->bi_private = cmd;
-	submit_bio(WRITE_FLUSH, bio);
+	submit_bio(bio);
 	return 0;
 }
 
diff --git a/fs/bio.c b/fs/bio.c
index 6f0362b..3678565 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -866,21 +866,20 @@ static void submit_bio_wait_endio(struct bio *bio, int error)
 
 /**
  * submit_bio_wait - submit a bio, and wait until it completes
- * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
  * @bio: The &struct bio which describes the I/O
  *
  * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
  * bio_endio() on failure.
  */
-int submit_bio_wait(int rw, struct bio *bio)
+int submit_bio_wait(struct bio *bio)
 {
 	struct submit_bio_ret ret;
 
-	rw |= REQ_SYNC;
+	bio->bi_rw |= REQ_SYNC;
 	init_completion(&ret.event);
 	bio->bi_private = &ret;
 	bio->bi_end_io = submit_bio_wait_endio;
-	submit_bio(rw, bio);
+	submit_bio(bio);
 	wait_for_completion(&ret.event);
 
 	return ret.error;
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 0e8388e..bebe088 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1699,6 +1699,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 			return -1;
 		}
 		bio->bi_bdev = block_ctx->dev->bdev;
+		bio->bi_rw = READ;
 		bio->bi_iter.bi_sector = dev_bytenr >> 9;
 
 		for (j = i; j < num_pages; j++) {
@@ -1712,7 +1713,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 			       "btrfsic: error, failed to add a single page!\n");
 			return -1;
 		}
-		if (submit_bio_wait(READ, bio)) {
+		if (submit_bio_wait(bio)) {
 			printk(KERN_INFO
 			       "btrfsic: read error at logical %llu dev %s!\n",
 			       block_ctx->start, block_ctx->dev->name);
@@ -3096,16 +3097,16 @@ leave:
 	mutex_unlock(&btrfsic_mutex);
 }
 
-void btrfsic_submit_bio(int rw, struct bio *bio)
+void btrfsic_submit_bio(struct bio *bio)
 {
-	__btrfsic_submit_bio(rw, bio);
-	submit_bio(rw, bio);
+	__btrfsic_submit_bio(bio->bi_rw, bio);
+	submit_bio(bio);
 }
 
-int btrfsic_submit_bio_wait(int rw, struct bio *bio)
+int btrfsic_submit_bio_wait(struct bio *bio)
 {
-	__btrfsic_submit_bio(rw, bio);
-	return submit_bio_wait(rw, bio);
+	__btrfsic_submit_bio(bio->bi_rw, bio);
+	return submit_bio_wait(bio);
 }
 
 int btrfsic_mount(struct btrfs_root *root,
diff --git a/fs/btrfs/check-integrity.h b/fs/btrfs/check-integrity.h
index 13b8566..c04e249 100644
--- a/fs/btrfs/check-integrity.h
+++ b/fs/btrfs/check-integrity.h
@@ -21,8 +21,8 @@
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 int btrfsic_submit_bh(int rw, struct buffer_head *bh);
-void btrfsic_submit_bio(int rw, struct bio *bio);
-int btrfsic_submit_bio_wait(int rw, struct bio *bio);
+void btrfsic_submit_bio(struct bio *bio);
+int btrfsic_submit_bio_wait(struct bio *bio);
 #else
 #define btrfsic_submit_bh submit_bh
 #define btrfsic_submit_bio submit_bio
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9833149..aebb01d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3252,12 +3252,13 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	bio->bi_bdev = device->bdev;
+	bio->bi_rw = WRITE_FLUSH;
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
 	device->flush_bio = bio;
 
 	bio_get(bio);
-	btrfsic_submit_bio(WRITE_FLUSH, bio);
+	btrfsic_submit_bio(bio);
 
 	return 0;
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3955e47..4ad0b0b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2052,9 +2052,10 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 		return -EIO;
 	}
 	bio->bi_bdev = dev->bdev;
+	bio->bi_rw = WRITE_SYNC;
 	bio_add_page(bio, page, length, start - page_offset(page));
 
-	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio)) {
+	if (btrfsic_submit_bio_wait(bio)) {
 		/* try to remap that extent elsewhere? */
 		bio_put(bio);
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
@@ -2646,6 +2647,7 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 
 	start = page_offset(page) + bvec->bv_offset;
 
+	bio->bi_rw |= rw;
 	bio->bi_private = NULL;
 
 	bio_get(bio);
@@ -2654,7 +2656,7 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
 					   mirror_num, bio_flags, start);
 	else
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(bio);
 
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f805bc..ba4bbab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7314,14 +7314,15 @@ out_err:
 	return 0;
 }
 
-static void btrfs_submit_direct(int rw, struct bio *dio_bio,
-				struct inode *inode, loff_t file_offset)
+static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
+				loff_t file_offset)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_dio_private *dip;
 	struct bio *io_bio;
 	int skip_sum;
 	int sum_len;
+	const int rw = bio_rw(dio_bio);
 	int write = rw & REQ_WRITE;
 	int ret = 0;
 	u16 csum_size;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 4055291..b58106c 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1253,10 +1253,11 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		if (!bio)
 			break;
 
+		bio->bi_rw |= WRITE;
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
 		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
-		submit_bio(WRITE, bio);
+		submit_bio(bio);
 	}
 	return;
 
@@ -1507,6 +1508,7 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 		if (!bio)
 			break;
 
+		bio->bi_rw |= READ;
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_rmw_end_io;
 
@@ -1514,7 +1516,7 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 				    BTRFS_WQ_ENDIO_RAID56);
 
 		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	}
 	/* the actual write will happen once the reads are done */
 	return 0;
@@ -2004,6 +2006,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 		if (!bio)
 			break;
 
+		bio->bi_rw |= READ;
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_recover_end_io;
 
@@ -2011,7 +2014,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 				    BTRFS_WQ_ENDIO_RAID56);
 
 		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	}
 out:
 	return 0;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0be7799..88ba735 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1343,10 +1343,11 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 			continue;
 		}
 		bio->bi_bdev = page->dev->bdev;
+		bio->bi_rw |= READ;
 		bio->bi_iter.bi_sector = page->physical >> 9;
 
 		bio_add_page(bio, page->page, PAGE_SIZE, 0);
-		if (btrfsic_submit_bio_wait(READ, bio))
+		if (btrfsic_submit_bio_wait(bio))
 			sblock->no_io_error_seen = 0;
 
 		bio_put(bio);
@@ -1463,6 +1464,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		if (!bio)
 			return -EIO;
 		bio->bi_bdev = page_bad->dev->bdev;
+		bio->bi_rw = WRITE;
 		bio->bi_iter.bi_sector = page_bad->physical >> 9;
 
 		ret = bio_add_page(bio, page_good->page, PAGE_SIZE, 0);
@@ -1471,7 +1473,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 			return -EIO;
 		}
 
-		if (btrfsic_submit_bio_wait(WRITE, bio)) {
+		if (btrfsic_submit_bio_wait(bio)) {
 			btrfs_dev_stat_inc_and_print(page_bad->dev,
 				BTRFS_DEV_STAT_WRITE_ERRS);
 			btrfs_dev_replace_stats_inc(
@@ -1604,7 +1606,8 @@ static void scrub_wr_submit(struct scrub_ctx *sctx)
 	 * orders the requests before sending them to the driver which
 	 * doubled the write performance on spinning disks when measured
 	 * with Linux 3.5 */
-	btrfsic_submit_bio(WRITE, sbio->bio);
+	sbio->bio->bi_rw |= WRITE;
+	btrfsic_submit_bio(sbio->bio);
 }
 
 static void scrub_wr_bio_end_io(struct bio *bio, int err)
@@ -1901,6 +1904,7 @@ static void scrub_submit(struct scrub_ctx *sctx)
 		return;
 
 	sbio = sctx->bios[sctx->curr];
+	sbio->bio->bi_rw |= READ;
 	sctx->curr = -1;
 	scrub_pending_bio_inc(sctx);
 
@@ -1916,7 +1920,7 @@ static void scrub_submit(struct scrub_ctx *sctx)
 			"BTRFS: scrub_submit(bio bdev == NULL) is unexpected!\n");
 		bio_endio(sbio->bio, -EIO);
 	} else {
-		btrfsic_submit_bio(READ, sbio->bio);
+		btrfsic_submit_bio(sbio->bio);
 	}
 }
 
@@ -3473,6 +3477,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
 	bio->bi_bdev = dev->bdev;
+	bio->bi_rw = WRITE_SYNC;
 	ret = bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
 	if (ret != PAGE_CACHE_SIZE) {
 leave_with_eio:
@@ -3481,7 +3486,7 @@ leave_with_eio:
 		return -EIO;
 	}
 
-	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio))
+	if (btrfsic_submit_bio_wait(bio))
 		goto leave_with_eio;
 
 	bio_put(bio);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49d7fab..997a769 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -369,7 +369,7 @@ loop_lock:
 			sync_pending = 0;
 		}
 
-		btrfsic_submit_bio(cur->bi_rw, cur);
+		btrfsic_submit_bio(cur);
 		num_run++;
 		batch_run++;
 		if (need_resched())
@@ -5358,6 +5358,8 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	int should_queue = 1;
 	struct btrfs_pending_bios *pending_bios;
 
+	bio->bi_rw |= rw;
+
 	if (device->missing || !device->bdev) {
 		bio_endio(bio, -EIO);
 		return;
@@ -5366,7 +5368,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	/* don't bother with additional async steps for reads, right now */
 	if (!(rw & REQ_WRITE)) {
 		bio_get(bio);
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(bio);
 		bio_put(bio);
 		return;
 	}
@@ -5456,13 +5458,14 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 	}
 #endif
 	bio->bi_bdev = dev->bdev;
+	bio->bi_rw |= rw;
 
 	btrfs_bio_counter_inc_noblocked(root->fs_info);
 
 	if (async)
 		btrfs_schedule_bio(root, dev, rw, bio);
 	else
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(bio);
 }
 
 static int breakup_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
diff --git a/fs/buffer.c b/fs/buffer.c
index 9ddb9fc..f18007d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3053,7 +3053,8 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 		rw |= REQ_PRIO;
 
 	bio_get(bio);
-	submit_bio(rw, bio);
+	bio->bi_rw |= rw;
+	submit_bio(bio);
 
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 31ba093..d3bfbb1 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -397,6 +397,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	struct bio *bio = sdio->bio;
 	unsigned long flags;
 
+	bio->bi_rw |= dio->rw;
 	bio->bi_private = dio;
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
@@ -407,10 +408,10 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 		bio_set_pages_dirty(bio);
 
 	if (sdio->submit_io)
-		sdio->submit_io(dio->rw, bio, dio->inode,
+		sdio->submit_io(bio, dio->inode,
 			       sdio->logical_offset_in_bio);
 	else
-		submit_bio(dio->rw, bio);
+		submit_bio(bio);
 
 	sdio->bio = NULL;
 	sdio->boundary = 0;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index c18d95b..3dd295b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -343,7 +343,8 @@ void ext4_io_submit(struct ext4_io_submit *io)
 
 	if (bio) {
 		bio_get(io->io_bio);
-		submit_bio(io->io_op, io->io_bio);
+		io->io_bio->bi_rw |= io->io_op;
+		submit_bio(io->io_bio);
 		BUG_ON(bio_flagged(io->io_bio, BIO_EOPNOTSUPP));
 		bio_put(io->io_bio);
 	}
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 45abd60..ff5c2fd 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -101,11 +101,12 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 		return;
 
 	rw = fio->rw;
+	io->bio->bi_rw |= rw;
 
 	if (is_read_io(rw)) {
 		trace_f2fs_submit_read_bio(io->sbi->sb, rw,
 						fio->type, io->bio);
-		submit_bio(rw, io->bio);
+		submit_bio(io->bio);
 	} else {
 		trace_f2fs_submit_write_bio(io->sbi->sb, rw,
 						fio->type, io->bio);
@@ -116,10 +117,10 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 		if (fio->type == META_FLUSH) {
 			DECLARE_COMPLETION_ONSTACK(wait);
 			io->sbi->wait_io = &wait;
-			submit_bio(rw, io->bio);
+			submit_bio(io->bio);
 			wait_for_completion(&wait);
 		} else {
-			submit_bio(rw, io->bio);
+			submit_bio(io->bio);
 		}
 	}
 
@@ -158,14 +159,14 @@ int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 
 	/* Allocate a new bio */
 	bio = __bio_alloc(sbi, blk_addr, 1, is_read_io(rw));
-
+	bio->bi_rw = rw;
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 		bio_put(bio);
 		f2fs_put_page(page, 1);
 		return -EFAULT;
 	}
 
-	submit_bio(rw, bio);
+	submit_bio(bio);
 	return 0;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 085f548..1ddcf19 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -218,8 +218,9 @@ repeat:
 		struct flush_cmd *cmd, *next;
 		int ret;
 
+		bio->bi_rw = WRITE_FLUSH;
 		bio->bi_bdev = sbi->sb->s_bdev;
-		ret = submit_bio_wait(WRITE_FLUSH, bio);
+		ret = submit_bio_wait(bio);
 
 		for (cmd = sm_i->dispatch_list; cmd; cmd = next) {
 			cmd->ret = ret;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index a294d8d..c9be2ff 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -240,7 +240,8 @@ void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw)
 {
 	if (sdp->sd_log_bio) {
 		atomic_inc(&sdp->sd_log_in_flight);
-		submit_bio(rw, sdp->sd_log_bio);
+		sdp->sd_log_bio->bi_rw |= rw;
+		submit_bio(sdp->sd_log_bio);
 		sdp->sd_log_bio = NULL;
 	}
 }
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 22f9540..30c9933 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -236,13 +236,14 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 	lock_page(page);
 
 	bio = bio_alloc(GFP_NOFS, 1);
+	bio->bi_rw = READ_SYNC | REQ_META;
 	bio->bi_iter.bi_sector = sector * (sb->s_blocksize >> 9);
 	bio->bi_bdev = sb->s_bdev;
 	bio_add_page(bio, page, PAGE_SIZE, 0);
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
-	submit_bio(READ_SYNC | REQ_META, bio);
+	submit_bio(bio);
 	wait_on_page_locked(page);
 	bio_put(bio);
 	if (!PageUptodate(page)) {
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 3f99964..c43b46f 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -63,6 +63,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	sector &= ~((io_size >> HFSPLUS_SECTOR_SHIFT) - 1);
 
 	bio = bio_alloc(GFP_NOIO, 1);
+	bio->bi_rw = rw;
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = sb->s_bdev;
 
@@ -83,7 +84,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 		buf = (u8 *)buf + len;
 	}
 
-	ret = submit_bio_wait(rw, bio);
+	ret = submit_bio_wait(bio);
 out:
 	bio_put(bio);
 	return ret < 0 ? ret : 0;
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 8d811e0..a334430 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1997,7 +1997,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 	bp->l_flag |= lbmREAD;
 
 	bio = bio_alloc(GFP_NOFS, 1);
-
+	bio->bi_rw = READ_SYNC;
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
 	bio->bi_io_vec[0].bv_page = bp->l_page;
@@ -2014,7 +2014,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 		bio->bi_iter.bi_size = 0;
 		lbmIODone(bio, 0);
 	} else {
-		submit_bio(READ_SYNC, bio);
+		submit_bio(bio);
 	}
 
 	wait_event(bp->l_ioevent, (bp->l_flag != lbmREAD));
@@ -2144,6 +2144,7 @@ static void lbmStartIO(struct lbuf * bp)
 	jfs_info("lbmStartIO\n");
 
 	bio = bio_alloc(GFP_NOFS, 1);
+	bio->bi_rw = WRITE_SYNC;
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
 	bio->bi_bdev = log->bdev;
 	bio->bi_io_vec[0].bv_page = bp->l_page;
@@ -2161,7 +2162,7 @@ static void lbmStartIO(struct lbuf * bp)
 		bio->bi_iter.bi_size = 0;
 		lbmIODone(bio, 0);
 	} else {
-		submit_bio(WRITE_SYNC, bio);
+		submit_bio(bio);
 		INCREMENT(lmStat.submitted);
 	}
 }
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 49ba7ff..93eaed9 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -418,7 +418,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 			inc_io(page);
 			if (!bio->bi_iter.bi_size)
 				goto dump_bio;
-			submit_bio(WRITE, bio);
+			submit_bio(bio);
 			nr_underway++;
 			bio = NULL;
 		} else
@@ -437,6 +437,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		len = min(xlen, (int)JFS_SBI(inode->i_sb)->nbperpage);
 
 		bio = bio_alloc(GFP_NOFS, 1);
+		bio->bi_rw = WRITE;
 		bio->bi_bdev = inode->i_sb->s_bdev;
 		bio->bi_iter.bi_sector = pblock << (inode->i_blkbits - 9);
 		bio->bi_end_io = metapage_write_end_io;
@@ -455,7 +456,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		if (!bio->bi_iter.bi_size)
 			goto dump_bio;
 
-		submit_bio(WRITE, bio);
+		submit_bio(bio);
 		nr_underway++;
 	}
 	if (redirty)
@@ -513,9 +514,10 @@ static int metapage_readpage(struct file *fp, struct page *page)
 				insert_metapage(page, NULL);
 			inc_io(page);
 			if (bio)
-				submit_bio(READ, bio);
+				submit_bio(bio);
 
 			bio = bio_alloc(GFP_NOFS, 1);
+			bio->bi_rw = READ;
 			bio->bi_bdev = inode->i_sb->s_bdev;
 			bio->bi_iter.bi_sector =
 				pblock << (inode->i_blkbits - 9);
@@ -530,7 +532,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 			block_offset++;
 	}
 	if (bio)
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	else
 		unlock_page(page);
 
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 76279e1..56c24ff 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -20,6 +20,7 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	struct bio_vec bio_vec;
 
 	bio_init(&bio);
+	bio.bi_rw = rw;
 	bio.bi_max_vecs = 1;
 	bio.bi_io_vec = &bio_vec;
 	bio_vec.bv_page = page;
@@ -30,7 +31,7 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio.bi_iter.bi_sector = page->index * (PAGE_SIZE >> 9);
 	bio.bi_iter.bi_size = PAGE_SIZE;
 
-	return submit_bio_wait(rw, &bio);
+	return submit_bio_wait(&bio);
 }
 
 static int bdev_readpage(void *_sb, struct page *page)
@@ -87,6 +88,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 
 	bio = bio_alloc(GFP_NOFS, max_pages);
 	BUG_ON(!bio);
+	bio->bi_rw = WRITE;
 
 	for (i = 0; i < nr_pages; i++) {
 		if (i >= max_pages) {
@@ -98,7 +100,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_private = sb;
 			bio->bi_end_io = writeseg_end_io;
 			atomic_inc(&super->s_pending_writes);
-			submit_bio(WRITE, bio);
+			submit_bio(bio);
 
 			ofs += i * PAGE_SIZE;
 			index += i;
@@ -125,7 +127,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_private = sb;
 	bio->bi_end_io = writeseg_end_io;
 	atomic_inc(&super->s_pending_writes);
-	submit_bio(WRITE, bio);
+	submit_bio(bio);
 	return 0;
 }
 
@@ -179,6 +181,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 
 	bio = bio_alloc(GFP_NOFS, max_pages);
 	BUG_ON(!bio);
+	bio->bi_rw = WRITE;
 
 	for (i = 0; i < nr_pages; i++) {
 		if (i >= max_pages) {
@@ -190,7 +193,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_private = sb;
 			bio->bi_end_io = erase_end_io;
 			atomic_inc(&super->s_pending_writes);
-			submit_bio(WRITE, bio);
+			submit_bio(bio);
 
 			ofs += i * PAGE_SIZE;
 			index += i;
@@ -211,7 +214,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_private = sb;
 	bio->bi_end_io = erase_end_io;
 	atomic_inc(&super->s_pending_writes);
-	submit_bio(WRITE, bio);
+	submit_bio(bio);
 	return 0;
 }
 
diff --git a/fs/mpage.c b/fs/mpage.c
index 4979ffa..d829d7f 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -73,7 +73,8 @@ static void mpage_end_io(struct bio *bio, int err)
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
 	bio->bi_end_io = mpage_end_io;
-	submit_bio(rw, bio);
+	bio->bi_rw |= rw;
+	submit_bio(bio);
 	return NULL;
 }
 
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 65d849b..2bb3445 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -136,7 +136,8 @@ bl_submit_bio(int rw, struct bio *bio)
 		dprintk("%s submitting %s bio %u@%llu\n", __func__,
 			rw == READ ? "read" : "write", bio->bi_iter.bi_size,
 			(unsigned long long)bio->bi_iter.bi_sector);
-		submit_bio(rw, bio);
+		bio->bi_rw |= rw;
+		submit_bio(bio);
 	}
 	return NULL;
 }
@@ -512,6 +513,7 @@ bl_do_readpage_sync(struct page *page, struct pnfs_block_extent *be,
 	isect = (page->index << PAGE_CACHE_SECTOR_SHIFT) +
 		(offset / SECTOR_SIZE);
 
+	bio->bi_rw = READ;
 	bio->bi_iter.bi_sector = isect - be->be_f_offset + be->be_v_offset;
 	bio->bi_bdev = be->be_mdev;
 	bio->bi_end_io = bl_read_single_end_io;
@@ -524,7 +526,7 @@ bl_do_readpage_sync(struct page *page, struct pnfs_block_extent *be,
 		return -EIO;
 	}
 
-	submit_bio(READ, bio);
+	submit_bio(bio);
 	wait_on_page_locked(shadow_page);
 	if (unlikely(!test_bit(BIO_UPTODATE, &bio->bi_flags))) {
 		ret = -EIO;
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc3a9efd..88f1dd2 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -372,10 +372,11 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 		}
 	}
 
+	bio->bi_rw |= mode;
 	bio->bi_end_io = nilfs_end_bio_write;
 	bio->bi_private = segbuf;
 	bio_get(bio);
-	submit_bio(mode, bio);
+	submit_bio(bio);
 	segbuf->sb_nbio++;
 	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
 		bio_put(bio);
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index bf482df..fb03b29 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -460,7 +460,8 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 		}
 
 		atomic_inc(&wc.wc_num_reqs);
-		submit_bio(READ, bio);
+		bio->bi_rw |= READ;
+		submit_bio(bio);
 	}
 
 	status = 0;
@@ -492,7 +493,8 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
-	submit_bio(WRITE_SYNC, bio);
+	bio->bi_rw |= WRITE_SYNC;
+	submit_bio(bio);
 
 	status = 0;
 bail:
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 0479c32..fe2a615 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -396,7 +396,8 @@ xfs_submit_ioend_bio(
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
-	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
+	bio->bi_rw |= wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE;
+	submit_bio(bio);
 }
 
 STATIC struct bio *
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cb10a0a..f8fe3a5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1250,6 +1250,7 @@ next_chunk:
 		nr_pages = total_nr_pages;
 
 	bio = bio_alloc(GFP_NOIO, nr_pages);
+	bio->bi_rw = rw;
 	bio->bi_bdev = bp->b_target->bt_bdev;
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
@@ -1278,7 +1279,7 @@ next_chunk:
 			flush_kernel_vmap_range(bp->b_addr,
 						xfs_buf_vmap_len(bp));
 		}
-		submit_bio(rw, bio);
+		submit_bio(bio);
 		if (size)
 			goto next_chunk;
 	} else {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index bba5508..f58e2b1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -272,7 +272,7 @@ static inline unsigned bio_segments(struct bio *bio)
  * something like:
  *
  * bio_get(bio);
- * submit_bio(rw, bio);
+ * submit_bio(bio);
  * if (bio->bi_flags ...)
  *	do_something
  * bio_put(bio);
@@ -371,7 +371,7 @@ extern void bio_endio_nodec(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
-extern int submit_bio_wait(int rw, struct bio *bio);
+extern int submit_bio_wait(struct bio *bio);
 extern void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8780312..afc1666 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2392,7 +2392,7 @@ static inline void remove_inode_hash(struct inode *inode)
 extern void inode_sb_list_add(struct inode *inode);
 
 #ifdef CONFIG_BLOCK
-extern void submit_bio(int, struct bio *);
+extern void submit_bio(struct bio *);
 extern int bdev_read_only(struct block_device *);
 #endif
 extern int set_blocksize(struct block_device *, int);
@@ -2460,7 +2460,7 @@ static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 #endif
 
 #ifdef CONFIG_BLOCK
-typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
+typedef void (dio_submit_t)(struct bio *bio, struct inode *inode,
 			    loff_t file_offset);
 
 enum {
diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
index 9a58bc2..26dde1e 100644
--- a/kernel/power/block_io.c
+++ b/kernel/power/block_io.c
@@ -28,10 +28,10 @@
 static int submit(int rw, struct block_device *bdev, sector_t sector,
 		struct page *page, struct bio **bio_chain)
 {
-	const int bio_rw = rw | REQ_SYNC;
 	struct bio *bio;
 
 	bio = bio_alloc(__GFP_WAIT | __GFP_HIGH, 1);
+	bio->bi_rw |= rw | REQ_SYNC;
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = bdev;
 	bio->bi_end_io = end_swap_bio_read;
@@ -47,7 +47,7 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 	bio_get(bio);
 
 	if (bio_chain == NULL) {
-		submit_bio(bio_rw, bio);
+		submit_bio(bio);
 		wait_on_page_locked(page);
 		if (rw == READ)
 			bio_set_pages_dirty(bio);
@@ -57,7 +57,7 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
 			get_page(page);	/* These pages are freed later */
 		bio->bi_private = *bio_chain;
 		*bio_chain = bio;
-		submit_bio(bio_rw, bio);
+		submit_bio(bio);
 	}
 	return 0;
 }
diff --git a/mm/page_io.c b/mm/page_io.c
index 7c59ef6..3e9a3be 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -304,12 +304,13 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		ret = -ENOMEM;
 		goto out;
 	}
+	bio->bi_rw = rw;
 	if (wbc->sync_mode == WB_SYNC_ALL)
-		rw |= REQ_SYNC;
+		bio->bi_rw |= REQ_SYNC;
 	count_vm_event(PSWPOUT);
 	set_page_writeback(page);
 	unlock_page(page);
-	submit_bio(rw, bio);
+	submit_bio(bio);
 out:
 	return ret;
 }
@@ -344,8 +345,9 @@ int swap_readpage(struct page *page)
 		ret = -ENOMEM;
 		goto out;
 	}
+	bio->bi_rw = READ;
 	count_vm_event(PSWPIN);
-	submit_bio(READ, bio);
+	submit_bio(bio);
 out:
 	return ret;
 }
-- 
1.8.4.5

