Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbaCSG4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:56:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbaCSG40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:26 -0400
Message-Id: <20140319065203.943810764@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 03/31] arch: Prepare for smp_mb__{before,after}_atomic()
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-arch-smp_mb__generic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the smp_mb__{before,after}*() ops are fundamentally dependent on
how an arch can implement atomics it doesn't make sense to have 3
variants of them. They must all be the same.

Furthermore, the 3 variants suggest they're only valid for those 3
atomic ops, while we have many more where they could be applied.

So move away from
smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}() and reduce the
interface to just the two: smp_mb__{before,after}_atomic().

This patch prepares the way by introducing default implementations in
asm-generic/barrier.h that default to a full barrier and providing
__deprecated inlines for the previous 6 barriers if they're not
provided by the arch.

This should allow for a mostly painless transition (lots of deprecated
warns in the interim).

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/atomic.h  |    7 +------
 include/asm-generic/barrier.h |    8 ++++++++
 include/asm-generic/bitops.h  |    9 +--------
 include/linux/atomic.h        |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/bitops.h        |   20 ++++++++++++++++++++
 kernel/sched/core.c           |   16 ++++++++++++++++
 6 files changed, 82 insertions(+), 14 deletions(-)

--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -16,6 +16,7 @@
 #define __ASM_GENERIC_ATOMIC_H
 
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #ifdef CONFIG_SMP
 /* Force people to define core atomics */
@@ -182,11 +183,5 @@ static inline void atomic_set_mask(unsig
 }
 #endif
 
-/* Assume that atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_ATOMIC_H */
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -62,6 +62,14 @@
 #define set_mb(var, value)  do { (var) = (value); mb(); } while (0)
 #endif
 
+#ifndef smp_mb__before_atomic
+#define smp_mb__before_atomic()	smp_mb()
+#endif
+
+#ifndef smp_mb__after_atomic
+#define smp_mb__after_atomic()	smp_mb()
+#endif
+
 #define smp_store_release(p, v)						\
 do {									\
 	compiletime_assert_atomic_type(*p);				\
--- a/include/asm-generic/bitops.h
+++ b/include/asm-generic/bitops.h
@@ -11,14 +11,7 @@
 
 #include <linux/irqflags.h>
 #include <linux/compiler.h>
-
-/*
- * clear_bit may not imply a memory barrier
- */
-#ifndef smp_mb__before_clear_bit
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-#endif
+#include <asm/barrier.h>
 
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/ffz.h>
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -3,6 +3,42 @@
 #define _LINUX_ATOMIC_H
 #include <asm/atomic.h>
 
+/*
+ * Provide __deprecated wrappers for the new interface, avoid flag day changes.
+ * We need the ugly external functions to break header recursion hell.
+ */
+#ifndef smp_mb__before_atomic_inc
+static inline void __deprecated smp_mb__before_atomic_inc(void)
+{
+	extern void __smp_mb__before_atomic(void);
+	__smp_mb__before_atomic();
+}
+#endif
+
+#ifndef smp_mb__after_atomic_inc
+static inline void __deprecated smp_mb__after_atomic_inc(void)
+{
+	extern void __smp_mb__after_atomic(void);
+	__smp_mb__after_atomic();
+}
+#endif
+
+#ifndef smp_mb__before_atomic_dec
+static inline void __deprecated smp_mb__before_atomic_dec(void)
+{
+	extern void __smp_mb__before_atomic(void);
+	__smp_mb__before_atomic();
+}
+#endif
+
+#ifndef smp_mb__after_atomic_dec
+static inline void __deprecated smp_mb__after_atomic_dec(void)
+{
+	extern void __smp_mb__after_atomic(void);
+	__smp_mb__after_atomic();
+}
+#endif
+
 /**
  * atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -32,6 +32,26 @@ extern unsigned long __sw_hweight64(__u6
  */
 #include <asm/bitops.h>
 
+/*
+ * Provide __deprecated wrappers for the new interface, avoid flag day changes.
+ * We need the ugly external functions to break header recursion hell.
+ */
+#ifndef smp_mb__before_clear_bit
+static inline void __deprecated smp_mb__before_clear_bit(void)
+{
+	extern void __smp_mb__before_atomic(void);
+	__smp_mb__before_atomic();
+}
+#endif
+
+#ifndef smp_mb__after_clear_bit
+static inline void __deprecated smp_mb__after_clear_bit(void)
+{
+	extern void __smp_mb__after_atomic(void);
+	__smp_mb__after_atomic();
+}
+#endif
+
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
 	     (bit) < (size);					\
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -89,6 +89,22 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
+#ifdef smp_mb__before_atomic
+void __smp_mb__before_atomic(void)
+{
+	smp_mb__before_atomic();
+}
+EXPORT_SYMBOL(__smp_mb__before_atomic);
+#endif
+
+#ifdef smp_mb__after_atomic
+void __smp_mb__after_atomic(void)
+{
+	smp_mb__after_atomic();
+}
+EXPORT_SYMBOL(__smp_mb__after_atomic);
+#endif
+
 void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;


