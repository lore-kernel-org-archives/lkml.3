Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979Ab3IDOj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:39:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15028 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762822Ab3IDOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:07 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=9psGN__WFIcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JEyrxvq0v4IA:10 a=VnNF1IyMAAAA:8 a=HPcB72GpCcUufFnEupoA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143702.114171226@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:36:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 11/18] ftrace: Create a RCU unsafe checker
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Create-a-RCU-unsafe-checker.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Knowing what functions are not safe to be traced by callbacks that use
RCU read locks, is not easy to figure out. By adding a function tracer
callback that is set as a non RCU safe callback that also uses
rcu_read_lock() and enables PROVE_RCU, it can be used to find locations
in the kernel that need to be tagged with FTRACE_UNSAFE_RCU().

On boot up, this callback gets registered so that all functions are
being traced, and there's no way to turn this off. In the future we
can make this enabled or disabled at run time, but for now it's only
used for debugging and should not be enabled by normal users.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig           |   22 ++++++++++++++++++
 kernel/trace/ftrace.c          |   12 ++++++++++
 kernel/trace/trace.h           |    3 +++
 kernel/trace/trace_functions.c |   48 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 015f85a..907b497 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -489,6 +489,28 @@ config FTRACE_MCOUNT_RECORD
 config FTRACE_SELFTEST
 	bool
 
+config FTRACE_UNSAFE_RCU_CHECKER
+        bool "Trace for unsafe RCU callers"
+	depends on DYNAMIC_FTRACE
+	depends on PROVE_LOCKING
+	select PROVE_RCU
+	help
+	 Some function tracing callbacks use RCU read lock (namely perf).
+	 There are some RCU critical functions that are called out
+	 of scope for RCU. For example, when NO_HZ_FULL is enabled,
+	 and coming out of user space. The CPU is not being tracked by
+	 RCU and all rcu_read_lock()s will be ignored. These functions
+	 need to be tagged as unsafe for RCU so that only function callbacks
+	 that specify that they do not use RCU will be called by them.
+
+	 This option will enable PROVE_RCU and will enable on boot up
+	 a function callback that traces all functions and uses an
+	 rcu_read_lock(). If any function that is not tagged as unsafe
+	 for RCU is called, a debug splat will be shown. This is used
+	 for finding unsafe RCU callers that need to be tagged.
+
+	 If you don't understand any of this, then say N.
+
 config FTRACE_STARTUP_TEST
 	bool "Perform a startup test on ftrace"
 	depends on GENERIC_TRACER
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d78f2cb..9fcf842 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1359,6 +1359,13 @@ alloc_and_copy_ftrace_hash(int size_bits, struct ftrace_hash *hash)
 	return NULL;
 }
 
+#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+bool ftrace_rcu_unsafe(unsigned long addr)
+{
+	return ftrace_lookup_ip(ftrace_unsafe_rcu, addr) != NULL;
+}
+#endif
+
 static void
 ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
 static void
@@ -4391,6 +4398,11 @@ static void __init create_unsafe_rcu_hash(void)
 		if (WARN_ON_ONCE(strcmp(str, finder->name) != 0))
 			continue;
 
+#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+		/* When checker is enabled, show what was marked unsafe */
+		pr_info("add ftrace rcu unsafe %p (%s)\n",
+			(void *)ip, finder->name);
+#endif
 		add_hash_entry(ftrace_unsafe_rcu, ip);
 	}
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3578be6..e551316 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -760,6 +760,9 @@ static inline int ftrace_graph_addr(unsigned long addr)
 
 	return 0;
 }
+#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+extern bool ftrace_rcu_unsafe(unsigned long addr);
+#endif
 #else
 static inline int ftrace_graph_addr(unsigned long addr)
 {
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 38fe148..79641bb 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -559,9 +559,55 @@ static inline int init_func_cmd_traceon(void)
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
+#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+static DEFINE_PER_CPU(int, ftrace_rcu_running);
+
+static void
+ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
+		       struct ftrace_ops *op, struct pt_regs *pt_regs)
+{
+	preempt_disable_notrace();
+
+	if (this_cpu_read(ftrace_rcu_running))
+		goto out;
+
+	if (WARN_ONCE(ftrace_rcu_unsafe(ip),
+		      "UNSAFE RCU function called %pS",
+		      (void *)ip))
+		goto out;
+
+	this_cpu_write(ftrace_rcu_running, 1);
+
+	/* Should trigger a RCU splat if called from unsafe RCU function */
+	rcu_read_lock();
+	rcu_read_unlock();
+
+	this_cpu_write(ftrace_rcu_running, 0);
+ out:
+	preempt_enable_notrace();
+}
+
+static struct ftrace_ops ftrace_unsafe_ops = {
+	.func			= ftrace_unsafe_callback,
+	.flags			= FTRACE_OPS_FL_RECURSION_SAFE
+};
+
+static __init void ftrace_start_unsafe_rcu(void)
+{
+	register_ftrace_function(&ftrace_unsafe_ops);
+}
+#else
+static inline void ftrace_start_unsafe_rcu(void) { }
+#endif
+
 static __init int init_function_trace(void)
 {
+	int ret;
+
 	init_func_cmd_traceon();
-	return register_tracer(&function_trace);
+	ret = register_tracer(&function_trace);
+	if (!ret)
+		ftrace_start_unsafe_rcu();
+	return ret;
 }
 core_initcall(init_function_trace);
-- 
1.7.10.4


