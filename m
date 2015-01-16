Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbbAPMGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:06:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:44175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbbAPMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:05:58 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Dongsu Park <dongsu.park@profitbricks.com>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] block: add a helper to free bio bounce buffer pages
Date: Fri, 16 Jan 2015 13:04:51 +0100
Message-Id: <1421409895-21377-4-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421409895-21377-1-git-send-email-hch@lst.de>
References: <1421409895-21377-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code sniplet to walk all bio_vecs and free their pages is opencoded in
way to many places, so factor it into a helper.  Also convert the slightly
more complex cases in bio_kern_endio and __bio_copy_iov where we break
the freeing from an existing loop into a separate one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 65 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 879921e..0895f69 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1048,7 +1048,7 @@ static struct bio_map_data *bio_alloc_map_data(unsigned int iov_count,
 }
 
 static int __bio_copy_iov(struct bio *bio, const struct sg_iovec *iov, int iov_count,
-			  int to_user, int from_user, int do_free_page)
+                          int to_user, int from_user)
 {
 	int ret = 0, i;
 	struct bio_vec *bvec;
@@ -1090,14 +1090,20 @@ static int __bio_copy_iov(struct bio *bio, const struct sg_iovec *iov, int iov_c
 				iov_off = 0;
 			}
 		}
-
-		if (do_free_page)
-			__free_page(bvec->bv_page);
 	}
 
 	return ret;
 }
 
+static void bio_free_pages(struct bio *bio)
+{
+	struct bio_vec *bvec;
+	int i;
+
+	bio_for_each_segment_all(bvec, bio, i)
+		__free_page(bvec->bv_page);
+}
+
 /**
  *	bio_uncopy_user	-	finish previously mapped bio
  *	@bio: bio being terminated
@@ -1108,8 +1114,7 @@ static int __bio_copy_iov(struct bio *bio, const struct sg_iovec *iov, int iov_c
 int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
-	struct bio_vec *bvec;
-	int ret = 0, i;
+	int ret = 0;
 
 	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
 		/*
@@ -1118,11 +1123,9 @@ int bio_uncopy_user(struct bio *bio)
 		 */
 		if (current->mm)
 			ret = __bio_copy_iov(bio, bmd->sgvecs, bmd->nr_sgvecs,
-					     bio_data_dir(bio) == READ,
-					     0, bmd->is_our_pages);
-		else if (bmd->is_our_pages)
-			bio_for_each_segment_all(bvec, bio, i)
-				__free_page(bvec->bv_page);
+					     bio_data_dir(bio) == READ, 0);
+		if (bmd->is_our_pages)
+			bio_free_pages(bio);
 	}
 	kfree(bmd);
 	bio_put(bio);
@@ -1149,7 +1152,6 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 			      int write_to_vm, gfp_t gfp_mask)
 {
 	struct bio_map_data *bmd;
-	struct bio_vec *bvec;
 	struct page *page;
 	struct bio *bio;
 	int i, ret;
@@ -1238,7 +1240,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, iov, iov_count, 0, 1, 0);
+		ret = __bio_copy_iov(bio, iov, iov_count, 0, 1);
 		if (ret)
 			goto cleanup;
 	}
@@ -1247,9 +1249,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	return bio;
 cleanup:
 	if (!map_data)
-		bio_for_each_segment_all(bvec, bio, i)
-			__free_page(bvec->bv_page);
-
+		bio_free_pages(bio);
 	bio_put(bio);
 out_bmd:
 	kfree(bmd);
@@ -1510,22 +1510,22 @@ EXPORT_SYMBOL(bio_map_kern);
 
 static void bio_copy_kern_endio(struct bio *bio, int err)
 {
-	struct bio_vec *bvec;
-	const int read = bio_data_dir(bio) == READ;
+	bio_free_pages(bio);
+	bio_put(bio);
+}
+
+static void bio_copy_kern_endio_read(struct bio *bio, int err)
+{
 	char *p = bio->bi_private;
+	struct bio_vec *bvec;
 	int i;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		char *addr = page_address(bvec->bv_page);
-
-		if (read)
-			memcpy(p, addr, bvec->bv_len);
-
-		__free_page(bvec->bv_page);
+		memcpy(p, page_address(bvec->bv_page), bvec->bv_len);
 		p += bvec->bv_len;
 	}
 
-	bio_put(bio);
+	bio_copy_kern_endio(bio, err);
 }
 
 /**
@@ -1545,10 +1545,9 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 	unsigned long kaddr = (unsigned long)data;
 	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start = kaddr >> PAGE_SHIFT;
-	struct bio_vec *bvec;
 	struct bio *bio;
 	void *p = data;
-	int nr_pages = 0, i;
+	int nr_pages = 0;
 
 	/*
 	 * Overflow, abort
@@ -1582,16 +1581,18 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		p += bytes;
 	}
 
-	if (!reading)
+	if (reading) {
+		bio->bi_end_io = bio_copy_kern_endio_read;
+		bio->bi_private = data;
+	} else {
+		bio->bi_end_io = bio_copy_kern_endio;
 		bio->bi_rw |= REQ_WRITE;
+	}
 
-	bio->bi_private = data;
-	bio->bi_end_io = bio_copy_kern_endio;
 	return bio;
 
 cleanup:
-	bio_for_each_segment_all(bvec, bio, i)
-		__free_page(bvec->bv_page);
+	bio_free_pages(bio);
 	bio_put(bio);
 	return ERR_PTR(-ENOMEM);
 }
-- 
1.9.1

