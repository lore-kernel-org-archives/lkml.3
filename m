Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaKKMPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:15:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57085 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaKKLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 003/170] switch iov_iter_get_pages() to passing maximal number of pages
Date: Tue, 11 Nov 2014 11:06:02 +0000
Message-Id: <1415704129-12709-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit c7f3888ad7f0932a87fb76e6e4edff2a90cc7920 upstream.

... instead of maximal size.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/direct-io.c      |  2 +-
 fs/fuse/file.c      |  4 ++--
 include/linux/uio.h |  2 +-
 mm/iov_iter.c       | 17 ++++++++---------
 4 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 17e39b047de5..c3116404ab49 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -158,7 +158,7 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 {
 	ssize_t ret;
 
-	ret = iov_iter_get_pages(sdio->iter, dio->pages, DIO_PAGES * PAGE_SIZE,
+	ret = iov_iter_get_pages(sdio->iter, dio->pages, DIO_PAGES,
 				&sdio->from);
 
 	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 40ac2628ddcf..912061ac4baf 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1303,10 +1303,10 @@ static int fuse_get_user_pages(struct fuse_req *req, struct iov_iter *ii,
 	while (nbytes < *nbytesp && req->num_pages < req->max_pages) {
 		unsigned npages;
 		size_t start;
-		unsigned n = req->max_pages - req->num_pages;
 		ssize_t ret = iov_iter_get_pages(ii,
 					&req->pages[req->num_pages],
-					n * PAGE_SIZE, &start);
+					req->max_pages - req->num_pages,
+					&start);
 		if (ret < 0)
 			return ret;
 
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 09a7cffc224e..48d64e6ab292 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -84,7 +84,7 @@ unsigned long iov_iter_alignment(const struct iov_iter *i);
 void iov_iter_init(struct iov_iter *i, int direction, const struct iovec *iov,
 			unsigned long nr_segs, size_t count);
 ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
-			size_t maxsize, size_t *start);
+			unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index 7b5dbd1517b5..ab88dc0ea1d3 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -310,7 +310,7 @@ void iov_iter_init(struct iov_iter *i, int direction,
 EXPORT_SYMBOL(iov_iter_init);
 
 static ssize_t get_pages_iovec(struct iov_iter *i,
-		   struct page **pages, size_t maxsize,
+		   struct page **pages, unsigned maxpages,
 		   size_t *start)
 {
 	size_t offset = i->iov_offset;
@@ -323,10 +323,10 @@ static ssize_t get_pages_iovec(struct iov_iter *i,
 	len = iov->iov_len - offset;
 	if (len > i->count)
 		len = i->count;
-	if (len > maxsize)
-		len = maxsize;
 	addr = (unsigned long)iov->iov_base + offset;
 	len += *start = addr & (PAGE_SIZE - 1);
+	if (len > maxpages * PAGE_SIZE)
+		len = maxpages * PAGE_SIZE;
 	addr &= ~(PAGE_SIZE - 1);
 	n = (len + PAGE_SIZE - 1) / PAGE_SIZE;
 	res = get_user_pages_fast(addr, n, (i->type & WRITE) != WRITE, pages);
@@ -588,15 +588,14 @@ static unsigned long alignment_bvec(const struct iov_iter *i)
 }
 
 static ssize_t get_pages_bvec(struct iov_iter *i,
-		   struct page **pages, size_t maxsize,
+		   struct page **pages, unsigned maxpages,
 		   size_t *start)
 {
 	const struct bio_vec *bvec = i->bvec;
 	size_t len = bvec->bv_len - i->iov_offset;
 	if (len > i->count)
 		len = i->count;
-	if (len > maxsize)
-		len = maxsize;
+	/* can't be more than PAGE_SIZE */
 	*start = bvec->bv_offset + i->iov_offset;
 
 	get_page(*pages = bvec->bv_page);
@@ -712,13 +711,13 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 EXPORT_SYMBOL(iov_iter_alignment);
 
 ssize_t iov_iter_get_pages(struct iov_iter *i,
-		   struct page **pages, size_t maxsize,
+		   struct page **pages, unsigned maxpages,
 		   size_t *start)
 {
 	if (i->type & ITER_BVEC)
-		return get_pages_bvec(i, pages, maxsize, start);
+		return get_pages_bvec(i, pages, maxpages, start);
 	else
-		return get_pages_iovec(i, pages, maxsize, start);
+		return get_pages_iovec(i, pages, maxpages, start);
 }
 EXPORT_SYMBOL(iov_iter_get_pages);
 
-- 
2.1.0

