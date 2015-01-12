Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbbALLys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:54:48 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51523 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbbALLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:50:42 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 3/9] block: allow __blk_queue_bounce() to handle bios larger than BIO_MAX_PAGES
Date: Mon, 12 Jan 2015 12:49:42 +0100
Message-Id: <641ab3a0eeb225316784b8a22a285eab911d48fd.1421052746.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ed9c9f3b8190cd64cddbe58a753c811aee69471f.1421052746.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
 <4e7cfbce77dcf72474e1b930ef017c9efaea36d7.1421052746.git.dongsu.park@profitbricks.com>
 <ed9c9f3b8190cd64cddbe58a753c811aee69471f.1421052746.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052745.git.dongsu.park@profitbricks.com>
References: <cover.1421052745.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Allow __blk_queue_bounce() to handle bios with more than BIO_MAX_PAGES
segments. Doing that, it becomes possible to simplify the block layer
in the kernel.

The issue is that any code that clones the bio and must clone the biovec
(i.e. it can't use bio_clone_fast()) won't be able to allocate a bio with
more than BIO_MAX_PAGES - bio_alloc_bioset() always fails in that case.

Fortunately, it's easy to make __blk_queue_bounce() just process part of
the bio if necessary, using bi_remaining to count the splits and punting
the rest back to generic_make_request().

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 block/bounce.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 8 deletions(-)

diff --git a/block/bounce.c b/block/bounce.c
index ab21ba2..689ea89 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -196,6 +196,43 @@ static int must_snapshot_stable_pages(struct request_queue *q, struct bio *bio)
 }
 #endif /* CONFIG_NEED_BOUNCE_POOL */
 
+static struct bio *bio_clone_segments(struct bio *bio_src, gfp_t gfp_mask,
+				      struct bio_set *bs, unsigned nsegs)
+{
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	struct bio *bio;
+
+	bio = bio_alloc_bioset(gfp_mask, nsegs, bs);
+	if (!bio)
+		return NULL;
+
+	bio->bi_bdev		= bio_src->bi_bdev;
+	bio->bi_rw		= bio_src->bi_rw;
+	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
+
+	bio_for_each_segment(bv, bio_src, iter) {
+		bio->bi_io_vec[bio->bi_vcnt++] = bv;
+		bio->bi_iter.bi_size += bv.bv_len;
+		if (!--nsegs)
+			break;
+	}
+
+	if (bio_integrity(bio_src)) {
+		int ret;
+
+		ret = bio_integrity_clone(bio, bio_src, gfp_mask);
+		if (ret < 0) {
+			bio_put(bio);
+			return NULL;
+		}
+	}
+
+	bio_src->bi_iter = iter;
+
+	return bio;
+}
+
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 			       mempool_t *pool, int force)
 {
@@ -203,17 +240,24 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	int rw = bio_data_dir(*bio_orig);
 	struct bio_vec *to, from;
 	struct bvec_iter iter;
-	unsigned i;
+	int i, nsegs = 0, bounce = force;
 
-	if (force)
-		goto bounce;
-	bio_for_each_segment(from, *bio_orig, iter)
+	bio_for_each_segment(from, *bio_orig, iter) {
+		nsegs++;
 		if (page_to_pfn(from.bv_page) > queue_bounce_pfn(q))
-			goto bounce;
+			bounce = 1;
+	}
+
+	if (!bounce)
+		return;
 
-	return;
-bounce:
-	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, fs_bio_set);
+	bio = bio_clone_segments(*bio_orig, GFP_NOIO, fs_bio_set,
+				 min(nsegs, BIO_MAX_PAGES));
+
+	if ((*bio_orig)->bi_iter.bi_size) {
+		atomic_inc(&(*bio_orig)->bi_remaining);
+		generic_make_request(*bio_orig);
+	}
 
 	bio_for_each_segment_all(to, bio, i) {
 		struct page *page = to->bv_page;
-- 
2.1.0

