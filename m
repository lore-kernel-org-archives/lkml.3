Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934998Ab3BTAXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:23:12 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52214 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934961Ab3BTAXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:23:03 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 13/27] block: Add submit_bio_wait(), remove from md
Date: Tue, 19 Feb 2013 16:22:27 -0800
Message-Id: <1361319761-23873-14-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Random cleanup - this code was duplicated and it's not really specific
to md.

Also added the ability to return the actual error code.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/md/raid1.c  | 19 -------------------
 drivers/md/raid10.c | 19 -------------------
 fs/bio.c            | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 4 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b47503b..3dbdb3d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2056,25 +2056,6 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 	}
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
-static int submit_bio_wait(int rw, struct bio *bio)
-{
-	struct completion event;
-	rw |= REQ_SYNC;
-
-	init_completion(&event);
-	bio->bi_private = &event;
-	bio->bi_end_io = bi_complete;
-	submit_bio(rw, bio);
-	wait_for_completion(&event);
-
-	return test_bit(BIO_UPTODATE, &bio->bi_flags);
-}
-
 static int narrow_write_error(struct r1bio *r1_bio, int i)
 {
 	struct mddev *mddev = r1_bio->mddev;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c2e2abf..3cbd3ac 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2479,25 +2479,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 }
 
-static void bi_complete(struct bio *bio, int error)
-{
-	complete((struct completion *)bio->bi_private);
-}
-
-static int submit_bio_wait(int rw, struct bio *bio)
-{
-	struct completion event;
-	rw |= REQ_SYNC;
-
-	init_completion(&event);
-	bio->bi_private = &event;
-	bio->bi_end_io = bi_complete;
-	submit_bio(rw, bio);
-	wait_for_completion(&event);
-
-	return test_bit(BIO_UPTODATE, &bio->bi_flags);
-}
-
 static int narrow_write_error(struct r10bio *r10_bio, int i)
 {
 	struct bio *bio = r10_bio->master_bio;
diff --git a/fs/bio.c b/fs/bio.c
index f1b4c16..4ce24ee 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -752,6 +752,42 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 }
 EXPORT_SYMBOL(bio_add_page);
 
+struct submit_bio_ret {
+	struct completion event;
+	int error;
+};
+
+static void submit_bio_wait_endio(struct bio *bio, int error)
+{
+	struct submit_bio_ret *ret = bio->bi_private;
+
+	ret->error = error;
+	complete(&ret->event);
+}
+
+/**
+ * submit_bio_wait - submit a bio, and wait until it completes
+ * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
+ * @bio: The &struct bio which describes the I/O
+ *
+ * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
+ * bio_endio() on failure.
+ */
+int submit_bio_wait(int rw, struct bio *bio)
+{
+	struct submit_bio_ret ret;
+
+	rw |= REQ_SYNC;
+	init_completion(&ret.event);
+	bio->bi_private = &ret;
+	bio->bi_end_io = submit_bio_wait_endio;
+	submit_bio(rw, bio);
+	wait_for_completion(&ret.event);
+
+	return ret.error;
+}
+EXPORT_SYMBOL(submit_bio_wait);
+
 /**
  * bio_advance - increment/complete a bio by some number of bytes
  * @bio:	bio to advance
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 20507eb..b20a9cd 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -249,6 +249,7 @@ extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
+extern int submit_bio_wait(int rw, struct bio *bio);
 extern void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
-- 
1.7.12

