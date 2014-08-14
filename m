Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaHNRXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:23:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbaHNRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:23:19 -0400
Date: Thu, 14 Aug 2014 10:22:13 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-af095dd60bdc52b11c186c3151e8e38d6faa094c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        mahesh@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, tglx@linutronix.de,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, mahesh@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tglx@linutronix.de, paul.gortmaker@windriver.com
In-Reply-To: <20140508135852.713980957@infradead.org>
References: <20140508135852.713980957@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,powerpc: Fold atomic_ops
Git-Commit-ID: af095dd60bdc52b11c186c3151e8e38d6faa094c
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

Commit-ID:  af095dd60bdc52b11c186c3151e8e38d6faa094c
Gitweb:     http://git.kernel.org/tip/af095dd60bdc52b11c186c3151e8e38d6faa094c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 26 Mar 2014 18:11:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:11 +0200

locking,arch,powerpc: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

Requires asm_op because PPC asm is weird :-)

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/20140508135852.713980957@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/include/asm/atomic.h | 198 +++++++++++++++-----------------------
 1 file changed, 77 insertions(+), 121 deletions(-)

diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index 28992d0..512d278 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -26,76 +26,53 @@ static __inline__ void atomic_set(atomic_t *v, int i)
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
 }
 
-static __inline__ int atomic_add_return(int a, atomic_t *v)
-{
-	int t;
+#define ATOMIC_OPS(op, asm_op) ATOMIC_OP(op, asm_op) ATOMIC_OP_RETURN(op, asm_op)
 
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
+ATOMIC_OPS(add, add)
+ATOMIC_OPS(sub, subf)
 
-	return t;
-}
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
@@ -289,71 +266,50 @@ static __inline__ void atomic64_set(atomic64_t *v, long i)
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
 }
 
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
 }
 
-#define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
-
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
+#define ATOMIC64_OPS(op, asm_op) ATOMIC64_OP(op, asm_op) ATOMIC64_OP_RETURN(op, asm_op)
 
-static __inline__ long atomic64_sub_return(long a, atomic64_t *v)
-{
-	long t;
+ATOMIC64_OPS(add, add)
+ATOMIC64_OPS(sub, subf)
 
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
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
-	return t;
-}
+#define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
 
 static __inline__ void atomic64_inc(atomic64_t *v)
 {
