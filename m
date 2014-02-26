Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaBZXo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:44:59 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44602 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaBZXkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:40:25 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 7/9] iov_iter: Move iov_iter to uio.h
Date: Wed, 26 Feb 2014 15:39:55 -0800
Message-Id: <1393457997-17618-8-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
References: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going to be consolidating all the iov iter in one place, and fs.h is way too
big. This also adds a new helper,  iovec iov_iter_iovec().

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h  | 32 --------------------------------
 include/linux/uio.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 60829565e5..e42211f044 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -290,38 +290,6 @@ struct page;
 struct address_space;
 struct writeback_control;
 
-struct iov_iter {
-	const struct iovec *iov;
-	unsigned long nr_segs;
-	size_t iov_offset;
-	size_t count;
-};
-
-size_t iov_iter_copy_from_user_atomic(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-size_t iov_iter_copy_from_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-void iov_iter_advance(struct iov_iter *i, size_t bytes);
-int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
-size_t iov_iter_single_seg_count(const struct iov_iter *i);
-
-static inline void iov_iter_init(struct iov_iter *i,
-			const struct iovec *iov, unsigned long nr_segs,
-			size_t count, size_t written)
-{
-	i->iov = iov;
-	i->nr_segs = nr_segs;
-	i->iov_offset = 0;
-	i->count = count + written;
-
-	iov_iter_advance(i, written);
-}
-
-static inline size_t iov_iter_count(struct iov_iter *i)
-{
-	return i->count;
-}
-
 /*
  * "descriptor" for what we're up to with a read.
  * This allows us to use the same read code yet
diff --git a/include/linux/uio.h b/include/linux/uio.h
index c55ce243cc..347d70ce09 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -9,14 +9,23 @@
 #ifndef __LINUX_UIO_H
 #define __LINUX_UIO_H
 
+#include <linux/kernel.h>
 #include <uapi/linux/uio.h>
 
+struct page;
 
 struct kvec {
 	void *iov_base; /* and that should *never* hold a userland pointer */
 	size_t iov_len;
 };
 
+struct iov_iter {
+	const struct iovec *iov;
+	unsigned long nr_segs;
+	size_t iov_offset;
+	size_t count;
+};
+
 /*
  * Total number of bytes covered by an iovec.
  *
@@ -34,8 +43,49 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
 	return ret;
 }
 
+static inline struct iovec iov_iter_iovec(const struct iov_iter *iter)
+{
+	return (struct iovec) {
+		.iov_base = iter->iov->iov_base + iter->iov_offset,
+		.iov_len = min(iter->count,
+			       iter->iov->iov_len - iter->iov_offset),
+	};
+}
+
+#define iov_for_each(iov, iter, start)				\
+	for (iter = (start);					\
+	     (iter).count &&					\
+	     ((iov = iov_iter_iovec(&(iter))), 1);		\
+	     iov_iter_advance(&(iter), (iov).iov_len))
+
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
 
+size_t iov_iter_copy_from_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes);
+size_t iov_iter_copy_from_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes);
+void iov_iter_advance(struct iov_iter *i, size_t bytes);
+int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
+size_t iov_iter_single_seg_count(const struct iov_iter *i);
+
+static inline void iov_iter_init(struct iov_iter *i,
+			const struct iovec *iov, unsigned long nr_segs,
+			size_t count, size_t written)
+{
+	i->iov = iov;
+	i->nr_segs = nr_segs;
+	i->iov_offset = 0;
+	i->count = count + written;
+
+	iov_iter_advance(i, written);
+}
+
+static inline size_t iov_iter_count(struct iov_iter *i)
+{
+	return i->count;
+}
+
 int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 int memcpy_toiovec(struct iovec *iov, unsigned char *kdata, int len);
+
 #endif
-- 
1.9.0

