Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbaCSG5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:57:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53006 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773AbaCSG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:31 -0400
Message-Id: <20140319065205.215604416@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 27/31] arch,tile: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-tile-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the new smp_mb__* ops as per the old ones.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/tile/include/asm/atomic_32.h |   10 ----------
 arch/tile/include/asm/atomic_64.h |    6 ------
 arch/tile/include/asm/barrier.h   |   14 ++++++++++++++
 arch/tile/include/asm/bitops.h    |    1 +
 arch/tile/include/asm/bitops_32.h |    8 ++------
 arch/tile/include/asm/bitops_64.h |    4 ----
 6 files changed, 17 insertions(+), 26 deletions(-)

--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -169,16 +169,6 @@ static inline void atomic64_set(atomic64
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
 
-/*
- * We need to barrier before modifying the word, since the _atomic_xxx()
- * routines just tns the lock and then read/modify/write of the word.
- * But after the word is updated, the routine issues an "mf" before returning,
- * and since it's a function call, we don't even need a compiler barrier.
- */
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_dec()	do { } while (0)
-#define smp_mb__after_atomic_inc()	do { } while (0)
 
 #endif /* !__ASSEMBLY__ */
 
--- a/arch/tile/include/asm/atomic_64.h
+++ b/arch/tile/include/asm/atomic_64.h
@@ -105,12 +105,6 @@ static inline long atomic64_add_unless(a
 
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
 
-/* Atomic dec and inc don't implement barrier, so provide them if needed. */
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 /* Define this to indicate that cmpxchg is an efficient operation. */
 #define __HAVE_ARCH_CMPXCHG
 
--- a/arch/tile/include/asm/barrier.h
+++ b/arch/tile/include/asm/barrier.h
@@ -72,6 +72,20 @@ mb_incoherent(void)
 #define mb()		fast_mb()
 #define iob()		fast_iob()
 
+#ifndef __tilegx__ /* 32 bit */
+/*
+ * We need to barrier before modifying the word, since the _atomic_xxx()
+ * routines just tns the lock and then read/modify/write of the word.
+ * But after the word is updated, the routine issues an "mf" before returning,
+ * and since it's a function call, we don't even need a compiler barrier.
+ */
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	do { } while (0)
+#else /* 64 bit */
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	smp_mb()
+#endif
+
 #include <asm-generic/barrier.h>
 
 #endif /* !__ASSEMBLY__ */
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -17,6 +17,7 @@
 #define _ASM_TILE_BITOPS_H
 
 #include <linux/types.h>
+#include <asm/barrier.h>
 
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
--- a/arch/tile/include/asm/bitops_32.h
+++ b/arch/tile/include/asm/bitops_32.h
@@ -49,8 +49,8 @@ static inline void set_bit(unsigned nr,
  * restricted to acting on a single-word quantity.
  *
  * clear_bit() may not contain a memory barrier, so if it is used for
- * locking purposes, you should call smp_mb__before_clear_bit() and/or
- * smp_mb__after_clear_bit() to ensure changes are visible on other cpus.
+ * locking purposes, you should call smp_mb__before_atomic() and/or
+ * smp_mb__after_atomic() to ensure changes are visible on other cpus.
  */
 static inline void clear_bit(unsigned nr, volatile unsigned long *addr)
 {
@@ -121,10 +121,6 @@ static inline int test_and_change_bit(un
 	return (_atomic_xor(addr, mask) & mask) != 0;
 }
 
-/* See discussion at smp_mb__before_atomic_dec() in <asm/atomic_32.h>. */
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	do {} while (0)
-
 #include <asm-generic/bitops/ext2-atomic.h>
 
 #endif /* _ASM_TILE_BITOPS_32_H */
--- a/arch/tile/include/asm/bitops_64.h
+++ b/arch/tile/include/asm/bitops_64.h
@@ -32,10 +32,6 @@ static inline void clear_bit(unsigned nr
 	__insn_fetchand((void *)(addr + nr / BITS_PER_LONG), ~mask);
 }
 
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-
-
 static inline void change_bit(unsigned nr, volatile unsigned long *addr)
 {
 	unsigned long mask = (1UL << (nr % BITS_PER_LONG));


