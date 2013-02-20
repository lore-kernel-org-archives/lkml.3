Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049Ab3BTAXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:23:21 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:32859 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934962Ab3BTAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:23:04 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 14/27] raid10: Use bio_reset()
Date: Tue, 19 Feb 2013 16:22:28 -0800
Message-Id: <1361319761-23873-15-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More prep work for immutable bio vecs, mainly getting rid of references
to bi_idx.

bio_reset was being open coded in a few places. The one in sync_request
was a bit nontrivial to convert, so could use some extra eyeballs.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
Acked-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid10.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3cbd3ac..8b5c3f2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2027,13 +2027,10 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		 * First we need to fixup bv_offset, bv_len and
 		 * bi_vecs, as the read request might have corrupted these
 		 */
+		bio_reset(tbio);
+
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_size = r10_bio->sectors << 9;
-		tbio->bi_idx = 0;
-		tbio->bi_phys_segments = 0;
-		tbio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		tbio->bi_flags |= 1 << BIO_UPTODATE;
-		tbio->bi_next = NULL;
 		tbio->bi_rw = WRITE;
 		tbio->bi_private = r10_bio;
 		tbio->bi_sector = r10_bio->devs[i].addr;
@@ -3040,6 +3037,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 					}
 				}
 				bio = r10_bio->devs[0].bio;
+				bio_reset(bio);
 				bio->bi_next = biolist;
 				biolist = bio;
 				bio->bi_private = r10_bio;
@@ -3064,6 +3062,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				rdev = mirror->rdev;
 				if (!test_bit(In_sync, &rdev->flags)) {
 					bio = r10_bio->devs[1].bio;
+					bio_reset(bio);
 					bio->bi_next = biolist;
 					biolist = bio;
 					bio->bi_private = r10_bio;
@@ -3092,6 +3091,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				if (rdev == NULL || bio == NULL ||
 				    test_bit(Faulty, &rdev->flags))
 					break;
+				bio_reset(bio);
 				bio->bi_next = biolist;
 				biolist = bio;
 				bio->bi_private = r10_bio;
@@ -3190,7 +3190,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				r10_bio->devs[i].repl_bio->bi_end_io = NULL;
 
 			bio = r10_bio->devs[i].bio;
-			bio->bi_end_io = NULL;
+			bio_reset(bio);
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
@@ -3227,6 +3227,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 
 			/* Need to set up for writing to the replacement */
 			bio = r10_bio->devs[i].repl_bio;
+			bio_reset(bio);
 			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 
 			sector = r10_bio->devs[i].addr;
@@ -3260,17 +3261,6 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		}
 	}
 
-	for (bio = biolist; bio ; bio=bio->bi_next) {
-
-		bio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		if (bio->bi_end_io)
-			bio->bi_flags |= 1 << BIO_UPTODATE;
-		bio->bi_vcnt = 0;
-		bio->bi_idx = 0;
-		bio->bi_phys_segments = 0;
-		bio->bi_size = 0;
-	}
-
 	nr_sectors = 0;
 	if (sector_nr + max_sync < max_sector)
 		max_sector = sector_nr + max_sync;
@@ -4337,17 +4327,14 @@ read_more:
 		}
 		if (!rdev2 || test_bit(Faulty, &rdev2->flags))
 			continue;
+
+		bio_reset(b);
 		b->bi_bdev = rdev2->bdev;
 		b->bi_sector = r10_bio->devs[s/2].addr + rdev2->new_data_offset;
 		b->bi_private = r10_bio;
 		b->bi_end_io = end_reshape_write;
 		b->bi_rw = WRITE;
-		b->bi_flags &= ~(BIO_POOL_MASK - 1);
-		b->bi_flags |= 1 << BIO_UPTODATE;
 		b->bi_next = blist;
-		b->bi_vcnt = 0;
-		b->bi_idx = 0;
-		b->bi_size = 0;
 		blist = b;
 	}
 
-- 
1.7.12

