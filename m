Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaBDMW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:22:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43824 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBDMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:22:25 -0500
Date: Tue, 4 Feb 2014 13:22:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC][PATCH] ia64: Fix atomic ops vs memory barriers
Message-ID: <20140204122212.GO8874@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The IA64 SDM V1-4.4.7 describes the memory ordering rules of IA64.

It states that the cmpxchg.{rel,acq} really have release and acquire
semantics and that xchg has acquire semantics.

Despite this the ia64 atomic_t code says that all atomic ops are fully
serialized, and its smp_mb__{before,after}_atomic_{inc,dec} are
barrier().

OTOH the atomic bitops, which are identically implemented (using
cmpxchg.acq), state that they have acquire semantics and set
smp_mb__before_clear_bit() to smp_mb().

Now either the SDM and the bitops are right, which means the atomic_t,
cmpxchg() and xchg() implementations are wrong, or the SDM is wrong and
cmpxchg.acq is actually fully serialized after all and the bitops
implementation is wrong, not to mention there's a big fat comment
missing someplace.


The below patch assumes the SDM is right (TM), and fixes the atomic_t,
cmpxchg() and xchg() implementations by inserting a mf before the
cmpxchg.acq (or xchg).

This way loads/stores before the mf stay there, loads/stores after the
cmpxchg.acq also stay after and the entire thing acts as a fully
serialized op the way it is supposed to.

For things like ia64_atomic_sub() which is a cmpxchg.acq loop with an
unordered load in, it still works because there is a control dependency
upon the cmpxchg op, therefore the load cannot escape.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/ia64/include/asm/atomic.h       | 31 +++++++++++++++++++++++--------
 arch/ia64/include/asm/bitops.h       | 25 +++++++++++++++++++++++--
 arch/ia64/include/uapi/asm/cmpxchg.h | 13 ++++++++-----
 3 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 6e6fe1839f5d..5052fe7ce34b 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 #include <asm/intrinsics.h>
+#include <asm/barrier.h>
 
 
 #define ATOMIC_INIT(i)		{ (i) }
@@ -125,6 +126,7 @@ static __inline__ long atomic64_add_unless(atomic64_t *v, long a, long u)
 #define atomic_add_return(i,v)						\
 ({									\
 	int __ia64_aar_i = (i);						\
+ 	ia64_mf();							\
 	(__builtin_constant_p(i)					\
 	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
 	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
@@ -137,6 +139,7 @@ static __inline__ long atomic64_add_unless(atomic64_t *v, long a, long u)
 #define atomic64_add_return(i,v)					\
 ({									\
 	long __ia64_aar_i = (i);					\
+ 	ia64_mf();							\
 	(__builtin_constant_p(i)					\
 	 && (   (__ia64_aar_i ==  1) || (__ia64_aar_i ==   4)		\
 	     || (__ia64_aar_i ==  8) || (__ia64_aar_i ==  16)		\
@@ -162,7 +165,7 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 	return atomic64_add_return(i, v) < 0;
 }
 
-#define atomic_sub_return(i,v)						\
+#define __atomic_sub_return(i,v)					\
 ({									\
 	int __ia64_asr_i = (i);						\
 	(__builtin_constant_p(i)					\
@@ -174,7 +177,13 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 		: ia64_atomic_sub(__ia64_asr_i, v);			\
 })
 
-#define atomic64_sub_return(i,v)					\
+#define atomic_sub_return(i,v)						\
+({									\
+	ia64_mf();							\
+ 	__atomic_sub_return((i), (v));					\
+})
+ 	
+#define __atomic64_sub_return(i,v)					\
 ({									\
 	long __ia64_asr_i = (i);					\
 	(__builtin_constant_p(i)					\
@@ -186,6 +195,12 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 		: ia64_atomic64_sub(__ia64_asr_i, v);			\
 })
 
+#define atomic64_sub_return(i,v)					\
+({									\
+	ia64_mf();							\
+ 	__atomic64_sub_return((i), (v))					\
+})
+
 #define atomic_dec_return(v)		atomic_sub_return(1, (v))
 #define atomic_inc_return(v)		atomic_add_return(1, (v))
 #define atomic64_dec_return(v)		atomic64_sub_return(1, (v))
@@ -198,20 +213,20 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 #define atomic64_dec_and_test(v)	(atomic64_sub_return(1, (v)) == 0)
 #define atomic64_inc_and_test(v)	(atomic64_add_return(1, (v)) == 0)
 
-#define atomic_add(i,v)			atomic_add_return((i), (v))
-#define atomic_sub(i,v)			atomic_sub_return((i), (v))
+#define atomic_add(i,v)			(void)__atomic_add_return((i), (v))
+#define atomic_sub(i,v)			(void)__atomic_sub_return((i), (v))
 #define atomic_inc(v)			atomic_add(1, (v))
 #define atomic_dec(v)			atomic_sub(1, (v))
 
-#define atomic64_add(i,v)		atomic64_add_return((i), (v))
-#define atomic64_sub(i,v)		atomic64_sub_return((i), (v))
+#define atomic64_add(i,v)		(void)__atomic64_add_return((i), (v))
+#define atomic64_sub(i,v)		(void)__atomic64_sub_return((i), (v))
 #define atomic64_inc(v)			atomic64_add(1, (v))
 #define atomic64_dec(v)			atomic64_sub(1, (v))
 
 /* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__before_atomic_dec()	smp_mb()
 #define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	barrier()
 
 #endif /* _ASM_IA64_ATOMIC_H */
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index c27eccd33349..4655b905f142 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -69,7 +69,7 @@ __set_bit (int nr, volatile void *addr)
  * clear_bit() has "acquire" semantics.
  */
 #define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	do { /* skip */; } while (0)
+#define smp_mb__after_clear_bit()	barrier()
 
 /**
  * clear_bit - Clears a bit in memory
@@ -208,6 +208,8 @@ test_and_set_bit (int nr, volatile void *addr)
 	volatile __u32 *m;
 	CMPXCHG_BUGCHECK_DECL
 
+	smp_mb();
+
 	m = (volatile __u32 *) addr + (nr >> 5);
 	bit = 1 << (nr & 31);
 	do {
@@ -225,7 +227,22 @@ test_and_set_bit (int nr, volatile void *addr)
  *
  * This is the same as test_and_set_bit on ia64
  */
-#define test_and_set_bit_lock test_and_set_bit
+static __inline__ int
+test_and_set_bit_lock (int nr, volatile void *addr)
+{
+	__u32 bit, old, new;
+	volatile __u32 *m;
+	CMPXCHG_BUGCHECK_DECL
+
+	m = (volatile __u32 *) addr + (nr >> 5);
+	bit = 1 << (nr & 31);
+	do {
+		CMPXCHG_BUGCHECK(m);
+		old = *m;
+		new = old | bit;
+	} while (cmpxchg_acq(m, old, new) != old);
+	return (old & bit) != 0;
+}
 
 /**
  * __test_and_set_bit - Set a bit and return its old value
@@ -262,6 +279,8 @@ test_and_clear_bit (int nr, volatile void *addr)
 	volatile __u32 *m;
 	CMPXCHG_BUGCHECK_DECL
 
+	smp_mb();
+
 	m = (volatile __u32 *) addr + (nr >> 5);
 	mask = ~(1 << (nr & 31));
 	do {
@@ -307,6 +326,8 @@ test_and_change_bit (int nr, volatile void *addr)
 	volatile __u32 *m;
 	CMPXCHG_BUGCHECK_DECL
 
+	smp_mb();
+
 	m = (volatile __u32 *) addr + (nr >> 5);
 	bit = (1 << (nr & 31));
 	do {
diff --git a/arch/ia64/include/uapi/asm/cmpxchg.h b/arch/ia64/include/uapi/asm/cmpxchg.h
index 4f37dbbb8640..6fe5d6b7a739 100644
--- a/arch/ia64/include/uapi/asm/cmpxchg.h
+++ b/arch/ia64/include/uapi/asm/cmpxchg.h
@@ -53,7 +53,10 @@ extern void ia64_xchg_called_with_bad_pointer(void);
 })
 
 #define xchg(ptr, x)							\
-((__typeof__(*(ptr))) __xchg((unsigned long) (x), (ptr), sizeof(*(ptr))))
+({									\
+ 	ia64_mf();							\
+ 	(__typeof__(*(ptr))) __xchg((unsigned long) (x), (ptr), sizeof(*(ptr)))) \
+)}
 
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
@@ -119,11 +122,11 @@ extern long ia64_cmpxchg_called_with_bad_pointer(void);
 	ia64_cmpxchg(rel, (ptr), (o), (n), sizeof(*(ptr)))
 
 /* for compatibility with other platforms: */
-#define cmpxchg(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
-#define cmpxchg64(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
+#define cmpxchg(ptr, o, n)	({ ia64_mf(); cmpxchg_acq((ptr), (o), (n)); })
+#define cmpxchg64(ptr, o, n)	({ ia64_mf(); cmpxchg_acq((ptr), (o), (n)); })
 
-#define cmpxchg_local		cmpxchg
-#define cmpxchg64_local		cmpxchg64
+#define cmpxchg_local		cmpxchg_acq
+#define cmpxchg64_local		cmpxchg_acq
 
 #ifdef CONFIG_IA64_DEBUG_CMPXCHG
 # define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;
