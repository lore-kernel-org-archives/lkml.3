Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbbAPMGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:06:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:44196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbbAPMGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:06:07 -0500
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Dongsu Park <dongsu.park@profitbricks.com>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 7/7] block: rewrite and split __bio_copy_iov()
Date: Fri, 16 Jan 2015 13:04:55 +0100
Message-Id: <1421409895-21377-8-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421409895-21377-1-git-send-email-hch@lst.de>
References: <1421409895-21377-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsu Park <dongsu.park@profitbricks.com>

Rewrite __bio_copy_iov using the copy_page_{from,to}_iter helpers, and
split it into two simpler functions.

This commit should contain only literal replacements, without
functional changes.

Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
[hch: removed the __bio_copy_iov wrapper]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 90 ++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 34 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0723d4c..f66a4ea 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1036,43 +1036,66 @@ static struct bio_map_data *bio_alloc_map_data(unsigned int iov_count,
 		       sizeof(struct iovec) * iov_count, gfp_mask);
 }
 
-static int __bio_copy_iov(struct bio *bio, const struct iov_iter *iter,
-			  int to_user, int from_user)
+/**
+ * bio_copy_from_iter - copy all pages from iov_iter to bio
+ * @bio: The &struct bio which describes the I/O as destination
+ * @iter: iov_iter as source
+ *
+ * Copy all pages from iov_iter to bio.
+ * Returns 0 on success, or error on failure.
+ */
+static int bio_copy_from_iter(struct bio *bio, struct iov_iter iter)
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
+
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
+ * bio_copy_to_iter - copy all pages from bio to iov_iter
+ * @bio: The &struct bio which describes the I/O as source
+ * @iter: iov_iter as destination
+ *
+ * Copy all pages from bio to iov_iter.
+ * Returns 0 on success, or error on failure.
+ */
+static int bio_copy_to_iter(struct bio *bio, struct iov_iter iter)
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
 }
 
 static void bio_free_pages(struct bio *bio)
@@ -1101,9 +1124,8 @@ int bio_uncopy_user(struct bio *bio)
 		 * if we're in a workqueue, the request is orphaned, so
 		 * don't copy into a random user address space, just free.
 		 */
-		if (current->mm)
-			ret = __bio_copy_iov(bio, &bmd->iter,
-					     bio_data_dir(bio) == READ, 0);
+		if (current->mm && bio_data_dir(bio) == READ)
+			ret = bio_copy_to_iter(bio, bmd->iter);
 		if (bmd->is_our_pages)
 			bio_free_pages(bio);
 	}
@@ -1228,7 +1250,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	 */
 	if (((iter->type & WRITE) && (!map_data || !map_data->null_mapped)) ||
 	    (map_data && map_data->from_user)) {
-		ret = __bio_copy_iov(bio, iter, 0, 1);
+		ret = bio_copy_from_iter(bio, *iter);
 		if (ret)
 			goto cleanup;
 	}
-- 
1.9.1

