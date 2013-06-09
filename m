Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3FICVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:21:15 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52024 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3FICUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:20:11 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 24/26] bcache: generic_make_request() handles large bios now
Date: Sat,  8 Jun 2013 19:19:06 -0700
Message-Id: <1370744348-15407-25-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we get to delete our hacky workaround.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/bcache/bcache.h    |  18 --------
 drivers/md/bcache/debug.c     |   2 +-
 drivers/md/bcache/io.c        | 100 +-----------------------------------------
 drivers/md/bcache/journal.c   |   4 +-
 drivers/md/bcache/request.c   |  14 +++---
 drivers/md/bcache/super.c     |  40 ++---------------
 drivers/md/bcache/util.h      |   4 +-
 drivers/md/bcache/writeback.c |   4 +-
 8 files changed, 19 insertions(+), 167 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 14aaff5..384a800 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -407,19 +407,6 @@ struct keybuf {
 	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
 };
 
-struct bio_split_pool {
-	struct bio_set		*bio_split;
-	mempool_t		*bio_split_hook;
-};
-
-struct bio_split_hook {
-	struct closure		cl;
-	struct bio_split_pool	*p;
-	struct bio		*bio;
-	bio_end_io_t		*bi_end_io;
-	void			*bi_private;
-};
-
 struct bcache_device {
 	struct closure		cl;
 
@@ -450,8 +437,6 @@ struct bcache_device {
 	int (*cache_miss)(struct btree *, struct search *,
 			  struct bio *, unsigned);
 	int (*ioctl) (struct bcache_device *, fmode_t, unsigned, unsigned long);
-
-	struct bio_split_pool	bio_split_hook;
 };
 
 struct io {
@@ -639,8 +624,6 @@ struct cache {
 	atomic_long_t		meta_sectors_written;
 	atomic_long_t		btree_sectors_written;
 	atomic_long_t		sectors_written;
-
-	struct bio_split_pool	bio_split_hook;
 };
 
 struct gc_stat {
@@ -1184,7 +1167,6 @@ void bch_bbio_endio(struct cache_set *, struct bio *, int, const char *);
 void bch_bbio_free(struct bio *, struct cache_set *);
 struct bio *bch_bbio_alloc(struct cache_set *);
 
-void bch_generic_make_request(struct bio *, struct bio_split_pool *);
 void __bch_submit_bbio(struct bio *, struct cache_set *);
 void bch_submit_bbio(struct bio *, struct cache_set *, struct bkey *, unsigned);
 
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 2077848..3b60e60 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -204,7 +204,7 @@ void bch_data_verify(struct search *s)
 	check->bi_private	= cl;
 	check->bi_end_io	= data_verify_endio;
 
-	closure_bio_submit(check, cl, &dc->disk);
+	closure_bio_submit(check, cl);
 	closure_sync(cl);
 
 	bio_for_each_segment(bv, s->orig_bio, iter) {
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index e3c582d..4b4d1fa 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -9,104 +9,6 @@
 #include "bset.h"
 #include "debug.h"
 
-static unsigned bch_bio_max_sectors(struct bio *bio)
-{
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	struct bio_vec bv;
-	struct bvec_iter iter;
-	unsigned ret = 0, seg = 0;
-
-	if (bio->bi_rw & REQ_DISCARD)
-		return min(bio_sectors(bio), q->limits.max_discard_sectors);
-
-	bio_for_each_segment(bv, bio, iter) {
-		struct bvec_merge_data bvm = {
-			.bi_bdev	= bio->bi_bdev,
-			.bi_sector	= bio->bi_iter.bi_sector,
-			.bi_size	= ret << 9,
-			.bi_rw		= bio->bi_rw,
-		};
-
-		if (seg == min_t(unsigned, BIO_MAX_PAGES,
-				 queue_max_segments(q)))
-			break;
-
-		if (q->merge_bvec_fn &&
-		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
-			break;
-
-		seg++;
-		ret += bv.bv_len >> 9;
-	}
-
-	ret = min(ret, queue_max_sectors(q));
-
-	WARN_ON(!ret);
-	ret = max_t(int, ret, bio_iovec(bio).bv_len >> 9);
-
-	return ret;
-}
-
-static void bch_bio_submit_split_done(struct closure *cl)
-{
-	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
-
-	s->bio->bi_end_io = s->bi_end_io;
-	s->bio->bi_private = s->bi_private;
-	s->bio->bi_end_io(s->bio, 0);
-
-	closure_debug_destroy(&s->cl);
-	mempool_free(s, s->p->bio_split_hook);
-}
-
-static void bch_bio_submit_split_endio(struct bio *bio, int error)
-{
-	struct closure *cl = bio->bi_private;
-	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
-
-	if (error)
-		clear_bit(BIO_UPTODATE, &s->bio->bi_flags);
-
-	bio_put(bio);
-	closure_put(cl);
-}
-
-void bch_generic_make_request(struct bio *bio, struct bio_split_pool *p)
-{
-	struct bio_split_hook *s;
-	struct bio *n;
-
-	if (!bio_has_data(bio) && !(bio->bi_rw & REQ_DISCARD))
-		goto submit;
-
-	if (bio_sectors(bio) <= bch_bio_max_sectors(bio))
-		goto submit;
-
-	s = mempool_alloc(p->bio_split_hook, GFP_NOIO);
-	closure_init(&s->cl, NULL);
-
-	s->bio		= bio;
-	s->p		= p;
-	s->bi_end_io	= bio->bi_end_io;
-	s->bi_private	= bio->bi_private;
-	bio_get(bio);
-
-	do {
-		n = bio_next_split(bio, bch_bio_max_sectors(bio),
-				   GFP_NOIO, s->p->bio_split);
-
-		n->bi_end_io	= bch_bio_submit_split_endio;
-		n->bi_private	= &s->cl;
-
-		closure_get(&s->cl);
-		generic_make_request(n);
-	} while (n != bio);
-
-	continue_at(&s->cl, bch_bio_submit_split_done, NULL);
-submit:
-	generic_make_request(bio);
-}
-
 /* Bios with headers */
 
 void bch_bbio_free(struct bio *bio, struct cache_set *c)
@@ -136,7 +38,7 @@ void __bch_submit_bbio(struct bio *bio, struct cache_set *c)
 	bio->bi_bdev		= PTR_CACHE(c, &b->key, 0)->bdev;
 
 	b->submit_time_us = local_clock_us();
-	closure_bio_submit(bio, bio->bi_private, PTR_CACHE(c, &b->key, 0));
+	closure_bio_submit(bio, bio->bi_private);
 }
 
 void bch_submit_bbio(struct bio *bio, struct cache_set *c,
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 724cb7a..c52e1cf 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -56,7 +56,7 @@ reread:		left = ca->sb.bucket_size - offset;
 		bio->bi_private = &op->cl;
 		bch_bio_map(bio, data);
 
-		closure_bio_submit(bio, &op->cl, ca);
+		closure_bio_submit(bio, &op->cl);
 		closure_sync(&op->cl);
 
 		/* This function could be simpler now since we no longer write
@@ -639,7 +639,7 @@ static void journal_write_unlocked(struct closure *cl)
 	spin_unlock(&c->journal.lock);
 
 	while ((bio = bio_list_pop(&list)))
-		closure_bio_submit(bio, cl, c->cache[0]);
+		closure_bio_submit(bio, cl);
 
 	continue_at(cl, journal_write_done, NULL);
 }
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 3c95b0e..762a143 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -779,7 +779,7 @@ static void request_read_error(struct closure *cl)
 		/* XXX: invalidate cache */
 
 		trace_bcache_read_retry(&s->bio.bio);
-		closure_bio_submit(&s->bio.bio, &s->cl, s->d);
+		closure_bio_submit(&s->bio.bio, &s->cl);
 	}
 
 	continue_at(cl, cached_dev_read_complete, NULL);
@@ -903,14 +903,14 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	bio_get(s->op.cache_bio);
 
 	trace_bcache_cache_miss(s->orig_bio);
-	closure_bio_submit(s->op.cache_bio, &s->cl, s->d);
+	closure_bio_submit(s->op.cache_bio, &s->cl);
 
 	return ret;
 out_put:
 	bio_put(s->op.cache_bio);
 	s->op.cache_bio = NULL;
 out_submit:
-	closure_bio_submit(miss, &s->cl, s->d);
+	closure_bio_submit(miss, &s->cl);
 	return ret;
 }
 
@@ -978,7 +978,7 @@ static void request_write(struct cached_dev *dc, struct search *s)
 						   dc->disk.bio_split);
 
 		trace_bcache_writethrough(s->orig_bio);
-		closure_bio_submit(bio, cl, s->d);
+		closure_bio_submit(bio, cl);
 	} else {
 		s->op.cache_bio = bio;
 		trace_bcache_writeback(s->orig_bio);
@@ -997,7 +997,7 @@ skip:
 	    !blk_queue_discard(bdev_get_queue(dc->bdev)))
 		goto out;
 
-	closure_bio_submit(bio, cl, s->d);
+	closure_bio_submit(bio, cl);
 	goto out;
 }
 
@@ -1014,7 +1014,7 @@ static void request_nodata(struct cached_dev *dc, struct search *s)
 	if (s->op.flush_journal)
 		bch_journal_meta(s->op.c, cl);
 
-	closure_bio_submit(bio, cl, s->d);
+	closure_bio_submit(bio, cl);
 
 	continue_at(cl, cached_dev_bio_complete, NULL);
 }
@@ -1171,7 +1171,7 @@ static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
 		    !blk_queue_discard(bdev_get_queue(dc->bdev)))
 			bio_endio(bio, 0);
 		else
-			bch_generic_make_request(bio, &d->bio_split_hook);
+			generic_make_request(bio);
 	}
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 668b50e..e67b839 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -62,29 +62,6 @@ struct workqueue_struct *bcache_wq;
 
 #define BTREE_MAX_PAGES		(256 * 1024 / PAGE_SIZE)
 
-static void bio_split_pool_free(struct bio_split_pool *p)
-{
-	if (p->bio_split_hook)
-		mempool_destroy(p->bio_split_hook);
-
-	if (p->bio_split)
-		bioset_free(p->bio_split);
-}
-
-static int bio_split_pool_init(struct bio_split_pool *p)
-{
-	p->bio_split = bioset_create(4, 0);
-	if (!p->bio_split)
-		return -ENOMEM;
-
-	p->bio_split_hook = mempool_create_kmalloc_pool(4,
-				sizeof(struct bio_split_hook));
-	if (!p->bio_split_hook)
-		return -ENOMEM;
-
-	return 0;
-}
-
 /* Superblock */
 
 static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
@@ -515,7 +492,7 @@ static void prio_io(struct cache *ca, uint64_t bucket, unsigned long rw)
 	bio->bi_private = ca;
 	bch_bio_map(bio, ca->disk_buckets);
 
-	closure_bio_submit(bio, &ca->prio, ca);
+	closure_bio_submit(bio, &ca->prio);
 	closure_sync(cl);
 }
 
@@ -739,8 +716,6 @@ static void bcache_device_free(struct bcache_device *d)
 		blk_cleanup_queue(d->disk->queue);
 	if (d->disk)
 		put_disk(d->disk);
-
-	bio_split_pool_free(&d->bio_split_hook);
 	if (d->bio_split)
 		bioset_free(d->bio_split);
 
@@ -752,12 +727,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size)
 	struct request_queue *q;
 
 	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
-	    bio_split_pool_init(&d->bio_split_hook))
-
-		return -ENOMEM;
-
-	d->disk = alloc_disk(1);
-	if (!d->disk)
+	    !(d->disk = alloc_disk(1)))
 		return -ENOMEM;
 
 	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", bcache_minor);
@@ -785,6 +755,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size)
 	q->limits.physical_block_size	= block_size;
 	set_bit(QUEUE_FLAG_NONROT,	&d->disk->queue->queue_flags);
 	set_bit(QUEUE_FLAG_DISCARD,	&d->disk->queue->queue_flags);
+	set_bit(QUEUE_FLAG_LARGEBIOS,	&d->disk->queue->queue_flags);
 
 	return 0;
 }
@@ -1682,8 +1653,6 @@ void bch_cache_release(struct kobject *kobj)
 
 	bch_cache_allocator_exit(ca);
 
-	bio_split_pool_free(&ca->bio_split_hook);
-
 	if (ca->alloc_workqueue)
 		destroy_workqueue(ca->alloc_workqueue);
 
@@ -1743,8 +1712,7 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 	    !(ca->prio_buckets	= kzalloc(sizeof(uint64_t) * prio_buckets(ca) *
 					  2, GFP_KERNEL)) ||
 	    !(ca->disk_buckets	= alloc_bucket_pages(GFP_KERNEL, ca)) ||
-	    !(ca->alloc_workqueue = alloc_workqueue("bch_allocator", 0, 1)) ||
-	    bio_split_pool_init(&ca->bio_split_hook))
+	    !(ca->alloc_workqueue = alloc_workqueue("bch_allocator", 0, 1)))
 		goto err;
 
 	ca->prio_last_buckets = ca->prio_buckets + prio_buckets(ca);
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index c9b3806..e78d4c5 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -573,10 +573,10 @@ static inline sector_t bdev_sectors(struct block_device *bdev)
 	return bdev->bd_inode->i_size >> 9;
 }
 
-#define closure_bio_submit(bio, cl, dev)				\
+#define closure_bio_submit(bio, cl)					\
 do {									\
 	closure_get(cl);						\
-	bch_generic_make_request(bio, &(dev)->bio_split_hook);		\
+	generic_make_request(bio);					\
 } while (0)
 
 uint64_t bch_crc64_update(uint64_t, const void *, size_t);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 61bc071..b4719f1 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -277,7 +277,7 @@ static void write_dirty(struct closure *cl)
 	io->bio.bi_end_io	= dirty_endio;
 
 	trace_bcache_write_dirty(&io->bio);
-	closure_bio_submit(&io->bio, cl, &io->dc->disk);
+	closure_bio_submit(&io->bio, cl);
 
 	continue_at(cl, write_dirty_finish, dirty_wq);
 }
@@ -298,7 +298,7 @@ static void read_dirty_submit(struct closure *cl)
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
 
 	trace_bcache_read_dirty(&io->bio);
-	closure_bio_submit(&io->bio, cl, &io->dc->disk);
+	closure_bio_submit(&io->bio, cl);
 
 	continue_at(cl, write_dirty, dirty_wq);
 }
-- 
1.8.3.rc1

