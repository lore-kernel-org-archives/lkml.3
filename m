Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3IYQi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:38:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3IYQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:38:23 -0400
Date: Wed, 25 Sep 2013 09:37:48 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-0mtn9siwbeo1d33bap1422se@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] x86:
  Use asm goto to implement better modify_and_test() functions
Git-Commit-ID: 0c44c2d0f459cd7e275242b72f500137c4fa834d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:37:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c44c2d0f459cd7e275242b72f500137c4fa834d
Gitweb:     http://git.kernel.org/tip/0c44c2d0f459cd7e275242b72f500137c4fa834d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 11 Sep 2013 15:19:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 13:53:08 +0200

x86: Use asm goto to implement better modify_and_test() functions

Linus suggested using asm goto to get rid of the typical SETcc + TEST
instruction pair -- which also clobbers an extra register -- for our
typical modify_and_test() functions.

Because asm goto doesn't allow output fields it has to include an
unconditinal memory clobber when it changes a memory variable to force
a reload.

Luckily all atomic ops already imply a compiler barrier to go along
with their memory barrier semantics.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-0mtn9siwbeo1d33bap1422se@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/atomic.h      | 29 +++++----------------------
 arch/x86/include/asm/atomic64_64.h | 28 ++++----------------------
 arch/x86/include/asm/bitops.h      | 24 ++++------------------
 arch/x86/include/asm/local.h       | 28 ++++----------------------
 arch/x86/include/asm/rmwcc.h       | 41 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 58 insertions(+), 92 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 722aa3b..da31c8b 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/rmwcc.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -76,12 +77,7 @@ static inline void atomic_sub(int i, atomic_t *v)
  */
 static inline int atomic_sub_and_test(int i, atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, i, "%0", "e");
 }
 
 /**
@@ -118,12 +114,7 @@ static inline void atomic_dec(atomic_t *v)
  */
 static inline int atomic_dec_and_test(atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, "%0", "e");
 }
 
 /**
@@ -136,12 +127,7 @@ static inline int atomic_dec_and_test(atomic_t *v)
  */
 static inline int atomic_inc_and_test(atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incl", v->counter, "%0", "e");
 }
 
 /**
@@ -155,12 +141,7 @@ static inline int atomic_inc_and_test(atomic_t *v)
  */
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 0e1cbfc..3f065c9 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -72,12 +72,7 @@ static inline void atomic64_sub(long i, atomic64_t *v)
  */
 static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, i, "%0", "e");
 }
 
 /**
@@ -116,12 +111,7 @@ static inline void atomic64_dec(atomic64_t *v)
  */
 static inline int atomic64_dec_and_test(atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decq", v->counter, "%0", "e");
 }
 
 /**
@@ -134,12 +124,7 @@ static inline int atomic64_dec_and_test(atomic64_t *v)
  */
 static inline int atomic64_inc_and_test(atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incq", v->counter, "%0", "e");
 }
 
 /**
@@ -153,12 +138,7 @@ static inline int atomic64_inc_and_test(atomic64_t *v)
  */
 static inline int atomic64_add_negative(long i, atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 41639ce..6d76d09 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -14,6 +14,7 @@
 
 #include <linux/compiler.h>
 #include <asm/alternative.h>
+#include <asm/rmwcc.h>
 
 #if BITS_PER_LONG == 32
 # define _BITOPS_LONG_SHIFT 5
@@ -204,12 +205,7 @@ static inline void change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
-		     "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
-
-	return oldbit;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "bts", *addr, nr, "%0", "c");
 }
 
 /**
@@ -255,13 +251,7 @@ static inline int __test_and_set_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile(LOCK_PREFIX "btr %2,%1\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
-
-	return oldbit;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "btr", *addr, nr, "%0", "c");
 }
 
 /**
@@ -314,13 +304,7 @@ static inline int __test_and_change_bit(long nr, volatile unsigned long *addr)
  */
 static inline int test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile(LOCK_PREFIX "btc %2,%1\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
-
-	return oldbit;
+	GEN_BINARY_RMWcc(LOCK_PREFIX "btc", *addr, nr, "%0", "c");
 }
 
 static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index 2d89e39..5b23e60 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -52,12 +52,7 @@ static inline void local_sub(long i, local_t *l)
  */
 static inline int local_sub_and_test(long i, local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_SUB "%2,%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, i, "%0", "e");
 }
 
 /**
@@ -70,12 +65,7 @@ static inline int local_sub_and_test(long i, local_t *l)
  */
 static inline int local_dec_and_test(local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_DEC "%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(_ASM_DEC, l->a.counter, "%0", "e");
 }
 
 /**
@@ -88,12 +78,7 @@ static inline int local_dec_and_test(local_t *l)
  */
 static inline int local_inc_and_test(local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_INC "%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GEN_UNARY_RMWcc(_ASM_INC, l->a.counter, "%0", "e");
 }
 
 /**
@@ -107,12 +92,7 @@ static inline int local_inc_and_test(local_t *l)
  */
 static inline int local_add_negative(long i, local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_ADD "%2,%0; sets %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, i, "%0", "s");
 }
 
 /**
diff --git a/arch/x86/include/asm/rmwcc.h b/arch/x86/include/asm/rmwcc.h
new file mode 100644
index 0000000..735f184
--- /dev/null
+++ b/arch/x86/include/asm/rmwcc.h
@@ -0,0 +1,41 @@
+#ifndef _ASM_X86_RMWcc
+#define _ASM_X86_RMWcc
+
+#ifdef CC_HAVE_ASM_GOTO
+
+#define __GEN_RMWcc(fullop, var, cc, ...)				\
+do {									\
+	asm volatile goto (fullop "; j" cc " %l[cc_label]"		\
+			: : "m" (var), ## __VA_ARGS__ 			\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+
+#define GEN_UNARY_RMWcc(op, var, arg0, cc) 				\
+	__GEN_RMWcc(op " " arg0, var, cc)
+
+#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
+	__GEN_RMWcc(op " %1, " arg0, var, cc, "er" (val))
+
+#else /* !CC_HAVE_ASM_GOTO */
+
+#define __GEN_RMWcc(fullop, var, cc, ...)				\
+do {									\
+	char c;								\
+	asm volatile (fullop "; set" cc " %1"				\
+			: "+m" (var), "=qm" (c)				\
+			: __VA_ARGS__ : "memory");			\
+	return c != 0;							\
+} while (0)
+
+#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
+	__GEN_RMWcc(op " " arg0, var, cc)
+
+#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
+	__GEN_RMWcc(op " %2, " arg0, var, cc, "er" (val))
+
+#endif /* CC_HAVE_ASM_GOTO */
+
+#endif /* _ASM_X86_RMWcc */
