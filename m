Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaCSG5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:57:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53012 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbaCSG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:32 -0400
Message-Id: <20140319065205.163413133@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 26/31] arch,sparc: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-sparc-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc32: fully relies on asm-generic/barrier.h and thus can use its
	 implementation.

sparc64: is strongly ordered and its atomic ops imply a full barrier,
	 implement the new primitives using barrier().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/sparc/include/asm/atomic_32.h  |    7 +------
 arch/sparc/include/asm/atomic_64.h  |    7 +------
 arch/sparc/include/asm/barrier_64.h |    3 +++
 arch/sparc/include/asm/bitops_32.h  |    3 ---
 arch/sparc/include/asm/bitops_64.h  |    4 +---
 5 files changed, 6 insertions(+), 18 deletions(-)

--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 #include <asm-generic/atomic64.h>
 
 
@@ -52,10 +53,4 @@ extern void atomic_set(atomic_t *, int);
 #define atomic_dec_and_test(v) (atomic_dec_return(v) == 0)
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* !(__ARCH_SPARC_ATOMIC__) */
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
@@ -108,10 +109,4 @@ static inline long atomic64_add_unless(a
 
 extern long atomic64_dec_if_positive(atomic64_t *v);
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* !(__ARCH_SPARC64_ATOMIC__) */
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -68,4 +68,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 #endif /* !(__SPARC64_BARRIER_H) */
--- a/arch/sparc/include/asm/bitops_32.h
+++ b/arch/sparc/include/asm/bitops_32.h
@@ -90,9 +90,6 @@ static inline void change_bit(unsigned l
 
 #include <asm-generic/bitops/non-atomic.h>
 
-#define smp_mb__before_clear_bit()	do { } while(0)
-#define smp_mb__after_clear_bit()	do { } while(0)
-
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/sched.h>
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -13,6 +13,7 @@
 
 #include <linux/compiler.h>
 #include <asm/byteorder.h>
+#include <asm/barrier.h>
 
 extern int test_and_set_bit(unsigned long nr, volatile unsigned long *addr);
 extern int test_and_clear_bit(unsigned long nr, volatile unsigned long *addr);
@@ -23,9 +24,6 @@ extern void change_bit(unsigned long nr,
 
 #include <asm-generic/bitops/non-atomic.h>
 
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>


