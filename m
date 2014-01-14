Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaANLaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:30:21 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59635 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANLaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:30:15 -0500
Date: Tue, 14 Jan 2014 14:27:23 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] zram: do not pass rw argument to
 __zram_make_request()
Message-ID: <20140114112723.GA2226@swordfish.minsk.epam.com>
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389692260-4421-3-git-send-email-sergey.senozhatsky@gmail.com>
 <52D5195A.3040001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D5195A.3040001@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not pass rw argument down the __zram_make_request() -> zram_bvec_rw()
chain, decode it in zram_bvec_rw() instead. Besides, this is the place
where we distinguish READ (+READ AHEAD) and WRITE bio data directions, so
account zram RW stats here, instead of __zram_make_request(). This also
allows to account a real number of zram READ/WRITE operations, not just
requests (single RW request may cause a number of zram RW ops with separate
locking, compression/decompression, etc).

v2: use bio_rw() instead of bio_data_dir(). noted by Jerome Marchand.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c323e05..2a7682c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -533,14 +533,21 @@ out:
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, struct bio *bio, int rw)
+			int offset, struct bio *bio)
 {
 	int ret;
+	int rw = bio_rw(bio);
 
-	if (rw == READ)
+	if (rw == READA)
+		rw = READ;
+
+	if (rw == READ) {
+		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
-	else
+	} else {
+		atomic64_inc(&zram->stats.num_writes);
 		ret = zram_bvec_write(zram, bvec, index, offset);
+	}
 
 	return ret;
 }
@@ -670,22 +677,13 @@ out:
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
@@ -704,16 +702,15 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
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
@@ -743,7 +740,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 		goto error;
 	}
 
-	__zram_make_request(zram, bio, bio_data_dir(bio));
+	__zram_make_request(zram, bio);
 	up_read(&zram->init_lock);
 
 	return;

