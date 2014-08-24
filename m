Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaHXRJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:09:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:63954 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752675AbaHXRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:08:54 -0400
Message-Id: <20140824170850.144108032@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 24 Aug 2014 13:08:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [PATCH 4/5] ftrace: Fix function_profiler and function tracer together
References: <20140824170808.753599145@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-ftrace-Fix-function_profiler-and-function-tracer-tog.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The latest rewrite of ftrace removed the separate ftrace_ops of
the function tracer and the function graph tracer and had them
share the same ftrace_ops. This simplified the accounting by removing
the multiple layers of functions called, where the global_ops func
would call a special list that would iterate over the other ops that
were registered within it (like function and function graph), which
itself was registered to the ftrace ops list of all functions
currently active. If that sounds confusing, the code that implemented
it was also confusing and its removal is a good thing.

The problem with this change was that it assumed that the function
and function graph tracer can never be used at the same time.
This is mostly true, but there is an exception. That is when the
function profiler uses the function graph tracer to profile.
The function profiler can be activated the same time as the function
tracer, and this breaks the assumption and the result is that ftrace
will crash (it detects the error and shuts itself down, it does not
cause a kernel oops).

To solve this issue, a previous change allowed the hash tables
for the functions traced by a ftrace_ops to be a pointer and let
multiple ftrace_ops share the same hash. This allows the function
and function_graph tracer to have separate ftrace_ops, but still
share the hash, which is what is done.

Now the function and function graph tracers have separate ftrace_ops
again, and the function tracer can be run while the function_profile
is active.

Cc: stable@vger.kernel.org # 3.16 (apply after 3.17-rc4 is out)
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 60 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 92376aeac4a7..08aca65d709a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -68,8 +68,12 @@
 #define INIT_OPS_HASH(opsname)	\
 	.func_hash		= &opsname.local_hash,			\
 	.local_hash.regex_lock	= __MUTEX_INITIALIZER(opsname.local_hash.regex_lock),
+#define ASSIGN_OPS_HASH(opsname, val) \
+	.func_hash		= val, \
+	.local_hash.regex_lock	= __MUTEX_INITIALIZER(opsname.local_hash.regex_lock),
 #else
 #define INIT_OPS_HASH(opsname)
+#define ASSIGN_OPS_HASH(opsname, val)
 #endif
 
 static struct ftrace_ops ftrace_list_end __read_mostly = {
@@ -4663,7 +4667,6 @@ void __init ftrace_init(void)
 static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
-	INIT_OPS_HASH(global_ops)
 };
 
 static int __init ftrace_nodyn_init(void)
@@ -5197,6 +5200,17 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
+static struct ftrace_ops graph_ops = {
+	.func			= ftrace_stub,
+	.flags			= FTRACE_OPS_FL_RECURSION_SAFE |
+				   FTRACE_OPS_FL_INITIALIZED |
+				   FTRACE_OPS_FL_STUB,
+#ifdef FTRACE_GRAPH_TRAMP_ADDR
+	.trampoline		= FTRACE_GRAPH_TRAMP_ADDR,
+#endif
+	ASSIGN_OPS_HASH(graph_ops, &global_ops.local_hash)
+};
+
 static int ftrace_graph_active;
 
 int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
@@ -5359,12 +5373,28 @@ static int ftrace_graph_entry_test(struct ftrace_graph_ent *trace)
  */
 static void update_function_graph_func(void)
 {
-	if (ftrace_ops_list == &ftrace_list_end ||
-	    (ftrace_ops_list == &global_ops &&
-	     global_ops.next == &ftrace_list_end))
-		ftrace_graph_entry = __ftrace_graph_entry;
-	else
+	struct ftrace_ops *op;
+	bool do_test = false;
+
+	/*
+	 * The graph and global ops share the same set of functions
+	 * to test. If any other ops is on the list, then
+	 * the graph tracing needs to test if its the function
+	 * it should call.
+	 */
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		if (op != &global_ops && op != &graph_ops &&
+		    op != &ftrace_list_end) {
+			do_test = true;
+			/* in double loop, break out with goto */
+			goto out;
+		}
+	} while_for_each_ftrace_op(op);
+ out:
+	if (do_test)
 		ftrace_graph_entry = ftrace_graph_entry_test;
+	else
+		ftrace_graph_entry = __ftrace_graph_entry;
 }
 
 static struct notifier_block ftrace_suspend_notifier = {
@@ -5405,16 +5435,7 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	ftrace_graph_entry = ftrace_graph_entry_test;
 	update_function_graph_func();
 
-	/* Function graph doesn't use the .func field of global_ops */
-	global_ops.flags |= FTRACE_OPS_FL_STUB;
-
-#ifdef CONFIG_DYNAMIC_FTRACE
-	/* Optimize function graph calling (if implemented by arch) */
-	if (FTRACE_GRAPH_TRAMP_ADDR != 0)
-		global_ops.trampoline = FTRACE_GRAPH_TRAMP_ADDR;
-#endif
-
-	ret = ftrace_startup(&global_ops, FTRACE_START_FUNC_RET);
+	ret = ftrace_startup(&graph_ops, FTRACE_START_FUNC_RET);
 
 out:
 	mutex_unlock(&ftrace_lock);
@@ -5432,12 +5453,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
 	__ftrace_graph_entry = ftrace_graph_entry_stub;
-	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
-	global_ops.flags &= ~FTRACE_OPS_FL_STUB;
-#ifdef CONFIG_DYNAMIC_FTRACE
-	if (FTRACE_GRAPH_TRAMP_ADDR != 0)
-		global_ops.trampoline = 0;
-#endif
+	ftrace_shutdown(&graph_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
-- 
2.0.1


