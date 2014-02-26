Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaBZXle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:41:34 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60020 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbaBZXkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:40:25 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 8/9] iov_iter: Kill iov_iter_single_seg_count()
Date: Wed, 26 Feb 2014 15:39:56 -0800
Message-Id: <1393457997-17618-9-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
References: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new iov_iter_iovec() is a more general replacement.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/fuse/file.c      |  6 +++---
 include/linux/uio.h |  1 -
 mm/filemap.c        | 15 +--------------
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 77bcc303c3..b4c9a14e70 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1013,7 +1013,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
 		if (!tmp) {
 			unlock_page(page);
 			page_cache_release(page);
-			bytes = min(bytes, iov_iter_single_seg_count(ii));
+			bytes = min(bytes, iov_iter_iovec(ii).iov_len);
 			goto again;
 		}
 
@@ -1204,7 +1204,7 @@ static inline unsigned long fuse_get_user_addr(const struct iov_iter *ii)
 static inline size_t fuse_get_frag_size(const struct iov_iter *ii,
 					size_t max_size)
 {
-	return min(iov_iter_single_seg_count(ii), max_size);
+	return min(iov_iter_iovec(ii).iov_len, max_size);
 }
 
 static int fuse_get_user_pages(struct fuse_req *req, struct iov_iter *ii,
@@ -1278,7 +1278,7 @@ static inline int fuse_iter_npages(const struct iov_iter *ii_p)
 	while (iov_iter_count(&ii) && npages < FUSE_MAX_PAGES_PER_REQ) {
 		unsigned long user_addr = fuse_get_user_addr(&ii);
 		unsigned offset = user_addr & ~PAGE_MASK;
-		size_t frag_size = iov_iter_single_seg_count(&ii);
+		size_t frag_size = iov_iter_iovec(&ii).iov_len;
 
 		npages += (frag_size + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		iov_iter_advance(&ii, frag_size);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 347d70ce09..2b99e0d2a1 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -66,7 +66,6 @@ size_t iov_iter_copy_from_user(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
-size_t iov_iter_single_seg_count(const struct iov_iter *i);
 
 static inline void iov_iter_init(struct iov_iter *i,
 			const struct iovec *iov, unsigned long nr_segs,
diff --git a/mm/filemap.c b/mm/filemap.c
index 7a13f6ac54..8e509b3225 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2073,19 +2073,6 @@ int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
 EXPORT_SYMBOL(iov_iter_fault_in_readable);
 
 /*
- * Return the count of just the current iov_iter segment.
- */
-size_t iov_iter_single_seg_count(const struct iov_iter *i)
-{
-	const struct iovec *iov = i->iov;
-	if (i->nr_segs == 1)
-		return i->count;
-	else
-		return min(i->count, iov->iov_len - i->iov_offset);
-}
-EXPORT_SYMBOL(iov_iter_single_seg_count);
-
-/*
  * Performs necessary checks before doing a write
  *
  * Can adjust writing position or amount of bytes to write.
@@ -2373,7 +2360,7 @@ again:
 			 * once without a pagefault.
 			 */
 			bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
-						iov_iter_single_seg_count(i));
+				      iov_iter_iovec(i).iov_len);
 			goto again;
 		}
 		pos += copied;
-- 
1.9.0

