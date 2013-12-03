Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3LCWC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:02:26 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37402 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab3LCWAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:47 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 08/11] block: convert to iov_iter
Date: Tue,  3 Dec 2013 14:00:14 -0800
Message-Id: <1386108017-27964-9-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 block/blk-map.c        |  27 ++++++------
 block/scsi_ioctl.c     |  17 ++------
 drivers/scsi/sg.c      |  15 +++----
 fs/bio.c               | 113 +++++++++++++++++++++++++------------------------
 include/linux/bio.h    |   8 ++--
 include/linux/blkdev.h |   3 +-
 6 files changed, 86 insertions(+), 97 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index ae4ae10..d4faf7b 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <scsi/sg.h>		/* for struct sg_iovec */
+#include <linux/uio.h>
 
 #include "blk.h"
 
@@ -188,20 +188,22 @@ EXPORT_SYMBOL(blk_rq_map_user);
  *    unmapping.
  */
 int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
-			struct rq_map_data *map_data, struct sg_iovec *iov,
-			int iov_count, unsigned int len, gfp_t gfp_mask)
+			struct rq_map_data *map_data, struct iov_iter *iter,
+			gfp_t gfp_mask)
 {
 	struct bio *bio;
-	int i, read = rq_data_dir(rq) == READ;
+	int read = rq_data_dir(rq) == READ;
 	int unaligned = 0;
+	struct iov_iter i;
+	struct iovec iov;
 
-	if (!iov || iov_count <= 0)
+	if (!iter || !iter->count)
 		return -EINVAL;
 
-	for (i = 0; i < iov_count; i++) {
-		unsigned long uaddr = (unsigned long)iov[i].iov_base;
+	iov_for_each(iov, i, *iter) {
+		unsigned long uaddr = (unsigned long) iov.iov_base;
 
-		if (!iov[i].iov_len)
+		if (!iov.iov_len)
 			return -EINVAL;
 
 		/*
@@ -211,16 +213,15 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			unaligned = 1;
 	}
 
-	if (unaligned || (q->dma_pad_mask & len) || map_data)
-		bio = bio_copy_user_iov(q, map_data, iov, iov_count, read,
-					gfp_mask);
+	if (unaligned || (q->dma_pad_mask & iter->count) || map_data)
+		bio = bio_copy_user_iov(q, map_data, iter, read, gfp_mask);
 	else
-		bio = bio_map_user_iov(q, NULL, iov, iov_count, read, gfp_mask);
+		bio = bio_map_user_iov(q, NULL, iter, read, gfp_mask);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (bio->bi_iter.bi_size != len) {
+	if (bio->bi_iter.bi_size != iter->count) {
 		/*
 		 * Grab an extra reference to this bio, as bio_unmap_user()
 		 * expects to be able to drop it twice as it happens on the
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 625e3e4..7ae554a 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -322,28 +322,19 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	}
 
 	if (hdr->iovec_count) {
-		size_t iov_data_len;
 		struct iovec *iov;
+		struct iov_iter i;
 
 		ret = rw_copy_check_uvector(-1, hdr->dxferp, hdr->iovec_count,
 					    0, NULL, &iov);
 		if (ret < 0)
 			goto out;
 
-		iov_data_len = ret;
-		ret = 0;
-
 		/* SG_IO howto says that the shorter of the two wins */
-		if (hdr->dxfer_len < iov_data_len) {
-			hdr->iovec_count = iov_shorten(iov,
-						       hdr->iovec_count,
-						       hdr->dxfer_len);
-			iov_data_len = hdr->dxfer_len;
-		}
+		iov_iter_init(&i, iov, hdr->iovec_count,
+			      min(ret, hdr->dxfer_len));
 
-		ret = blk_rq_map_user_iov(q, rq, NULL, (struct sg_iovec *) iov,
-					  hdr->iovec_count,
-					  iov_data_len, GFP_KERNEL);
+		ret = blk_rq_map_user_iov(q, rq, NULL, &i, GFP_KERNEL);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
 		ret = blk_rq_map_user(q, rq, NULL, hdr->dxferp, hdr->dxfer_len,
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..5cc44b9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1695,22 +1695,19 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	}
 
 	if (iov_count) {
-		int len, size = sizeof(struct sg_iovec) * iov_count;
+		int size = sizeof(struct sg_iovec) * iov_count;
 		struct iovec *iov;
+		struct iov_iter i;
 
 		iov = memdup_user(hp->dxferp, size);
 		if (IS_ERR(iov))
 			return PTR_ERR(iov);
 
-		len = iov_length(iov, iov_count);
-		if (hp->dxfer_len < len) {
-			iov_count = iov_shorten(iov, iov_count, hp->dxfer_len);
-			len = hp->dxfer_len;
-		}
+		iov_iter_init(&i, iov, iov_count,
+			      min_t(size_t, hp->dxfer_len,
+				    iov_length(iov, iov_count)));
 
-		res = blk_rq_map_user_iov(q, rq, md, (struct sg_iovec *)iov,
-					  iov_count,
-					  len, GFP_ATOMIC);
+		res = blk_rq_map_user_iov(q, rq, md, &i, GFP_ATOMIC);
 		kfree(iov);
 	} else
 		res = blk_rq_map_user(q, rq, md, hp->dxferp,
diff --git a/fs/bio.c b/fs/bio.c
index da27557..a7e5789 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -969,18 +969,17 @@ void bio_copy_data(struct bio *dst, struct bio *src)
 EXPORT_SYMBOL(bio_copy_data);
 
 struct bio_map_data {
-	int nr_sgvecs;
 	int is_our_pages;
-	struct sg_iovec sgvecs[];
+	struct iov_iter iter;
+	struct iovec sgvecs[];
 };
 
 static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
-			     struct sg_iovec *iov, int iov_count,
-			     int is_our_pages)
+			     struct iov_iter *iter, int is_our_pages)
 {
-	memcpy(bmd->sgvecs, iov, sizeof(struct sg_iovec) * iov_count);
-	bmd->nr_sgvecs = iov_count;
 	bmd->is_our_pages = is_our_pages;
+	bmd->iter = *iter;
+	memcpy(bmd->sgvecs, iter->iov, sizeof(struct iovec) * iter->nr_segs);
 	bio->bi_private = bmd;
 }
 
@@ -995,33 +994,30 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs,
 		       sizeof(struct sg_iovec) * iov_count, gfp_mask);
 }
 
-static int __bio_copy_iov(struct bio *bio, struct sg_iovec *iov, int iov_count,
+static int __bio_copy_iov(struct bio *bio, struct iov_iter *iter,
 			  int to_user, int from_user, int do_free_page)
 {
 	int ret = 0, i;
 	struct bio_vec *bvec;
-	int iov_idx = 0;
-	unsigned int iov_off = 0;
+	struct iov_iter iov_iter = *iter;
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		char *bv_addr = page_address(bvec->bv_page);
 		unsigned int bv_len = bvec->bv_len;
 
-		while (bv_len && iov_idx < iov_count) {
-			unsigned int bytes;
-			char __user *iov_addr;
-
-			bytes = min_t(unsigned int,
-				      iov[iov_idx].iov_len - iov_off, bv_len);
-			iov_addr = iov[iov_idx].iov_base + iov_off;
+		while (bv_len && iov_iter.count) {
+			struct iovec iov = iov_iter_iovec(&iov_iter);
+			unsigned int bytes = min_t(unsigned int, bv_len,
+						   iov.iov_len);
 
 			if (!ret) {
 				if (to_user)
-					ret = copy_to_user(iov_addr, bv_addr,
-							   bytes);
+					ret = copy_to_user(iov.iov_base,
+							   bv_addr, bytes);
 
 				if (from_user)
-					ret = copy_from_user(bv_addr, iov_addr,
+					ret = copy_from_user(bv_addr,
+							     iov.iov_base,
 							     bytes);
 
 				if (ret)
@@ -1030,13 +1026,7 @@ static int __bio_copy_iov(struct bio *bio, struct sg_iovec *iov, int iov_count,
 
 			bv_len -= bytes;
 			bv_addr += bytes;
-			iov_addr += bytes;
-			iov_off += bytes;
-
-			if (iov[iov_idx].iov_len == iov_off) {
-				iov_idx++;
-				iov_off = 0;
-			}
+			iov_iter_advance(&iov_iter, bytes);
 		}
 
 		if (do_free_page)
@@ -1065,7 +1055,7 @@ int bio_uncopy_user(struct bio *bio)
 		 * don't copy into a random user address space, just free.
 		 */
 		if (current->mm)
-			ret = __bio_copy_iov(bio, bmd->sgvecs, bmd->nr_sgvecs,
+			ret = __bio_copy_iov(bio, &bmd->iter,
 					     bio_data_dir(bio) == READ,
 					     0, bmd->is_our_pages);
 		else if (bmd->is_our_pages)
@@ -1093,7 +1083,7 @@ EXPORT_SYMBOL(bio_uncopy_user);
  */
 struct bio *bio_copy_user_iov(struct request_queue *q,
 			      struct rq_map_data *map_data,
-			      struct sg_iovec *iov, int iov_count,
+			      struct iov_iter *iter,
 			      int write_to_vm, gfp_t gfp_mask)
 {
 	struct bio_map_data *bmd;
@@ -1102,16 +1092,16 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	struct bio *bio;
 	int i, ret;
 	int nr_pages = 0;
-	unsigned int len = 0;
+	unsigned int len;
 	unsigned int offset = map_data ? map_data->offset & ~PAGE_MASK : 0;
 
-	for (i = 0; i < iov_count; i++) {
+	for (i = 0; i < iter->nr_segs; i++) {
 		unsigned long uaddr;
 		unsigned long end;
 		unsigned long start;
 
-		uaddr = (unsigned long)iov[i].iov_base;
-		end = (uaddr + iov[i].iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		uaddr = (unsigned long) iter->iov[i].iov_base;
+		end = (uaddr + iter->iov[i].iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		start = uaddr >> PAGE_SHIFT;
 
 		/*
@@ -1121,13 +1111,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 			return ERR_PTR(-EINVAL);
 
 		nr_pages += end - start;
-		len += iov[i].iov_len;
 	}
 
 	if (offset)
 		nr_pages++;
 
-	bmd = bio_alloc_map_data(nr_pages, iov_count, gfp_mask);
+	bmd = bio_alloc_map_data(nr_pages, iter->nr_segs, gfp_mask);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
@@ -1144,7 +1133,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	if (map_data) {
 		nr_pages = 1 << map_data->page_order;
 		i = map_data->offset / PAGE_SIZE;
+	} else {
+		i = 0;
 	}
+
+	len = iter->count;
+
 	while (len) {
 		unsigned int bytes = PAGE_SIZE;
 
@@ -1186,12 +1180,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, iov, iov_count, 0, 1, 0);
+		ret = __bio_copy_iov(bio, iter, 0, 1, 0);
 		if (ret)
 			goto cleanup;
 	}
 
-	bio_set_map_data(bmd, bio, iov, iov_count, map_data ? 0 : 1);
+	bio_set_map_data(bmd, bio, iter, map_data ? 0 : 1);
 	return bio;
 cleanup:
 	if (!map_data)
@@ -1221,30 +1215,35 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
 			  unsigned long uaddr, unsigned int len,
 			  int write_to_vm, gfp_t gfp_mask)
 {
-	struct sg_iovec iov;
+	struct iovec iov;
+	struct iov_iter i;
 
-	iov.iov_base = (void __user *)uaddr;
+	iov.iov_base = (void __user *) uaddr;
 	iov.iov_len = len;
 
-	return bio_copy_user_iov(q, map_data, &iov, 1, write_to_vm, gfp_mask);
+	iov_iter_init(&i, &iov, 1, len);
+
+	return bio_copy_user_iov(q, map_data, &i, write_to_vm, gfp_mask);
 }
 EXPORT_SYMBOL(bio_copy_user);
 
 static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      struct block_device *bdev,
-				      struct sg_iovec *iov, int iov_count,
+				      struct iov_iter *iter,
 				      int write_to_vm, gfp_t gfp_mask)
 {
-	int i, j;
+	int j;
 	int nr_pages = 0;
 	struct page **pages;
 	struct bio *bio;
 	int cur_page = 0;
 	int ret, offset;
+	struct iov_iter i;
+	struct iovec iov;
 
-	for (i = 0; i < iov_count; i++) {
-		unsigned long uaddr = (unsigned long)iov[i].iov_base;
-		unsigned long len = iov[i].iov_len;
+	iov_for_each(iov, i, *iter) {
+		unsigned long uaddr = (unsigned long) iov.iov_base;
+		unsigned long len = iov.iov_len;
 		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		unsigned long start = uaddr >> PAGE_SHIFT;
 
@@ -1274,9 +1273,9 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!pages)
 		goto out;
 
-	for (i = 0; i < iov_count; i++) {
-		unsigned long uaddr = (unsigned long)iov[i].iov_base;
-		unsigned long len = iov[i].iov_len;
+	iov_for_each(iov, i, *iter) {
+		unsigned long uaddr = (unsigned long) iov.iov_base;
+		unsigned long len = iov.iov_len;
 		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		unsigned long start = uaddr >> PAGE_SHIFT;
 		const int local_nr_pages = end - start;
@@ -1331,10 +1330,10 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	return bio;
 
  out_unmap:
-	for (i = 0; i < nr_pages; i++) {
-		if(!pages[i])
+	for (j = 0; j < nr_pages; j++) {
+		if(!pages[j])
 			break;
-		page_cache_release(pages[i]);
+		page_cache_release(pages[j]);
 	}
  out:
 	kfree(pages);
@@ -1358,12 +1357,15 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
 			 unsigned long uaddr, unsigned int len, int write_to_vm,
 			 gfp_t gfp_mask)
 {
-	struct sg_iovec iov;
+	struct iovec iov;
+	struct iov_iter i;
 
-	iov.iov_base = (void __user *)uaddr;
+	iov.iov_base = (void __user *) uaddr;
 	iov.iov_len = len;
 
-	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm, gfp_mask);
+	iov_iter_init(&i, &iov, 1, len);
+
+	return bio_map_user_iov(q, bdev, &i, write_to_vm, gfp_mask);
 }
 EXPORT_SYMBOL(bio_map_user);
 
@@ -1380,13 +1382,12 @@ EXPORT_SYMBOL(bio_map_user);
  *	device. Returns an error pointer in case of error.
  */
 struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
-			     struct sg_iovec *iov, int iov_count,
+			     struct iov_iter *iter,
 			     int write_to_vm, gfp_t gfp_mask)
 {
 	struct bio *bio;
 
-	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm,
-				 gfp_mask);
+	bio = __bio_map_user_iov(q, bdev, iter, write_to_vm, gfp_mask);
 	if (IS_ERR(bio))
 		return bio;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7065452..068f199 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -372,11 +372,11 @@ extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 extern int bio_get_nr_vecs(struct block_device *);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
-struct sg_iovec;
+struct iov_iter;
 struct rq_map_data;
 extern struct bio *bio_map_user_iov(struct request_queue *,
 				    struct block_device *,
-				    struct sg_iovec *, int, int, gfp_t);
+				    struct iov_iter *, int, gfp_t);
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				gfp_t);
@@ -402,8 +402,8 @@ extern int bio_alloc_pages(struct bio *bio, gfp_t gfp);
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
 extern struct bio *bio_copy_user_iov(struct request_queue *,
-				     struct rq_map_data *, struct sg_iovec *,
-				     int, int, gfp_t);
+				     struct rq_map_data *, struct iov_iter *,
+				     int, gfp_t);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
 extern struct bio_vec *bvec_alloc(gfp_t, int, unsigned long *, mempool_t *);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 88d4e7b..33bec67 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -833,8 +833,7 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
 extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
-			       struct rq_map_data *, struct sg_iovec *, int,
-			       unsigned int, gfp_t);
+			       struct rq_map_data *, struct iov_iter *, gfp_t);
 extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
-- 
1.8.4.4

