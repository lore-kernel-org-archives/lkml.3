Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaEHOAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:00:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:43810 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaEHOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:44 -0400
Message-Id: <20140508135851.886055622@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 03/20] arch,arc: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-arc-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arc/include/asm/atomic.h |  194 ++++++++++++++----------------------------
 1 file changed, 68 insertions(+), 126 deletions(-)

--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -25,79 +25,36 @@
 
 #define atomic_set(v, i) (((v)->counter) = (i))
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	add     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)	/* Early clobber, to prevent reg reuse */
-	: "r"(&v->counter), "ir"(i)
-	: "cc");
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	sub     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(&v->counter), "ir"(i)
-	: "cc");
-}
-
-/* add and also return the new value */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	add     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(&v->counter), "ir"(i)
-	: "cc");
-
-	return temp;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	sub     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(&v->counter), "ir"(i)
-	: "cc");
-
-	return temp;
-}
-
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned int temp;
-
-	__asm__ __volatile__(
-	"1:	llock   %0, [%1]	\n"
-	"	bic     %0, %0, %2	\n"
-	"	scond   %0, [%1]	\n"
-	"	bnz     1b		\n"
-	: "=&r"(temp)
-	: "r"(addr), "ir"(mask)
-	: "cc");
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned int temp;						\
+									\
+	__asm__ __volatile__(						\
+	"1:	llock   %0, [%1]	\n"				\
+	"	" #asm_op " %0, %0, %2	\n"				\
+	"	scond   %0, [%1]	\n"				\
+	"	bnz     1b		\n"				\
+	: "=&r"(temp)	/* Early clobber, to prevent reg reuse */	\
+	: "r"(&v->counter), "ir"(i)					\
+	: "cc");							\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned int temp;						\
+									\
+	__asm__ __volatile__(						\
+	"1:	llock   %0, [%1]	\n"				\
+	"	" #asm_op " %0, %0, %2	\n"				\
+	"	scond   %0, [%1]	\n"				\
+	"	bnz     1b		\n"				\
+	: "=&r"(temp)							\
+	: "r"(&v->counter), "ir"(i)					\
+	: "cc");							\
+									\
+	return temp;							\
 }
 
 #else	/* !CONFIG_ARC_HAS_LLSC */
@@ -126,6 +83,7 @@ static inline void atomic_set(atomic_t *
 	v->counter = i;
 	atomic_ops_unlock(flags);
 }
+
 #endif
 
 /*
@@ -133,63 +91,47 @@ static inline void atomic_set(atomic_t *
  * Locking would change to irq-disabling only (UP) and spinlocks (SMP)
  */
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	atomic_ops_lock(flags);
-	v->counter += i;
-	atomic_ops_unlock(flags);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	atomic_ops_lock(flags);
-	v->counter -= i;
-	atomic_ops_unlock(flags);
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	unsigned long temp;
-
-	atomic_ops_lock(flags);
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	atomic_ops_unlock(flags);
-
-	return temp;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	unsigned long temp;
-
-	atomic_ops_lock(flags);
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	atomic_ops_unlock(flags);
-
-	return temp;
-}
-
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned long flags;
-
-	atomic_ops_lock(flags);
-	*addr &= ~mask;
-	atomic_ops_unlock(flags);
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	atomic_ops_lock(flags);						\
+	v->counter c_op i;						\
+	atomic_ops_unlock(flags);					\
+}
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	unsigned long temp;						\
+									\
+	atomic_ops_lock(flags);						\
+	temp = v->counter;						\
+	temp c_op i;							\
+	v->counter = temp;						\
+	atomic_ops_unlock(flags);					\
+									\
+	return temp;							\
 }
 
 #endif /* !CONFIG_ARC_HAS_LLSC */
 
+#define ATOMIC_OPS(op, c_op, asm_op)					\
+	ATOMIC_OP(op, c_op, asm_op)					\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
+
+ATOMIC_OPS(add, +=, add)
+ATOMIC_OPS(sub, -=, sub)
+ATOMIC_OP(and, &=, and)
+
+#define atomic_clear_mask(mask, v) atomic_and(~(mask), (v))
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
 /**
  * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t


