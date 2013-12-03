Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3LCXsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:48:31 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:50637
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802Ab3LCXi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:38:59 -0500
Message-Id: <20131203233251.745099192@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:45 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 13/41] percpu: Add raw_cpu_ops
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=raw_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches following this one will add preemption checks to __this_cpu
ops so we need to have an alternative way to use this_cpu operations
without preemption checks.

raw_cpu_ops will be the basis for all other ops since these will be the
operations that do not implement any checks. 

Primitive operations are renamed by this patch from __this_cpu_xxx to
raw_cpu_xxxx.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-12-02 16:07:50.634610204 -0600
+++ linux/include/linux/percpu.h	2013-12-02 16:09:21.000000000 -0600
@@ -139,6 +139,9 @@ extern int __init pcpu_page_first_chunk(
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 #endif
 
+/* Keep until we have removed all uses of __this_cpu_ptr */
+#define __this_cpu_ptr raw_cpu_ptr
+
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's
@@ -242,6 +245,8 @@ do {									\
 } while (0)
 
 /*
+ * this_cpu operations (C) 2008-2013 Christoph Lameter <cl@linux.com>
+ *
  * Optimized manipulation for memory allocated through the per cpu
  * allocator or for addresses of per cpu variables.
  *
@@ -295,7 +300,7 @@ do {									\
 do {									\
 	unsigned long flags;						\
 	raw_local_irq_save(flags);					\
-	*__this_cpu_ptr(&(pcp)) op val;					\
+	*raw_cpu_ptr(&(pcp)) op val;					\
 	raw_local_irq_restore(flags);					\
 } while (0)
 
@@ -380,8 +385,8 @@ do {									\
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
@@ -410,8 +415,8 @@ do {									\
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
@@ -438,9 +443,9 @@ do {									\
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
@@ -475,7 +480,7 @@ do {									\
 	int ret__;							\
 	unsigned long flags;						\
 	raw_local_irq_save(flags);					\
-	ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
+	ret__ = raw_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
 			oval1, oval2, nval1, nval2);			\
 	raw_local_irq_restore(flags);					\
 	ret__;								\
@@ -503,12 +508,8 @@ do {									\
 #endif
 
 /*
- * Generic percpu operations for context that are safe from preemption/interrupts.
- * Either we do not care about races or the caller has the
- * responsibility of handling preemption/interrupt issues. Arch code can still
- * override these instructions since the arch per cpu code may be more
- * efficient and may actually get race freeness for free (that is the
- * case for x86 for example).
+ * Generic percpu operations for contexts where we do not want to do
+ * any checks for preemptiosn.
  *
  * If there is no other protection through preempt disable and/or
  * disabling interupts then one of these RMW operations can show unexpected
@@ -516,211 +517,272 @@ do {									\
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
+
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
-# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
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
 
-#define __this_cpu_generic_add_return(pcp, val)				\
+#define raw_cpu_generic_add_return(pcp, val)				\
 ({									\
-	__this_cpu_add(pcp, val);					\
-	__this_cpu_read(pcp);						\
+	raw_cpu_add(pcp, val);						\
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
+	__pcpu_size_call_return2(raw_add_return_, pcp, val)
 #endif
 
-#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
-#define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
-#define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
+#define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
+#define raw_cpu_inc_return(pcp)	raw_cpu_add_return(pcp, 1)
+#define raw_cpu_dec_return(pcp)	raw_cpu_add_return(pcp, -1)
 
-#define __this_cpu_generic_xchg(pcp, nval)				\
+#define raw_cpu_generic_xchg(pcp, nval)					\
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
+		raw_cpu_write(pcp1, (nval1));				\
+		raw_cpu_write(pcp2, (nval2));				\
 		__ret = 1;						\
 	}								\
 	(__ret);							\
 })
 
-#ifndef __this_cpu_cmpxchg_double
-# ifndef __this_cpu_cmpxchg_double_1
-#  define __this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef __this_cpu_cmpxchg_double_2
-#  define __this_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef __this_cpu_cmpxchg_double_4
-#  define __this_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef __this_cpu_cmpxchg_double_8
-#  define __this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+#ifndef raw_cpu_cmpxchg_double
+# ifndef raw_cpu_cmpxchg_double_1
+#  define raw_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef raw_cpu_cmpxchg_double_2
+#  define raw_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef raw_cpu_cmpxchg_double_4
+#  define raw_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef raw_cpu_cmpxchg_double_8
+#  define raw_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
+# define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+#endif
+
+/*
+ * Generic percpu operations for context that are safe from preemption/interrupts.
+ * Checks will be added here soon.
+ */
+#ifndef __this_cpu_read
+# define __this_cpu_read(pcp)	__pcpu_size_call_return(raw_cpu_read_, (pcp))
+#endif
+
+#ifndef __this_cpu_write
+# define __this_cpu_write(pcp, val)	__pcpu_size_call(raw_cpu_write_, (pcp), (val))
+#endif
+
+#ifndef __this_cpu_add
+# define __this_cpu_add(pcp, val)	__pcpu_size_call(raw_cpu_add_, (pcp), (val))
+#endif
+
+#ifndef __this_cpu_sub
+# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
+#endif
+
+#ifndef __this_cpu_inc
+# define __this_cpu_inc(pcp)		__this_cpu_add((pcp), 1)
+#endif
+
+#ifndef __this_cpu_dec
+# define __this_cpu_dec(pcp)		__this_cpu_sub((pcp), 1)
+#endif
+
+#ifndef __this_cpu_and
+# define __this_cpu_and(pcp, val)	__pcpu_size_call(raw_cpu_and_, (pcp), (val))
+#endif
+
+#ifndef __this_cpu_or
+# define __this_cpu_or(pcp, val)	__pcpu_size_call(raw_cpu_or_, (pcp), (val))
+#endif
+
+#ifndef __this_cpu_add_return
+# define __this_cpu_add_return(pcp, val)	\
+	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
+#endif
+
+#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
+#define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
+#define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
+
+#ifndef __this_cpu_xchg
+# define __this_cpu_xchg(pcp, nval)	\
+	__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval)
+#endif
+
+#ifndef __this_cpu_cmpxchg
+# define __this_cpu_cmpxchg(pcp, oval, nval)	\
+	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
+#endif
+
+#ifndef __this_cpu_cmpxchg_double
 # define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 #endif
 
 #endif /* __LINUX_PERCPU_H */
Index: linux/arch/x86/include/asm/percpu.h
===================================================================
--- linux.orig/arch/x86/include/asm/percpu.h	2013-12-02 16:07:50.634610204 -0600
+++ linux/arch/x86/include/asm/percpu.h	2013-12-02 16:09:23.000000000 -0600
@@ -52,7 +52,7 @@
  * Compared to the generic __my_cpu_offset version, the following
  * saves one instruction and avoids clobbering a temp register.
  */
-#define __this_cpu_ptr(ptr)				\
+#define raw_cpu_ptr(ptr)				\
 ({							\
 	unsigned long tcp_ptr__;			\
 	__verify_pcpu_ptr(ptr);				\
Index: linux/include/asm-generic/percpu.h
===================================================================
--- linux.orig/include/asm-generic/percpu.h	2013-12-02 16:07:50.634610204 -0600
+++ linux/include/asm-generic/percpu.h	2013-12-02 16:09:09.000000000 -0600
@@ -56,17 +56,17 @@ extern unsigned long __per_cpu_offset[NR
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
 

