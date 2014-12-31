Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaLaCNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 21:13:50 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41004 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaLaCNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 21:13:49 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] lib/bitmap.c: Change prototype of bitmap_copy_le
Date: Wed, 31 Dec 2014 03:13:31 +0100
Message-Id: <1419992012-15545-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the prototype of bitmap_copy_le the same as bitmap_copy's. All
other bitmap_* functions take unsigned long* parameters; there's no
reason this should be special.

The only current user is the static inline uwb_mas_bm_copy_le, which
already does the void* laundering, so the end users can pass their u8
or __le32 buffers without a cast.

Furthermore, this allows us to simply let bitmap_copy_le be an alias
for bitmap_copy on little-endian; see next patch.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 2 +-
 lib/bitmap.c           | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 202e4034fe26..bd1748919872 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -170,7 +170,7 @@ extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
-extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
+extern void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits);
 extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
 extern int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 324ea9eab8c1..5ded9180528b 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1207,16 +1207,15 @@ EXPORT_SYMBOL(bitmap_allocate_region);
  *
  * Require nbits % BITS_PER_LONG == 0.
  */
-void bitmap_copy_le(void *dst, const unsigned long *src, int nbits)
+void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits)
 {
-	unsigned long *d = dst;
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < nbits/BITS_PER_LONG; i++) {
 		if (BITS_PER_LONG == 64)
-			d[i] = cpu_to_le64(src[i]);
+			dst[i] = cpu_to_le64(src[i]);
 		else
-			d[i] = cpu_to_le32(src[i]);
+			dst[i] = cpu_to_le32(src[i]);
 	}
 }
 EXPORT_SYMBOL(bitmap_copy_le);
-- 
2.1.3

