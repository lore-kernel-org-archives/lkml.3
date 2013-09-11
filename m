Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3IKN03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:26:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45237 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3IKN01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:26:27 -0400
Date: Wed, 11 Sep 2013 15:26:17 +0200
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
Message-ID: <20130911132616.GU26785@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910135152.GD7537@gmail.com>
 <20130910135636.GA8268@gmail.com>
 <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
 <20130910164519.GL31370@twins.programming.kicks-ass.net>
 <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
 <20130910212509.GA18147@laptop.programming.kicks-ass.net>
 <CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
 <20130911131323.GQ31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911131323.GQ31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 03:13:23PM +0200, Peter Zijlstra wrote:
> On Tue, Sep 10, 2013 at 02:43:06PM -0700, Linus Torvalds wrote:
> > That said, looking at your patch, I get the *very* strong feeling that
> > we could make a macro that does all the repetitions for us, and then
> > have a
> > 
> >   GENERATE_RMW(atomic_sub_and_test, LOCK_PREFIX "subl", "e", "")
> 
> The below seems to compile..
> 
> +#define GENERATE_ADDcc(var, val, lock, cc)				\

And here's one that builds and is usable for per-cpu things too:

static __always_inline bool __preempt_count_dec_and_test(void)
{
	GENERATE_ADDcc(__preempt_count, -1, "", __percpu_arg(0), "e");
}

---
 arch/x86/include/asm/addcc.h       |  115 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/atomic.h      |   29 +--------
 arch/x86/include/asm/atomic64_64.h |   28 +--------
 arch/x86/include/asm/local.h       |   28 +--------
 4 files changed, 128 insertions(+), 72 deletions(-)

--- /dev/null
+++ b/arch/x86/include/asm/addcc.h
@@ -0,0 +1,115 @@
+#ifndef _ASM_X86_ADDcc
+#define _ASM_X86_ADDcc
+
+extern void __bad_addcc_size(void);
+
+#ifdef CC_HAVE_ASM_GOTO
+
+#define GENERATE_ADDcc(var, val, lock, arg0, cc)			\
+do {									\
+	const int add_ID__ = (__builtin_constant_p(val) &&		\
+			((val) == 1 || (val) == -1)) ? (val) : 0;	\
+									\
+	switch (sizeof(var)) {						\
+	case 4:								\
+		if (add_ID__ == 1) {					\
+			asm volatile goto(lock "incl " arg0 ";"		\
+					  "j" cc " %l[cc_label]"	\
+					  : : "m" (var)			\
+					  : "memory" : cc_label);	\
+		} else if (add_ID__ == -1) {				\
+			asm volatile goto(lock "decl " arg0 ";"		\
+					  "j" cc " %l[cc_label]"	\
+					  : : "m" (var)			\
+					  : "memory" : cc_label);	\
+		} else {						\
+			asm volatile goto(lock "addl %1, " arg0 ";"	\
+					  "j" cc " %l[cc_label]"	\
+					  : : "m" (var), "er" (val)	\
+					  : "memory" : cc_label);	\
+		}							\
+		break;							\
+									\
+	case 8:								\
+		if (add_ID__ == 1) {					\
+			asm volatile goto(lock "incq " arg0 ";"		\
+					  "j" cc " %l[cc_label]"	\
+					  : : "m" (var)			\
+					  : "memory" : cc_label);	\
+		} else if (add_ID__ == -1) {				\
+			asm volatile goto(lock "decq " arg0 ";"		\
+					  "j" cc " %l[cc_label]"	\
+					  : : "m" (var)			\
+					  : "memory" : cc_label);	\
+		} else {						\
+			asm volatile goto(lock "addq %1, " arg0 ";"	\
+					  "j" cc " %l[cc_label]"	\
+					  : : "m" (var), "er" (val)	\
+					  : "memory" : cc_label);	\
+		}							\
+		break;							\
+									\
+	default: __bad_addcc_size();					\
+	}								\
+									\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+
+#else /* !CC_HAVE_ASM_GOTO */
+
+#define GENERATE_ADDcc(var, val, lock, arg0, cc)			\
+do {									\
+	const int add_ID__ = (__builtin_constant_p(val) &&		\
+			((val) == 1 || (val) == -1)) ? (val) : 0;	\
+	char c;								\
+									\
+	switch (sizeof(var)) {						\
+	case 4:								\
+		if (add_ID__ == 1) {					\
+			asm volatile (lock "incl " arg0 ";"		\
+					  "set" cc " %1"		\
+					  : "+m" (var), "=qm" (c)	\
+					  : : "memory");		\
+		} else if (add_ID__ == -1) {				\
+			asm volatile (lock "decl " arg0 ";"		\
+					  "set" cc " %1"		\
+					  : "+m" (var), "=qm" (c)	\
+					  : : "memory");		\
+		} else {						\
+			asm volatile (lock "addl %2, " arg0 ";"		\
+					  "set" cc " %1"		\
+					  : "+m" (var), "=qm" (c)	\
+					  : "er" (val) : "memory");	\
+		}							\
+		break;							\
+									\
+	case 8:								\
+		if (add_ID__ == 1) {					\
+			asm volatile (lock "incq " arg0 ";"		\
+					  "set" cc " %1"		\
+					  : "+m" (var), "=qm" (c)	\
+					  : : "memory");		\
+		} else if (add_ID__ == -1) {				\
+			asm volatile (lock "decq " arg0 ";"		\
+					  "set" cc " %1"		\
+					  : "+m" (var), "=qm" (c)	\
+					  : : "memory");		\
+		} else {						\
+			asm volatile (lock "addq %2, " arg0 ";"		\
+					  "set" cc " %1"		\
+					  : "+m" (var), "=qm" (c)	\
+					  : "er" (val) : "memory");	\
+		}							\
+		break;							\
+									\
+	default: __bad_addcc_size();					\
+	}								\
+									\
+	return c != 0;							\
+} while (0)
+
+#endif /* CC_HAVE_ASM_GOTO */
+
+#endif /* _ASM_X86_ADDcc */
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/addcc.h>
 
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
+	GENERATE_ADDcc(v->counter, -i, LOCK_PREFIX, "%0", "e");
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
+	GENERATE_ADDcc(v->counter, -1, LOCK_PREFIX, "%0", "e");
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
+	GENERATE_ADDcc(v->counter, 1, LOCK_PREFIX, "%0", "e");
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
+	GENERATE_ADDcc(v->counter, i, LOCK_PREFIX, "%0", "s");
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
+	GENERATE_ADDcc(v->counter, -i, LOCK_PREFIX, "%0", "e");
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
+	GENERATE_ADDcc(v->counter, -1, LOCK_PREFIX, "%0", "e");
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
+	GENERATE_ADDcc(v->counter, 1, LOCK_PREFIX, "%0", "e");
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
+	GENERATE_ADDcc(v->counter, i, LOCK_PREFIX, "%0", "s");
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
+	GENERATE_ADDcc(l->a.counter, -i, "", "%0", "e");
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
+	GENERATE_ADDcc(l->a.counter, -1, "", "%0", "e");
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
+	GENERATE_ADDcc(l->a.counter, 1, "", "%0", "e");
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
+	GENERATE_ADDcc(l->a.counter, i, "", "%0", "s");
 }
 
 /**
