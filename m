Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3K0Arg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:47:36 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58195 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3K0AqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:46:17 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 22/25] block: Generic bio chaining
Date: Tue, 26 Nov 2013 16:45:25 -0800
Message-Id: <1385513128-5035-22-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385513128-5035-1-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
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
 drivers/md/dm-snap.c         |  1 +
 drivers/md/dm-thin.c         |  8 +++--
 drivers/md/dm-verity.c       |  2 +-
 fs/bio-integrity.c           |  2 +-
 fs/bio.c                     | 76 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/bio.h          |  2 ++
 include/linux/blk_types.h    |  2 ++
 9 files changed, 90 insertions(+), 11 deletions(-)

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
index 86f9c83..bf3a206 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -765,6 +765,12 @@ static void writethrough_endio(struct bio *bio, int err)
 
 	dm_unhook_bio(&pb->hook_info, bio);
 
+	/*
+	 * Must bump bi_remaining to allow bio to complete with
+	 * restored bi_end_io.
+	 */
+	atomic_inc(&bio->bi_remaining);
+
 	if (err) {
 		bio_endio(bio, err);
 		return;
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3ded8c7..80b5cab 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1415,6 +1415,7 @@ out:
 	if (full_bio) {
 		full_bio->bi_end_io = pe->full_bio_end_io;
 		full_bio->bi_private = pe->full_bio_private;
+		atomic_inc(&full_bio->bi_remaining);
 	}
 	free_pending_exception(pe);
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index a654024..1abb4a2 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -611,8 +611,10 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
 
 static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 {
-	if (m->bio)
+	if (m->bio) {
 		m->bio->bi_end_io = m->saved_bi_end_io;
+		atomic_inc(&m->bio->bi_remaining);
+	}
 	cell_error(m->tc->pool, m->cell);
 	list_del(&m->list);
 	mempool_free(m, m->tc->pool->mapping_pool);
@@ -626,8 +628,10 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	int r;
 
 	bio = m->bio;
-	if (bio)
+	if (bio) {
 		bio->bi_end_io = m->saved_bi_end_io;
+		atomic_inc(&bio->bi_remaining);
+	}
 
 	if (m->err) {
 		cell_error(pool, m->cell);
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index ac35e95..796007a 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -385,7 +385,7 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_private = io->orig_bi_private;
 
-	bio_endio(bio, error);
+	bio_endio_nodec(bio, error);
 }
 
 static void verity_work(struct work_struct *w)
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
index e6dfa06..b0a16db 100644
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
@@ -295,9 +296,35 @@ void bio_reset(struct bio *bio)
 
 	memset(bio, 0, BIO_RESET_BYTES);
 	bio->bi_flags = flags|(1 << BIO_UPTODATE);
+	atomic_set(&bio->bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_reset);
 
+static void bio_chain_endio(struct bio *bio, int error)
+{
+	bio_endio(bio->bi_private, error);
+	bio_put(bio);
+}
+
+/**
+ * bio_chain - chain bio completions
+ *
+ * The caller won't have a bi_end_io called when @bio completes - instead,
+ * @parent's bi_end_io won't be called until both @parent and @bio have
+ * completed; the chained bio will also be freed when it completes.
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
@@ -1719,16 +1746,53 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
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
+			struct bio *parent = bio->bi_private;
+			bio_put(bio);
+			bio = parent;
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
index 0c32a45..64f5169 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -356,6 +356,7 @@ static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
 }
 
 extern void bio_endio(struct bio *, int);
+extern void bio_endio_nodec(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
@@ -364,6 +365,7 @@ extern void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
+void bio_chain(struct bio *, struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d369f8f..bbc3a6c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -65,6 +65,8 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
 
+	atomic_t		bi_remaining;
+
 	bio_end_io_t		*bi_end_io;
 
 	void			*bi_private;
-- 
1.8.4.4

