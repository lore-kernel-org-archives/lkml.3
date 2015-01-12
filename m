Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbbALLvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:51:20 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55546 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbALLvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:51:16 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 2/7] block: rewrite __bio_copy_iov()
Date: Mon, 12 Jan 2015 12:43:59 +0100
Message-Id: <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <19cceed4e701430bfb307301a38cdf8d40fbfcac.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <19cceed4e701430bfb307301a38cdf8d40fbfcac.1421052656.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite __bio_copy_iov() so that it can call either _read() or _write()
variant, which is determined by direction to_iov, given as either READ
or WRITE. Moreover, make __bio_copy_iov() take its parameter iov_iter
by value, to avoid awkward situations like ref-/dereferencing pointer
and value repeatedly.

This commit should contain only literal replacements, without
functional changes.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 block/bio.c | 113 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 75 insertions(+), 38 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8267676..7b1aed3 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1046,46 +1046,84 @@ static struct bio_map_data *bio_alloc_map_data(unsigned int iov_count,
 		       sizeof(struct sg_iovec) * iov_count, gfp_mask);
 }
 
-static int __bio_copy_iov(struct bio *bio, const struct iov_iter *iter,
-			  int to_user, int from_user, int do_free_page)
+/**
+ * __bio_copy_iov_read - copy all pages from iov_iter to bio
+ * @bio: The &struct bio which describes the I/O as destination
+ * @iter: iov_iter as source
+ *
+ * Copy all pages from iov_iter to bio.
+ * Returns 0 on success, or error on failure.
+ */
+static int __bio_copy_iov_read(struct bio *bio, struct iov_iter iter)
 {
-	int ret = 0, i;
+	int i;
 	struct bio_vec *bvec;
-	struct iov_iter iov_iter = *iter;
 
 	bio_for_each_segment_all(bvec, bio, i) {
-		char *bv_addr = page_address(bvec->bv_page);
-		unsigned int bv_len = bvec->bv_len;
-
-		while (bv_len && iov_iter.count) {
-			struct iovec iov = iov_iter_iovec(&iov_iter);
-			unsigned int bytes = min_t(unsigned int, bv_len,
-						   iov.iov_len);
-
-			if (!ret) {
-				if (to_user)
-					ret = copy_to_user(iov.iov_base,
-							   bv_addr, bytes);
-
-				if (from_user)
-					ret = copy_from_user(bv_addr,
-							     iov.iov_base,
-							     bytes);
-
-				if (ret)
-					ret = -EFAULT;
-			}
+		ssize_t ret;
 
-			bv_len -= bytes;
-			bv_addr += bytes;
-			iov_iter_advance(&iov_iter, bytes);
-		}
+		ret = copy_page_from_iter(bvec->bv_page,
+					  bvec->bv_offset,
+					  bvec->bv_len,
+					  &iter);
 
-		if (do_free_page)
-			__free_page(bvec->bv_page);
+		if (!iov_iter_count(&iter))
+			break;
+
+		if (ret < bvec->bv_len)
+			return -EFAULT;
 	}
 
-	return ret;
+	return 0;
+}
+
+/**
+ * __bio_copy_iov_write - copy all pages from bio to iov_iter
+ * @bio: The &struct bio which describes the I/O as source
+ * @iter: iov_iter as destination
+ *
+ * Copy all pages from bio to iov_iter.
+ * Returns 0 on success, or error on failure.
+ */
+static int __bio_copy_iov_write(struct bio *bio, struct iov_iter iter)
+{
+	int i;
+	struct bio_vec *bvec;
+
+	bio_for_each_segment_all(bvec, bio, i) {
+		ssize_t ret;
+
+		ret = copy_page_to_iter(bvec->bv_page,
+					bvec->bv_offset,
+					bvec->bv_len,
+					&iter);
+
+		if (!iov_iter_count(&iter))
+			break;
+
+		if (ret < bvec->bv_len)
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+/**
+ * __bio_copy_iov - copy all pages between bio and iov_iter
+ * @bio: The &struct bio which describes the I/O
+ * @iter: iov_iter either as source or destination
+ * @to_iov: whether to %READ (0) or %WRITE (1)
+ *
+ * Simple wrapper around __bio_copy_iov_{write,read}().
+ * Returns 0 on success, or the error returned as-is on failure.
+ */
+static inline int __bio_copy_iov(struct bio *bio, struct iov_iter iter,
+				 int to_iov)
+{
+	if (to_iov == WRITE)
+		return __bio_copy_iov_write(bio, iter);
+	else
+		return __bio_copy_iov_read(bio, iter);
 }
 
 /**
@@ -1106,11 +1144,10 @@ int bio_uncopy_user(struct bio *bio)
 		 * if we're in a workqueue, the request is orphaned, so
 		 * don't copy into a random user address space, just free.
 		 */
-		if (current->mm)
-			ret = __bio_copy_iov(bio, &bmd->iter,
-					     bio_data_dir(bio) == READ,
-					     0, bmd->is_our_pages);
-		else if (bmd->is_our_pages)
+		if (current->mm && bio_data_dir(bio) == READ)
+			ret = __bio_copy_iov(bio, bmd->iter, WRITE);
+
+		if (bmd->is_our_pages)
 			bio_for_each_segment_all(bvec, bio, i)
 				__free_page(bvec->bv_page);
 	}
@@ -1233,7 +1270,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if ((!write_to_vm && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, iter, 0, 1, 0);
+		ret = __bio_copy_iov(bio, *iter, READ);
 		if (ret)
 			goto cleanup;
 	}
-- 
2.1.0

