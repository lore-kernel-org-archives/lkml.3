Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965770AbaLLACk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:02:40 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:32869 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934468AbaLLACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:02:22 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] lib: bitmap: Minor changes of bitmap_remap
Date: Fri, 12 Dec 2014 01:01:54 +0100
Message-Id: <1418342514-21630-9-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the nbits parameter unsigned for consistency with most other
bitmap_* functions, and pull the test of empty dst out of the loop.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h |  2 +-
 lib/bitmap.c           | 23 ++++++++++++++---------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index e854934cdbf9..690b180d723a 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -133,7 +133,7 @@ extern int bitmap_parselist(const char *buf, unsigned long *maskp,
 extern int bitmap_parselist_user(const char __user *ubuf, unsigned int ulen,
 			unsigned long *dst, int nbits);
 extern void bitmap_remap(unsigned long *dst, const unsigned long *src,
-		const unsigned long *old, const unsigned long *new, int bits);
+		const unsigned long *old, const unsigned long *new, unsigned int nbits);
 extern int bitmap_bitremap(int oldbit,
 		const unsigned long *old, const unsigned long *new, int bits);
 extern void bitmap_onto(unsigned long *dst, const unsigned long *orig,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 89b61e42f173..eda3bf0673ad 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -772,7 +772,7 @@ unsigned int bitmap_ord_to_pos(const unsigned long *buf, unsigned int ord, unsig
  *	@src: subset to be remapped
  *	@old: defines domain of map
  *	@new: defines range of map
- *	@bits: number of bits in each of these bitmaps
+ *	@nbits: number of bits in each of these bitmaps
  *
  * Let @old and @new define a mapping of bit positions, such that
  * whatever position is held by the n-th set bit in @old is mapped
@@ -800,22 +800,27 @@ unsigned int bitmap_ord_to_pos(const unsigned long *buf, unsigned int ord, unsig
  */
 void bitmap_remap(unsigned long *dst, const unsigned long *src,
 		const unsigned long *old, const unsigned long *new,
-		int bits)
+		unsigned int nbits)
 {
-	int oldbit, w;
+	unsigned int oldbit, w;
 
 	if (dst == src)		/* following doesn't handle inplace remaps */
 		return;
-	bitmap_zero(dst, bits);
 
-	w = bitmap_weight(new, bits);
-	for_each_set_bit(oldbit, src, bits) {
-	     	int n = bitmap_pos_to_ord(old, oldbit, bits);
+	w = bitmap_weight(new, nbits);
+	if (!w) {
+		bitmap_copy(dst, src, nbits);
+		return;
+	}
+
+	bitmap_zero(dst, nbits);
+	for_each_set_bit(oldbit, src, nbits) {
+		int n = bitmap_pos_to_ord(old, oldbit, nbits);
 
-		if (n < 0 || w == 0)
+		if (n < 0)
 			set_bit(oldbit, dst);	/* identity map */
 		else
-			set_bit(bitmap_ord_to_pos(new, n % w, bits), dst);
+			set_bit(bitmap_ord_to_pos(new, n % w, nbits), dst);
 	}
 }
 EXPORT_SYMBOL(bitmap_remap);
-- 
2.1.3

