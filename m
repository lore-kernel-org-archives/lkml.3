Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbaGCWnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:43:35 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:53849 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759847AbaGCWnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:33 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 06/18] lib: bitmap: Make nbits parameter of bitmap_{and,or,xor,andnot} unsigned
Date: Fri,  4 Jul 2014 00:42:52 +0200
Message-Id: <1404427384-11422-7-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is only for consistency with the changes to the other
bitmap_* functions; it doesn't change the size of the generated code:
inside BITS_TO_LONGS there is a sizeof(long), which causes bits to be
interpreted as unsigned anyway.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 16 ++++++++--------
 lib/bitmap.c           | 24 ++++++++++++------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index f42d72d..7048782 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -99,13 +99,13 @@ extern void __bitmap_shift_right(unsigned long *dst,
 extern void __bitmap_shift_left(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
-			const unsigned long *bitmap2, int bits);
+			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_intersects(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_subset(const unsigned long *bitmap1,
@@ -188,7 +188,7 @@ static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
 }
 
 static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return (*dst = *src1 & *src2) != 0;
@@ -196,7 +196,7 @@ static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
 }
 
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src1 | *src2;
@@ -205,7 +205,7 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 }
 
 static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		*dst = *src1 ^ *src2;
@@ -214,7 +214,7 @@ static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
 }
 
 static inline int bitmap_andnot(unsigned long *dst, const unsigned long *src1,
-			const unsigned long *src2, int nbits)
+			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return (*dst = *src1 & ~(*src2)) != 0;
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 4387e3c..0320737 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -182,10 +182,10 @@ void __bitmap_shift_left(unsigned long *dst,
 EXPORT_SYMBOL(__bitmap_shift_left);
 
 int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 	unsigned long result = 0;
 
 	for (k = 0; k < nr; k++)
@@ -195,10 +195,10 @@ int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 EXPORT_SYMBOL(__bitmap_and);
 
 void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 
 	for (k = 0; k < nr; k++)
 		dst[k] = bitmap1[k] | bitmap2[k];
@@ -206,10 +206,10 @@ void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
 EXPORT_SYMBOL(__bitmap_or);
 
 void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 
 	for (k = 0; k < nr; k++)
 		dst[k] = bitmap1[k] ^ bitmap2[k];
@@ -217,10 +217,10 @@ void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
 EXPORT_SYMBOL(__bitmap_xor);
 
 int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
-				const unsigned long *bitmap2, int bits)
+				const unsigned long *bitmap2, unsigned int bits)
 {
-	int k;
-	int nr = BITS_TO_LONGS(bits);
+	unsigned int k;
+	unsigned int nr = BITS_TO_LONGS(bits);
 	unsigned long result = 0;
 
 	for (k = 0; k < nr; k++)
-- 
1.9.2

