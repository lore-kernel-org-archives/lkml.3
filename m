Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaEHOA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:00:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47518 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaEHOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:52 -0400
Message-Id: <20140508135852.659342353@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH 15/20] arch,parisc: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-parisc-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, no LoC saved in this case because sub was defined in terms of add.
Still do it because this also prepares for easy addition of new ops.

Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/parisc/include/asm/atomic.h |  121 +++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 48 deletions(-)

Index: linux-2.6/arch/parisc/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/atomic.h
+++ linux-2.6/arch/parisc/include/asm/atomic.h
@@ -55,24 +55,7 @@ extern arch_spinlock_t __atomic_hash[ATO
  * are atomic, so a reader never sees inconsistent values.
  */
 
-/* It's possible to reduce all atomic operations to either
- * __atomic_add_return, atomic_set and atomic_read (the latter
- * is there only for consistency).
- */
-
-static __inline__ int __atomic_add_return(int i, atomic_t *v)
-{
-	int ret;
-	unsigned long flags;
-	_atomic_spin_lock_irqsave(v, flags);
-
-	ret = (v->counter += i);
-
-	_atomic_spin_unlock_irqrestore(v, flags);
-	return ret;
-}
-
-static __inline__ void atomic_set(atomic_t *v, int i) 
+static __inline__ void atomic_set(atomic_t *v, int i)
 {
 	unsigned long flags;
 	_atomic_spin_lock_irqsave(v, flags);
@@ -115,16 +98,43 @@ static __inline__ int __atomic_add_unles
 	return c;
 }
 
+#define ATOMIC_OP(op, c_op)						\
+static __inline__ void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	v->counter c_op i;						\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static __inline__ int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long flags;						\
+	int ret;							\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	ret = (v->counter c_op i);					\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+									\
+	return ret;							\
+}
+
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
+
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-#define atomic_add(i,v)	((void)(__atomic_add_return(        (i),(v))))
-#define atomic_sub(i,v)	((void)(__atomic_add_return(-((int) (i)),(v))))
-#define atomic_inc(v)	((void)(__atomic_add_return(   1,(v))))
-#define atomic_dec(v)	((void)(__atomic_add_return(  -1,(v))))
-
-#define atomic_add_return(i,v)	(__atomic_add_return( (i),(v)))
-#define atomic_sub_return(i,v)	(__atomic_add_return(-(i),(v)))
-#define atomic_inc_return(v)	(__atomic_add_return(   1,(v)))
-#define atomic_dec_return(v)	(__atomic_add_return(  -1,(v)))
+#define atomic_inc(v)	(atomic_add(   1,(v)))
+#define atomic_dec(v)	(atomic_add(  -1,(v)))
+
+#define atomic_inc_return(v)	(atomic_add_return(   1,(v)))
+#define atomic_dec_return(v)	(atomic_add_return(  -1,(v)))
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
@@ -148,18 +158,37 @@ static __inline__ int __atomic_add_unles
 
 #define ATOMIC64_INIT(i) { (i) }
 
-static __inline__ s64
-__atomic64_add_return(s64 i, atomic64_t *v)
-{
-	s64 ret;
-	unsigned long flags;
-	_atomic_spin_lock_irqsave(v, flags);
-
-	ret = (v->counter += i);
-
-	_atomic_spin_unlock_irqrestore(v, flags);
-	return ret;
-}
+#define ATOMIC64_OP(op, c_op)						\
+static __inline__ void atomic64_##op(s64 i, atomic64_t *v)		\
+{									\
+	unsigned long flags;						\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	v->counter c_op i;						\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+}									\
+
+#define ATOMIC64_OP_RETURN(op, c_op)					\
+static __inline__ s64 atomic64_##op##_return(s64 i, atomic64_t *v)	\
+{									\
+	unsigned long flags;						\
+	s64 ret;							\
+									\
+	_atomic_spin_lock_irqsave(v, flags);				\
+	ret = (v->counter c_op i);					\
+	_atomic_spin_unlock_irqrestore(v, flags);			\
+									\
+	return ret;							\
+}
+
+#define ATOMIC64_OPS(op, c_op) ATOMIC64_OP(op, c_op) ATOMIC64_OP_RETURN(op, c_op)
+
+ATOMIC64_OPS(add, +=)
+ATOMIC64_OPS(sub, -=)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 static __inline__ void
 atomic64_set(atomic64_t *v, s64 i)
@@ -178,15 +207,11 @@ atomic64_read(const atomic64_t *v)
 	return (*(volatile long *)&(v)->counter);
 }
 
-#define atomic64_add(i,v)	((void)(__atomic64_add_return( ((s64)(i)),(v))))
-#define atomic64_sub(i,v)	((void)(__atomic64_add_return(-((s64)(i)),(v))))
-#define atomic64_inc(v)		((void)(__atomic64_add_return(   1,(v))))
-#define atomic64_dec(v)		((void)(__atomic64_add_return(  -1,(v))))
-
-#define atomic64_add_return(i,v)	(__atomic64_add_return( ((s64)(i)),(v)))
-#define atomic64_sub_return(i,v)	(__atomic64_add_return(-((s64)(i)),(v)))
-#define atomic64_inc_return(v)		(__atomic64_add_return(   1,(v)))
-#define atomic64_dec_return(v)		(__atomic64_add_return(  -1,(v)))
+#define atomic64_inc(v)		(atomic64_add(   1,(v)))
+#define atomic64_dec(v)		(atomic64_add(  -1,(v)))
+
+#define atomic64_inc_return(v)		(atomic64_add_return(   1,(v)))
+#define atomic64_dec_return(v)		(atomic64_add_return(  -1,(v)))
 
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 


