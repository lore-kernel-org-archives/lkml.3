Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3GBU0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:26:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3GBUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:29 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=lez6ERixACgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3uCSwsvZzAgA:10 a=87YVE1VR_OrSl2xStK4A:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202426.791401823@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 10/14] ftrace: Do not run selftest if command line parameter is set
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Do-not-run-selftest-if-command-line-parameter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If the kernel command line ftrace filter parameters are set
(ftrace_filter or ftrace_notrace), force the function self test to
pass, with a warning why it was forced.

If the user adds a filter to the kernel command line, it is assumed
that they know what they are doing, and the self test should just not
run instead of failing (which disables function tracing) or clearing
the filter, as that will probably annoy the user.

If the user wants the selftest to run, the message will tell them why
it did not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c         |    5 +++++
 kernel/trace/trace.h          |    1 +
 kernel/trace/trace_selftest.c |   18 ++++++++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 26e1910..67708f4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3537,8 +3537,12 @@ EXPORT_SYMBOL_GPL(ftrace_set_global_notrace);
 static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
 
+/* Used by function selftest to not test if filter is set */
+bool ftrace_filter_param __initdata;
+
 static int __init set_ftrace_notrace(char *str)
 {
+	ftrace_filter_param = true;
 	strlcpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
@@ -3546,6 +3550,7 @@ __setup("ftrace_notrace=", set_ftrace_notrace);
 
 static int __init set_ftrace_filter(char *str)
 {
+	ftrace_filter_param = true;
 	strlcpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 711ca7d..a88939e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -776,6 +776,7 @@ print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 extern struct list_head ftrace_pids;
 
 #ifdef CONFIG_FUNCTION_TRACER
+extern bool ftrace_filter_param __initdata;
 static inline int ftrace_trace_task(struct task_struct *task)
 {
 	if (list_empty(&ftrace_pids))
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 2901e3b..a7329b7 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -640,13 +640,20 @@ out:
  * Enable ftrace, sleep 1/10 second, and then read the trace
  * buffer to see if all is in order.
  */
-int
+__init int
 trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 {
 	int save_ftrace_enabled = ftrace_enabled;
 	unsigned long count;
 	int ret;
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (ftrace_filter_param) {
+		printk(KERN_CONT " ... kernel command line filter set: force PASS ... ");
+		return 0;
+	}
+#endif
+
 	/* make sure msleep has been recorded */
 	msleep(1);
 
@@ -727,13 +734,20 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
  * Pretty much the same than for the function tracer from which the selftest
  * has been borrowed.
  */
-int
+__init int
 trace_selftest_startup_function_graph(struct tracer *trace,
 					struct trace_array *tr)
 {
 	int ret;
 	unsigned long count;
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (ftrace_filter_param) {
+		printk(KERN_CONT " ... kernel command line filter set: force PASS ... ");
+		return 0;
+	}
+#endif
+
 	/*
 	 * Simulate the init() callback but we attach a watchdog callback
 	 * to detect and recover from possible hangs
-- 
1.7.10.4


