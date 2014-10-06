Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaJFFbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:31:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:37935 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:31:14 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: karam.lee@lge.com
From: karam.lee@lge.com
To: minchan@kernel.org, ngupta@vflare.org, linux-kernel@vger.kernel.org
Cc: seungho1.park@lge.com, karam.lee@lge.com
Subject: [PATCH] zram: implement rw_page operation of zram block device operation
Date: Mon,  6 Oct 2014 14:31:05 +0900
Message-Id: <1412573465-28286-1-git-send-email-karam.lee@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "karam.lee" <karam.lee@lge.com>

Recently rw_page block device operation is added.
This patch implements rw_page operation for zram block device so
zram can process page sized I/O without bio.
---
---
 drivers/block/zram/zram_drv.c |   60 +++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 48eccb3..b76a5dc 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -368,7 +368,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 }
 
 static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, int offset, struct bio *bio)
+			  u32 index, int offset)
 {
 	int ret;
 	struct page *page;
@@ -535,14 +535,13 @@ out:
 }
 
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, struct bio *bio)
+			int offset, int rw)
 {
 	int ret;
-	int rw = bio_data_dir(bio);
 
 	if (rw == READ) {
 		atomic64_inc(&zram->stats.num_reads);
-		ret = zram_bvec_read(zram, bvec, index, offset, bio);
+		ret = zram_bvec_read(zram, bvec, index, offset);
 	} else {
 		atomic64_inc(&zram->stats.num_writes);
 		ret = zram_bvec_write(zram, bvec, index, offset);
@@ -718,7 +717,7 @@ out:
 
 static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
-	int offset;
+	int offset, rw;
 	u32 index;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
@@ -733,6 +732,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 		return;
 	}
 
+	rw = bio_data_dir(bio);
 	bio_for_each_segment(bvec, bio, iter) {
 		int max_transfer_size = PAGE_SIZE - offset;
 
@@ -747,15 +747,15 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 			bv.bv_len = max_transfer_size;
 			bv.bv_offset = bvec.bv_offset;
 
-			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
+			if (zram_bvec_rw(zram, &bv, index, offset, rw) < 0)
 				goto out;
 
 			bv.bv_len = bvec.bv_len - max_transfer_size;
 			bv.bv_offset += max_transfer_size;
-			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
+			if (zram_bvec_rw(zram, &bv, index + 1, 0, rw) < 0)
 				goto out;
 		} else
-			if (zram_bvec_rw(zram, &bvec, index, offset, bio) < 0)
+			if (zram_bvec_rw(zram, &bvec, index, offset, rw) < 0)
 				goto out;
 
 		update_position(&index, &offset, &bvec);
@@ -810,8 +810,52 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	atomic64_inc(&zram->stats.notify_free);
 }
 
+static int zram_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	int offset, ret = 1;
+	u32 index;
+	u64 start, end, bound;
+	struct zram *zram;
+	struct bio_vec bv;
+
+	zram = bdev->bd_disk->private_data;
+
+	if (unlikely(sector&
+			(ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
+		goto out;
+
+	start = sector;
+	end = start + (PAGE_SIZE >> SECTOR_SHIFT);
+	bound = zram->disksize >> SECTOR_SHIFT;
+	if (unlikely(start >= bound || end > bound || start > end))
+		goto out;
+
+	down_read(&zram->init_lock);
+	if (unlikely(!init_done(zram))) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	index = sector >> SECTORS_PER_PAGE_SHIFT;
+	offset = sector & (SECTORS_PER_PAGE - 1) << SECTOR_SHIFT;
+
+	bv.bv_page = page;
+	bv.bv_len = PAGE_SIZE;
+	bv.bv_offset = 0;
+
+	ret = zram_bvec_rw(zram, &bv, index, offset, rw);
+	page_endio(page, rw, ret);
+
+out_unlock:
+	up_read(&zram->init_lock);
+out:
+	return ret;
+}
+
 static const struct block_device_operations zram_devops = {
 	.swap_slot_free_notify = zram_slot_free_notify,
+	.rw_page = zram_rw_page,
 	.owner = THIS_MODULE
 };
 
-- 
1.7.9.5

