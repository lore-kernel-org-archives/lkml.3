Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaLSJXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:23:54 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42566 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaLSJXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:23:51 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] lib: bitmap: Make the bits parameter of bitmap_remap unsigned
Date: Fri, 19 Dec 2014 10:23:26 +0100
Message-Id: <1418981007-19798-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418939798-18350-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418939798-18350-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, rename bits to nbits. Both changes for consistency with other
bitmap_* functions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

Notes:
    v3: Hopefully complete and unambiguous commit log.
    
    v2: Only do the signed->unsigned conversion. bitmap_remap only has a
    single caller (via nodes_remap), so bloating it by special-casing
    empty new isn't justified (and the commit log was wrong; it said
    "empty dst").

 include/linux/bitmap.h |  2 +-
 lib/bitmap.c           | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index e1c8d080c427..1a634b0e0cbe 100644
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
index b499ab6ada29..5884b974407b 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -788,7 +788,7 @@ int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
  *	@src: subset to be remapped
  *	@old: defines domain of map
  *	@new: defines range of map
- *	@bits: number of bits in each of these bitmaps
+ *	@nbits: number of bits in each of these bitmaps
  *
  * Let @old and @new define a mapping of bit positions, such that
  * whatever position is held by the n-th set bit in @old is mapped
@@ -816,22 +816,22 @@ int bitmap_ord_to_pos(const unsigned long *buf, int ord, int bits)
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
+	bitmap_zero(dst, nbits);
 
-	w = bitmap_weight(new, bits);
-	for_each_set_bit(oldbit, src, bits) {
-	     	int n = bitmap_pos_to_ord(old, oldbit, bits);
+	w = bitmap_weight(new, nbits);
+	for_each_set_bit(oldbit, src, nbits) {
+		int n = bitmap_pos_to_ord(old, oldbit, nbits);
 
 		if (n < 0 || w == 0)
 			set_bit(oldbit, dst);	/* identity map */
 		else
-			set_bit(bitmap_ord_to_pos(new, n % w, bits), dst);
+			set_bit(bitmap_ord_to_pos(new, n % w, nbits), dst);
 	}
 }
 EXPORT_SYMBOL(bitmap_remap);
-- 
2.1.3

