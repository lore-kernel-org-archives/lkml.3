Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3KFVpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:45:00 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37725 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3KFVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:44:58 -0500
Date: Wed, 6 Nov 2013 13:44:52 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block/s390: Fixes for "Convert bio_for_each_segment() to
 bvec_iter"
Message-ID: <20131106214452.GA10871@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5d1f127c3e0c57d64ce75ee04a0db2b40a3e21df was incomplete - this just converts
s390's drivers.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
I was poking around a bit, and it looks like there's nothing really preventing
these drivers from building on non s390 except that a bunch of headers are in
arch/s390/include. Would be nice to get that fixed so we can get better build
coverage.

 drivers/s390/block/dasd_diag.c       | 10 ++++----
 drivers/s390/block/dasd_eckd.c       | 48 ++++++++++++++++++------------------
 drivers/s390/block/dasd_fba.c        | 26 +++++++++----------
 drivers/s390/block/scm_blk.c         |  8 +++---
 drivers/s390/block/scm_blk_cluster.c |  4 +--
 5 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 92bd22c..9cbc567 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -504,7 +504,7 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
 	struct dasd_diag_req *dreq;
 	struct dasd_diag_bio *dbio;
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst;
 	unsigned int count, datasize;
 	sector_t recid, first_rec, last_rec;
@@ -525,10 +525,10 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
 	rq_for_each_segment(bv, req, iter) {
-		if (bv->bv_len & (blksize - 1))
+		if (bv.bv_len & (blksize - 1))
 			/* Fba can only do full blocks. */
 			return ERR_PTR(-EINVAL);
-		count += bv->bv_len >> (block->s2b_shift + 9);
+		count += bv.bv_len >> (block->s2b_shift + 9);
 	}
 	/* Paranoia. */
 	if (count != last_rec - first_rec + 1)
@@ -545,8 +545,8 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
 	dbio = dreq->bio;
 	recid = first_rec;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
-		for (off = 0; off < bv->bv_len; off += blksize) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			memset(dbio, 0, sizeof (struct dasd_diag_bio));
 			dbio->type = rw_cmd;
 			dbio->block_number = recid + 1;
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 5adb204..030d6e0 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2507,7 +2507,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst;
 	unsigned int off;
 	int count, cidaw, cplength, datasize;
@@ -2529,13 +2529,13 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 	count = 0;
 	cidaw = 0;
 	rq_for_each_segment(bv, req, iter) {
-		if (bv->bv_len & (blksize - 1))
+		if (bv.bv_len & (blksize - 1))
 			/* Eckd can only do full blocks. */
 			return ERR_PTR(-EINVAL);
-		count += bv->bv_len >> (block->s2b_shift + 9);
+		count += bv.bv_len >> (block->s2b_shift + 9);
 #if defined(CONFIG_64BIT)
-		if (idal_is_needed (page_address(bv->bv_page), bv->bv_len))
-			cidaw += bv->bv_len >> (block->s2b_shift + 9);
+		if (idal_is_needed (page_address(bv.bv_page), bv.bv_len))
+			cidaw += bv.bv_len >> (block->s2b_shift + 9);
 #endif
 	}
 	/* Paranoia. */
@@ -2606,16 +2606,16 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 			      last_rec - recid + 1, cmd, basedev, blksize);
 	}
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
+		dst = page_address(bv.bv_page) + bv.bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
 						      GFP_DMA | __GFP_NOWARN);
 			if (copy && rq_data_dir(req) == WRITE)
-				memcpy(copy + bv->bv_offset, dst, bv->bv_len);
+				memcpy(copy + bv.bv_offset, dst, bv.bv_len);
 			if (copy)
-				dst = copy + bv->bv_offset;
+				dst = copy + bv.bv_offset;
 		}
-		for (off = 0; off < bv->bv_len; off += blksize) {
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			sector_t trkid = recid;
 			unsigned int recoffs = sector_div(trkid, blk_per_trk);
 			rcmd = cmd;
@@ -2691,7 +2691,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_track(
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst, *idaw_dst;
 	unsigned int cidaw, cplength, datasize;
 	unsigned int tlf;
@@ -2769,8 +2769,8 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_track(
 	idaw_dst = NULL;
 	idaw_len = 0;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
-		seg_len = bv->bv_len;
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		seg_len = bv.bv_len;
 		while (seg_len) {
 			if (new_track) {
 				trkid = recid;
@@ -2995,7 +2995,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 {
 	struct dasd_ccw_req *cqr;
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst;
 	unsigned int trkcount, ctidaw;
 	unsigned char cmd;
@@ -3081,8 +3081,8 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		new_track = 1;
 		recid = first_rec;
 		rq_for_each_segment(bv, req, iter) {
-			dst = page_address(bv->bv_page) + bv->bv_offset;
-			seg_len = bv->bv_len;
+			dst = page_address(bv.bv_page) + bv.bv_offset;
+			seg_len = bv.bv_len;
 			while (seg_len) {
 				if (new_track) {
 					trkid = recid;
@@ -3114,9 +3114,9 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 		}
 	} else {
 		rq_for_each_segment(bv, req, iter) {
-			dst = page_address(bv->bv_page) + bv->bv_offset;
+			dst = page_address(bv.bv_page) + bv.bv_offset;
 			last_tidaw = itcw_add_tidaw(itcw, 0x00,
-						    dst, bv->bv_len);
+						    dst, bv.bv_len);
 			if (IS_ERR(last_tidaw)) {
 				ret = -EINVAL;
 				goto out_error;
@@ -3232,7 +3232,7 @@ static struct dasd_ccw_req *dasd_raw_build_cp(struct dasd_device *startdev,
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst;
 	unsigned char cmd;
 	unsigned int trkcount;
@@ -3332,8 +3332,8 @@ static struct dasd_ccw_req *dasd_raw_build_cp(struct dasd_device *startdev,
 			idaws = idal_create_words(idaws, rawpadpage, PAGE_SIZE);
 	}
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
-		seg_len = bv->bv_len;
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		seg_len = bv.bv_len;
 		if (cmd == DASD_ECKD_CCW_READ_TRACK)
 			memset(dst, 0, seg_len);
 		if (!len_to_track_end) {
@@ -3378,7 +3378,7 @@ dasd_eckd_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	struct dasd_eckd_private *private;
 	struct ccw1 *ccw;
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst, *cda;
 	unsigned int blksize, blk_per_trk, off;
 	sector_t recid;
@@ -3396,8 +3396,8 @@ dasd_eckd_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	if (private->uses_cdl == 0 || recid > 2*blk_per_trk)
 		ccw++;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
-		for (off = 0; off < bv->bv_len; off += blksize) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Skip locate record. */
 			if (private->uses_cdl && recid <= 2*blk_per_trk)
 				ccw++;
@@ -3408,7 +3408,7 @@ dasd_eckd_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 					cda = (char *)((addr_t) ccw->cda);
 				if (dst != cda) {
 					if (rq_data_dir(req) == READ)
-						memcpy(dst, cda, bv->bv_len);
+						memcpy(dst, cda, bv.bv_len);
 					kmem_cache_free(dasd_page_cache,
 					    (void *)((addr_t)cda & PAGE_MASK));
 				}
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 9cbc8c3..2c8e68b 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -260,7 +260,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst;
 	int count, cidaw, cplength, datasize;
 	sector_t recid, first_rec, last_rec;
@@ -283,13 +283,13 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 	count = 0;
 	cidaw = 0;
 	rq_for_each_segment(bv, req, iter) {
-		if (bv->bv_len & (blksize - 1))
+		if (bv.bv_len & (blksize - 1))
 			/* Fba can only do full blocks. */
 			return ERR_PTR(-EINVAL);
-		count += bv->bv_len >> (block->s2b_shift + 9);
+		count += bv.bv_len >> (block->s2b_shift + 9);
 #if defined(CONFIG_64BIT)
-		if (idal_is_needed (page_address(bv->bv_page), bv->bv_len))
-			cidaw += bv->bv_len / blksize;
+		if (idal_is_needed (page_address(bv.bv_page), bv.bv_len))
+			cidaw += bv.bv_len / blksize;
 #endif
 	}
 	/* Paranoia. */
@@ -326,16 +326,16 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 	}
 	recid = first_rec;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
+		dst = page_address(bv.bv_page) + bv.bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
 						      GFP_DMA | __GFP_NOWARN);
 			if (copy && rq_data_dir(req) == WRITE)
-				memcpy(copy + bv->bv_offset, dst, bv->bv_len);
+				memcpy(copy + bv.bv_offset, dst, bv.bv_len);
 			if (copy)
-				dst = copy + bv->bv_offset;
+				dst = copy + bv.bv_offset;
 		}
-		for (off = 0; off < bv->bv_len; off += blksize) {
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Locate record for stupid devices. */
 			if (private->rdc_data.mode.bits.data_chain == 0) {
 				ccw[-1].flags |= CCW_FLAG_CC;
@@ -384,7 +384,7 @@ dasd_fba_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	struct dasd_fba_private *private;
 	struct ccw1 *ccw;
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst, *cda;
 	unsigned int blksize, off;
 	int status;
@@ -399,8 +399,8 @@ dasd_fba_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	if (private->rdc_data.mode.bits.data_chain != 0)
 		ccw++;
 	rq_for_each_segment(bv, req, iter) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
-		for (off = 0; off < bv->bv_len; off += blksize) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Skip locate record. */
 			if (private->rdc_data.mode.bits.data_chain == 0)
 				ccw++;
@@ -411,7 +411,7 @@ dasd_fba_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 					cda = (char *)((addr_t) ccw->cda);
 				if (dst != cda) {
 					if (rq_data_dir(req) == READ)
-						memcpy(dst, cda, bv->bv_len);
+						memcpy(dst, cda, bv.bv_len);
 					kmem_cache_free(dasd_page_cache,
 					    (void *)((addr_t)cda & PAGE_MASK));
 				}
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 5d73e6e..8a06a7a 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -146,7 +146,7 @@ static void scm_request_prepare(struct scm_request *scmrq)
 	struct aidaw *aidaw = scmrq->aidaw;
 	struct msb *msb = &scmrq->aob->msb[0];
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 
 	msb->bs = MSB_BS_4K;
 	scmrq->aob->request.msb_count = 1;
@@ -158,9 +158,9 @@ static void scm_request_prepare(struct scm_request *scmrq)
 	msb->data_addr = (u64) aidaw;
 
 	rq_for_each_segment(bv, scmrq->request, iter) {
-		WARN_ON(bv->bv_offset);
-		msb->blk_count += bv->bv_len >> 12;
-		aidaw->data_addr = (u64) page_address(bv->bv_page);
+		WARN_ON(bv.bv_offset);
+		msb->blk_count += bv.bv_len >> 12;
+		aidaw->data_addr = (u64) page_address(bv.bv_page);
 		aidaw++;
 	}
 }
diff --git a/drivers/s390/block/scm_blk_cluster.c b/drivers/s390/block/scm_blk_cluster.c
index c0d102e..f874864 100644
--- a/drivers/s390/block/scm_blk_cluster.c
+++ b/drivers/s390/block/scm_blk_cluster.c
@@ -122,7 +122,7 @@ static void scm_prepare_cluster_request(struct scm_request *scmrq)
 	struct aidaw *aidaw = scmrq->aidaw;
 	struct msb *msb = &scmrq->aob->msb[0];
 	struct req_iterator iter;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	int i = 0;
 	u64 addr;
 
@@ -163,7 +163,7 @@ static void scm_prepare_cluster_request(struct scm_request *scmrq)
 			i++;
 		}
 		rq_for_each_segment(bv, req, iter) {
-			aidaw->data_addr = (u64) page_address(bv->bv_page);
+			aidaw->data_addr = (u64) page_address(bv.bv_page);
 			aidaw++;
 			i++;
 		}
-- 
1.8.4.2

