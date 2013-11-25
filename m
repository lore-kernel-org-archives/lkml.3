Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3KYWaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:30:52 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60036 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3KYWam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:30:42 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk
Cc: Kent Overstreet <kmo@daterainc.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 2/5] mtip32xx: handle arbitrary size bios
Date: Mon, 25 Nov 2013 14:30:30 -0800
Message-Id: <1385418633-9753-3-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
References: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get a measurable performance increase by handling this in the driver when
we're already looping over the biovec, instead of handling it separately in
generic_make_request() (or bio_add_page() originally)

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 47 ++++++++++++---------------------------
 1 file changed, 14 insertions(+), 33 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 1b3dfee..2b142eb 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2648,24 +2648,6 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
 }
 
 /*
- * Release a command slot.
- *
- * @dd  Pointer to the driver data structure.
- * @tag Slot tag
- *
- * return value
- *      None
- */
-static void mtip_hw_release_scatterlist(struct driver_data *dd, int tag,
-								int unaligned)
-{
-	struct semaphore *sem = unaligned ? &dd->port->cmd_slot_unal :
-							&dd->port->cmd_slot;
-	release_slot(dd->port, tag);
-	up(sem);
-}
-
-/*
  * Obtain a command slot and return its associated scatter list.
  *
  * @dd  Pointer to the driver data structure.
@@ -3969,8 +3951,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 	blk_queue_bounce(queue, &bio);
 
-	blk_queue_split(queue, &bio, q->bio_split);
-
 	if (unlikely(dd->dd_flag & MTIP_DDF_STOP_IO)) {
 		if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 							&dd->dd_flag))) {
@@ -4020,21 +4000,22 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
 	if (likely(sg != NULL)) {
-		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
-			dev_warn(&dd->pdev->dev,
-				"Maximum number of SGL entries exceeded\n");
-			bio_io_error(bio);
-			mtip_hw_release_scatterlist(dd, tag, unaligned);
-			return;
-		}
-
 		/* Create the scatter list for this bio. */
 		bio_for_each_segment(bvec, bio, iter) {
-			sg_set_page(&sg[nents],
-					bvec.bv_page,
-					bvec.bv_len,
-					bvec.bv_offset);
-			nents++;
+			if (unlikely(nents == MTIP_MAX_SG)) {
+				struct bio *split = bio_clone(bio, GFP_NOIO);
+
+				split->bi_iter = iter;
+				bio->bi_iter.bi_size -= iter.bi_size;
+				bio_chain(split, bio);
+				generic_make_request(split);
+				break;
+			}
+
+			sg_set_page(&sg[nents++],
+				    bvec.bv_page,
+				    bvec.bv_len,
+				    bvec.bv_offset);
 		}
 
 		/* Issue the read/write. */
-- 
1.8.4.3

