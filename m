Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3J2UT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:19:58 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:65427 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3J2USv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:51 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        NeilBrown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Peter Osterlund <petero2@telia.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 20/23] block: Rename bio_split() -> bio_pair_split()
Date: Tue, 29 Oct 2013 13:18:13 -0700
Message-Id: <1383077896-4132-21-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is prep work for introducing a more general bio_split().

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
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
index 147f05e..fa6fa57 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2413,7 +2413,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
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
index 8ee1a6c..ea754dd 100644
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
index 2303f59..7e49cbe 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1193,7 +1193,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
 		 */
-		bp = bio_split(bio, chunk_sects -
+		bp = bio_pair_split(bio, chunk_sects -
 			       (bio->bi_iter.bi_sector & (chunk_sects - 1)));
 
 		/* Each of these 'make_request' calls will call 'wait_barrier'.
diff --git a/fs/bio.c b/fs/bio.c
index 9e7ef5e..663c944 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1792,7 +1792,7 @@ static void bio_pair_end_2(struct bio *bi, int err)
 /*
  * split a bio - only worry about a bio with a single page in its iovec
  */
-struct bio_pair *bio_split(struct bio *bi, int first_sectors)
+struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
 {
 	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
 
@@ -1839,7 +1839,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 
 	return bp;
 }
-EXPORT_SYMBOL(bio_split);
+EXPORT_SYMBOL(bio_pair_split);
 
 /**
  * bio_trim - trim a bio
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 003f65d..228a4e7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -317,7 +317,7 @@ struct bio_pair {
 	atomic_t			cnt;
 	int				error;
 };
-extern struct bio_pair *bio_split(struct bio *bi, int first_sectors);
+extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
 extern void bio_pair_release(struct bio_pair *dbio);
 extern void bio_trim(struct bio *bio, int offset, int size);
 
-- 
1.8.4.rc3

