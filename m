Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaAIN0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:26:45 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:63122 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaAIN0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:26:36 -0500
Date: Thu, 9 Jan 2014 16:23:43 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] zram: do not pass rw argument to __zram_make_request()
Message-ID: <20140109132343.GB2246@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not pass rw argument down the __zram_make_request() -> zram_bvec_rw()
chain, decode it in zram_bvec_rw() instead. Besides, this is the place
where we distinguish READ and WRITE bio data directions, so account zram
RW stats here, instead of __zram_make_request(). This also allows to
account a real number of zram READ/WRITE operations, not just requests
(RW request may end up in a number of zram RW ops with separate
locking, compression/decompression, slot free handling, etc).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/block/zram/zram_drv.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 833d24f..798793f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -534,22 +534,27 @@ static void handle_pending_slot_free(struct zram *zram)
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, struct bio *bio, int rw)
+			int offset, struct bio *bio)
 {
 	int ret;
+	int rw = bio_data_dir(bio);
+
+	if (rw == READA)
+		rw = READ;
 
 	if (rw == READ) {
+		atomic64_inc(&zram->stats.num_reads);
 		down_read(&zram->lock);
 		handle_pending_slot_free(zram);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		up_read(&zram->lock);
 	} else {
+		atomic64_inc(&zram->stats.num_writes);
 		down_write(&zram->lock);
 		handle_pending_slot_free(zram);
 		ret = zram_bvec_write(zram, bvec, index, offset);
 		up_write(&zram->lock);
 	}
-
 	return ret;
 }
 
@@ -680,22 +685,13 @@ out:
 	return ret;
 }
 
-static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
+static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
 	int offset;
 	u32 index;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
-	switch (rw) {
-	case READ:
-		atomic64_inc(&zram->stats.num_reads);
-		break;
-	case WRITE:
-		atomic64_inc(&zram->stats.num_writes);
-		break;
-	}
-
 	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
 	offset = (bio->bi_iter.bi_sector &
 		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
@@ -714,16 +710,15 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
 			bv.bv_len = max_transfer_size;
 			bv.bv_offset = bvec.bv_offset;
 
-			if (zram_bvec_rw(zram, &bv, index, offset, bio, rw) < 0)
+			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
 				goto out;
 
 			bv.bv_len = bvec.bv_len - max_transfer_size;
 			bv.bv_offset += max_transfer_size;
-			if (zram_bvec_rw(zram, &bv, index+1, 0, bio, rw) < 0)
+			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
 				goto out;
 		} else
-			if (zram_bvec_rw(zram, &bvec, index, offset, bio, rw)
-			    < 0)
+			if (zram_bvec_rw(zram, &bvec, index, offset, bio) < 0)
 				goto out;
 
 		update_position(&index, &offset, &bvec);
@@ -753,7 +748,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 		goto error;
 	}
 
-	__zram_make_request(zram, bio, bio_data_dir(bio));
+	__zram_make_request(zram, bio);
 	up_read(&zram->init_lock);
 
 	return;
