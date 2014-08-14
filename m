Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaHNRXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:23:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaHNRV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:21:29 -0400
Date: Thu, 14 Aug 2014 10:19:30 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-92ba1f530b4f90db78eb45f4b6598e75939146bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, catalin.marinas@arm.com,
        will.deacon@arm.com, rmk+kernel@arm.linux.org.uk, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, bhelgaas@google.com, gang.chen@asianux.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, catalin.marinas@arm.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rmk+kernel@arm.linux.org.uk, paulmck@linux.vnet.ibm.com,
        bhelgaas@google.com, gang.chen@asianux.com, tglx@linutronix.de
In-Reply-To: <20140508135851.995123148@infradead.org>
References: <20140508135851.995123148@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,arm64: Fold atomic_ops
Git-Commit-ID: 92ba1f530b4f90db78eb45f4b6598e75939146bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92ba1f530b4f90db78eb45f4b6598e75939146bd
Gitweb:     http://git.kernel.org/tip/92ba1f530b4f90db78eb45f4b6598e75939146bd
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 16:57:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:04 +0200

locking,arch,arm64: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Requires the asm_op due to eor.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/20140508135851.995123148@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm64/include/asm/atomic.h | 197 ++++++++++++++++------------------------
 1 file changed, 80 insertions(+), 117 deletions(-)

diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 65f1569..b83c325 100644
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
-
-	smp_mb();
-	return result;
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
 
-	asm volatile("// atomic_sub\n"
-"1:	ldxr	%w0, %2\n"
-"	sub	%w0, %w0, %w3\n"
-"	stxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i));
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
 }
 
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long tmp;
-	int result;
+#define ATOMIC_OPS(op, asm_op)						\
+	ATOMIC_OP(op, asm_op)						\
+	ATOMIC_OP_RETURN(op, asm_op)
 
-	asm volatile("// atomic_sub_return\n"
-"1:	ldxr	%w0, %2\n"
-"	sub	%w0, %w0, %w3\n"
-"	stlxr	%w1, %w0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "memory");
+ATOMIC_OPS(add, add)
+ATOMIC_OPS(sub, sub)
 
-	smp_mb();
-	return result;
-}
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
 static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 {
@@ -160,69 +142,50 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic64_read(v)	(*(volatile long *)&(v)->counter)
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
 }
 
-static inline long atomic64_add_return(long i, atomic64_t *v)
-{
-	long result;
-	unsigned long tmp;
+#define ATOMIC64_OPS(op, asm_op)					\
+	ATOMIC64_OP(op, asm_op)						\
+	ATOMIC64_OP_RETURN(op, asm_op)
 
-	asm volatile("// atomic64_add_return\n"
-"1:	ldxr	%0, %2\n"
-"	add	%0, %0, %3\n"
-"	stlxr	%w1, %0, %2\n"
-"	cbnz	%w1, 1b"
-	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
-	: "Ir" (i)
-	: "memory");
+ATOMIC64_OPS(add, add)
+ATOMIC64_OPS(sub, sub)
 
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
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 static inline long atomic64_cmpxchg(atomic64_t *ptr, long old, long new)
 {
