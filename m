Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3IWTY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:24:27 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:51615 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab3IWTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:24:26 -0400
Message-Id: <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 23 Sep 2013 19:24:25 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu ops
References: <20130923191256.584672290@linux.com>
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We define a check function in order to avoid trouble with the
include files. Then the higher level __this_cpu macros are
modified to invoke the check before __this_cpu operation

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-09-23 10:24:47.371629684 -0500
+++ linux/include/linux/percpu.h	2013-09-23 10:26:01.314865122 -0500
@@ -175,6 +175,12 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
 
 extern void __bad_size_call_parameter(void);
 
+#ifdef CONFIG_DEBUG_PREEMPT
+extern void __this_cpu_preempt_check(void);
+#else
+static inline void __this_cpu_preempt_check(void) { }
+#endif
+
 #define __pcpu_size_call_return(stem, variable)				\
 ({	typeof(variable) pscr_ret__;					\
 	__verify_pcpu_ptr(&(variable));					\
@@ -538,7 +544,8 @@ do {									\
 # ifndef __this_cpu_read_8
 #  define __this_cpu_read_8(pcp)	(*__this_cpu_ptr(&(pcp)))
 # endif
-# define __this_cpu_read(pcp)	__pcpu_size_call_return(__this_cpu_read_, (pcp))
+# define __this_cpu_read(pcp) \
+	(__this_cpu_preempt_check(),__pcpu_size_call_return(__this_cpu_read_, (pcp)))
 #endif
 
 #define __this_cpu_generic_to_op(pcp, val, op)				\
@@ -559,7 +566,12 @@ do {									\
 # ifndef __this_cpu_write_8
 #  define __this_cpu_write_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
 # endif
-# define __this_cpu_write(pcp, val)	__pcpu_size_call(__this_cpu_write_, (pcp), (val))
+
+# define __this_cpu_write(pcp, val) \
+do { __this_cpu_preempt_check();					\
+     __pcpu_size_call(__this_cpu_write_, (pcp), (val));			\
+} while (0)
+
 #endif
 
 #ifndef __this_cpu_add
@@ -575,7 +587,12 @@ do {									\
 # ifndef __this_cpu_add_8
 #  define __this_cpu_add_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# define __this_cpu_add(pcp, val)	__pcpu_size_call(__this_cpu_add_, (pcp), (val))
+
+# define __this_cpu_add(pcp, val) \
+do { __this_cpu_preempt_check();					\
+	__pcpu_size_call(__this_cpu_add_, (pcp), (val));		\
+} while (0)
+
 #endif
 
 #ifndef __this_cpu_sub
@@ -603,7 +620,12 @@ do {									\
 # ifndef __this_cpu_and_8
 #  define __this_cpu_and_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# define __this_cpu_and(pcp, val)	__pcpu_size_call(__this_cpu_and_, (pcp), (val))
+
+# define __this_cpu_and(pcp, val) \
+do { __this_cpu_preempt_check();					\
+	__pcpu_size_call(__this_cpu_and_, (pcp), (val));		\
+} while (0)
+
 #endif
 
 #ifndef __this_cpu_or
@@ -619,7 +641,12 @@ do {									\
 # ifndef __this_cpu_or_8
 #  define __this_cpu_or_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# define __this_cpu_or(pcp, val)	__pcpu_size_call(__this_cpu_or_, (pcp), (val))
+
+# define __this_cpu_or(pcp, val)	\
+do { __this_cpu_preempt_check();					\
+	__pcpu_size_call(__this_cpu_or_, (pcp), (val));			\
+} while (0)
+
 #endif
 
 #ifndef __this_cpu_xor
@@ -635,7 +662,12 @@ do {									\
 # ifndef __this_cpu_xor_8
 #  define __this_cpu_xor_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
+
+# define __this_cpu_xor(pcp, val) \
+do { __this_cpu_preempt_check();					\
+	__pcpu_size_call(__this_cpu_xor_, (pcp), (val));		\
+} while (0)
+
 #endif
 
 #define __this_cpu_generic_add_return(pcp, val)				\
@@ -658,7 +690,7 @@ do {									\
 #  define __this_cpu_add_return_8(pcp, val)	__this_cpu_generic_add_return(pcp, val)
 # endif
 # define __this_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
+	(__this_cpu_preempt_check(),__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val))
 #endif
 
 #define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(val))
@@ -686,7 +718,7 @@ do {									\
 #  define __this_cpu_xchg_8(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
 # endif
 # define __this_cpu_xchg(pcp, nval)	\
-	__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval)
+	(__this_cpu_preempt_check(),__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval))
 #endif
 
 #define __this_cpu_generic_cmpxchg(pcp, oval, nval)			\
@@ -712,7 +744,7 @@ do {									\
 #  define __this_cpu_cmpxchg_8(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
 # define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval)
+	(__this_cpu_preempt_check(),__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval))
 #endif
 
 #define __this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
@@ -745,7 +777,7 @@ do {									\
 	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
 # define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	(__this_cpu_preempt_check(),__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
 #endif
 
 /*
Index: linux/kernel/sched/core.c
===================================================================
--- linux.orig/kernel/sched/core.c	2013-09-23 10:24:47.371629684 -0500
+++ linux/kernel/sched/core.c	2013-09-23 10:24:47.371629684 -0500
@@ -2566,6 +2566,29 @@ asmlinkage void __sched preempt_schedule
 	exception_exit(prev_state);
 }
 
+#ifdef CONFIG_DEBUG_PREEMPT
+/*
+ * This function is called if the kernel is compiled with preempt
+ * support for each __this_cpu operations. It verifies that
+ * preemption has been disabled.
+ *
+ * The function cannot be a macro due to the low level nature
+ * of the per cpu header files.
+ */
+void __this_cpu_preempt_check(void)
+{
+	int p;
+
+	p = preemptible();
+	if (p) {
+		printk(KERN_ERR "__this_cpu but preemptable."
+			" preempt_count=%d irqs_disabled=%d\n",
+			preempt_count(), irqs_disabled());
+		dump_stack();
+	}
+
+}
+#endif /* CONFIG_DEBUG_PREEMPT */
 #endif /* CONFIG_PREEMPT */
 
 int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,

