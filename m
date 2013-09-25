Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912Ab3IYEPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:15:16 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49781 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3IYEPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:15:14 -0400
X-Spam-Score: -100.8
Message-ID: <52426310.4020204@asianux.com>
Date: Wed, 25 Sep 2013 12:14:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] tile: include: asm: use 'long long' instead of 'u64' for
 atomic64_t and its related functions
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic* value is signed value, and atomic* functions need also process
signed value (parameter value, and return value), so use 'long long'
instead of 'u64'.

After replacement, it will also fix a bug for atomic64_add_negative():
"u64 is never less than 0".

The modifications are:

  in vim, use "1,% s/\<u64\>/long long/g" command.
  remove redundant '__aligned(8)' and a type case '(u64 *)'.
  be sure of 80 (and macro '\') columns limitation after replacement.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/tile/include/asm/atomic.h    |    5 +++--
 arch/tile/include/asm/atomic_32.h |   27 +++++++++++++++------------
 arch/tile/include/asm/cmpxchg.h   |   28 +++++++++++++++++-----------
 arch/tile/lib/atomic_32.c         |    8 ++++----
 4 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index d385eaa..7097984 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -166,7 +166,7 @@ static inline int atomic_cmpxchg(atomic_t *v, int o, int n)
  *
  * Atomically sets @v to @i and returns old @v
  */
-static inline u64 atomic64_xchg(atomic64_t *v, u64 n)
+static inline long long atomic64_xchg(atomic64_t *v, long long n)
 {
 	return xchg64(&v->counter, n);
 }
@@ -180,7 +180,8 @@ static inline u64 atomic64_xchg(atomic64_t *v, u64 n)
  * Atomically checks if @v holds @o and replaces it with @n if so.
  * Returns the old value at @v.
  */
-static inline u64 atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
+static inline long long atomic64_cmpxchg(atomic64_t *v, long long o,
+					long long n)
 {
 	return cmpxchg64(&v->counter, o, n);
 }
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index 0d0395b..0b613f9 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -80,7 +80,7 @@ static inline void atomic_set(atomic_t *v, int n)
 /* A 64bit atomic type */
 
 typedef struct {
-	u64 __aligned(8) counter;
+	long long counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(val) { (val) }
@@ -91,14 +91,14 @@ typedef struct {
  *
  * Atomically reads the value of @v.
  */
-static inline u64 atomic64_read(const atomic64_t *v)
+static inline long long atomic64_read(const atomic64_t *v)
 {
 	/*
 	 * Requires an atomic op to read both 32-bit parts consistently.
 	 * Casting away const is safe since the atomic support routines
 	 * do not write to memory if the value has not been modified.
 	 */
-	return _atomic64_xchg_add((u64 *)&v->counter, 0);
+	return _atomic64_xchg_add(&v->counter, 0);
 }
 
 /**
@@ -108,7 +108,7 @@ static inline u64 atomic64_read(const atomic64_t *v)
  *
  * Atomically adds @i to @v.
  */
-static inline void atomic64_add(u64 i, atomic64_t *v)
+static inline void atomic64_add(long long i, atomic64_t *v)
 {
 	_atomic64_xchg_add(&v->counter, i);
 }
@@ -120,7 +120,7 @@ static inline void atomic64_add(u64 i, atomic64_t *v)
  *
  * Atomically adds @i to @v and returns @i + @v
  */
-static inline u64 atomic64_add_return(u64 i, atomic64_t *v)
+static inline long long atomic64_add_return(long long i, atomic64_t *v)
 {
 	smp_mb();  /* barrier for proper semantics */
 	return _atomic64_xchg_add(&v->counter, i) + i;
@@ -135,7 +135,8 @@ static inline u64 atomic64_add_return(u64 i, atomic64_t *v)
  * Atomically adds @a to @v, so long as @v was not already @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
+static inline long long atomic64_add_unless(atomic64_t *v, long long a,
+					long long u)
 {
 	smp_mb();  /* barrier for proper semantics */
 	return _atomic64_xchg_add_unless(&v->counter, a, u) != u;
@@ -151,7 +152,7 @@ static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
  * atomic64_set() can't be just a raw store, since it would be lost if it
  * fell between the load and store of one of the other atomic ops.
  */
-static inline void atomic64_set(atomic64_t *v, u64 n)
+static inline void atomic64_set(atomic64_t *v, long long n)
 {
 	_atomic64_xchg(&v->counter, n);
 }
@@ -236,11 +237,13 @@ extern struct __get_user __atomic_xchg_add_unless(volatile int *p,
 extern struct __get_user __atomic_or(volatile int *p, int *lock, int n);
 extern struct __get_user __atomic_andn(volatile int *p, int *lock, int n);
 extern struct __get_user __atomic_xor(volatile int *p, int *lock, int n);
-extern u64 __atomic64_cmpxchg(volatile u64 *p, int *lock, u64 o, u64 n);
-extern u64 __atomic64_xchg(volatile u64 *p, int *lock, u64 n);
-extern u64 __atomic64_xchg_add(volatile u64 *p, int *lock, u64 n);
-extern u64 __atomic64_xchg_add_unless(volatile u64 *p,
-				      int *lock, u64 o, u64 n);
+extern long long __atomic64_cmpxchg(volatile long long *p, int *lock,
+					long long o, long long n);
+extern long long __atomic64_xchg(volatile long long *p, int *lock, long long n);
+extern long long __atomic64_xchg_add(volatile long long *p, int *lock,
+					long long n);
+extern long long __atomic64_xchg_add_unless(volatile long long *p,
+					int *lock, long long o, long long n);
 
 /* Return failure from the atomic wrappers. */
 struct __get_user __atomic_bad_address(int __user *addr);
diff --git a/arch/tile/include/asm/cmpxchg.h b/arch/tile/include/asm/cmpxchg.h
index 4001d5e..0ccda3c 100644
--- a/arch/tile/include/asm/cmpxchg.h
+++ b/arch/tile/include/asm/cmpxchg.h
@@ -35,10 +35,10 @@ int _atomic_xchg(int *ptr, int n);
 int _atomic_xchg_add(int *v, int i);
 int _atomic_xchg_add_unless(int *v, int a, int u);
 int _atomic_cmpxchg(int *ptr, int o, int n);
-u64 _atomic64_xchg(u64 *v, u64 n);
-u64 _atomic64_xchg_add(u64 *v, u64 i);
-u64 _atomic64_xchg_add_unless(u64 *v, u64 a, u64 u);
-u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n);
+long long _atomic64_xchg(long long *v, long long n);
+long long _atomic64_xchg_add(long long *v, long long i);
+long long _atomic64_xchg_add_unless(long long *v, long long a, long long u);
+long long _atomic64_cmpxchg(long long *v, long long o, long long n);
 
 #define xchg(ptr, n)							\
 	({								\
@@ -53,7 +53,8 @@ u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n);
 		if (sizeof(*(ptr)) != 4)				\
 			__cmpxchg_called_with_bad_pointer();		\
 		smp_mb();						\
-		(typeof(*(ptr)))_atomic_cmpxchg((int *)ptr, (int)o, (int)n); \
+		(typeof(*(ptr)))_atomic_cmpxchg((int *)ptr, (int)o,	\
+						(int)n);		\
 	})
 
 #define xchg64(ptr, n)							\
@@ -61,7 +62,8 @@ u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n);
 		if (sizeof(*(ptr)) != 8)				\
 			__xchg_called_with_bad_pointer();		\
 		smp_mb();						\
-		(typeof(*(ptr)))_atomic64_xchg((u64 *)(ptr), (u64)(n));	\
+		(typeof(*(ptr)))_atomic64_xchg((long long *)(ptr),	\
+						(long long)(n));	\
 	})
 
 #define cmpxchg64(ptr, o, n)						\
@@ -69,7 +71,8 @@ u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n);
 		if (sizeof(*(ptr)) != 8)				\
 			__cmpxchg_called_with_bad_pointer();		\
 		smp_mb();						\
-		(typeof(*(ptr)))_atomic64_cmpxchg((u64 *)ptr, (u64)o, (u64)n); \
+		(typeof(*(ptr)))_atomic64_cmpxchg((long long *)ptr,	\
+					(long long)o, (long long)n);	\
 	})
 
 #else
@@ -81,10 +84,11 @@ u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n);
 		switch (sizeof(*(ptr))) {				\
 		case 4:							\
 			__x = (typeof(__x))(unsigned long)		\
-				__insn_exch4((ptr), (u32)(unsigned long)(n)); \
+				__insn_exch4((ptr),			\
+					(u32)(unsigned long)(n));	\
 			break;						\
 		case 8:							\
-			__x = (typeof(__x))			\
+			__x = (typeof(__x))				\
 				__insn_exch((ptr), (unsigned long)(n));	\
 			break;						\
 		default:						\
@@ -103,10 +107,12 @@ u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n);
 		switch (sizeof(*(ptr))) {				\
 		case 4:							\
 			__x = (typeof(__x))(unsigned long)		\
-				__insn_cmpexch4((ptr), (u32)(unsigned long)(n)); \
+				__insn_cmpexch4((ptr),			\
+					(u32)(unsigned long)(n));	\
 			break;						\
 		case 8:							\
-			__x = (typeof(__x))__insn_cmpexch((ptr), (u64)(n)); \
+			__x = (typeof(__x))__insn_cmpexch((ptr),	\
+						(long long)(n));	\
 			break;						\
 		default:						\
 			__cmpxchg_called_with_bad_pointer();		\
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index 759efa3..c89b211 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -107,19 +107,19 @@ unsigned long _atomic_xor(volatile unsigned long *p, unsigned long mask)
 EXPORT_SYMBOL(_atomic_xor);
 
 
-u64 _atomic64_xchg(u64 *v, u64 n)
+long long _atomic64_xchg(long long *v, long long n)
 {
 	return __atomic64_xchg(v, __atomic_setup(v), n);
 }
 EXPORT_SYMBOL(_atomic64_xchg);
 
-u64 _atomic64_xchg_add(u64 *v, u64 i)
+long long _atomic64_xchg_add(long long *v, long long i)
 {
 	return __atomic64_xchg_add(v, __atomic_setup(v), i);
 }
 EXPORT_SYMBOL(_atomic64_xchg_add);
 
-u64 _atomic64_xchg_add_unless(u64 *v, u64 a, u64 u)
+long long _atomic64_xchg_add_unless(long long *v, long long a, long long u)
 {
 	/*
 	 * Note: argument order is switched here since it is easier
@@ -130,7 +130,7 @@ u64 _atomic64_xchg_add_unless(u64 *v, u64 a, u64 u)
 }
 EXPORT_SYMBOL(_atomic64_xchg_add_unless);
 
-u64 _atomic64_cmpxchg(u64 *v, u64 o, u64 n)
+long long _atomic64_cmpxchg(long long *v, long long o, long long n)
 {
 	return __atomic64_cmpxchg(v, __atomic_setup(v), o, n);
 }
-- 
1.7.7.6
