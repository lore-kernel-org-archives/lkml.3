Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaEHOEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:04:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:43886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaEHOAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:49 -0400
Message-Id: <20140508135852.605324173@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH 14/20] arch,mn10300: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-mn10300-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/mn10300/include/asm/atomic.h |  129 ++++++++++++--------------------------
 1 file changed, 44 insertions(+), 85 deletions(-)

Index: linux-2.6/arch/mn10300/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/mn10300/include/asm/atomic.h
+++ linux-2.6/arch/mn10300/include/asm/atomic.h
@@ -33,7 +33,6 @@
  * @v: pointer of type atomic_t
  *
  * Atomically reads the value of @v.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
  */
 #define atomic_read(v)	(ACCESS_ONCE((v)->counter))
 
@@ -43,100 +42,60 @@
  * @i: required value
  *
  * Atomically sets the value of @v to @i.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
  */
 #define atomic_set(v, i) (((v)->counter) = (i))
 
-/**
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int retval;
-#ifdef CONFIG_SMP
-	int status;
-
-	asm volatile(
-		"1:	mov	%4,(_AAR,%3)	\n"
-		"	mov	(_ADR,%3),%1	\n"
-		"	add	%5,%1		\n"
-		"	mov	%1,(_ADR,%3)	\n"
-		"	mov	(_ADR,%3),%0	\n"	/* flush */
-		"	mov	(_ASR,%3),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=&r"(retval), "=m"(v->counter)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)
-		: "memory", "cc");
-
-#else
-	unsigned long flags;
-
-	flags = arch_local_cli_save();
-	retval = v->counter;
-	retval += i;
-	v->counter = retval;
-	arch_local_irq_restore(flags);
-#endif
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int retval, status;						\
+									\
+	asm volatile(							\
+		"1:	mov	%4,(_AAR,%3)	\n"			\
+		"	mov	(_ADR,%3),%1	\n"			\
+		"	" #op "	%5,%1		\n"			\
+		"	mov	%1,(_ADR,%3)	\n"			\
+		"	mov	(_ADR,%3),%0	\n"	/* flush */	\
+		"	mov	(_ASR,%3),%0	\n"			\
+		"	or	%0,%0		\n"			\
+		"	bne	1b		\n"			\
+		: "=&r"(status), "=&r"(retval), "=m"(v->counter)	\
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)	\
+		: "memory", "cc");					\
+}									\
+
+#define ATOMIC_OP_RETURN(op)						\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int retval, status;						\
+									\
+	asm volatile(							\
+		"1:	mov	%4,(_AAR,%3)	\n"			\
+		"	mov	(_ADR,%3),%1	\n"			\
+		"	" #op "	%5,%1		\n"			\
+		"	mov	%1,(_ADR,%3)	\n"			\
+		"	mov	(_ADR,%3),%0	\n"	/* flush */	\
+		"	mov	(_ASR,%3),%0	\n"			\
+		"	or	%0,%0		\n"			\
+		"	bne	1b		\n"			\
+		: "=&r"(status), "=&r"(retval), "=m"(v->counter)	\
+		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)	\
+		: "memory", "cc");					\
 	return retval;
 }
 
-/**
- * atomic_sub_return - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int retval;
-#ifdef CONFIG_SMP
-	int status;
-
-	asm volatile(
-		"1:	mov	%4,(_AAR,%3)	\n"
-		"	mov	(_ADR,%3),%1	\n"
-		"	sub	%5,%1		\n"
-		"	mov	%1,(_ADR,%3)	\n"
-		"	mov	(_ADR,%3),%0	\n"	/* flush */
-		"	mov	(_ASR,%3),%0	\n"
-		"	or	%0,%0		\n"
-		"	bne	1b		\n"
-		: "=&r"(status), "=&r"(retval), "=m"(v->counter)
-		: "a"(ATOMIC_OPS_BASE_ADDR), "r"(&v->counter), "r"(i)
-		: "memory", "cc");
-
-#else
-	unsigned long flags;
-	flags = arch_local_cli_save();
-	retval = v->counter;
-	retval -= i;
-	v->counter = retval;
-	arch_local_irq_restore(flags);
-#endif
-	return retval;
-}
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-static inline int atomic_add_negative(int i, atomic_t *v)
-{
-	return atomic_add_return(i, v) < 0;
-}
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	atomic_add_return(i, v);
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-static inline void atomic_sub(int i, atomic_t *v)
+static inline int atomic_add_negative(int i, atomic_t *v)
 {
-	atomic_sub_return(i, v);
+	return atomic_add_return(i, v) < 0;
 }
 
 static inline void atomic_inc(atomic_t *v)


