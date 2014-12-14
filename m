Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbaLNUV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:21:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:48476 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750952AbaLNUVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:01 -0500
Message-Id: <20141214202054.834096759@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 14 Dec 2014 15:16:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 2/2 v2] tracing: Add tp_printk cmdline to have tracepoints go to printk()
References: <20141214201609.126831471@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Add-tp_printk-cmdline-to-have-tracepoints-go.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add the kernel command line tp_printk option that will have tracepoints
that are active sent to printk() as well as to the trace buffer.

Passing "tp_printk" will activate this. To turn it off, the sysctl
/proc/sys/kernel/tracepoint_printk can have '0' echoed into it. Note,
this only works if the cmdline option is used. Echoing 1 into the sysctl
file without the cmdline option will have no affect.

Note, this is a dangerous option. Having high frequency tracepoints send
their data to printk() can possibly cause a live lock. This is another
reason why this is only active if the command line option is used.

Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412121539300.16494@nanos

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt | 18 ++++++++++++++++++
 include/linux/ftrace.h              |  1 +
 kernel/sysctl.c                     |  7 +++++++
 kernel/trace/trace.c                | 17 +++++++++++++++++
 kernel/trace/trace.h                |  1 +
 kernel/trace/trace_events.c         | 32 ++++++++++++++++++++++++++++++++
 6 files changed, 76 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1d09eb37c562..ae41f1181e9a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3500,6 +3500,24 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			See also Documentation/trace/ftrace.txt "trace options"
 			section.
 
+	tp_printk[FTRACE]
+			Have the tracepoints sent to printk as well as the
+			tracing ring buffer. This is useful for early boot up
+			where the system hangs or reboots and does not give the
+			option for reading the tracing buffer or performing a
+			ftrace_dump_on_oops.
+
+			To turn off having tracepoints sent to printk,
+			 echo 0 > /proc/sys/kernel/tracepoint_printk
+			Note, echoing 1 into this file without the
+			tracepoint_printk kernel cmdline option has no effect.
+
+			** CAUTION **
+
+			Having tracepoints sent to printk() and activating high
+			frequency tracepoints such as irq or sched, can cause
+			the system to live lock.
+
 	traceoff_on_warning
 			[FTRACE] enable this option to disable tracing when a
 			warning is hit. This turns off "tracing_on". Tracing can
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f4bc14b7d444..1da602982cf9 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -879,6 +879,7 @@ static inline int test_tsk_trace_graph(struct task_struct *tsk)
 enum ftrace_dump_mode;
 
 extern enum ftrace_dump_mode ftrace_dump_on_oops;
+extern int tracepoint_printk;
 
 extern void disable_trace_on_warning(void);
 extern int __disable_trace_on_warning;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4aada6d9fe74..bb50c2187194 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -622,6 +622,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "tracepoint_printk",
+		.data		= &tracepoint_printk,
+		.maxlen		= sizeof(tracepoint_printk),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 #ifdef CONFIG_KEXEC
 	{
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ec3ca694665f..e890d2d4ec89 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -63,6 +63,10 @@ static bool __read_mostly tracing_selftest_running;
  */
 bool __read_mostly tracing_selftest_disabled;
 
+/* Pipe tracepoints to printk */
+struct trace_iterator *tracepoint_print_iter;
+int tracepoint_printk;
+
 /* For tracers that don't implement custom flags */
 static struct tracer_opt dummy_tracer_opt[] = {
 	{ }
@@ -193,6 +197,13 @@ static int __init set_trace_boot_clock(char *str)
 }
 __setup("trace_clock=", set_trace_boot_clock);
 
+static int __init set_tracepoint_printk(char *str)
+{
+	if ((strcmp(str, "=0") != 0 && strcmp(str, "=off") != 0))
+		tracepoint_printk = 1;
+	return 1;
+}
+__setup("tp_printk", set_tracepoint_printk);
 
 unsigned long long ns2usecs(cycle_t nsec)
 {
@@ -6878,6 +6889,12 @@ out:
 
 void __init trace_init(void)
 {
+	if (tracepoint_printk) {
+		tracepoint_print_iter =
+			kmalloc(sizeof(*tracepoint_print_iter), GFP_KERNEL);
+		if (WARN_ON(!tracepoint_print_iter))
+			tracepoint_printk = 0;
+	}
 	tracer_alloc_buffers();
 	init_ftrace_syscalls();
 	trace_event_init();	
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c138c149d6ef..8de48bac1ce2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1313,5 +1313,6 @@ void trace_event_init(void);
 static inline void __init trace_event_init(void) { }
 #endif
 
+extern struct trace_iterator *tracepoint_print_iter;
 
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index fd9deb0e03f0..9f7175a3df71 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -212,8 +212,40 @@ void *ftrace_event_buffer_reserve(struct ftrace_event_buffer *fbuffer,
 }
 EXPORT_SYMBOL_GPL(ftrace_event_buffer_reserve);
 
+static DEFINE_SPINLOCK(tracepoint_iter_lock);
+
+static void output_printk(struct ftrace_event_buffer *fbuffer)
+{
+	struct ftrace_event_call *event_call;
+	struct trace_event *event;
+	unsigned long flags;
+	struct trace_iterator *iter = tracepoint_print_iter;
+
+	if (!iter)
+		return;
+
+	event_call = fbuffer->ftrace_file->event_call;
+	if (!event_call || !event_call->event.funcs ||
+	    !event_call->event.funcs->trace)
+		return;
+
+	event = &fbuffer->ftrace_file->event_call->event;
+
+	spin_lock_irqsave(&tracepoint_iter_lock, flags);
+	trace_seq_init(&iter->seq);
+	iter->ent = fbuffer->entry;
+	event_call->event.funcs->trace(iter, 0, event);
+	trace_seq_putc(&iter->seq, 0);
+	printk("%s", iter->seq.buffer);
+
+	spin_unlock_irqrestore(&tracepoint_iter_lock, flags);
+}
+
 void ftrace_event_buffer_commit(struct ftrace_event_buffer *fbuffer)
 {
+	if (tracepoint_printk)
+		output_printk(fbuffer);
+
 	event_trigger_unlock_commit(fbuffer->ftrace_file, fbuffer->buffer,
 				    fbuffer->event, fbuffer->entry,
 				    fbuffer->flags, fbuffer->pc);
-- 
2.1.3


