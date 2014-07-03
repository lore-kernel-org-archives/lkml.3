Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbaGCWnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:43:51 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:45274 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759962AbaGCWns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:48 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 18/18] lib: bitmap: Add missing mask in bitmap_andnot
Date: Fri,  4 Jul 2014 00:43:04 +0200
Message-Id: <1404427384-11422-19-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently, bitmap_andnot is supposed to return whether the new bitmap
is empty. But it didn't take potential garbage bits in the last word
into account.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 2 +-
 lib/bitmap.c           | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 3399a9e..e1c8d08 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -217,7 +217,7 @@ static inline int bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
-		return (*dst = *src1 & ~(*src2)) != 0;
+		return (*dst = *src1 & ~(*src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	return __bitmap_andnot(dst, src1, src2, nbits);
 }
 
diff --git a/lib/bitmap.c b/lib/bitmap.c
index ce2ec80..1e031f2 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -223,11 +223,14 @@ int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, unsigned int bits)
 {
 	unsigned int k;
-	unsigned int nr = BITS_TO_LONGS(bits);
+	unsigned int lim = bits/BITS_PER_LONG;
 	unsigned long result = 0;
 
-	for (k = 0; k < nr; k++)
+	for (k = 0; k < lim; k++)
 		result |= (dst[k] = bitmap1[k] & ~bitmap2[k]);
+	if (bits % BITS_PER_LONG)
+		result |= (dst[k] = bitmap1[k] & ~bitmap2[k] &
+			   BITMAP_LAST_WORD_MASK(bits));
 	return result != 0;
 }
 EXPORT_SYMBOL(__bitmap_andnot);
-- 
1.9.2

