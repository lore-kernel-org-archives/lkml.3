Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3LCWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:01:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58241 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3LCWAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:48 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 09/11] block: iov_count_pages()
Date: Tue,  3 Dec 2013 14:00:15 -0800
Message-Id: <1386108017-27964-10-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 fs/bio.c            | 42 ++++++------------------------------------
 include/linux/uio.h |  2 ++
 lib/iovec.c         | 30 ++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index a7e5789..a660e3f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1095,23 +1095,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	unsigned int len;
 	unsigned int offset = map_data ? map_data->offset & ~PAGE_MASK : 0;
 
-	for (i = 0; i < iter->nr_segs; i++) {
-		unsigned long uaddr;
-		unsigned long end;
-		unsigned long start;
-
-		uaddr = (unsigned long) iter->iov[i].iov_base;
-		end = (uaddr + iter->iov[i].iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
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
@@ -1241,25 +1227,9 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
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
index d653fee..d74c3451 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -60,6 +60,8 @@ static inline struct iovec iov_iter_iovec(const struct iov_iter *iter)
 
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
 
+int iov_count_pages(const struct iov_iter *iter, unsigned align);
+
 size_t iov_iter_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
 size_t iov_iter_copy_from_user(struct page *page,
diff --git a/lib/iovec.c b/lib/iovec.c
index 454baa8..fa2c050 100644
--- a/lib/iovec.c
+++ b/lib/iovec.c
@@ -1,5 +1,7 @@
 #include <linux/uaccess.h>
 #include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
 #include <linux/uio.h>
 
 /*
@@ -51,3 +53,31 @@ int memcpy_toiovec(struct iovec *iov, unsigned char *kdata, int len)
 	return 0;
 }
 EXPORT_SYMBOL(memcpy_toiovec);
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
1.8.4.4

