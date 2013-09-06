Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3IFNKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:10:17 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50367 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3IFNKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:10:15 -0400
Message-ID: <201309061310.r86DA9OU025982@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 6 Sep 2013 08:56:45 -0400
Subject: [PATCH] tile: rework <asm/cmpxchg.h>
To: kbuild test robot <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, <kbuild-all@01.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20130904163122.GH3996@quack.suse.cz>
References: <52274d0f.jLRsYGUvhePuFG6l%fengguang.wu@intel.com>
  <20130904163122.GH3996@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macrology in cmpxchg.h was designed to allow arbitrary pointer
and integer values to be passed through the routines.  To support
cmpxchg() on 64-bit values on the 32-bit tilepro architecture, we
used the idiom "(typeof(val))(typeof(val-val))".  This way, in the
"size 8" branch of the switch, when the underlying cmpxchg routine
returns a 64-bit quantity, we cast it first to a typeof(val-val)
quantity (i.e. size_t if "val" is a pointer) with no warnings about
casting between pointers and integers of different sizes, then cast
onwards to typeof(val), again with no warnings.  If val is not a
pointer type, the additional cast is a no-op.  We can't replace the
typeof(val-val) cast with (for example) unsigned long, since then if
"val" is really a 64-bit type, we cast away the high bits.

HOWEVER, this fails with current gcc (through 4.7 at least) if "val"
is a pointer to an incomplete type.  Unfortunately gcc isn't smart
enough to realize that "val - val" will always be a size_t type
even if it's an incomplete type pointer.

Accordingly, I've reworked the way we handle the casting.  We have
given up the ability to use cmpxchg() on 64-bit values on tilepro,
which is OK in the kernel since we should use cmpxchg64() explicitly
on such values anyway.  As a result, I can just use simple "unsigned
long" casts internally.

As I reworked it, I realized it would be cleaner to move the
architecture-specific conditionals for cmpxchg and xchg out of the
atomic.h headers and into cmpxchg, and then use the cmpxchg() and
xchg() primitives directly in atomic.h and elsewhere.  This allowed
the cmpxchg.h header to stand on its own without relying on the
implicit include of it that is performed by <asm/atomic.h>.
It also allowed collapsing the atomic_xchg/atomic_cmpxchg routines
from atomic_{32,64}.h into atomic.h.

I improved the tests that guard the allowed size of the arguments
to the routines to use a __compiletime_error() test.  (By avoiding
the use of BUILD_BUG, I could include cmpxchg.h into bitops.h as
well and use the macros there, which is otherwise impossible due
to include order dependency issues.)

The tilepro _atomic_xxx internal methods were previously set up to
take atomic_t and atomic64_t arguments, which isn't as convenient
with the new model, so I modified them to take int or u64 arguments,
which is consistent with how they used the arguments internally
anyway, so provided some nice simplification there too.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/atomic.h    | 52 +++++++++++++++++++++
 arch/tile/include/asm/atomic_32.h | 85 ++++------------------------------
 arch/tile/include/asm/atomic_64.h | 42 +----------------
 arch/tile/include/asm/bitops_32.h |  2 +-
 arch/tile/include/asm/bitops_64.h |  8 ++--
 arch/tile/include/asm/cmpxchg.h   | 97 +++++++++++++++++++++++++++++----------
 arch/tile/lib/atomic_32.c         | 34 +++++++-------
 7 files changed, 156 insertions(+), 164 deletions(-)

diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index e71387a..9e24585 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -114,6 +114,32 @@ static inline int atomic_read(const atomic_t *v)
 #define atomic_inc_and_test(v)		(atomic_inc_return(v) == 0)
 
 /**
+ * atomic_xchg - atomically exchange contents of memory with a new value
+ * @v: pointer of type atomic_t
+ * @i: integer value to store in memory
+ *
+ * Atomically sets @v to @i and returns old @v
+ */
+static inline int atomic_xchg(atomic_t *v, int n)
+{
+	return xchg(&v->counter, n);
+}
+
+/**
+ * atomic_cmpxchg - atomically exchange contents of memory if it matches
+ * @v: pointer of type atomic_t
+ * @o: old value that memory should have
+ * @n: new value to write to memory if it matches
+ *
+ * Atomically checks if @v holds @o and replaces it with @n if so.
+ * Returns the old value at @v.
+ */
+static inline int atomic_cmpxchg(atomic_t *v, int o, int n)
+{
+	return cmpxchg(&v->counter, o, n);
+}
+
+/**
  * atomic_add_negative - add and test if negative
  * @v: pointer of type atomic_t
  * @i: integer value to add
@@ -133,6 +159,32 @@ static inline int atomic_read(const atomic_t *v)
 
 #ifndef __ASSEMBLY__
 
+/**
+ * atomic64_xchg - atomically exchange contents of memory with a new value
+ * @v: pointer of type atomic64_t
+ * @i: integer value to store in memory
+ *
+ * Atomically sets @v to @i and returns old @v
+ */
+static inline u64 atomic64_xchg(atomic64_t *v, u64 n)
+{
+	return xchg64(&v->counter, n);
+}
+
+/**
+ * atomic64_cmpxchg - atomically exchange contents of memory if it matches
+* @v: pointer of type atomic64_t
++ * @o: old value that memory should have
+ * @n: new value to write to memory if it matches
+ *
+ * Atomically checks if @v holds @o and replaces it with @n if so.
+ * Returns the old value at @v.
+ */
+static inline u64 atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
+{
+	return cmpxchg64(&v->counter, o, n);
+}
+
 static inline long long atomic64_dec_if_positive(atomic64_t *v)
 {
 	long long c, old, dec;
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index 96156f5..0d0395b 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -22,40 +22,6 @@
 
 #ifndef __ASSEMBLY__
 
-/* Tile-specific routines to support <linux/atomic.h>. */
-int _atomic_xchg(atomic_t *v, int n);
-int _atomic_xchg_add(atomic_t *v, int i);
-int _atomic_xchg_add_unless(atomic_t *v, int a, int u);
-int _atomic_cmpxchg(atomic_t *v, int o, int n);
-
-/**
- * atomic_xchg - atomically exchange contents of memory with a new value
- * @v: pointer of type atomic_t
- * @i: integer value to store in memory
- *
- * Atomically sets @v to @i and returns old @v
- */
-static inline int atomic_xchg(atomic_t *v, int n)
-{
-	smp_mb();  /* barrier for proper semantics */
-	return _atomic_xchg(v, n);
-}
-
-/**
- * atomic_cmpxchg - atomically exchange contents of memory if it matches
- * @v: pointer of type atomic_t
- * @o: old value that memory should have
- * @n: new value to write to memory if it matches
- *
- * Atomically checks if @v holds @o and replaces it with @n if so.
- * Returns the old value at @v.
- */
-static inline int atomic_cmpxchg(atomic_t *v, int o, int n)
-{
-	smp_mb();  /* barrier for proper semantics */
-	return _atomic_cmpxchg(v, o, n);
-}
-
 /**
  * atomic_add - add integer to atomic variable
  * @i: integer value to add
@@ -65,7 +31,7 @@ static inline int atomic_cmpxchg(atomic_t *v, int o, int n)
  */
 static inline void atomic_add(int i, atomic_t *v)
 {
-	_atomic_xchg_add(v, i);
+	_atomic_xchg_add(&v->counter, i);
 }
 
 /**
@@ -78,7 +44,7 @@ static inline void atomic_add(int i, atomic_t *v)
 static inline int atomic_add_return(int i, atomic_t *v)
 {
 	smp_mb();  /* barrier for proper semantics */
-	return _atomic_xchg_add(v, i) + i;
+	return _atomic_xchg_add(&v->counter, i) + i;
 }
 
 /**
@@ -93,7 +59,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
 static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	smp_mb();  /* barrier for proper semantics */
-	return _atomic_xchg_add_unless(v, a, u);
+	return _atomic_xchg_add_unless(&v->counter, a, u);
 }
 
 /**
@@ -108,7 +74,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
  */
 static inline void atomic_set(atomic_t *v, int n)
 {
-	_atomic_xchg(v, n);
+	_atomic_xchg(&v->counter, n);
 }
 
 /* A 64bit atomic type */
@@ -119,11 +85,6 @@ typedef struct {
 
 #define ATOMIC64_INIT(val) { (val) }
 
-u64 _atomic64_xchg(atomic64_t *v, u64 n);
-u64 _atomic64_xchg_add(atomic64_t *v, u64 i);
-u64 _atomic64_xchg_add_unless(atomic64_t *v, u64 a, u64 u);
-u64 _atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n);
-
 /**
  * atomic64_read - read atomic variable
  * @v: pointer of type atomic64_t
@@ -137,35 +98,7 @@ static inline u64 atomic64_read(const atomic64_t *v)
 	 * Casting away const is safe since the atomic support routines
 	 * do not write to memory if the value has not been modified.
 	 */
-	return _atomic64_xchg_add((atomic64_t *)v, 0);
-}
-
-/**
- * atomic64_xchg - atomically exchange contents of memory with a new value
- * @v: pointer of type atomic64_t
- * @i: integer value to store in memory
- *
- * Atomically sets @v to @i and returns old @v
- */
-static inline u64 atomic64_xchg(atomic64_t *v, u64 n)
-{
-	smp_mb();  /* barrier for proper semantics */
-	return _atomic64_xchg(v, n);
-}
-
-/**
- * atomic64_cmpxchg - atomically exchange contents of memory if it matches
- * @v: pointer of type atomic64_t
- * @o: old value that memory should have
- * @n: new value to write to memory if it matches
- *
- * Atomically checks if @v holds @o and replaces it with @n if so.
- * Returns the old value at @v.
- */
-static inline u64 atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
-{
-	smp_mb();  /* barrier for proper semantics */
-	return _atomic64_cmpxchg(v, o, n);
+	return _atomic64_xchg_add((u64 *)&v->counter, 0);
 }
 
 /**
@@ -177,7 +110,7 @@ static inline u64 atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
  */
 static inline void atomic64_add(u64 i, atomic64_t *v)
 {
-	_atomic64_xchg_add(v, i);
+	_atomic64_xchg_add(&v->counter, i);
 }
 
 /**
@@ -190,7 +123,7 @@ static inline void atomic64_add(u64 i, atomic64_t *v)
 static inline u64 atomic64_add_return(u64 i, atomic64_t *v)
 {
 	smp_mb();  /* barrier for proper semantics */
-	return _atomic64_xchg_add(v, i) + i;
+	return _atomic64_xchg_add(&v->counter, i) + i;
 }
 
 /**
@@ -205,7 +138,7 @@ static inline u64 atomic64_add_return(u64 i, atomic64_t *v)
 static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
 {
 	smp_mb();  /* barrier for proper semantics */
-	return _atomic64_xchg_add_unless(v, a, u) != u;
+	return _atomic64_xchg_add_unless(&v->counter, a, u) != u;
 }
 
 /**
@@ -220,7 +153,7 @@ static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
  */
 static inline void atomic64_set(atomic64_t *v, u64 n)
 {
-	_atomic64_xchg(v, n);
+	_atomic64_xchg(&v->counter, n);
 }
 
 #define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
diff --git a/arch/tile/include/asm/atomic_64.h b/arch/tile/include/asm/atomic_64.h
index f4500c6..ad220ee 100644
--- a/arch/tile/include/asm/atomic_64.h
+++ b/arch/tile/include/asm/atomic_64.h
@@ -32,25 +32,6 @@
  * on any routine which updates memory and returns a value.
  */
 
-static inline int atomic_cmpxchg(atomic_t *v, int o, int n)
-{
-	int val;
-	__insn_mtspr(SPR_CMPEXCH_VALUE, o);
-	smp_mb();  /* barrier for proper semantics */
-	val = __insn_cmpexch4((void *)&v->counter, n);
-	smp_mb();  /* barrier for proper semantics */
-	return val;
-}
-
-static inline int atomic_xchg(atomic_t *v, int n)
-{
-	int val;
-	smp_mb();  /* barrier for proper semantics */
-	val = __insn_exch4((void *)&v->counter, n);
-	smp_mb();  /* barrier for proper semantics */
-	return val;
-}
-
 static inline void atomic_add(int i, atomic_t *v)
 {
 	__insn_fetchadd4((void *)&v->counter, i);
@@ -72,7 +53,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 		if (oldval == u)
 			break;
 		guess = oldval;
-		oldval = atomic_cmpxchg(v, guess, guess + a);
+		oldval = cmpxchg(&v->counter, guess, guess + a);
 	} while (guess != oldval);
 	return oldval;
 }
@@ -84,25 +65,6 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic64_read(v)		((v)->counter)
 #define atomic64_set(v, i) ((v)->counter = (i))
 
-static inline long atomic64_cmpxchg(atomic64_t *v, long o, long n)
-{
-	long val;
-	smp_mb();  /* barrier for proper semantics */
-	__insn_mtspr(SPR_CMPEXCH_VALUE, o);
-	val = __insn_cmpexch((void *)&v->counter, n);
-	smp_mb();  /* barrier for proper semantics */
-	return val;
-}
-
-static inline long atomic64_xchg(atomic64_t *v, long n)
-{
-	long val;
-	smp_mb();  /* barrier for proper semantics */
-	val = __insn_exch((void *)&v->counter, n);
-	smp_mb();  /* barrier for proper semantics */
-	return val;
-}
-
 static inline void atomic64_add(long i, atomic64_t *v)
 {
 	__insn_fetchadd((void *)&v->counter, i);
@@ -124,7 +86,7 @@ static inline long atomic64_add_unless(atomic64_t *v, long a, long u)
 		if (oldval == u)
 			break;
 		guess = oldval;
-		oldval = atomic64_cmpxchg(v, guess, guess + a);
+		oldval = cmpxchg(&v->counter, guess, guess + a);
 	} while (guess != oldval);
 	return oldval != u;
 }
diff --git a/arch/tile/include/asm/bitops_32.h b/arch/tile/include/asm/bitops_32.h
index ddc4c1e..386865a 100644
--- a/arch/tile/include/asm/bitops_32.h
+++ b/arch/tile/include/asm/bitops_32.h
@@ -16,7 +16,7 @@
 #define _ASM_TILE_BITOPS_32_H
 
 #include <linux/compiler.h>
-#include <linux/atomic.h>
+#include <asm/barrier.h>
 
 /* Tile-specific routines to support <asm/bitops.h>. */
 unsigned long _atomic_or(volatile unsigned long *p, unsigned long mask);
diff --git a/arch/tile/include/asm/bitops_64.h b/arch/tile/include/asm/bitops_64.h
index 60b87ee..ad34cd0 100644
--- a/arch/tile/include/asm/bitops_64.h
+++ b/arch/tile/include/asm/bitops_64.h
@@ -16,7 +16,7 @@
 #define _ASM_TILE_BITOPS_64_H
 
 #include <linux/compiler.h>
-#include <linux/atomic.h>
+#include <asm/cmpxchg.h>
 
 /* See <asm/bitops.h> for API comments. */
 
@@ -44,8 +44,7 @@ static inline void change_bit(unsigned nr, volatile unsigned long *addr)
 	oldval = *addr;
 	do {
 		guess = oldval;
-		oldval = atomic64_cmpxchg((atomic64_t *)addr,
-					  guess, guess ^ mask);
+		oldval = cmpxchg(addr, guess, guess ^ mask);
 	} while (guess != oldval);
 }
 
@@ -90,8 +89,7 @@ static inline int test_and_change_bit(unsigned nr,
 	oldval = *addr;
 	do {
 		guess = oldval;
-		oldval = atomic64_cmpxchg((atomic64_t *)addr,
-					  guess, guess ^ mask);
+		oldval = cmpxchg(addr, guess, guess ^ mask);
 	} while (guess != oldval);
 	return (oldval & mask) != 0;
 }
diff --git a/arch/tile/include/asm/cmpxchg.h b/arch/tile/include/asm/cmpxchg.h
index 1da5bfb..4001d5e 100644
--- a/arch/tile/include/asm/cmpxchg.h
+++ b/arch/tile/include/asm/cmpxchg.h
@@ -20,59 +20,108 @@
 
 #ifndef __ASSEMBLY__
 
-/* Nonexistent functions intended to cause link errors. */
-extern unsigned long __xchg_called_with_bad_pointer(void);
-extern unsigned long __cmpxchg_called_with_bad_pointer(void);
+#include <asm/barrier.h>
 
-#define xchg(ptr, x)							\
+/* Nonexistent functions intended to cause compile errors. */
+extern void __xchg_called_with_bad_pointer(void)
+	__compiletime_error("Bad argument size for xchg");
+extern void __cmpxchg_called_with_bad_pointer(void)
+	__compiletime_error("Bad argument size for cmpxchg");
+
+#ifndef __tilegx__
+
+/* Note the _atomic_xxx() routines include a final mb(). */
+int _atomic_xchg(int *ptr, int n);
+int _atomic_xchg_add(int *v, int i);
+int _atomic_xchg_add_unless(int *v, int a, int u);
+int _atomic_cmpxchg(int *ptr, int o, int n);
+u64 _atomic64_xchg(u64 *v, u64 n);
+u64 _atomic64_xchg_add(u64 *v, u64 i);
+u64 _atomic64_xchg_add_unless(u64 *v, u64 a, u64 u);
+u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n);
+
+#define xchg(ptr, n)							\
+	({								\
+		if (sizeof(*(ptr)) != 4)				\
+			__xchg_called_with_bad_pointer();		\
+		smp_mb();						\
+		(typeof(*(ptr)))_atomic_xchg((int *)(ptr), (int)(n));	\
+	})
+
+#define cmpxchg(ptr, o, n)						\
+	({								\
+		if (sizeof(*(ptr)) != 4)				\
+			__cmpxchg_called_with_bad_pointer();		\
+		smp_mb();						\
+		(typeof(*(ptr)))_atomic_cmpxchg((int *)ptr, (int)o, (int)n); \
+	})
+
+#define xchg64(ptr, n)							\
+	({								\
+		if (sizeof(*(ptr)) != 8)				\
+			__xchg_called_with_bad_pointer();		\
+		smp_mb();						\
+		(typeof(*(ptr)))_atomic64_xchg((u64 *)(ptr), (u64)(n));	\
+	})
+
+#define cmpxchg64(ptr, o, n)						\
+	({								\
+		if (sizeof(*(ptr)) != 8)				\
+			__cmpxchg_called_with_bad_pointer();		\
+		smp_mb();						\
+		(typeof(*(ptr)))_atomic64_cmpxchg((u64 *)ptr, (u64)o, (u64)n); \
+	})
+
+#else
+
+#define xchg(ptr, n)							\
 	({								\
 		typeof(*(ptr)) __x;					\
+		smp_mb();						\
 		switch (sizeof(*(ptr))) {				\
 		case 4:							\
-			__x = (typeof(__x))(typeof(__x-__x))atomic_xchg( \
-				(atomic_t *)(ptr),			\
-				(u32)(typeof((x)-(x)))(x));		\
+			__x = (typeof(__x))(unsigned long)		\
+				__insn_exch4((ptr), (u32)(unsigned long)(n)); \
 			break;						\
 		case 8:							\
-			__x = (typeof(__x))(typeof(__x-__x))atomic64_xchg( \
-				(atomic64_t *)(ptr),			\
-				(u64)(typeof((x)-(x)))(x));		\
+			__x = (typeof(__x))			\
+				__insn_exch((ptr), (unsigned long)(n));	\
 			break;						\
 		default:						\
 			__xchg_called_with_bad_pointer();		\
+			break;						\
 		}							\
+		smp_mb();						\
 		__x;							\
 	})
 
 #define cmpxchg(ptr, o, n)						\
 	({								\
 		typeof(*(ptr)) __x;					\
+		__insn_mtspr(SPR_CMPEXCH_VALUE, (unsigned long)(o));	\
+		smp_mb();						\
 		switch (sizeof(*(ptr))) {				\
 		case 4:							\
-			__x = (typeof(__x))(typeof(__x-__x))atomic_cmpxchg( \
-				(atomic_t *)(ptr),			\
-				(u32)(typeof((o)-(o)))(o),		\
-				(u32)(typeof((n)-(n)))(n));		\
+			__x = (typeof(__x))(unsigned long)		\
+				__insn_cmpexch4((ptr), (u32)(unsigned long)(n)); \
 			break;						\
 		case 8:							\
-			__x = (typeof(__x))(typeof(__x-__x))atomic64_cmpxchg( \
-				(atomic64_t *)(ptr),			\
-				(u64)(typeof((o)-(o)))(o),		\
-				(u64)(typeof((n)-(n)))(n));		\
+			__x = (typeof(__x))__insn_cmpexch((ptr), (u64)(n)); \
 			break;						\
 		default:						\
 			__cmpxchg_called_with_bad_pointer();		\
+			break;						\
 		}							\
+		smp_mb();						\
 		__x;							\
 	})
 
-#define tas(ptr) (xchg((ptr), 1))
+#define xchg64 xchg
+#define cmpxchg64 cmpxchg
 
-#define cmpxchg64(ptr, o, n)						\
-({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg((ptr), (o), (n));					\
-})
+#endif
+
+#define tas(ptr) xchg((ptr), 1)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index 5d91d18..759efa3 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -59,33 +59,32 @@ static inline int *__atomic_setup(volatile void *v)
 	return __atomic_hashed_lock(v);
 }
 
-int _atomic_xchg(atomic_t *v, int n)
+int _atomic_xchg(int *v, int n)
 {
-	return __atomic_xchg(&v->counter, __atomic_setup(v), n).val;
+	return __atomic_xchg(v, __atomic_setup(v), n).val;
 }
 EXPORT_SYMBOL(_atomic_xchg);
 
-int _atomic_xchg_add(atomic_t *v, int i)
+int _atomic_xchg_add(int *v, int i)
 {
-	return __atomic_xchg_add(&v->counter, __atomic_setup(v), i).val;
+	return __atomic_xchg_add(v, __atomic_setup(v), i).val;
 }
 EXPORT_SYMBOL(_atomic_xchg_add);
 
-int _atomic_xchg_add_unless(atomic_t *v, int a, int u)
+int _atomic_xchg_add_unless(int *v, int a, int u)
 {
 	/*
 	 * Note: argument order is switched here since it is easier
 	 * to use the first argument consistently as the "old value"
 	 * in the assembly, as is done for _atomic_cmpxchg().
 	 */
-	return __atomic_xchg_add_unless(&v->counter, __atomic_setup(v), u, a)
-		.val;
+	return __atomic_xchg_add_unless(v, __atomic_setup(v), u, a).val;
 }
 EXPORT_SYMBOL(_atomic_xchg_add_unless);
 
-int _atomic_cmpxchg(atomic_t *v, int o, int n)
+int _atomic_cmpxchg(int *v, int o, int n)
 {
-	return __atomic_cmpxchg(&v->counter, __atomic_setup(v), o, n).val;
+	return __atomic_cmpxchg(v, __atomic_setup(v), o, n).val;
 }
 EXPORT_SYMBOL(_atomic_cmpxchg);
 
@@ -108,33 +107,32 @@ unsigned long _atomic_xor(volatile unsigned long *p, unsigned long mask)
 EXPORT_SYMBOL(_atomic_xor);
 
 
-u64 _atomic64_xchg(atomic64_t *v, u64 n)
+u64 _atomic64_xchg(u64 *v, u64 n)
 {
-	return __atomic64_xchg(&v->counter, __atomic_setup(v), n);
+	return __atomic64_xchg(v, __atomic_setup(v), n);
 }
 EXPORT_SYMBOL(_atomic64_xchg);
 
-u64 _atomic64_xchg_add(atomic64_t *v, u64 i)
+u64 _atomic64_xchg_add(u64 *v, u64 i)
 {
-	return __atomic64_xchg_add(&v->counter, __atomic_setup(v), i);
+	return __atomic64_xchg_add(v, __atomic_setup(v), i);
 }
 EXPORT_SYMBOL(_atomic64_xchg_add);
 
-u64 _atomic64_xchg_add_unless(atomic64_t *v, u64 a, u64 u)
+u64 _atomic64_xchg_add_unless(u64 *v, u64 a, u64 u)
 {
 	/*
 	 * Note: argument order is switched here since it is easier
 	 * to use the first argument consistently as the "old value"
 	 * in the assembly, as is done for _atomic_cmpxchg().
 	 */
-	return __atomic64_xchg_add_unless(&v->counter, __atomic_setup(v),
-					  u, a);
+	return __atomic64_xchg_add_unless(v, __atomic_setup(v), u, a);
 }
 EXPORT_SYMBOL(_atomic64_xchg_add_unless);
 
-u64 _atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
+u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n)
 {
-	return __atomic64_cmpxchg(&v->counter, __atomic_setup(v), o, n);
+	return __atomic64_cmpxchg(v, __atomic_setup(v), o, n);
 }
 EXPORT_SYMBOL(_atomic64_cmpxchg);
 
-- 
1.8.3.1

