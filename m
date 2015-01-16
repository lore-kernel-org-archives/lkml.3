Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbbAPMF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:05:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:44171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbbAPMF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:05:56 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Dongsu Park <dongsu.park@profitbricks.com>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] block: use blk_rq_map_user_iov to implement blk_rq_map_user
Date: Fri, 16 Jan 2015 13:04:50 +0100
Message-Id: <1421409895-21377-3-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421409895-21377-1-git-send-email-hch@lst.de>
References: <1421409895-21377-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         |  53 +-------------------
 block/blk-map.c     | 137 +++++-----------------------------------------------
 include/linux/bio.h |   4 --
 3 files changed, 14 insertions(+), 180 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 54da51e..879921e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1102,7 +1102,7 @@ static int __bio_copy_iov(struct bio *bio, const struct sg_iovec *iov, int iov_c
  *	bio_uncopy_user	-	finish previously mapped bio
  *	@bio: bio being terminated
  *
- *	Free pages allocated from bio_copy_user() and write back data
+ *	Free pages allocated from bio_copy_user_iov() and write back data
  *	to user space in case of a read.
  */
 int bio_uncopy_user(struct bio *bio)
@@ -1256,32 +1256,6 @@ out_bmd:
 	return ERR_PTR(ret);
 }
 
-/**
- *	bio_copy_user	-	copy user data to bio
- *	@q: destination block queue
- *	@map_data: pointer to the rq_map_data holding pages (if necessary)
- *	@uaddr: start of user address
- *	@len: length in bytes
- *	@write_to_vm: bool indicating writing to pages or not
- *	@gfp_mask: memory allocation flags
- *
- *	Prepares and returns a bio for indirect user io, bouncing data
- *	to/from kernel pages as necessary. Must be paired with
- *	call bio_uncopy_user() on io completion.
- */
-struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
-			  unsigned long uaddr, unsigned int len,
-			  int write_to_vm, gfp_t gfp_mask)
-{
-	struct sg_iovec iov;
-
-	iov.iov_base = (void __user *)uaddr;
-	iov.iov_len = len;
-
-	return bio_copy_user_iov(q, map_data, &iov, 1, write_to_vm, gfp_mask);
-}
-EXPORT_SYMBOL(bio_copy_user);
-
 static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      struct block_device *bdev,
 				      const struct sg_iovec *iov, int iov_count,
@@ -1395,31 +1369,6 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 }
 
 /**
- *	bio_map_user	-	map user address into bio
- *	@q: the struct request_queue for the bio
- *	@bdev: destination block device
- *	@uaddr: start of user address
- *	@len: length in bytes
- *	@write_to_vm: bool indicating writing to pages or not
- *	@gfp_mask: memory allocation flags
- *
- *	Map the user space address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
- */
-struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int write_to_vm,
-			 gfp_t gfp_mask)
-{
-	struct sg_iovec iov;
-
-	iov.iov_base = (void __user *)uaddr;
-	iov.iov_len = len;
-
-	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm, gfp_mask);
-}
-EXPORT_SYMBOL(bio_map_user);
-
-/**
  *	bio_map_user_iov - map user sg_iovec table into bio
  *	@q: the struct request_queue for the bio
  *	@bdev: destination block device
diff --git a/block/blk-map.c b/block/blk-map.c
index f890d43..152a5fe 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -39,130 +39,6 @@ static int __blk_rq_unmap_user(struct bio *bio)
 	return ret;
 }
 
-static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
-			     struct rq_map_data *map_data, void __user *ubuf,
-			     unsigned int len, gfp_t gfp_mask)
-{
-	unsigned long uaddr;
-	struct bio *bio, *orig_bio;
-	int reading, ret;
-
-	reading = rq_data_dir(rq) == READ;
-
-	/*
-	 * if alignment requirement is satisfied, map in user pages for
-	 * direct dma. else, set up kernel bounce buffers
-	 */
-	uaddr = (unsigned long) ubuf;
-	if (blk_rq_aligned(q, uaddr, len) && !map_data)
-		bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
-	else
-		bio = bio_copy_user(q, map_data, uaddr, len, reading, gfp_mask);
-
-	if (IS_ERR(bio))
-		return PTR_ERR(bio);
-
-	if (map_data && map_data->null_mapped)
-		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
-
-	orig_bio = bio;
-	blk_queue_bounce(q, &bio);
-
-	/*
-	 * We link the bounce buffer in and could have to traverse it
-	 * later so we have to get a ref to prevent it from being freed
-	 */
-	bio_get(bio);
-
-	ret = blk_rq_append_bio(q, rq, bio);
-	if (!ret)
-		return bio->bi_iter.bi_size;
-
-	/* if it was boucned we must call the end io function */
-	bio_endio(bio, 0);
-	__blk_rq_unmap_user(orig_bio);
-	bio_put(bio);
-	return ret;
-}
-
-/**
- * blk_rq_map_user - map user data to a request, for REQ_TYPE_BLOCK_PC usage
- * @q:		request queue where request should be inserted
- * @rq:		request structure to fill
- * @map_data:   pointer to the rq_map_data holding pages (if necessary)
- * @ubuf:	the user buffer
- * @len:	length of user data
- * @gfp_mask:	memory allocation flags
- *
- * Description:
- *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
- *    a kernel bounce buffer is used.
- *
- *    A matching blk_rq_unmap_user() must be issued at the end of I/O, while
- *    still in process context.
- *
- *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
- *    before being submitted to the device, as pages mapped may be out of
- *    reach. It's the callers responsibility to make sure this happens. The
- *    original bio must be passed back in to blk_rq_unmap_user() for proper
- *    unmapping.
- */
-int blk_rq_map_user(struct request_queue *q, struct request *rq,
-		    struct rq_map_data *map_data, void __user *ubuf,
-		    unsigned long len, gfp_t gfp_mask)
-{
-	unsigned long bytes_read = 0;
-	struct bio *bio = NULL;
-	int ret;
-
-	if (len > (queue_max_hw_sectors(q) << 9))
-		return -EINVAL;
-	if (!len)
-		return -EINVAL;
-
-	if (!ubuf && (!map_data || !map_data->null_mapped))
-		return -EINVAL;
-
-	while (bytes_read != len) {
-		unsigned long map_len, end, start;
-
-		map_len = min_t(unsigned long, len - bytes_read, BIO_MAX_SIZE);
-		end = ((unsigned long)ubuf + map_len + PAGE_SIZE - 1)
-								>> PAGE_SHIFT;
-		start = (unsigned long)ubuf >> PAGE_SHIFT;
-
-		/*
-		 * A bad offset could cause us to require BIO_MAX_PAGES + 1
-		 * pages. If this happens we just lower the requested
-		 * mapping len by a page so that we can fit
-		 */
-		if (end - start > BIO_MAX_PAGES)
-			map_len -= PAGE_SIZE;
-
-		ret = __blk_rq_map_user(q, rq, map_data, ubuf, map_len,
-					gfp_mask);
-		if (ret < 0)
-			goto unmap_rq;
-		if (!bio)
-			bio = rq->bio;
-		bytes_read += ret;
-		ubuf += ret;
-
-		if (map_data)
-			map_data->offset += ret;
-	}
-
-	if (!bio_flagged(bio, BIO_USER_MAPPED))
-		rq->cmd_flags |= REQ_COPY_USER;
-
-	return 0;
-unmap_rq:
-	blk_rq_unmap_user(bio);
-	rq->bio = NULL;
-	return ret;
-}
-EXPORT_SYMBOL(blk_rq_map_user);
-
 /**
  * blk_rq_map_user_iov - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
@@ -241,6 +117,19 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 }
 EXPORT_SYMBOL(blk_rq_map_user_iov);
 
+int blk_rq_map_user(struct request_queue *q, struct request *rq,
+		    struct rq_map_data *map_data, void __user *ubuf,
+		    unsigned long len, gfp_t gfp_mask)
+{
+	struct sg_iovec iov;
+
+	iov.iov_base = (void __user *)ubuf;
+	iov.iov_len = len;
+
+	return blk_rq_map_user_iov(q, rq, map_data, &iov, 1, len, gfp_mask);
+}
+EXPORT_SYMBOL(blk_rq_map_user);
+
 /**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	       start of bio list
diff --git a/include/linux/bio.h b/include/linux/bio.h
index efead0b..d0d6735 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -428,8 +428,6 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
-				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
 struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
@@ -462,8 +460,6 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
 extern void bio_copy_data(struct bio *dst, struct bio *src);
 extern int bio_alloc_pages(struct bio *bio, gfp_t gfp);
 
-extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
-				 unsigned long, unsigned int, int, gfp_t);
 extern struct bio *bio_copy_user_iov(struct request_queue *,
 				     struct rq_map_data *,
 				     const struct sg_iovec *,
-- 
1.9.1

