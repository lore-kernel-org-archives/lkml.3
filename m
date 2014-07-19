Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087AbaGSNYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:24:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:10810 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754794AbaGSNQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:11 -0400
Message-Id: <20140719131609.242496160@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [for-next][PATCH 01/32] ftrace: Allow archs to specify if they need a separate function graph
 trampoline
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-Allow-archs-to-specify-if-they-need-a-separat.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently if an arch supports function graph tracing, the core code will
just assign the function graph trampoline to the function graph addr that
gets called.

But as the old method for function graph tracing always calls the function
trampoline first and that calls the function graph trampoline, some
archs may have the function graph trampoline dependent on operations that
were done in the function trampoline. This causes function graph tracer
to break on those archs.

Instead of having the default be to set the function graph ftrace_ops
to the function graph trampoline, have it instead just set it to zero
which will keep it from jumping to a trampoline that is not set up
to be jumped directly too.

Link: http://lkml.kernel.org/r/53BED155.9040607@nvidia.com

Reported-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Tested-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 10 ++++++++++
 kernel/trace/ftrace.c  |  6 ++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 11e18fd58b1a..4807a39e7ae1 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -453,6 +453,16 @@ void ftrace_modify_all_code(int command);
 #endif
 #endif
 
+/*
+ * If an arch would like functions that are only traced
+ * by the function graph tracer to jump directly to its own
+ * trampoline, then they can define FTRACE_GRAPH_TRAMP_ADDR
+ * to be that address to jump to.
+ */
+#ifndef FTRACE_GRAPH_TRAMP_ADDR
+#define FTRACE_GRAPH_TRAMP_ADDR ((unsigned long) 0)
+#endif
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern void ftrace_graph_caller(void);
 extern int ftrace_enable_ftrace_graph_caller(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 45aac1a742c5..1776153ea6e0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5366,7 +5366,8 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/* Optimize function graph calling (if implemented by arch) */
-	global_ops.trampoline = FTRACE_GRAPH_ADDR;
+	if (FTRACE_GRAPH_TRAMP_ADDR != 0)
+		global_ops.trampoline = FTRACE_GRAPH_TRAMP_ADDR;
 #endif
 
 	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
@@ -5390,7 +5391,8 @@ void unregister_ftrace_graph(void)
 	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
 	global_ops.flags &= ~FTRACE_OPS_FL_STUB;
 #ifdef CONFIG_DYNAMIC_FTRACE
-	global_ops.trampoline = 0;
+	if (FTRACE_GRAPH_TRAMP_ADDR != 0)
+		global_ops.trampoline = 0;
 #endif
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
-- 
2.0.1


