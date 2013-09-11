Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3IKTAC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:00:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53927 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3IKTAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:00:00 -0400
Date: Wed, 11 Sep 2013 20:59:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130911185944.GA1798@laptop.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910135152.GD7537@gmail.com>
 <20130910135636.GA8268@gmail.com>
 <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
 <20130910164519.GL31370@twins.programming.kicks-ass.net>
 <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
 <20130910212509.GA18147@laptop.programming.kicks-ass.net>
 <CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
 <20130911131323.GQ31370@twins.programming.kicks-ass.net>
 <CA+55aFyxcHvQUe_h8cyQrNbGJ6-G_NQnK9pVenABLjCF-7WMXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyxcHvQUe_h8cyQrNbGJ6-G_NQnK9pVenABLjCF-7WMXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 08:33:21AM -0700, Linus Torvalds wrote:
> An excessively complex macro that makes the arguments trivially
> simpler is not worth it.

OK, stripped it down further, I couldn't quite see how to collapse the
unary and binary operator variants though :/

---
 arch/x86/include/asm/rmwcc.h       |   62 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/atomic.h      |   29 ++---------------
 arch/x86/include/asm/atomic64_64.h |   28 ++--------------
 arch/x86/include/asm/local.h       |   28 ++--------------
 4 files changed, 75 insertions(+), 72 deletions(-)

--- /dev/null
+++ b/arch/x86/include/asm/rmwcc.h
@@ -0,0 +1,62 @@
+#ifndef _ASM_X86_RMWcc
+#define _ASM_X86_RMWcc
+
+extern void __bad_rmwcc_nargs(void);
+
+#ifdef CC_HAVE_ASM_GOTO
+
+#define GENERATE_RMWcc(var, val, op, nargs, arg0, cc)			\
+do {									\
+	switch (nargs) {						\
+	case 0:								\
+		asm volatile goto (op " " arg0 ";"			\
+				"j" cc " %l[cc_label]"			\
+				: : "m" (var)				\
+				: "memory" : cc_label);			\
+		break;							\
+									\
+	case 1:								\
+		asm volatile goto (op " %1, " arg0 ";"			\
+				"j" cc " %l[cc_label]"			\
+				: : "m" (var), "er" (val)		\
+				: "memory" : cc_label);			\
+		break;							\
+									\
+	default: __bad_rmwcc_nargs();					\
+	}								\
+									\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+
+#else /* !CC_HAVE_ASM_GOTO */
+
+#define GENERATE_RMWcc(var, val, op, nargs, arg0, cc)			\
+do {									\
+	char c;								\
+									\
+	switch (nargs) {						\
+	case 0:								\
+		asm volatile (op " " arg0 ";"				\
+				"set" cc " %1"				\
+				: "+m" (var), "=qm" (c)			\
+				: : "memory");				\
+		break;							\
+									\
+	case 1:								\
+		asm volatile (op " %2, " arg0 ";"			\
+				"set" cc " %1"				\
+				: "+m" (var), "=qm" (c)			\
+				: "er" (val) : "memory");		\
+		break;							\
+									\
+	default: __bad_rmwcc_nargs();					\
+	}								\
+									\
+	return c != 0;							\
+} while (0)
+
+#endif /* CC_HAVE_ASM_GOTO */
+
+#endif /* _ASM_X86_RMWcc */
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/rmwcc.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -76,12 +77,7 @@ static inline void atomic_sub(int i, ato
  */
 static inline int atomic_sub_and_test(int i, atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GENERATE_RMWcc(v->counter, i, LOCK_PREFIX "subl", 1, "%0", "e");
 }
 
 /**
@@ -118,12 +114,7 @@ static inline void atomic_dec(atomic_t *
  */
 static inline int atomic_dec_and_test(atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GENERATE_RMWcc(v->counter, 0, LOCK_PREFIX "decl", 0, "%0", "e");
 }
 
 /**
@@ -136,12 +127,7 @@ static inline int atomic_dec_and_test(at
  */
 static inline int atomic_inc_and_test(atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GENERATE_RMWcc(v->counter, 0, LOCK_PREFIX "incl", 0, "%0", "e");
 }
 
 /**
@@ -155,12 +141,7 @@ static inline int atomic_inc_and_test(at
  */
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GENERATE_RMWcc(v->counter, i, LOCK_PREFIX "addl", 1, "%0", "s");
 }
 
 /**
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -72,12 +72,7 @@ static inline void atomic64_sub(long i,
  */
 static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
+	GENERATE_RMWcc(v->counter, i, LOCK_PREFIX "subq", 1, "%0", "e");
 }
 
 /**
@@ -116,12 +111,7 @@ static inline void atomic64_dec(atomic64
  */
 static inline int atomic64_dec_and_test(atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
+	GENERATE_RMWcc(v->counter, 0, LOCK_PREFIX "decq", 0, "%0", "e");
 }
 
 /**
@@ -134,12 +124,7 @@ static inline int atomic64_dec_and_test(
  */
 static inline int atomic64_inc_and_test(atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
+	GENERATE_RMWcc(v->counter, 0, LOCK_PREFIX "incq", 0, "%0", "e");
 }
 
 /**
@@ -153,12 +138,7 @@ static inline int atomic64_inc_and_test(
  */
 static inline int atomic64_add_negative(long i, atomic64_t *v)
 {
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
+	GENERATE_RMWcc(v->counter, i, LOCK_PREFIX "addq", 1, "%0", "s");
 }
 
 /**
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -52,12 +52,7 @@ static inline void local_sub(long i, loc
  */
 static inline int local_sub_and_test(long i, local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_SUB "%2,%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GENERATE_RMWcc(l->a.counter, i, _ASM_SUB, 1, "%0", "e");
 }
 
 /**
@@ -70,12 +65,7 @@ static inline int local_sub_and_test(lon
  */
 static inline int local_dec_and_test(local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_DEC "%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GENERATE_RMWcc(l->a.counter, 0, _ASM_DEC, 0, "%0", "e");
 }
 
 /**
@@ -88,12 +78,7 @@ static inline int local_dec_and_test(loc
  */
 static inline int local_inc_and_test(local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_INC "%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
+	GENERATE_RMWcc(l->a.counter, 0, _ASM_INC, 0, "%0", "e");
 }
 
 /**
@@ -107,12 +92,7 @@ static inline int local_inc_and_test(loc
  */
 static inline int local_add_negative(long i, local_t *l)
 {
-	unsigned char c;
-
-	asm volatile(_ASM_ADD "%2,%0; sets %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
+	GENERATE_RMWcc(l->a.counter, i, _ASM_ADD, 1, "%0", "s");
 }
 
 /**
