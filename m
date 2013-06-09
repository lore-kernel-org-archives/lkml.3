Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3FIC1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:27:08 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62352 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3FICTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:19:39 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 01/26] bcache: Use standard utility code
Date: Sat,  8 Jun 2013 19:18:43 -0700
Message-Id: <1370744348-15407-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of bcache's utility code has made it into the rest of the kernel,
so drop the bcache versions.

Bcache used to have a workaround for allocating from a bio set under
generic_make_request() (if you allocated more than once, the bios you
already allocated would get stuck on current->bio_list when you
submitted, and you'd risk deadlock) - bcache would mask out __GFP_WAIT
when allocating bios under generic_make_request() so that allocation
could fail and it could retry from workqueue. But bio_alloc_bioset() has
a workaround now, so we can drop this hack and the associated error
handling.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/bcache/btree.c     |  7 +---
 drivers/md/bcache/debug.c     |  2 +-
 drivers/md/bcache/io.c        | 64 +++++++++++--------------------
 drivers/md/bcache/movinggc.c  |  7 ++--
 drivers/md/bcache/request.c   | 87 +++++++++----------------------------------
 drivers/md/bcache/util.c      | 17 ---------
 drivers/md/bcache/util.h      |  4 --
 drivers/md/bcache/writeback.c |  7 ++--
 8 files changed, 51 insertions(+), 144 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 7a5658f..6830190 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -333,7 +333,7 @@ static void do_btree_write(struct btree *b)
 	bkey_copy(&k.key, &b->key);
 	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) + bset_offset(b, i));
 
-	if (!bch_bio_alloc_pages(b->bio, GFP_NOIO)) {
+	if (!bio_alloc_pages(b->bio, GFP_NOIO)) {
 		int j;
 		struct bio_vec *bv;
 		void *base = (void *) ((unsigned long) i & ~(PAGE_SIZE - 1));
@@ -1896,7 +1896,7 @@ bool bch_btree_insert_check_key(struct btree *b, struct btree_op *op,
 	    should_split(b))
 		goto out;
 
-	op->replace = KEY(op->inode, bio_end(bio), bio_sectors(bio));
+	op->replace = KEY(op->inode, bio_end_sector(bio), bio_sectors(bio));
 
 	SET_KEY_PTRS(&op->replace, 1);
 	get_random_bytes(&op->replace.ptr[0], sizeof(uint64_t));
@@ -2215,9 +2215,6 @@ static int submit_partial_cache_hit(struct btree *b, struct btree_op *op,
 					 KEY_OFFSET(k) - bio->bi_sector);
 
 		n = bch_bio_split(bio, sectors, GFP_NOIO, s->d->bio_split);
-		if (!n)
-			return -EAGAIN;
-
 		if (n == bio)
 			op->lookup_done = true;
 
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 89fd520..91cd5f8 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -200,7 +200,7 @@ void bch_data_verify(struct search *s)
 	if (!check)
 		return;
 
-	if (bch_bio_alloc_pages(check, GFP_NOIO))
+	if (bio_alloc_pages(check, GFP_NOIO))
 		goto out_put;
 
 	check->bi_rw		= READ_SYNC;
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 48efd4d..e5d27a8 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -66,13 +66,6 @@ static void bch_generic_make_request_hack(struct bio *bio)
  * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
  * bvec boundry; it is the caller's responsibility to ensure that @bio is not
  * freed before the split.
- *
- * If bch_bio_split() is running under generic_make_request(), it's not safe to
- * allocate more than one bio from the same bio set. Therefore, if it is running
- * under generic_make_request() it masks out __GFP_WAIT when doing the
- * allocation. The caller must check for failure if there's any possibility of
- * it being called from under generic_make_request(); it is then the caller's
- * responsibility to retry from a safe context (by e.g. punting to workqueue).
  */
 struct bio *bch_bio_split(struct bio *bio, int sectors,
 			  gfp_t gfp, struct bio_set *bs)
@@ -83,15 +76,6 @@ struct bio *bch_bio_split(struct bio *bio, int sectors,
 
 	BUG_ON(sectors <= 0);
 
-	/*
-	 * If we're being called from underneath generic_make_request() and we
-	 * already allocated any bios from this bio set, we risk deadlock if we
-	 * use the mempool. So instead, we possibly fail and let the caller punt
-	 * to workqueue or somesuch and retry in a safe context.
-	 */
-	if (current->bio_list)
-		gfp &= ~__GFP_WAIT;
-
 	if (sectors >= bio_sectors(bio))
 		return bio;
 
@@ -160,17 +144,18 @@ static unsigned bch_bio_max_sectors(struct bio *bio)
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	unsigned max_segments = min_t(unsigned, BIO_MAX_PAGES,
 				      queue_max_segments(q));
-	struct bio_vec *bv, *end = bio_iovec(bio) +
-		min_t(int, bio_segments(bio), max_segments);
 
 	if (bio->bi_rw & REQ_DISCARD)
 		return min(ret, q->limits.max_discard_sectors);
 
 	if (bio_segments(bio) > max_segments ||
 	    q->merge_bvec_fn) {
+		struct bio_vec *bv;
+		int i, seg = 0;
+
 		ret = 0;
 
-		for (bv = bio_iovec(bio); bv < end; bv++) {
+		bio_for_each_segment(bv, bio, i) {
 			struct bvec_merge_data bvm = {
 				.bi_bdev	= bio->bi_bdev,
 				.bi_sector	= bio->bi_sector,
@@ -178,10 +163,14 @@ static unsigned bch_bio_max_sectors(struct bio *bio)
 				.bi_rw		= bio->bi_rw,
 			};
 
+			if (seg == max_segments)
+				break;
+
 			if (q->merge_bvec_fn &&
 			    q->merge_bvec_fn(q, &bvm, bv) < (int) bv->bv_len)
 				break;
 
+			seg++;
 			ret += bv->bv_len >> 9;
 		}
 	}
@@ -218,30 +207,10 @@ static void bch_bio_submit_split_endio(struct bio *bio, int error)
 	closure_put(cl);
 }
 
-static void __bch_bio_submit_split(struct closure *cl)
-{
-	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
-	struct bio *bio = s->bio, *n;
-
-	do {
-		n = bch_bio_split(bio, bch_bio_max_sectors(bio),
-				  GFP_NOIO, s->p->bio_split);
-		if (!n)
-			continue_at(cl, __bch_bio_submit_split, system_wq);
-
-		n->bi_end_io	= bch_bio_submit_split_endio;
-		n->bi_private	= cl;
-
-		closure_get(cl);
-		bch_generic_make_request_hack(n);
-	} while (n != bio);
-
-	continue_at(cl, bch_bio_submit_split_done, NULL);
-}
-
 void bch_generic_make_request(struct bio *bio, struct bio_split_pool *p)
 {
 	struct bio_split_hook *s;
+	struct bio *n;
 
 	if (!bio_has_data(bio) && !(bio->bi_rw & REQ_DISCARD))
 		goto submit;
@@ -250,6 +219,7 @@ void bch_generic_make_request(struct bio *bio, struct bio_split_pool *p)
 		goto submit;
 
 	s = mempool_alloc(p->bio_split_hook, GFP_NOIO);
+	closure_init(&s->cl, NULL);
 
 	s->bio		= bio;
 	s->p		= p;
@@ -257,8 +227,18 @@ void bch_generic_make_request(struct bio *bio, struct bio_split_pool *p)
 	s->bi_private	= bio->bi_private;
 	bio_get(bio);
 
-	closure_call(&s->cl, __bch_bio_submit_split, NULL, NULL);
-	return;
+	do {
+		n = bch_bio_split(bio, bch_bio_max_sectors(bio),
+				  GFP_NOIO, s->p->bio_split);
+
+		n->bi_end_io	= bch_bio_submit_split_endio;
+		n->bi_private	= &s->cl;
+
+		closure_get(&s->cl);
+		bch_generic_make_request_hack(n);
+	} while (n != bio);
+
+	continue_at(&s->cl, bch_bio_submit_split_done, NULL);
 submit:
 	bch_generic_make_request_hack(bio);
 }
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 8589512..23f19fa 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -44,9 +44,10 @@ static void write_moving_finish(struct closure *cl)
 {
 	struct moving_io *io = container_of(cl, struct moving_io, s.cl);
 	struct bio *bio = &io->bio.bio;
-	struct bio_vec *bv = bio_iovec_idx(bio, bio->bi_vcnt);
+	struct bio_vec *bv;
+	int i;
 
-	while (bv-- != bio->bi_io_vec)
+	bio_for_each_segment_all(bv, bio, i)
 		__free_page(bv->bv_page);
 
 	pr_debug("%s %s", io->s.op.insert_collision
@@ -159,7 +160,7 @@ static void read_moving(struct closure *cl)
 		bio->bi_rw	= READ;
 		bio->bi_end_io	= read_moving_endio;
 
-		if (bch_bio_alloc_pages(bio, GFP_KERNEL))
+		if (bio_alloc_pages(bio, GFP_KERNEL))
 			goto err;
 
 		pr_debug("%s", pkey(&w->key));
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index e5ff12e..c91ef76 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -510,10 +510,6 @@ static void bch_insert_data_loop(struct closure *cl)
 			goto err;
 
 		n = bch_bio_split(bio, KEY_SIZE(k), GFP_NOIO, split);
-		if (!n) {
-			__bkey_put(op->c, k);
-			continue_at(cl, bch_insert_data_loop, bcache_wq);
-		}
 
 		n->bi_end_io	= bch_insert_data_endio;
 		n->bi_private	= cl;
@@ -827,53 +823,13 @@ static void request_read_done(struct closure *cl)
 	 */
 
 	if (s->op.cache_bio) {
-		struct bio_vec *src, *dst;
-		unsigned src_offset, dst_offset, bytes;
-		void *dst_ptr;
-
 		bio_reset(s->op.cache_bio);
 		s->op.cache_bio->bi_sector	= s->cache_miss->bi_sector;
 		s->op.cache_bio->bi_bdev	= s->cache_miss->bi_bdev;
 		s->op.cache_bio->bi_size	= s->cache_bio_sectors << 9;
 		bch_bio_map(s->op.cache_bio, NULL);
 
-		src = bio_iovec(s->op.cache_bio);
-		dst = bio_iovec(s->cache_miss);
-		src_offset = src->bv_offset;
-		dst_offset = dst->bv_offset;
-		dst_ptr = kmap(dst->bv_page);
-
-		while (1) {
-			if (dst_offset == dst->bv_offset + dst->bv_len) {
-				kunmap(dst->bv_page);
-				dst++;
-				if (dst == bio_iovec_idx(s->cache_miss,
-						s->cache_miss->bi_vcnt))
-					break;
-
-				dst_offset = dst->bv_offset;
-				dst_ptr = kmap(dst->bv_page);
-			}
-
-			if (src_offset == src->bv_offset + src->bv_len) {
-				src++;
-				if (src == bio_iovec_idx(s->op.cache_bio,
-						 s->op.cache_bio->bi_vcnt))
-					BUG();
-
-				src_offset = src->bv_offset;
-			}
-
-			bytes = min(dst->bv_offset + dst->bv_len - dst_offset,
-				    src->bv_offset + src->bv_len - src_offset);
-
-			memcpy(dst_ptr + dst_offset,
-			       page_address(src->bv_page) + src_offset,
-			       bytes);
-
-			src_offset	+= bytes;
-			dst_offset	+= bytes;
-		}
+		bio_copy_data(s->cache_miss, s->op.cache_bio);
 
 		bio_put(s->cache_miss);
 		s->cache_miss = NULL;
@@ -917,9 +873,6 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	struct bio *miss;
 
 	miss = bch_bio_split(bio, sectors, GFP_NOIO, s->d->bio_split);
-	if (!miss)
-		return -EAGAIN;
-
 	if (miss == bio)
 		s->op.lookup_done = true;
 
@@ -938,8 +891,9 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 		reada = min(dc->readahead >> 9,
 			    sectors - bio_sectors(miss));
 
-		if (bio_end(miss) + reada > bdev_sectors(miss->bi_bdev))
-			reada = bdev_sectors(miss->bi_bdev) - bio_end(miss);
+		if (bio_end_sector(miss) + reada > bdev_sectors(miss->bi_bdev))
+			reada = bdev_sectors(miss->bi_bdev) -
+				bio_end_sector(miss);
 	}
 
 	s->cache_bio_sectors = bio_sectors(miss) + reada;
@@ -963,7 +917,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 		goto out_put;
 
 	bch_bio_map(s->op.cache_bio, NULL);
-	if (bch_bio_alloc_pages(s->op.cache_bio, __GFP_NOWARN|GFP_NOIO))
+	if (bio_alloc_pages(s->op.cache_bio, __GFP_NOWARN|GFP_NOIO))
 		goto out_put;
 
 	s->cache_miss = miss;
@@ -1019,7 +973,7 @@ static void request_write(struct cached_dev *dc, struct search *s)
 	struct bio *bio = &s->bio.bio;
 	struct bkey start, end;
 	start = KEY(dc->disk.id, bio->bi_sector, 0);
-	end = KEY(dc->disk.id, bio_end(bio), 0);
+	end = KEY(dc->disk.id, bio_end_sector(bio), 0);
 
 	bch_keybuf_check_overlapping(&s->op.c->moving_gc_keys, &start, &end);
 
@@ -1177,7 +1131,7 @@ found:
 		if (i->sequential + bio->bi_size > i->sequential)
 			i->sequential	+= bio->bi_size;
 
-		i->last			 = bio_end(bio);
+		i->last			 = bio_end_sector(bio);
 		i->jiffies		 = jiffies + msecs_to_jiffies(5000);
 		s->task->sequential_io	 = i->sequential;
 
@@ -1288,30 +1242,25 @@ void bch_cached_dev_request_init(struct cached_dev *dc)
 static int flash_dev_cache_miss(struct btree *b, struct search *s,
 				struct bio *bio, unsigned sectors)
 {
+	struct bio_vec *bv;
+	int i;
+
 	/* Zero fill bio */
 
-	while (bio->bi_idx != bio->bi_vcnt) {
-		struct bio_vec *bv = bio_iovec(bio);
+	bio_for_each_segment(bv, bio, i) {
 		unsigned j = min(bv->bv_len >> 9, sectors);
 
 		void *p = kmap(bv->bv_page);
 		memset(p + bv->bv_offset, 0, j << 9);
 		kunmap(bv->bv_page);
 
-		bv->bv_len	-= j << 9;
-		bv->bv_offset	+= j << 9;
-
-		if (bv->bv_len)
-			return 0;
-
-		bio->bi_sector	+= j;
-		bio->bi_size	-= j << 9;
-
-		bio->bi_idx++;
-		sectors		-= j;
+		sectors	-= j;
 	}
 
-	s->op.lookup_done = true;
+	bio_advance(bio, min(sectors << 9, bio->bi_size));
+
+	if (!bio->bi_size)
+		s->op.lookup_done = true;
 
 	return 0;
 }
@@ -1338,8 +1287,8 @@ static void flash_dev_make_request(struct request_queue *q, struct bio *bio)
 		closure_call(&s->op.cl, btree_read_async, NULL, cl);
 	} else if (bio_has_data(bio) || s->op.skip) {
 		bch_keybuf_check_overlapping(&s->op.c->moving_gc_keys,
-					     &KEY(d->id, bio->bi_sector, 0),
-					     &KEY(d->id, bio_end(bio), 0));
+					&KEY(d->id, bio->bi_sector, 0),
+					&KEY(d->id, bio_end_sector(bio), 0));
 
 		s->writeback	= true;
 		s->op.cache_bio	= bio;
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index da3a99e..98eb811 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -228,23 +228,6 @@ start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
 	}
 }
 
-int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp)
-{
-	int i;
-	struct bio_vec *bv;
-
-	bio_for_each_segment(bv, bio, i) {
-		bv->bv_page = alloc_page(gfp);
-		if (!bv->bv_page) {
-			while (bv-- != bio->bi_io_vec + bio->bi_idx)
-				__free_page(bv->bv_page);
-			return -ENOMEM;
-		}
-	}
-
-	return 0;
-}
-
 /*
  * Portions Copyright (c) 1996-2001, PostgreSQL Global Development Group (Any
  * use permitted, subject to terms of PostgreSQL license; see.)
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 577393e..c9b3806 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -566,12 +566,8 @@ static inline unsigned fract_exp_two(unsigned x, unsigned fract_bits)
 	return x;
 }
 
-#define bio_end(bio)	((bio)->bi_sector + bio_sectors(bio))
-
 void bch_bio_map(struct bio *bio, void *base);
 
-int bch_bio_alloc_pages(struct bio *bio, gfp_t gfp);
-
 static inline sector_t bdev_sectors(struct block_device *bdev)
 {
 	return bdev->bd_inode->i_size >> 9;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 93e7e31..8a3311a 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -216,9 +216,10 @@ static void write_dirty_finish(struct closure *cl)
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
 	struct cached_dev *dc = io->dc;
-	struct bio_vec *bv = bio_iovec_idx(&io->bio, io->bio.bi_vcnt);
+	struct bio_vec *bv;
+	int i;
 
-	while (bv-- != io->bio.bi_io_vec)
+	bio_for_each_segment_all(bv, &io->bio, i)
 		__free_page(bv->bv_page);
 
 	/* This is kind of a dumb way of signalling errors. */
@@ -349,7 +350,7 @@ static void read_dirty(struct closure *cl)
 		io->bio.bi_rw		= READ;
 		io->bio.bi_end_io	= read_dirty_endio;
 
-		if (bch_bio_alloc_pages(&io->bio, GFP_KERNEL))
+		if (bio_alloc_pages(&io->bio, GFP_KERNEL))
 			goto err_free;
 
 		pr_debug("%s", pkey(&w->key));
-- 
1.8.3.rc1

