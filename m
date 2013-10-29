Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3J2USp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:18:45 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46683 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3J2USd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:33 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        "Ed L. Cashin" <ecashin@coraid.com>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 06/23] block: Convert bio_iovec() to bvec_iter
Date: Tue, 29 Oct 2013 13:17:59 -0700
Message-Id: <1383077896-4132-7-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For immutable biovecs, we'll be introducing a new bio_iovec() that uses
our new bvec iterator to construct a biovec, taking into account
bvec_iter->bi_bvec_done - this patch updates existing users for the new
usage.

Some of the existing users really do need a pointer into the bvec array
- those uses are all going to be removed, but we'll need the
functionality from immutable to remove them - so for now rename the
existing bio_iovec() -> __bio_iovec(), and it'll be removed in a couple
patches.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/block/aoe/aoecmd.c |  2 +-
 drivers/md/bcache/io.c     | 13 +++++++------
 drivers/md/dm-verity.c     |  2 +-
 drivers/scsi/sd.c          |  2 +-
 fs/bio.c                   | 20 ++++++++++----------
 include/linux/bio.h        | 10 ++++++----
 6 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 877ba11..77c24ab 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -932,7 +932,7 @@ bufinit(struct buf *buf, struct request *rq, struct bio *bio)
 	buf->resid = bio->bi_iter.bi_size;
 	buf->sector = bio->bi_iter.bi_sector;
 	bio_pageinc(bio);
-	buf->bv = bio_iovec(bio);
+	buf->bv = __bio_iovec(bio);
 	buf->bv_resid = buf->bv->bv_len;
 	WARN_ON(buf->bv_resid == 0);
 }
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index cc4ba2d..dc44f06 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -22,11 +22,12 @@ static void bch_bi_idx_hack_endio(struct bio *bio, int error)
 static void bch_generic_make_request_hack(struct bio *bio)
 {
 	if (bio->bi_iter.bi_idx) {
+		int i;
+		struct bio_vec *bv;
 		struct bio *clone = bio_alloc(GFP_NOIO, bio_segments(bio));
 
-		memcpy(clone->bi_io_vec,
-		       bio_iovec(bio),
-		       bio_segments(bio) * sizeof(struct bio_vec));
+		bio_for_each_segment(bv, bio, i)
+			clone->bi_io_vec[clone->bi_vcnt++] = *bv;
 
 		clone->bi_iter.bi_sector = bio->bi_iter.bi_sector;
 		clone->bi_bdev		= bio->bi_bdev;
@@ -97,7 +98,7 @@ struct bio *bch_bio_split(struct bio *bio, int sectors,
 			if (!ret)
 				return NULL;
 
-			memcpy(ret->bi_io_vec, bio_iovec(bio),
+			memcpy(ret->bi_io_vec, __bio_iovec(bio),
 			       sizeof(struct bio_vec) * vcnt);
 
 			break;
@@ -106,7 +107,7 @@ struct bio *bch_bio_split(struct bio *bio, int sectors,
 			if (!ret)
 				return NULL;
 
-			memcpy(ret->bi_io_vec, bio_iovec(bio),
+			memcpy(ret->bi_io_vec, __bio_iovec(bio),
 			       sizeof(struct bio_vec) * vcnt);
 
 			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
@@ -182,7 +183,7 @@ static unsigned bch_bio_max_sectors(struct bio *bio)
 	ret = min(ret, queue_max_sectors(q));
 
 	WARN_ON(!ret);
-	ret = max_t(int, ret, bio_iovec(bio)->bv_len >> 9);
+	ret = max_t(int, ret, bio_iovec(bio).bv_len >> 9);
 
 	return ret;
 }
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 132b315..5392135 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -524,7 +524,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 		io->io_vec = io->io_vec_inline;
 	else
 		io->io_vec = mempool_alloc(v->vec_mempool, GFP_NOIO);
-	memcpy(io->io_vec, bio_iovec(bio),
+	memcpy(io->io_vec, __bio_iovec(bio),
 	       io->io_vec_size * sizeof(struct bio_vec));
 
 	verity_submit_prefetch(v, io);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e62d17d..b79eb39 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -800,7 +800,7 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 	if (sdkp->device->no_write_same)
 		return BLKPREP_KILL;
 
-	BUG_ON(bio_offset(bio) || bio_iovec(bio)->bv_len != sdp->sector_size);
+	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
 
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
diff --git a/fs/bio.c b/fs/bio.c
index 77ab430..26f1cc5 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -821,12 +821,12 @@ void bio_advance(struct bio *bio, unsigned bytes)
 			break;
 		}
 
-		if (bytes >= bio_iovec(bio)->bv_len) {
-			bytes -= bio_iovec(bio)->bv_len;
+		if (bytes >= bio_iovec(bio).bv_len) {
+			bytes -= bio_iovec(bio).bv_len;
 			bio->bi_iter.bi_idx++;
 		} else {
-			bio_iovec(bio)->bv_len -= bytes;
-			bio_iovec(bio)->bv_offset += bytes;
+			bio_iovec(bio).bv_len -= bytes;
+			bio_iovec(bio).bv_offset += bytes;
 			bytes = 0;
 		}
 	}
@@ -879,8 +879,8 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 	unsigned src_offset, dst_offset, bytes;
 	void *src_p, *dst_p;
 
-	src_bv = bio_iovec(src);
-	dst_bv = bio_iovec(dst);
+	src_bv = __bio_iovec(src);
+	dst_bv = __bio_iovec(dst);
 
 	src_offset = src_bv->bv_offset;
 	dst_offset = dst_bv->bv_offset;
@@ -893,7 +893,7 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 				if (!src)
 					break;
 
-				src_bv = bio_iovec(src);
+				src_bv = __bio_iovec(src);
 			}
 
 			src_offset = src_bv->bv_offset;
@@ -906,7 +906,7 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 				if (!dst)
 					break;
 
-				dst_bv = bio_iovec(dst);
+				dst_bv = __bio_iovec(dst);
 			}
 
 			dst_offset = dst_bv->bv_offset;
@@ -1776,8 +1776,8 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 	bp->bio1.bi_iter.bi_size = first_sectors << 9;
 
 	if (bi->bi_vcnt != 0) {
-		bp->bv1 = *bio_iovec(bi);
-		bp->bv2 = *bio_iovec(bi);
+		bp->bv1 = bio_iovec(bi);
+		bp->bv2 = bio_iovec(bi);
 
 		if (bio_is_rw(bi)) {
 			bp->bv2.bv_offset += first_sectors << 9;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5f440f0..58d5647 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -62,9 +62,11 @@
  * on highmem page vectors
  */
 #define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
-#define bio_iovec(bio)		bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
-#define bio_page(bio)		bio_iovec((bio))->bv_page
-#define bio_offset(bio)		bio_iovec((bio))->bv_offset
+#define __bio_iovec(bio)	bio_iovec_idx((bio), (bio)->bi_iter.bi_idx)
+#define bio_iovec(bio)		(*__bio_iovec(bio))
+
+#define bio_page(bio)		(bio_iovec((bio)).bv_page)
+#define bio_offset(bio)		(bio_iovec((bio)).bv_offset)
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_iter.bi_idx)
 #define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
 #define bio_end_sector(bio)	((bio)->bi_iter.bi_sector + bio_sectors((bio)))
@@ -72,7 +74,7 @@
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
 	if (bio->bi_vcnt)
-		return bio_iovec(bio)->bv_len;
+		return bio_iovec(bio).bv_len;
 	else /* dataless requests such as discard */
 		return bio->bi_iter.bi_size;
 }
-- 
1.8.4.rc3

