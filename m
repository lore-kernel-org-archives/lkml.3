Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3FICXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:23:47 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:32848 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3FICT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:19:59 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 15/26] block: Generic bio chaining
Date: Sat,  8 Jun 2013 19:18:57 -0700
Message-Id: <1370744348-15407-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic mechanism for chaining bio completions. This is
going to be used for a bio_split() replacement, and some other things in
the future.

This is implemented with a new bio flag that bio_endio() checks; it
would definitely be cleaner to implement chaining with a bi_end_io
function, but since there's no limits on the depth of a bio chain (and
with arbitrary bio splitting coming this is going to be a real issue)
using an endio function would lead to unbounded stack usage.

Tail call optimization could solve that, but CONFIG_FRAME_POINTER
disables gcc's tail call optimization (-fno-optimize-sibling-calls) - so
we do it the hacky but safe way.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/io.c    |  2 +-
 fs/bio.c                  | 45 +++++++++++++++++++++++++++++++++++++++------
 include/linux/bio.h       |  1 +
 include/linux/blk_types.h |  7 +++++--
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 294b4c1..246b420 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -137,7 +137,7 @@ static void bch_bio_submit_split_done(struct closure *cl)
 
 	s->bio->bi_end_io = s->bi_end_io;
 	s->bio->bi_private = s->bi_private;
-	bio_endio(s->bio, 0);
+	s->bio->bi_end_io(s->bio, 0);
 
 	closure_debug_destroy(&s->cl);
 	mempool_free(s, s->p->bio_split_hook);
diff --git a/fs/bio.c b/fs/bio.c
index 24271ce..bd25401 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -273,6 +273,7 @@ void bio_init(struct bio *bio)
 {
 	memset(bio, 0, sizeof(*bio));
 	bio->bi_flags = 1 << BIO_UPTODATE;
+	atomic_set(&bio->bi_remaining, 1);
 	atomic_set(&bio->bi_cnt, 1);
 }
 EXPORT_SYMBOL(bio_init);
@@ -295,9 +296,29 @@ void bio_reset(struct bio *bio)
 
 	memset(bio, 0, BIO_RESET_BYTES);
 	bio->bi_flags = flags|(1 << BIO_UPTODATE);
+	atomic_set(&bio->bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_reset);
 
+/**
+ * bio_chain - chain bio completions
+ *
+ * The caller won't have a bi_end_io called when @bio completes - instead,
+ * @parent's bi_end_io won't be called until both @parent and @bio have
+ * completed.
+ *
+ * The caller must not set bi_private or bi_end_io in @bio.
+ */
+void bio_chain(struct bio *bio, struct bio *parent)
+{
+	BUG_ON(bio->bi_private || bio->bi_end_io);
+
+	bio->bi_flags |= 1 << BIO_CHAINED;
+	bio->bi_private = parent;
+	atomic_inc(&parent->bi_remaining);
+}
+EXPORT_SYMBOL(bio_chain);
+
 static void bio_alloc_rescue(struct work_struct *work)
 {
 	struct bio_set *bs = container_of(work, struct bio_set, rescue_work);
@@ -1669,13 +1690,25 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  **/
 void bio_endio(struct bio *bio, int error)
 {
-	if (error)
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		error = -EIO;
+	while (bio) {
+		BUG_ON(atomic_read(&bio->bi_remaining) <= 0);
+
+		if (error)
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
+		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+			error = -EIO;
+
+		if (!atomic_dec_and_test(&bio->bi_remaining))
+			return;
 
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+		if (bio_flagged(bio, BIO_CHAINED)) {
+			bio = bio->bi_private;
+		} else {
+			if (bio->bi_end_io)
+				bio->bi_end_io(bio, error);
+			bio = NULL;
+		}
+	}
 }
 EXPORT_SYMBOL(bio_endio);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 80ffe15..55d2ce8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -326,6 +326,7 @@ extern void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
+void bio_chain(struct bio *, struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 72f1274..69f5c0d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -64,6 +64,8 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
 
+	atomic_t		bi_remaining;
+
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
@@ -119,13 +121,14 @@ struct bio {
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
 #define BIO_SNAP_STABLE	12	/* bio data must be snapshotted during write */
+#define BIO_CHAINED	13	/* bi_private points to a parent bio */
 
 /*
  * Flags starting here get preserved by bio_reset() - this includes
  * BIO_POOL_IDX()
  */
-#define BIO_RESET_BITS	13
-#define BIO_OWNS_VEC	13	/* bio_free() should free bvec */
+#define BIO_RESET_BITS	14
+#define BIO_OWNS_VEC	14	/* bio_free() should free bvec */
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
-- 
1.8.3.rc1

