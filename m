Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaEHOGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:06:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:43837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaEHOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:45 -0400
Message-Id: <20140508135852.940119622@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:59:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 20/20] arch: Rewrite generic atomic support
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-generic-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite generic atomic support to only require cmpxchg(), generate all
other primitives from that.

Furthermore reduce the endless repetition for all these primitives to
a few CPP macros. This way we get more for less lines.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/atomic.h   |  174 ++++++++++++++++++-----------------------
 include/asm-generic/atomic64.h |   20 +++-
 lib/atomic64.c                 |   83 ++++++++-----------
 3 files changed, 130 insertions(+), 147 deletions(-)

--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -19,13 +19,81 @@
 #include <asm/barrier.h>
 
 #ifdef CONFIG_SMP
-/* Force people to define core atomics */
-# if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
-     !defined(atomic_clear_mask) || !defined(atomic_set_mask)
-#  error "SMP requires a little arch-specific magic"
-# endif
+
+/* we can build all atomic primitives from cmpxchg */
+
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int c, old;							\
+									\
+	c = v->counter;							\
+	while ((old = cmpxchg(&v->counter, c, c c_op i)) != c)		\
+		c = old;						\
+}
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int c, old;							\
+									\
+	c = v->counter;							\
+	while ((old = cmpxchg(&v->counter, c, c c_op i)) != c)		\
+		c = old;						\
+									\
+	return c c_op i;						\
+}
+
+#else
+
+#include <linux/irqflags.h>
+
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter c_op i;						\
+	raw_local_irq_restore(flags);					\
+}
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int ret;							\
+									\
+	raw_local_irq_save(flags);					\
+	ret = (v->counter c_op i);					\
+	raw_local_irq_restore(flags);					\
+									\
+	return ret;							\
+}
+
+#endif /* CONFIG_SMP */
+
+#ifndef atomic_add_return
+ATOMIC_OP_RETURN(add, +)
+#endif
+
+#ifndef atomic_sub_return
+ATOMIC_OP_RETURN(sub, -)
+#endif
+
+#ifndef atomic_clear_mask
+ATOMIC_OP(and, &)
+#define atomic_clear_mask(i, v) atomic_and(~(i), (v))
+#endif
+
+#ifndef atomic_set_mask
+ATOMIC_OP(or, |)
+#define atomic_set_mask(i, v)	atomic_or((i), (v))
 #endif
 
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
@@ -33,8 +101,6 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#ifdef __KERNEL__
-
 /**
  * atomic_read - read atomic variable
  * @v: pointer of type atomic_t
@@ -56,52 +122,6 @@
 
 #include <linux/irqflags.h>
 
-/**
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns the result
- */
-#ifndef atomic_add_return
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int temp;
-
-	raw_local_irq_save(flags); /* Don't trace it in an irqsoff handler */
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
-
-	return temp;
-}
-#endif
-
-/**
- * atomic_sub_return - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns the result
- */
-#ifndef atomic_sub_return
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int temp;
-
-	raw_local_irq_save(flags); /* Don't trace it in an irqsoff handler */
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
-
-	return temp;
-}
-#endif
-
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
 	return atomic_add_return(i, v) < 0;
@@ -139,49 +159,11 @@ static inline void atomic_dec(atomic_t *
 
 static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
-  int c, old;
-  c = atomic_read(v);
-  while (c != u && (old = atomic_cmpxchg(v, c, c + a)) != c)
-    c = old;
-  return c;
-}
-
-/**
- * atomic_clear_mask - Atomically clear bits in atomic variable
- * @mask: Mask of the bits to be cleared
- * @v: pointer of type atomic_t
- *
- * Atomically clears the bits set in @mask from @v
- */
-#ifndef atomic_clear_mask
-static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	mask = ~mask;
-	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
-	v->counter &= mask;
-	raw_local_irq_restore(flags);
-}
-#endif
-
-/**
- * atomic_set_mask - Atomically set bits in atomic variable
- * @mask: Mask of the bits to be set
- * @v: pointer of type atomic_t
- *
- * Atomically sets the bits set in @mask in @v
- */
-#ifndef atomic_set_mask
-static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
-	v->counter |= mask;
-	raw_local_irq_restore(flags);
+	int c, old;
+	c = atomic_read(v);
+	while (c != u && (old = atomic_cmpxchg(v, c, c + a)) != c)
+		c = old;
+	return c;
 }
-#endif
 
-#endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_ATOMIC_H */
--- a/include/asm-generic/atomic64.h
+++ b/include/asm-generic/atomic64.h
@@ -20,10 +20,22 @@ typedef struct {
 
 extern long long atomic64_read(const atomic64_t *v);
 extern void	 atomic64_set(atomic64_t *v, long long i);
-extern void	 atomic64_add(long long a, atomic64_t *v);
-extern long long atomic64_add_return(long long a, atomic64_t *v);
-extern void	 atomic64_sub(long long a, atomic64_t *v);
-extern long long atomic64_sub_return(long long a, atomic64_t *v);
+
+#define ATOMIC64_OP(op)							\
+extern void	 atomic64_##op(long long a, atomic64_t *v);
+
+#define ATOMIC64_OP_RETURN(op)						\
+extern long long atomic64_##op##_return(long long a, atomic64_t *v);
+
+#define ATOMIC64_OPS(op)	ATOMIC64_OP(op) ATOMIC_OP_RETURN(op)
+
+ATOMIC64_OPS(add)
+ATOMIC64_OPS(sub)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
+
 extern long long atomic64_dec_if_positive(atomic64_t *v);
 extern long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n);
 extern long long atomic64_xchg(atomic64_t *v, long long new);
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -70,53 +70,42 @@ void atomic64_set(atomic64_t *v, long lo
 }
 EXPORT_SYMBOL(atomic64_set);
 
-void atomic64_add(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-
-	raw_spin_lock_irqsave(lock, flags);
-	v->counter += a;
-	raw_spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_add);
-
-long long atomic64_add_return(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	raw_spin_lock_irqsave(lock, flags);
-	val = v->counter += a;
-	raw_spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_add_return);
-
-void atomic64_sub(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-
-	raw_spin_lock_irqsave(lock, flags);
-	v->counter -= a;
-	raw_spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(atomic64_sub);
-
-long long atomic64_sub_return(long long a, atomic64_t *v)
-{
-	unsigned long flags;
-	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
-
-	raw_spin_lock_irqsave(lock, flags);
-	val = v->counter -= a;
-	raw_spin_unlock_irqrestore(lock, flags);
-	return val;
-}
-EXPORT_SYMBOL(atomic64_sub_return);
+#define ATOMIC64_OP(op, c_op)						\
+void atomic64_##op(long long a, atomic64_t *v)				\
+{									\
+	unsigned long flags;						\
+	raw_spinlock_t *lock = lock_addr(v);				\
+									\
+	raw_spin_lock_irqsave(lock, flags);				\
+	v->counter c_op a;						\
+	raw_spin_unlock_irqrestore(lock, flags);			\
+}									\
+EXPORT_SYMBOL(atomic64_##op);
+
+#define ATOMIC64_OP_RETURN(op, c_op)					\
+long long atomic64_##op##_return(long long a, atomic64_t *v)		\
+{									\
+	unsigned long flags;						\
+	raw_spinlock_t *lock = lock_addr(v);				\
+	long long val;							\
+									\
+	raw_spin_lock_irqsave(lock, flags);				\
+	val = (v->counter c_op a);					\
+	raw_spin_unlock_irqrestore(lock, flags);			\
+	return val;							\
+}									\
+EXPORT_SYMBOL(atomic64_##op##_return);
+
+#define ATOMIC64_OPS(op, c_op)						\
+	ATOMIC64_OP(op, c_op)						\
+	ATOMIC64_OP_RETURN(op, c_op)
+
+ATOMIC64_OPS(add, +=)
+ATOMIC64_OPS(sub, -=)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 long long atomic64_dec_if_positive(atomic64_t *v)
 {


