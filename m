Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3C0RqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:46:03 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53473 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3C0Rk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:27 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 08/22] block: Convert bio_copy_data() to bvec_iter
Date: Wed, 27 Mar 2013 10:39:38 -0700
Message-Id: <1364405992-28424-9-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/bio.c | 60 +++++++++++++++++++++++++-----------------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index cb89a59..80644cc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -853,58 +853,48 @@ EXPORT_SYMBOL(bio_alloc_pages);
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
+		src_bv = bio_iovec_iter(src, src_iter);
+		dst_bv = bio_iovec_iter(dst, dst_iter);
+
+		bytes = min(src_bv.bv_len, dst_bv.bv_len);
 
-		src_p = kmap_atomic(src_bv->bv_page);
-		dst_p = kmap_atomic(dst_bv->bv_page);
+		src_p = kmap_atomic(src_bv.bv_page);
+		dst_p = kmap_atomic(dst_bv.bv_page);
 
-		memcpy(dst_p + dst_bv->bv_offset,
-		       src_p + src_bv->bv_offset,
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
1.8.1.3

