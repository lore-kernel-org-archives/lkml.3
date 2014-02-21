Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaBUNUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:20:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086AbaBUNCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 26/60] ftrace: Have function graph only trace based on global_ops filters
Date: Fri, 21 Feb 2014 13:00:53 +0000
Message-Id: <1392987687-15367-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 23a8e8441a0a74dd612edf81dc89d1600bc0a3d1 upstream.

Doing some different tests, I discovered that function graph tracing, when
filtered via the set_ftrace_filter and set_ftrace_notrace files, does
not always keep with them if another function ftrace_ops is registered
to trace functions.

The reason is that function graph just happens to trace all functions
that the function tracer enables. When there was only one user of
function tracing, the function graph tracer did not need to worry about
being called by functions that it did not want to trace. But now that there
are other users, this becomes a problem.

For example, one just needs to do the following:

 # cd /sys/kernel/debug/tracing
 # echo schedule > set_ftrace_filter
 # echo function_graph > current_tracer
 # cat trace
[..]
 0)               |  schedule() {
 ------------------------------------------
 0)    <idle>-0    =>   rcu_pre-7
 ------------------------------------------

 0) ! 2980.314 us |  }
 0)               |  schedule() {
 ------------------------------------------
 0)   rcu_pre-7    =>    <idle>-0
 ------------------------------------------

 0) + 20.701 us   |  }

 # echo 1 > /proc/sys/kernel/stack_tracer_enabled
 # cat trace
[..]
 1) + 20.825 us   |      }
 1) + 21.651 us   |    }
 1) + 30.924 us   |  } /* SyS_ioctl */
 1)               |  do_page_fault() {
 1)               |    __do_page_fault() {
 1)   0.274 us    |      down_read_trylock();
 1)   0.098 us    |      find_vma();
 1)               |      handle_mm_fault() {
 1)               |        _raw_spin_lock() {
 1)   0.102 us    |          preempt_count_add();
 1)   0.097 us    |          do_raw_spin_lock();
 1)   2.173 us    |        }
 1)               |        do_wp_page() {
 1)   0.079 us    |          vm_normal_page();
 1)   0.086 us    |          reuse_swap_page();
 1)   0.076 us    |          page_move_anon_rmap();
 1)               |          unlock_page() {
 1)   0.082 us    |            page_waitqueue();
 1)   0.086 us    |            __wake_up_bit();
 1)   1.801 us    |          }
 1)   0.075 us    |          ptep_set_access_flags();
 1)               |          _raw_spin_unlock() {
 1)   0.098 us    |            do_raw_spin_unlock();
 1)   0.105 us    |            preempt_count_sub();
 1)   1.884 us    |          }
 1)   9.149 us    |        }
 1) + 13.083 us   |      }
 1)   0.146 us    |      up_read();

When the stack tracer was enabled, it enabled all functions to be traced, which
now the function graph tracer also traces. This is a side effect that should
not occur.

To fix this a test is added when the function tracing is changed, as well as when
the graph tracer is enabled, to see if anything other than the ftrace global_ops
function tracer is enabled. If so, then the graph tracer calls a test trampoline
that will look at the function that is being traced and compare it with the
filters defined by the global_ops.

As an optimization, if there's no other function tracers registered, or if
the only registered function tracers also use the global ops, the function
graph infrastructure will call the registered function graph callback directly
and not go through the test trampoline.

Fixes: d2d45c7a03a2 "tracing: Have stack_tracer use a separate list of functions"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ luis: backported to 3.5: used Steven's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/ftrace.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5119235..05dc549 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -239,6 +239,12 @@ static void ftrace_sync_ipi(void *data)
 	smp_rmb();
 }
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static void update_function_graph_func(void);
+#else
+static inline void update_function_graph_func(void) { }
+#endif
+
 static void update_ftrace_function(void)
 {
 	ftrace_func_t func;
@@ -257,6 +263,8 @@ static void update_ftrace_function(void)
 	else
 		func = ftrace_ops_list_func;
 
+	update_function_graph_func();
+
 #ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	ftrace_trace_function = func;
 #else
@@ -4482,6 +4490,7 @@ int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace)
 trace_func_graph_ret_t ftrace_graph_return =
 			(trace_func_graph_ret_t)ftrace_stub;
 trace_func_graph_ent_t ftrace_graph_entry = ftrace_graph_entry_stub;
+static trace_func_graph_ent_t __ftrace_graph_entry = ftrace_graph_entry_stub;
 
 /* Try to assign a return stack array on FTRACE_RETSTACK_ALLOC_SIZE tasks. */
 static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
@@ -4622,6 +4631,30 @@ static struct ftrace_ops fgraph_ops __read_mostly = {
 	.flags		= FTRACE_OPS_FL_GLOBAL,
 };
 
+static int ftrace_graph_entry_test(struct ftrace_graph_ent *trace)
+{
+	if (!ftrace_ops_test(&global_ops, trace->func))
+		return 0;
+	return __ftrace_graph_entry(trace);
+}
+
+/*
+ * The function graph tracer should only trace the functions defined
+ * by set_ftrace_filter and set_ftrace_notrace. If another function
+ * tracer ops is registered, the graph tracer requires testing the
+ * function against the global ops, and not just trace any function
+ * that any ftrace_ops registered.
+ */
+static void update_function_graph_func(void)
+{
+	if (ftrace_ops_list == &ftrace_list_end ||
+	    (ftrace_ops_list == &global_ops &&
+	     global_ops.next == &ftrace_list_end))
+		ftrace_graph_entry = __ftrace_graph_entry;
+	else
+		ftrace_graph_entry = ftrace_graph_entry_test;
+}
+
 int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 			trace_func_graph_ent_t entryfunc)
 {
@@ -4646,7 +4679,16 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	}
 
 	ftrace_graph_return = retfunc;
-	ftrace_graph_entry = entryfunc;
+
+	/*
+	 * Update the indirect function to the entryfunc, and the
+	 * function that gets called to the entry_test first. Then
+	 * call the update fgraph entry function to determine if
+	 * the entryfunc should be called directly or not.
+	 */
+	__ftrace_graph_entry = entryfunc;
+	ftrace_graph_entry = ftrace_graph_entry_test;
+	update_function_graph_func();
 
 	ret = ftrace_startup(&fgraph_ops, FTRACE_START_FUNC_RET);
 
@@ -4665,6 +4707,7 @@ void unregister_ftrace_graph(void)
 	ftrace_graph_active--;
 	ftrace_graph_return = (trace_func_graph_ret_t)ftrace_stub;
 	ftrace_graph_entry = ftrace_graph_entry_stub;
+	__ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(&fgraph_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
-- 
1.9.0

