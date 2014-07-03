Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135AbaGCWqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:46:20 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:37218 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759906AbaGCWnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:43:37 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: linux-kernel@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 10/18] lib: bitmap: Make the start index of bitmap_set unsigned
Date: Fri,  4 Jul 2014 00:42:56 +0200
Message-Id: <1404427384-11422-11-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1404427384-11422-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler can generate slightly smaller and simpler code when it
knows that "start" is non-negative.

Also, use the names "start" and "len" for the two parameters in both
header file and implementation, instead of the previous mix.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h |  2 +-
 lib/bitmap.c           | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 64b0ebe..ad2c67d 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -112,7 +112,7 @@ extern int __bitmap_subset(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
 
-extern void bitmap_set(unsigned long *map, int i, int len);
+extern void bitmap_set(unsigned long *map, unsigned int start, int len);
 extern void bitmap_clear(unsigned long *map, int start, int nr);
 extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
 					 unsigned long size,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index f69435c..2a3a92f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -274,21 +274,21 @@ int __bitmap_weight(const unsigned long *bitmap, unsigned int bits)
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
-void bitmap_set(unsigned long *map, int start, int nr)
+void bitmap_set(unsigned long *map, unsigned int start, int len)
 {
 	unsigned long *p = map + BIT_WORD(start);
-	const int size = start + nr;
+	const unsigned int size = start + len;
 	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
 	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
 
-	while (nr - bits_to_set >= 0) {
+	while (len - bits_to_set >= 0) {
 		*p |= mask_to_set;
-		nr -= bits_to_set;
+		len -= bits_to_set;
 		bits_to_set = BITS_PER_LONG;
 		mask_to_set = ~0UL;
 		p++;
 	}
-	if (nr) {
+	if (len) {
 		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
 		*p |= mask_to_set;
 	}
-- 
1.9.2

