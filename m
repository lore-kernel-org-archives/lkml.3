Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3LCWCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:02:53 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45460 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3LCWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:44 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 06/11] iov_iter: Kill iov_iter_single_seg_count()
Date: Tue,  3 Dec 2013 14:00:12 -0800
Message-Id: <1386108017-27964-7-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 fs/fuse/file.c      |  6 +++---
 include/linux/uio.h |  1 -
 mm/filemap.c        | 15 +--------------
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7e70506..69175a1 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -996,7 +996,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
 		if (!tmp) {
 			unlock_page(page);
 			page_cache_release(page);
-			bytes = min(bytes, iov_iter_single_seg_count(ii));
+			bytes = min(bytes, iov_iter_iovec(ii).iov_len);
 			goto again;
 		}
 
@@ -1187,7 +1187,7 @@ static inline unsigned long fuse_get_user_addr(const struct iov_iter *ii)
 static inline size_t fuse_get_frag_size(const struct iov_iter *ii,
 					size_t max_size)
 {
-	return min(iov_iter_single_seg_count(ii), max_size);
+	return min(iov_iter_iovec(ii).iov_len, max_size);
 }
 
 static int fuse_get_user_pages(struct fuse_req *req, struct iov_iter *ii,
@@ -1261,7 +1261,7 @@ static inline int fuse_iter_npages(const struct iov_iter *ii_p)
 	while (iov_iter_count(&ii) && npages < FUSE_MAX_PAGES_PER_REQ) {
 		unsigned long user_addr = fuse_get_user_addr(&ii);
 		unsigned offset = user_addr & ~PAGE_MASK;
-		size_t frag_size = iov_iter_single_seg_count(&ii);
+		size_t frag_size = iov_iter_iovec(&ii).iov_len;
 
 		npages += (frag_size + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		iov_iter_advance(&ii, frag_size);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 347d70c..2b99e0d 100644
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
index b7749a9..1a40f12 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2075,19 +2075,6 @@ int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
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
@@ -2375,7 +2362,7 @@ again:
 			 * once without a pagefault.
 			 */
 			bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
-						iov_iter_single_seg_count(i));
+				      iov_iter_iovec(i).iov_len);
 			goto again;
 		}
 		pos += copied;
-- 
1.8.4.4

