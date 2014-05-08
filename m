Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaEHOE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:04:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:43880 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaEHOAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:47 -0400
Message-Id: <20140508135852.713980957@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 16/20] arch,powerpc: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-powerpc-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

Requires asm_op because PPC asm is weird :-)

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/powerpc/include/asm/atomic.h |  216 +++++++++++++++-----------------------
 1 file changed, 86 insertions(+), 130 deletions(-)

Index: linux-2.6/arch/powerpc/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/atomic.h
+++ linux-2.6/arch/powerpc/include/asm/atomic.h
@@ -26,76 +26,53 @@ static __inline__ void atomic_set(atomic
 	__asm__ __volatile__("stw%U0%X0 %1,%0" : "=m"(v->counter) : "r"(i));
 }
 
-static __inline__ void atomic_add(int a, atomic_t *v)
-{
-	int t;
-
-	__asm__ __volatile__(
-"1:	lwarx	%0,0,%3		# atomic_add\n\
-	add	%0,%2,%0\n"
-	PPC405_ERR77(0,%3)
-"	stwcx.	%0,0,%3 \n\
-	bne-	1b"
-	: "=&r" (t), "+m" (v->counter)
-	: "r" (a), "r" (&v->counter)
-	: "cc");
-}
-
-static __inline__ int atomic_add_return(int a, atomic_t *v)
-{
-	int t;
-
-	__asm__ __volatile__(
-	PPC_ATOMIC_ENTRY_BARRIER
-"1:	lwarx	%0,0,%2		# atomic_add_return\n\
-	add	%0,%1,%0\n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%2 \n\
-	bne-	1b"
-	PPC_ATOMIC_EXIT_BARRIER
-	: "=&r" (t)
-	: "r" (a), "r" (&v->counter)
-	: "cc", "memory");
-
-	return t;
-}
+#define ATOMIC_OP(op, asm_op)						\
+static __inline__ void atomic_##op(int a, atomic_t *v)			\
+{									\
+	int t;								\
+									\
+	__asm__ __volatile__(						\
+"1:	lwarx	%0,0,%3		# atomic_" #op "\n"			\
+	#asm_op " %0,%2,%0\n"						\
+	PPC405_ERR77(0,%3)						\
+"	stwcx.	%0,0,%3 \n"						\
+"	bne-	1b\n"							\
+	: "=&r" (t), "+m" (v->counter)					\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc");							\
+}									\
+
+#define ATOMIC_OP_RETURN(op, asm_op)					\
+static __inline__ int atomic_##op##_return(int a, atomic_t *v)		\
+{									\
+	int t;								\
+									\
+	__asm__ __volatile__(						\
+	PPC_ATOMIC_ENTRY_BARRIER					\
+"1:	lwarx	%0,0,%2		# atomic_" #op "_return\n"		\
+	#asm_op " %0,%1,%0\n"						\
+	PPC405_ERR77(0,%2)						\
+"	stwcx.	%0,0,%2 \n"						\
+"	bne-	1b\n"							\
+	PPC_ATOMIC_EXIT_BARRIER						\
+	: "=&r" (t)							\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc", "memory");						\
+									\
+	return t;							\
+}
+
+#define ATOMIC_OPS(op, asm_op) ATOMIC_OP(op, asm_op) ATOMIC_OP_RETURN(op, asm_op)
+
+ATOMIC_OPS(add, add)
+ATOMIC_OPS(sub, subf)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
-static __inline__ void atomic_sub(int a, atomic_t *v)
-{
-	int t;
-
-	__asm__ __volatile__(
-"1:	lwarx	%0,0,%3		# atomic_sub\n\
-	subf	%0,%2,%0\n"
-	PPC405_ERR77(0,%3)
-"	stwcx.	%0,0,%3 \n\
-	bne-	1b"
-	: "=&r" (t), "+m" (v->counter)
-	: "r" (a), "r" (&v->counter)
-	: "cc");
-}
-
-static __inline__ int atomic_sub_return(int a, atomic_t *v)
-{
-	int t;
-
-	__asm__ __volatile__(
-	PPC_ATOMIC_ENTRY_BARRIER
-"1:	lwarx	%0,0,%2		# atomic_sub_return\n\
-	subf	%0,%1,%0\n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%2 \n\
-	bne-	1b"
-	PPC_ATOMIC_EXIT_BARRIER
-	: "=&r" (t)
-	: "r" (a), "r" (&v->counter)
-	: "cc", "memory");
-
-	return t;
-}
-
 static __inline__ void atomic_inc(atomic_t *v)
 {
 	int t;
@@ -289,72 +266,51 @@ static __inline__ void atomic64_set(atom
 	__asm__ __volatile__("std%U0%X0 %1,%0" : "=m"(v->counter) : "r"(i));
 }
 
-static __inline__ void atomic64_add(long a, atomic64_t *v)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%3		# atomic64_add\n\
-	add	%0,%2,%0\n\
-	stdcx.	%0,0,%3 \n\
-	bne-	1b"
-	: "=&r" (t), "+m" (v->counter)
-	: "r" (a), "r" (&v->counter)
-	: "cc");
-}
-
-static __inline__ long atomic64_add_return(long a, atomic64_t *v)
-{
-	long t;
-
-	__asm__ __volatile__(
-	PPC_ATOMIC_ENTRY_BARRIER
-"1:	ldarx	%0,0,%2		# atomic64_add_return\n\
-	add	%0,%1,%0\n\
-	stdcx.	%0,0,%2 \n\
-	bne-	1b"
-	PPC_ATOMIC_EXIT_BARRIER
-	: "=&r" (t)
-	: "r" (a), "r" (&v->counter)
-	: "cc", "memory");
-
-	return t;
-}
+#define ATOMIC64_OP(op, asm_op)						\
+static __inline__ void atomic64_##op(long a, atomic64_t *v)		\
+{									\
+	long t;								\
+									\
+	__asm__ __volatile__(						\
+"1:	ldarx	%0,0,%3		# atomic64_" #op "\n"			\
+	#asm_op " %0,%2,%0\n"						\
+"	stdcx.	%0,0,%3 \n"						\
+"	bne-	1b\n"							\
+	: "=&r" (t), "+m" (v->counter)					\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc");							\
+}									\
+
+#define ATOMIC64_OP_RETURN(op, asm_op)					\
+static __inline__ long atomic64_##op##_return(long a, atomic64_t *v)	\
+{									\
+	long t;								\
+									\
+	__asm__ __volatile__(						\
+	PPC_ATOMIC_ENTRY_BARRIER					\
+"1:	ldarx	%0,0,%2		# atomic64_" #op "_return\n"		\
+	#asm_op " %0,%1,%0\n"						\
+"	stdcx.	%0,0,%2 \n"						\
+"	bne-	1b\n"							\
+	PPC_ATOMIC_EXIT_BARRIER						\
+	: "=&r" (t)							\
+	: "r" (a), "r" (&v->counter)					\
+	: "cc", "memory");						\
+									\
+	return t;							\
+}
+
+#define ATOMIC64_OPS(op, asm_op) ATOMIC64_OP(op, asm_op) ATOMIC64_OP_RETURN(op, asm_op)
+
+ATOMIC64_OPS(add, add)
+ATOMIC64_OPS(add, subf)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 
-static __inline__ void atomic64_sub(long a, atomic64_t *v)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%3		# atomic64_sub\n\
-	subf	%0,%2,%0\n\
-	stdcx.	%0,0,%3 \n\
-	bne-	1b"
-	: "=&r" (t), "+m" (v->counter)
-	: "r" (a), "r" (&v->counter)
-	: "cc");
-}
-
-static __inline__ long atomic64_sub_return(long a, atomic64_t *v)
-{
-	long t;
-
-	__asm__ __volatile__(
-	PPC_ATOMIC_ENTRY_BARRIER
-"1:	ldarx	%0,0,%2		# atomic64_sub_return\n\
-	subf	%0,%1,%0\n\
-	stdcx.	%0,0,%2 \n\
-	bne-	1b"
-	PPC_ATOMIC_EXIT_BARRIER
-	: "=&r" (t)
-	: "r" (a), "r" (&v->counter)
-	: "cc", "memory");
-
-	return t;
-}
-
 static __inline__ void atomic64_inc(atomic64_t *v)
 {
 	long t;


