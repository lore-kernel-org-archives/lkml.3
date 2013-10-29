Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3J2UWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:22:45 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53451 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3J2USj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:18:39 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 09/23] block: Convert bio_copy_data() to bvec_iter
Date: Tue, 29 Oct 2013 13:18:02 -0700
Message-Id: <1383077896-4132-10-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our fancy new bvec iterator makes code like this much easier to write.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c | 60 +++++++++++++++++++++++++-----------------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b39436a..ef6afc5 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -852,58 +852,48 @@ EXPORT_SYMBOL(bio_alloc_pages);
  */
 void bio_copy_data(struct bio *dst, struct bio *src)
 {
-	struct bio_vec *src_bv, *dst_bv;
-	unsigned src_offset, dst_offset, bytes;
+	struct bvec_iter src_iter, dst_iter;
+	struct bio_vec src_bv, dst_bv;
 	void *src_p, *dst_p;
+	unsigned bytes;
 
-	src_bv = __bio_iovec(src);
-	dst_bv = __bio_iovec(dst);
-
-	src_offset = src_bv->bv_offset;
-	dst_offset = dst_bv->bv_offset;
+	src_iter = src->bi_iter;
+	dst_iter = dst->bi_iter;
 
 	while (1) {
-		if (src_offset == src_bv->bv_offset + src_bv->bv_len) {
-			src_bv++;
-			if (src_bv == bio_iovec_idx(src, src->bi_vcnt)) {
-				src = src->bi_next;
-				if (!src)
-					break;
-
-				src_bv = __bio_iovec(src);
-			}
+		if (!src_iter.bi_size) {
+			src = src->bi_next;
+			if (!src)
+				break;
 
-			src_offset = src_bv->bv_offset;
+			src_iter = src->bi_iter;
 		}
 
-		if (dst_offset == dst_bv->bv_offset + dst_bv->bv_len) {
-			dst_bv++;
-			if (dst_bv == bio_iovec_idx(dst, dst->bi_vcnt)) {
-				dst = dst->bi_next;
-				if (!dst)
-					break;
-
-				dst_bv = __bio_iovec(dst);
-			}
+		if (!dst_iter.bi_size) {
+			dst = dst->bi_next;
+			if (!dst)
+				break;
 
-			dst_offset = dst_bv->bv_offset;
+			dst_iter = dst->bi_iter;
 		}
 
-		bytes = min(dst_bv->bv_offset + dst_bv->bv_len - dst_offset,
-			    src_bv->bv_offset + src_bv->bv_len - src_offset);
+		src_bv = bio_iter_iovec(src, src_iter);
+		dst_bv = bio_iter_iovec(dst, dst_iter);
+
+		bytes = min(src_bv.bv_len, dst_bv.bv_len);
 
-		src_p = kmap_atomic(src_bv->bv_page);
-		dst_p = kmap_atomic(dst_bv->bv_page);
+		src_p = kmap_atomic(src_bv.bv_page);
+		dst_p = kmap_atomic(dst_bv.bv_page);
 
-		memcpy(dst_p + dst_offset,
-		       src_p + src_offset,
+		memcpy(dst_p + dst_bv.bv_offset,
+		       src_p + src_bv.bv_offset,
 		       bytes);
 
 		kunmap_atomic(dst_p);
 		kunmap_atomic(src_p);
 
-		src_offset += bytes;
-		dst_offset += bytes;
+		bio_advance_iter(src, &src_iter, bytes);
+		bio_advance_iter(dst, &dst_iter, bytes);
 	}
 }
 EXPORT_SYMBOL(bio_copy_data);
-- 
1.8.4.rc3

