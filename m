Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbbAPMHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:07:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:44190 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbbAPMGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:06:05 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Dongsu Park <dongsu.park@profitbricks.com>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] block: merge __bio_map_user_iov into bio_map_user_iov
Date: Fri, 16 Jan 2015 13:04:54 +0100
Message-Id: <1421409895-21377-7-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421409895-21377-1-git-send-email-hch@lst.de>
References: <1421409895-21377-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And also remove the unused bdev argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 56 +++++++++++++++++++----------------------------------
 block/blk-map.c     |  2 +-
 include/linux/bio.h |  1 -
 3 files changed, 21 insertions(+), 38 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index a69a9c9..0723d4c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1244,10 +1244,18 @@ out_bmd:
 	return ERR_PTR(ret);
 }
 
-static struct bio *__bio_map_user_iov(struct request_queue *q,
-				      struct block_device *bdev,
-				      const struct iov_iter *iter,
-				      gfp_t gfp_mask)
+/**
+ *	bio_map_user_iov - map user iovec into bio
+ *	@q:		the struct request_queue for the bio
+ *	@iter:		iovec iterator
+ *	@gfp_mask:	memory allocation flags
+ *
+ *	Map the user space address into a bio suitable for io to a block
+ *	device. Returns an error pointer in case of error.
+ */
+struct bio *bio_map_user_iov(struct request_queue *q,
+			     const struct iov_iter *iter,
+			     gfp_t gfp_mask)
 {
 	int j;
 	int nr_pages = 0;
@@ -1343,8 +1351,15 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (iter->type & WRITE)
 		bio->bi_rw |= REQ_WRITE;
 
-	bio->bi_bdev = bdev;
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
+
+	/*
+	 * subtle -- if __bio_map_user() ended up bouncing a bio,
+	 * it would normally disappear when its bi_end_io is run.
+	 * however, we need it for the unmap, so grab an extra
+	 * reference to it
+	 */
+	bio_get(bio);
 	return bio;
 
  out_unmap:
@@ -1359,37 +1374,6 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	return ERR_PTR(ret);
 }
 
-/**
- *	bio_map_user_iov - map user iovec into bio
- *	@q:		the struct request_queue for the bio
- *	@bdev:		destination block device
- *	@iter:		iovec iterator
- *	@gfp_mask:	memory allocation flags
- *
- *	Map the user space address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
- */
-struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
-			     const struct iov_iter *iter,
-			     gfp_t gfp_mask)
-{
-	struct bio *bio;
-
-	bio = __bio_map_user_iov(q, bdev, iter, gfp_mask);
-	if (IS_ERR(bio))
-		return bio;
-
-	/*
-	 * subtle -- if __bio_map_user() ended up bouncing a bio,
-	 * it would normally disappear when its bi_end_io is run.
-	 * however, we need it for the unmap, so grab an extra
-	 * reference to it
-	 */
-	bio_get(bio);
-
-	return bio;
-}
-
 static void __bio_unmap_user(struct bio *bio)
 {
 	struct bio_vec *bvec;
diff --git a/block/blk-map.c b/block/blk-map.c
index 30e6bb8..0f22911 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -88,7 +88,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	if (unaligned || (q->dma_pad_mask & iter->count) || map_data)
 		bio = bio_copy_user_iov(q, map_data, iter, gfp_mask);
 	else
-		bio = bio_map_user_iov(q, NULL, iter, gfp_mask);
+		bio = bio_map_user_iov(q, iter, gfp_mask);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0d6105b..da3a127 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -430,7 +430,6 @@ extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 extern int bio_get_nr_vecs(struct block_device *);
 struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
-				    struct block_device *,
 				    const struct iov_iter *, gfp_t);
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
-- 
1.9.1

