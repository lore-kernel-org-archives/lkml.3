Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131Ab3FTDhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:37:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935652Ab3FTDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:42 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=QrjVQHfF2LYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3V98C5VGHtYA:10 a=JfrnYn6hAAAA:8 a=NJoiJGqCHa-TixDUHxYA:9 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033640.057861808@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [for-next][PATCH 10/12] tracing: Disable tracing on warning
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Disable-tracing-on-warning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a traceoff_on_warning option in both the kernel command line as well
as a sysctl option. When set, any WARN*() function that is hit will cause
the tracing_on variable to be cleared, which disables writing to the
ring buffer.

This is useful especially when tracing a bug with function tracing. When
a warning is hit, the print caused by the warning can flood the trace with
the functions that producing the output for the warning. This can make the
resulting trace useless by either hiding where the bug happened, or worse,
by overflowing the buffer and losing the trace of the bug totally.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt |   13 +++++++++++++
 include/linux/ftrace.h              |    5 +++++
 kernel/panic.c                      |    3 +++
 kernel/sysctl.c                     |    7 +++++++
 kernel/trace/trace.c                |   17 +++++++++++++++++
 5 files changed, 45 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6e3b18a..729d0b9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3069,6 +3069,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			See also Documentation/trace/ftrace.txt "trace options"
 			section.
 
+	traceoff_on_warning
+			[FTRACE] enable this option to disable tracing when a
+			warning is hit. This turns off "tracing_on". Tracing can
+			be enabled again by echoing '1' into the "tracing_on"
+			file located in /sys/kernel/debug/tracing/
+
+			This option is useful, as it disables the trace before
+			the WARNING dump is called, which prevents the trace to
+			be filled with content caused by the warning output.
+
+			This option can also be set at run time via the sysctl
+			option:  kernel/traceoff_on_warning
+
 	transparent_hugepage=
 			[KNL]
 			Format: [always|madvise|never]
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e48ed1d..9f15c00 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -824,10 +824,15 @@ enum ftrace_dump_mode;
 
 extern enum ftrace_dump_mode ftrace_dump_on_oops;
 
+extern void disable_trace_on_warning(void);
+extern int __disable_trace_on_warning;
+
 #ifdef CONFIG_PREEMPT
 #define INIT_TRACE_RECURSION		.trace_recursion = 0,
 #endif
 
+#else /* CONFIG_TRACING */
+static inline void  disable_trace_on_warning(void) { }
 #endif /* CONFIG_TRACING */
 
 #ifndef INIT_TRACE_RECURSION
diff --git a/kernel/panic.c b/kernel/panic.c
index 167ec09..4cea6cc 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -15,6 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/ftrace.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/kexec.h>
@@ -399,6 +400,8 @@ struct slowpath_args {
 static void warn_slowpath_common(const char *file, int line, void *caller,
 				 unsigned taint, struct slowpath_args *args)
 {
+	disable_trace_on_warning();
+
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..5b0f18c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -600,6 +600,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "traceoff_on_warning",
+		.data		= &__disable_trace_on_warning,
+		.maxlen		= sizeof(__disable_trace_on_warning),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 #ifdef CONFIG_MODULES
 	{
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5f4a09c..c4c9296 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -115,6 +115,9 @@ cpumask_var_t __read_mostly	tracing_buffer_mask;
 
 enum ftrace_dump_mode ftrace_dump_on_oops;
 
+/* When set, tracing will stop when a WARN*() is hit */
+int __disable_trace_on_warning;
+
 static int tracing_set_tracer(const char *buf);
 
 #define MAX_TRACER_SIZE		100
@@ -149,6 +152,13 @@ static int __init set_ftrace_dump_on_oops(char *str)
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
 
+static int __init stop_trace_on_warning(char *str)
+{
+	__disable_trace_on_warning = 1;
+	return 1;
+}
+__setup("traceoff_on_warning=", stop_trace_on_warning);
+
 static int __init boot_alloc_snapshot(char *str)
 {
 	allocate_snapshot = true;
@@ -170,6 +180,7 @@ static int __init set_trace_boot_options(char *str)
 }
 __setup("trace_options=", set_trace_boot_options);
 
+
 unsigned long long ns2usecs(cycle_t nsec)
 {
 	nsec += 500;
@@ -562,6 +573,12 @@ void tracing_off(void)
 }
 EXPORT_SYMBOL_GPL(tracing_off);
 
+void disable_trace_on_warning(void)
+{
+	if (__disable_trace_on_warning)
+		tracing_off();
+}
+
 /**
  * tracing_is_on - show state of ring buffers enabled
  */
-- 
1.7.10.4


