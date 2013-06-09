Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3FICX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:23:27 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37486 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3FICUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:20:01 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, NeilBrown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Peter Osterlund <petero2@telia.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 16/26] block: Rename bio_split() -> bio_pair_split()
Date: Sat,  8 Jun 2013 19:18:58 -0700
Message-Id: <1370744348-15407-17-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is prep work for introducing a more general bio_split().

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Peter Osterlund <petero2@telia.com>
Cc: Sage Weil <sage@inktank.com>
---
 drivers/block/pktcdvd.c | 2 +-
 drivers/md/linear.c     | 2 +-
 drivers/md/raid0.c      | 6 +++---
 drivers/md/raid10.c     | 2 +-
 fs/bio.c                | 4 ++--
 include/linux/bio.h     | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 68a6d2a..6c1029c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2412,7 +2412,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
 			first_sectors = last_zone - bio->bi_iter.bi_sector;
-			bp = bio_split(bio, first_sectors);
+			bp = bio_pair_split(bio, first_sectors);
 			BUG_ON(!bp);
 			pkt_make_request(q, &bp->bio1);
 			pkt_make_request(q, &bp->bio2);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index fb3b0d0..e9b53e9 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -326,7 +326,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 
 		rcu_read_unlock();
 
-		bp = bio_split(bio, end_sector - bio->bi_iter.bi_sector);
+		bp = bio_pair_split(bio, end_sector - bio->bi_iter.bi_sector);
 
 		linear_make_request(mddev, &bp->bio1);
 		linear_make_request(mddev, &bp->bio2);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8c2ec0..5edc3f7 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -534,11 +534,11 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 		 * refuse to split for us, so we need to split it.
 		 */
 		if (likely(is_power_of_2(chunk_sects)))
-			bp = bio_split(bio, chunk_sects - (sector &
+			bp = bio_pair_split(bio, chunk_sects - (sector &
 							   (chunk_sects-1)));
 		else
-			bp = bio_split(bio, chunk_sects -
-				       sector_div(sector, chunk_sects));
+			bp = bio_pair_split(bio, chunk_sects -
+					    sector_div(sector, chunk_sects));
 		raid0_make_request(mddev, &bp->bio1);
 		raid0_make_request(mddev, &bp->bio2);
 		bio_pair_release(bp);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5899d87..7b68d82 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1185,7 +1185,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, chunk_sects -
+		bp = bio_pair_split(bio, chunk_sects -
 			       (bio->bi_iter.bi_sector & (chunk_sects - 1)));
 
 		/* Each of these 'make_request' calls will call 'wait_barrier'.
diff --git a/fs/bio.c b/fs/bio.c
index bd25401..3968b8f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1746,7 +1746,7 @@ static void bio_pair_end_2(struct bio *bi, int err)
 /*
  * split a bio - only worry about a bio with a single page in its iovec
  */
-struct bio_pair *bio_split(struct bio *bi, int first_sectors)
+struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
 {
 	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
 
@@ -1793,7 +1793,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 
 	return bp;
 }
-EXPORT_SYMBOL(bio_split);
+EXPORT_SYMBOL(bio_pair_split);
 
 /*
  * create memory pools for biovec's in a bio_set.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 55d2ce8..dd70f7e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -281,7 +281,7 @@ struct bio_pair {
 	atomic_t			cnt;
 	int				error;
 };
-extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
+extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
-- 
1.8.3.rc1

