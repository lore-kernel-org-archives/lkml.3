Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbbASVZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:25:53 -0500
Received: from mail-lb0-f196.google.com ([209.85.217.196]:62796 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbASVZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:25:52 -0500
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: heukelum@mailshack.com, mita@miraclelinux.com,
        Yury Norov <yury.norov@gmail.com>
Subject: [PATCH] lib: find_*_bit reimplementation
Date: Tue, 20 Jan 2015 00:25:06 +0300
Message-Id: <1421702706-10404-1-git-send-email-yury.norov@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New implementation takes less space, and, I hope, easier to understand.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 lib/find_next_bit.c | 265 +++++++++++++++-------------------------------------
 1 file changed, 73 insertions(+), 192 deletions(-)

diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index 0cbfc0b..a5c915f 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -11,10 +11,39 @@
 
 #include <linux/bitops.h>
 #include <linux/export.h>
+#include <linux/kernel.h>
 #include <asm/types.h>
 #include <asm/byteorder.h>
 
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
+#define HIGH_BITS_MASK(nr)		(ULONG_MAX << (nr))
+#define MIN(a, b)			((a) < (b) ? (a) : (b))
+
+#if !defined(find_next_bit) || !defined(find_next_zero_bit)
+static unsigned long _find_next_bit(const unsigned long *addr,
+		unsigned long end, unsigned long start, unsigned long flags)
+{
+	unsigned long tmp = flags ? addr[start / BITS_PER_LONG]
+			: ~addr[start / BITS_PER_LONG];
+
+	/* Handle 1st word. */
+	if (!IS_ALIGNED(start, BITS_PER_LONG)) {
+		tmp &= HIGH_BITS_MASK(start % BITS_PER_LONG);
+		start = round_down(start, BITS_PER_LONG);
+	}
+
+	do {
+		if (tmp)
+			return MIN(start + __ffs(tmp), end);
+
+		start += BITS_PER_LONG;
+		if (start >= end)
+			return end;
+
+		tmp = flags ? addr[start / BITS_PER_LONG]
+			: ~addr[start / BITS_PER_LONG];
+	} while (1);
+}
+#endif
 
 #ifndef find_next_bit
 /*
@@ -23,86 +52,16 @@
 unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
 			    unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset %= BITS_PER_LONG;
-	if (offset) {
-		tmp = *(p++);
-		tmp &= (~0UL << offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	tmp &= (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found_middle:
-	return result + __ffs(tmp);
+	return _find_next_bit(addr, size, offset, 1);
 }
 EXPORT_SYMBOL(find_next_bit);
 #endif
 
 #ifndef find_next_zero_bit
-/*
- * This implementation of find_{first,next}_zero_bit was stolen from
- * Linus' asm-alpha/bitops.h.
- */
 unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 				 unsigned long offset)
 {
-	const unsigned long *p = addr + BITOP_WORD(offset);
-	unsigned long result = offset & ~(BITS_PER_LONG-1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset %= BITS_PER_LONG;
-	if (offset) {
-		tmp = *(p++);
-		tmp |= ~0UL >> (BITS_PER_LONG - offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (~tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-	while (size & ~(BITS_PER_LONG-1)) {
-		if (~(tmp = *(p++)))
-			goto found_middle;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	tmp |= ~0UL << size;
-	if (tmp == ~0UL)	/* Are any bits zero? */
-		return result + size;	/* Nope. */
-found_middle:
-	return result + ffz(tmp);
+	return _find_next_bit(addr, size, offset, 0);
 }
 EXPORT_SYMBOL(find_next_zero_bit);
 #endif
@@ -113,24 +72,14 @@ EXPORT_SYMBOL(find_next_zero_bit);
  */
 unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
 {
-	const unsigned long *p = addr;
-	unsigned long result = 0;
-	unsigned long tmp;
+	unsigned int idx;
 
-	while (size & ~(BITS_PER_LONG-1)) {
-		if ((tmp = *(p++)))
-			goto found;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
+	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
+		if (addr[idx])
+			return idx * BITS_PER_LONG + __ffs(addr[idx]);
 	}
-	if (!size)
-		return result;
 
-	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size;	/* Nope. */
-found:
-	return result + __ffs(tmp);
+	return size;
 }
 EXPORT_SYMBOL(find_first_bit);
 #endif
@@ -141,24 +90,14 @@ EXPORT_SYMBOL(find_first_bit);
  */
 unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
 {
-	const unsigned long *p = addr;
-	unsigned long result = 0;
-	unsigned long tmp;
+	unsigned int idx;
 
-	while (size & ~(BITS_PER_LONG-1)) {
-		if (~(tmp = *(p++)))
-			goto found;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
+	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
+		if (addr[idx] != ULONG_MAX)
+			return idx * BITS_PER_LONG + ffz(addr[idx]);
 	}
-	if (!size)
-		return result;
 
-	tmp = (*p) | (~0UL << size);
-	if (tmp == ~0UL)	/* Are any bits zero? */
-		return result + size;	/* Nope. */
-found:
-	return result + ffz(tmp);
+	return size;
 }
 EXPORT_SYMBOL(find_first_zero_bit);
 #endif
@@ -166,18 +105,6 @@ EXPORT_SYMBOL(find_first_zero_bit);
 #ifdef __BIG_ENDIAN
 
 /* include/linux/byteorder does not support "unsigned long" type */
-static inline unsigned long ext2_swabp(const unsigned long * x)
-{
-#if BITS_PER_LONG == 64
-	return (unsigned long) __swab64p((u64 *) x);
-#elif BITS_PER_LONG == 32
-	return (unsigned long) __swab32p((u32 *) x);
-#else
-#error BITS_PER_LONG not defined
-#endif
-}
-
-/* include/linux/byteorder doesn't support "unsigned long" type */
 static inline unsigned long ext2_swab(const unsigned long y)
 {
 #if BITS_PER_LONG == 64
@@ -189,48 +116,40 @@ static inline unsigned long ext2_swab(const unsigned long y)
 #endif
 }
 
-#ifndef find_next_zero_bit_le
-unsigned long find_next_zero_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
+#if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
+static unsigned long _find_next_bit_le(const unsigned long *addr,
+		unsigned long end, unsigned long start, unsigned long flags)
 {
-	const unsigned long *p = addr;
-	unsigned long result = offset & ~(BITS_PER_LONG - 1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	p += BITOP_WORD(offset);
-	size -= result;
-	offset &= (BITS_PER_LONG - 1UL);
-	if (offset) {
-		tmp = ext2_swabp(p++);
-		tmp |= (~0UL >> (BITS_PER_LONG - offset));
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (~tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
+	unsigned long tmp = flags ? addr[start / BITS_PER_LONG]
+			: ~addr[start / BITS_PER_LONG];
+
+	/* Handle 1st word. */
+	if (!IS_ALIGNED(start, BITS_PER_LONG)) {
+		tmp &= ext2_swab(HIGH_BITS_MASK(start
+					% BITS_PER_LONG));
+		start = round_down(start, BITS_PER_LONG);
 	}
 
-	while (size & ~(BITS_PER_LONG - 1)) {
-		if (~(tmp = *(p++)))
-			goto found_middle_swap;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = ext2_swabp(p);
-found_first:
-	tmp |= ~0UL << size;
-	if (tmp == ~0UL)	/* Are any bits zero? */
-		return result + size; /* Nope. Skip ffz */
-found_middle:
-	return result + ffz(tmp);
+	do {
+		if (tmp)
+			return MIN(start +
+				__ffs(ext2_swab(tmp)), end);
 
-found_middle_swap:
-	return result + ffz(ext2_swab(tmp));
+		start += BITS_PER_LONG;
+		if (start >= end)
+			return end;
+
+		tmp = flags ? addr[start / BITS_PER_LONG]
+			: ~addr[start / BITS_PER_LONG];
+	} while (1);
+}
+#endif
+
+#ifndef find_next_zero_bit_le
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	return _find_next_bit_le(addr, size, offset, o);
 }
 EXPORT_SYMBOL(find_next_zero_bit_le);
 #endif
@@ -239,45 +158,7 @@ EXPORT_SYMBOL(find_next_zero_bit_le);
 unsigned long find_next_bit_le(const void *addr, unsigned
 		long size, unsigned long offset)
 {
-	const unsigned long *p = addr;
-	unsigned long result = offset & ~(BITS_PER_LONG - 1);
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	p += BITOP_WORD(offset);
-	size -= result;
-	offset &= (BITS_PER_LONG - 1UL);
-	if (offset) {
-		tmp = ext2_swabp(p++);
-		tmp &= (~0UL << offset);
-		if (size < BITS_PER_LONG)
-			goto found_first;
-		if (tmp)
-			goto found_middle;
-		size -= BITS_PER_LONG;
-		result += BITS_PER_LONG;
-	}
-
-	while (size & ~(BITS_PER_LONG - 1)) {
-		tmp = *(p++);
-		if (tmp)
-			goto found_middle_swap;
-		result += BITS_PER_LONG;
-		size -= BITS_PER_LONG;
-	}
-	if (!size)
-		return result;
-	tmp = ext2_swabp(p);
-found_first:
-	tmp &= (~0UL >> (BITS_PER_LONG - size));
-	if (tmp == 0UL)		/* Are any bits set? */
-		return result + size; /* Nope. */
-found_middle:
-	return result + __ffs(tmp);
-
-found_middle_swap:
-	return result + __ffs(ext2_swab(tmp));
+	return _find_next_bit_le(addr, size, offset, 1);
 }
 EXPORT_SYMBOL(find_next_bit_le);
 #endif
-- 
2.1.0

