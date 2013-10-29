Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3J2UTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:19:34 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60655 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3J2USz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:55 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 23/23] block: Don't save/copy bvec array anymore, share when cloning
Date: Tue, 29 Oct 2013 13:18:16 -0700
Message-Id: <1383077896-4132-24-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that drivers have been converted to the bvec_iter primitives, they
shouldn't be modifying the biovec anymore and thus saving it is
unnecessary - code that was previously making a backup of the bvec array
can now just save bio->bi_iter.

Also, when cloning bios we can usually just reuse the original bio's
bvec array. For code that does need to modify the clone's biovec (the
bounce buffer code, mainly), add bio_clone_biovec().

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/bcache/request.c |   2 -
 drivers/md/bcache/request.h |   1 -
 drivers/md/dm-bio-record.h  |  25 -------
 drivers/md/dm.c             |   2 +-
 fs/bio-integrity.c          |  12 +---
 fs/bio.c                    | 162 ++++++++++++++++++--------------------------
 include/linux/bio.h         |   1 +
 mm/bounce.c                 |   1 +
 8 files changed, 72 insertions(+), 134 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 417b37b..52a1fef 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -681,8 +681,6 @@ static void do_bio_hook(struct search *s)
 	struct bio *bio = &s->bio.bio;
 
 	bio_init(bio);
-	bio->bi_io_vec		= s->bv;
-	bio->bi_max_vecs	= BIO_MAX_PAGES;
 	__bio_clone(bio, s->orig_bio);
 	bio->bi_end_io		= request_endio;
 	bio->bi_private		= &s->cl;
diff --git a/drivers/md/bcache/request.h b/drivers/md/bcache/request.h
index bee95a9..6bcdf33 100644
--- a/drivers/md/bcache/request.h
+++ b/drivers/md/bcache/request.h
@@ -26,7 +26,6 @@ struct search {
 
 	/* Anything past op->keys won't get zeroed in do_bio_hook */
 	struct btree_op		op;
-	struct bio_vec		bv[BIO_MAX_PAGES];
 };
 
 void bch_cache_read_endio(struct bio *, int);
diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index 4f46e8e..dd36461 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -17,49 +17,24 @@
  * original bio state.
  */
 
-struct dm_bio_vec_details {
-#if PAGE_SIZE < 65536
-	__u16 bv_len;
-	__u16 bv_offset;
-#else
-	unsigned bv_len;
-	unsigned bv_offset;
-#endif
-};
-
 struct dm_bio_details {
 	struct block_device *bi_bdev;
 	unsigned long bi_flags;
 	struct bvec_iter bi_iter;
-	struct dm_bio_vec_details bi_io_vec[BIO_MAX_PAGES];
 };
 
 static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 {
-	unsigned i;
-
 	bd->bi_bdev = bio->bi_bdev;
 	bd->bi_flags = bio->bi_flags;
 	bd->bi_iter = bio->bi_iter;
-
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		bd->bi_io_vec[i].bv_len = bio->bi_io_vec[i].bv_len;
-		bd->bi_io_vec[i].bv_offset = bio->bi_io_vec[i].bv_offset;
-	}
 }
 
 static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 {
-	unsigned i;
-
 	bio->bi_bdev = bd->bi_bdev;
 	bio->bi_flags = bd->bi_flags;
 	bio->bi_iter = bd->bi_iter;
-
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		bio->bi_io_vec[i].bv_len = bd->bi_io_vec[i].bv_len;
-		bio->bi_io_vec[i].bv_offset = bd->bi_io_vec[i].bv_offset;
-	}
 }
 
 #endif
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index af20a84..8e6174c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1220,7 +1220,7 @@ static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti
 		num_target_bios = ti->num_write_bios(ti, bio);
 
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
-		tio = alloc_tio(ci, ti, bio_segments(bio), target_bio_nr);
+		tio = alloc_tio(ci, ti, 0, target_bio_nr);
 		clone_bio(tio, bio, sector, len);
 		__map_bio(tio);
 	}
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 80d972d..31f2d5a 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -594,17 +594,11 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
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
index fa427c7..82e8c1c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -549,17 +549,7 @@ EXPORT_SYMBOL(bio_phys_segments);
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	if (bio_is_rw(bio_src)) {
-		struct bio_vec bv;
-		struct bvec_iter iter;
-
-		bio_for_each_segment(bv, bio_src, iter)
-			bio->bi_io_vec[bio->bi_vcnt++] = bv;
-	} else if (bio_has_data(bio_src)) {
-		memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		       bio_src->bi_max_vecs * sizeof(struct bio_vec));
-		bio->bi_vcnt = bio_src->bi_vcnt;
-	}
+	BUG_ON(bio->bi_pool && BIO_POOL_IDX(bio) != BIO_POOL_NONE);
 
 	/*
 	 * most users will be overriding ->bi_bdev with a new target,
@@ -569,6 +559,7 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_iter = bio_src->bi_iter;
+	bio->bi_io_vec = bio_src->bi_io_vec;
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -585,7 +576,7 @@ struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 {
 	struct bio *b;
 
-	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
+	b = bio_alloc_bioset(gfp_mask, 0, bs);
 	if (!b)
 		return NULL;
 
@@ -607,6 +598,50 @@ struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 EXPORT_SYMBOL(bio_clone_bioset);
 
 /**
+ * bio_clone_biovec: Given a cloned bio, give the clone its own copy of the
+ * biovec
+ * @bio: cloned bio
+ *
+ * @bio must have been allocated from a bioset - i.e. returned from
+ * bio_clone_bioset()
+ */
+int bio_clone_biovec(struct bio *bio, gfp_t gfp_mask)
+{
+	unsigned long idx = BIO_POOL_NONE;
+	unsigned nr_iovecs = 0;
+	struct bio_vec bv, *bvl = NULL;
+	struct bvec_iter iter;
+
+	BUG_ON(!bio->bi_pool);
+	BUG_ON(BIO_POOL_IDX(bio) != BIO_POOL_NONE);
+
+	bio_for_each_segment(bv, bio, iter)
+		nr_iovecs++;
+
+	if (nr_iovecs > BIO_INLINE_VECS) {
+		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx,
+				 bio->bi_pool->bvec_pool);
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
+/**
  *	bio_get_nr_vecs		- return approx number of vecs
  *	@bdev:  I/O target
  *
@@ -931,60 +966,33 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 EXPORT_SYMBOL(bio_copy_data);
 
 struct bio_map_data {
-	struct bio_vec *iovecs;
-	struct sg_iovec *sgvecs;
 	int nr_sgvecs;
 	int is_our_pages;
+	struct sg_iovec sgvecs[];
 };
 
 static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
 			     struct sg_iovec *iov, int iov_count,
 			     int is_our_pages)
 {
-	memcpy(bmd->iovecs, bio->bi_io_vec, sizeof(struct bio_vec) * bio->bi_vcnt);
 	memcpy(bmd->sgvecs, iov, sizeof(struct sg_iovec) * iov_count);
 	bmd->nr_sgvecs = iov_count;
 	bmd->is_our_pages = is_our_pages;
 	bio->bi_private = bmd;
 }
 
-static void bio_free_map_data(struct bio_map_data *bmd)
-{
-	kfree(bmd->iovecs);
-	kfree(bmd->sgvecs);
-	kfree(bmd);
-}
-
 static struct bio_map_data *bio_alloc_map_data(int nr_segs,
 					       unsigned int iov_count,
 					       gfp_t gfp_mask)
 {
-	struct bio_map_data *bmd;
-
 	if (iov_count > UIO_MAXIOV)
 		return NULL;
 
-	bmd = kmalloc(sizeof(*bmd), gfp_mask);
-	if (!bmd)
-		return NULL;
-
-	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, gfp_mask);
-	if (!bmd->iovecs) {
-		kfree(bmd);
-		return NULL;
-	}
-
-	bmd->sgvecs = kmalloc(sizeof(struct sg_iovec) * iov_count, gfp_mask);
-	if (bmd->sgvecs)
-		return bmd;
-
-	kfree(bmd->iovecs);
-	kfree(bmd);
-	return NULL;
+	return kmalloc(sizeof(struct bio_map_data) +
+		       sizeof(struct sg_iovec) * iov_count, gfp_mask);
 }
 
-static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
-			  struct sg_iovec *iov, int iov_count,
+static int __bio_copy_iov(struct bio *bio, struct sg_iovec *iov, int iov_count,
 			  int to_user, int from_user, int do_free_page)
 {
 	int ret = 0, i;
@@ -994,7 +1002,7 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		char *bv_addr = page_address(bvec->bv_page);
-		unsigned int bv_len = iovecs[i].bv_len;
+		unsigned int bv_len = bvec->bv_len;
 
 		while (bv_len && iov_idx < iov_count) {
 			unsigned int bytes;
@@ -1054,14 +1062,14 @@ int bio_uncopy_user(struct bio *bio)
 		 * don't copy into a random user address space, just free.
 		 */
 		if (current->mm)
-			ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-					     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
+			ret = __bio_copy_iov(bio, bmd->sgvecs, bmd->nr_sgvecs,
+					     bio_data_dir(bio) == READ,
 					     0, bmd->is_our_pages);
 		else if (bmd->is_our_pages)
 			bio_for_each_segment_all(bvec, bio, i)
 				__free_page(bvec->bv_page);
 	}
-	bio_free_map_data(bmd);
+	kfree(bmd);
 	bio_put(bio);
 	return ret;
 }
@@ -1175,7 +1183,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 1, 0);
+		ret = __bio_copy_iov(bio, iov, iov_count, 0, 1, 0);
 		if (ret)
 			goto cleanup;
 	}
@@ -1189,7 +1197,7 @@ cleanup:
 
 	bio_put(bio);
 out_bmd:
-	bio_free_map_data(bmd);
+	kfree(bmd);
 	return ERR_PTR(ret);
 }
 
@@ -1506,16 +1514,15 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		char *addr = page_address(bvec->bv_page);
-		int len = bmd->iovecs[i].bv_len;
 
 		if (read)
-			memcpy(p, addr, len);
+			memcpy(p, addr, bvec->bv_len);
 
 		__free_page(bvec->bv_page);
-		p += len;
+		p += bvec->bv_len;
 	}
 
-	bio_free_map_data(bmd);
+	kfree(bmd);
 	bio_put(bio);
 }
 
@@ -1766,62 +1773,25 @@ EXPORT_SYMBOL(bio_endio_nodec);
  * Allocates and returns a new bio which represents @sectors from the start of
  * @bio, and updates @bio to represent the remaining sectors.
  *
- * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
- * unchanged.
+ * The newly allocated bio will point to @bio's bi_io_vec; it is the caller's
+ * responsibility to ensure that @bio is not freed before the split.
  */
 struct bio *bio_split(struct bio *bio, int sectors,
 		      gfp_t gfp, struct bio_set *bs)
 {
-	unsigned vcnt = 0, nbytes = sectors << 9;
-	struct bio_vec bv;
-	struct bvec_iter iter;
 	struct bio *split = NULL;
 
 	BUG_ON(sectors <= 0);
 	BUG_ON(sectors >= bio_sectors(bio));
 
-	if (bio->bi_rw & REQ_DISCARD) {
-		split = bio_alloc_bioset(gfp, 1, bs);
-		if (!split)
-			return NULL;
-		goto out;
-	}
-
-	bio_for_each_segment(bv, bio, iter) {
-		vcnt++;
-
-		if (nbytes <= bv.bv_len)
-			break;
-
-		nbytes -= bv.bv_len;
-	}
-
-	split = bio_alloc_bioset(gfp, vcnt, bs);
+	split = bio_clone_bioset(bio, gfp, bs);
 	if (!split)
 		return NULL;
 
-	bio_for_each_segment(bv, bio, iter) {
-		split->bi_io_vec[split->bi_vcnt++] = bv;
-
-		if (split->bi_vcnt == vcnt)
-			break;
-	}
-
-	split->bi_io_vec[split->bi_vcnt - 1].bv_len = nbytes;
-out:
-	split->bi_bdev		= bio->bi_bdev;
-	split->bi_iter.bi_sector = bio->bi_iter.bi_sector;
-	split->bi_iter.bi_size	= sectors << 9;
-	split->bi_rw		= bio->bi_rw;
-
-	if (bio_integrity(bio)) {
-		if (bio_integrity_clone(split, bio, gfp)) {
-			bio_put(split);
-			return NULL;
-		}
+	split->bi_iter.bi_size = sectors << 9;
 
-		bio_integrity_trim(split, 0, bio_sectors(split));
-	}
+	if (bio_integrity(split))
+		bio_integrity_trim(split, 0, sectors);
 
 	bio_advance(bio, split->bi_iter.bi_size);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6c52a65..6d924f3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -329,6 +329,7 @@ extern void bio_put(struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
+extern int bio_clone_biovec(struct bio *bio, gfp_t gfp_mask);
 
 extern struct bio_set *fs_bio_set;
 
diff --git a/mm/bounce.c b/mm/bounce.c
index 523918b..d5873f2 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -211,6 +211,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	return;
 bounce:
 	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
+	bio_clone_biovec(bio, GFP_NOIO);
 
 	bio_for_each_segment_all(to, bio, i) {
 		struct page *page = to->bv_page;
-- 
1.8.4.rc3

