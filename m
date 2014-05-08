Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaEHOFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:05:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:43869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaEHOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:45 -0400
Message-Id: <20140508135852.770036493@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 17/20] arch,sh: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-sh-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/sh/include/asm/atomic-grb.h  |  121 ++++++++++++++------------------------
 arch/sh/include/asm/atomic-irq.h  |   62 ++++++++-----------
 arch/sh/include/asm/atomic-llsc.h |  101 ++++++++++++-------------------
 3 files changed, 113 insertions(+), 171 deletions(-)

--- a/arch/sh/include/asm/atomic-grb.h
+++ b/arch/sh/include/asm/atomic-grb.h
@@ -1,85 +1,56 @@
 #ifndef __ASM_SH_ATOMIC_GRB_H
 #define __ASM_SH_ATOMIC_GRB_H
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	int tmp;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov    r15,   r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   add     %2,   %0      \n\t" /* add */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (i)
-		: "memory" , "r0", "r1");
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int tmp;							\
+									\
+	__asm__ __volatile__ (						\
+		"   .align 2              \n\t"				\
+		"   mova    1f,   r0      \n\t" /* r0 = end point */	\
+		"   mov    r15,   r1      \n\t" /* r1 = saved sp */	\
+		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */	\
+		"   mov.l  @%1,   %0      \n\t" /* load  old value */	\
+		" " #op "   %2,   %0      \n\t" /* $op */		\
+		"   mov.l   %0,   @%1     \n\t" /* store new value */	\
+		"1: mov     r1,   r15     \n\t" /* LOGOUT */		\
+		: "=&r" (tmp),						\
+		  "+r"  (v)						\
+		: "r"   (i)						\
+		: "memory" , "r0", "r1");				\
+}									\
+
+#define ATOMIC_OP_RETURN(op)						\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int tmp;							\
+									\
+	__asm__ __volatile__ (						\
+		"   .align 2              \n\t"				\
+		"   mova    1f,   r0      \n\t" /* r0 = end point */	\
+		"   mov    r15,   r1      \n\t" /* r1 = saved sp */	\
+		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */	\
+		"   mov.l  @%1,   %0      \n\t" /* load  old value */	\
+		" " #op "   %2,   %0      \n\t" /* $op */		\
+		"   mov.l   %0,   @%1     \n\t" /* store new value */	\
+		"1: mov     r1,   r15     \n\t" /* LOGOUT */		\
+		: "=&r" (tmp),						\
+		  "+r"  (v)						\
+		: "r"   (i)						\
+		: "memory" , "r0", "r1");				\
+									\
+	return tmp;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	int tmp;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov     r15,  r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   sub     %2,   %0      \n\t" /* sub */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (i)
-		: "memory" , "r0", "r1");
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int tmp;
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov    r15,   r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   add     %2,   %0      \n\t" /* add */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (i)
-		: "memory" , "r0", "r1");
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-	return tmp;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int tmp;
-
-	__asm__ __volatile__ (
-		"   .align 2              \n\t"
-		"   mova    1f,   r0      \n\t" /* r0 = end point */
-		"   mov    r15,   r1      \n\t" /* r1 = saved sp */
-		"   mov    #-6,   r15     \n\t" /* LOGIN: r15 = size */
-		"   mov.l  @%1,   %0      \n\t" /* load  old value */
-		"   sub     %2,   %0      \n\t" /* sub */
-		"   mov.l   %0,   @%1     \n\t" /* store new value */
-		"1: mov     r1,   r15     \n\t" /* LOGOUT */
-		: "=&r" (tmp),
-		  "+r"  (v)
-		: "r"   (i)
-		: "memory", "r0", "r1");
-
-	return tmp;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
--- a/arch/sh/include/asm/atomic-irq.h
+++ b/arch/sh/include/asm/atomic-irq.h
@@ -8,49 +8,39 @@
  * forward to code at the end of this object's .text section, then
  * branch back to restart the operation.
  */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-	v->counter += i;
-	raw_local_irq_restore(flags);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
 
-	raw_local_irq_save(flags);
-	v->counter -= i;
-	raw_local_irq_restore(flags);
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	raw_local_irq_save(flags);					\
+	v->counter c_op i;						\
+	raw_local_irq_restore(flags);					\
 }
 
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long temp, flags;
-
-	raw_local_irq_save(flags);
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
-
-	return temp;
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long temp, flags;					\
+									\
+	raw_local_irq_save(flags);					\
+	temp = v->counter;						\
+	temp c_op i;							\
+	v->counter = temp;						\
+	raw_local_irq_restore(flags);					\
+									\
+	return temp;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long temp, flags;
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
 
-	raw_local_irq_save(flags);
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	raw_local_irq_restore(flags);
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
 
-	return temp;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
--- a/arch/sh/include/asm/atomic-llsc.h
+++ b/arch/sh/include/asm/atomic-llsc.h
@@ -2,39 +2,6 @@
 #define __ASM_SH_ATOMIC_LLSC_H
 
 /*
- * To get proper branch prediction for the main line, we must branch
- * forward to code at the end of this object's .text section, then
- * branch back to restart the operation.
- */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long tmp;
-
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_add	\n"
-"	add	%1, %0				\n"
-"	movco.l	%0, @%2				\n"
-"	bf	1b				\n"
-	: "=&z" (tmp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long tmp;
-
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_sub	\n"
-"	sub	%1, %0				\n"
-"	movco.l	%0, @%2				\n"
-"	bf	1b				\n"
-	: "=&z" (tmp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
-}
-
-/*
  * SH-4A note:
  *
  * We basically get atomic_xxx_return() for free compared with
@@ -42,39 +9,53 @@ static inline void atomic_sub(int i, ato
  * encoding, so the retval is automatically set without having to
  * do any special work.
  */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long temp;
+/*
+ * To get proper branch prediction for the main line, we must branch
+ * forward to code at the end of this object's .text section, then
+ * branch back to restart the operation.
+ */
 
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_add_return	\n"
-"	add	%1, %0					\n"
-"	movco.l	%0, @%2					\n"
-"	bf	1b					\n"
-"	synco						\n"
-	: "=&z" (temp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long tmp;						\
+									\
+	__asm__ __volatile__ (						\
+"1:	movli.l @%2, %0		! atomic_" #op "\n"			\
+"	" #op "	%1, %0				\n"			\
+"	movco.l	%0, @%2				\n"			\
+"	bf	1b				\n"			\
+	: "=&z" (tmp)							\
+	: "r" (i), "r" (&v->counter)					\
+	: "t");								\
+}
 
-	return temp;
+#define ATOMIC_OP_RETURN(op)						\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long temp;						\
+									\
+	__asm__ __volatile__ (						\
+"1:	movli.l @%2, %0		! atomic_" #op "_return	\n"		\
+"	" #op "	%1, %0					\n"		\
+"	movco.l	%0, @%2					\n"		\
+"	bf	1b					\n"		\
+"	synco						\n"		\
+	: "=&z" (temp)							\
+	: "r" (i), "r" (&v->counter)					\
+	: "t");								\
+									\
+	return temp;							\
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long temp;
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-	__asm__ __volatile__ (
-"1:	movli.l @%2, %0		! atomic_sub_return	\n"
-"	sub	%1, %0					\n"
-"	movco.l	%0, @%2					\n"
-"	bf	1b					\n"
-"	synco						\n"
-	: "=&z" (temp)
-	: "r" (i), "r" (&v->counter)
-	: "t");
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-	return temp;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {


