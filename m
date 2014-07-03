Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbaGCWri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:47:38 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:60327 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770AbaGCWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:30 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 04/18] lib: bitmap: Make nbits parameter of bitmap_complement unsigned
Date: Fri,  4 Jul 2014 00:42:50 +0200
Message-Id: <1404427384-11422-5-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler can generate slightly smaller and simpler code when it
knows that "nbits" is non-negative. Since no-one passes a
negative bit-count, this shouldn't affect the semantics.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 6 +++---
 lib/bitmap.c           | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 1e0f46c..21fb52f 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -93,7 +93,7 @@ extern int __bitmap_full(const unsigned long *bitmap, unsigned int nbits);
 extern int __bitmap_equal(const unsigned long *bitmap1,
 			  const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
-			int bits);
+			unsigned int nbits);
 extern void __bitmap_shift_right(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
 extern void __bitmap_shift_left(unsigned long *dst,
@@ -222,7 +222,7 @@ static inline int bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 }
 
 static inline void bitmap_complement(unsigned long *dst, const unsigned long *src,
-			int nbits)
+			unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
@@ -231,7 +231,7 @@ static inline void bitmap_complement(unsigned long *dst, const unsigned long *sr
 }
 
 static inline int bitmap_equal(const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
diff --git a/lib/bitmap.c b/lib/bitmap.c
index d6bb955..0f2f845 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -86,9 +86,9 @@ int __bitmap_equal(const unsigned long *bitmap1,
 }
 EXPORT_SYMBOL(__bitmap_equal);
 
-void __bitmap_complement(unsigned long *dst, const unsigned long *src, int bits)
+void __bitmap_complement(unsigned long *dst, const unsigned long *src, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		dst[k] = ~src[k];
 
-- 
1.9.2

