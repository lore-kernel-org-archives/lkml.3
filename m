Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbaFLQXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:23:46 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39447 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaFLQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:42 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/12] percpu: only allow sized arch overrides for {raw|this}_cpu_*() ops
Date: Thu, 12 Jun 2014 12:23:23 -0400
Message-Id: <1402590209-31610-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, percpu allows two separate methods for overriding
{raw|this}_cpu_*() ops - for a given operation, an arch can provide
whole replacement or sized sub operations to override specific parts
of it.  e.g. arch either can provide this_cpu_add() or
this_cpu_add_4() to override only the 4 byte operation.

While quite flexible on a glance, the dual-overriding scheme
complicates the code path for no actual gain.  It compilcates the
already complex operation definitions and if an arch wants to override
all sizes, it can easily provide all variants anyway.  In fact, no
arch is actually making use of whole operation override.

Another oddity is that __this_cpu_*() operations are defined in the
same way as raw_cpu_*() but ignores full overrides of the raw_cpu_*()
and doesn't allow full operation override, so if an arch provides
whole overrides for raw_cpu_*() operations __this_cpu_*() ends up
using the generic implementations.

More importantly, it takes away the layering between arch-specific and
generic parts making it impossible for the generic part to implement
arch-independent features on top of arch-specific overrides.

This patch removes the support for whole operation overrides.  As no
arch is using it, this doesn't cause any actual difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu.h | 94 +++-----------------------------------------------
 1 file changed, 5 insertions(+), 89 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 97b2079..95d380e 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -226,17 +226,11 @@ do {									\
  * safe. Interrupts may occur. If the interrupt modifies the variable
  * too then RMW actions will not be reliable.
  *
- * The arch code can provide optimized functions in two ways:
- *
- * 1. Override the function completely. F.e. define this_cpu_add().
- *    The arch must then ensure that the various scalar format passed
- *    are handled correctly.
- *
- * 2. Provide functions for certain scalar sizes. F.e. provide
- *    this_cpu_add_2() to provide per cpu atomic operations for 2 byte
- *    sized RMW actions. If arch code does not provide operations for
- *    a scalar size then the fallback in the generic code will be
- *    used.
+ * The arch code can provide optimized implementation by defining macros
+ * for certain scalar sizes. F.e. provide this_cpu_add_2() to provide per
+ * cpu atomic operations for 2 byte sized RMW actions. If arch code does
+ * not provide operations for a scalar size then the fallback in the
+ * generic code will be used.
  */
 
 #define _this_cpu_generic_read(pcp)					\
@@ -247,7 +241,6 @@ do {									\
 	ret__;								\
 })
 
-#ifndef this_cpu_read
 # ifndef this_cpu_read_1
 #  define this_cpu_read_1(pcp)	_this_cpu_generic_read(pcp)
 # endif
@@ -261,7 +254,6 @@ do {									\
 #  define this_cpu_read_8(pcp)	_this_cpu_generic_read(pcp)
 # endif
 # define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
-#endif
 
 #define _this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
@@ -271,7 +263,6 @@ do {									\
 	raw_local_irq_restore(flags);					\
 } while (0)
 
-#ifndef this_cpu_write
 # ifndef this_cpu_write_1
 #  define this_cpu_write_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
 # endif
@@ -285,9 +276,7 @@ do {									\
 #  define this_cpu_write_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
 # endif
 # define this_cpu_write(pcp, val)	__pcpu_size_call(this_cpu_write_, (pcp), (val))
-#endif
 
-#ifndef this_cpu_add
 # ifndef this_cpu_add_1
 #  define this_cpu_add_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
 # endif
@@ -301,21 +290,11 @@ do {									\
 #  define this_cpu_add_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
 # endif
 # define this_cpu_add(pcp, val)		__pcpu_size_call(this_cpu_add_, (pcp), (val))
-#endif
 
-#ifndef this_cpu_sub
 # define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(typeof(pcp))(val))
-#endif
-
-#ifndef this_cpu_inc
 # define this_cpu_inc(pcp)		this_cpu_add((pcp), 1)
-#endif
-
-#ifndef this_cpu_dec
 # define this_cpu_dec(pcp)		this_cpu_sub((pcp), 1)
-#endif
 
-#ifndef this_cpu_and
 # ifndef this_cpu_and_1
 #  define this_cpu_and_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
 # endif
@@ -329,9 +308,7 @@ do {									\
 #  define this_cpu_and_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
 # endif
 # define this_cpu_and(pcp, val)		__pcpu_size_call(this_cpu_and_, (pcp), (val))
-#endif
 
-#ifndef this_cpu_or
 # ifndef this_cpu_or_1
 #  define this_cpu_or_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
 # endif
@@ -345,7 +322,6 @@ do {									\
 #  define this_cpu_or_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
 # endif
 # define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
-#endif
 
 #define _this_cpu_generic_add_return(pcp, val)				\
 ({									\
@@ -358,7 +334,6 @@ do {									\
 	ret__;								\
 })
 
-#ifndef this_cpu_add_return
 # ifndef this_cpu_add_return_1
 #  define this_cpu_add_return_1(pcp, val)	_this_cpu_generic_add_return(pcp, val)
 # endif
@@ -372,7 +347,6 @@ do {									\
 #  define this_cpu_add_return_8(pcp, val)	_this_cpu_generic_add_return(pcp, val)
 # endif
 # define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
-#endif
 
 #define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
@@ -388,7 +362,6 @@ do {									\
 	ret__;								\
 })
 
-#ifndef this_cpu_xchg
 # ifndef this_cpu_xchg_1
 #  define this_cpu_xchg_1(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
 # endif
@@ -403,7 +376,6 @@ do {									\
 # endif
 # define this_cpu_xchg(pcp, nval)	\
 	__pcpu_size_call_return2(this_cpu_xchg_, (pcp), nval)
-#endif
 
 #define _this_cpu_generic_cmpxchg(pcp, oval, nval)			\
 ({									\
@@ -417,7 +389,6 @@ do {									\
 	ret__;								\
 })
 
-#ifndef this_cpu_cmpxchg
 # ifndef this_cpu_cmpxchg_1
 #  define this_cpu_cmpxchg_1(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
@@ -432,7 +403,6 @@ do {									\
 # endif
 # define this_cpu_cmpxchg(pcp, oval, nval)	\
 	__pcpu_size_call_return2(this_cpu_cmpxchg_, pcp, oval, nval)
-#endif
 
 /*
  * cmpxchg_double replaces two adjacent scalars at once.  The first
@@ -453,7 +423,6 @@ do {									\
 	ret__;								\
 })
 
-#ifndef this_cpu_cmpxchg_double
 # ifndef this_cpu_cmpxchg_double_1
 #  define this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
@@ -472,7 +441,6 @@ do {									\
 # endif
 # define this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	__pcpu_double_call_return_bool(this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
-#endif
 
 /*
  * Generic percpu operations for contexts where we do not want to do
@@ -484,7 +452,6 @@ do {									\
  * or an interrupt occurred and the same percpu variable was modified from
  * the interrupt context.
  */
-#ifndef raw_cpu_read
 # ifndef raw_cpu_read_1
 #  define raw_cpu_read_1(pcp)	(*raw_cpu_ptr(&(pcp)))
 # endif
@@ -498,15 +465,12 @@ do {									\
 #  define raw_cpu_read_8(pcp)	(*raw_cpu_ptr(&(pcp)))
 # endif
 # define raw_cpu_read(pcp)	__pcpu_size_call_return(raw_cpu_read_, (pcp))
-#endif
 
 #define raw_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	*raw_cpu_ptr(&(pcp)) op val;					\
 } while (0)
 
-
-#ifndef raw_cpu_write
 # ifndef raw_cpu_write_1
 #  define raw_cpu_write_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
 # endif
@@ -520,9 +484,7 @@ do {									\
 #  define raw_cpu_write_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
 # endif
 # define raw_cpu_write(pcp, val)	__pcpu_size_call(raw_cpu_write_, (pcp), (val))
-#endif
 
-#ifndef raw_cpu_add
 # ifndef raw_cpu_add_1
 #  define raw_cpu_add_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
 # endif
@@ -536,21 +498,13 @@ do {									\
 #  define raw_cpu_add_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
 # endif
 # define raw_cpu_add(pcp, val)	__pcpu_size_call(raw_cpu_add_, (pcp), (val))
-#endif
 
-#ifndef raw_cpu_sub
 # define raw_cpu_sub(pcp, val)	raw_cpu_add((pcp), -(val))
-#endif
 
-#ifndef raw_cpu_inc
 # define raw_cpu_inc(pcp)		raw_cpu_add((pcp), 1)
-#endif
 
-#ifndef raw_cpu_dec
 # define raw_cpu_dec(pcp)		raw_cpu_sub((pcp), 1)
-#endif
 
-#ifndef raw_cpu_and
 # ifndef raw_cpu_and_1
 #  define raw_cpu_and_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
 # endif
@@ -564,9 +518,7 @@ do {									\
 #  define raw_cpu_and_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
 # endif
 # define raw_cpu_and(pcp, val)	__pcpu_size_call(raw_cpu_and_, (pcp), (val))
-#endif
 
-#ifndef raw_cpu_or
 # ifndef raw_cpu_or_1
 #  define raw_cpu_or_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
 # endif
@@ -580,7 +532,6 @@ do {									\
 #  define raw_cpu_or_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
 # endif
 # define raw_cpu_or(pcp, val)	__pcpu_size_call(raw_cpu_or_, (pcp), (val))
-#endif
 
 #define raw_cpu_generic_add_return(pcp, val)				\
 ({									\
@@ -588,7 +539,6 @@ do {									\
 	raw_cpu_read(pcp);						\
 })
 
-#ifndef raw_cpu_add_return
 # ifndef raw_cpu_add_return_1
 #  define raw_cpu_add_return_1(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
@@ -603,7 +553,6 @@ do {									\
 # endif
 # define raw_cpu_add_return(pcp, val)	\
 	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
-#endif
 
 #define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define raw_cpu_inc_return(pcp)	raw_cpu_add_return(pcp, 1)
@@ -616,7 +565,6 @@ do {									\
 	ret__;								\
 })
 
-#ifndef raw_cpu_xchg
 # ifndef raw_cpu_xchg_1
 #  define raw_cpu_xchg_1(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
 # endif
@@ -631,7 +579,6 @@ do {									\
 # endif
 # define raw_cpu_xchg(pcp, nval)	\
 	__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval)
-#endif
 
 #define raw_cpu_generic_cmpxchg(pcp, oval, nval)			\
 ({									\
@@ -642,7 +589,6 @@ do {									\
 	ret__;								\
 })
 
-#ifndef raw_cpu_cmpxchg
 # ifndef raw_cpu_cmpxchg_1
 #  define raw_cpu_cmpxchg_1(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
@@ -657,7 +603,6 @@ do {									\
 # endif
 # define raw_cpu_cmpxchg(pcp, oval, nval)	\
 	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
-#endif
 
 #define raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 ({									\
@@ -671,7 +616,6 @@ do {									\
 	(__ret);							\
 })
 
-#ifndef raw_cpu_cmpxchg_double
 # ifndef raw_cpu_cmpxchg_double_1
 #  define raw_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
@@ -690,79 +634,51 @@ do {									\
 # endif
 # define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
-#endif
 
 /*
  * Generic percpu operations for context that are safe from preemption/interrupts.
  */
-#ifndef __this_cpu_read
 # define __this_cpu_read(pcp) \
 	(__this_cpu_preempt_check("read"),__pcpu_size_call_return(raw_cpu_read_, (pcp)))
-#endif
 
-#ifndef __this_cpu_write
 # define __this_cpu_write(pcp, val)					\
 do { __this_cpu_preempt_check("write");					\
      __pcpu_size_call(raw_cpu_write_, (pcp), (val));			\
 } while (0)
-#endif
 
-#ifndef __this_cpu_add
 # define __this_cpu_add(pcp, val)					 \
 do { __this_cpu_preempt_check("add");					\
 	__pcpu_size_call(raw_cpu_add_, (pcp), (val));			\
 } while (0)
-#endif
 
-#ifndef __this_cpu_sub
 # define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
-#endif
-
-#ifndef __this_cpu_inc
 # define __this_cpu_inc(pcp)		__this_cpu_add((pcp), 1)
-#endif
-
-#ifndef __this_cpu_dec
 # define __this_cpu_dec(pcp)		__this_cpu_sub((pcp), 1)
-#endif
 
-#ifndef __this_cpu_and
 # define __this_cpu_and(pcp, val)					\
 do { __this_cpu_preempt_check("and");					\
 	__pcpu_size_call(raw_cpu_and_, (pcp), (val));			\
 } while (0)
 
-#endif
-
-#ifndef __this_cpu_or
 # define __this_cpu_or(pcp, val)					\
 do { __this_cpu_preempt_check("or");					\
 	__pcpu_size_call(raw_cpu_or_, (pcp), (val));			\
 } while (0)
-#endif
 
-#ifndef __this_cpu_add_return
 # define __this_cpu_add_return(pcp, val)	\
 	(__this_cpu_preempt_check("add_return"),__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val))
-#endif
 
 #define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
 #define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
 
-#ifndef __this_cpu_xchg
 # define __this_cpu_xchg(pcp, nval)	\
 	(__this_cpu_preempt_check("xchg"),__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval))
-#endif
 
-#ifndef __this_cpu_cmpxchg
 # define __this_cpu_cmpxchg(pcp, oval, nval)	\
 	(__this_cpu_preempt_check("cmpxchg"),__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval))
-#endif
 
-#ifndef __this_cpu_cmpxchg_double
 # define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	(__this_cpu_preempt_check("cmpxchg_double"),__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
-#endif
 
 #endif /* __LINUX_PERCPU_H */
-- 
1.9.3

