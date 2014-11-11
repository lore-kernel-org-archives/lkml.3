Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaKKMPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:15:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaKKLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 004/170] fuse: honour max_read and max_write in direct_io mode
Date: Tue, 11 Nov 2014 11:06:03 +0000
Message-Id: <1415704129-12709-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 2c80929c4c4d54e568b07ab85877d5fd38f4b02f upstream.

The third argument of fuse_get_user_pages() "nbytesp" refers to the number of
bytes a caller asked to pack into fuse request. This value may be lesser
than capacity of fuse request or iov_iter.  So fuse_get_user_pages() must
ensure that *nbytesp won't grow.

Now, when helper iov_iter_get_pages() performs all hard work of extracting
pages from iov_iter, it can be done by passing properly calculated
"maxsize" to the helper.

The other caller of iov_iter_get_pages() (dio_refill_pages()) doesn't need
this capability, so pass LONG_MAX as the maxsize argument here.

Fixes: c9c37e2e6378 ("fuse: switch to iov_iter_get_pages()")
Reported-by: Werner Baumann <werner.baumann@onlinehome.de>
Tested-by: Maxim Patlasov <mpatlasov@parallels.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/direct-io.c      |  2 +-
 fs/fuse/file.c      |  1 +
 include/linux/uio.h |  2 +-
 mm/iov_iter.c       | 14 +++++++++-----
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index c3116404ab49..e181b6b2e297 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -158,7 +158,7 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 {
 	ssize_t ret;
 
-	ret = iov_iter_get_pages(sdio->iter, dio->pages, DIO_PAGES,
+	ret = iov_iter_get_pages(sdio->iter, dio->pages, LONG_MAX, DIO_PAGES,
 				&sdio->from);
 
 	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 912061ac4baf..caa8d95b24e8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1305,6 +1305,7 @@ static int fuse_get_user_pages(struct fuse_req *req, struct iov_iter *ii,
 		size_t start;
 		ssize_t ret = iov_iter_get_pages(ii,
 					&req->pages[req->num_pages],
+					*nbytesp - nbytes,
 					req->max_pages - req->num_pages,
 					&start);
 		if (ret < 0)
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 48d64e6ab292..290fbf0b6b8a 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -84,7 +84,7 @@ unsigned long iov_iter_alignment(const struct iov_iter *i);
 void iov_iter_init(struct iov_iter *i, int direction, const struct iovec *iov,
 			unsigned long nr_segs, size_t count);
 ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
-			unsigned maxpages, size_t *start);
+			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index ab88dc0ea1d3..9a09f2034fcc 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -310,7 +310,7 @@ void iov_iter_init(struct iov_iter *i, int direction,
 EXPORT_SYMBOL(iov_iter_init);
 
 static ssize_t get_pages_iovec(struct iov_iter *i,
-		   struct page **pages, unsigned maxpages,
+		   struct page **pages, size_t maxsize, unsigned maxpages,
 		   size_t *start)
 {
 	size_t offset = i->iov_offset;
@@ -323,6 +323,8 @@ static ssize_t get_pages_iovec(struct iov_iter *i,
 	len = iov->iov_len - offset;
 	if (len > i->count)
 		len = i->count;
+	if (len > maxsize)
+		len = maxsize;
 	addr = (unsigned long)iov->iov_base + offset;
 	len += *start = addr & (PAGE_SIZE - 1);
 	if (len > maxpages * PAGE_SIZE)
@@ -588,13 +590,15 @@ static unsigned long alignment_bvec(const struct iov_iter *i)
 }
 
 static ssize_t get_pages_bvec(struct iov_iter *i,
-		   struct page **pages, unsigned maxpages,
+		   struct page **pages, size_t maxsize, unsigned maxpages,
 		   size_t *start)
 {
 	const struct bio_vec *bvec = i->bvec;
 	size_t len = bvec->bv_len - i->iov_offset;
 	if (len > i->count)
 		len = i->count;
+	if (len > maxsize)
+		len = maxsize;
 	/* can't be more than PAGE_SIZE */
 	*start = bvec->bv_offset + i->iov_offset;
 
@@ -711,13 +715,13 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 EXPORT_SYMBOL(iov_iter_alignment);
 
 ssize_t iov_iter_get_pages(struct iov_iter *i,
-		   struct page **pages, unsigned maxpages,
+		   struct page **pages, size_t maxsize, unsigned maxpages,
 		   size_t *start)
 {
 	if (i->type & ITER_BVEC)
-		return get_pages_bvec(i, pages, maxpages, start);
+		return get_pages_bvec(i, pages, maxsize, maxpages, start);
 	else
-		return get_pages_iovec(i, pages, maxpages, start);
+		return get_pages_iovec(i, pages, maxsize, maxpages, start);
 }
 EXPORT_SYMBOL(iov_iter_get_pages);
 
-- 
2.1.0

