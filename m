Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaBZXkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:40:21 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51967 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaBZXkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:40:06 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 2/9] block: Gut bio_add_page()
Date: Wed, 26 Feb 2014 15:39:50 -0800
Message-Id: <1393457997-17618-3-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
References: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since generic_make_request() can now handle arbitrary size bios, all we
have to do is make sure the bvec array doesn't overflow.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c | 137 ++++++++++++++++++++++++++-------------------------------------
 1 file changed, 57 insertions(+), 80 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b2dd42ed9e..8985cc784d 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -694,9 +694,23 @@ int bio_get_nr_vecs(struct block_device *bdev)
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
@@ -707,7 +721,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	if (unlikely(bio_flagged(bio, BIO_CLONED)))
 		return 0;
 
-	if (((bio->bi_iter.bi_size + len) >> 9) > max_sectors)
+	if (((bio->bi_iter.bi_size + len) >> 9) > queue_max_hw_sectors(q))
 		return 0;
 
 	/*
@@ -720,28 +734,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 
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
 			goto done;
 		}
 	}
@@ -772,31 +765,6 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 
-	/*
-	 * if queue has other restrictions (eg varying max sector size
-	 * depending on offset), it can specify a merge_bvec_fn in the
-	 * queue to get further control
-	 */
-	if (q->merge_bvec_fn) {
-		struct bvec_merge_data bvm = {
-			.bi_bdev = bio->bi_bdev,
-			.bi_sector = bio->bi_iter.bi_sector,
-			.bi_size = bio->bi_iter.bi_size,
-			.bi_rw = bio->bi_rw,
-		};
-
-		/*
-		 * merge_bvec_fn() returns number of bytes it can accept
-		 * at this offset
-		 */
-		if (q->merge_bvec_fn(q, &bvm, bvec) < bvec->bv_len) {
-			bvec->bv_page = NULL;
-			bvec->bv_len = 0;
-			bvec->bv_offset = 0;
-			return 0;
-		}
-	}
-
 	/* If we may be able to merge these biovecs, force a recount */
 	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
@@ -807,28 +775,6 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	bio->bi_iter.bi_size += len;
 	return len;
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
@@ -838,16 +784,47 @@ EXPORT_SYMBOL(bio_add_pc_page);
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
-	return __bio_add_page(q, bio, page, len, offset, queue_max_sectors(q));
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
+
+	if (bio->bi_vcnt >= bio->bi_max_vecs)
+		return 0;
+
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
1.9.0

