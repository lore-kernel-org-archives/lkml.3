Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaK1QBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:01:45 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:59489 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaK1QBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:42 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] lib: bitmap: Change bitmap_shift_right to take unsigned parameters
Date: Fri, 28 Nov 2014 17:01:04 +0100
Message-Id: <1417190476-18066-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc can generate slightly better code for stuff like "nbits %
BITS_PER_LONG" when it knows nbits is not negative. Since negative
size bitmaps or shift amounts don't make sense, change these
parameters of bitmap_shift_right to unsigned.

The expressions involving "lim - 1" are still ok, since if lim is 0
the loop is never executed.

Also use "shift" and "nbits" consistently for the parameter names.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 12 ++++++------
 lib/bitmap.c           | 10 +++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index e1c8d08..5494adb 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -94,8 +94,8 @@ extern int __bitmap_equal(const unsigned long *bitmap1,
 			  const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
 			unsigned int nbits);
-extern void __bitmap_shift_right(unsigned long *dst,
-                        const unsigned long *src, int shift, int bits);
+extern void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
+				unsigned int shift, unsigned int nbits);
 extern void __bitmap_shift_left(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
@@ -280,13 +280,13 @@ static inline int bitmap_weight(const unsigned long *src, unsigned int nbits)
 	return __bitmap_weight(src, nbits);
 }
 
-static inline void bitmap_shift_right(unsigned long *dst,
-			const unsigned long *src, int n, int nbits)
+static inline void bitmap_shift_right(unsigned long *dst, const unsigned long *src,
+				unsigned int shift, int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = (*src & BITMAP_LAST_WORD_MASK(nbits)) >> n;
+		*dst = (*src & BITMAP_LAST_WORD_MASK(nbits)) >> shift;
 	else
-		__bitmap_shift_right(dst, src, n, nbits);
+		__bitmap_shift_right(dst, src, shift, nbits);
 }
 
 static inline void bitmap_shift_left(unsigned long *dst,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index b499ab6..2332115 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -102,17 +102,17 @@ EXPORT_SYMBOL(__bitmap_complement);
  *   @dst : destination bitmap
  *   @src : source bitmap
  *   @shift : shift by this many bits
- *   @bits : bitmap size, in bits
+ *   @nbits : bitmap size, in bits
  *
  * Shifting right (dividing) means moving bits in the MS -> LS bit
  * direction.  Zeros are fed into the vacated MS positions and the
  * LS bits shifted off the bottom are lost.
  */
-void __bitmap_shift_right(unsigned long *dst,
-			const unsigned long *src, int shift, int bits)
+void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
+			unsigned shift, unsigned nbits)
 {
-	int k, lim = BITS_TO_LONGS(bits), left = bits % BITS_PER_LONG;
-	int off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
+	unsigned k, lim = BITS_TO_LONGS(nbits), left = nbits % BITS_PER_LONG;
+	unsigned off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
 	unsigned long mask = (1UL << left) - 1;
 	for (k = 0; off + k < lim; ++k) {
 		unsigned long upper, lower;
-- 
2.0.4

