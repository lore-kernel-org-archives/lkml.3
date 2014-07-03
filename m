Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbaGCWqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:46:43 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56170 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759782AbaGCWne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:34 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 07/18] lib: bitmap: Make nbits parameter of bitmap_intersects unsigned
Date: Fri,  4 Jul 2014 00:42:53 +0200
Message-Id: <1404427384-11422-8-git-send-email-linux@rasmusvillemoes.dk>
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
 include/linux/bitmap.h | 4 ++--
 lib/bitmap.c           | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7048782..2f3f3a4 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -107,7 +107,7 @@ extern void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
 extern int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_intersects(const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_subset(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_weight(const unsigned long *bitmap, int bits);
@@ -240,7 +240,7 @@ static inline int bitmap_equal(const unsigned long *src1,
 }
 
 static inline int bitmap_intersects(const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return ((*src1 & *src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 0320737..e85daa9 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -230,9 +230,9 @@ int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
 EXPORT_SYMBOL(__bitmap_andnot);
 
 int __bitmap_intersects(const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+			const unsigned long *bitmap2, unsigned int bits)
 {
-	int k, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
 	for (k = 0; k < lim; ++k)
 		if (bitmap1[k] & bitmap2[k])
 			return 1;
-- 
1.9.2

