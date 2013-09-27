Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3I0Nyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:54:53 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:52396 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3I0Nyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:54:49 -0400
Date: Fri, 27 Sep 2013 13:54:47 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu
 ops
In-Reply-To: <20130925181146.GA16693@gmail.com>
Message-ID: <000001415fb34afc-79a24112-5d3f-431c-b90c-d6cfa1caf27a-000000@email.amazonses.com>
References: <20130924154159.855373283@linux.com> <0000014150a21408-2d759c49-6a9e-4553-956f-2d4b53e710f8-000000@email.amazonses.com> <20130924171029.GB10261@gmail.com> <0000014155fdd6cf-d54da8b8-2198-40ce-8831-4559971e69f0-000000@email.amazonses.com>
 <20130925181146.GA16693@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.27-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Ingo Molnar wrote:

> >
> > I think this is necessary since it seems that the discussions on how to
> > do the raw_cpu conversions may take some time. If we enable it by
> > default then there will be numerous new log messages. That way a
> > developer can enable it for working on this.
>
> Note that for these patches to be eligible for upstream merge any extra
> warnings that trigger must be fixed, regardless of the default setting.

That is exactly what this patch does. There will only be warning if the
user enabled them.

> The blind __this_cpu conversions without proper preempt debugging cannot
> continue without first fixing all the fallout of the missing debug checks
> to begin with.

That will take some time as the feedback from the other patchset suggests.
If we merge this patchset then the necessary infrastructure for that work
will be present.

Here is a revised version of the second patch:


Subject: percpu: Add preemption checks to __this_cpu ops

We define a check function in order to avoid trouble with the
include files. Then the higher level __this_cpu macros are
modified to invoke the check before __this_cpu operation

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-09-25 11:49:49.542184644 -0500
+++ linux/include/linux/percpu.h	2013-09-25 11:49:49.498185073 -0500
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
Index: linux/lib/smp_processor_id.c
===================================================================
--- linux.orig/lib/smp_processor_id.c	2013-09-25 11:49:49.542184644 -0500
+++ linux/lib/smp_processor_id.c	2013-09-25 11:51:11.461386858 -0500
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>

-notrace unsigned int debug_smp_processor_id(void)
+notrace static unsigned int check_preemption_disabled(char *what)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
@@ -39,8 +39,8 @@ notrace unsigned int debug_smp_processor
 	if (!printk_ratelimit())
 		goto out_enable;

-	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
-			"code: %s/%d\n",
+	printk(KERN_ERR "%s in preemptible [%08x] "
+			"code: %s/%d\n", what,
 			preempt_count() - 1, current->comm, current->pid);
 	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
 	dump_stack();
@@ -51,5 +51,17 @@ out:
 	return this_cpu;
 }

+notrace unsigned int debug_smp_processor_id(void)
+{
+	return check_preemption_disabled("BUG: using smp_processor_id()");
+}
 EXPORT_SYMBOL(debug_smp_processor_id);

+notrace void __this_cpu_preempt_check(void)
+{
+#ifdef CONFIG_THIS_CPU_PREEMPTION_CHECK
+	check_preemption_disabled("__this_cpu operation");
+#endif
+}
+EXPORT_SYMBOL(__this_cpu_preempt_check);
+
Index: linux/lib/Kconfig.debug
===================================================================
--- linux.orig/lib/Kconfig.debug	2013-09-25 11:49:49.542184644 -0500
+++ linux/lib/Kconfig.debug	2013-09-25 11:49:49.542184644 -0500
@@ -797,6 +797,19 @@ config DEBUG_PREEMPT
 	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
 	  will detect preemption count underflows.

+config DEBUG_THIS_CPU_OPERATIONS
+	bool "Preemption checks for __this_cpu operations"
+	depends on DEBUG_PREEMPT
+	default n
+	help
+	  Enables preemption checks for __this_cpu macros. These
+	  are macros to generate single instruction operations on
+	  per cpu data. The option only affects the __this_cpu variant
+	  which is used when fallback to multiple instructions without
+	  other synchronization is possible should the arch not support
+	  these types of instruction. A verification is then
+	  done to make sure that the thread cannot be preempted.
+
 menu "Lock Debugging (spinlocks, mutexes, etc...)"

 config DEBUG_RT_MUTEXES
