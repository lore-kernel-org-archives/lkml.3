Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaEHOAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:00:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:43825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaEHOAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:44 -0400
Message-Id: <20140508135852.387473090@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 11/20] arch,m68k: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-m68k-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Requires asm_op due to eor.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/m68k/include/asm/atomic.h |  119 ++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 64 deletions(-)

Index: linux-2.6/arch/m68k/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/atomic.h
+++ linux-2.6/arch/m68k/include/asm/atomic.h
@@ -30,15 +30,62 @@
 #define	ASM_DI	"di"
 #endif
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	__asm__ __volatile__("addl %1,%0" : "+m" (*v) : ASM_DI (i));
-}
+#ifdef CONFIG_RMW_INSNS
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	__asm__ __volatile__("subl %1,%0" : "+m" (*v) : ASM_DI (i));
-}
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	__asm__ __volatile__(#asm_op "l %1,%0" : "+m" (*v) : ASM_DI (i));\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int t, tmp;							\
+									\
+	__asm__ __volatile__(						\
+			"1:	movel %2,%1\n"				\
+			"	" #asm_op "l %3,%1\n"			\
+			"	casl %2,%1,%0\n"			\
+			"	jne 1b"					\
+			: "+m" (*v), "=&d" (t), "=&d" (tmp)		\
+			: "g" (i), "2" (atomic_read(v)));		\
+	return t;							\
+}
+
+#else
+
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	__asm__ __volatile__(#asm_op "l %1,%0" : "+m" (*v) : ASM_DI (i));\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t * v)		\
+{									\
+	unsigned long flags;						\
+	int t;								\
+									\
+	local_irq_save(flags);						\
+	t = (v->counter c_op i);					\
+	local_irq_restore(flags);					\
+									\
+	return t;							\
+}
+
+#endif /* CONFIG_RMW_INSNS */
+
+#define ATOMIC_OPS(op, c_op, asm_op)					\
+	ATOMIC_OP(op, c_op, asm_op)					\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
+
+ATOMIC_OPS(add, +=, add)
+ATOMIC_OPS(sub, -=, sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_inc(atomic_t *v)
 {
@@ -76,67 +123,11 @@ static inline int atomic_inc_and_test(at
 
 #ifdef CONFIG_RMW_INSNS
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int t, tmp;
-
-	__asm__ __volatile__(
-			"1:	movel %2,%1\n"
-			"	addl %3,%1\n"
-			"	casl %2,%1,%0\n"
-			"	jne 1b"
-			: "+m" (*v), "=&d" (t), "=&d" (tmp)
-			: "g" (i), "2" (atomic_read(v)));
-	return t;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int t, tmp;
-
-	__asm__ __volatile__(
-			"1:	movel %2,%1\n"
-			"	subl %3,%1\n"
-			"	casl %2,%1,%0\n"
-			"	jne 1b"
-			: "+m" (*v), "=&d" (t), "=&d" (tmp)
-			: "g" (i), "2" (atomic_read(v)));
-	return t;
-}
-
 #define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 #else /* !CONFIG_RMW_INSNS */
 
-static inline int atomic_add_return(int i, atomic_t * v)
-{
-	unsigned long flags;
-	int t;
-
-	local_irq_save(flags);
-	t = atomic_read(v);
-	t += i;
-	atomic_set(v, t);
-	local_irq_restore(flags);
-
-	return t;
-}
-
-static inline int atomic_sub_return(int i, atomic_t * v)
-{
-	unsigned long flags;
-	int t;
-
-	local_irq_save(flags);
-	t = atomic_read(v);
-	t -= i;
-	atomic_set(v, t);
-	local_irq_restore(flags);
-
-	return t;
-}
-
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	unsigned long flags;


