Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527AbaLLACj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:02:39 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43944 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934467AbaLLACV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:02:21 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] lib: bitmap: Simplify bitmap_ord_to_pos
Date: Fri, 12 Dec 2014 01:01:53 +0100
Message-Id: <1418342514-21630-8-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the return value and the ord and nbits parameters of
bitmap_ord_to_pos unsigned.

Also, simplify the implementation and as a side effect make the result
fully defined, returning nbits for ord >= weight, in analogy with what
find_{first,next}_bit does. This is a better sentinel than the former
("unofficial") 0. No current users are affected by this change.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h |  2 +-
 lib/bitmap.c           | 28 +++++++++++-----------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 85e8fb091ed7..e854934cdbf9 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -144,7 +144,7 @@ extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
-extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
+extern unsigned int bitmap_ord_to_pos(const unsigned long *bitmap, unsigned int ord, unsigned int nbits);
 
 #define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
 #define BITMAP_LAST_WORD_MASK(nbits)					\
diff --git a/lib/bitmap.c b/lib/bitmap.c
index ab62a7e4d50f..89b61e42f173 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -740,34 +740,28 @@ static int bitmap_pos_to_ord(const unsigned long *buf, unsigned int pos, unsigne
  * bitmap_ord_to_pos - find position of n-th set bit in bitmap
  *	@buf: pointer to bitmap
  *	@ord: ordinal bit position (n-th set bit, n >= 0)
- *	@bits: number of valid bit positions in @buf
+ *	@nbits: number of valid bit positions in @buf
  *
  * Map the ordinal offset of bit @ord in @buf to its position in @buf.
- * Value of @ord should be in range 0 <= @ord < weight(buf), else
- * results are undefined.
+ * Value of @ord should be in range 0 <= @ord < weight(buf). If @ord
+ * >= weight(buf), returns @nbits.
  *
  * If for example, just bits 4 through 7 are set in @buf, then @ord
  * values 0 through 3 will get mapped to 4 through 7, respectively,
- * and all other @ord values return undefined values.  When @ord value 3
+ * and all other @ord values returns @nbits.  When @ord value 3
  * gets mapped to (returns) @pos value 7 in this example, that means
  * that the 3rd set bit (starting with 0th) is at position 7 in @buf.
  *
- * The bit positions 0 through @bits are valid positions in @buf.
+ * The bit positions 0 through @nbits-1 are valid positions in @buf.
  */
-int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
+unsigned int bitmap_ord_to_pos(const unsigned long *buf, unsigned int ord, unsigned int nbits)
 {
-	int pos = 0;
+	unsigned int pos;
 
-	if (ord >= 0 && ord < bits) {
-		int i;
-
-		for (i = find_first_bit(buf, bits);
-		     i < bits && ord > 0;
-		     i = find_next_bit(buf, bits, i + 1))
-	     		ord--;
-		if (i < bits && ord == 0)
-			pos = i;
-	}
+	for (pos = find_first_bit(buf, nbits);
+	     pos < nbits && ord;
+	     pos = find_next_bit(buf, nbits, pos + 1))
+		ord--;
 
 	return pos;
 }
-- 
2.1.3

