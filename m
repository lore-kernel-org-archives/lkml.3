Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaBTNuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:50:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbaBTNtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:49:15 -0500
From: Hannes Reinecke <hare@suse.de>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] loop: Add module parameter 'lbs' to set logical blocksize
Date: Thu, 20 Feb 2014 14:48:51 +0100
Message-Id: <1392904131-71320-3-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1392904131-71320-1-git-send-email-hare@suse.de>
References: <1392904131-71320-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop device already knows about the physical blocksize
(= blocksize of the underlying file). This patch adds a
module option 'lbs' to specify the blocksize directly
or '0' for using the blocksize from the underlying file.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/loop.c | 55 +++++++++++++++++++++++++++++++++++++++-------------
 drivers/block/loop.h |  1 +
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6965e5a..6019373 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -84,6 +84,7 @@ static DEFINE_MUTEX(loop_index_mutex);
 
 static int max_part;
 static int part_shift;
+static int lbs = 512;
 
 /*
  * Transfer functions
@@ -160,9 +161,14 @@ static struct loop_func_table *xfer_funcs[MAX_LO_CRYPT] = {
 	&xor_funcs
 };
 
-static loff_t get_size(loff_t offset, loff_t sizelimit, struct file *file)
+/*
+ * Returns the number of sectors
+ */
+static loff_t get_size(loff_t offset, loff_t sizelimit, int blocksize,
+		       struct file *file)
 {
 	loff_t loopsize;
+	int lo_bits = blksize_bits(blocksize);
 
 	/* Compute loopsize in bytes */
 	loopsize = i_size_read(file->f_mapping->host);
@@ -176,20 +182,22 @@ static loff_t get_size(loff_t offset, loff_t sizelimit, struct file *file)
 		loopsize = sizelimit;
 	/*
 	 * Unfortunately, if we want to do I/O on the device,
-	 * the number of 512-byte sectors has to fit into a sector_t.
+	 * the number of sectors has to fit into a sector_t.
 	 */
-	return loopsize >> 9;
+	return loopsize >> lo_bits;
 }
 
 static loff_t get_loop_size(struct loop_device *lo, struct file *file)
 {
-	return get_size(lo->lo_offset, lo->lo_sizelimit, file);
+	return get_size(lo->lo_offset, lo->lo_sizelimit,
+			lo->lo_logical_blocksize, file);
 }
 
 static int
 figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 {
-	loff_t size = get_size(offset, sizelimit, lo->lo_backing_file);
+	loff_t size = get_size(offset, sizelimit, lo->lo_logical_blocksize,
+			       lo->lo_backing_file);
 	sector_t x = (sector_t)size;
 	struct block_device *bdev = lo->lo_device;
 
@@ -200,8 +208,9 @@ figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 	if (lo->lo_sizelimit != sizelimit)
 		lo->lo_sizelimit = sizelimit;
 	blk_queue_physical_block_size(lo->lo_queue, lo->lo_blocksize);
+	blk_queue_logical_block_size(lo->lo_queue, lo->lo_logical_blocksize);
 	set_capacity(lo->lo_disk, x);
-	bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
+	bd_set_size(bdev, size << blksize_bits(lo->lo_logical_blocksize));
 	/* let user-space know about the new size */
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	return 0;
@@ -272,8 +281,9 @@ static int do_lo_send_direct_write(struct loop_device *lo,
 static int do_lo_send_write(struct loop_device *lo, struct bio_vec *bvec,
 		loff_t pos, struct page *page)
 {
+	sector_t sec = (pos >> blksize_bits(lo->lo_logical_blocksize));
 	int ret = lo_do_transfer(lo, WRITE, page, 0, bvec->bv_page,
-			bvec->bv_offset, bvec->bv_len, pos >> 9);
+			bvec->bv_offset, bvec->bv_len, sec);
 	if (likely(!ret))
 		return __do_lo_send_write(lo->lo_backing_file,
 				page_address(page), bvec->bv_len,
@@ -337,10 +347,11 @@ lo_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct loop_device *lo = p->lo;
 	struct page *page = buf->page;
 	sector_t IV;
+	int lo_bits = blksize_bits(lo->lo_logical_blocksize);
 	int size;
 
-	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - 9)) +
-							(buf->offset >> 9);
+	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - lo_bits)) +
+		(buf->offset >> lo_bits);
 	size = sd->len;
 	if (size > p->bsize)
 		size = p->bsize;
@@ -377,7 +388,7 @@ do_lo_receive(struct loop_device *lo,
 	cookie.lo = lo;
 	cookie.page = bvec->bv_page;
 	cookie.offset = bvec->bv_offset;
-	cookie.bsize = lo->lo_blocksize;
+	cookie.bsize = lo->lo_logical_blocksize;
 
 	sd.len = 0;
 	sd.total_len = bvec->bv_len;
@@ -415,9 +426,10 @@ lo_receive(struct loop_device *lo, struct bio *bio, loff_t pos)
 static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 {
 	loff_t pos;
+	int lo_bits = blksize_bits(lo->lo_logical_blocksize);
 	int ret;
 
-	pos = ((loff_t) bio->bi_iter.bi_sector << 9) + lo->lo_offset;
+	pos = ((loff_t) bio->bi_iter.bi_sector << lo_bits) + lo->lo_offset;
 
 	if (bio_rw(bio) == WRITE) {
 		struct file *file = lo->lo_backing_file;
@@ -797,6 +809,7 @@ static void loop_config_discard(struct loop_device *lo)
 	struct file *file = lo->lo_backing_file;
 	struct inode *inode = file->f_mapping->host;
 	struct request_queue *q = lo->lo_queue;
+	int lo_bits = blksize_bits(lo->lo_logical_blocksize);
 
 	/*
 	 * We use punch hole to reclaim the free space used by the
@@ -816,7 +829,7 @@ static void loop_config_discard(struct loop_device *lo)
 
 	q->limits.discard_granularity = inode->i_sb->s_blocksize;
 	q->limits.discard_alignment = 0;
-	q->limits.max_discard_sectors = UINT_MAX >> 9;
+	q->limits.max_discard_sectors = UINT_MAX >> lo_bits;
 	q->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
@@ -884,6 +897,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	set_device_ro(bdev, (lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
 	lo->lo_blocksize = lo_blocksize;
+	lo->lo_logical_blocksize = lbs ? lbs : lo_blocksize;
 	lo->lo_device = bdev;
 	lo->lo_flags = lo_flags;
 	lo->lo_backing_file = file;
@@ -900,8 +914,9 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
 
 	blk_queue_physical_block_size(lo->lo_queue, lo->lo_blocksize);
+	blk_queue_logical_block_size(lo->lo_queue, lo->lo_logical_blocksize);
 	set_capacity(lo->lo_disk, size);
-	bd_set_size(bdev, size << 9);
+	bd_set_size(bdev, size << blksize_bits(lo->lo_logical_blocksize));
 	loop_sysfs_init(lo);
 	/* let user-space know about the new size */
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
@@ -1562,6 +1577,8 @@ module_param(max_loop, int, S_IRUGO);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 module_param(max_part, int, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
+module_param(lbs, int, S_IRUGO);
+MODULE_PARM_DESC(lbs, "logical blocksize (0: native, default: 512)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1856,6 +1873,18 @@ static int __init loop_init(void)
 		goto misc_out;
 	}
 
+	switch (lbs) {
+	case 512:
+	case 1024:
+	case 2048:
+	case 4096:
+	case 0:
+		break;
+	default:
+		err = -EINVAL;
+		goto misc_out;
+	}
+
 	/*
 	 * If max_loop is specified, create that many devices upfront.
 	 * This also becomes a hard limit. If max_loop is not specified,
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 90df5d6..fefe3dc 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -47,6 +47,7 @@ struct loop_device {
 	struct file *	lo_backing_file;
 	struct block_device *lo_device;
 	unsigned	lo_blocksize;
+	unsigned	lo_logical_blocksize;
 	void		*key_data; 
 
 	gfp_t		old_gfp_mask;
-- 
1.7.12.4

