Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263Ab3B1Ufx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:35:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44374 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760241Ab3B1Ufr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:35:47 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: Kent Overstreet <koverstreet@google.com>, tytso@mit.edu, axboe@kernel.dk,
        zab@redhat.com, bcrl@kvack.org, anatol@google.com
Subject: [PATCH 3/4] direct-io: Set dio->io_error directly
Date: Thu, 28 Feb 2013 12:35:40 -0800
Message-Id: <1362083741-2429-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1362083741-2429-1-git-send-email-koverstreet@google.com>
References: <1362083741-2429-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way io errors are returned in the dio code was rather convoluted,
and also meant that the specific error code was lost. We need to return
the actual error so that for cancellation we can pass up -ECANCELED.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/direct-io.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index ef234ee..b054615 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -270,7 +270,7 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 	return ret;
 }
 
-static int dio_bio_complete(struct dio *dio, struct bio *bio);
+static void dio_bio_complete(struct dio *dio, struct bio *bio);
 /*
  * Asynchronous IO callback. 
  */
@@ -328,6 +328,9 @@ void dio_end_io(struct bio *bio, int error)
 {
 	struct dio *dio = bio->bi_private;
 
+	if (error)
+		dio->io_error = error;
+
 	if (dio->is_async)
 		dio_bio_end_aio(bio, error, NULL);
 	else
@@ -440,15 +443,11 @@ static struct bio *dio_await_one(struct dio *dio)
 /*
  * Process one completed BIO.  No locks are held.
  */
-static int dio_bio_complete(struct dio *dio, struct bio *bio)
+static void dio_bio_complete(struct dio *dio, struct bio *bio)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int page_no;
 
-	if (!uptodate)
-		dio->io_error = -EIO;
-
 	if (dio->is_async && dio->rw == READ) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
@@ -461,7 +460,6 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 		}
 		bio_put(bio);
 	}
-	return uptodate ? 0 : -EIO;
 }
 
 /*
@@ -488,27 +486,21 @@ static void dio_await_completion(struct dio *dio)
  *
  * This also helps to limit the peak amount of pinned userspace memory.
  */
-static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
+static inline void dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
 {
-	int ret = 0;
-
 	if (sdio->reap_counter++ >= 64) {
 		while (dio->bio_list) {
 			unsigned long flags;
 			struct bio *bio;
-			int ret2;
 
 			spin_lock_irqsave(&dio->bio_lock, flags);
 			bio = dio->bio_list;
 			dio->bio_list = bio->bi_private;
 			spin_unlock_irqrestore(&dio->bio_lock, flags);
-			ret2 = dio_bio_complete(dio, bio);
-			if (ret == 0)
-				ret = ret2;
+			dio_bio_complete(dio, bio);
 		}
 		sdio->reap_counter = 0;
 	}
-	return ret;
 }
 
 /*
@@ -593,19 +585,20 @@ static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
 		sector_t start_sector, struct buffer_head *map_bh)
 {
 	sector_t sector;
-	int ret, nr_pages;
+	int nr_pages;
+
+	dio_bio_reap(dio, sdio);
+
+	if (dio->io_error)
+		return dio->io_error;
 
-	ret = dio_bio_reap(dio, sdio);
-	if (ret)
-		goto out;
 	sector = start_sector << (sdio->blkbits - 9);
 	nr_pages = min(sdio->pages_in_io, bio_get_nr_vecs(map_bh->b_bdev));
 	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
 	dio_bio_alloc(dio, sdio, map_bh->b_bdev, sector, nr_pages);
 	sdio->boundary = 0;
-out:
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.7.12

