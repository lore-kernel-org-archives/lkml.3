Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbbALLoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:44:44 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60526 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbbALLok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:44:40 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 3/7] block: refactor iov_count_pages() from bio_{copy,map}_user_iov()
Date: Mon, 12 Jan 2015 12:44:00 +0100
Message-Id: <0117035a25929ae97e2039edc895f582d53cf217.1421052656.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <19cceed4e701430bfb307301a38cdf8d40fbfcac.1421052656.git.dongsu.park@profitbricks.com>
 <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Refactor the common part in bio_copy_user_iov() and
__bio_map_user_iov() to separate out iov_count_pages() into the general
iov_iter API, instead of open coding iov iterations as done previously.

This commit should contain only literal replacements, without
functional changes.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 block/bio.c         | 43 ++++++-------------------------------------
 include/linux/uio.h |  2 ++
 lib/iovec.c         | 30 ++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 7b1aed3..9ad76ed 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1184,24 +1184,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	unsigned int len;
 	unsigned int offset = map_data ? map_data->offset & ~PAGE_MASK : 0;
 
-	for (i = 0; i < iter->nr_segs; i++) {
-		unsigned long uaddr;
-		unsigned long end;
-		unsigned long start;
-
-		uaddr = (unsigned long) iter->iov[i].iov_base;
-		end = (uaddr + iter->iov[i].iov_len + PAGE_SIZE - 1)
-			>> PAGE_SHIFT;
-		start = uaddr >> PAGE_SHIFT;
-
-		/*
-		 * Overflow, abort
-		 */
-		if (end < start)
-			return ERR_PTR(-EINVAL);
-
-		nr_pages += end - start;
-	}
+	nr_pages = iov_count_pages(iter, 0);
+	if (nr_pages < 0)
+		return ERR_PTR(nr_pages);
 
 	if (offset)
 		nr_pages++;
@@ -1331,25 +1316,9 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	struct iov_iter i;
 	struct iovec iov;
 
-	iov_for_each(iov, i, *iter) {
-		unsigned long uaddr = (unsigned long) iov.iov_base;
-		unsigned long len = iov.iov_len;
-		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		unsigned long start = uaddr >> PAGE_SHIFT;
-
-		/*
-		 * Overflow, abort
-		 */
-		if (end < start)
-			return ERR_PTR(-EINVAL);
-
-		nr_pages += end - start;
-		/*
-		 * buffer must be aligned to at least hardsector size for now
-		 */
-		if (uaddr & queue_dma_alignment(q))
-			return ERR_PTR(-EINVAL);
-	}
+	nr_pages = iov_count_pages(iter, queue_dma_alignment(q));
+	if (nr_pages < 0)
+		return ERR_PTR(nr_pages);
 
 	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 1c5e453..142ff1b 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -72,6 +72,8 @@ static inline struct iovec iov_iter_iovec(const struct iov_iter *iter)
 
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
 
+int iov_count_pages(const struct iov_iter *iter, unsigned align);
+
 size_t iov_iter_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
diff --git a/lib/iovec.c b/lib/iovec.c
index 2d99cb4..2e75086 100644
--- a/lib/iovec.c
+++ b/lib/iovec.c
@@ -1,5 +1,7 @@
 #include <linux/uaccess.h>
 #include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
 #include <linux/uio.h>
 
 /*
@@ -85,3 +87,31 @@ int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 	return 0;
 }
 EXPORT_SYMBOL(memcpy_fromiovecend);
+
+int iov_count_pages(const struct iov_iter *iter, unsigned align)
+{
+	struct iov_iter i = *iter;
+	int nr_pages = 0;
+
+	while (iov_iter_count(&i)) {
+		unsigned long uaddr = (unsigned long) i.iov->iov_base +
+			i.iov_offset;
+		unsigned long len = i.iov->iov_len - i.iov_offset;
+
+		if ((uaddr & align) || (len & align))
+			return -EINVAL;
+
+		/*
+		 * Overflow, abort
+		 */
+		if (uaddr + len < uaddr)
+			return -EINVAL;
+
+		nr_pages += DIV_ROUND_UP(len + offset_in_page(uaddr),
+					 PAGE_SIZE);
+		iov_iter_advance(&i, len);
+	}
+
+	return nr_pages;
+}
+EXPORT_SYMBOL(iov_count_pages);
-- 
2.1.0

