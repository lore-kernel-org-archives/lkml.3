Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3LCXqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:46:12 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:56278 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721Ab3LCXjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:39:03 -0500
Message-Id: <20131203233254.463334159@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 17:32:50 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 18/41] percpu: Add preemption checks to __this_cpu ops
References: <20131203233232.928771708@linux.com>
Content-Disposition: inline; filename=preempt_check_this_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We define a check function in order to avoid trouble with the
include files. Then the higher level __this_cpu macros are
modified to invoke the preemption check.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-12-02 16:07:52.314563523 -0600
+++ linux/include/linux/percpu.h	2013-12-02 16:09:08.000000000 -0600
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
@@ -727,18 +733,24 @@ do {									\
 
 /*
  * Generic percpu operations for context that are safe from preemption/interrupts.
- * Checks will be added here soon.
  */
 #ifndef __this_cpu_read
-# define __this_cpu_read(pcp)	__pcpu_size_call_return(raw_cpu_read_, (pcp))
+# define __this_cpu_read(pcp) \
+	(__this_cpu_preempt_check("read"),__pcpu_size_call_return(raw_cpu_read_, (pcp)))
 #endif
 
 #ifndef __this_cpu_write
-# define __this_cpu_write(pcp, val)	__pcpu_size_call(raw_cpu_write_, (pcp), (val))
+# define __this_cpu_write(pcp, val)					\
+do { __this_cpu_preempt_check("write");					\
+     __pcpu_size_call(raw_cpu_write_, (pcp), (val));			\
+} while (0)
 #endif
 
 #ifndef __this_cpu_add
-# define __this_cpu_add(pcp, val)	__pcpu_size_call(raw_cpu_add_, (pcp), (val))
+# define __this_cpu_add(pcp, val)					 \
+do { __this_cpu_preempt_check("add");					\
+	__pcpu_size_call(raw_cpu_add_, (pcp), (val));			\
+} while (0)
 #endif
 
 #ifndef __this_cpu_sub
@@ -754,16 +766,23 @@ do {									\
 #endif
 
 #ifndef __this_cpu_and
-# define __this_cpu_and(pcp, val)	__pcpu_size_call(raw_cpu_and_, (pcp), (val))
+# define __this_cpu_and(pcp, val)					\
+do { __this_cpu_preempt_check("and");					\
+	__pcpu_size_call(raw_cpu_and_, (pcp), (val));			\
+} while (0)
+
 #endif
 
 #ifndef __this_cpu_or
-# define __this_cpu_or(pcp, val)	__pcpu_size_call(raw_cpu_or_, (pcp), (val))
+# define __this_cpu_or(pcp, val)					\
+do { __this_cpu_preempt_check("or");					\
+	__pcpu_size_call(raw_cpu_or_, (pcp), (val));			\
+} while (0)
 #endif
 
 #ifndef __this_cpu_add_return
 # define __this_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
+	(__this_cpu_preempt_check("add_return"),__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val))
 #endif
 
 #define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
@@ -772,17 +791,17 @@ do {									\
 
 #ifndef __this_cpu_xchg
 # define __this_cpu_xchg(pcp, nval)	\
-	__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval)
+	(__this_cpu_preempt_check("xchg"),__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval))
 #endif
 
 #ifndef __this_cpu_cmpxchg
 # define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
+	(__this_cpu_preempt_check("cmpxchg"),__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval))
 #endif
 
 #ifndef __this_cpu_cmpxchg_double
 # define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+	(__this_cpu_preempt_check("cmpxchg_double"),__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
 #endif
 
 #endif /* __LINUX_PERCPU_H */
Index: linux/lib/smp_processor_id.c
===================================================================
--- linux.orig/lib/smp_processor_id.c	2013-12-02 16:07:52.314563523 -0600
+++ linux/lib/smp_processor_id.c	2013-12-02 16:07:52.314563523 -0600
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-notrace unsigned int debug_smp_processor_id(void)
+notrace static unsigned int check_preemption_disabled(char *what)
 {
 	int this_cpu = raw_smp_processor_id();
 
@@ -38,9 +38,9 @@ notrace unsigned int debug_smp_processor
 	if (!printk_ratelimit())
 		goto out_enable;
 
-	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
-			"code: %s/%d\n",
-			preempt_count() - 1, current->comm, current->pid);
+	printk(KERN_ERR "BUG: using %s in preemptible [%08x] code: %s/%d\n",
+		what, preempt_count() - 1, current->comm, current->pid);
+
 	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
 	dump_stack();
 
@@ -50,5 +50,18 @@ out:
 	return this_cpu;
 }
 
+notrace unsigned int debug_smp_processor_id(void)
+{
+	return check_preemption_disabled("smp_processor_id()");
+}
 EXPORT_SYMBOL(debug_smp_processor_id);
 
+notrace void __this_cpu_preempt_check(const char *op)
+{
+	char text[40];
+
+	snprintf(text, sizeof(text), "__this_cpu_%s()", op);
+	check_preemption_disabled(text);
+}
+EXPORT_SYMBOL(__this_cpu_preempt_check);
+

