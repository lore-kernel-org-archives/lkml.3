Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3FICTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:19:43 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57985 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3FICTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:19:40 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 02/26] bcache: Kill unaligned bvec hack
Date: Sat,  8 Jun 2013 19:18:44 -0700
Message-Id: <1370744348-15407-3-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcache has a hack to avoid cloning the biovec if it's all full pages -
but with immutable biovecs coming this won't be necessary anymore.

For now, we remove the special case and always clone the bvec array so
that the immutable biovec patches are simpler.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/bcache/bcache.h  |  1 -
 drivers/md/bcache/debug.c   |  4 ----
 drivers/md/bcache/request.c | 32 +++++---------------------------
 drivers/md/bcache/request.h |  2 +-
 drivers/md/bcache/super.c   |  4 ----
 5 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 340146d..850de67 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -443,7 +443,6 @@ struct bcache_device {
 	unsigned long		sectors_dirty_last;
 	long			sectors_dirty_derivative;
 
-	mempool_t		*unaligned_bvec;
 	struct bio_set		*bio_split;
 
 	unsigned		data_csum:1;
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 91cd5f8..5941ed7 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -192,10 +192,6 @@ void bch_data_verify(struct search *s)
 	struct bio_vec *bv;
 	int i;
 
-	if (!s->unaligned_bvec)
-		bio_for_each_segment(bv, s->orig_bio, i)
-			bv->bv_offset = 0, bv->bv_len = PAGE_SIZE;
-
 	check = bio_clone(s->orig_bio, GFP_NOIO);
 	if (!check)
 		return;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index c91ef76..8e5c35d 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -675,10 +675,14 @@ static void bio_complete(struct search *s)
 static void do_bio_hook(struct search *s)
 {
 	struct bio *bio = &s->bio.bio;
-	memcpy(bio, s->orig_bio, sizeof(struct bio));
 
+	bio_init(bio);
+	bio->bi_io_vec		= s->bv;
+	bio->bi_max_vecs	= BIO_MAX_PAGES;
+	__bio_clone(bio, s->orig_bio);
 	bio->bi_end_io		= request_endio;
 	bio->bi_private		= &s->cl;
+
 	atomic_set(&bio->bi_cnt, 3);
 }
 
@@ -690,16 +694,12 @@ static void search_free(struct closure *cl)
 	if (s->op.cache_bio)
 		bio_put(s->op.cache_bio);
 
-	if (s->unaligned_bvec)
-		mempool_free(s->bio.bio.bi_io_vec, s->d->unaligned_bvec);
-
 	closure_debug_destroy(cl);
 	mempool_free(s, s->d->c->search);
 }
 
 static struct search *search_alloc(struct bio *bio, struct bcache_device *d)
 {
-	struct bio_vec *bv;
 	struct search *s = mempool_alloc(d->c->search, GFP_NOIO);
 	memset(s, 0, offsetof(struct search, op.keys));
 
@@ -718,15 +718,6 @@ static struct search *search_alloc(struct bio *bio, struct bcache_device *d)
 	s->start_time		= jiffies;
 	do_bio_hook(s);
 
-	if (bio->bi_size != bio_segments(bio) * PAGE_SIZE) {
-		bv = mempool_alloc(d->unaligned_bvec, GFP_NOIO);
-		memcpy(bv, bio_iovec(bio),
-		       sizeof(struct bio_vec) * bio_segments(bio));
-
-		s->bio.bio.bi_io_vec	= bv;
-		s->unaligned_bvec	= 1;
-	}
-
 	return s;
 }
 
@@ -776,8 +767,6 @@ static void cached_dev_read_complete(struct closure *cl)
 static void request_read_error(struct closure *cl)
 {
 	struct search *s = container_of(cl, struct search, cl);
-	struct bio_vec *bv;
-	int i;
 
 	if (s->recoverable) {
 		/* The cache read failed, but we can retry from the backing
@@ -787,18 +776,7 @@ static void request_read_error(struct closure *cl)
 			 (uint64_t) s->orig_bio->bi_sector);
 
 		s->error = 0;
-		bv = s->bio.bio.bi_io_vec;
 		do_bio_hook(s);
-		s->bio.bio.bi_io_vec = bv;
-
-		if (!s->unaligned_bvec)
-			bio_for_each_segment(bv, s->orig_bio, i)
-				bv->bv_offset = 0, bv->bv_len = PAGE_SIZE;
-		else
-			memcpy(s->bio.bio.bi_io_vec,
-			       bio_iovec(s->orig_bio),
-			       sizeof(struct bio_vec) *
-			       bio_segments(s->orig_bio));
 
 		/* XXX: invalidate cache */
 
diff --git a/drivers/md/bcache/request.h b/drivers/md/bcache/request.h
index 254d9ab..7873029b 100644
--- a/drivers/md/bcache/request.h
+++ b/drivers/md/bcache/request.h
@@ -16,7 +16,6 @@ struct search {
 	unsigned		cache_bio_sectors;
 
 	unsigned		recoverable:1;
-	unsigned		unaligned_bvec:1;
 
 	unsigned		write:1;
 	unsigned		writeback:1;
@@ -27,6 +26,7 @@ struct search {
 
 	/* Anything past op->keys won't get zeroed in do_bio_hook */
 	struct btree_op		op;
+	struct bio_vec		bv[BIO_MAX_PAGES];
 };
 
 void bch_cache_read_endio(struct bio *, int);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c8046bc..7f7ea78 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -741,8 +741,6 @@ static void bcache_device_free(struct bcache_device *d)
 		put_disk(d->disk);
 
 	bio_split_pool_free(&d->bio_split_hook);
-	if (d->unaligned_bvec)
-		mempool_destroy(d->unaligned_bvec);
 	if (d->bio_split)
 		bioset_free(d->bio_split);
 
@@ -754,8 +752,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size)
 	struct request_queue *q;
 
 	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
-	    !(d->unaligned_bvec = mempool_create_kmalloc_pool(1,
-				sizeof(struct bio_vec) * BIO_MAX_PAGES)) ||
 	    bio_split_pool_init(&d->bio_split_hook))
 
 		return -ENOMEM;
-- 
1.8.3.rc1

