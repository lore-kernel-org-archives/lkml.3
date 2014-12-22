Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaLVLxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:53:22 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39902 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaLVLu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:28 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [RFC PATCH 11/17] block: allow __blk_queue_bounce() to handle bios larger than BIO_MAX_PAGES
Date: Mon, 22 Dec 2014 12:48:38 +0100
Message-Id: <abe647cf7cf272220227fad4dac9c43641192f01.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <4334b90a56b96ad7a11e4ba7eb97c2cf4405950d.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
 <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
 <fe96db02d805ca6191dd605d03dac0d04c926fc1.1419241597.git.dongsu.park@profitbricks.com>
 <bb0051ceb5805896089ded26c0f7f06758b25105.1419241597.git.dongsu.park@profitbricks.com>
 <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
 <83a9ee8a309f8e08490c5dd715a608ea054f5c33.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <0b6ba533a64aec98e8447bfd30c6622d0729d12e.1419241597.git.dongsu.park@profitbricks.com>
 <d42dae3d2a64fa4c3a0893f1af963151b31869e3.1419241597.git.dongsu.park@profitbricks.com>
 <4334b90a56b96ad7a11e4ba7eb97c2cf4405950d.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
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

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>
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

