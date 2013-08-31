Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab3HaFSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:18:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3HaFRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:06 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=V-Haa3OHH8YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=tJQdvyv6oMMA:10 a=JfrnYn6hAAAA:8 a=XA_K0ntbrZJHw4o1PS4A:9 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051702.766697014@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 14/18 v2] ftrace/lockdep: Have the RCU lockdep splat show what function
 triggered
References: <20130831051117.884125230@goodmis.org>
Content-Disposition: inline; filename=0014-ftrace-lockdep-Have-the-RCU-lockdep-splat-show-what-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When the RCU lockdep splat hits because of the unsafe RCU checker,
the backtrace does not always show the culprit. But the culprit was
passed to the unsafe RCU checker.

Save the ip of the function being traced in a per_cpu variable, and
when the RCU lockdep detects a problem, it can also print out what
function was being traced if it was caused by the unsafe RCU checker.

Cc:  Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h         |    6 ++++++
 kernel/lockdep.c               |    2 ++
 kernel/trace/trace_functions.c |   14 ++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4752764..3dbb946 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -885,4 +885,10 @@ unsigned long arch_syscall_addr(int nr);
 
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
+#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+extern void print_ftrace_rcu_func(int cpu);
+#else
+static inline void print_ftrace_rcu_func(int cpu) { }
+#endif
+
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e16c45b..74272ed 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4229,6 +4229,8 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 				: "",
 	       rcu_scheduler_active, debug_locks);
 
+	print_ftrace_rcu_func(raw_smp_processor_id());
+
 	/*
 	 * If a CPU is in the RCU-free window in idle (ie: in the section
 	 * between rcu_idle_enter() and rcu_idle_exit(), then RCU
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 1d5f951..f5a9031 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -560,6 +560,7 @@ static inline int init_func_cmd_traceon(void)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+
 static atomic_t ftrace_unsafe_rcu_disabled;
 
 void ftrace_unsafe_rcu_checker_disable(void)
@@ -572,6 +573,17 @@ void ftrace_unsafe_rcu_checker_enable(void)
 	atomic_dec(&ftrace_unsafe_rcu_disabled);
 }
 
+static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
+
+void print_ftrace_rcu_func(int cpu)
+{
+	unsigned long ip = per_cpu(ftrace_rcu_func, cpu);
+
+	if (ip)
+		printk("ftrace_rcu_func: %pS\n",
+		       (void *)per_cpu(ftrace_rcu_func, cpu));
+}
+
 static void
 ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
 		       struct ftrace_ops *op, struct pt_regs *pt_regs)
@@ -592,9 +604,11 @@ ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
 		      (void *)ip))
 		goto out;
 
+	this_cpu_write(ftrace_rcu_func, ip);
 	/* Should trigger a RCU splat if called from unsafe RCU function */
 	rcu_read_lock();
 	rcu_read_unlock();
+	this_cpu_write(ftrace_rcu_func, 0);
 
 	trace_clear_recursion(bit);
  out:
-- 
1.7.10.4


