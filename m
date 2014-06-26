Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbaFZQ6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:58:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756132AbaFZQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:49 -0400
Message-Id: <20140626165848.568062800@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFA][PATCH 04/27] ftrace-graph: Remove dependency of ftrace_stop() from
 ftrace_graph_stop()
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-ftrace-graph-Remove-dependency-of-ftrace_stop-from-f.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

ftrace_stop() is going away as it disables parts of function tracing
that affects users that should not be affected. But ftrace_graph_stop()
is built on ftrace_stop(). Here's another example of killing all of
function tracing because something went wrong with function graph
tracing.

Instead of disabling all users of function tracing on function graph
error, disable only function graph tracing.

A new function is created called ftrace_graph_is_dead(). This is called
in strategic paths to prevent function graph from doing more harm and
allowing at least a warning to be printed before the system crashes.

NOTE: ftrace_stop() is still used until all the archs are converted over
to use ftrace_graph_is_dead(). After that, ftrace_stop() will be removed.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h               |  1 +
 kernel/trace/ftrace.c                |  5 -----
 kernel/trace/trace_functions_graph.c | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 11e18fd58b1a..ec059c343e78 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -750,6 +750,7 @@ extern char __irqentry_text_end[];
 extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 				trace_func_graph_ent_t entryfunc);
 
+extern bool ftrace_graph_is_dead(void);
 extern void ftrace_graph_stop(void);
 
 /* The current handlers in use */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3a6d44c76af7..823984c20262 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5439,9 +5439,4 @@ void ftrace_graph_exit_task(struct task_struct *t)
 
 	kfree(ret_stack);
 }
-
-void ftrace_graph_stop(void)
-{
-	ftrace_stop();
-}
 #endif
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4de3e57f723c..3604690be70b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -15,6 +15,38 @@
 #include "trace.h"
 #include "trace_output.h"
 
+static bool kill_ftrace_graph;
+
+/**
+ * ftrace_graph_is_dead - returns true if ftrace_graph_stop() was called
+ *
+ * ftrace_graph_stop() is called when a severe error is detected in
+ * the function graph tracing. This function is called by the critical
+ * paths of function graph to keep those paths from doing any more harm.
+ */
+bool ftrace_graph_is_dead(void)
+{
+	return kill_ftrace_graph;
+}
+
+/**
+ * ftrace_graph_stop - set to permanently disable function graph tracincg
+ *
+ * In case of an error int function graph tracing, this is called
+ * to try to keep function graph tracing from causing any more harm.
+ * Usually this is pretty severe and this is called to try to at least
+ * get a warning out to the user.
+ */
+void ftrace_graph_stop(void)
+{
+	kill_ftrace_graph = true;
+	/*
+	 * ftrace_stop() will be removed when all archs are updated to
+	 * use ftrace_graph_is_dead()
+	 */
+	ftrace_stop();
+}
+
 /* When set, irq functions will be ignored */
 static int ftrace_graph_skip_irqs;
 
@@ -92,6 +124,9 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
 	unsigned long long calltime;
 	int index;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		return -EBUSY;
+
 	if (!current->ret_stack)
 		return -EBUSY;
 
-- 
2.0.0


