Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3IYUY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:24:28 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56934 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab3IYUW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:22:58 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 5/6] convert integrity to new merging
Date: Wed, 25 Sep 2013 13:22:43 -0700
Message-Id: <1380140564-9030-6-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
References: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <koverstreet@google.com>

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 block/blk-integrity.c | 54 +++++++++++++--------------------------------------
 fs/bio-integrity.c    | 10 ++++++++++
 2 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 861fcae..22d8e9c 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -43,33 +43,19 @@ static const char *bi_unsupported_name = "unsupported";
  */
 int blk_rq_count_integrity_sg(struct request_queue *q, struct bio *bio)
 {
-	struct bio_vec iv, ivprv;
 	unsigned int segments = 0;
-	unsigned int seg_size = 0;
-	struct bvec_iter iter;
-	int prev = 0;
 
-	bio_for_each_integrity_vec(iv, bio, iter) {
+	for_each_bio(bio) {
+		struct bio_integrity_payload *bip = bio->bi_integrity;
+		struct bvec_iter iter = bip->bip_iter;
 
-		if (prev) {
-			if (!BIOVEC_PHYS_MERGEABLE(&ivprv, &iv))
-				goto new_segment;
+		while (iter.bi_size) {
+			struct bio_vec iv = bvec_iter_bvec(bip->bip_vec, iter);
+			unsigned nbytes = blk_max_segment(q, &iv);
 
-			if (!BIOVEC_SEG_BOUNDARY(q, &ivprv, &iv))
-				goto new_segment;
-
-			if (seg_size + iv.bv_len > queue_max_segment_size(q))
-				goto new_segment;
-
-			seg_size += iv.bv_len;
-		} else {
-new_segment:
 			segments++;
-			seg_size = iv.bv_len;
+			bio_advance_iter(bio, &iter, nbytes);
 		}
-
-		prev = 1;
-		ivprv = iv;
 	}
 
 	return segments;
@@ -89,27 +75,17 @@ EXPORT_SYMBOL(blk_rq_count_integrity_sg);
 int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
 			    struct scatterlist *sglist)
 {
-	struct bio_vec iv, ivprv;
 	struct scatterlist *sg = NULL;
 	unsigned int segments = 0;
-	struct bvec_iter iter;
-	int prev = 0;
 
-	bio_for_each_integrity_vec(iv, bio, iter) {
+	for_each_bio(bio) {
+		struct bio_integrity_payload *bip = bio->bi_integrity;
+		struct bvec_iter iter = bip->bip_iter;
 
-		if (prev) {
-			if (!BIOVEC_PHYS_MERGEABLE(&ivprv, &iv))
-				goto new_segment;
+		while (iter.bi_size) {
+			struct bio_vec iv= bvec_iter_bvec(bip->bip_vec, iter);
+			unsigned nbytes = blk_max_segment(q, &iv);
 
-			if (!BIOVEC_SEG_BOUNDARY(q, &ivprv, &iv))
-				goto new_segment;
-
-			if (sg->length + iv.bv_len > queue_max_segment_size(q))
-				goto new_segment;
-
-			sg->length += iv.bv_len;
-		} else {
-new_segment:
 			if (!sg)
 				sg = sglist;
 			else {
@@ -119,10 +95,8 @@ new_segment:
 
 			sg_set_page(sg, iv.bv_page, iv.bv_len, iv.bv_offset);
 			segments++;
+			bio_advance_iter(bio, &iter, nbytes);
 		}
-
-		prev = 1;
-		ivprv = iv;
 	}
 
 	if (sg)
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 31f2d5a..2578c84 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -129,6 +129,16 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct bio_vec *iv;
 
+	if (bip->bip_vcnt) {
+		iv = bip->bip_vec + bip->bip_vcnt - 1;
+
+		if (bvec_to_phys(iv) + iv->bv_len ==
+		    page_to_phys(page) + offset) {
+			iv->bv_len += len;
+			return len;
+		}
+	}
+
 	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
-- 
1.8.4.rc3

