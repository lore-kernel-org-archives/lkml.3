Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaEHOFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:05:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:43861 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaEHOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:45 -0400
Message-Id: <20140508135852.245224472@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 09/20] arch,ia64: Fold atomic_ops
References: <20140508135840.956784204@infradead.org>
Content-Disposition: inline; filename=peterz-ia64-atomic_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/ia64/include/asm/atomic.h |  182 ++++++++++++++++++-----------------------
 1 file changed, 83 insertions(+), 99 deletions(-)

Index: linux-2.6/arch/ia64/include/asm/atomic.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/atomic.h
+++ linux-2.6/arch/ia64/include/asm/atomic.h
@@ -27,61 +27,93 @@
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
+ATOMIC_OP(add, +)
+ATOMIC_OP(sub, -)
 
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic64_read(v);
-		new = old + i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old);
-	return new;
-}
+#undef ATOMIC_OP
 
-static __inline__ int
-ia64_atomic_sub (int i, atomic_t *v)
-{
-	__s32 old, new;
-	CMPXCHG_BUGCHECK_DECL
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
 
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic_read(v);
-		new = old - i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic_t)) != old);
-	return new;
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
 
-static __inline__ long
-ia64_atomic64_sub (__s64 i, atomic64_t *v)
-{
-	__s64 old, new;
-	CMPXCHG_BUGCHECK_DECL
+ATOMIC64_OP(add, +)
+ATOMIC64_OP(sub, -)
 
-	do {
-		CMPXCHG_BUGCHECK(v);
-		old = atomic64_read(v);
-		new = old - i;
-	} while (ia64_cmpxchg(acq, v, old, new, sizeof(atomic64_t)) != old);
-	return new;
-}
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
 
 #define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
@@ -123,30 +155,6 @@ static __inline__ long atomic64_add_unle
 
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
@@ -163,30 +171,6 @@ atomic64_add_negative (__s64 i, atomic64
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
@@ -199,13 +183,13 @@ atomic64_add_negative (__s64 i, atomic64
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
 


