Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaLVLuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:50:37 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44036 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaLVLuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:32 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Subject: [RFC PATCH 13/17] md/raid5: get rid of bio_fits_rdev()
Date: Mon, 22 Dec 2014 12:48:40 +0100
Message-Id: <e35d37b66d621c51f2eb24ff024291bd1d53422e.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
 <d42dae3d2a64fa4c3a0893f1af963151b31869e3.1419241597.git.dongsu.park@profitbricks.com>
 <4334b90a56b96ad7a11e4ba7eb97c2cf4405950d.1419241597.git.dongsu.park@profitbricks.com>
 <abe647cf7cf272220227fad4dac9c43641192f01.1419241597.git.dongsu.park@profitbricks.com>
 <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Remove bio_fits_rdev() completely, because ->merge_bvec_fn() has now
gone. There's no point in calling bio_fits_rdev() only for ensuring
aligned read from rdev.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
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

