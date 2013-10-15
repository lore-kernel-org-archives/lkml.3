Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab3JOR4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:56:23 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:40431
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933198Ab3JORy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:54:56 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2013 13:54:32 EDT
Message-Id: <20131015174747.813545438@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 15 Oct 2013 12:47:28 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
References: <20131015174722.615394057@linux.com>
Content-Disposition: inline; filename=preempt_check_this_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3->V4:
	- Drop CONFIG_DEBUG_THIS_CPU_OPERATIONS
	- Add support for logging the exact operation that caused the issue.

We define a check function in order to avoid trouble with the
include files. Then the higher level __this_cpu macros are
modified to invoke the check before __this_cpu operation

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-10-10 11:30:17.111743444 -0500
+++ linux/include/linux/percpu.h	2013-10-10 10:30:26.817316787 -0500
@@ -175,6 +175,12 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
 
 extern void __bad_size_call_parameter(void);
 
+#ifdef CONFIG_DEBUG_PREEMPT
+extern void __this_cpu_preempt_check(const char *op);
+#else
+static inline void __this_cpu_preempt_check(const char *op) { }
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
+	(__this_cpu_preempt_check("read"),__pcpu_size_call_return(__this_cpu_read_, (pcp)))
 #endif
 
 #define __this_cpu_generic_to_op(pcp, val, op)				\
@@ -559,7 +566,12 @@ do {									\
 # ifndef __this_cpu_write_8
 #  define __this_cpu_write_8(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
 # endif
-# define __this_cpu_write(pcp, val)	__pcpu_size_call(__this_cpu_write_, (pcp), (val))
+
+# define __this_cpu_write(pcp, val) \
+do { __this_cpu_preempt_check("write");					\
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
+do { __this_cpu_preempt_check("add");					\
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
+do { __this_cpu_preempt_check("and");					\
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
+do { __this_cpu_preempt_check("or");					\
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
+do { __this_cpu_preempt_check("xor");					\
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
+	(__this_cpu_preempt_check("add_return"),__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val))
 #endif
 
 #define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(val))
@@ -686,7 +718,7 @@ do {									\
 #  define __this_cpu_xchg_8(pcp, nval)	__this_cpu_generic_xchg(pcp, nval)
 # endif
 # define __this_cpu_xchg(pcp, nval)	\
-	__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval)
+	(__this_cpu_preempt_check("xchg"),__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval))
 #endif
 
 #define __this_cpu_generic_cmpxchg(pcp, oval, nval)			\
@@ -712,7 +744,7 @@ do {									\
 #  define __this_cpu_cmpxchg_8(pcp, oval, nval)	__this_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
 # define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval)
+	(__this_cpu_preempt_check("cmpxchg"),__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval))
 #endif
 
 #define __this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
@@ -745,7 +777,7 @@ do {									\
 	__this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
 # define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	(__this_cpu_preempt_check("cmpxchg_double"),__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
 #endif
 
 /*
Index: linux/lib/smp_processor_id.c
===================================================================
--- linux.orig/lib/smp_processor_id.c	2013-10-10 11:30:17.111743444 -0500
+++ linux/lib/smp_processor_id.c	2013-10-10 10:32:16.046357108 -0500
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-notrace unsigned int debug_smp_processor_id(void)
+notrace static unsigned int check_preemption_disabled(char *what)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
@@ -39,9 +39,9 @@ notrace unsigned int debug_smp_processor
 	if (!printk_ratelimit())
 		goto out_enable;
 
-	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
-			"code: %s/%d\n",
-			preempt_count() - 1, current->comm, current->pid);
+	printk(KERN_ERR "%s in preemptible [%08x] code: %s/%d\n",
+		what, preempt_count() - 1, current->comm, current->pid);
+
 	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
 	dump_stack();
 
@@ -51,5 +51,18 @@ out:
 	return this_cpu;
 }
 
+notrace unsigned int debug_smp_processor_id(void)
+{
+	return check_preemption_disabled("BUG: using smp_processor_id()");
+}
 EXPORT_SYMBOL(debug_smp_processor_id);
 
+notrace void __this_cpu_preempt_check(const char *op)
+{
+	char text[40];
+
+	snprintf(text, sizeof(text), "__this_cpu_%s operation", op);
+	check_preemption_disabled(text);
+}
+EXPORT_SYMBOL(__this_cpu_preempt_check);
+

