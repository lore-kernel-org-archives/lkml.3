Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3C0RlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:41:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32910 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3C0Rk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:59 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 22/22] block: Don't copy bvecs when cloning bios, just share them
Date: Wed, 27 Mar 2013 10:39:52 -0700
Message-Id: <1364405992-28424-23-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that immutable biovecs are plumbed through, most users of
bio_clone() don't need it to clone the biovec - we can share the
original bio's biovec.

Add bio_clone_biovec() for the users that do need to modify the biovec
(the bounce buffer code).

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  | 35 +++++++++--------------------------
 fs/bio.c            | 47 ++++++++++++++++++++++++++++++++++++++++-------
 include/linux/bio.h |  2 +-
 mm/bounce.c         |  1 +
 4 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 61f41ff..8a17399 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -592,7 +592,6 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 {
 	struct blk_integrity *bi;
 	struct bio_integrity_payload *bip = bio->bi_integrity;
-	unsigned int nr_sectors;
 
 	if (bio_integrity(bio) == 0)
 		return;
@@ -601,27 +600,17 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	BUG_ON(bi == NULL);
 	BUG_ON(bip->bip_vcnt != 1);
 
-	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
-
 	bp->bio1.bi_integrity = &bp->bip1;
 	bp->bio2.bi_integrity = &bp->bip2;
 
-	bp->iv1 = bip->bip_vec[bip->bip_iter.bi_idx];
-	bp->iv2 = bip->bip_vec[bip->bip_iter.bi_idx];
-
-	bp->bip1.bip_vec = &bp->iv1;
-	bp->bip2.bip_vec = &bp->iv2;
+	bp->bip1.bip_vec = bip->bip_vec;
+	bp->bip2.bip_vec = bip->bip_vec;
 
-	bp->iv1.bv_len = sectors * bi->tuple_size;
-	bp->iv2.bv_offset += sectors * bi->tuple_size;
-	bp->iv2.bv_len -= sectors * bi->tuple_size;
+	bp->bip1.bip_iter = bip->bip_iter;
+	bp->bip2.bip_iter = bip->bip_iter;
 
-	bp->bip1.bip_iter.bi_sector = bio->bi_integrity->bip_iter.bi_sector;
-	bp->bip2.bip_iter.bi_sector =
-		bio->bi_integrity->bip_iter.bi_sector + nr_sectors;
-
-	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
-	bp->bip1.bip_iter.bi_idx = bp->bip2.bip_iter.bi_idx = 0;
+	bio_integrity_trim(&bp->bio1, 0, sectors);
+	bio_integrity_advance(&bp->bio2, sectors << 9);
 }
 EXPORT_SYMBOL(bio_integrity_split);
 
@@ -639,17 +628,11 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
 	struct bio_integrity_payload *bip;
 
-	BUG_ON(bip_src == NULL);
-
-	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_vcnt);
-
+	bip = bio_integrity_alloc(bio, gfp_mask, 0);
 	if (bip == NULL)
-		return -EIO;
-
-	memcpy(bip->bip_vec, bip_src->bip_vec,
-	       bip_src->bip_vcnt * sizeof(struct bio_vec));
+		return -ENOMEM;
 
-	bip->bip_vcnt = bip_src->bip_vcnt;
+	bip->bip_vec = bip_src->bip_vec;
 	bip->bip_iter = bip_src->bip_iter;
 
 	return 0;
diff --git a/fs/bio.c b/fs/bio.c
index 6acb7b7..f365405 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -524,20 +524,17 @@ EXPORT_SYMBOL(bio_phys_segments);
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		bio_src->bi_max_vecs * sizeof(struct bio_vec));
+	BUG_ON(BIO_POOL_IDX(bio) != BIO_POOL_NONE);
 
 	/*
 	 * most users will be overriding ->bi_bdev with a new target,
 	 * so we don't set nor calculate new physical/hw segment counts here
 	 */
-	bio->bi_iter.bi_sector = bio_src->bi_iter.bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
-	bio->bi_vcnt = bio_src->bi_vcnt;
-	bio->bi_iter.bi_size = bio_src->bi_iter.bi_size;
-	bio->bi_iter.bi_idx = bio_src->bi_iter.bi_idx;
+	bio->bi_iter = bio_src->bi_iter;
+	bio->bi_io_vec = bio_src->bi_io_vec;
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -554,7 +551,7 @@ struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 {
 	struct bio *b;
 
-	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
+	b = bio_alloc_bioset(gfp_mask, 0, bs);
 	if (!b)
 		return NULL;
 
@@ -575,6 +572,42 @@ struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(bio_clone_bioset);
 
+int bio_clone_biovec(struct bio *bio, gfp_t gfp_mask)
+{
+	unsigned long idx = BIO_POOL_NONE;
+	unsigned nr_iovecs = 0;
+	struct bio_vec bv, *bvl = NULL;
+	struct bvec_iter iter;
+
+	BUG_ON(bio->bi_vcnt);
+	BUG_ON(bio->bi_io_vec == bio->bi_inline_vecs ||
+	       BIO_POOL_IDX(bio) != BIO_POOL_NONE);
+
+	bio_for_each_segment(bv, bio, iter)
+		nr_iovecs++;
+
+	if (nr_iovecs > BIO_INLINE_VECS) {
+		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, bio->bi_pool->bvec_pool);
+		if (!bvl)
+			return -ENOMEM;
+	} else if (nr_iovecs) {
+		bvl = bio->bi_inline_vecs;
+	}
+
+	bio_for_each_segment(bv, bio, iter)
+		bvl[bio->bi_vcnt++] = bv;
+
+	bio->bi_io_vec = bvl;
+	bio->bi_iter.bi_idx = 0;
+	bio->bi_iter.bi_bvec_done = 0;
+
+	bio->bi_flags &= BIO_POOL_MASK - 1;
+	bio->bi_flags |= idx << BIO_POOL_OFFSET;
+
+	return 0;
+}
+EXPORT_SYMBOL(bio_clone_biovec);
+
 /**
  *	bio_get_nr_vecs		- return approx number of vecs
  *	@bdev:  I/O target
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 80ffe15..acfab48 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -276,7 +276,6 @@ struct bio_pair {
 	struct bio_vec			bv1, bv2;
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	struct bio_integrity_payload	bip1, bip2;
-	struct bio_vec			iv1, iv2;
 #endif
 	atomic_t			cnt;
 	int				error;
@@ -293,6 +292,7 @@ extern void bio_put(struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
+extern int bio_clone_biovec(struct bio *bio, gfp_t gfp_mask);
 
 extern struct bio_set *fs_bio_set;
 
diff --git a/mm/bounce.c b/mm/bounce.c
index deaf1b0..e60953e 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -228,6 +228,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	return;
 bounce:
 	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
+	bio_clone_biovec(bio, GFP_NOIO);
 
 	bio_for_each_segment_all(to, bio, i) {
 		struct page *page = to->bv_page;
-- 
1.8.1.3

