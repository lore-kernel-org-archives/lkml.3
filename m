Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbaLLACg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:02:36 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:62682 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbaLLACV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:02:21 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] lib: bitmap: Simplify bitmap_pos_to_ord
Date: Fri, 12 Dec 2014 01:01:52 +0100
Message-Id: <1418342514-21630-7-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ordinal of the a set bit is simply the number of set bits before
it; counting those doesn't need to be done one bit at a time. While at
it, update the parameters to unsigned int.

It is not completely unthinkable that gcc would see pos as
compile-time constant 0 in one of the uses of bitmap_pos_to_ord. Since
the static inline frontend bitmap_weight doesn't handle nbits==0
correctly (it would behave exactly as if nbits==BITS_PER_LONG), use
__bitmap_weight.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

Notes:
    Alternatively, the last line could be spelled bitmap_weight(buf,
    pos+1)-1, but this is simpler.

 lib/bitmap.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1807d089eda7..ab62a7e4d50f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -713,10 +713,10 @@ EXPORT_SYMBOL(bitmap_parselist_user);
 /**
  * bitmap_pos_to_ord - find ordinal of set bit at given position in bitmap
  *	@buf: pointer to a bitmap
- *	@pos: a bit position in @buf (0 <= @pos < @bits)
- *	@bits: number of valid bit positions in @buf
+ *	@pos: a bit position in @buf (0 <= @pos < @nbits)
+ *	@nbits: number of valid bit positions in @buf
  *
- * Map the bit at position @pos in @buf (of length @bits) to the
+ * Map the bit at position @pos in @buf (of length @nbits) to the
  * ordinal of which set bit it is.  If it is not set or if @pos
  * is not a valid bit position, map to -1.
  *
@@ -728,22 +728,12 @@ EXPORT_SYMBOL(bitmap_parselist_user);
  *
  * The bit positions 0 through @bits are valid positions in @buf.
  */
-static int bitmap_pos_to_ord(const unsigned long *buf, int pos, int bits)
+static int bitmap_pos_to_ord(const unsigned long *buf, unsigned int pos, unsigned int nbits)
 {
-	int i, ord;
-
-	if (pos < 0 || pos >= bits || !test_bit(pos, buf))
+	if (pos >= nbits || !test_bit(pos, buf))
 		return -1;
 
-	i = find_first_bit(buf, bits);
-	ord = 0;
-	while (i < pos) {
-		i = find_next_bit(buf, bits, i + 1);
-	     	ord++;
-	}
-	BUG_ON(i != pos);
-
-	return ord;
+	return __bitmap_weight(buf, pos);
 }
 
 /**
-- 
2.1.3

