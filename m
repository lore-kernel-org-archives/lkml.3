Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3ENBTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:19:38 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:47874 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3ENBTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:32 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Joel Becker <jlbec@evilplan.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 20/21] direct-io: Set dio->io_error directly
Date: Mon, 13 May 2013 18:18:57 -0700
Message-Id: <1368494338-7069-21-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way io errors are returned in the dio code was rather convoluted,
and also meant that the specific error code was lost. We need to return
the actual error so that for cancellation we can pass up -ECANCELED.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/direct-io.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index b4dd97c..9ac3011 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -271,7 +271,7 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
 	return ret;
 }
 
-static int dio_bio_complete(struct dio *dio, struct bio *bio);
+static void dio_bio_complete(struct dio *dio, struct bio *bio);
 /*
  * Asynchronous IO callback. 
  */
@@ -282,6 +282,9 @@ static void dio_bio_end_aio(struct bio *bio, int error,
 	unsigned long remaining;
 	unsigned long flags;
 
+	if (error)
+		dio->io_error = error;
+
 	/* cleanup the bio */
 	dio_bio_complete(dio, bio);
 
@@ -309,6 +312,9 @@ static void dio_bio_end_io(struct bio *bio, int error)
 	struct dio *dio = bio->bi_private;
 	unsigned long flags;
 
+	if (error)
+		dio->io_error = error;
+
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	bio->bi_private = dio->bio_list;
 	dio->bio_list = bio;
@@ -438,15 +444,11 @@ static struct bio *dio_await_one(struct dio *dio)
 /*
  * Process one completed BIO.  No locks are held.
  */
-static int dio_bio_complete(struct dio *dio, struct bio *bio)
+static void dio_bio_complete(struct dio *dio, struct bio *bio)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec;
 	unsigned i;
 
-	if (!uptodate)
-		dio->io_error = -EIO;
-
 	if (dio->is_async && dio->rw == READ) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
@@ -459,7 +461,6 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 		}
 		bio_put(bio);
 	}
-	return uptodate ? 0 : -EIO;
 }
 
 /*
@@ -486,27 +487,21 @@ static void dio_await_completion(struct dio *dio)
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
@@ -591,19 +586,20 @@ static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
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
1.8.2.1

