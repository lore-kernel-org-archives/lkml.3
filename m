Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980Ab3JPQ0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:26:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58303 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760566Ab3JPQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:25:58 -0400
Date: Wed, 16 Oct 2013 18:25:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131016162537.GB10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174747.813545438@linux.com>
 <20131016084920.GT10651@twins.programming.kicks-ass.net>
 <00000141c1d04300-e935e477-6669-4388-8109-c77064ee27e7-000000@email.amazonses.com>
 <20131016153603.GZ10651@twins.programming.kicks-ass.net>
 <00000141c1fae3ba-6b52fea1-74f9-42f7-b1db-70dda847e7f9-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141c1fae3ba-6b52fea1-74f9-42f7-b1db-70dda847e7f9-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:55:47PM +0000, Christoph Lameter wrote:
> On Wed, 16 Oct 2013, Peter Zijlstra wrote:
> 
> > On Wed, Oct 16, 2013 at 03:09:13PM +0000, Christoph Lameter wrote:
> > > On Wed, 16 Oct 2013, Peter Zijlstra wrote:
> > >
> > > > So I didn't understand what was wrong with:
> > > >
> > > > #define __this_cpu_read(pcp) \
> > > > 	(__this_cpu_preempt_check("read"), raw_this_cpu_read(pcp))
> > > >
> > > > And idem for all others. This is 1) shorter to write; and 2) makes it
> > > > blindingly obvious that the implementations are actually the same.
> > >
> > > Nothing wrong with that. It just increases the scope of this patch to
> > > require modifications to arch code and I already have trouble enough
> > > following through on all the issues that were raised so far.
> > >
> >
> > But non of your raw ops touch arch code... /me confused.
> 
> Yes that is intentional to limit scope. Renaming would require arch
> changes.
> 
> The __this_cpu_xxxs are defined in arch code. Look at x86 arch
> implementations for example. arch/x86/include/asm/percpu.h. s390 also has
> this. Not sure if other arches do.

I can only find x86 that has per arch __this_cpu thingies; and then only
the __this_cpu_$op_$n variants, the actual __this_cpu_$op stuff comes
from linux/percpu.h:

# define __this_cpu_read(pcp)   __pcpu_size_call_return(__this_cpu_read_, (pcp))

With exception of __this_cpu_ptr.

# git grep "#[[:space:]]*define[[:space:]]*__this_cpu"  | grep -v "__this_cpu[[:alpha:]_]*[0-9]"
arch/x86/include/asm/percpu.h:#define __this_cpu_ptr(ptr)                               \
include/asm-generic/percpu.h:#define __this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
include/asm-generic/percpu.h:#define __this_cpu_ptr(ptr)        this_cpu_ptr(ptr)
include/linux/percpu.h:# define __this_cpu_read(pcp)    __pcpu_size_call_return(__this_cpu_read_, (pcp))
include/linux/percpu.h:#define __this_cpu_generic_to_op(pcp, val, op)                           \
include/linux/percpu.h:# define __this_cpu_write(pcp, val)      __pcpu_size_call(__this_cpu_write_, (pcp), (val))
include/linux/percpu.h:# define __this_cpu_add(pcp, val)        __pcpu_size_call(__this_cpu_add_, (pcp), (val))
include/linux/percpu.h:# define __this_cpu_sub(pcp, val)        __this_cpu_add((pcp), -(val))
include/linux/percpu.h:# define __this_cpu_inc(pcp)             __this_cpu_add((pcp), 1)
include/linux/percpu.h:# define __this_cpu_dec(pcp)             __this_cpu_sub((pcp), 1)
include/linux/percpu.h:# define __this_cpu_and(pcp, val)        __pcpu_size_call(__this_cpu_and_, (pcp), (val))
include/linux/percpu.h:# define __this_cpu_or(pcp, val) __pcpu_size_call(__this_cpu_or_, (pcp), (val))
include/linux/percpu.h:# define __this_cpu_xor(pcp, val)        __pcpu_size_call(__this_cpu_xor_, (pcp), (val))
include/linux/percpu.h:#define __this_cpu_generic_add_return(pcp, val)                          \
include/linux/percpu.h:# define __this_cpu_add_return(pcp, val) \
include/linux/percpu.h:#define __this_cpu_sub_return(pcp, val)  __this_cpu_add_return(pcp, -(val))
include/linux/percpu.h:#define __this_cpu_inc_return(pcp)       __this_cpu_add_return(pcp, 1)
include/linux/percpu.h:#define __this_cpu_dec_return(pcp)       __this_cpu_add_return(pcp, -1)
include/linux/percpu.h:#define __this_cpu_generic_xchg(pcp, nval)                               \
include/linux/percpu.h:# define __this_cpu_xchg(pcp, nval)      \
include/linux/percpu.h:#define __this_cpu_generic_cmpxchg(pcp, oval, nval)                      \
include/linux/percpu.h:# define __this_cpu_cmpxchg(pcp, oval, nval)     \
include/linux/percpu.h:#define __this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)        \
include/linux/percpu.h:# define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)       \


But yes, the way its set-up an arch could indeed provide __this_cup_$op
itself -- without providing the _$n variants; in which case the
raw_cpu_$op provided by you is broken.

Can't we have a 'simple' coccinelle script rename the entire __this_cpu*
implementation over to raw_cpu* and then provide generic __this_cpu* ->
raw_cpu maps?

>From what I can gather the __this_cpu_$op_$n variants aren't an official
API anyway.

Maybe something simple like this:

git grep -l "#[[:space:]]*define[[:space:]]*__this_cpu" | while read file; do sed -ie 's/__this_cpu/raw_cpu/g' $file; done

To rename __this_cpu to raw_cpu; it would then need a little manual
fixup and generic __this_cpu -> raW_cpu map, which can add the
preemption check.

---
 arch/x86/include/asm/percpu.h |  84 ++++++-------
 include/asm-generic/percpu.h  |  10 +-
 include/linux/percpu.h        | 282 +++++++++++++++++++++---------------------
 3 files changed, 188 insertions(+), 188 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 0da5200ee79d..7a9fbff3d191 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -52,7 +52,7 @@
  * Compared to the generic __my_cpu_offset version, the following
  * saves one instruction and avoids clobbering a temp register.
  */
-#define __this_cpu_ptr(ptr)				\
+#define raw_cpu_ptr(ptr)				\
 ({							\
 	unsigned long tcp_ptr__;			\
 	__verify_pcpu_ptr(ptr);				\
@@ -361,28 +361,28 @@ do {									\
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
-#define __this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define __this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define __this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
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
+#define raw_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
+#define raw_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
+#define raw_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
+#define raw_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
+#define raw_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
+#define raw_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
+#define raw_cpu_or_1(pcp, val)	percpu_to_op("or", (pcp), val)
+#define raw_cpu_or_2(pcp, val)	percpu_to_op("or", (pcp), val)
+#define raw_cpu_or_4(pcp, val)	percpu_to_op("or", (pcp), val)
+#define raw_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define raw_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define raw_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define raw_cpu_xchg_1(pcp, val)	percpu_xchg_op(pcp, val)
+#define raw_cpu_xchg_2(pcp, val)	percpu_xchg_op(pcp, val)
+#define raw_cpu_xchg_4(pcp, val)	percpu_xchg_op(pcp, val)
 
 #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -406,12 +406,12 @@ do {									\
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
 
-#define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_add_return_4(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-#define __this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-#define __this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define raw_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
+#define raw_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
+#define raw_cpu_add_return_4(pcp, val) percpu_add_return_op(pcp, val)
+#define raw_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define raw_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define raw_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
 #define this_cpu_add_return_1(pcp, val)	percpu_add_return_op(pcp, val)
 #define this_cpu_add_return_2(pcp, val)	percpu_add_return_op(pcp, val)
@@ -432,7 +432,7 @@ do {									\
 	__ret;								\
 })
 
-#define __this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
+#define raw_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 #define this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 #endif /* CONFIG_X86_CMPXCHG64 */
 
@@ -441,15 +441,15 @@ do {									\
  * 32 bit must fall back to generic operations.
  */
 #ifdef CONFIG_X86_64
-#define __this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
-#define __this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
-#define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
-#define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
-#define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define __this_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
-#define __this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define __this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
+#define raw_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define raw_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define raw_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
+#define raw_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
+#define raw_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
+#define raw_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define raw_cpu_add_return_8(pcp, val) percpu_add_return_op(pcp, val)
+#define raw_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
+#define raw_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
 #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
@@ -481,7 +481,7 @@ do {									\
 	__ret;								\
 })
 
-#define __this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
+#define raw_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 #define this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 
 #endif
@@ -502,9 +502,9 @@ static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
 	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
 
 #ifdef CONFIG_X86_64
-	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_8(*a)) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) & raw_cpu_read_8(*a)) != 0;
 #else
-	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_4(*a)) != 0;
+	return ((1UL << (nr % BITS_PER_LONG)) & raw_cpu_read_4(*a)) != 0;
 #endif
 }
 
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index d17784ea37ff..c6d86ab3aa67 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -56,17 +56,17 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #define per_cpu(var, cpu) \
 	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
 
-#ifndef __this_cpu_ptr
-#define __this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
+#ifndef raw_cpu_ptr
+#define raw_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
 #endif
 #ifdef CONFIG_DEBUG_PREEMPT
 #define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
 #else
-#define this_cpu_ptr(ptr) __this_cpu_ptr(ptr)
+#define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
 #endif
 
 #define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
-#define __raw_get_cpu_var(var) (*__this_cpu_ptr(&(var)))
+#define __raw_get_cpu_var(var) (*raw_cpu_ptr(&(var)))
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
@@ -83,7 +83,7 @@ extern void setup_per_cpu_areas(void);
 #define __get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
 #define __raw_get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
 #define this_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
-#define __this_cpu_ptr(ptr)	this_cpu_ptr(ptr)
+#define raw_cpu_ptr(ptr)	this_cpu_ptr(ptr)
 
 #endif	/* SMP */
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index cc88172c7d9a..c9ba66e58acf 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -295,7 +295,7 @@ do {									\
 do {									\
 	unsigned long flags;						\
 	raw_local_irq_save(flags);					\
-	*__this_cpu_ptr(&(pcp)) op val;					\
+	*raw_cpu_ptr(&(pcp)) op val;					\
 	raw_local_irq_restore(flags);					\
 } while (0)
 
@@ -396,8 +396,8 @@ do {									\
 	typeof(pcp) ret__;						\
 	unsigned long flags;						\
 	raw_local_irq_save(flags);					\
-	__this_cpu_add(pcp, val);					\
-	ret__ = __this_cpu_read(pcp);					\
+	raw_cpu_add(pcp, val);					\
+	ret__ = raw_cpu_read(pcp);					\
 	raw_local_irq_restore(flags);					\
 	ret__;								\
 })
@@ -426,8 +426,8 @@ do {									\
 ({	typeof(pcp) ret__;						\
 	unsigned long flags;						\
 	raw_local_irq_save(flags);					\
-	ret__ = __this_cpu_read(pcp);					\
-	__this_cpu_write(pcp, nval);					\
+	ret__ = raw_cpu_read(pcp);					\
+	raw_cpu_write(pcp, nval);					\
 	raw_local_irq_restore(flags);					\
 	ret__;								\
 })
@@ -454,9 +454,9 @@ do {									\
 	typeof(pcp) ret__;						\
 	unsigned long flags;						\
 	raw_local_irq_save(flags);					\
-	ret__ = __this_cpu_read(pcp);					\
+	ret__ = raw_cpu_read(pcp);					\
 	if (ret__ == (oval))						\
-		__this_cpu_write(pcp, nval);				\
+		raw_cpu_write(pcp, nval);				\
 	raw_local_irq_restore(flags);					\
 	ret__;								\
 })
@@ -491,7 +491,7 @@ do {									\
 	int ret__;							\
 	unsigned long flags;						\
 	raw_local_irq_save(flags);					\
-	ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
+	ret__ = raw_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
 			oval1, oval2, nval1, nval2);			\
 	raw_local_irq_restore(flags);					\
 	ret__;								\
@@ -532,227 +532,227 @@ do {									\
  * or an interrupt occurred and the same percpu variable was modified from
  * the interrupt context.
  */
-#ifndef __this_cpu_read
-# ifndef __this_cpu_read_1
-#  define __this_cpu_read_1(pcp)	(*__this_cpu_ptr(&(pcp)))
+#ifndef raw_cpu_read
+# ifndef raw_cpu_read_1
+#  define raw_cpu_read_1(pcp)	(*raw_cpu_ptr(&(pcp)))
 # endif
-# ifndef __this_cpu_read_2
-#  define __this_cpu_read_2(pcp)	(*__this_cpu_ptr(&(pcp)))
+# ifndef raw_cpu_read_2
+#  define raw_cpu_read_2(pcp)	(*raw_cpu_ptr(&(pcp)))
 # endif
-# ifndef __this_cpu_read_4
-#  define __this_cpu_read_4(pcp)	(*__this_cpu_ptr(&(pcp)))
+# ifndef raw_cpu_read_4
+#  define raw_cpu_read_4(pcp)	(*raw_cpu_ptr(&(pcp)))
 # endif
-# ifndef __this_cpu_read_8
-#  define __this_cpu_read_8(pcp)	(*__this_cpu_ptr(&(pcp)))
+# ifndef raw_cpu_read_8
+#  define raw_cpu_read_8(pcp)	(*raw_cpu_ptr(&(pcp)))
 # endif
-# define __this_cpu_read(pcp)	__pcpu_size_call_return(__this_cpu_read_, (pcp))
+# define raw_cpu_read(pcp)	__pcpu_size_call_return(raw_cpu_read_, (pcp))
 #endif
 
-#define __this_cpu_generic_to_op(pcp, val, op)				\
+#define raw_cpu_generic_to_op(pcp, val, op)				\
 do {									\
-	*__this_cpu_ptr(&(pcp)) op val;					\
+	*raw_cpu_ptr(&(pcp)) op val;					\
 } while (0)
 
-#ifndef __this_cpu_write
-# ifndef __this_cpu_write_1
-#  define __this_cpu_write_1(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
+#ifndef raw_cpu_write
+# ifndef raw_cpu_write_1
+#  define raw_cpu_write_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
 # endif
-# ifndef __this_cpu_write_2
-#  define __this_cpu_write_2(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
+# ifndef raw_cpu_write_2
+#  define raw_cpu_write_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
 # endif
-# ifndef __this_cpu_write_4
-#  define __this_cpu_write_4(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
+# ifndef raw_cpu_write_4
+#  define raw_cpu_write_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
 # endif
-# ifndef __this_cpu_write_8
-#  define __this_cpu_write_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
+# ifndef raw_cpu_write_8
+#  define raw_cpu_write_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
 # endif
-# define __this_cpu_write(pcp, val)	__pcpu_size_call(__this_cpu_write_, (pcp), (val))
+# define raw_cpu_write(pcp, val)	__pcpu_size_call(raw_cpu_write_, (pcp), (val))
 #endif
 
-#ifndef __this_cpu_add
-# ifndef __this_cpu_add_1
-#  define __this_cpu_add_1(pcp, val)	__this_cpu_generic_to_op((pcp), (val), +=)
+#ifndef raw_cpu_add
+# ifndef raw_cpu_add_1
+#  define raw_cpu_add_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# ifndef __this_cpu_add_2
-#  define __this_cpu_add_2(pcp, val)	__this_cpu_generic_to_op((pcp), (val), +=)
+# ifndef raw_cpu_add_2
+#  define raw_cpu_add_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# ifndef __this_cpu_add_4
-#  define __this_cpu_add_4(pcp, val)	__this_cpu_generic_to_op((pcp), (val), +=)
+# ifndef raw_cpu_add_4
+#  define raw_cpu_add_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# ifndef __this_cpu_add_8
-#  define __this_cpu_add_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), +=)
+# ifndef raw_cpu_add_8
+#  define raw_cpu_add_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# define __this_cpu_add(pcp, val)	__pcpu_size_call(__this_cpu_add_, (pcp), (val))
+# define raw_cpu_add(pcp, val)	__pcpu_size_call(raw_cpu_add_, (pcp), (val))
 #endif
 
-#ifndef __this_cpu_sub
-# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(val))
+#ifndef raw_cpu_sub
+# define raw_cpu_sub(pcp, val)	raw_cpu_add((pcp), -(val))
 #endif
 
-#ifndef __this_cpu_inc
-# define __this_cpu_inc(pcp)		__this_cpu_add((pcp), 1)
+#ifndef raw_cpu_inc
+# define raw_cpu_inc(pcp)		raw_cpu_add((pcp), 1)
 #endif
 
-#ifndef __this_cpu_dec
-# define __this_cpu_dec(pcp)		__this_cpu_sub((pcp), 1)
+#ifndef raw_cpu_dec
+# define raw_cpu_dec(pcp)		raw_cpu_sub((pcp), 1)
 #endif
 
-#ifndef __this_cpu_and
-# ifndef __this_cpu_and_1
-#  define __this_cpu_and_1(pcp, val)	__this_cpu_generic_to_op((pcp), (val), &=)
+#ifndef raw_cpu_and
+# ifndef raw_cpu_and_1
+#  define raw_cpu_and_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# ifndef __this_cpu_and_2
-#  define __this_cpu_and_2(pcp, val)	__this_cpu_generic_to_op((pcp), (val), &=)
+# ifndef raw_cpu_and_2
+#  define raw_cpu_and_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# ifndef __this_cpu_and_4
-#  define __this_cpu_and_4(pcp, val)	__this_cpu_generic_to_op((pcp), (val), &=)
+# ifndef raw_cpu_and_4
+#  define raw_cpu_and_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# ifndef __this_cpu_and_8
-#  define __this_cpu_and_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), &=)
+# ifndef raw_cpu_and_8
+#  define raw_cpu_and_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# define __this_cpu_and(pcp, val)	__pcpu_size_call(__this_cpu_and_, (pcp), (val))
+# define raw_cpu_and(pcp, val)	__pcpu_size_call(raw_cpu_and_, (pcp), (val))
 #endif
 
-#ifndef __this_cpu_or
-# ifndef __this_cpu_or_1
-#  define __this_cpu_or_1(pcp, val)	__this_cpu_generic_to_op((pcp), (val), |=)
+#ifndef raw_cpu_or
+# ifndef raw_cpu_or_1
+#  define raw_cpu_or_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# ifndef __this_cpu_or_2
-#  define __this_cpu_or_2(pcp, val)	__this_cpu_generic_to_op((pcp), (val), |=)
+# ifndef raw_cpu_or_2
+#  define raw_cpu_or_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# ifndef __this_cpu_or_4
-#  define __this_cpu_or_4(pcp, val)	__this_cpu_generic_to_op((pcp), (val), |=)
+# ifndef raw_cpu_or_4
+#  define raw_cpu_or_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# ifndef __this_cpu_or_8
-#  define __this_cpu_or_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), |=)
+# ifndef raw_cpu_or_8
+#  define raw_cpu_or_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# define __this_cpu_or(pcp, val)	__pcpu_size_call(__this_cpu_or_, (pcp), (val))
+# define raw_cpu_or(pcp, val)	__pcpu_size_call(raw_cpu_or_, (pcp), (val))
 #endif
 
-#ifndef __this_cpu_xor
-# ifndef __this_cpu_xor_1
-#  define __this_cpu_xor_1(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
+#ifndef raw_cpu_xor
+# ifndef raw_cpu_xor_1
+#  define raw_cpu_xor_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# ifndef __this_cpu_xor_2
-#  define __this_cpu_xor_2(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
+# ifndef raw_cpu_xor_2
+#  define raw_cpu_xor_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# ifndef __this_cpu_xor_4
-#  define __this_cpu_xor_4(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
+# ifndef raw_cpu_xor_4
+#  define raw_cpu_xor_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# ifndef __this_cpu_xor_8
-#  define __this_cpu_xor_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
+# ifndef raw_cpu_xor_8
+#  define raw_cpu_xor_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
+# define raw_cpu_xor(pcp, val)	__pcpu_size_call(raw_cpu_xor_, (pcp), (val))
 #endif
 
-#define __this_cpu_generic_add_return(pcp, val)				\
+#define raw_cpu_generic_add_return(pcp, val)				\
 ({									\
-	__this_cpu_add(pcp, val);					\
-	__this_cpu_read(pcp);						\
+	raw_cpu_add(pcp, val);					\
+	raw_cpu_read(pcp);						\
 })
 
-#ifndef __this_cpu_add_return
-# ifndef __this_cpu_add_return_1
-#  define __this_cpu_add_return_1(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+#ifndef raw_cpu_add_return
+# ifndef raw_cpu_add_return_1
+#  define raw_cpu_add_return_1(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
-# ifndef __this_cpu_add_return_2
-#  define __this_cpu_add_return_2(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# ifndef raw_cpu_add_return_2
+#  define raw_cpu_add_return_2(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
-# ifndef __this_cpu_add_return_4
-#  define __this_cpu_add_return_4(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# ifndef raw_cpu_add_return_4
+#  define raw_cpu_add_return_4(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
-# ifndef __this_cpu_add_return_8
-#  define __this_cpu_add_return_8(pcp, val)	__this_cpu_generic_add_return(pcp, val)
+# ifndef raw_cpu_add_return_8
+#  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
-# define __this_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
+# define raw_cpu_add_return(pcp, val)	\
+	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
 #endif
 
-#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(val))
-#define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
-#define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
+#define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(val))
+#define raw_cpu_inc_return(pcp)	raw_cpu_add_return(pcp, 1)
+#define raw_cpu_dec_return(pcp)	raw_cpu_add_return(pcp, -1)
 
-#define __this_cpu_generic_xchg(pcp, nval)				\
+#define raw_cpu_generic_xchg(pcp, nval)				\
 ({	typeof(pcp) ret__;						\
-	ret__ = __this_cpu_read(pcp);					\
-	__this_cpu_write(pcp, nval);					\
+	ret__ = raw_cpu_read(pcp);					\
+	raw_cpu_write(pcp, nval);					\
 	ret__;								\
 })
 
-#ifndef __this_cpu_xchg
-# ifndef __this_cpu_xchg_1
-#  define __this_cpu_xchg_1(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
+#ifndef raw_cpu_xchg
+# ifndef raw_cpu_xchg_1
+#  define raw_cpu_xchg_1(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
 # endif
-# ifndef __this_cpu_xchg_2
-#  define __this_cpu_xchg_2(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
+# ifndef raw_cpu_xchg_2
+#  define raw_cpu_xchg_2(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
 # endif
-# ifndef __this_cpu_xchg_4
-#  define __this_cpu_xchg_4(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
+# ifndef raw_cpu_xchg_4
+#  define raw_cpu_xchg_4(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
 # endif
-# ifndef __this_cpu_xchg_8
-#  define __this_cpu_xchg_8(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
+# ifndef raw_cpu_xchg_8
+#  define raw_cpu_xchg_8(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
 # endif
-# define __this_cpu_xchg(pcp, nval)	\
-	__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval)
+# define raw_cpu_xchg(pcp, nval)	\
+	__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval)
 #endif
 
-#define __this_cpu_generic_cmpxchg(pcp, oval, nval)			\
+#define raw_cpu_generic_cmpxchg(pcp, oval, nval)			\
 ({									\
 	typeof(pcp) ret__;						\
-	ret__ = __this_cpu_read(pcp);					\
+	ret__ = raw_cpu_read(pcp);					\
 	if (ret__ == (oval))						\
-		__this_cpu_write(pcp, nval);				\
+		raw_cpu_write(pcp, nval);				\
 	ret__;								\
 })
 
-#ifndef __this_cpu_cmpxchg
-# ifndef __this_cpu_cmpxchg_1
-#  define __this_cpu_cmpxchg_1(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
+#ifndef raw_cpu_cmpxchg
+# ifndef raw_cpu_cmpxchg_1
+#  define raw_cpu_cmpxchg_1(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
-# ifndef __this_cpu_cmpxchg_2
-#  define __this_cpu_cmpxchg_2(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
+# ifndef raw_cpu_cmpxchg_2
+#  define raw_cpu_cmpxchg_2(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
-# ifndef __this_cpu_cmpxchg_4
-#  define __this_cpu_cmpxchg_4(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
+# ifndef raw_cpu_cmpxchg_4
+#  define raw_cpu_cmpxchg_4(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
-# ifndef __this_cpu_cmpxchg_8
-#  define __this_cpu_cmpxchg_8(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
+# ifndef raw_cpu_cmpxchg_8
+#  define raw_cpu_cmpxchg_8(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
-# define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval)
+# define raw_cpu_cmpxchg(pcp, oval, nval)	\
+	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
 #endif
 
-#define __this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+#define raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 ({									\
 	int __ret = 0;							\
-	if (__this_cpu_read(pcp1) == (oval1) &&				\
-			 __this_cpu_read(pcp2)  == (oval2)) {		\
-		__this_cpu_write(pcp1, (nval1));			\
-		__this_cpu_write(pcp2, (nval2));			\
+	if (raw_cpu_read(pcp1) == (oval1) &&				\
+			 raw_cpu_read(pcp2)  == (oval2)) {		\
+		raw_cpu_write(pcp1, (nval1));			\
+		raw_cpu_write(pcp2, (nval2));			\
 		__ret = 1;						\
 	}								\
 	(__ret);							\
 })
 
-#ifndef __this_cpu_cmpxchg_double
-# ifndef __this_cpu_cmpxchg_double_1
-#  define __this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+#ifndef raw_cpu_cmpxchg_double
+# ifndef raw_cpu_cmpxchg_double_1
+#  define raw_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
-# ifndef __this_cpu_cmpxchg_double_2
-#  define __this_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# ifndef raw_cpu_cmpxchg_double_2
+#  define raw_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
-# ifndef __this_cpu_cmpxchg_double_4
-#  define __this_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# ifndef raw_cpu_cmpxchg_double_4
+#  define raw_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
-# ifndef __this_cpu_cmpxchg_double_8
-#  define __this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# ifndef raw_cpu_cmpxchg_double_8
+#  define raw_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
-# define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+# define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 #endif
 
 #endif /* __LINUX_PERCPU_H */
