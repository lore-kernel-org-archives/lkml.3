Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaBXFvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:51:05 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64092 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBXFvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:51:03 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-20-530addc563d7
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] zram: support REQ_DISCARD
Date: Mon, 24 Feb 2014 14:51:10 +0900
Message-Id: <1393221070-21674-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram is ram based block device and can be used by backend of filesystem.
When filesystem deletes a file, it normally doesn't do anything on data
block of that file. It just marks on metadata of that file. This behavior
has no problem on disk based block device, but has problems on ram based
block device, since we can't free memory used for data block. To overcome
this disadvantage, there is REQ_DISCARD functionality. If block device
support REQ_DISCARD and filesystem is mounted with discard option,
filesystem sends REQ_DISCARD to block device whenever some data blocks are
discarded. All we have to do is to handle this request.

This patch implements to flag up QUEUE_FLAG_DISCARD and handle this
REQ_DISCARD request. With it, we can free memory used by zram if it isn't
used.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
This patch is based on master branch of linux-next tree.

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 5ec61be..cff2c0e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -501,6 +501,20 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 	return ret;
 }
 
+static void zram_bio_discard(struct zram *zram, struct bio *bio)
+{
+	u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
+	size_t n = bio->bi_iter.bi_size;
+
+	while (n >= PAGE_SIZE) {
+		write_lock(&zram->meta->tb_lock);
+		zram_free_page(zram, index);
+		write_unlock(&zram->meta->tb_lock);
+		index++;
+		n -= PAGE_SIZE;
+	}
+}
+
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
 	size_t index;
@@ -618,6 +632,12 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
+	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+		zram_bio_discard(zram, bio);
+		bio_endio(bio, 0);
+		return;
+	}
+
 	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
 	offset = (bio->bi_iter.bi_sector &
 		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
@@ -784,6 +804,10 @@ static int create_device(struct zram *zram, int device_id)
 					ZRAM_LOGICAL_BLOCK_SIZE);
 	blk_queue_io_min(zram->disk->queue, PAGE_SIZE);
 	blk_queue_io_opt(zram->disk->queue, PAGE_SIZE);
+	zram->disk->queue->limits.discard_granularity = PAGE_SIZE;
+	zram->disk->queue->limits.max_discard_sectors = UINT_MAX;
+	zram->disk->queue->limits.discard_zeroes_data = 1;
+	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
 
 	add_disk(zram->disk);
 
-- 
1.7.9.5

