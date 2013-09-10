Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3IJVZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:25:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3IJVZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:25:23 -0400
Date: Tue, 10 Sep 2013 23:25:09 +0200
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
Message-ID: <20130910212509.GA18147@laptop.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910135152.GD7537@gmail.com>
 <20130910135636.GA8268@gmail.com>
 <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
 <20130910164519.GL31370@twins.programming.kicks-ass.net>
 <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:06:44AM -0700, Linus Torvalds wrote:
> > Which is indeed perfect. So should I go 'fix' the other _and_test()
> > functions we have to do this same thing?
> 
> It would be a good thing to test. There might be downsides with "asm
> goto" (maybe it limits gcc some way), but it does in general save us
> not only two instructions but also a register.

Here's one that builds and boots on kvm until wanting to mount root.

I'm not entirely sure on the "ir" vs "er" thing and atomic64_t and
local_t are inconsistent wrt that so I'm too.

I'll try running on actual hardware tomorrow sometime.

---
 arch/x86/include/asm/atomic.h      |   52 +++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/atomic64_64.h |   54 ++++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/local.h       |   52 +++++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -74,6 +74,18 @@ static inline void atomic_sub(int i, ato
  * true if the result is zero, or false for all
  * other cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int atomic_sub_and_test(int i, atomic_t *v)
+{
+	asm volatile goto(LOCK_PREFIX "subl %1,%0;"
+			  "je %l[became_zero]"
+			  : : "m" (v->counter), "ir" (i)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int atomic_sub_and_test(int i, atomic_t *v)
 {
 	unsigned char c;
@@ -83,6 +95,7 @@ static inline int atomic_sub_and_test(in
 		     : "ir" (i) : "memory");
 	return c;
 }
+#endif
 
 /**
  * atomic_inc - increment atomic variable
@@ -116,6 +129,18 @@ static inline void atomic_dec(atomic_t *
  * returns true if the result is 0, or false for all other
  * cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int atomic_dec_and_test(atomic_t *v)
+{
+	asm volatile goto(LOCK_PREFIX "decl %0;"
+			  "je %l[became_zero]"
+			  : : "m" (v->counter)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int atomic_dec_and_test(atomic_t *v)
 {
 	unsigned char c;
@@ -125,6 +150,7 @@ static inline int atomic_dec_and_test(at
 		     : : "memory");
 	return c != 0;
 }
+#endif
 
 /**
  * atomic_inc_and_test - increment and test
@@ -134,6 +160,18 @@ static inline int atomic_dec_and_test(at
  * and returns true if the result is zero, or false for all
  * other cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int atomic_inc_and_test(atomic_t *v)
+{
+	asm volatile goto(LOCK_PREFIX "incl %0;"
+			  "je %l[became_zero]"
+			  : : "m" (v->counter)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int atomic_inc_and_test(atomic_t *v)
 {
 	unsigned char c;
@@ -143,6 +181,7 @@ static inline int atomic_inc_and_test(at
 		     : : "memory");
 	return c != 0;
 }
+#endif
 
 /**
  * atomic_add_negative - add and test if negative
@@ -153,6 +192,18 @@ static inline int atomic_inc_and_test(at
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int atomic_add_negative(int i, atomic_t *v)
+{
+	asm volatile goto(LOCK_PREFIX "addl %1,%0;"
+			  "js %l[became_neg]"
+			  : : "m" (v->counter), "ir" (i)
+			  : "memory" : became_neg);
+	return 0;
+became_neg:
+	return 1;
+}
+#else
 static inline int atomic_add_negative(int i, atomic_t *v)
 {
 	unsigned char c;
@@ -162,6 +213,7 @@ static inline int atomic_add_negative(in
 		     : "ir" (i) : "memory");
 	return c;
 }
+#endif
 
 /**
  * atomic_add_return - add integer and return
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -70,6 +70,18 @@ static inline void atomic64_sub(long i,
  * true if the result is zero, or false for all
  * other cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int atomic64_sub_and_test(long i, atomic64_t *v)
+{
+	asm volatile goto(LOCK_PREFIX "subq %1,%0;"
+			  "je %l[became_zero]"
+			  : : "m" (v->counter), "er" (i)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int atomic64_sub_and_test(long i, atomic64_t *v)
 {
 	unsigned char c;
@@ -79,6 +91,7 @@ static inline int atomic64_sub_and_test(
 		     : "er" (i), "m" (v->counter) : "memory");
 	return c;
 }
+#endif
 
 /**
  * atomic64_inc - increment atomic64 variable
@@ -114,6 +127,18 @@ static inline void atomic64_dec(atomic64
  * returns true if the result is 0, or false for all other
  * cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int atomic64_dec_and_test(atomic64_t *v)
+{
+	asm volatile goto(LOCK_PREFIX "decq %0;"
+			  "je %l[became_zero]"
+			  : : "m" (v->counter)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int atomic64_dec_and_test(atomic64_t *v)
 {
 	unsigned char c;
@@ -123,6 +148,7 @@ static inline int atomic64_dec_and_test(
 		     : "m" (v->counter) : "memory");
 	return c != 0;
 }
+#endif
 
 /**
  * atomic64_inc_and_test - increment and test
@@ -132,6 +158,18 @@ static inline int atomic64_dec_and_test(
  * and returns true if the result is zero, or false for all
  * other cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int atomic64_inc_and_test(atomic64_t *v)
+{
+	asm volatile goto(LOCK_PREFIX "incq %0;"
+			  "je %l[became_zero]"
+			  : : "m" (v->counter)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int atomic64_inc_and_test(atomic64_t *v)
 {
 	unsigned char c;
@@ -141,6 +179,7 @@ static inline int atomic64_inc_and_test(
 		     : "m" (v->counter) : "memory");
 	return c != 0;
 }
+#endif
 
 /**
  * atomic64_add_negative - add and test if negative
@@ -151,6 +190,18 @@ static inline int atomic64_inc_and_test(
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int atomic64_add_negative(long i, atomic64_t *v)
+{
+	asm volatile goto(LOCK_PREFIX "addq %1,%0;"
+			  "js %l[became_neg]"
+			  : : "m" (v->counter), "er" (i)
+			  : "memory" : became_neg);
+	return 0;
+became_neg:
+	return 1;
+}
+#else
 static inline int atomic64_add_negative(long i, atomic64_t *v)
 {
 	unsigned char c;
@@ -160,6 +211,7 @@ static inline int atomic64_add_negative(
 		     : "er" (i), "m" (v->counter) : "memory");
 	return c;
 }
+#endif
 
 /**
  * atomic64_add_return - add and return
@@ -219,7 +271,7 @@ static inline int atomic64_add_unless(at
 
 /*
  * atomic64_dec_if_positive - decrement by 1 if old value positive
- * @v: pointer of type atomic_t
+ * @v: pointer of type atomic64_t
  *
  * The function returns the old value of *v minus 1, even if
  * the atomic variable, v, was not decremented.
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -50,6 +50,18 @@ static inline void local_sub(long i, loc
  * true if the result is zero, or false for all
  * other cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int local_sub_and_test(long i, local_t *l)
+{
+	asm volatile goto(_ASM_SUB " %1,%0;"
+			  "je %l[became_zero]"
+			  : : "m" (l->a.counter), "ir" (i)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int local_sub_and_test(long i, local_t *l)
 {
 	unsigned char c;
@@ -59,6 +71,7 @@ static inline int local_sub_and_test(lon
 		     : "ir" (i) : "memory");
 	return c;
 }
+#endif
 
 /**
  * local_dec_and_test - decrement and test
@@ -68,6 +81,18 @@ static inline int local_sub_and_test(lon
  * returns true if the result is 0, or false for all other
  * cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int local_dec_and_test(local_t *l)
+{
+	asm volatile goto(_ASM_DEC " %0;"
+			  "je %l[became_zero]"
+			  : : "m" (l->a.counter)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int local_dec_and_test(local_t *l)
 {
 	unsigned char c;
@@ -77,6 +102,7 @@ static inline int local_dec_and_test(loc
 		     : : "memory");
 	return c != 0;
 }
+#endif
 
 /**
  * local_inc_and_test - increment and test
@@ -86,6 +112,18 @@ static inline int local_dec_and_test(loc
  * and returns true if the result is zero, or false for all
  * other cases.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int local_inc_and_test(local_t *l)
+{
+	asm volatile goto(_ASM_INC " %0;"
+			  "je %l[became_zero]"
+			  : : "m" (l->a.counter)
+			  : "memory" : became_zero);
+	return 0;
+became_zero:
+	return 1;
+}
+#else
 static inline int local_inc_and_test(local_t *l)
 {
 	unsigned char c;
@@ -95,6 +133,7 @@ static inline int local_inc_and_test(loc
 		     : : "memory");
 	return c != 0;
 }
+#endif
 
 /**
  * local_add_negative - add and test if negative
@@ -105,6 +144,18 @@ static inline int local_inc_and_test(loc
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline int local_add_negative(long i, local_t *l)
+{
+	asm volatile goto(_ASM_ADD " %1,%0;"
+			  "js %l[became_neg]"
+			  : : "m" (l->a.counter), "ir" (i)
+			  : "memory" : became_neg);
+	return 0;
+became_neg:
+	return 1;
+}
+#else
 static inline int local_add_negative(long i, local_t *l)
 {
 	unsigned char c;
@@ -114,6 +165,7 @@ static inline int local_add_negative(lon
 		     : "ir" (i) : "memory");
 	return c;
 }
+#endif
 
 /**
  * local_add_return - add and return
