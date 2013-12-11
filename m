Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab3LKSgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:36:09 -0500
Received: from a9-114.smtp-out.amazonses.com ([54.240.9.114]:50461 "EHLO
	a9-114.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791Ab3LKSgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:36:05 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 13:36:05 EST
Date: Wed, 11 Dec 2013 18:30:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
In-Reply-To: <20131211175235.GD12431@gmail.com>
Message-ID: <00000142e2ec5e62-25b6aaaf-494c-44ff-987f-2935aed1bb9c-000000@email.amazonses.com>
References: <20131203233251.745099192@linux.com> <20131210153445.GE4610@htj.dyndns.org> <20131210154506.GA1884@gmail.com> <20131210154951.GF4610@htj.dyndns.org> <20131210155546.GD1995@gmail.com> <00000142ddb6d07d-f77cfa15-55a5-4806-891e-2d57894fc46b-000000@email.amazonses.com>
 <20131210183133.GC20770@gmail.com> <00000142de1ac9a3-d2b5b7fb-25c5-4bec-acbe-8be30a951bbc-000000@email.amazonses.com> <20131211151220.GB11048@gmail.com> <00000142e2c64102-07168d96-fb2f-4eeb-9b49-c3298bc81192-000000@email.amazonses.com>
 <20131211175235.GD12431@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.11-54.240.9.114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Ingo Molnar wrote:

> > Thinking about this some more: Separating these two issues would
> > make it impossible to build x86 since the hackery in
> > x86/include/asm/preempt.h depends on having the right names in
> > x86/include/asm/percpu.h. Changing the names first would result in
> > preempt.h not being usable.
>
> The series must be bisectable at every commit, of course.

Ok patch with revised header:



From: Peter Zijlstra <peterz@infradead.org>
Subject: x86: Rename __this_cpu_xxx_# operations to raw_cpu_xxx_#

This is required after the raw_cpu changes in the core since x86 needs
to follow a different naming for __this_cpu primitives now.

Change the names from __this_cpu_xxxx_# to raw_cpu_xxxx_#.

Also changes the uses of the x86 percpu primitives in preempt.h.
These depend directly on asm/percpu.h (header #include nesting issue).

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/x86/include/asm/percpu.h
===================================================================
--- linux.orig/arch/x86/include/asm/percpu.h	2013-12-02 16:07:50.984600478 -0600
+++ linux/arch/x86/include/asm/percpu.h	2013-12-02 16:07:50.984600478 -0600
@@ -362,25 +362,25 @@ do {									\
  */
 #define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))

-#define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define __this_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-
-#define __this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_or_1(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_or_2(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_or_4(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
-#define __this_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
-#define __this_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
+#define raw_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+
+#define raw_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define raw_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define raw_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define raw_cpu_add_1(pcp, val)		percpu_add_op((pcp), val)
+#define raw_cpu_add_2(pcp, val)		percpu_add_op((pcp), val)
+#define raw_cpu_add_4(pcp, val)		percpu_add_op((pcp), val)
+#define raw_cpu_and_1(pcp, val)		percpu_to_op("and", (pcp), val)
+#define raw_cpu_and_2(pcp, val)		percpu_to_op("and", (pcp), val)
+#define raw_cpu_and_4(pcp, val)		percpu_to_op("and", (pcp), val)
+#define raw_cpu_or_1(pcp, val)		percpu_to_op("or", (pcp), val)
+#define raw_cpu_or_2(pcp, val)		percpu_to_op("or", (pcp), val)
+#define raw_cpu_or_4(pcp, val)		percpu_to_op("or", (pcp), val)
+#define raw_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
+#define raw_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
+#define raw_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)

 #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -401,16 +401,16 @@ do {									\
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)

-#define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_add_return_4(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-#define __this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-#define __this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-
-#define this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
-#define this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
-#define this_cpu_add_return_4(pcp, val)	percpu_add_return_op(pcp, val)
+#define raw_cpu_add_return_1(pcp, val)		percpu_add_return_op(pcp, val)
+#define raw_cpu_add_return_2(pcp, val)		percpu_add_return_op(pcp, val)
+#define raw_cpu_add_return_4(pcp, val)		percpu_add_return_op(pcp, val)
+#define raw_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define raw_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define raw_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+
+#define this_cpu_add_return_1(pcp, val)		percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_2(pcp, val)		percpu_add_return_op(pcp, val)
+#define this_cpu_add_return_4(pcp, val)		percpu_add_return_op(pcp, val)
 #define this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
@@ -427,7 +427,7 @@ do {									\
 	__ret;								\
 })

-#define __this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
+#define raw_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 #define this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 #endif /* CONFIG_X86_CMPXCHG64 */

@@ -436,22 +436,22 @@ do {									\
  * 32 bit must fall back to generic operations.
  */
 #ifdef CONFIG_X86_64
-#define __this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define __this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-
-#define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
-#define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
-#define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
-#define this_cpu_add_return_8(pcp, val)	percpu_add_return_op(pcp, val)
-#define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define raw_cpu_read_8(pcp)			percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_write_8(pcp, val)		percpu_to_op("mov", (pcp), val)
+#define raw_cpu_add_8(pcp, val)			percpu_add_op((pcp), val)
+#define raw_cpu_and_8(pcp, val)			percpu_to_op("and", (pcp), val)
+#define raw_cpu_or_8(pcp, val)			percpu_to_op("or", (pcp), val)
+#define raw_cpu_add_return_8(pcp, val)		percpu_add_return_op(pcp, val)
+#define raw_cpu_xchg_8(pcp, nval)		percpu_xchg_op(pcp, nval)
+#define raw_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+
+#define this_cpu_read_8(pcp)			percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_write_8(pcp, val)		percpu_to_op("mov", (pcp), val)
+#define this_cpu_add_8(pcp, val)		percpu_add_op((pcp), val)
+#define this_cpu_and_8(pcp, val)		percpu_to_op("and", (pcp), val)
+#define this_cpu_or_8(pcp, val)			percpu_to_op("or", (pcp), val)
+#define this_cpu_add_return_8(pcp, val)		percpu_add_return_op(pcp, val)
+#define this_cpu_xchg_8(pcp, nval)		percpu_xchg_op(pcp, nval)
 #define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)

 /*
@@ -474,7 +474,7 @@ do {									\
 	__ret;								\
 })

-#define __this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
+#define raw_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 #define this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double

 #endif
@@ -495,9 +495,9 @@ static __always_inline int x86_this_cpu_
 	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;

 #ifdef CONFIG_X86_64
-	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_8(*a)) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) & raw_cpu_read_8(*a)) != 0;
 #else
-	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_4(*a)) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) & raw_cpu_read_4(*a)) != 0;
 #endif
 }

Index: linux/arch/x86/include/asm/preempt.h
===================================================================
--- linux.orig/arch/x86/include/asm/preempt.h	2013-12-02 16:07:50.984600478 -0600
+++ linux/arch/x86/include/asm/preempt.h	2013-12-02 16:07:50.984600478 -0600
@@ -13,12 +13,12 @@ DECLARE_PER_CPU(int, __preempt_count);
  */
 static __always_inline int preempt_count(void)
 {
-	return __this_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
+	return raw_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
 }

 static __always_inline void preempt_count_set(int pc)
 {
-	__this_cpu_write_4(__preempt_count, pc);
+	raw_cpu_write_4(__preempt_count, pc);
 }

 /*
@@ -47,17 +47,17 @@ static __always_inline void preempt_coun

 static __always_inline void set_preempt_need_resched(void)
 {
-	__this_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
+	raw_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
 }

 static __always_inline void clear_preempt_need_resched(void)
 {
-	__this_cpu_or_4(__preempt_count, PREEMPT_NEED_RESCHED);
+	raw_cpu_or_4(__preempt_count, PREEMPT_NEED_RESCHED);
 }

 static __always_inline bool test_preempt_need_resched(void)
 {
-	return !(__this_cpu_read_4(__preempt_count) & PREEMPT_NEED_RESCHED);
+	return !(raw_cpu_read_4(__preempt_count) & PREEMPT_NEED_RESCHED);
 }

 /*
@@ -66,12 +66,12 @@ static __always_inline bool test_preempt

 static __always_inline void __preempt_count_add(int val)
 {
-	__this_cpu_add_4(__preempt_count, val);
+	raw_cpu_add_4(__preempt_count, val);
 }

 static __always_inline void __preempt_count_sub(int val)
 {
-	__this_cpu_add_4(__preempt_count, -val);
+	raw_cpu_add_4(__preempt_count, -val);
 }

 static __always_inline bool __preempt_count_dec_and_test(void)
@@ -84,7 +84,7 @@ static __always_inline bool __preempt_co
  */
 static __always_inline bool should_resched(void)
 {
-	return unlikely(!__this_cpu_read_4(__preempt_count));
+	return unlikely(!raw_cpu_read_4(__preempt_count));
 }

 #ifdef CONFIG_PREEMPT
