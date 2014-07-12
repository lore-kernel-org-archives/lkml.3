Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaGLDgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 23:36:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:51271 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751906AbaGLDgP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 23:36:15 -0400
Date: Fri, 11 Jul 2014 23:36:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 04/21] ftrace: Optimize function graph to be
 called directly
Message-ID: <20140711233610.551c274d@gandalf.local.home>
In-Reply-To: <53BED155.9040607@nvidia.com>
References: <20140703160503.006976702@goodmis.org>
	<20140703161224.062459692@goodmis.org>
	<53BED155.9040607@nvidia.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 20:45:57 +0300
Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:
> >
> 
> This commit (79922b8) breaks the function graph tracer on today's -next. 
> This is on an ARM Tegra board.

Can you test this patch. It makes the default operation of calling the
function graph tracer trampoline directly being disabled. It is now up
to the arch to define FTRACE_GRAPH_TRAMP_ADDR that can be used to call
directly. If it is not set, the old method of calling the function
tracer first is used.

I'll worked on getting arm to be called directly too. Can you test that
patch as well? I'll reply to this email with that one.

Thanks!

-- Steve

>From 641e0d82e5be65adac6449f62d68d83012b780d9 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Fri, 11 Jul 2014 14:39:10 -0400
Subject: [PATCH] ftrace: Allow archs to specify if they need a separate
 function graph trampoline

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 10 ++++++++++
 kernel/trace/ftrace.c  |  6 ++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 11e18fd..4807a39 100644
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
index 45aac1a..c52d37d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5366,7 +5366,8 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/* Optimize function graph calling (if implemented by arch) */
-	global_ops.trampoline = FTRACE_GRAPH_ADDR;
+	if (FTRACE_GRAPH_TRAMP_ADDR)
+		global_ops.trampoline = FTRACE_GRAPH_TRAMP_ADDR;
 #endif
 
 	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
@@ -5390,7 +5391,8 @@ void unregister_ftrace_graph(void)
 	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
 	global_ops.flags &= ~FTRACE_OPS_FL_STUB;
 #ifdef CONFIG_DYNAMIC_FTRACE
-	global_ops.trampoline = 0;
+	if (FTRACE_GRAPH_TRAMP_ADDR)
+		global_ops.trampoline = 0;
 #endif
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
-- 
1.8.1.4

