Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaJVIo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:44:56 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45787 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJVIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:44:53 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: karam.lee@lge.com
From: karam.lee@lge.com
To: minchan@kernel.org, ngupta@vflare.org, linux-kernel@vger.kernel.org
Cc: matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com,
        "karam.lee" <karam.lee@lge.com>
Subject: [PATCH v5 2/3] zram: change parameter from vaild_io_request()
Date: Wed, 22 Oct 2014 17:44:48 +0900
Message-Id: <1413967490-20218-3-git-send-email-karam.lee@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413967490-20218-1-git-send-email-karam.lee@lge.com>
References: <1413967490-20218-1-git-send-email-karam.lee@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "karam.lee" <karam.lee@lge.com>

This patch changes parameter of valid_io_request for common usage.
The purpose of valid_io_request() is to determine if bio request is
valid or not.
This patch use  I/O start address and size instead of a BIO parameter
for common usage.

Signed-off-by: karam.lee <karam.lee@lge.com>
---
 drivers/block/zram/zram_drv.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 54da18a..4565fdc 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -206,19 +206,18 @@ static inline int is_partial_io(struct bio_vec *bvec)
 /*
  * Check if request is within bounds and aligned on zram logical blocks.
  */
-static inline int valid_io_request(struct zram *zram, struct bio *bio)
+static inline int valid_io_request(struct zram *zram,
+		sector_t start, unsigned int size)
 {
-	u64 start, end, bound;
+	u64 end, bound;
 
 	/* unaligned request */
-	if (unlikely(bio->bi_iter.bi_sector &
-		     (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
+	if (unlikely(start & (ZRAM_SECTOR_PER_LOGICAL_BLOCK - 1)))
 		return 0;
-	if (unlikely(bio->bi_iter.bi_size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
+	if (unlikely(size & (ZRAM_LOGICAL_BLOCK_SIZE - 1)))
 		return 0;
 
-	start = bio->bi_iter.bi_sector;
-	end = start + (bio->bi_iter.bi_size >> SECTOR_SHIFT);
+	end = start + (size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
 	/* out of range range */
 	if (unlikely(start >= bound || end > bound || start > end))
@@ -780,7 +779,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 	if (unlikely(!init_done(zram)))
 		goto error;
 
-	if (!valid_io_request(zram, bio)) {
+	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
+					bio->bi_iter.bi_size)) {
 		atomic64_inc(&zram->stats.invalid_io);
 		goto error;
 	}
-- 
1.7.9.5

