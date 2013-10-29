Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3J2UT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:19:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3J2USx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:53 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 22/23] block: Kill bio_pair_split()
Date: Tue, 29 Oct 2013 13:18:15 -0700
Message-Id: <1383077896-4132-23-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio-integrity.c  | 45 ---------------------------
 fs/bio.c            | 90 -----------------------------------------------------
 include/linux/bio.h | 30 ------------------
 3 files changed, 165 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 9d547d2..80d972d 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -581,51 +581,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
 EXPORT_SYMBOL(bio_integrity_trim);
 
 /**
- * bio_integrity_split - Split integrity metadata
- * @bio:	Protected bio
- * @bp:		Resulting bio_pair
- * @sectors:	Offset
- *
- * Description: Splits an integrity page into a bio_pair.
- */
-void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
-{
-	struct blk_integrity *bi;
-	struct bio_integrity_payload *bip = bio->bi_integrity;
-	unsigned int nr_sectors;
-
-	if (bio_integrity(bio) == 0)
-		return;
-
-	bi = bdev_get_integrity(bio->bi_bdev);
-	BUG_ON(bi == NULL);
-	BUG_ON(bip->bip_vcnt != 1);
-
-	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
-
-	bp->bio1.bi_integrity = &bp->bip1;
-	bp->bio2.bi_integrity = &bp->bip2;
-
-	bp->iv1 = bip->bip_vec[bip->bip_iter.bi_idx];
-	bp->iv2 = bip->bip_vec[bip->bip_iter.bi_idx];
-
-	bp->bip1.bip_vec = &bp->iv1;
-	bp->bip2.bip_vec = &bp->iv2;
-
-	bp->iv1.bv_len = sectors * bi->tuple_size;
-	bp->iv2.bv_offset += sectors * bi->tuple_size;
-	bp->iv2.bv_len -= sectors * bi->tuple_size;
-
-	bp->bip1.bip_iter.bi_sector = bio->bi_integrity->bip_iter.bi_sector;
-	bp->bip2.bip_iter.bi_sector =
-		bio->bi_integrity->bip_iter.bi_sector + nr_sectors;
-
-	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
-	bp->bip1.bip_iter.bi_idx = bp->bip2.bip_iter.bi_idx = 0;
-}
-EXPORT_SYMBOL(bio_integrity_split);
-
-/**
  * bio_integrity_clone - Callback for cloning bios with integrity metadata
  * @bio:	New bio
  * @bio_src:	Original bio
diff --git a/fs/bio.c b/fs/bio.c
index a840f08..fa427c7 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -38,8 +38,6 @@
  */
 #define BIO_INLINE_VECS		4
 
-static mempool_t *bio_split_pool __read_mostly;
-
 /*
  * if you change this list, also change bvec_alloc or things will
  * break badly! cannot be bigger than what you can fit into an
@@ -1831,89 +1829,6 @@ out:
 }
 EXPORT_SYMBOL(bio_split);
 
-void bio_pair_release(struct bio_pair *bp)
-{
-	if (atomic_dec_and_test(&bp->cnt)) {
-		struct bio *master = bp->bio1.bi_private;
-
-		bio_endio(master, bp->error);
-		mempool_free(bp, bp->bio2.bi_private);
-	}
-}
-EXPORT_SYMBOL(bio_pair_release);
-
-static void bio_pair_end_1(struct bio *bi, int err)
-{
-	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
-
-	if (err)
-		bp->error = err;
-
-	bio_pair_release(bp);
-}
-
-static void bio_pair_end_2(struct bio *bi, int err)
-{
-	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
-
-	if (err)
-		bp->error = err;
-
-	bio_pair_release(bp);
-}
-
-/*
- * split a bio - only worry about a bio with a single page in its iovec
- */
-struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
-{
-	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
-
-	if (!bp)
-		return bp;
-
-	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
-				bi->bi_iter.bi_sector + first_sectors);
-
-	BUG_ON(bio_multiple_segments(bi));
-	atomic_set(&bp->cnt, 3);
-	bp->error = 0;
-	bp->bio1 = *bi;
-	bp->bio2 = *bi;
-	bp->bio2.bi_iter.bi_sector += first_sectors;
-	bp->bio2.bi_iter.bi_size -= first_sectors << 9;
-	bp->bio1.bi_iter.bi_size = first_sectors << 9;
-
-	if (bi->bi_vcnt != 0) {
-		bp->bv1 = bio_iovec(bi);
-		bp->bv2 = bio_iovec(bi);
-
-		if (bio_is_rw(bi)) {
-			bp->bv2.bv_offset += first_sectors << 9;
-			bp->bv2.bv_len -= first_sectors << 9;
-			bp->bv1.bv_len = first_sectors << 9;
-		}
-
-		bp->bio1.bi_io_vec = &bp->bv1;
-		bp->bio2.bi_io_vec = &bp->bv2;
-
-		bp->bio1.bi_max_vecs = 1;
-		bp->bio2.bi_max_vecs = 1;
-	}
-
-	bp->bio1.bi_end_io = bio_pair_end_1;
-	bp->bio2.bi_end_io = bio_pair_end_2;
-
-	bp->bio1.bi_private = bi;
-	bp->bio2.bi_private = bio_split_pool;
-
-	if (bio_integrity(bi))
-		bio_integrity_split(bi, bp, first_sectors);
-
-	return bp;
-}
-EXPORT_SYMBOL(bio_pair_split);
-
 /**
  * bio_trim - trim a bio
  * @bio:	bio to trim
@@ -2115,11 +2030,6 @@ static int __init init_bio(void)
 	if (bioset_integrity_create(fs_bio_set, BIO_POOL_SIZE))
 		panic("bio: can't create integrity pool\n");
 
-	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
-						     sizeof(struct bio_pair));
-	if (!bio_split_pool)
-		panic("bio: can't create split pool\n");
-
 	return 0;
 }
 subsys_initcall(init_bio);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 157f068..6c52a65 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -297,30 +297,7 @@ struct bio_integrity_payload {
 };
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
-/*
- * A bio_pair is used when we need to split a bio.
- * This can only happen for a bio that refers to just one
- * page of data, and in the unusual situation when the
- * page crosses a chunk/device boundary
- *
- * The address of the master bio is stored in bio1.bi_private
- * The address of the pool the pair was allocated from is stored
- *   in bio2.bi_private
- */
-struct bio_pair {
-	struct bio			bio1, bio2;
-	struct bio_vec			bv1, bv2;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	struct bio_integrity_payload	bip1, bip2;
-	struct bio_vec			iv1, iv2;
-#endif
-	atomic_t			cnt;
-	int				error;
-};
-extern struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors);
-extern void bio_pair_release(struct bio_pair *dbio);
 extern void bio_trim(struct bio *bio, int offset, int size);
-
 extern struct bio *bio_split(struct bio *bio, int sectors,
 			     gfp_t gfp, struct bio_set *bs);
 
@@ -674,7 +651,6 @@ extern int bio_integrity_prep(struct bio *);
 extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
-extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
 extern int bioset_integrity_create(struct bio_set *, int);
 extern void bioset_integrity_free(struct bio_set *);
@@ -718,12 +694,6 @@ static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	return 0;
 }
 
-static inline void bio_integrity_split(struct bio *bio, struct bio_pair *bp,
-				       int sectors)
-{
-	return;
-}
-
 static inline void bio_integrity_advance(struct bio *bio,
 					 unsigned int bytes_done)
 {
-- 
1.8.4.rc3

