Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3IYUXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:23:19 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56216 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3IYUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:23:00 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 6/6] Multipage bvecs
Date: Wed, 25 Sep 2013 13:22:44 -0700
Message-Id: <1380140564-9030-7-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
References: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert merging to bio_add_page()/blk_max_segment()

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 arch/x86/include/asm/io.h |   7 --
 block/blk-merge.c         | 227 ++++++++++++----------------------------------
 drivers/xen/biomerge.c    |  11 ---
 fs/bio.c                  |  14 ++-
 include/linux/bio.h       |  25 -----
 include/linux/blk_types.h |   7 --
 6 files changed, 65 insertions(+), 226 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 4799845..9060a25 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -333,17 +333,10 @@ extern bool is_early_ioremap_ptep(pte_t *ptep);
 
 #ifdef CONFIG_XEN
 #include <xen/xen.h>
-struct bio_vec;
 
 extern bool xen_page_phys_mergeable(const struct page *p1,
 				    const struct page *p2);
 
-extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
-				      const struct bio_vec *vec2);
-
-#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
-	(__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&				\
-	 (!xen_domain() || xen_biovec_phys_mergeable(vec1, vec2)))
 #endif	/* CONFIG_XEN */
 
 #define IO_SPACE_LIMIT 0xffff
diff --git a/block/blk-merge.c b/block/blk-merge.c
index c9c837b..c356e11 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -116,10 +116,8 @@ static struct bio *blk_bio_write_same_split(struct request_queue *q,
 struct bio *blk_bio_segment_split(struct request_queue *q, struct bio *bio,
 				  struct bio_set *bs)
 {
-	struct bio_vec bv, bvprv;
-	struct bvec_iter iter;
-	unsigned seg_size = 0, nsegs = 0;
-	int prev = 0;
+	struct bvec_iter iter = bio->bi_iter;
+	unsigned nsegs = 0;
 
 	if (bio->bi_rw & REQ_DISCARD)
 		return blk_bio_discard_split(q, bio, bs);
@@ -127,21 +125,10 @@ struct bio *blk_bio_segment_split(struct request_queue *q, struct bio *bio,
 	if (bio->bi_rw & REQ_WRITE_SAME)
 		return blk_bio_write_same_split(q, bio, bs);
 
-	bio_for_each_segment(bv, bio, iter) {
-		if (prev && blk_queue_cluster(q)) {
-			if (seg_size + bv.bv_len > queue_max_segment_size(q))
-				goto new_segment;
-			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bv))
-				goto new_segment;
-			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bv))
-				goto new_segment;
-
-			seg_size += bv.bv_len;
-			bvprv = bv;
-			prev = 1;
-			continue;
-		}
-new_segment:
+	while (iter.bi_size) {
+		struct bio_vec bv = bio_iter_iovec(bio, iter);
+		unsigned nbytes = blk_max_segment(q, &bv);
+
 		if (nsegs == queue_max_segments(q)) {
 			struct bio *split;
 
@@ -159,9 +146,7 @@ new_segment:
 		}
 
 		nsegs++;
-		bvprv = bv;
-		prev = 1;
-		seg_size = bv.bv_len;
+		bio_advance_iter(bio, &iter, nbytes);
 	}
 
 	return NULL;
@@ -170,59 +155,29 @@ new_segment:
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
-	struct bio_vec bv, bvprv;
-	int cluster, prev = 0;
-	unsigned int seg_size, nr_phys_segs;
-	struct bio *fbio, *bbio;
-	struct bvec_iter iter;
+	unsigned nr_phys_segs = 0;
 
-	if (!bio)
-		return 0;
-
-	fbio = bio;
-	cluster = blk_queue_cluster(q);
-	seg_size = 0;
-	nr_phys_segs = 0;
 	for_each_bio(bio) {
-		bio_for_each_segment(bv, bio, iter) {
-			if (prev && cluster) {
-				if (seg_size + bv.bv_len
-				    > queue_max_segment_size(q))
-					goto new_segment;
-				if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bv))
-					goto new_segment;
-				if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bv))
-					goto new_segment;
-
-				seg_size += bv.bv_len;
-				bvprv = bv;
-				prev = 1;
-				continue;
-			}
-new_segment:
-			if (nr_phys_segs == 1 && seg_size >
-			    fbio->bi_seg_front_size)
-				fbio->bi_seg_front_size = seg_size;
+		struct bvec_iter iter = bio->bi_iter;
+
+		while (iter.bi_size) {
+			struct bio_vec bv = bio_iter_iovec(bio, iter);
+			unsigned nbytes = blk_max_segment(q, &bv);
 
 			nr_phys_segs++;
-			bvprv = bv;
-			prev = 1;
-			seg_size = bv.bv_len;
+			bio_advance_iter(bio, &iter, nbytes);
 		}
-		bbio = bio;
 	}
 
-	if (nr_phys_segs == 1 && seg_size > fbio->bi_seg_front_size)
-		fbio->bi_seg_front_size = seg_size;
-	if (seg_size > bbio->bi_seg_back_size)
-		bbio->bi_seg_back_size = seg_size;
-
 	return nr_phys_segs;
 }
 
 void blk_recalc_rq_segments(struct request *rq)
 {
-	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio);
+	if (rq->bio)
+		rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio);
+	else
+		rq->nr_phys_segments = 0;
 }
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
@@ -236,82 +191,43 @@ void blk_recount_segments(struct request_queue *q, struct bio *bio)
 }
 EXPORT_SYMBOL(blk_recount_segments);
 
-static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
-				   struct bio *nxt)
+static int __blk_segment_map_sg(struct request_queue *q, struct bio *bio,
+				struct scatterlist *sglist,
+				struct scatterlist **sg)
 {
-	struct bio_vec end_bv, nxt_bv;
-	struct bvec_iter iter;
-
-	if (!blk_queue_cluster(q))
-		return 0;
-
-	if (bio->bi_seg_back_size + nxt->bi_seg_front_size >
-	    queue_max_segment_size(q))
-		return 0;
-
-	if (!bio_has_data(bio))
-		return 1;
-
-	bio_for_each_segment(end_bv, bio, iter)
-		if (end_bv.bv_len == iter.bi_size)
-			break;
-
-	nxt_bv = bio_iovec(nxt);
-
-	if (!BIOVEC_PHYS_MERGEABLE(&end_bv, &nxt_bv))
-		return 0;
+	unsigned nsegs = 0;
 
-	/*
-	 * bio and nxt are contiguous in memory; check if the queue allows
-	 * these two to be merged into one
-	 */
-	if (BIOVEC_SEG_BOUNDARY(q, &end_bv, &nxt_bv))
-		return 1;
-
-	return 0;
-}
-
-static inline void
-__blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
-		     struct scatterlist *sglist, struct bio_vec *bvprv,
-		     struct scatterlist **sg, int *nsegs, int *cluster)
-{
+	for_each_bio(bio) {
+		struct bvec_iter iter = bio->bi_iter;
+
+		while (iter.bi_size) {
+			struct bio_vec bv = bio_iter_iovec(bio, iter);
+			unsigned nbytes = blk_max_segment(q, &bv);
+
+			if (!*sg)
+				*sg = sglist;
+			else {
+				/*
+				 * If the driver previously mapped a shorter
+				 * list, we could see a termination bit
+				 * prematurely unless it fully inits the sg
+				 * table on each mapping. We KNOW that there
+				 * must be more entries here or the driver
+				 * would be buggy, so force clear the
+				 * termination bit to avoid doing a full
+				 * sg_init_table() in drivers for each command.
+				 */
+				sg_unmark_end(*sg);
+				*sg = sg_next(*sg);
+			}
 
-	int nbytes = bvec->bv_len;
-
-	if (*sg && *cluster) {
-		if ((*sg)->length + nbytes > queue_max_segment_size(q))
-			goto new_segment;
-
-		if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
-			goto new_segment;
-		if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
-			goto new_segment;
-
-		(*sg)->length += nbytes;
-	} else {
-new_segment:
-		if (!*sg)
-			*sg = sglist;
-		else {
-			/*
-			 * If the driver previously mapped a shorter
-			 * list, we could see a termination bit
-			 * prematurely unless it fully inits the sg
-			 * table on each mapping. We KNOW that there
-			 * must be more entries here or the driver
-			 * would be buggy, so force clear the
-			 * termination bit to avoid doing a full
-			 * sg_init_table() in drivers for each command.
-			 */
-			sg_unmark_end(*sg);
-			*sg = sg_next(*sg);
+			sg_set_page(*sg, bv.bv_page, nbytes, bv.bv_offset);
+			nsegs++;
+			bio_advance_iter(bio, &iter, nbytes);
 		}
-
-		sg_set_page(*sg, bvec->bv_page, nbytes, bvec->bv_offset);
-		(*nsegs)++;
 	}
-	*bvprv = *bvec;
+
+	return nsegs;
 }
 
 /*
@@ -321,22 +237,13 @@ new_segment:
 int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		  struct scatterlist *sglist)
 {
-	struct bio_vec bvec, bvprv;
-	struct req_iterator iter;
-	struct scatterlist *sg;
-	int nsegs, cluster;
-
-	nsegs = 0;
-	cluster = blk_queue_cluster(q);
+	struct scatterlist *sg = NULL;
+	unsigned nsegs;
 
 	/*
 	 * for each bio in rq
 	 */
-	sg = NULL;
-	rq_for_each_segment(bvec, rq, iter) {
-		__blk_segment_map_sg(q, &bvec, sglist, &bvprv, &sg,
-				     &nsegs, &cluster);
-	} /* segments in rq */
+	nsegs = __blk_segment_map_sg(q, rq->bio, sglist, &sg);
 
 
 	if (unlikely(rq->cmd_flags & REQ_COPY_USER) &&
@@ -383,24 +290,17 @@ EXPORT_SYMBOL(blk_rq_map_sg);
 int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
 		   struct scatterlist *sglist)
 {
-	struct bio_vec bvec, bvprv;
-	struct scatterlist *sg;
-	int nsegs, cluster;
-	struct bvec_iter iter;
-
-	nsegs = 0;
-	cluster = blk_queue_cluster(q);
+	struct scatterlist *sg = NULL;
+	struct bio *next = bio->bi_next;
+	unsigned nsegs;
 
-	sg = NULL;
-	bio_for_each_segment(bvec, bio, iter) {
-		__blk_segment_map_sg(q, &bvec, sglist, &bvprv, &sg,
-				     &nsegs, &cluster);
-	} /* segments in bio */
+	bio->bi_next = NULL;
+	nsegs = __blk_segment_map_sg(q, bio, sglist, &sg);
+	bio->bi_next = next;
 
 	if (sg)
 		sg_mark_end(sg);
 
-	BUG_ON(bio->bi_phys_segments && nsegs > bio->bi_phys_segments);
 	return nsegs;
 }
 EXPORT_SYMBOL(blk_bio_map_sg);
@@ -471,8 +371,6 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 				struct request *next)
 {
 	int total_phys_segments;
-	unsigned int seg_size =
-		req->biotail->bi_seg_back_size + next->bio->bi_seg_front_size;
 
 	/*
 	 * First check if the either of the requests are re-queued
@@ -489,13 +387,6 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
-	if (blk_phys_contig_segment(q, req->biotail, next->bio)) {
-		if (req->nr_phys_segments == 1)
-			req->bio->bi_seg_front_size = seg_size;
-		if (next->nr_phys_segments == 1)
-			next->biotail->bi_seg_back_size = seg_size;
-		total_phys_segments--;
-	}
 
 	if (total_phys_segments > queue_max_segments(q))
 		return 0;
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
index d9fb598..9934266 100644
--- a/drivers/xen/biomerge.c
+++ b/drivers/xen/biomerge.c
@@ -10,14 +10,3 @@ bool xen_page_phys_mergeable(const struct page *p1, const struct page *p2)
 
 	return mfn1 + 1 == mfn2;
 }
-
-bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
-			       const struct bio_vec *vec2)
-{
-	unsigned long mfn1 = pfn_to_mfn(page_to_pfn(vec1->bv_page));
-	unsigned long mfn2 = pfn_to_mfn(page_to_pfn(vec2->bv_page));
-
-	return __BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&
-		((mfn1 == mfn2) || ((mfn1+1) == mfn2));
-}
-EXPORT_SYMBOL(xen_biovec_phys_mergeable);
diff --git a/fs/bio.c b/fs/bio.c
index da8aa81..93aee5c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -678,8 +678,8 @@ int bio_add_page(struct bio *bio, struct page *page,
 	if (bio->bi_vcnt > 0) {
 		bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
-		if (page == bv->bv_page &&
-		    offset == bv->bv_offset + bv->bv_len) {
+		if (bvec_to_phys(bv) + bv->bv_len ==
+		    page_to_phys(page) + offset) {
 			bv->bv_len += len;
 			goto done;
 		}
@@ -688,12 +688,10 @@ int bio_add_page(struct bio *bio, struct page *page,
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return 0;
 
-	bv		= &bio->bi_io_vec[bio->bi_vcnt];
-	bv->bv_page	= page;
-	bv->bv_len	= len;
-	bv->bv_offset	= offset;
-
-	bio->bi_vcnt++;
+	bv = &bio->bi_io_vec[bio->bi_vcnt++];
+	bv->bv_page = page;
+	bv->bv_len = len;
+	bv->bv_offset = offset;
 done:
 	bio->bi_iter.bi_size += len;
 	return len;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f6f0e99..3d9473d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -175,27 +175,6 @@ static inline void *bio_data(struct bio *bio)
 
 #define __bio_kunmap_atomic(addr)	kunmap_atomic(addr)
 
-/*
- * merge helpers etc
- */
-
-/* Default implementation of BIOVEC_PHYS_MERGEABLE */
-#define __BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
-	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
-
-/*
- * allow arch override, for eg virtualized architectures (put in asm/io.h)
- */
-#ifndef BIOVEC_PHYS_MERGEABLE
-#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
-	__BIOVEC_PHYS_MERGEABLE(vec1, vec2)
-#endif
-
-#define __BIO_SEG_BOUNDARY(addr1, addr2, mask) \
-	(((addr1) | (mask)) == (((addr2) - 1) | (mask)))
-#define BIOVEC_SEG_BOUNDARY(q, b1, b2) \
-	__BIO_SEG_BOUNDARY(bvec_to_phys((b1)), bvec_to_phys((b2)) + (b2)->bv_len, queue_segment_boundary((q)))
-
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
 static inline void bvec_iter_advance(struct bio_vec *bv, struct bvec_iter *iter,
@@ -652,10 +631,6 @@ struct biovec_slab {
 #define bip_for_each_page(bvl, bip, iter)				\
 	__bip_for_each(bvl, bip, iter, bvec_iter_page_bytes)
 
-#define bio_for_each_integrity_vec(_bvl, _bio, _iter)			\
-	for_each_bio(_bio)						\
-		bip_for_each_segment(_bvl, _bio->bi_integrity, _iter)
-
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8fca6e3..4aebb73 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -57,13 +57,6 @@ struct bio {
 	 */
 	unsigned int		bi_phys_segments;
 
-	/*
-	 * To keep track of the max segment size, we account for the
-	 * sizes of the first and last mergeable segments in this bio.
-	 */
-	unsigned int		bi_seg_front_size;
-	unsigned int		bi_seg_back_size;
-
 	atomic_t		bi_remaining;
 
 	bio_end_io_t		*bi_end_io;
-- 
1.8.4.rc3

