Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbaELPMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:12:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:51633 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758290AbaELPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:05 -0400
Message-Id: <20140512151202.702135478@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 01/13] ftrace: Have function graph tracer use global_ops for filtering
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-ftrace-Have-function-graph-tracer-use-global_ops-for.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 4104d326b670 "ftrace: Remove global function list and call
function directly" cleaned up the global_ops filtering and made
the code simpler. But it left out function graph filtering which
also depended on that code. The function graph filtering still
needs to use global_ops as the filter otherwise it wont filter
at all.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 34b098bf..9eb1aa0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5008,12 +5008,6 @@ ftrace_suspend_notifier_call(struct notifier_block *bl, unsigned long state,
 	return NOTIFY_DONE;
 }
 
-/* Just a place holder for function graph */
-static struct ftrace_ops fgraph_ops __read_mostly = {
-	.func		= ftrace_stub,
-	.flags		= FTRACE_OPS_FL_STUB | FTRACE_OPS_FL_RECURSION_SAFE,
-};
-
 static int ftrace_graph_entry_test(struct ftrace_graph_ent *trace)
 {
 	if (!ftrace_ops_test(&global_ops, trace->func, NULL))
@@ -5076,7 +5070,10 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_entry = ftrace_graph_entry_test;
 	update_function_graph_func();
 
-	ret = ftrace_startup(&fgraph_ops, FTRACE_START_FUNC_RET);
+	/* Function graph doesn't use the .func field of global_ops */
+	global_ops.flags |= FTRACE_OPS_FL_STUB;
+
+	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
@@ -5094,7 +5091,8 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	__ftrace_graph_entry = ftrace_graph_entry_stub;
-	ftrace_shutdown(&fgraph_ops, FTRACE_STOP_FUNC_RET);
+	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
+	global_ops.flags &= ~FTRACE_OPS_FL_STUB;
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
-- 
1.8.5.3


