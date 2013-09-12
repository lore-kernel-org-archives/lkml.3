Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3ILCUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 22:20:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33804 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3ILCUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 22:20:53 -0400
Date: Thu, 12 Sep 2013 04:20:40 +0200
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
Message-ID: <20130912022040.GT31370@twins.programming.kicks-ass.net>
References: <20130910135636.GA8268@gmail.com>
 <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
 <20130910164519.GL31370@twins.programming.kicks-ass.net>
 <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
 <20130910212509.GA18147@laptop.programming.kicks-ass.net>
 <CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
 <20130911131323.GQ31370@twins.programming.kicks-ass.net>
 <CA+55aFyxcHvQUe_h8cyQrNbGJ6-G_NQnK9pVenABLjCF-7WMXg@mail.gmail.com>
 <20130911185944.GA1798@laptop.programming.kicks-ass.net>
 <CA+55aFxDbqeFumkVApf-L2pi+FQn06GQqQf4rWkzOC4LF=fn=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxDbqeFumkVApf-L2pi+FQn06GQqQf4rWkzOC4LF=fn=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 04:02:14PM -0700, Linus Torvalds wrote:
> On Wed, Sep 11, 2013 at 11:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > OK, stripped it down further, I couldn't quite see how to collapse the
> > unary and binary operator variants though :/
> 
> Ok, this looks pretty good. I assume it works too? ;)

Only compile tested that one.. the below is kvm boot tested until root
mount -- I'll try on actual hardware when I've gotten some sleep.

I split the thing up into two macros GEN_UNARY_RMWcc and
GEN_BINARY_RMWcc which ends up being more readable as well as smaller
code overall.

I also attempted to convert asm/bitops.h, although I'm not sure it'll
compile right with older GCCs due to the comment near BITOP_ADDR()

It also changes the fallback from sbb %0,%0 to setc %0, which afaict
should be similar but I'm not too familiar with all that.

I might have to add the clobber to the macro arguments so we can do
version without "memory" clobber, although bitops is inconsistent with
that as well, __test_and_clear_bit() doesn't have a memory clobber but
__test_and_change_bit() does.

---
 arch/x86/include/asm/atomic.h      |   29 +++---------------
 arch/x86/include/asm/atomic64_64.h |   28 ++---------------
 arch/x86/include/asm/bitops.h      |   58 +++++--------------------------------
 arch/x86/include/asm/local.h       |   28 ++---------------
 arch/x86/include/asm/rmwcc.h       |   52 +++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 122 deletions(-)

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
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subl", v->counter, i, "%0", "e");
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
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, "%0", "e");
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
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incl", v->counter, "%0", "e");
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
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addl", v->counter, i, "%0", "s");
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
+	GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, i, "%0", "e");
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
+	GEN_UNARY_RMWcc(LOCK_PREFIX "decq", v->counter, "%0", "e");
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
+	GEN_UNARY_RMWcc(LOCK_PREFIX "incq", v->counter, "%0", "e");
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
+	GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, i, "%0", "s");
 }
 
 /**
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -14,6 +14,7 @@
 
 #include <linux/compiler.h>
 #include <asm/alternative.h>
+#include <asm/rmwcc.h>
 
 #if BITS_PER_LONG == 32
 # define _BITOPS_LONG_SHIFT 5
@@ -204,12 +205,7 @@ static inline void change_bit(long nr, v
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
@@ -236,13 +232,7 @@ test_and_set_bit_lock(long nr, volatile
  */
 static inline int __test_and_set_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm("bts %2,%1\n\t"
-	    "sbb %0,%0"
-	    : "=r" (oldbit), ADDR
-	    : "Ir" (nr));
-	return oldbit;
+	GEN_BINARY_RMWcc("bts", *addr, nr, "%0", "c");
 }
 
 /**
@@ -255,13 +245,7 @@ static inline int __test_and_set_bit(lon
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
@@ -282,26 +266,13 @@ static inline int test_and_clear_bit(lon
  */
 static inline int __test_and_clear_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile("btr %2,%1\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR
-		     : "Ir" (nr));
-	return oldbit;
+	GEN_BINARY_RMWcc("btr", *addr, nr, "%0", "c");
 }
 
 /* WARNING: non atomic and it can be reordered! */
 static inline int __test_and_change_bit(long nr, volatile unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile("btc %2,%1\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit), ADDR
-		     : "Ir" (nr) : "memory");
-
-	return oldbit;
+	GEN_BINARY_RMWcc("btc", *addr, nr, "%0", "c");
 }
 
 /**
@@ -314,13 +285,7 @@ static inline int __test_and_change_bit(
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
@@ -331,14 +296,7 @@ static __always_inline int constant_test
 
 static inline int variable_test_bit(long nr, volatile const unsigned long *addr)
 {
-	int oldbit;
-
-	asm volatile("bt %2,%1\n\t"
-		     "sbb %0,%0"
-		     : "=r" (oldbit)
-		     : "m" (*(unsigned long *)addr), "Ir" (nr));
-
-	return oldbit;
+	GEN_BINARY_RMWcc("bt", *(volatile unsigned long *)addr, nr, "%0", "c");
 }
 
 #if 0 /* Fool kernel-doc since it doesn't do macros yet */
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
+	GEN_BINARY_RMWcc(_ASM_SUB, l->a.counter, i, "%0", "e");
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
+	GEN_UNARY_RMWcc(_ASM_DEC, l->a.counter, "%0", "e");
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
+	GEN_UNARY_RMWcc(_ASM_INC, l->a.counter, "%0", "e");
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
+	GEN_BINARY_RMWcc(_ASM_ADD, l->a.counter, i, "%0", "s");
 }
 
 /**
--- /dev/null
+++ b/arch/x86/include/asm/rmwcc.h
@@ -0,0 +1,52 @@
+#ifndef _ASM_X86_RMWcc
+#define _ASM_X86_RMWcc
+
+#ifdef CC_HAVE_ASM_GOTO
+
+#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
+do {									\
+	asm volatile goto (op " " arg0 ";"				\
+			"j" cc " %l[cc_label]"				\
+			: : "m" (var)					\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+
+#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
+do {									\
+	asm volatile goto (op " %1, " arg0 ";"				\
+			"j" cc " %l[cc_label]"				\
+			: : "m" (var), "er" (val)			\
+			: "memory" : cc_label);				\
+	return 0;							\
+cc_label:								\
+	return 1;							\
+} while (0)
+
+#else /* !CC_HAVE_ASM_GOTO */
+
+#define GEN_UNARY_RMWcc(op, var, arg0, cc)				\
+do {									\
+	char c;								\
+	asm volatile (op " " arg0 ";"					\
+			"set" cc " %1"					\
+			: "+m" (var), "=qm" (c)				\
+			: : "memory");					\
+	return c != 0;							\
+} while (0)
+
+#define GEN_BINARY_RMWcc(op, var, val, arg0, cc)			\
+do {									\
+	char c;								\
+	asm volatile (op " %2, " arg0 ";"				\
+			"set" cc " %1"					\
+			: "+m" (var), "=qm" (c)				\
+			: "er" (val) : "memory");			\
+	return c != 0;							\
+} while (0)
+
+#endif /* CC_HAVE_ASM_GOTO */
+
+#endif /* _ASM_X86_RMWcc */
