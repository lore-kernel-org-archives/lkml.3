Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab3HAUZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:25:03 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:12036 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3HAUZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:25:00 -0400
Message-ID: <201308012024.r71KOwQN029953@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Aug 2013 15:52:17 -0400
Subject: [PATCH] tile: optimize and clean up string functions
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change cleans up the string code in a number of ways:

- For memcpy(), fix bug in prefetch and increase distance to 3 lines;
  optimize for unaligned data; do all loads before wh64 to make memcpy
  safe for forward-overlapping calls; etc.  Performance is improved.

- Use new copy_byte() function on tilegx to spread a single byte value
  out into a full word using the shufflebytes instruction.

- Clean up header include ordering to be more canonical, and remove
  spurious #undefs of function names.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/memchr_64.c     |   2 +-
 arch/tile/lib/memcpy_64.c     | 261 +++++++++++++++++++++++++++++++-----------
 arch/tile/lib/memset_32.c     |   5 +-
 arch/tile/lib/memset_64.c     |   9 +-
 arch/tile/lib/strchr_32.c     |   2 -
 arch/tile/lib/strchr_64.c     |   2 +-
 arch/tile/lib/string-endian.h |  13 ++-
 arch/tile/lib/strlen_32.c     |   2 -
 8 files changed, 212 insertions(+), 84 deletions(-)

diff --git a/arch/tile/lib/memchr_64.c b/arch/tile/lib/memchr_64.c
index 6f867db..f8196b3 100644
--- a/arch/tile/lib/memchr_64.c
+++ b/arch/tile/lib/memchr_64.c
@@ -36,7 +36,7 @@ void *memchr(const void *s, int c, size_t n)
 	p = (const uint64_t *)(s_int & -8);
 
 	/* Create eight copies of the byte for which we are looking. */
-	goal = 0x0101010101010101ULL * (uint8_t) c;
+	goal = copy_byte(c);
 
 	/* Read the first word, but munge it so that bytes before the array
 	 * will not match goal.
diff --git a/arch/tile/lib/memcpy_64.c b/arch/tile/lib/memcpy_64.c
index c79b8e7..46fc160 100644
--- a/arch/tile/lib/memcpy_64.c
+++ b/arch/tile/lib/memcpy_64.c
@@ -18,14 +18,17 @@
 /* EXPORT_SYMBOL() is in arch/tile/lib/exports.c since this should be asm. */
 
 /* Must be 8 bytes in size. */
-#define word_t uint64_t
+#define op_t uint64_t
 
-#if CHIP_L2_LINE_SIZE() != 64 && CHIP_L2_LINE_SIZE() != 128
-#error "Assumes 64 or 128 byte line size"
+/* Threshold value for when to enter the unrolled loops. */
+#define	OP_T_THRES	16
+
+#if CHIP_L2_LINE_SIZE() != 64
+#error "Assumes 64 byte line size"
 #endif
 
 /* How many cache lines ahead should we prefetch? */
-#define PREFETCH_LINES_AHEAD 3
+#define PREFETCH_LINES_AHEAD 4
 
 /*
  * Provide "base versions" of load and store for the normal code path.
@@ -58,8 +61,8 @@ int USERCOPY_FUNC(void *__restrict dstv, const void *__restrict srcv, size_t n)
 	const char *__restrict src1 = (const char *)srcv;
 	const char *__restrict src1_end;
 	const char *__restrict prefetch;
-	word_t *__restrict dst8;    /* 8-byte pointer to destination memory. */
-	word_t final; /* Final bytes to write to trailing word, if any */
+	op_t *__restrict dst8;    /* 8-byte pointer to destination memory. */
+	op_t final; /* Final bytes to write to trailing word, if any */
 	long i;
 
 	if (n < 16) {
@@ -79,104 +82,228 @@ int USERCOPY_FUNC(void *__restrict dstv, const void *__restrict srcv, size_t n)
 	for (i = 0; i < PREFETCH_LINES_AHEAD; i++) {
 		__insn_prefetch(prefetch);
 		prefetch += CHIP_L2_LINE_SIZE();
-		prefetch = (prefetch > src1_end) ? prefetch : src1;
+		prefetch = (prefetch < src1_end) ? prefetch : src1;
 	}
 
 	/* Copy bytes until dst is word-aligned. */
-	for (; (uintptr_t)dst1 & (sizeof(word_t) - 1); n--)
+	for (; (uintptr_t)dst1 & (sizeof(op_t) - 1); n--)
 		ST1(dst1++, LD1(src1++));
 
 	/* 8-byte pointer to destination memory. */
-	dst8 = (word_t *)dst1;
-
-	if (__builtin_expect((uintptr_t)src1 & (sizeof(word_t) - 1), 0)) {
-		/*
-		 * Misaligned copy.  Copy 8 bytes at a time, but don't
-		 * bother with other fanciness.
-		 *
-		 * TODO: Consider prefetching and using wh64 as well.
-		 */
-
-		/* Create an aligned src8. */
-		const word_t *__restrict src8 =
-			(const word_t *)((uintptr_t)src1 & -sizeof(word_t));
-		word_t b;
-
-		word_t a = LD8(src8++);
-		for (; n >= sizeof(word_t); n -= sizeof(word_t)) {
-			b = LD8(src8++);
-			a = __insn_dblalign(a, b, src1);
-			ST8(dst8++, a);
-			a = b;
+	dst8 = (op_t *)dst1;
+
+	if (__builtin_expect((uintptr_t)src1 & (sizeof(op_t) - 1), 0)) {
+		/* Unaligned copy. */
+
+		op_t  tmp0 = 0, tmp1 = 0, tmp2, tmp3;
+		const op_t *src8 = (const op_t *) ((uintptr_t)src1 &
+						   -sizeof(op_t));
+		const void *srci = (void *)src1;
+		int m;
+
+		m = (CHIP_L2_LINE_SIZE() << 2) -
+			(((uintptr_t)dst8) & ((CHIP_L2_LINE_SIZE() << 2) - 1));
+		m = (n < m) ? n : m;
+		m /= sizeof(op_t);
+
+		/* Copy until 'dst' is cache-line-aligned. */
+		n -= (sizeof(op_t) * m);
+
+		switch (m % 4) {
+		case 0:
+			if (__builtin_expect(!m, 0))
+				goto _M0;
+			tmp1 = LD8(src8++);
+			tmp2 = LD8(src8++);
+			goto _8B3;
+		case 2:
+			m += 2;
+			tmp3 = LD8(src8++);
+			tmp0 = LD8(src8++);
+			goto _8B1;
+		case 3:
+			m += 1;
+			tmp2 = LD8(src8++);
+			tmp3 = LD8(src8++);
+			goto _8B2;
+		case 1:
+			m--;
+			tmp0 = LD8(src8++);
+			tmp1 = LD8(src8++);
+			if (__builtin_expect(!m, 0))
+				goto _8B0;
+		}
+
+		do {
+			tmp2 = LD8(src8++);
+			tmp0 =  __insn_dblalign(tmp0, tmp1, srci);
+			ST8(dst8++, tmp0);
+_8B3:
+			tmp3 = LD8(src8++);
+			tmp1 = __insn_dblalign(tmp1, tmp2, srci);
+			ST8(dst8++, tmp1);
+_8B2:
+			tmp0 = LD8(src8++);
+			tmp2 = __insn_dblalign(tmp2, tmp3, srci);
+			ST8(dst8++, tmp2);
+_8B1:
+			tmp1 = LD8(src8++);
+			tmp3 = __insn_dblalign(tmp3, tmp0, srci);
+			ST8(dst8++, tmp3);
+			m -= 4;
+		} while (m);
+
+_8B0:
+		tmp0 = __insn_dblalign(tmp0, tmp1, srci);
+		ST8(dst8++, tmp0);
+		src8--;
+
+_M0:
+		if (__builtin_expect(n >= CHIP_L2_LINE_SIZE(), 0)) {
+			op_t tmp4, tmp5, tmp6, tmp7, tmp8;
+
+			prefetch = ((const char *)src8) +
+				CHIP_L2_LINE_SIZE() * PREFETCH_LINES_AHEAD;
+
+			for (tmp0 = LD8(src8++); n >= CHIP_L2_LINE_SIZE();
+			     n -= CHIP_L2_LINE_SIZE()) {
+				/* Prefetch and advance to next line to
+				   prefetch, but don't go past the end.  */
+				__insn_prefetch(prefetch);
+
+				/* Make sure prefetch got scheduled
+				   earlier.  */
+				__asm__ ("" : : : "memory");
+
+				prefetch += CHIP_L2_LINE_SIZE();
+				prefetch = (prefetch < src1_end) ? prefetch :
+					(const char *) src8;
+
+				tmp1 = LD8(src8++);
+				tmp2 = LD8(src8++);
+				tmp3 = LD8(src8++);
+				tmp4 = LD8(src8++);
+				tmp5 = LD8(src8++);
+				tmp6 = LD8(src8++);
+				tmp7 = LD8(src8++);
+				tmp8 = LD8(src8++);
+
+				tmp0 = __insn_dblalign(tmp0, tmp1, srci);
+				tmp1 = __insn_dblalign(tmp1, tmp2, srci);
+				tmp2 = __insn_dblalign(tmp2, tmp3, srci);
+				tmp3 = __insn_dblalign(tmp3, tmp4, srci);
+				tmp4 = __insn_dblalign(tmp4, tmp5, srci);
+				tmp5 = __insn_dblalign(tmp5, tmp6, srci);
+				tmp6 = __insn_dblalign(tmp6, tmp7, srci);
+				tmp7 = __insn_dblalign(tmp7, tmp8, srci);
+
+				__insn_wh64(dst8);
+
+				ST8(dst8++, tmp0);
+				ST8(dst8++, tmp1);
+				ST8(dst8++, tmp2);
+				ST8(dst8++, tmp3);
+				ST8(dst8++, tmp4);
+				ST8(dst8++, tmp5);
+				ST8(dst8++, tmp6);
+				ST8(dst8++, tmp7);
+
+				tmp0 = tmp8;
+			}
+			src8--;
+		}
+
+		/* Copy the rest 8-byte chunks. */
+		if (n >= sizeof(op_t)) {
+			tmp0 = LD8(src8++);
+			for (; n >= sizeof(op_t); n -= sizeof(op_t)) {
+				tmp1 = LD8(src8++);
+				tmp0 = __insn_dblalign(tmp0, tmp1, srci);
+				ST8(dst8++, tmp0);
+				tmp0 = tmp1;
+			}
+			src8--;
 		}
 
 		if (n == 0)
 			return RETVAL;
 
-		b = ((const char *)src8 <= src1_end) ? *src8 : 0;
+		tmp0 = LD8(src8++);
+		tmp1 = ((const char *)src8 <= src1_end)
+			? LD8((op_t *)src8) : 0;
+		final = __insn_dblalign(tmp0, tmp1, srci);
 
-		/*
-		 * Final source bytes to write to trailing partial
-		 * word, if any.
-		 */
-		final = __insn_dblalign(a, b, src1);
 	} else {
 		/* Aligned copy. */
 
-		const word_t* __restrict src8 = (const word_t *)src1;
+		const op_t *__restrict src8 = (const op_t *)src1;
 
 		/* src8 and dst8 are both word-aligned. */
 		if (n >= CHIP_L2_LINE_SIZE()) {
 			/* Copy until 'dst' is cache-line-aligned. */
 			for (; (uintptr_t)dst8 & (CHIP_L2_LINE_SIZE() - 1);
-			     n -= sizeof(word_t))
+			     n -= sizeof(op_t))
 				ST8(dst8++, LD8(src8++));
 
 			for (; n >= CHIP_L2_LINE_SIZE(); ) {
-				__insn_wh64(dst8);
+				op_t tmp0, tmp1, tmp2, tmp3;
+				op_t tmp4, tmp5, tmp6, tmp7;
 
 				/*
 				 * Prefetch and advance to next line
-				 * to prefetch, but don't go past the end
+				 * to prefetch, but don't go past the
+				 * end.
 				 */
 				__insn_prefetch(prefetch);
+
+				/* Make sure prefetch got scheduled
+				   earlier.  */
+				__asm__ ("" : : : "memory");
+
 				prefetch += CHIP_L2_LINE_SIZE();
-				prefetch = (prefetch > src1_end) ? prefetch :
+				prefetch = (prefetch < src1_end) ? prefetch :
 					(const char *)src8;
 
 				/*
-				 * Copy an entire cache line.  Manually
-				 * unrolled to avoid idiosyncracies of
-				 * compiler unrolling.
+				 * Do all the loads before wh64.  This
+				 * is necessary if [src8, src8+7] and
+				 * [dst8, dst8+7] share the same cache
+				 * line and dst8 <= src8, as can be
+				 * the case when called from memmove,
+				 * or with code tested on x86 whose
+				 * memcpy always works with forward
+				 * copies.
 				 */
-#define COPY_WORD(offset) ({ ST8(dst8+offset, LD8(src8+offset)); n -= 8; })
-				COPY_WORD(0);
-				COPY_WORD(1);
-				COPY_WORD(2);
-				COPY_WORD(3);
-				COPY_WORD(4);
-				COPY_WORD(5);
-				COPY_WORD(6);
-				COPY_WORD(7);
-#if CHIP_L2_LINE_SIZE() == 128
-				COPY_WORD(8);
-				COPY_WORD(9);
-				COPY_WORD(10);
-				COPY_WORD(11);
-				COPY_WORD(12);
-				COPY_WORD(13);
-				COPY_WORD(14);
-				COPY_WORD(15);
-#elif CHIP_L2_LINE_SIZE() != 64
-# error Fix code that assumes particular L2 cache line sizes
-#endif
+				tmp0 = LD8(src8++);
+				tmp1 = LD8(src8++);
+				tmp2 = LD8(src8++);
+				tmp3 = LD8(src8++);
+				tmp4 = LD8(src8++);
+				tmp5 = LD8(src8++);
+				tmp6 = LD8(src8++);
+				tmp7 = LD8(src8++);
+
+				/* wh64 and wait for tmp7 load completion. */
+				__asm__ ("move %0, %0; wh64 %1\n"
+					 : : "r"(tmp7), "r"(dst8));
 
-				dst8 += CHIP_L2_LINE_SIZE() / sizeof(word_t);
-				src8 += CHIP_L2_LINE_SIZE() / sizeof(word_t);
+				ST8(dst8++, tmp0);
+				ST8(dst8++, tmp1);
+				ST8(dst8++, tmp2);
+				ST8(dst8++, tmp3);
+				ST8(dst8++, tmp4);
+				ST8(dst8++, tmp5);
+				ST8(dst8++, tmp6);
+				ST8(dst8++, tmp7);
+
+				n -= CHIP_L2_LINE_SIZE();
 			}
+#if CHIP_L2_LINE_SIZE() != 64
+# error "Fix code that assumes particular L2 cache line size."
+#endif
 		}
 
-		for (; n >= sizeof(word_t); n -= sizeof(word_t))
+		for (; n >= sizeof(op_t); n -= sizeof(op_t))
 			ST8(dst8++, LD8(src8++));
 
 		if (__builtin_expect(n == 0, 1))
diff --git a/arch/tile/lib/memset_32.c b/arch/tile/lib/memset_32.c
index 57dbb3a..9a7837d 100644
--- a/arch/tile/lib/memset_32.c
+++ b/arch/tile/lib/memset_32.c
@@ -12,13 +12,10 @@
  *   more details.
  */
 
-#include <arch/chip.h>
-
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-
-#undef memset
+#include <arch/chip.h>
 
 void *memset(void *s, int c, size_t n)
 {
diff --git a/arch/tile/lib/memset_64.c b/arch/tile/lib/memset_64.c
index 3873085..03ef69c 100644
--- a/arch/tile/lib/memset_64.c
+++ b/arch/tile/lib/memset_64.c
@@ -12,13 +12,11 @@
  *   more details.
  */
 
-#include <arch/chip.h>
-
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-
-#undef memset
+#include <arch/chip.h>
+#include "string-endian.h"
 
 void *memset(void *s, int c, size_t n)
 {
@@ -70,8 +68,7 @@ void *memset(void *s, int c, size_t n)
 	n64 = n >> 3;
 
 	/* Tile input byte out to 64 bits. */
-	/* KLUDGE */
-	v64 = 0x0101010101010101ULL * (uint8_t)c;
+	v64 = copy_byte(c);
 
 	/* This must be at least 8 or the following loop doesn't work. */
 #define CACHE_LINE_SIZE_IN_DOUBLEWORDS (CHIP_L2_LINE_SIZE() / 8)
diff --git a/arch/tile/lib/strchr_32.c b/arch/tile/lib/strchr_32.c
index c94e6f7..841fe69 100644
--- a/arch/tile/lib/strchr_32.c
+++ b/arch/tile/lib/strchr_32.c
@@ -16,8 +16,6 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
-#undef strchr
-
 char *strchr(const char *s, int c)
 {
 	int z, g;
diff --git a/arch/tile/lib/strchr_64.c b/arch/tile/lib/strchr_64.c
index f39f9dc..fe6e31c 100644
--- a/arch/tile/lib/strchr_64.c
+++ b/arch/tile/lib/strchr_64.c
@@ -26,7 +26,7 @@ char *strchr(const char *s, int c)
 	const uint64_t *p = (const uint64_t *)(s_int & -8);
 
 	/* Create eight copies of the byte for which we are looking. */
-	const uint64_t goal = 0x0101010101010101ULL * (uint8_t) c;
+	const uint64_t goal = copy_byte(c);
 
 	/* Read the first aligned word, but force bytes before the string to
 	 * match neither zero nor goal (we make sure the high bit of each
diff --git a/arch/tile/lib/string-endian.h b/arch/tile/lib/string-endian.h
index c0eed7c..2e49cbf 100644
--- a/arch/tile/lib/string-endian.h
+++ b/arch/tile/lib/string-endian.h
@@ -1,5 +1,5 @@
 /*
- * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
  *
  *   This program is free software; you can redistribute it and/or
  *   modify it under the terms of the GNU General Public License
@@ -31,3 +31,14 @@
 #define CFZ(x) __insn_clz(x)
 #define REVCZ(x) __insn_ctz(x)
 #endif
+
+/*
+ * Create eight copies of the byte in a uint64_t.  Byte Shuffle uses
+ * the bytes of srcB as the index into the dest vector to select a
+ * byte.  With all indices of zero, the first byte is copied into all
+ * the other bytes.
+ */
+static inline uint64_t copy_byte(uint8_t byte)
+{
+	return __insn_shufflebytes(byte, 0, 0);
+}
diff --git a/arch/tile/lib/strlen_32.c b/arch/tile/lib/strlen_32.c
index 4974292..f26f88e 100644
--- a/arch/tile/lib/strlen_32.c
+++ b/arch/tile/lib/strlen_32.c
@@ -16,8 +16,6 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
-#undef strlen
-
 size_t strlen(const char *s)
 {
 	/* Get an aligned pointer. */
-- 
1.8.3.1

