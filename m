Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935180Ab3BTA0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:26:20 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:38257 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934960Ab3BTAXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:23:09 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk
Subject: [PATCH 18/27] block: Add bio_copy_data()
Date: Tue, 19 Feb 2013 16:22:32 -0800
Message-Id: <1361319761-23873-19-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets open coded quite a bit and it's tricky to get right, so make a
generic version and convert some existing users over to it instead.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |  2 ++
 2 files changed, 72 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index 4ce24ee..e437f9aa 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -829,6 +829,76 @@ void bio_advance(struct bio *bio, unsigned bytes)
 }
 EXPORT_SYMBOL(bio_advance);
 
+/**
+ * bio_copy_data - copy contents of data buffers from one chain of bios to
+ * another
+ * @src: source bio list
+ * @dst: destination bio list
+ *
+ * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
+ * @src and @dst as linked lists of bios.
+ *
+ * Stops when it reaches the end of either @src or @dst - that is, copies
+ * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
+ */
+void bio_copy_data(struct bio *dst, struct bio *src)
+{
+	struct bio_vec *src_bv, *dst_bv;
+	unsigned src_offset, dst_offset, bytes;
+	void *src_p, *dst_p;
+
+	src_bv = bio_iovec(src);
+	dst_bv = bio_iovec(dst);
+
+	src_offset = src_bv->bv_offset;
+	dst_offset = dst_bv->bv_offset;
+
+	while (1) {
+		if (src_offset == src_bv->bv_offset + src_bv->bv_len) {
+			src_bv++;
+			if (src_bv == bio_iovec_idx(src, src->bi_vcnt)) {
+				src = src->bi_next;
+				if (!src)
+					break;
+
+				src_bv = bio_iovec(src);
+			}
+
+			src_offset = src_bv->bv_offset;
+		}
+
+		if (dst_offset == dst_bv->bv_offset + dst_bv->bv_len) {
+			dst_bv++;
+			if (dst_bv == bio_iovec_idx(dst, dst->bi_vcnt)) {
+				dst = dst->bi_next;
+				if (!dst)
+					break;
+
+				dst_bv = bio_iovec(dst);
+			}
+
+			dst_offset = dst_bv->bv_offset;
+		}
+
+		bytes = min(dst_bv->bv_offset + dst_bv->bv_len - dst_offset,
+			    src_bv->bv_offset + src_bv->bv_len - src_offset);
+
+		src_p = kmap_atomic(src_bv->bv_page);
+		dst_p = kmap_atomic(dst_bv->bv_page);
+
+		memcpy(dst_p + dst_bv->bv_offset,
+		       src_p + src_bv->bv_offset,
+		       bytes);
+
+		kunmap_atomic(dst_p);
+		kunmap_atomic(src_p);
+
+		src_offset += bytes;
+		dst_offset += bytes;
+	}
+}
+EXPORT_SYMBOL(bio_copy_data);
+
 struct bio_map_data {
 	struct bio_vec *iovecs;
 	struct sg_iovec *sgvecs;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b20a9cd..90d36c6 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -286,6 +286,8 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
 }
 #endif
 
+extern void bio_copy_data(struct bio *dst, struct bio *src);
+
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
 extern struct bio *bio_copy_user_iov(struct request_queue *,
-- 
1.7.12

