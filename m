Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaBTNtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:49:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbaBTNtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:49:15 -0500
From: Hannes Reinecke <hare@suse.de>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] loop: Display correct physical blocksize
Date: Thu, 20 Feb 2014 14:48:50 +0100
Message-Id: <1392904131-71320-2-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1392904131-71320-1-git-send-email-hare@suse.de>
References: <1392904131-71320-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running on files the physical blocksize is actually 4k,
so we should be announcing it as such.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/loop.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 66e8c3b..6965e5a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -199,6 +199,7 @@ figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 		lo->lo_offset = offset;
 	if (lo->lo_sizelimit != sizelimit)
 		lo->lo_sizelimit = sizelimit;
+	blk_queue_physical_block_size(lo->lo_queue, lo->lo_blocksize);
 	set_capacity(lo->lo_disk, x);
 	bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
 	/* let user-space know about the new size */
@@ -366,7 +367,7 @@ lo_direct_splice_actor(struct pipe_inode_info *pipe, struct splice_desc *sd)
 
 static ssize_t
 do_lo_receive(struct loop_device *lo,
-	      struct bio_vec *bvec, int bsize, loff_t pos)
+	      struct bio_vec *bvec, loff_t pos)
 {
 	struct lo_read_data cookie;
 	struct splice_desc sd;
@@ -376,7 +377,7 @@ do_lo_receive(struct loop_device *lo,
 	cookie.lo = lo;
 	cookie.page = bvec->bv_page;
 	cookie.offset = bvec->bv_offset;
-	cookie.bsize = bsize;
+	cookie.bsize = lo->lo_blocksize;
 
 	sd.len = 0;
 	sd.total_len = bvec->bv_len;
@@ -391,14 +392,14 @@ do_lo_receive(struct loop_device *lo,
 }
 
 static int
-lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
+lo_receive(struct loop_device *lo, struct bio *bio, loff_t pos)
 {
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	ssize_t s;
 
 	bio_for_each_segment(bvec, bio, iter) {
-		s = do_lo_receive(lo, &bvec, bsize, pos);
+		s = do_lo_receive(lo, &bvec, pos);
 		if (s < 0)
 			return s;
 
@@ -460,7 +461,7 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 				ret = -EIO;
 		}
 	} else
-		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
+		ret = lo_receive(lo, bio, pos);
 
 out:
 	return ret;
@@ -898,6 +899,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
 
+	blk_queue_physical_block_size(lo->lo_queue, lo->lo_blocksize);
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
 	loop_sysfs_init(lo);
-- 
1.7.12.4

