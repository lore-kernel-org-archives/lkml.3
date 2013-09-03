Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167Ab3ICWdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:33:25 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:50704 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755631Ab3ICWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:33:22 -0400
Message-ID: <00000140e5f56965-daead878-020f-4dd9-b239-5547db26f274-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Tue, 3 Sep 2013 22:33:20 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [gcv v4 05/38] percpu: Add preemption checks to __this_cpu ops
References: <20130903190014.794420260@linux.com>
X-SES-Outgoing: 2013.09.03-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We define a check function in order to avoid trouble with the
include files. Then the higher level __this_cpu macros are
modified to involve the check before any operation.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-09-03 13:38:49.818888738 -0500
+++ linux/include/linux/percpu.h	2013-09-03 13:38:49.810888819 -0500
@@ -172,6 +172,12 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
 
 extern void __bad_size_call_parameter(void);
 
+#ifdef CONFIG_PREEMPT
+extern void this_cpu_preempt_check(void);
+#else
+static inline void this_cpu_preempt_check(void) { }
+#endif
+
 #define __pcpu_size_call_return(stem, variable)				\
 ({	typeof(variable) pscr_ret__;					\
 	__verify_pcpu_ptr(&(variable));					\
@@ -556,7 +562,7 @@ do {									\
 # ifndef __this_cpu_write_8
 #  define __this_cpu_write_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
 # endif
-# define __this_cpu_write(pcp, val)	__pcpu_size_call(__this_cpu_write_, (pcp), (val))
+# define __this_cpu_write(pcp, val)	do { this_cpu_preempt_check();__pcpu_size_call(__this_cpu_write_, (pcp), (val)); } while (0)
 #endif
 
 #ifndef __this_cpu_add
@@ -572,7 +578,7 @@ do {									\
 # ifndef __this_cpu_add_8
 #  define __this_cpu_add_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), +=)
 # endif
-# define __this_cpu_add(pcp, val)	__pcpu_size_call(__this_cpu_add_, (pcp), (val))
+# define __this_cpu_add(pcp, val)	do { this_cpu_preempt_check();__pcpu_size_call(__this_cpu_add_, (pcp), (val)); } while (0)
 #endif
 
 #ifndef __this_cpu_sub
@@ -600,7 +606,7 @@ do {									\
 # ifndef __this_cpu_and_8
 #  define __this_cpu_and_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), &=)
 # endif
-# define __this_cpu_and(pcp, val)	__pcpu_size_call(__this_cpu_and_, (pcp), (val))
+# define __this_cpu_and(pcp, val)	do { this_cpu_preempt_check();__pcpu_size_call(__this_cpu_and_, (pcp), (val)); } while (0)
 #endif
 
 #ifndef __this_cpu_or
@@ -616,7 +622,7 @@ do {									\
 # ifndef __this_cpu_or_8
 #  define __this_cpu_or_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), |=)
 # endif
-# define __this_cpu_or(pcp, val)	__pcpu_size_call(__this_cpu_or_, (pcp), (val))
+# define __this_cpu_or(pcp, val)	do { this_cpu_preempt_check();__pcpu_size_call(__this_cpu_or_, (pcp), (val)); } while (0)
 #endif
 
 #ifndef __this_cpu_xor
@@ -632,7 +638,7 @@ do {									\
 # ifndef __this_cpu_xor_8
 #  define __this_cpu_xor_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
 # endif
-# define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
+# define __this_cpu_xor(pcp, val)	do { this_cpu_preempt_check();__pcpu_size_call(__this_cpu_xor_, (pcp), (val)); } while (0)
 #endif
 
 #define __this_cpu_generic_add_return(pcp, val)				\
@@ -655,7 +661,7 @@ do {									\
 #  define __this_cpu_add_return_8(pcp, val)	__this_cpu_generic_add_return(pcp, val)
 # endif
 # define __this_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
+	(this_cpu_preempt_check(),__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val))
 #endif
 
 #define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(val))
@@ -683,7 +689,7 @@ do {									\
 #  define __this_cpu_xchg_8(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
 # endif
 # define __this_cpu_xchg(pcp, nval)	\
-	__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval)
+	(this_cpu_preempt_check(),__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval))
 #endif
 
 #define __this_cpu_generic_cmpxchg(pcp, oval, nval)			\
@@ -709,7 +715,7 @@ do {									\
 #  define __this_cpu_cmpxchg_8(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
 # define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval)
+	(this_cpu_preempt_check(),__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval))
 #endif
 
 #define __this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
@@ -742,7 +748,7 @@ do {									\
 	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
 # define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	(this_cpu_preempt_check(),__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
 #endif
 
 /*
Index: linux/kernel/sched/core.c
===================================================================
--- linux.orig/kernel/sched/core.c	2013-09-03 13:38:49.818888738 -0500
+++ linux/kernel/sched/core.c	2013-09-03 13:38:49.814888779 -0500
@@ -2583,6 +2583,27 @@ asmlinkage void __sched preempt_schedule
 	exception_exit(prev_state);
 }
 
+/*
+ * This function is called if the kernel is compiled with preempt
+ * support for each __this_cpu operations. It verifies that
+ * preemption has been disabled.
+ *
+ * The function cannot be a macro due to the low level nature
+ * of the per cpu header files.
+ */
+void this_cpu_preempt_check(void)
+{
+	int p;
+
+	p = preemptible();
+	if (p) {
+		printk(KERN_ERR "__this_cpu but preempt is off."
+			" Preempt count=%d Interrupts=%d\n",
+			preempt_count(), irqs_disabled());
+		dump_stack();
+	}
+
+}
 #endif /* CONFIG_PREEMPT */
 
 int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,

