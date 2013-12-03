Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3LCWC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:02:56 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56451 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3LCWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:43 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 05/11] iov_iter: Move iov_iter to uio.h
Date: Tue,  3 Dec 2013 14:00:11 -0800
Message-Id: <1386108017-27964-6-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/fs.h  | 32 --------------------------------
 include/linux/uio.h | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 32 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..7a19f5d 100644
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
index c55ce24..347d70c 100644
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
1.8.4.4

