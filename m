Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaAQP1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:27:24 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:60363 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbaAQP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:27:14 -0500
Message-Id: <20140117151836.233114147@linux.com>
Date: Fri, 17 Jan 2014 09:18:30 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 18/41] percpu: Add preemption checks to __this_cpu ops
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=preempt_check_this_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch depends on another patch in this series that introduces raw_cpu_ops]

We define a check function in order to avoid trouble with the
include files. Then the higher level __this_cpu macros are
modified to invoke the preemption check.

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-12-19 11:35:44.171220808 -0600
+++ linux/include/linux/percpu.h	2013-12-19 11:35:44.171220808 -0600
@@ -172,6 +172,12 @@
 
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
@@ -724,18 +730,24 @@
 
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
@@ -751,16 +763,23 @@
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
@@ -769,17 +788,17 @@
 
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
--- linux.orig/lib/smp_processor_id.c	2013-12-19 11:35:44.171220808 -0600
+++ linux/lib/smp_processor_id.c	2013-12-19 11:36:06.110597585 -0600
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-notrace unsigned int debug_smp_processor_id(void)
+notrace static unsigned int check_preemption_disabled(char *what)
 {
 	int this_cpu = raw_smp_processor_id();
 
@@ -38,9 +38,9 @@
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
 
@@ -50,5 +50,17 @@
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

