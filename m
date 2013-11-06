Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3KFDsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:48:24 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52375 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3KFDsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:48:23 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] block: Revert bio_clone() default behaviour
Date: Tue,  5 Nov 2013 19:48:41 -0800
Message-Id: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts the default behaviour introduced by
9fc6286f347d00528adcdcf12396d220f47492ed - bio_clone_biovec() no clonger
shares the source bio's biovec, cloning the biovec is once again the
default.

Instead, we add a new bio_clone_biovec_fast(), which creates a clone
that shares the source's biovec. This patch changes bcache and md to use
__bio_clone_biovec_fast() since they're expecting the new behaviour due
to other refactoring; most of the other uses of bio_clone() should be
same to convert to the _fast() variant but that will be done more
incrementally in other patches (bio_split() in particular).

Note that __bio_clone() isn't being readded - the reason being that with
immutable biovecs allocating the right number of biovecs for the new
clone is no longer trivial so we don't want drivers trying to do that
themselves.

This patch also reverts febca1baea1cfe2d7a0271385d89b03d5fb34f94 -
__bio_clone_fast() should not be setting bi_vcnt for bios that do not
own the biovec (see Documentation/block/biovecs.txt for rationale) - in
short, not setting it might cause bugs in the short term but long term
it's likely to hide nastier more subtle bugs, we don't want code looking
at bi_vcnt at all for bios it does not own. However, this patch
_shouldn't_ cause any regressions because of this since we're reverting
back to the old bio_clone() behaviour.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Olof Johansson <olof@lixom.net>
---
Chris, Olaf, can you two in particular test this? I have tested the bounce
buffer code (and bcache), but Jens told me today there was an md bug that I
_still_ can't find any emails about so I'm not sure what to test for that.

 drivers/md/bcache/request.c |   6 +--
 drivers/md/dm.c             |   4 +-
 fs/bio.c                    | 104 +++++++++++++++++++++++++++-----------------
 include/linux/bio.h         |   6 +--
 mm/bounce.c                 |   1 -
 5 files changed, 72 insertions(+), 49 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 52a1fef..ef44198 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -681,7 +681,7 @@ static void do_bio_hook(struct search *s)
 	struct bio *bio = &s->bio.bio;
 
 	bio_init(bio);
-	__bio_clone(bio, s->orig_bio);
+	__bio_clone_fast(bio, s->orig_bio);
 	bio->bi_end_io		= request_endio;
 	bio->bi_private		= &s->cl;
 
@@ -969,8 +969,8 @@ static void request_write(struct cached_dev *dc, struct search *s)
 	trace_bcache_write(s->orig_bio, s->writeback, s->op.skip);
 
 	if (!s->writeback) {
-		s->op.cache_bio = bio_clone_bioset(bio, GFP_NOIO,
-						   dc->disk.bio_split);
+		s->op.cache_bio = bio_clone_bioset_fast(bio, GFP_NOIO,
+							dc->disk.bio_split);
 
 		closure_bio_submit(bio, cl, s->d);
 	} else {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8e6174c..bafe7ed 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1135,7 +1135,7 @@ static void clone_bio(struct dm_target_io *tio, struct bio *bio,
 {
 	struct bio *clone = &tio->clone;
 
-	__bio_clone(clone, bio);
+	__bio_clone_fast(clone, bio);
 
 	if (bio_integrity(bio))
 		bio_integrity_clone(clone, bio, GFP_NOIO);
@@ -1177,7 +1177,7 @@ static void __clone_and_map_simple_bio(struct clone_info *ci,
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
-	 __bio_clone(clone, ci->bio);
+	 __bio_clone_fast(clone, ci->bio);
 	if (len)
 		bio_setup_sector(clone, ci->sector, len);
 
diff --git a/fs/bio.c b/fs/bio.c
index 6046c91..99ff176 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -539,15 +539,17 @@ inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
 EXPORT_SYMBOL(bio_phys_segments);
 
 /**
- * 	__bio_clone	-	clone a bio
+ * 	__bio_clone_fast - clone a bio that shares the original bio's biovec
  * 	@bio: destination bio
  * 	@bio_src: bio to clone
  *
  *	Clone a &bio. Caller will own the returned bio, but not
  *	the actual data it points to. Reference count of returned
  * 	bio will be one.
+ *
+ * 	Caller must ensure that @bio_src is not freed before @bio.
  */
-void __bio_clone(struct bio *bio, struct bio *bio_src)
+void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 {
 	BUG_ON(bio->bi_pool && BIO_POOL_IDX(bio) != BIO_POOL_NONE);
 
@@ -560,20 +562,19 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
-	bio->bi_vcnt = bio_src->bi_vcnt;
 }
-EXPORT_SYMBOL(__bio_clone);
+EXPORT_SYMBOL(__bio_clone_fast);
 
 /**
- *	bio_clone_bioset -	clone a bio
+ *	bio_clone_bioset_fast -	clone a bio that shares the original bio's biovec
  *	@bio: bio to clone
  *	@gfp_mask: allocation priority
  *	@bs: bio_set to allocate from
  *
- * 	Like __bio_clone, only also allocates the returned bio
+ * 	Like __bio_clone_fast, only also allocates the returned bio
  */
-struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
-			     struct bio_set *bs)
+struct bio *bio_clone_bioset_fast(struct bio *bio, gfp_t gfp_mask,
+				  struct bio_set *bs)
 {
 	struct bio *b;
 
@@ -581,7 +582,7 @@ struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 	if (!b)
 		return NULL;
 
-	__bio_clone(b, bio);
+	__bio_clone_fast(b, bio);
 
 	if (bio_integrity(bio)) {
 		int ret;
@@ -596,53 +597,76 @@ struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 
 	return b;
 }
-EXPORT_SYMBOL(bio_clone_bioset);
+EXPORT_SYMBOL(bio_clone_bioset_fast);
 
 /**
- * bio_clone_biovec: Given a cloned bio, give the clone its own copy of the
- * biovec
- * @bio: cloned bio
+ * 	bio_clone_bioset - clone a bio
+ * 	@bio_src: bio to clone
+ *	@gfp_mask: allocation priority
+ *	@bs: bio_set to allocate from
  *
- * @bio must have been allocated from a bioset - i.e. returned from
- * bio_clone_bioset()
+ *	Clone a &bio. Caller will own the returned bio, but not
+ *	the actual data it points to. Reference count of returned
+ * 	bio will be one.
  */
-int bio_clone_biovec(struct bio *bio, gfp_t gfp_mask)
+struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
+			     struct bio_set *bs)
 {
-	unsigned long idx = BIO_POOL_NONE;
 	unsigned nr_iovecs = 0;
-	struct bio_vec bv, *bvl = NULL;
 	struct bvec_iter iter;
-	int i;
+	struct bio_vec bv;
+	struct bio *bio;
 
-	BUG_ON(!bio->bi_pool);
-	BUG_ON(BIO_POOL_IDX(bio) != BIO_POOL_NONE);
+	/*
+	 * Pre immutable biovecs, __bio_clone() used to just do a memcpy from
+	 * bio_src->bi_io_vec to bio->bi_io_vec.
+	 *
+	 * We can't do that anymore, because:
+	 *
+	 *  - The point of cloning the biovec is to produce a bio with a biovec
+	 *    the caller can modify: bi_idx and bi_bvec_done should be 0.
+	 *
+	 *  - The original bio could've had more than BIO_MAX_PAGES biovecs; if
+	 *    we tried to clone the whole thing bio_alloc_bioset() would fail.
+	 *    But the clone should succeed as long as the number of biovecs we
+	 *    actually need to allocate is fewer than BIO_MAX_PAGES.
+	 *
+	 *  - Lastly, bi_vcnt should not be looked at or relied upon by code
+	 *    that does not own the bio - reason being drivers don't use it for
+	 *    iterating over the biovec anymore, so expecting it to be kept up
+	 *    to date (i.e. for clones that share the parent biovec) is just
+	 *    asking for trouble and would force extra work on
+	 *    __bio_clone_fast() anyways.
+	 */
 
-	bio_for_each_segment(bv, bio, iter)
+	bio_for_each_segment(bv, bio_src, iter)
 		nr_iovecs++;
 
-	if (nr_iovecs > BIO_INLINE_VECS) {
-		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx,
-				 bio->bi_pool->bvec_pool);
-		if (!bvl)
-			return -ENOMEM;
-	} else if (nr_iovecs) {
-		bvl = bio->bi_inline_vecs;
-	}
+	bio = bio_alloc_bioset(gfp_mask, nr_iovecs, bs);
+	if (!bio)
+		return NULL;
 
-	i = 0;
-	bio_for_each_segment(bv, bio, iter)
-		bvl[i++] = bv;
+	bio->bi_bdev		= bio_src->bi_bdev;
+	bio->bi_rw		= bio_src->bi_rw;
+	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
+	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
-	bio->bi_io_vec = bvl;
-	bio->bi_iter.bi_idx = 0;
-	bio->bi_iter.bi_bvec_done = 0;
+	bio_for_each_segment(bv, bio_src, iter)
+		bio->bi_io_vec[bio->bi_vcnt++] = bv;
 
-	bio->bi_flags &= BIO_POOL_MASK - 1;
-	bio->bi_flags |= idx << BIO_POOL_OFFSET;
+	if (bio_integrity(bio_src)) {
+		int ret;
 
-	return 0;
+		ret = bio_integrity_clone(bio, bio_src, gfp_mask);
+		if (ret < 0) {
+			bio_put(bio);
+			return NULL;
+		}
+	}
+
+	return bio;
 }
-EXPORT_SYMBOL(bio_clone_biovec);
+EXPORT_SYMBOL(bio_clone_bioset);
 
 /**
  *	bio_get_nr_vecs		- return approx number of vecs
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 204489e..434ac76 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -327,9 +327,9 @@ extern mempool_t *biovec_create_pool(struct bio_set *bs, int pool_entries);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
 
-extern void __bio_clone(struct bio *, struct bio *);
-extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
-extern int bio_clone_biovec(struct bio *bio, gfp_t gfp_mask);
+extern void __bio_clone_fast(struct bio *, struct bio *);
+extern struct bio *bio_clone_bioset_fast(struct bio *, gfp_t, struct bio_set *);
+extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *);
 
 extern struct bio_set *fs_bio_set;
 
diff --git a/mm/bounce.c b/mm/bounce.c
index d5873f2..523918b 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -211,7 +211,6 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	return;
 bounce:
 	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
-	bio_clone_biovec(bio, GFP_NOIO);
 
 	bio_for_each_segment_all(to, bio, i) {
 		struct page *page = to->bv_page;
-- 
1.8.4.2

