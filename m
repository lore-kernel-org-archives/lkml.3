Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaAOKTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:19:53 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36614 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaAOKTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:19:48 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv2 2/4] zram: do not pass rw argument to __zram_make_request()
Date: Wed, 15 Jan 2014 13:16:15 +0300
Message-Id: <1389780977-18949-3-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389780977-18949-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389780977-18949-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not pass rw argument down the __zram_make_request() -> zram_bvec_rw()
chain, decode it in zram_bvec_rw() instead. Besides, this is the place
where we distinguish READ and WRITE bio data directions, so account zram
RW stats here, instead of __zram_make_request(). This also allows to account
a real number of zram READ/WRITE operations, not just requests (single RW
request may cause a number of zram RW ops with separate locking,
compression/decompression, etc).

v2: do not check for READA return code. noted by Jerome Marchand.

Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c323e05..b0bcb7e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -533,14 +533,18 @@ out:
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, struct bio *bio, int rw)
+			int offset, struct bio *bio)
 {
 	int ret;
+	int rw = bio_data_dir(bio);
 
-	if (rw == READ)
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
@@ -670,22 +674,13 @@ out:
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
@@ -704,16 +699,15 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
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
@@ -743,7 +737,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 		goto error;
 	}
 
-	__zram_make_request(zram, bio, bio_data_dir(bio));
+	__zram_make_request(zram, bio);
 	up_read(&zram->init_lock);
 
 	return;
-- 
1.8.5.3.493.gb139ac2

