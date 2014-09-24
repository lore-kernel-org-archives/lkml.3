Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaIXPLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:11:37 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:41794 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaIXPJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:09:16 -0400
Date: Wed, 24 Sep 2014 17:09:11 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] fuse: honour max_read and max_write in direct_io mode
Message-ID: <20140924150911.GB7441@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

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
---
This touches non-fuse files too, that's why I'm not sending this as regular PULL
request.

 fs/direct-io.c      |    2 +-
 fs/fuse/file.c      |    1 +
 include/linux/uio.h |    2 +-
 mm/iov_iter.c       |   14 +++++++++-----
 4 files changed, 12 insertions(+), 7 deletions(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -158,7 +158,7 @@ static inline int dio_refill_pages(struc
 {
 	ssize_t ret;
 
-	ret = iov_iter_get_pages(sdio->iter, dio->pages, DIO_PAGES,
+	ret = iov_iter_get_pages(sdio->iter, dio->pages, LONG_MAX, DIO_PAGES,
 				&sdio->from);
 
 	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1305,6 +1305,7 @@ static int fuse_get_user_pages(struct fu
 		size_t start;
 		ssize_t ret = iov_iter_get_pages(ii,
 					&req->pages[req->num_pages],
+					*nbytesp - nbytes,
 					req->max_pages - req->num_pages,
 					&start);
 		if (ret < 0)
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -84,7 +84,7 @@ unsigned long iov_iter_alignment(const s
 void iov_iter_init(struct iov_iter *i, int direction, const struct iovec *iov,
 			unsigned long nr_segs, size_t count);
 ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
-			unsigned maxpages, size_t *start);
+			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -310,7 +310,7 @@ void iov_iter_init(struct iov_iter *i, i
 EXPORT_SYMBOL(iov_iter_init);
 
 static ssize_t get_pages_iovec(struct iov_iter *i,
-		   struct page **pages, unsigned maxpages,
+		   struct page **pages, size_t maxsize, unsigned maxpages,
 		   size_t *start)
 {
 	size_t offset = i->iov_offset;
@@ -323,6 +323,8 @@ static ssize_t get_pages_iovec(struct io
 	len = iov->iov_len - offset;
 	if (len > i->count)
 		len = i->count;
+	if (len > maxsize)
+		len = maxsize;
 	addr = (unsigned long)iov->iov_base + offset;
 	len += *start = addr & (PAGE_SIZE - 1);
 	if (len > maxpages * PAGE_SIZE)
@@ -588,13 +590,15 @@ static unsigned long alignment_bvec(cons
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
 
@@ -711,13 +715,13 @@ unsigned long iov_iter_alignment(const s
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
 
