Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbbALLw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:52:58 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58996 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbbALLuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:50:44 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 6/9] md/raid5: get rid of bio_fits_rdev()
Date: Mon, 12 Jan 2015 12:49:45 +0100
Message-Id: <5cfac9da1b2724050502c3fa6a00af25bae2e0a7.1421052746.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c98bf7a8cccb8a831566a72f87e8be9511d70e41.1421052746.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
 <4e7cfbce77dcf72474e1b930ef017c9efaea36d7.1421052746.git.dongsu.park@profitbricks.com>
 <ed9c9f3b8190cd64cddbe58a753c811aee69471f.1421052746.git.dongsu.park@profitbricks.com>
 <641ab3a0eeb225316784b8a22a285eab911d48fd.1421052746.git.dongsu.park@profitbricks.com>
 <ca2dd738a2c26bba51acedae96ddb6cb65658268.1421052746.git.dongsu.park@profitbricks.com>
 <c98bf7a8cccb8a831566a72f87e8be9511d70e41.1421052746.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052745.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Remove bio_fits_rdev() completely, because ->merge_bvec_fn() has now
gone. There's no point in calling bio_fits_rdev() only for ensuring
aligned read from rdev.

Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 drivers/md/raid5.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c1b0d52..40e464c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4218,25 +4218,6 @@ static void raid5_align_endio(struct bio *bi, int error)
 	add_bio_to_retry(raid_bi, conf);
 }
 
-static int bio_fits_rdev(struct bio *bi)
-{
-	struct request_queue *q = bdev_get_queue(bi->bi_bdev);
-
-	if (bio_sectors(bi) > queue_max_sectors(q))
-		return 0;
-	blk_recount_segments(q, bi);
-	if (bi->bi_phys_segments > queue_max_segments(q))
-		return 0;
-
-	if (q->merge_bvec_fn)
-		/* it's too hard to apply the merge_bvec_fn at this stage,
-		 * just just give up
-		 */
-		return 0;
-
-	return 1;
-}
-
 static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 {
 	struct r5conf *conf = mddev->private;
@@ -4290,11 +4271,9 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		align_bi->bi_bdev =  rdev->bdev;
 		__clear_bit(BIO_SEG_VALID, &align_bi->bi_flags);
 
-		if (!bio_fits_rdev(align_bi) ||
-		    is_badblock(rdev, align_bi->bi_iter.bi_sector,
+		if (is_badblock(rdev, align_bi->bi_iter.bi_sector,
 				bio_sectors(align_bi),
 				&first_bad, &bad_sectors)) {
-			/* too big in some way, or has a known bad block */
 			bio_put(align_bi);
 			rdev_dec_pending(rdev, mddev);
 			return 0;
-- 
2.1.0

