Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbaEHOG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:06:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:43840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:45 -0400
Message-Id: <20140508135851.995123148@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chen Gang <gang.chen@asianux.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 05/20] arch,arm64: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-arm64-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Requires the asm_op due to eor.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arm64/include/asm/atomic.h |  213 ++++++++++++++++------------------------
 1 file changed, 88 insertions(+), 125 deletions(-)

--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -43,69 +43,51 @@
  * store exclusive to ensure that these are atomic.  We may loop
  * to ensure that the update happens.
  */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	asm volatile("// atomic_add\n"
-"1:	ldxr	%w0, %2\n"
-"	add	%w0, %w0, %w3\n"
-"	stxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i));
-}
-
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	asm volatile("// atomic_add_return\n"
-"1:	ldxr	%w0, %2\n"
-"	add	%w0, %w0, %w3\n"
-"	stlxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "memory");
 
-	smp_mb();
-	return result;
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	asm volatile("// atomic_sub\n"
-"1:	ldxr	%w0, %2\n"
-"	sub	%w0, %w0, %w3\n"
-"	stxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i));
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
-
-	asm volatile("// atomic_sub_return\n"
-"1:	ldxr	%w0, %2\n"
-"	sub	%w0, %w0, %w3\n"
-"	stlxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "memory");
-
-	smp_mb();
-	return result;
-}
+#define ATOMIC_OP(op, asm_op)						\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	asm volatile("// atomic_" #op "\n"				\
+"1:	ldxr	%w0, %2\n"						\
+"	" #asm_op "	%w0, %w0, %w3\n"				\
+"	stxr	%w1, %w0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i));							\
+}									\
+
+#define ATOMIC_OP_RETURN(op, asm_op)					\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	unsigned long tmp;						\
+	int result;							\
+									\
+	asm volatile("// atomic_" #op "_return\n"			\
+"1:	ldxr	%w0, %2\n"						\
+"	" #asm_op "	%w0, %w0, %w3\n"				\
+"	stlxr	%w1, %w0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i)							\
+	: "memory");							\
+									\
+	smp_mb();							\
+	return result;							\
+}
+
+#define ATOMIC_OPS(op, asm_op)						\
+	ATOMIC_OP(op, asm_op)						\
+	ATOMIC_OP_RETURN(op, asm_op)
+
+ATOMIC_OPS(add, add)
+ATOMIC_OPS(sub, sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 {
@@ -160,69 +142,50 @@ static inline int __atomic_add_unless(at
 #define atomic64_read(v)	(*(volatile long long *)&(v)->counter)
 #define atomic64_set(v,i)	(((v)->counter) = (i))
 
-static inline void atomic64_add(u64 i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
-
-	asm volatile("// atomic64_add\n"
-"1:	ldxr	%0, %2\n"
-"	add	%0, %0, %3\n"
-"	stxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i));
-}
-
-static inline long atomic64_add_return(long i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
-
-	asm volatile("// atomic64_add_return\n"
-"1:	ldxr	%0, %2\n"
-"	add	%0, %0, %3\n"
-"	stlxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "memory");
-
-	smp_mb();
-	return result;
-}
-
-static inline void atomic64_sub(u64 i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
-
-	asm volatile("// atomic64_sub\n"
-"1:	ldxr	%0, %2\n"
-"	sub	%0, %0, %3\n"
-"	stxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i));
-}
-
-static inline long atomic64_sub_return(long i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
-
-	asm volatile("// atomic64_sub_return\n"
-"1:	ldxr	%0, %2\n"
-"	sub	%0, %0, %3\n"
-"	stlxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "memory");
-
-	smp_mb();
-	return result;
-}
+#define ATOMIC64_OP(op, asm_op)						\
+static inline void atomic64_##op(long i, atomic64_t *v)			\
+{									\
+	long result;							\
+	unsigned long tmp;						\
+									\
+	asm volatile("// atomic64_" #op "\n"				\
+"1:	ldxr	%0, %2\n"						\
+"	" #asm_op "	%0, %0, %3\n"					\
+"	stxr	%w1, %0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i));							\
+}									\
+
+#define ATOMIC64_OP_RETURN(op, asm_op)					\
+static inline long atomic64_##op##_return(long i, atomic64_t *v)	\
+{									\
+	long result;							\
+	unsigned long tmp;						\
+									\
+	asm volatile("// atomic64_" #op "_return\n"			\
+"1:	ldxr	%0, %2\n"						\
+"	" #asm_op "	%0, %0, %3\n"					\
+"	stlxr	%w1, %0, %2\n"						\
+"	cbnz	%w1, 1b"						\
+	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
+	: "Ir" (i)							\
+	: "memory");							\
+									\
+	smp_mb();							\
+	return result;							\
+}
+
+#define ATOMIC64_OPS(op, asm_op)					\
+	ATOMIC64_OP(op, asm_op)						\
+	ATOMIC64_OP_RETURN(op, asm_op)
+
+ATOMIC64_OPS(add, add)
+ATOMIC64_OPS(sub, sub)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 static inline long atomic64_cmpxchg(atomic64_t *ptr, long old, long new)
 {


