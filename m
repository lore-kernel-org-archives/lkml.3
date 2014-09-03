Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbaICKLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:11:11 -0400
Received: from relay.parallels.com ([195.214.232.42]:53954 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbaICKLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:11:06 -0400
Subject: [PATCH 1/2] vfs: switch iov_iter_get_pages() to passing maximal size
To: viro@zeniv.linux.org.uk
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, werner.baumann@onlinehome.de
Date: Wed, 03 Sep 2014 14:11:04 +0400
Message-ID: <20140903101030.23218.27114.stgit@localhost.localdomain>
In-Reply-To: <20140903100826.23218.95122.stgit@localhost.localdomain>
References: <20140903100826.23218.95122.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch reverts the commit c7f3888ad7f0 ("switch iov_iter_get_pages() to
passing maximal number of pages") because FUSE do need maxsize argument that
existed before that commit.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/direct-io.c      |    2 +-
 fs/fuse/file.c      |    4 ++--
 include/linux/uio.h |    2 +-
 mm/iov_iter.c       |   17 +++++++++--------
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index c311640..17e39b0 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -158,7 +158,7 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 {
 	ssize_t ret;
 
-	ret = iov_iter_get_pages(sdio->iter, dio->pages, DIO_PAGES,
+	ret = iov_iter_get_pages(sdio->iter, dio->pages, DIO_PAGES * PAGE_SIZE,
 				&sdio->from);
 
 	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 912061a..40ac262 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1303,10 +1303,10 @@ static int fuse_get_user_pages(struct fuse_req *req, struct iov_iter *ii,
 	while (nbytes < *nbytesp && req->num_pages < req->max_pages) {
 		unsigned npages;
 		size_t start;
+		unsigned n = req->max_pages - req->num_pages;
 		ssize_t ret = iov_iter_get_pages(ii,
 					&req->pages[req->num_pages],
-					req->max_pages - req->num_pages,
-					&start);
+					n * PAGE_SIZE, &start);
 		if (ret < 0)
 			return ret;
 
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 48d64e6..09a7cff 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -84,7 +84,7 @@ unsigned long iov_iter_alignment(const struct iov_iter *i);
 void iov_iter_init(struct iov_iter *i, int direction, const struct iovec *iov,
 			unsigned long nr_segs, size_t count);
 ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
-			unsigned maxpages, size_t *start);
+			size_t maxsize, size_t *start);
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index ab88dc0..7b5dbd1 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -310,7 +310,7 @@ void iov_iter_init(struct iov_iter *i, int direction,
 EXPORT_SYMBOL(iov_iter_init);
 
 static ssize_t get_pages_iovec(struct iov_iter *i,
-		   struct page **pages, unsigned maxpages,
+		   struct page **pages, size_t maxsize,
 		   size_t *start)
 {
 	size_t offset = i->iov_offset;
@@ -323,10 +323,10 @@ static ssize_t get_pages_iovec(struct iov_iter *i,
 	len = iov->iov_len - offset;
 	if (len > i->count)
 		len = i->count;
+	if (len > maxsize)
+		len = maxsize;
 	addr = (unsigned long)iov->iov_base + offset;
 	len += *start = addr & (PAGE_SIZE - 1);
-	if (len > maxpages * PAGE_SIZE)
-		len = maxpages * PAGE_SIZE;
 	addr &= ~(PAGE_SIZE - 1);
 	n = (len + PAGE_SIZE - 1) / PAGE_SIZE;
 	res = get_user_pages_fast(addr, n, (i->type & WRITE) != WRITE, pages);
@@ -588,14 +588,15 @@ static unsigned long alignment_bvec(const struct iov_iter *i)
 }
 
 static ssize_t get_pages_bvec(struct iov_iter *i,
-		   struct page **pages, unsigned maxpages,
+		   struct page **pages, size_t maxsize,
 		   size_t *start)
 {
 	const struct bio_vec *bvec = i->bvec;
 	size_t len = bvec->bv_len - i->iov_offset;
 	if (len > i->count)
 		len = i->count;
-	/* can't be more than PAGE_SIZE */
+	if (len > maxsize)
+		len = maxsize;
 	*start = bvec->bv_offset + i->iov_offset;
 
 	get_page(*pages = bvec->bv_page);
@@ -711,13 +712,13 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 EXPORT_SYMBOL(iov_iter_alignment);
 
 ssize_t iov_iter_get_pages(struct iov_iter *i,
-		   struct page **pages, unsigned maxpages,
+		   struct page **pages, size_t maxsize,
 		   size_t *start)
 {
 	if (i->type & ITER_BVEC)
-		return get_pages_bvec(i, pages, maxpages, start);
+		return get_pages_bvec(i, pages, maxsize, start);
 	else
-		return get_pages_iovec(i, pages, maxpages, start);
+		return get_pages_iovec(i, pages, maxsize, start);
 }
 EXPORT_SYMBOL(iov_iter_get_pages);
 

