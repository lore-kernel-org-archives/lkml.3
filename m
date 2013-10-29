Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3J2UUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:20:00 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63767 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3J2USu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:50 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 19/23] block: Generic bio chaining
Date: Tue, 29 Oct 2013 13:18:12 -0700
Message-Id: <1383077896-4132-20-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic mechanism for chaining bio completions. This is
going to be used for a bio_split() replacement, and it turns out to be
very useful in a fair amount of driver code - a fair number of drivers
were implementing this in their own roundabout ways, often painfully.

Note that this means it's no longer to call bio_endio() more than once
on the same bio! This can cause problems for drivers that save/restore
bi_end_io. Arguably they shouldn't be saving/restoring bi_end_io at all
- in all but the simplest cases they'd be better off just cloning the
bio, and immutable biovecs is making bio cloning cheaper. But for now,
we add a bio_endio_nodec() for these cases.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/io.c       |  2 +-
 drivers/md/dm-cache-target.c |  6 ++++
 fs/bio-integrity.c           |  2 +-
 fs/bio.c                     | 73 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/bio.h          |  2 ++
 include/linux/blk_types.h    |  2 ++
 6 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 0f0ab65..522f957 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -133,7 +133,7 @@ static void bch_bio_submit_split_done(struct closure *cl)
 
 	s->bio->bi_end_io = s->bi_end_io;
 	s->bio->bi_private = s->bi_private;
-	bio_endio(s->bio, 0);
+	bio_endio_nodec(s->bio, 0);
 
 	closure_debug_destroy(&s->cl);
 	mempool_free(s, s->p->bio_split_hook);
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index b71195f..1ccbfff 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -666,6 +666,12 @@ static void writethrough_endio(struct bio *bio, int err)
 	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
 	bio->bi_end_io = pb->saved_bi_end_io;
 
+	/*
+	 * Must bump bi_remaining to allow bio to complete with
+	 * restored bi_end_io.
+	 */
+	atomic_inc(&bio->bi_remaining);
+
 	if (err) {
 		bio_endio(bio, err);
 		return;
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index fed744b..9d547d2 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -502,7 +502,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 
 	/* Restore original bio completion handler */
 	bio->bi_end_io = bip->bip_end_io;
-	bio_endio(bio, error);
+	bio_endio_nodec(bio, error);
 }
 
 /**
diff --git a/fs/bio.c b/fs/bio.c
index 8bbba9a..9e7ef5e 100644
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
@@ -295,9 +296,34 @@ void bio_reset(struct bio *bio)
 
 	memset(bio, 0, BIO_RESET_BYTES);
 	bio->bi_flags = flags|(1 << BIO_UPTODATE);
+	atomic_set(&bio->bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_reset);
 
+static void bio_chain_endio(struct bio *bio, int error)
+{
+	bio_endio(bio->bi_private, error);
+}
+
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
+	bio->bi_private = parent;
+	bio->bi_end_io	= bio_chain_endio;
+	atomic_inc(&parent->bi_remaining);
+}
+EXPORT_SYMBOL(bio_chain);
+
 static void bio_alloc_rescue(struct work_struct *work)
 {
 	struct bio_set *bs = container_of(work, struct bio_set, rescue_work);
@@ -1687,16 +1713,51 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
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
+		/*
+		 * Need to have a real endio function for chained bios,
+		 * otherwise various corner cases will break (like stacking
+		 * block devices that save/restore bi_end_io) - however, we want
+		 * to avoid unbounded recursion and blowing the stack. Tail call
+		 * optimization would handle this, but compiling with frame
+		 * pointers also disables gcc's sibling call optimization.
+		 */
+		if (bio->bi_end_io == bio_chain_endio) {
+			bio = bio->bi_private;
+		} else {
+			if (bio->bi_end_io)
+				bio->bi_end_io(bio, error);
+			bio = NULL;
+		}
+	}
 }
 EXPORT_SYMBOL(bio_endio);
 
+/**
+ * bio_endio_nodec - end I/O on a bio, without decrementing bi_remaining
+ * @bio:	bio
+ * @error:	error, if any
+ *
+ * For code that has saved and restored bi_end_io; thing hard before using this
+ * function, probably you should've cloned the entire bio.
+ **/
+void bio_endio_nodec(struct bio *bio, int error)
+{
+	atomic_inc(&bio->bi_remaining);
+	bio_endio(bio, error);
+}
+EXPORT_SYMBOL(bio_endio_nodec);
+
 void bio_pair_release(struct bio_pair *bp)
 {
 	if (atomic_dec_and_test(&bp->cnt)) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6aaeeb1..003f65d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -355,6 +355,7 @@ static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
 }
 
 extern void bio_endio(struct bio *, int);
+extern void bio_endio_nodec(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
@@ -363,6 +364,7 @@ extern void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
+void bio_chain(struct bio *, struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 72f1274..8fca6e3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -64,6 +64,8 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
 
+	atomic_t		bi_remaining;
+
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
-- 
1.8.4.rc3

