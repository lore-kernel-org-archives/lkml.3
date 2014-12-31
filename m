Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaLaCNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 21:13:54 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:41470 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaLaCNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 21:13:51 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] lib/bitmap.c: Elide bitmap_copy_le on little-endian
Date: Wed, 31 Dec 2014 03:13:32 +0100
Message-Id: <1419992012-15545-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419992012-15545-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419992012-15545-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On little-endian, there's no reason to have an extra, presumably less
efficient, way of copying a bitmap.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/bitmap.h | 4 ++++
 lib/bitmap.c           | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index bd1748919872..a1977e153e63 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -170,7 +170,11 @@ extern void bitmap_fold(unsigned long *dst, const unsigned long *orig,
 extern int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
+#ifdef __BIG_ENDIAN
 extern void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits);
+#else
+#define bitmap_copy_le bitmap_copy
+#endif
 extern int bitmap_ord_to_pos(const unsigned long *bitmap, int n, int bits);
 extern int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 5ded9180528b..8014996b1531 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1207,6 +1207,7 @@ EXPORT_SYMBOL(bitmap_allocate_region);
  *
  * Require nbits % BITS_PER_LONG == 0.
  */
+#ifdef __BIG_ENDIAN
 void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits)
 {
 	unsigned int i;
@@ -1219,3 +1220,4 @@ void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int n
 	}
 }
 EXPORT_SYMBOL(bitmap_copy_le);
+#endif
-- 
2.1.3

