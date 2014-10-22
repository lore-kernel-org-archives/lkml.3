Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaJVHEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:04:36 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:47290 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaJVHEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:04:33 -0400
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: karam.lee@lge.com
From: karam.lee@lge.com
To: minchan@kernel.org, ngupta@vflare.org, linux-kernel@vger.kernel.org
Cc: matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com,
        "karam.lee" <karam.lee@lge.com>
Subject: [PATCH v4 1/3] zram: remove bio parameter from zram_bvec_rw().
Date: Wed, 22 Oct 2014 16:04:12 +0900
Message-Id: <1413961454-13479-2-git-send-email-karam.lee@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413961454-13479-1-git-send-email-karam.lee@lge.com>
References: <1413961454-13479-1-git-send-email-karam.lee@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "karam.lee" <karam.lee@lge.com>

This patch removes an unnecessary parameter(bio)
from zram_bvec_rw() and zram_bvec_read().
zram_bvec_read() doesn't use a bio parameter, so remove it.
zram_bvec_rw() calls a read/write operation not using bio, so a rw parameter
replaces a bio parameter.

Signed-off-by: karam.lee <karam.lee@lge.com>
---
 drivers/block/zram/zram_drv.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 48eccb3..54da18a 100644
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
-- 
1.7.9.5

