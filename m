Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaLVLua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:50:30 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42569 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaLVLuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:50:23 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [RFC PATCH 10/17] block: refactor bio_get_user_pages() from __bio_map_user_iov()
Date: Mon, 22 Dec 2014 12:48:37 +0100
Message-Id: <4334b90a56b96ad7a11e4ba7eb97c2cf4405950d.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <d42dae3d2a64fa4c3a0893f1af963151b31869e3.1419241597.git.dongsu.park@profitbricks.com>
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
In-Reply-To: <cover.1419241597.git.dongsu.park@profitbricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Split up a part of the code that was in __bio_map_user_iov() into
a new function bio_get_user_pages(). This helper is going to be used
by future block layer rewriting, especially from direct-IO part.

Note that this relies on the recent change to make
generic_make_request() take arbitrarily sized bios - we're not using
bio_add_page() here.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/bio.c         | 130 +++++++++++++++++++++++++++-------------------------
 include/linux/bio.h |   2 +
 2 files changed, 70 insertions(+), 62 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2adb68b..470e330 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1228,19 +1228,79 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
 }
 EXPORT_SYMBOL(bio_copy_user);
 
+/**
+ * bio_get_user_pages - pin user pages and add them to a biovec
+ * @bio: bio to add pages to
+ * @uaddr: start of user address
+ * @len: length in bytes
+ * @write_to_vm: bool indicating writing to pages or not
+ *
+ * Pins pages for up to @len bytes and appends them to @bio's bvec array. May
+ * pin only part of the requested pages - @bio need not have room for all the
+ * pages and can already have had pages added to it.
+ *
+ * Returns the number of bytes from @len added to @bio.
+ */
+ssize_t bio_get_user_pages(struct bio *bio, struct iov_iter *i, int write_to_vm)
+{
+	while (bio->bi_vcnt < bio->bi_max_vecs && iov_iter_count(i)) {
+		struct iovec iov = iov_iter_iovec(i);
+		int ret;
+		unsigned nr_pages, bytes;
+		unsigned offset = offset_in_page(iov.iov_base);
+		struct bio_vec *bv;
+		struct page **pages;
+
+		nr_pages = min_t(size_t,
+				 DIV_ROUND_UP(iov.iov_len + offset, PAGE_SIZE),
+				 bio->bi_max_vecs - bio->bi_vcnt);
+
+		bv = &bio->bi_io_vec[bio->bi_vcnt];
+		pages = (void *) bv;
+
+		ret = get_user_pages_fast((unsigned long) iov.iov_base,
+					  nr_pages, write_to_vm, pages);
+		if (ret < 0) {
+			if (bio->bi_vcnt)
+				return 0;
+
+			return ret;
+		}
+
+		bio->bi_vcnt += ret;
+		bytes = ret * PAGE_SIZE - offset;
+
+		while (ret--) {
+			bv[ret].bv_page = pages[ret];
+			bv[ret].bv_len = PAGE_SIZE;
+			bv[ret].bv_offset = 0;
+		}
+
+		bv[0].bv_offset += offset;
+		bv[0].bv_len -= offset;
+
+		if (bytes > iov.iov_len) {
+			bio->bi_io_vec[bio->bi_vcnt - 1].bv_len -=
+				bytes - iov.iov_len;
+			bytes = iov.iov_len;
+		}
+
+		bio->bi_iter.bi_size += bytes;
+		iov_iter_advance(i, bytes);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(bio_get_user_pages);
+
 static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      struct block_device *bdev,
 				      const struct iov_iter *iter,
 				      int write_to_vm, gfp_t gfp_mask)
 {
-	int j;
+	ssize_t ret;
 	int nr_pages = 0;
-	struct page **pages;
 	struct bio *bio;
-	int cur_page = 0;
-	int ret, offset;
-	struct iov_iter i;
-	struct iovec iov;
 
 	nr_pages = iov_count_pages(iter, queue_dma_alignment(q));
 	if (nr_pages < 0)
@@ -1253,57 +1313,10 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
-	ret = -ENOMEM;
-	pages = kcalloc(nr_pages, sizeof(struct page *), gfp_mask);
-	if (!pages)
+	ret = bio_get_user_pages(bio, (struct iov_iter *)iter, write_to_vm);
+	if (ret < 0)
 		goto out;
 
-	iov_for_each(iov, i, *iter) {
-		unsigned long uaddr = (unsigned long) iov.iov_base;
-		unsigned long len = iov.iov_len;
-		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		unsigned long start = uaddr >> PAGE_SHIFT;
-		const int local_nr_pages = end - start;
-		const int page_limit = cur_page + local_nr_pages;
-
-		ret = get_user_pages_fast(uaddr, local_nr_pages,
-				write_to_vm, &pages[cur_page]);
-		if (ret < local_nr_pages) {
-			ret = -EFAULT;
-			goto out_unmap;
-		}
-
-		offset = uaddr & ~PAGE_MASK;
-		for (j = cur_page; j < page_limit; j++) {
-			unsigned int bytes = PAGE_SIZE - offset;
-
-			if (len <= 0)
-				break;
-			
-			if (bytes > len)
-				bytes = len;
-
-			/*
-			 * sorry...
-			 */
-			if (bio_add_pc_page(q, bio, pages[j], bytes, offset) <
-					    bytes)
-				break;
-
-			len -= bytes;
-			offset = 0;
-		}
-
-		cur_page = j;
-		/*
-		 * release the pages we didn't map into the bio, if any
-		 */
-		while (j < page_limit)
-			page_cache_release(pages[j++]);
-	}
-
-	kfree(pages);
-
 	/*
 	 * set data direction, and check if mapped pages need bouncing
 	 */
@@ -1314,14 +1327,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 	return bio;
 
- out_unmap:
-	for (j = 0; j < nr_pages; j++) {
-		if (!pages[j])
-			break;
-		page_cache_release(pages[j]);
-	}
  out:
-	kfree(pages);
 	bio_put(bio);
 	return ERR_PTR(ret);
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index a69f7b1..c80131a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -428,6 +428,8 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+struct iov_iter;
+extern ssize_t bio_get_user_pages(struct bio *, struct iov_iter *, int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct iov_iter;
-- 
2.1.0

