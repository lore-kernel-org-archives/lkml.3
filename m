Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaHNR0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:26:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaHNR0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:26:22 -0400
Date: Thu, 14 Aug 2014 10:20:25 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-08be2dab191431f23f5f98ba2db76513d0d853e7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tony.luck@intel.com, akinobu.mita@gmail.com,
        paulmck@linux.vnet.ibm.com, fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        akinobu.mita@gmail.com, tony.luck@intel.com,
        paulmck@linux.vnet.ibm.com, fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <20140508135852.245224472@infradead.org>
References: <20140508135852.245224472@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,arch,ia64: Fold atomic_ops
Git-Commit-ID: 08be2dab191431f23f5f98ba2db76513d0d853e7
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

Commit-ID:  08be2dab191431f23f5f98ba2db76513d0d853e7
Gitweb:     http://git.kernel.org/tip/08be2dab191431f23f5f98ba2db76513d0d853e7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 Mar 2014 18:20:30 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:07 +0200

locking,arch,ia64: Fold atomic_ops

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
Link: http://lkml.kernel.org/r/20140508135852.245224472@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/ia64/include/asm/atomic.h | 188 +++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 102 deletions(-)

diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 0f8bf48..42919a8 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -27,62 +27,94 @@
 #define atomic_set(v,i)		(((v)->counter) = (i))
 #define atomic64_set(v,i)	(((v)->counter) = (i))
 
-static __inline__ int
-ia64_atomic_add (int i, atomic_t *v)
-{
-	__s32 old, new;
-	CMPXCHG_BUGCHECK_DECL
-
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic_read(v);
-		new = old + i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old);
-	return new;
+#define ATOMIC_OP(op, c_op)						\
+static __inline__ int							\
+ia64_atomic_##op (int i, atomic_t *v)					\
+{									\
+	__s32 old, new;							\
+	CMPXCHG_BUGCHECK_DECL						\
+									\
+	do {								\
+		CMPXCHG_BUGCHECK(v);					\
+		old = atomic_read(v);					\
+		new = old c_op i;					\
+	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old); \
+	return new;							\
 }
 
-static __inline__ long
-ia64_atomic64_add (__s64 i, atomic64_t *v)
-{
-	__s64 old, new;
-	CMPXCHG_BUGCHECK_DECL
-
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic64_read(v);
-		new = old + i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old);
-	return new;
-}
+ATOMIC_OP(add, +)
+ATOMIC_OP(sub, -)
 
-static __inline__ int
-ia64_atomic_sub (int i, atomic_t *v)
-{
-	__s32 old, new;
-	CMPXCHG_BUGCHECK_DECL
-
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic_read(v);
-		new = old - i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old);
-	return new;
-}
+#undef ATOMIC_OP
 
-static __inline__ long
-ia64_atomic64_sub (__s64 i, atomic64_t *v)
-{
-	__s64 old, new;
-	CMPXCHG_BUGCHECK_DECL
-
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic64_read(v);
-		new = old - i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old);
-	return new;
+#define atomic_add_return(i,v)						\
+({									\
+	int __ia64_aar_i = (i);						\
+	(__builtin_constant_p(i)					\
+	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
+	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
+	     || (__ia64_aar_i == -1) || (__ia64_aar_i ==  -4)		\
+	     || (__ia64_aar_i == -8) || (__ia64_aar_i == -16)))		\
+		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
+		: ia64_atomic_add(__ia64_aar_i, v);			\
+})
+
+#define atomic_sub_return(i,v)						\
+({									\
+	int __ia64_asr_i = (i);						\
+	(__builtin_constant_p(i)					\
+	 && (   (__ia64_asr_i ==   1) || (__ia64_asr_i ==   4)		\
+	     || (__ia64_asr_i ==   8) || (__ia64_asr_i ==  16)		\
+	     || (__ia64_asr_i ==  -1) || (__ia64_asr_i ==  -4)		\
+	     || (__ia64_asr_i ==  -8) || (__ia64_asr_i == -16)))	\
+		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
+		: ia64_atomic_sub(__ia64_asr_i, v);			\
+})
+
+#define ATOMIC64_OP(op, c_op)						\
+static __inline__ long							\
+ia64_atomic64_##op (__s64 i, atomic64_t *v)				\
+{									\
+	__s64 old, new;							\
+	CMPXCHG_BUGCHECK_DECL						\
+									\
+	do {								\
+		CMPXCHG_BUGCHECK(v);					\
+		old = atomic64_read(v);					\
+		new = old c_op i;					\
+	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old); \
+	return new;							\
 }
 
+ATOMIC64_OP(add, +)
+ATOMIC64_OP(sub, -)
+
+#undef ATOMIC64_OP
+
+#define atomic64_add_return(i,v)					\
+({									\
+	long __ia64_aar_i = (i);					\
+	(__builtin_constant_p(i)					\
+	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
+	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
+	     || (__ia64_aar_i == -1) || (__ia64_aar_i ==  -4)		\
+	     || (__ia64_aar_i == -8) || (__ia64_aar_i == -16)))		\
+		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
+		: ia64_atomic64_add(__ia64_aar_i, v);			\
+})
+
+#define atomic64_sub_return(i,v)					\
+({									\
+	long __ia64_asr_i = (i);					\
+	(__builtin_constant_p(i)					\
+	 && (   (__ia64_asr_i ==   1) || (__ia64_asr_i ==   4)		\
+	     || (__ia64_asr_i ==   8) || (__ia64_asr_i ==  16)		\
+	     || (__ia64_asr_i ==  -1) || (__ia64_asr_i ==  -4)		\
+	     || (__ia64_asr_i ==  -8) || (__ia64_asr_i == -16)))	\
+		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
+		: ia64_atomic64_sub(__ia64_asr_i, v);			\
+})
+
 #define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
@@ -123,30 +155,6 @@ static __inline__ long atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
-#define atomic_add_return(i,v)						\
-({									\
-	int __ia64_aar_i = (i);						\
-	(__builtin_constant_p(i)					\
-	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
-	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
-	     || (__ia64_aar_i == -1) || (__ia64_aar_i ==  -4)		\
-	     || (__ia64_aar_i == -8) || (__ia64_aar_i == -16)))		\
-		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
-		: ia64_atomic_add(__ia64_aar_i, v);			\
-})
-
-#define atomic64_add_return(i,v)					\
-({									\
-	long __ia64_aar_i = (i);					\
-	(__builtin_constant_p(i)					\
-	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
-	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
-	     || (__ia64_aar_i == -1) || (__ia64_aar_i ==  -4)		\
-	     || (__ia64_aar_i == -8) || (__ia64_aar_i == -16)))		\
-		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
-		: ia64_atomic64_add(__ia64_aar_i, v);			\
-})
-
 /*
  * Atomically add I to V and return TRUE if the resulting value is
  * negative.
@@ -163,30 +171,6 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 	return atomic64_add_return(i, v) < 0;
 }
 
-#define atomic_sub_return(i,v)						\
-({									\
-	int __ia64_asr_i = (i);						\
-	(__builtin_constant_p(i)					\
-	 && (   (__ia64_asr_i ==   1) || (__ia64_asr_i ==   4)		\
-	     || (__ia64_asr_i ==   8) || (__ia64_asr_i ==  16)		\
-	     || (__ia64_asr_i ==  -1) || (__ia64_asr_i ==  -4)		\
-	     || (__ia64_asr_i ==  -8) || (__ia64_asr_i == -16)))	\
-		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
-		: ia64_atomic_sub(__ia64_asr_i, v);			\
-})
-
-#define atomic64_sub_return(i,v)					\
-({									\
-	long __ia64_asr_i = (i);					\
-	(__builtin_constant_p(i)					\
-	 && (   (__ia64_asr_i ==   1) || (__ia64_asr_i ==   4)		\
-	     || (__ia64_asr_i ==   8) || (__ia64_asr_i ==  16)		\
-	     || (__ia64_asr_i ==  -1) || (__ia64_asr_i ==  -4)		\
-	     || (__ia64_asr_i ==  -8) || (__ia64_asr_i == -16)))	\
-		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
-		: ia64_atomic64_sub(__ia64_asr_i, v);			\
-})
-
 #define atomic_dec_return(v)		atomic_sub_return(1, (v))
 #define atomic_inc_return(v)		atomic_add_return(1, (v))
 #define atomic64_dec_return(v)		atomic64_sub_return(1, (v))
@@ -199,13 +183,13 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 #define atomic64_dec_and_test(v)	(atomic64_sub_return(1, (v)) == 0)
 #define atomic64_inc_and_test(v)	(atomic64_add_return(1, (v)) == 0)
 
-#define atomic_add(i,v)			atomic_add_return((i), (v))
-#define atomic_sub(i,v)			atomic_sub_return((i), (v))
+#define atomic_add(i,v)			(void)atomic_add_return((i), (v))
+#define atomic_sub(i,v)			(void)atomic_sub_return((i), (v))
 #define atomic_inc(v)			atomic_add(1, (v))
 #define atomic_dec(v)			atomic_sub(1, (v))
 
-#define atomic64_add(i,v)		atomic64_add_return((i), (v))
-#define atomic64_sub(i,v)		atomic64_sub_return((i), (v))
+#define atomic64_add(i,v)		(void)atomic64_add_return((i), (v))
+#define atomic64_sub(i,v)		(void)atomic64_sub_return((i), (v))
 #define atomic64_inc(v)			atomic64_add(1, (v))
 #define atomic64_dec(v)			atomic64_sub(1, (v))
 
