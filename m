Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3LCWB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:01:28 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45653 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3LCWAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:49 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 10/11] block: Add bio_get_user_pages()
Date: Tue,  3 Dec 2013 14:00:16 -0800
Message-Id: <1386108017-27964-11-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces some of the code that was in __bio_map_user_iov(), and
soon we're going to use this helper in the dio code.

Note that this relies on the recent change to make
generic_make_request() take arbitrary sized bios - we're not using
bio_add_page() here.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 130 +++++++++++++++++++++++++++-------------------------
 include/linux/bio.h |   2 +
 2 files changed, 70 insertions(+), 62 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index a660e3f..c93ac07 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1213,19 +1213,79 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
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
 				      struct iov_iter *iter,
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
@@ -1238,57 +1298,10 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
-	ret = -ENOMEM;
-	pages = kcalloc(nr_pages, sizeof(struct page *), gfp_mask);
-	if (!pages)
+	ret = bio_get_user_pages(bio, iter, write_to_vm);
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
@@ -1299,14 +1312,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 	return bio;
 
- out_unmap:
-	for (j = 0; j < nr_pages; j++) {
-		if(!pages[j])
-			break;
-		page_cache_release(pages[j]);
-	}
  out:
-	kfree(pages);
 	bio_put(bio);
 	return ERR_PTR(ret);
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 068f199..52a07da 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -370,6 +370,8 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+struct iov_iter;
+extern ssize_t bio_get_user_pages(struct bio *, struct iov_iter *, int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct iov_iter;
-- 
1.8.4.4

