Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaHNRXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:23:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaHNRXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:23:49 -0400
Date: Thu, 14 Aug 2014 10:22:42 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-4f3316c2b5fe2062c26c9b66915b5a5c80c60a5c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, torvalds@linux-foundation.org, peterz@infradead.org,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, bhelgaas@google.com,
        tkhai@yandex.ru, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, sam@ravnborg.org, peterz@infradead.org,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, bhelgaas@google.com,
        tkhai@yandex.ru, tglx@linutronix.de
In-Reply-To: <20140508135852.825281379@infradead.org>
References: <20140508135852.825281379@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,sparc: Fold atomic_ops
Git-Commit-ID: 4f3316c2b5fe2062c26c9b66915b5a5c80c60a5c
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

Commit-ID:  4f3316c2b5fe2062c26c9b66915b5a5c80c60a5c
Gitweb:     http://git.kernel.org/tip/4f3316c2b5fe2062c26c9b66915b5a5c80c60a5c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 26 Mar 2014 18:29:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:13 +0200

locking,arch,sparc: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: sparclinux@vger.kernel.org
Link: http://lkml.kernel.org/r/20140508135852.825281379@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sparc/include/asm/atomic_32.h |  17 ++--
 arch/sparc/include/asm/atomic_64.h |  45 +++++-----
 arch/sparc/kernel/smp_64.c         |   2 +-
 arch/sparc/lib/atomic32.c          |  29 ++++---
 arch/sparc/lib/atomic_64.S         | 163 +++++++++++++++----------------------
 arch/sparc/lib/ksyms.c             |  25 ++++--
 6 files changed, 133 insertions(+), 148 deletions(-)

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 7aed2be..7b024f0 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -20,7 +20,7 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-int __atomic_add_return(int, atomic_t *);
+int atomic_add_return(int, atomic_t *);
 int atomic_cmpxchg(atomic_t *, int, int);
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 int __atomic_add_unless(atomic_t *, int, int);
@@ -28,15 +28,14 @@ void atomic_set(atomic_t *, int);
 
 #define atomic_read(v)          (*(volatile int *)&(v)->counter)
 
-#define atomic_add(i, v)	((void)__atomic_add_return( (int)(i), (v)))
-#define atomic_sub(i, v)	((void)__atomic_add_return(-(int)(i), (v)))
-#define atomic_inc(v)		((void)__atomic_add_return(        1, (v)))
-#define atomic_dec(v)		((void)__atomic_add_return(       -1, (v)))
+#define atomic_add(i, v)	((void)atomic_add_return( (int)(i), (v)))
+#define atomic_sub(i, v)	((void)atomic_add_return(-(int)(i), (v)))
+#define atomic_inc(v)		((void)atomic_add_return(        1, (v)))
+#define atomic_dec(v)		((void)atomic_add_return(       -1, (v)))
 
-#define atomic_add_return(i, v)	(__atomic_add_return( (int)(i), (v)))
-#define atomic_sub_return(i, v)	(__atomic_add_return(-(int)(i), (v)))
-#define atomic_inc_return(v)	(__atomic_add_return(        1, (v)))
-#define atomic_dec_return(v)	(__atomic_add_return(       -1, (v)))
+#define atomic_sub_return(i, v)	(atomic_add_return(-(int)(i), (v)))
+#define atomic_inc_return(v)	(atomic_add_return(        1, (v)))
+#define atomic_dec_return(v)	(atomic_add_return(       -1, (v)))
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
 
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index bb894c8..7e4ca1e 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -20,27 +20,28 @@
 #define atomic_set(v, i)	(((v)->counter) = i)
 #define atomic64_set(v, i)	(((v)->counter) = i)
 
-void atomic_add(int, atomic_t *);
-void atomic64_add(long, atomic64_t *);
-void atomic_sub(int, atomic_t *);
-void atomic64_sub(long, atomic64_t *);
+#define ATOMIC_OP(op)							\
+void atomic_##op(int, atomic_t *);					\
+void atomic64_##op(long, atomic64_t *);
 
-int atomic_add_ret(int, atomic_t *);
-long atomic64_add_ret(long, atomic64_t *);
-int atomic_sub_ret(int, atomic_t *);
-long atomic64_sub_ret(long, atomic64_t *);
+#define ATOMIC_OP_RETURN(op)						\
+int atomic_##op##_return(int, atomic_t *);				\
+long atomic64_##op##_return(long, atomic64_t *);
 
-#define atomic_dec_return(v) atomic_sub_ret(1, v)
-#define atomic64_dec_return(v) atomic64_sub_ret(1, v)
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-#define atomic_inc_return(v) atomic_add_ret(1, v)
-#define atomic64_inc_return(v) atomic64_add_ret(1, v)
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-#define atomic_sub_return(i, v) atomic_sub_ret(i, v)
-#define atomic64_sub_return(i, v) atomic64_sub_ret(i, v)
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-#define atomic_add_return(i, v) atomic_add_ret(i, v)
-#define atomic64_add_return(i, v) atomic64_add_ret(i, v)
+#define atomic_dec_return(v)   atomic_sub_return(1, v)
+#define atomic64_dec_return(v) atomic64_sub_return(1, v)
+
+#define atomic_inc_return(v)   atomic_add_return(1, v)
+#define atomic64_inc_return(v) atomic64_add_return(1, v)
 
 /*
  * atomic_inc_and_test - increment and test
@@ -53,11 +54,11 @@ long atomic64_sub_ret(long, atomic64_t *);
 #define atomic_inc_and_test(v) (atomic_inc_return(v) == 0)
 #define atomic64_inc_and_test(v) (atomic64_inc_return(v) == 0)
 
-#define atomic_sub_and_test(i, v) (atomic_sub_ret(i, v) == 0)
-#define atomic64_sub_and_test(i, v) (atomic64_sub_ret(i, v) == 0)
+#define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
+#define atomic64_sub_and_test(i, v) (atomic64_sub_return(i, v) == 0)
 
-#define atomic_dec_and_test(v) (atomic_sub_ret(1, v) == 0)
-#define atomic64_dec_and_test(v) (atomic64_sub_ret(1, v) == 0)
+#define atomic_dec_and_test(v) (atomic_sub_return(1, v) == 0)
+#define atomic64_dec_and_test(v) (atomic64_sub_return(1, v) == 0)
 
 #define atomic_inc(v) atomic_add(1, v)
 #define atomic64_inc(v) atomic64_add(1, v)
@@ -65,8 +66,8 @@ long atomic64_sub_ret(long, atomic64_t *);
 #define atomic_dec(v) atomic_sub(1, v)
 #define atomic64_dec(v) atomic64_sub(1, v)
 
-#define atomic_add_negative(i, v) (atomic_add_ret(i, v) < 0)
-#define atomic64_add_negative(i, v) (atomic64_add_ret(i, v) < 0)
+#define atomic_add_negative(i, v) (atomic_add_return(i, v) < 0)
+#define atomic64_add_negative(i, v) (atomic64_add_return(i, v) < 0)
 
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 41aa247..32dab00 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1138,7 +1138,7 @@ static unsigned long penguins_are_doing_time;
 
 void smp_capture(void)
 {
-	int result = atomic_add_ret(1, &smp_capture_depth);
+	int result = atomic_add_return(1, &smp_capture_depth);
 
 	if (result == 1) {
 		int ncpus = num_online_cpus();
diff --git a/arch/sparc/lib/atomic32.c b/arch/sparc/lib/atomic32.c
index 1d32b54..a7c418a 100644
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -27,18 +27,23 @@ static DEFINE_SPINLOCK(dummy);
 
 #endif /* SMP */
 
-int __atomic_add_return(int i, atomic_t *v)
-{
-	int ret;
-	unsigned long flags;
-	spin_lock_irqsave(ATOMIC_HASH(v), flags);
-
-	ret = (v->counter += i);
-
-	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);
-	return ret;
-}
-EXPORT_SYMBOL(__atomic_add_return);
+#define ATOMIC_OP(op, cop)						\
+int atomic_##op##_return(int i, atomic_t *v)				\
+{									\
+	int ret;							\
+	unsigned long flags;						\
+	spin_lock_irqsave(ATOMIC_HASH(v), flags);			\
+									\
+	ret = (v->counter cop i);					\
+									\
+	spin_unlock_irqrestore(ATOMIC_HASH(v), flags);			\
+	return ret;							\
+}									\
+EXPORT_SYMBOL(atomic_##op##_return);
+
+ATOMIC_OP(add, +=)
+
+#undef ATOMIC_OP
 
 int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
diff --git a/arch/sparc/lib/atomic_64.S b/arch/sparc/lib/atomic_64.S
index 85c233d..96d70b4 100644
--- a/arch/sparc/lib/atomic_64.S
+++ b/arch/sparc/lib/atomic_64.S
@@ -14,109 +14,80 @@
 	 * memory barriers, and a second which returns
 	 * a value and does the barriers.
 	 */
-ENTRY(atomic_add) /* %o0 = increment, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	lduw	[%o1], %g1
-	add	%g1, %o0, %g7
-	cas	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%icc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 nop
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic_add)
 
-ENTRY(atomic_sub) /* %o0 = decrement, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	lduw	[%o1], %g1
-	sub	%g1, %o0, %g7
-	cas	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%icc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 nop
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic_sub)
+#define ATOMIC_OP(op)							\
+ENTRY(atomic_##op) /* %o0 = increment, %o1 = atomic_ptr */		\
+	BACKOFF_SETUP(%o2);						\
+1:	lduw	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	cas	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%icc, BACKOFF_LABEL(2f, 1b);				\
+	 nop;								\
+	retl;								\
+	 nop;								\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic_##op);							\
 
-ENTRY(atomic_add_ret) /* %o0 = increment, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	lduw	[%o1], %g1
-	add	%g1, %o0, %g7
-	cas	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%icc, BACKOFF_LABEL(2f, 1b)
-	 add	%g1, %o0, %g1
-	retl
-	 sra	%g1, 0, %o0
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic_add_ret)
+#define ATOMIC_OP_RETURN(op)						\
+ENTRY(atomic_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
+	BACKOFF_SETUP(%o2);						\
+1:	lduw	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	cas	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%icc, BACKOFF_LABEL(2f, 1b);				\
+	 add	%g1, %o0, %g1;						\
+	retl;								\
+	 sra	%g1, 0, %o0;						\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic_##op##_return);
 
-ENTRY(atomic_sub_ret) /* %o0 = decrement, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	lduw	[%o1], %g1
-	sub	%g1, %o0, %g7
-	cas	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%icc, BACKOFF_LABEL(2f, 1b)
-	 sub	%g1, %o0, %g1
-	retl
-	 sra	%g1, 0, %o0
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic_sub_ret)
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
 
-ENTRY(atomic64_add) /* %o0 = increment, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	ldx	[%o1], %g1
-	add	%g1, %o0, %g7
-	casx	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 nop
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic64_add)
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
 
-ENTRY(atomic64_sub) /* %o0 = decrement, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	ldx	[%o1], %g1
-	sub	%g1, %o0, %g7
-	casx	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 nop
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic64_sub)
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
 
-ENTRY(atomic64_add_ret) /* %o0 = increment, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	ldx	[%o1], %g1
-	add	%g1, %o0, %g7
-	casx	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 add	%g1, %o0, %o0
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic64_add_ret)
+#define ATOMIC64_OP(op)							\
+ENTRY(atomic64_##op) /* %o0 = increment, %o1 = atomic_ptr */		\
+	BACKOFF_SETUP(%o2);						\
+1:	ldx	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	casx	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b);				\
+	 nop;								\
+	retl;								\
+	 nop;								\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic64_##op);							\
 
-ENTRY(atomic64_sub_ret) /* %o0 = decrement, %o1 = atomic_ptr */
-	BACKOFF_SETUP(%o2)
-1:	ldx	[%o1], %g1
-	sub	%g1, %o0, %g7
-	casx	[%o1], %g1, %g7
-	cmp	%g1, %g7
-	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b)
-	 nop
-	retl
-	 sub	%g1, %o0, %o0
-2:	BACKOFF_SPIN(%o2, %o3, 1b)
-ENDPROC(atomic64_sub_ret)
+#define ATOMIC64_OP_RETURN(op)						\
+ENTRY(atomic64_##op##_return) /* %o0 = increment, %o1 = atomic_ptr */	\
+	BACKOFF_SETUP(%o2);						\
+1:	ldx	[%o1], %g1;						\
+	op	%g1, %o0, %g7;						\
+	casx	[%o1], %g1, %g7;					\
+	cmp	%g1, %g7;						\
+	bne,pn	%xcc, BACKOFF_LABEL(2f, 1b);				\
+	 nop;								\
+	retl;								\
+	 add	%g1, %o0, %o0;						\
+2:	BACKOFF_SPIN(%o2, %o3, 1b);					\
+ENDPROC(atomic64_##op##_return);
+
+#define ATOMIC64_OPS(op) ATOMIC64_OP(op) ATOMIC64_OP_RETURN(op)
+
+ATOMIC64_OPS(add)
+ATOMIC64_OPS(sub)
+
+#undef ATOMIC64_OPS
+#undef ATOMIC64_OP_RETURN
+#undef ATOMIC64_OP
 
 ENTRY(atomic64_dec_if_positive) /* %o0 = atomic_ptr */
 	BACKOFF_SETUP(%o2)
diff --git a/arch/sparc/lib/ksyms.c b/arch/sparc/lib/ksyms.c
index 323335b..1d649a9 100644
--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -99,14 +99,23 @@ EXPORT_SYMBOL(___copy_in_user);
 EXPORT_SYMBOL(__clear_user);
 
 /* Atomic counter implementation. */
-EXPORT_SYMBOL(atomic_add);
-EXPORT_SYMBOL(atomic_add_ret);
-EXPORT_SYMBOL(atomic_sub);
-EXPORT_SYMBOL(atomic_sub_ret);
-EXPORT_SYMBOL(atomic64_add);
-EXPORT_SYMBOL(atomic64_add_ret);
-EXPORT_SYMBOL(atomic64_sub);
-EXPORT_SYMBOL(atomic64_sub_ret);
+#define ATOMIC_OP(op)							\
+EXPORT_SYMBOL(atomic_##op);						\
+EXPORT_SYMBOL(atomic64_##op);
+
+#define ATOMIC_OP_RETURN(op)						\
+EXPORT_SYMBOL(atomic_##op##_return);					\
+EXPORT_SYMBOL(atomic64_##op##_return);
+
+#define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op)
+
+ATOMIC_OPS(add)
+ATOMIC_OPS(sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
+
 EXPORT_SYMBOL(atomic64_dec_if_positive);
 
 /* Atomic bit operations. */
