Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaEHOBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:01:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbaEHOA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:59 -0400
Message-Id: <20140508135852.453864110@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 12/20] arch,metag: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-metag-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/metag/include/asm/atomic_lnkget.h |  121 ++++++++++++---------------------
 arch/metag/include/asm/atomic_lock1.h  |   76 ++++++++------------
 2 files changed, 77 insertions(+), 120 deletions(-)

Index: linux-2.6/arch/metag/include/asm/atomic_lnkget.h
===================================================================
--- linux-2.6.orig/arch/metag/include/asm/atomic_lnkget.h
+++ linux-2.6/arch/metag/include/asm/atomic_lnkget.h
@@ -27,85 +27,56 @@ static inline int atomic_read(const atom
 	return temp;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	int temp;
-
-	asm volatile (
-		"1:	LNKGETD %0, [%1]\n"
-		"	ADD	%0, %0, %2\n"
-		"	LNKSETD [%1], %0\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ	1b\n"
-		: "=&d" (temp)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
+#define ATOMIC_OP(op)							\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	int temp;							\
+									\
+	asm volatile (							\
+		"1:	LNKGETD %0, [%1]\n"				\
+		"	" #op "	%0, %0, %2\n"				\
+		"	LNKSETD [%1], %0\n"				\
+		"	DEFR	%0, TXSTAT\n"				\
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"		\
+		"	CMPT	%0, #HI(0x02000000)\n"			\
+		"	BNZ	1b\n"					\
+		: "=&d" (temp)						\
+		: "da" (&v->counter), "bd" (i)				\
+		: "cc");						\
+}									\
+
+#define ATOMIC_OP_RETURN(op)						\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int result, temp;						\
+									\
+	smp_mb();							\
+									\
+	asm volatile (							\
+		"1:	LNKGETD %1, [%2]\n"				\
+		"	" #op "	%1, %1, %3\n"				\
+		"	LNKSETD [%2], %1\n"				\
+		"	DEFR	%0, TXSTAT\n"				\
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"		\
+		"	CMPT	%0, #HI(0x02000000)\n"			\
+		"	BNZ 1b\n"					\
+		: "=&d" (temp), "=&da" (result)				\
+		: "da" (&v->counter), "bd" (i)				\
+		: "cc");						\
+									\
+	smp_mb();							\
+									\
+	return result;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	int temp;
-
-	asm volatile (
-		"1:	LNKGETD %0, [%1]\n"
-		"	SUB	%0, %0, %2\n"
-		"	LNKSETD [%1], %0\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ 1b\n"
-		: "=&d" (temp)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int result, temp;
-
-	smp_mb();
-
-	asm volatile (
-		"1:	LNKGETD %1, [%2]\n"
-		"	ADD	%1, %1, %3\n"
-		"	LNKSETD [%2], %1\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ 1b\n"
-		: "=&d" (temp), "=&da" (result)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-	smp_mb();
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-	return result;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int result, temp;
-
-	smp_mb();
-
-	asm volatile (
-		"1:	LNKGETD %1, [%2]\n"
-		"	SUB	%1, %1, %3\n"
-		"	LNKSETD [%2], %1\n"
-		"	DEFR	%0, TXSTAT\n"
-		"	ANDT	%0, %0, #HI(0x3f000000)\n"
-		"	CMPT	%0, #HI(0x02000000)\n"
-		"	BNZ	1b\n"
-		: "=&d" (temp), "=&da" (result)
-		: "da" (&v->counter), "bd" (i)
-		: "cc");
-
-	smp_mb();
-
-	return result;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
Index: linux-2.6/arch/metag/include/asm/atomic_lock1.h
===================================================================
--- linux-2.6.orig/arch/metag/include/asm/atomic_lock1.h
+++ linux-2.6/arch/metag/include/asm/atomic_lock1.h
@@ -37,55 +37,41 @@ static inline int atomic_set(atomic_t *v
 	return i;
 }
 
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	__global_lock1(flags);
-	fence();
-	v->counter += i;
-	__global_unlock1(flags);
+#define ATOMIC_OP(op, c_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long flags;						\
+									\
+	__global_lock1(flags);						\
+	fence();							\
+	v->counter c_op i;						\
+	__global_unlock1(flags);					\
+}									\
+
+#define ATOMIC_OP_RETURN(op, c_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long result;						\
+	unsigned long flags;						\
+									\
+	__global_lock1(flags);						\
+	result = v->counter;						\
+	result c_op i;							\
+	fence();							\
+	v->counter = result;						\
+	__global_unlock1(flags);					\
+									\
+	return result;							\
 }
 
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long flags;
-
-	__global_lock1(flags);
-	fence();
-	v->counter -= i;
-	__global_unlock1(flags);
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long result;
-	unsigned long flags;
+#define ATOMIC_OPS(op, c_op) ATOMIC_OP(op, c_op) ATOMIC_OP_RETURN(op, c_op)
 
-	__global_lock1(flags);
-	result = v->counter;
-	result += i;
-	fence();
-	v->counter = result;
-	__global_unlock1(flags);
+ATOMIC_OPS(add, +=)
+ATOMIC_OPS(sub, -=)
 
-	return result;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long result;
-	unsigned long flags;
-
-	__global_lock1(flags);
-	result = v->counter;
-	result -= i;
-	fence();
-	v->counter = result;
-	__global_unlock1(flags);
-
-	return result;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {


