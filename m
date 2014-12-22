Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaLVLtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:49:43 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36351 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaLVLtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:49:39 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [RFC PATCH 02/17] block: simplify bio_add_page()
Date: Mon, 22 Dec 2014 12:48:29 +0100
Message-Id: <f67d71b4a375ab504c2fc02e94a9d2a651686cab.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Since generic_make_request() can now handle arbitrary size bios, all we
have to do is make sure the bvec array doesn't overflow.
__bio_add_page() doesn't need to call ->merge_bvec_fn(), where
we can get rid of unnecessary code paths.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: rebase and resolve merge conflicts]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lin <mlin@minggr.net>
---
 block/bio.c | 135 +++++++++++++++++++++++++-----------------------------------
 1 file changed, 55 insertions(+), 80 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 471d738..955bc57 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -700,9 +700,23 @@ int bio_get_nr_vecs(struct block_device *bdev)
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 
-static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
-			  *page, unsigned int len, unsigned int offset,
-			  unsigned int max_sectors)
+/**
+ *	bio_add_pc_page	-	attempt to add page to bio
+ *	@q: the target queue
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This can fail for a
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
+ *
+ *	This should only be used by REQ_PC bios.
+ */
+int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page
+		    *page, unsigned int len, unsigned int offset)
 {
 	int retried_segments = 0;
 	struct bio_vec *bvec;
@@ -713,7 +727,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (unlikely(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
-	if (((bio->bi_iter.bi_size + len) >> 9) > max_sectors)
+	if (((bio->bi_iter.bi_size + len) >> 9) > queue_max_hw_sectors(q))
 		return 0;
 
 	/*
@@ -726,28 +740,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 
 		if (page == prev->bv_page &&
 		    offset == prev->bv_offset + prev->bv_len) {
-			unsigned int prev_bv_len = prev->bv_len;
 			prev->bv_len += len;
-
-			if (q->merge_bvec_fn) {
-				struct bvec_merge_data bvm = {
-					/* prev_bvec is already charged in
-					   bi_size, discharge it in order to
-					   simulate merging updated prev_bvec
-					   as new bvec. */
-					.bi_bdev = bio->bi_bdev,
-					.bi_sector = bio->bi_iter.bi_sector,
-					.bi_size = bio->bi_iter.bi_size -
-						prev_bv_len,
-					.bi_rw = bio->bi_rw,
-				};
-
-				if (q->merge_bvec_fn(q, &bvm, prev) < prev->bv_len) {
-					prev->bv_len -= len;
-					return 0;
-				}
-			}
-
 			bio->bi_iter.bi_size += len;
 			goto done;
 		}
@@ -790,27 +783,6 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		blk_recount_segments(q, bio);
 	}
 
-	/*
-	 * if queue has other restrictions (eg varying max sector size
-	 * depending on offset), it can specify a merge_bvec_fn in the
-	 * queue to get further control
-	 */
-	if (q->merge_bvec_fn) {
-		struct bvec_merge_data bvm = {
-			.bi_bdev = bio->bi_bdev,
-			.bi_sector = bio->bi_iter.bi_sector,
-			.bi_size = bio->bi_iter.bi_size - len,
-			.bi_rw = bio->bi_rw,
-		};
-
-		/*
-		 * merge_bvec_fn() returns number of bytes it can accept
-		 * at this offset
-		 */
-		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len)
-			goto failed;
-	}
-
 	/* If we may be able to merge these biovecs, force a recount */
 	if (bio->bi_vcnt > 1 && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
@@ -827,28 +799,6 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	blk_recount_segments(q, bio);
 	return 0;
 }
-
-/**
- *	bio_add_pc_page	-	attempt to add page to bio
- *	@q: the target queue
- *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
- *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block device
- *	limitations. The target block device must allow bio's up to PAGE_SIZE,
- *	so it is always possible to add a single page to an empty bio.
- *
- *	This should only be used by REQ_PC bios.
- */
-int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
-		    unsigned int len, unsigned int offset)
-{
-	return __bio_add_page(q, bio, page, len, offset,
-			      queue_max_hw_sectors(q));
-}
 EXPORT_SYMBOL(bio_add_pc_page);
 
 /**
@@ -858,22 +808,47 @@ EXPORT_SYMBOL(bio_add_pc_page);
  *	@len: vec entry length
  *	@offset: vec entry offset
  *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block device
- *	limitations. The target block device must allow bio's up to PAGE_SIZE,
- *	so it is always possible to add a single page to an empty bio.
+ *	Attempt to add a page to the bio_vec maplist. This will only fail if
+ *	bio->bi_vcnt == bio->bi_max_vecs.
  */
-int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
-		 unsigned int offset)
+int bio_add_page(struct bio *bio, struct page *page,
+		 unsigned int len, unsigned int offset)
 {
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	unsigned int max_sectors;
+	struct bio_vec *bv;
+
+	/*
+	 * cloned bio must not modify vec list
+	 */
+	if (unlikely(bio_flagged(bio, BIO_CLONED)))
+		return 0;
+
+	/*
+	 * For filesystems with a blocksize smaller than the pagesize
+	 * we will often be called with the same page as last time and
+	 * a consecutive offset.  Optimize this special case.
+	 */
+	if (bio->bi_vcnt > 0) {
+		bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		if (page == bv->bv_page &&
+		    offset == bv->bv_offset + bv->bv_len) {
+			bv->bv_len += len;
+			goto done;
+		}
+	}
 
-	max_sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector);
-	if ((max_sectors < (len >> 9)) && !bio->bi_iter.bi_size)
-		max_sectors = len >> 9;
+	if (bio->bi_vcnt >= bio->bi_max_vecs)
+		return 0;
 
-	return __bio_add_page(q, bio, page, len, offset, max_sectors);
+	bv		= &bio->bi_io_vec[bio->bi_vcnt];
+	bv->bv_page	= page;
+	bv->bv_len	= len;
+	bv->bv_offset	= offset;
+
+	bio->bi_vcnt++;
+done:
+	bio->bi_iter.bi_size += len;
+	return len;
 }
 EXPORT_SYMBOL(bio_add_page);
 
-- 
2.1.0

