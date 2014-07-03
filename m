Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbaGCWnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:43:39 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58567 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759847AbaGCWng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:36 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 09/18] lib: bitmap: Make nbits parameter of bitmap_weight unsigned
Date: Fri,  4 Jul 2014 00:42:55 +0200
Message-Id: <1404427384-11422-10-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler can generate slightly smaller and simpler code when it
knows that "nbits" is non-negative. Since no-one passes a negative
bit-count, this shouldn't affect the semantics.

I didn't change the return type, since that might change the semantics
of some expression containing a call to bitmap_weight(). Certainly an
int is capable of holding the result.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 4 ++--
 lib/bitmap.c           | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 87e88f7..64b0ebe 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -110,7 +110,7 @@ extern int __bitmap_intersects(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_subset(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
-extern int __bitmap_weight(const unsigned long *bitmap, int bits);
+extern int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
 
 extern void bitmap_set(unsigned long *map, int i, int len);
 extern void bitmap_clear(unsigned long *map, int start, int nr);
@@ -273,7 +273,7 @@ static inline int bitmap_full(const unsigned long *src, unsigned int nbits)
 		return __bitmap_full(src, nbits);
 }
 
-static inline int bitmap_weight(const unsigned long *src, int nbits)
+static inline int bitmap_weight(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
diff --git a/lib/bitmap.c b/lib/bitmap.c
index c9bff53..f69435c 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -259,9 +259,10 @@ int __bitmap_subset(const unsigned long *bitmap1,
 }
 EXPORT_SYMBOL(__bitmap_subset);
 
-int __bitmap_weight(const unsigned long *bitmap, int bits)
+int __bitmap_weight(const unsigned long *bitmap, unsigned int bits)
 {
-	int k, w = 0, lim = bits/BITS_PER_LONG;
+	unsigned int k, lim = bits/BITS_PER_LONG;
+	int w = 0;
 
 	for (k = 0; k < lim; k++)
 		w += hweight_long(bitmap[k]);
-- 
1.9.2

