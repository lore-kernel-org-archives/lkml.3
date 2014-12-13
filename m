Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276AbaLMFul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 00:50:41 -0500
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:33504 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965236AbaLMFuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 00:50:40 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::,RULES_HIT:2:41:355:379:541:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:1801:2393:2525:2560:2563:2682:2685:2693:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3865:3867:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4049:4118:4321:4605:5007:6119:6120:6261:6742:8599:9025:10004:10848:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:12783:13161:13180:13229:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: top42_79ef74ce5155f
X-Filterd-Recvd-Size: 7572
Date: Sat, 13 Dec 2014 00:50:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 2/2] tracing: Add tracepoint_printk cmdline
Message-ID: <20141213005037.78eca245@gandalf.local.home>
In-Reply-To: <20141213004830.792da019@gandalf.local.home>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
	<20141212181420.47100d5c@gandalf.local.home>
	<20141213004830.792da019@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add the kernel command line tracepoint_printk option that will
have tracepoints that are active sent to printk().

Passing "tracepoint_printk" will activate this. To turn it off
the sysctl /proc/sys/kernel/tracepoint_printk can have '0' echoed
into it. Note, this only works if the cmdline option is used.
Echoing 1 into the sysctl file without the cmdline option will
have no affect.

Note, this is a dangerous option. Having high frequency
tracepoints send their data to printk() can possibly cause
a live lock.

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
index 1d09eb37c562..d81f464a7358 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3500,6 +3500,24 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			See also Documentation/trace/ftrace.txt "trace options"
 			section.
 
+	tracepoint_printk[FTRACE]
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
index 0fc3e720d4fd..9e20e7c28aab 100644
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
index ec3ca694665f..18a00ab4427e 100644
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
+__setup("tracepoint_printk", set_tracepoint_printk);
 
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
1.8.1.4

