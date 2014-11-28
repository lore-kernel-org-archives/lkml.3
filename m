Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaK1QCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:02:03 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39342 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaK1QB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:59 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] lib: bitmap: Change bitmap_shift_left to take unsigned parameters
Date: Fri, 28 Nov 2014 17:01:08 +0100
Message-Id: <1417190476-18066-6-git-send-email-linux@rasmusvillemoes.dk>
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

If off >= lim (which requires shift >= nbits), k is initialized with a
large positive value, but since I've let k continue to be signed, the
loop will never run and dst will be zeroed as expected. Inside the
loop, k is guaranteed to be non-negative, so the fact that it is
promoted to unsigned in the various expressions it appears in is
harmless.

Also use "shift" and "nbits" consistently for the parameter names.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 12 ++++++------
 lib/bitmap.c           | 11 ++++++-----
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 5494adb..fc8abc7 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -96,8 +96,8 @@ extern void __bitmap_complement(unsigned long *dst, const unsigned long *src,
 			unsigned int nbits);
 extern void __bitmap_shift_right(unsigned long *dst, const unsigned long *src,
 				unsigned int shift, unsigned int nbits);
-extern void __bitmap_shift_left(unsigned long *dst,
-                        const unsigned long *src, int shift, int bits);
+extern void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
+				unsigned int shift, unsigned int nbits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
@@ -289,13 +289,13 @@ static inline void bitmap_shift_right(unsigned long *dst, const unsigned long *s
 		__bitmap_shift_right(dst, src, shift, nbits);
 }
 
-static inline void bitmap_shift_left(unsigned long *dst,
-			const unsigned long *src, int n, int nbits)
+static inline void bitmap_shift_left(unsigned long *dst, const unsigned long *src,
+				unsigned int shift, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = (*src << n) & BITMAP_LAST_WORD_MASK(nbits);
+		*dst = (*src << shift) & BITMAP_LAST_WORD_MASK(nbits);
 	else
-		__bitmap_shift_left(dst, src, n, nbits);
+		__bitmap_shift_left(dst, src, shift, nbits);
 }
 
 static inline int bitmap_parse(const char *buf, unsigned int buflen,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 0d78c96..5edd71b 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -146,18 +146,19 @@ EXPORT_SYMBOL(__bitmap_shift_right);
  *   @dst : destination bitmap
  *   @src : source bitmap
  *   @shift : shift by this many bits
- *   @bits : bitmap size, in bits
+ *   @nbits : bitmap size, in bits
  *
  * Shifting left (multiplying) means moving bits in the LS -> MS
  * direction.  Zeros are fed into the vacated LS bit positions
  * and those MS bits shifted off the top are lost.
  */
 
-void __bitmap_shift_left(unsigned long *dst,
-			const unsigned long *src, int shift, int bits)
+void __bitmap_shift_left(unsigned long *dst, const unsigned long *src,
+			unsigned int shift, unsigned int nbits)
 {
-	int k, lim = BITS_TO_LONGS(bits), left = bits % BITS_PER_LONG;
-	int off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
+	int k;
+	unsigned int lim = BITS_TO_LONGS(nbits), left = nbits % BITS_PER_LONG;
+	unsigned int off = shift/BITS_PER_LONG, rem = shift % BITS_PER_LONG;
 	for (k = lim - off - 1; k >= 0; --k) {
 		unsigned long upper, lower;
 
-- 
2.0.4

