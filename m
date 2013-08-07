Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839Ab3HGV6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:58:05 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53471 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933745Ab3HGVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:55:29 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 18/22] block: Generic bio chaining
Date: Wed,  7 Aug 2013 14:54:27 -0700
Message-Id: <1375912471-5106-19-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
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

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/io.c    |  2 +-
 fs/bio.c                  | 45 +++++++++++++++++++++++++++++++++++++++------
 include/linux/bio.h       |  1 +
 include/linux/blk_types.h |  7 +++++--
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 0f0ab65..10f6065 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -133,7 +133,7 @@ static void bch_bio_submit_split_done(struct closure *cl)
 
 	s->bio->bi_end_io = s->bi_end_io;
 	s->bio->bi_private = s->bi_private;
-	bio_endio(s->bio, 0);
+	s->bio->bi_end_io(s->bio, 0);
 
 	closure_debug_destroy(&s->cl);
 	mempool_free(s, s->p->bio_split_hook);
diff --git a/fs/bio.c b/fs/bio.c
index 7d14b79..7737984 100644
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
index e9a4fce..1b06bcb 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -344,6 +344,7 @@ extern void bio_advance(struct bio *, unsigned);
 
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
1.8.4.rc1

