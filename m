Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbaAJV1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:27:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42915 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751466AbaAJV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:27:04 -0500
Date: Fri, 10 Jan 2014 16:27:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH] ftrace: Synchronize setting function_trace_op
 with ftrace_trace_function
Message-ID: <20140110162701.31a0cc2a@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 405e1d834807e51b2ebd3dea81cb51e53fb61504


Steven Rostedt (Red Hat) (1):
      ftrace: Synchronize setting function_trace_op with ftrace_trace_function

----
 kernel/trace/ftrace.c | 87 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 15 deletions(-)
---------------------------
commit 405e1d834807e51b2ebd3dea81cb51e53fb61504
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Fri Nov 8 14:17:30 2013 -0500

    ftrace: Synchronize setting function_trace_op with ftrace_trace_function
    
    ftrace_trace_function is a variable that holds what function will be called
    directly by the assembly code (mcount). If just a single function is
    registered and it handles recursion itself, then the assembly will call that
    function directly without any helper function. It also passes in the
    ftrace_op that was registered with the callback. The ftrace_op to send is
    stored in the function_trace_op variable.
    
    The ftrace_trace_function and function_trace_op needs to be coordinated such
    that the called callback wont be called with the wrong ftrace_op, otherwise
    bad things can happen if it expected a different op. Luckily, there's no
    callback that doesn't use the helper functions that requires this. But
    there soon will be and this needs to be fixed.
    
    Use a set_function_trace_op to store the ftrace_op to set the
    function_trace_op to when it is safe to do so (during the update function
    within the breakpoint or stop machine calls). Or if dynamic ftrace is not
    being used (static tracing) then we have to do a bit more synchronization
    when the ftrace_trace_function is set as that takes affect immediately
    (as oppose to dynamic ftrace doing it with the modification of the trampoline).
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 531ffa6..0ffb811 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -85,6 +85,8 @@ int function_trace_stop __read_mostly;
 
 /* Current function tracing op */
 struct ftrace_ops *function_trace_op __read_mostly = &ftrace_list_end;
+/* What to set function_trace_op to */
+static struct ftrace_ops *set_function_trace_op;
 
 /* List for set_ftrace_pid's pids. */
 LIST_HEAD(ftrace_pids);
@@ -278,6 +280,23 @@ static void update_global_ops(void)
 	global_ops.func = func;
 }
 
+static void ftrace_sync(struct work_struct *work)
+{
+	/*
+	 * This function is just a stub to implement a hard force
+	 * of synchronize_sched(). This requires synchronizing
+	 * tasks even in userspace and idle.
+	 *
+	 * Yes, function tracing is rude.
+	 */
+}
+
+static void ftrace_sync_ipi(void *data)
+{
+	/* Probably not needed, but do it anyway */
+	smp_rmb();
+}
+
 static void update_ftrace_function(void)
 {
 	ftrace_func_t func;
@@ -296,16 +315,59 @@ static void update_ftrace_function(void)
 	     !FTRACE_FORCE_LIST_FUNC)) {
 		/* Set the ftrace_ops that the arch callback uses */
 		if (ftrace_ops_list == &global_ops)
-			function_trace_op = ftrace_global_list;
+			set_function_trace_op = ftrace_global_list;
 		else
-			function_trace_op = ftrace_ops_list;
+			set_function_trace_op = ftrace_ops_list;
 		func = ftrace_ops_list->func;
 	} else {
 		/* Just use the default ftrace_ops */
-		function_trace_op = &ftrace_list_end;
+		set_function_trace_op = &ftrace_list_end;
 		func = ftrace_ops_list_func;
 	}
 
+	/* If there's no change, then do nothing more here */
+	if (ftrace_trace_function == func)
+		return;
+
+	/*
+	 * If we are using the list function, it doesn't care
+	 * about the function_trace_ops.
+	 */
+	if (func == ftrace_ops_list_func) {
+		ftrace_trace_function = func;
+		/*
+		 * Don't even bother setting function_trace_ops,
+		 * it would be racy to do so anyway.
+		 */
+		return;
+	}
+
+#ifndef CONFIG_DYNAMIC_FTRACE
+	/*
+	 * For static tracing, we need to be a bit more careful.
+	 * The function change takes affect immediately. Thus,
+	 * we need to coorditate the setting of the function_trace_ops
+	 * with the setting of the ftrace_trace_function.
+	 *
+	 * Set the function to the list ops, which will call the
+	 * function we want, albeit indirectly, but it handles the
+	 * ftrace_ops and doesn't depend on function_trace_op.
+	 */
+	ftrace_trace_function = ftrace_ops_list_func;
+	/*
+	 * Make sure all CPUs see this. Yes this is slow, but static
+	 * tracing is slow and nasty to have enabled.
+	 */
+	schedule_on_each_cpu(ftrace_sync);
+	/* Now all cpus are using the list ops. */
+	function_trace_op = set_function_trace_op;
+	/* Make sure the function_trace_op is visible on all CPUs */
+	smp_wmb();
+	/* Nasty way to force a rmb on all cpus */
+	smp_call_function(ftrace_sync_ipi, NULL, 1);
+	/* OK, we are all set to update the ftrace_trace_function now! */
+#endif /* !CONFIG_DYNAMIC_FTRACE */
+
 	ftrace_trace_function = func;
 }
 
@@ -410,17 +472,6 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	return 0;
 }
 
-static void ftrace_sync(struct work_struct *work)
-{
-	/*
-	 * This function is just a stub to implement a hard force
-	 * of synchronize_sched(). This requires synchronizing
-	 * tasks even in userspace and idle.
-	 *
-	 * Yes, function tracing is rude.
-	 */
-}
-
 static int __unregister_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret;
@@ -1979,8 +2030,14 @@ void ftrace_modify_all_code(int command)
 	else if (command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);
 
-	if (update && ftrace_trace_function != ftrace_ops_list_func)
+	if (update && ftrace_trace_function != ftrace_ops_list_func) {
+		function_trace_op = set_function_trace_op;
+		smp_wmb();
+		/* If irqs are disabled, we are in stop machine */
+		if (!irqs_disabled())
+			smp_call_function(ftrace_sync_ipi, NULL, 1);
 		ftrace_update_ftrace_func(ftrace_trace_function);
+	}
 
 	if (command & FTRACE_START_FUNC_RET)
 		ftrace_enable_ftrace_graph_caller();
