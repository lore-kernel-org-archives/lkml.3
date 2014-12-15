Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaLOPiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:38:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:11840 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750952AbaLOPh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:37:56 -0500
Message-Id: <20141215153743.427704960@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 15 Dec 2014 10:36:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 1/2] tracing: Move enabling tracepoints to just after rcu_init()
References: <20141215153638.563024114@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Move-enabling-tracepoints-to-just-after-rcu_.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Enabling tracepoints at boot up can be very useful. The tracepoint
can be initialized right after RCU has been. There's no need to
wait for the early_initcall() to be called. That's too late for some
things that can use tracepoints for debugging. Move the logic to
enable tracepoints out of the initcalls and into init/main.c to
right after rcu_init().

This also allows trace_printk() to be used early too.

Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412121539300.16494@nanos
Link: http://lkml.kernel.org/r/20141214164104.307127356@goodmis.org

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h        |  6 ++++++
 init/main.c                   |  4 ++++
 kernel/trace/trace.c          |  8 +++++++-
 kernel/trace/trace.h          | 13 +++++++++++++
 kernel/trace/trace_events.c   | 10 ++++++++--
 kernel/trace/trace_syscalls.c |  7 ++-----
 6 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ed501953f0b2..f4bc14b7d444 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -39,6 +39,12 @@
 # define FTRACE_FORCE_LIST_FUNC 0
 #endif
 
+/* Main tracing buffer and events set up */
+#ifdef CONFIG_TRACING
+void trace_init(void);
+#else
+static inline void trace_init(void) { }
+#endif
 
 struct module;
 struct ftrace_hash;
diff --git a/init/main.c b/init/main.c
index 800a0daede7e..70687069f8e2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -577,6 +577,10 @@ asmlinkage __visible void __init start_kernel(void)
 		local_irq_disable();
 	idr_init_cache();
 	rcu_init();
+
+	/* trace_printk() and trace points may be used after this */
+	trace_init();
+
 	context_tracking_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4ceb2546c7ef..ec3ca694665f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6876,6 +6876,13 @@ out:
 	return ret;
 }
 
+void __init trace_init(void)
+{
+	tracer_alloc_buffers();
+	init_ftrace_syscalls();
+	trace_event_init();	
+}
+
 __init static int clear_boot_tracer(void)
 {
 	/*
@@ -6895,6 +6902,5 @@ __init static int clear_boot_tracer(void)
 	return 0;
 }
 
-early_initcall(tracer_alloc_buffers);
 fs_initcall(tracer_init_debugfs);
 late_initcall(clear_boot_tracer);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3255dfb054a0..c138c149d6ef 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1301,4 +1301,17 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
 #define perf_ftrace_event_register NULL
 #endif
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+void init_ftrace_syscalls(void);
+#else
+static inline void init_ftrace_syscalls(void) { }
+#endif
+
+#ifdef CONFIG_EVENT_TRACING
+void trace_event_init(void);
+#else
+static inline void __init trace_event_init(void) { }
+#endif
+
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f9d0cbe014b7..fd9deb0e03f0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2477,8 +2477,14 @@ static __init int event_trace_init(void)
 #endif
 	return 0;
 }
-early_initcall(event_trace_memsetup);
-core_initcall(event_trace_enable);
+
+void __init trace_event_init(void)
+{
+	event_trace_memsetup();
+	init_ftrace_syscalls();
+	event_trace_enable();
+}
+
 fs_initcall(event_trace_init);
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index a72f3d8d813e..ec239771c175 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -514,7 +514,7 @@ unsigned long __init __weak arch_syscall_addr(int nr)
 	return (unsigned long)sys_call_table[nr];
 }
 
-static int __init init_ftrace_syscalls(void)
+void __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;
 	unsigned long addr;
@@ -524,7 +524,7 @@ static int __init init_ftrace_syscalls(void)
 				    GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
-		return -ENOMEM;
+		return;
 	}
 
 	for (i = 0; i < NR_syscalls; i++) {
@@ -536,10 +536,7 @@ static int __init init_ftrace_syscalls(void)
 		meta->syscall_nr = i;
 		syscalls_metadata[i] = meta;
 	}
-
-	return 0;
 }
-early_initcall(init_ftrace_syscalls);
 
 #ifdef CONFIG_PERF_EVENTS
 
-- 
2.1.3


