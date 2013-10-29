Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3J2UWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:22:43 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36064 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3J2USj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:39 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 10/23] bio-integrity: Convert to bvec_iter
Date: Tue, 29 Oct 2013 13:18:03 -0700
Message-Id: <1383077896-4132-11-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bio integrity is also stored in a bvec array, so if we use the bvec
iter code we just added, the integrity code won't need to implement its
own iteration stuff (bio_integrity_mark_head(), bio_integrity_mark_tail())

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 block/blk-integrity.c |  40 ++++++++++---------
 drivers/scsi/sd_dif.c |  30 +++++++-------
 fs/bio-integrity.c    | 108 ++++++++++++--------------------------------------
 include/linux/bio.h   |  19 ++++-----
 4 files changed, 71 insertions(+), 126 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 03cf717..861fcae 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -43,30 +43,32 @@ static const char *bi_unsupported_name = "unsupported";
  */
 int blk_rq_count_integrity_sg(struct request_queue *q, struct bio *bio)
 {
-	struct bio_vec *iv, *ivprv = NULL;
+	struct bio_vec iv, ivprv;
 	unsigned int segments = 0;
 	unsigned int seg_size = 0;
-	unsigned int i = 0;
+	struct bvec_iter iter;
+	int prev = 0;
 
-	bio_for_each_integrity_vec(iv, bio, i) {
+	bio_for_each_integrity_vec(iv, bio, iter) {
 
-		if (ivprv) {
-			if (!BIOVEC_PHYS_MERGEABLE(ivprv, iv))
+		if (prev) {
+			if (!BIOVEC_PHYS_MERGEABLE(&ivprv, &iv))
 				goto new_segment;
 
-			if (!BIOVEC_SEG_BOUNDARY(q, ivprv, iv))
+			if (!BIOVEC_SEG_BOUNDARY(q, &ivprv, &iv))
 				goto new_segment;
 
-			if (seg_size + iv->bv_len > queue_max_segment_size(q))
+			if (seg_size + iv.bv_len > queue_max_segment_size(q))
 				goto new_segment;
 
-			seg_size += iv->bv_len;
+			seg_size += iv.bv_len;
 		} else {
 new_segment:
 			segments++;
-			seg_size = iv->bv_len;
+			seg_size = iv.bv_len;
 		}
 
+		prev = 1;
 		ivprv = iv;
 	}
 
@@ -87,24 +89,25 @@ EXPORT_SYMBOL(blk_rq_count_integrity_sg);
 int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
 			    struct scatterlist *sglist)
 {
-	struct bio_vec *iv, *ivprv = NULL;
+	struct bio_vec iv, ivprv;
 	struct scatterlist *sg = NULL;
 	unsigned int segments = 0;
-	unsigned int i = 0;
+	struct bvec_iter iter;
+	int prev = 0;
 
-	bio_for_each_integrity_vec(iv, bio, i) {
+	bio_for_each_integrity_vec(iv, bio, iter) {
 
-		if (ivprv) {
-			if (!BIOVEC_PHYS_MERGEABLE(ivprv, iv))
+		if (prev) {
+			if (!BIOVEC_PHYS_MERGEABLE(&ivprv, &iv))
 				goto new_segment;
 
-			if (!BIOVEC_SEG_BOUNDARY(q, ivprv, iv))
+			if (!BIOVEC_SEG_BOUNDARY(q, &ivprv, &iv))
 				goto new_segment;
 
-			if (sg->length + iv->bv_len > queue_max_segment_size(q))
+			if (sg->length + iv.bv_len > queue_max_segment_size(q))
 				goto new_segment;
 
-			sg->length += iv->bv_len;
+			sg->length += iv.bv_len;
 		} else {
 new_segment:
 			if (!sg)
@@ -114,10 +117,11 @@ new_segment:
 				sg = sg_next(sg);
 			}
 
-			sg_set_page(sg, iv->bv_page, iv->bv_len, iv->bv_offset);
+			sg_set_page(sg, iv.bv_page, iv.bv_len, iv.bv_offset);
 			segments++;
 		}
 
+		prev = 1;
 		ivprv = iv;
 	}
 
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 6174ca4..a7a691d 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -365,7 +365,6 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 	struct bio *bio;
 	struct scsi_disk *sdkp;
 	struct sd_dif_tuple *sdt;
-	unsigned int i, j;
 	u32 phys, virt;
 
 	sdkp = rq->bio->bi_bdev->bd_disk->private_data;
@@ -376,19 +375,21 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 	phys = hw_sector & 0xffffffff;
 
 	__rq_for_each_bio(bio, rq) {
-		struct bio_vec *iv;
+		struct bio_vec iv;
+		struct bvec_iter iter;
+		unsigned int j;
 
 		/* Already remapped? */
 		if (bio_flagged(bio, BIO_MAPPED_INTEGRITY))
 			break;
 
-		virt = bio->bi_integrity->bip_sector & 0xffffffff;
+		virt = bio->bi_integrity->bip_iter.bi_sector & 0xffffffff;
 
-		bip_for_each_vec(iv, bio->bi_integrity, i) {
-			sdt = kmap_atomic(iv->bv_page)
-				+ iv->bv_offset;
+		bip_for_each_vec(iv, bio->bi_integrity, iter) {
+			sdt = kmap_atomic(iv.bv_page)
+				+ iv.bv_offset;
 
-			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
+			for (j = 0; j < iv.bv_len; j += tuple_sz, sdt++) {
 
 				if (be32_to_cpu(sdt->ref_tag) == virt)
 					sdt->ref_tag = cpu_to_be32(phys);
@@ -414,7 +415,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 	struct scsi_disk *sdkp;
 	struct bio *bio;
 	struct sd_dif_tuple *sdt;
-	unsigned int i, j, sectors, sector_sz;
+	unsigned int j, sectors, sector_sz;
 	u32 phys, virt;
 
 	sdkp = scsi_disk(scmd->request->rq_disk);
@@ -430,15 +431,16 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 		phys >>= 3;
 
 	__rq_for_each_bio(bio, scmd->request) {
-		struct bio_vec *iv;
+		struct bio_vec iv;
+		struct bvec_iter iter;
 
-		virt = bio->bi_integrity->bip_sector & 0xffffffff;
+		virt = bio->bi_integrity->bip_iter.bi_sector & 0xffffffff;
 
-		bip_for_each_vec(iv, bio->bi_integrity, i) {
-			sdt = kmap_atomic(iv->bv_page)
-				+ iv->bv_offset;
+		bip_for_each_vec(iv, bio->bi_integrity, iter) {
+			sdt = kmap_atomic(iv.bv_page)
+				+ iv.bv_offset;
 
-			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
+			for (j = 0; j < iv.bv_len; j += tuple_sz, sdt++) {
 
 				if (sectors == 0) {
 					kunmap_atomic(sdt);
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 9127db8..fed744b 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -134,8 +134,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 		return 0;
 	}
 
-	iv = bip_vec_idx(bip, bip->bip_vcnt);
-	BUG_ON(iv == NULL);
+	iv = bip->bip_vec + bip->bip_vcnt;
 
 	iv->bv_page = page;
 	iv->bv_len = len;
@@ -203,6 +202,12 @@ static inline unsigned int bio_integrity_hw_sectors(struct blk_integrity *bi,
 	return sectors;
 }
 
+static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
+					       unsigned int sectors)
+{
+	return bio_integrity_hw_sectors(bi, sectors) * bi->tuple_size;
+}
+
 /**
  * bio_integrity_tag_size - Retrieve integrity tag space
  * @bio:	bio to inspect
@@ -235,9 +240,9 @@ int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len, int set)
 	nr_sectors = bio_integrity_hw_sectors(bi,
 					DIV_ROUND_UP(len, bi->tag_size));
 
-	if (nr_sectors * bi->tuple_size > bip->bip_size) {
-		printk(KERN_ERR "%s: tag too big for bio: %u > %u\n",
-		       __func__, nr_sectors * bi->tuple_size, bip->bip_size);
+	if (nr_sectors * bi->tuple_size > bip->bip_iter.bi_size) {
+		printk(KERN_ERR "%s: tag too big for bio: %u > %u\n", __func__,
+		       nr_sectors * bi->tuple_size, bip->bip_iter.bi_size);
 		return -1;
 	}
 
@@ -322,7 +327,7 @@ static void bio_integrity_generate(struct bio *bio)
 		sector += sectors;
 		prot_buf += sectors * bi->tuple_size;
 		total += sectors * bi->tuple_size;
-		BUG_ON(total > bio->bi_integrity->bip_size);
+		BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
 
 		kunmap_atomic(kaddr);
 	}
@@ -387,8 +392,8 @@ int bio_integrity_prep(struct bio *bio)
 
 	bip->bip_owns_buf = 1;
 	bip->bip_buf = buf;
-	bip->bip_size = len;
-	bip->bip_sector = bio->bi_iter.bi_sector;
+	bip->bip_iter.bi_size = len;
+	bip->bip_iter.bi_sector = bio->bi_iter.bi_sector;
 
 	/* Map it */
 	offset = offset_in_page(buf);
@@ -444,7 +449,7 @@ static int bio_integrity_verify(struct bio *bio)
 	struct blk_integrity_exchg bix;
 	struct bio_vec bv;
 	struct bvec_iter iter;
-	sector_t sector = bio->bi_integrity->bip_sector;
+	sector_t sector = bio->bi_integrity->bip_iter.bi_sector;
 	unsigned int sectors, total, ret;
 	void *prot_buf = bio->bi_integrity->bip_buf;
 
@@ -470,7 +475,7 @@ static int bio_integrity_verify(struct bio *bio)
 		sector += sectors;
 		prot_buf += sectors * bi->tuple_size;
 		total += sectors * bi->tuple_size;
-		BUG_ON(total > bio->bi_integrity->bip_size);
+		BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
 
 		kunmap_atomic(kaddr);
 	}
@@ -535,56 +540,6 @@ void bio_integrity_endio(struct bio *bio, int error)
 EXPORT_SYMBOL(bio_integrity_endio);
 
 /**
- * bio_integrity_mark_head - Advance bip_vec skip bytes
- * @bip:	Integrity vector to advance
- * @skip:	Number of bytes to advance it
- */
-void bio_integrity_mark_head(struct bio_integrity_payload *bip,
-			     unsigned int skip)
-{
-	struct bio_vec *iv;
-	unsigned int i;
-
-	bip_for_each_vec(iv, bip, i) {
-		if (skip == 0) {
-			bip->bip_idx = i;
-			return;
-		} else if (skip >= iv->bv_len) {
-			skip -= iv->bv_len;
-		} else { /* skip < iv->bv_len) */
-			iv->bv_offset += skip;
-			iv->bv_len -= skip;
-			bip->bip_idx = i;
-			return;
-		}
-	}
-}
-
-/**
- * bio_integrity_mark_tail - Truncate bip_vec to be len bytes long
- * @bip:	Integrity vector to truncate
- * @len:	New length of integrity vector
- */
-void bio_integrity_mark_tail(struct bio_integrity_payload *bip,
-			     unsigned int len)
-{
-	struct bio_vec *iv;
-	unsigned int i;
-
-	bip_for_each_vec(iv, bip, i) {
-		if (len == 0) {
-			bip->bip_vcnt = i;
-			return;
-		} else if (len >= iv->bv_len) {
-			len -= iv->bv_len;
-		} else { /* len < iv->bv_len) */
-			iv->bv_len = len;
-			len = 0;
-		}
-	}
-}
-
-/**
  * bio_integrity_advance - Advance integrity vector
  * @bio:	bio whose integrity vector to update
  * @bytes_done:	number of data bytes that have been completed
@@ -597,13 +552,9 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	unsigned int nr_sectors;
+	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
-	BUG_ON(bip == NULL);
-	BUG_ON(bi == NULL);
-
-	nr_sectors = bio_integrity_hw_sectors(bi, bytes_done >> 9);
-	bio_integrity_mark_head(bip, nr_sectors * bi->tuple_size);
+	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 EXPORT_SYMBOL(bio_integrity_advance);
 
@@ -623,16 +574,9 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	unsigned int nr_sectors;
 
-	BUG_ON(bip == NULL);
-	BUG_ON(bi == NULL);
-	BUG_ON(!bio_flagged(bio, BIO_CLONED));
-
-	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
-	bip->bip_sector = bip->bip_sector + offset;
-	bio_integrity_mark_head(bip, offset * bi->tuple_size);
-	bio_integrity_mark_tail(bip, sectors * bi->tuple_size);
+	bio_integrity_advance(bio, offset << 9);
+	bip->bip_iter.bi_size = bio_integrity_bytes(bi, sectors);
 }
 EXPORT_SYMBOL(bio_integrity_trim);
 
@@ -662,8 +606,8 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->bio1.bi_integrity = &bp->bip1;
 	bp->bio2.bi_integrity = &bp->bip2;
 
-	bp->iv1 = bip->bip_vec[bip->bip_idx];
-	bp->iv2 = bip->bip_vec[bip->bip_idx];
+	bp->iv1 = bip->bip_vec[bip->bip_iter.bi_idx];
+	bp->iv2 = bip->bip_vec[bip->bip_iter.bi_idx];
 
 	bp->bip1.bip_vec = &bp->iv1;
 	bp->bip2.bip_vec = &bp->iv2;
@@ -672,11 +616,12 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->iv2.bv_offset += sectors * bi->tuple_size;
 	bp->iv2.bv_len -= sectors * bi->tuple_size;
 
-	bp->bip1.bip_sector = bio->bi_integrity->bip_sector;
-	bp->bip2.bip_sector = bio->bi_integrity->bip_sector + nr_sectors;
+	bp->bip1.bip_iter.bi_sector = bio->bi_integrity->bip_iter.bi_sector;
+	bp->bip2.bip_iter.bi_sector =
+		bio->bi_integrity->bip_iter.bi_sector + nr_sectors;
 
 	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
-	bp->bip1.bip_idx = bp->bip2.bip_idx = 0;
+	bp->bip1.bip_iter.bi_idx = bp->bip2.bip_iter.bi_idx = 0;
 }
 EXPORT_SYMBOL(bio_integrity_split);
 
@@ -704,9 +649,8 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	memcpy(bip->bip_vec, bip_src->bip_vec,
 	       bip_src->bip_vcnt * sizeof(struct bio_vec));
 
-	bip->bip_sector = bip_src->bip_sector;
 	bip->bip_vcnt = bip_src->bip_vcnt;
-	bip->bip_idx = bip_src->bip_idx;
+	bip->bip_iter = bip_src->bip_iter;
 
 	return 0;
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 151868e..57a6f40 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -244,16 +244,15 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 struct bio_integrity_payload {
 	struct bio		*bip_bio;	/* parent bio */
 
-	sector_t		bip_sector;	/* virtual start sector */
+	struct bvec_iter	bip_iter;
 
+	/* kill - should just use bip_vec */
 	void			*bip_buf;	/* generated integrity data */
-	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
 
-	unsigned int		bip_size;
+	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
 
 	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
-	unsigned short		bip_idx;	/* current bip_vec index */
 	unsigned		bip_owns_buf:1;	/* should free bip_buf */
 
 	struct work_struct	bip_work;	/* I/O completion */
@@ -624,16 +623,12 @@ struct biovec_slab {
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
-#define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
-#define bip_vec(bip)		bip_vec_idx(bip, 0)
 
-#define __bip_for_each_vec(bvl, bip, i, start_idx)			\
-	for (bvl = bip_vec_idx((bip), (start_idx)), i = (start_idx);	\
-	     i < (bip)->bip_vcnt;					\
-	     bvl++, i++)
 
-#define bip_for_each_vec(bvl, bip, i)					\
-	__bip_for_each_vec(bvl, bip, i, (bip)->bip_idx)
+#define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
+
+#define bip_for_each_vec(bvl, bip, iter)				\
+	for_each_bvec(bvl, (bip)->bip_vec, iter, (bip)->bip_iter)
 
 #define bio_for_each_integrity_vec(_bvl, _bio, _iter)			\
 	for_each_bio(_bio)						\
-- 
1.8.4.rc3

