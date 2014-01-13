Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaAMX4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:56:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:26900 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751207AbaAMXzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:55:21 -0500
Message-Id: <20140113235516.589802358@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 13 Jan 2014 18:50:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 2/2] ftrace: Fix synchronization location disabling and freeing ftrace_ops
References: <20140113235036.473005178@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Fix-synchronization-location-disabling-and-fr.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The synchronization needed after ftrace_ops are unregistered must happen
after the callback is disabled from becing called by functions.

The current location happens after the function is being removed from the
internal lists, but not after the function callbacks were disabled, leaving
the functions susceptible of being called after their callbacks are freed.

This affects perf and any externel users of function tracing (LTTng and
SystemTap).

Cc: stable@vger.kernel.org # 3.0+
Fixes: cdbe61bfe704 "ftrace: Allow dynamically allocated function tracers"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 58 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7f21b06..7181ad1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -498,20 +498,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	} else if (ops->flags & FTRACE_OPS_FL_CONTROL) {
 		ret = remove_ftrace_list_ops(&ftrace_control_list,
 					     &control_ops, ops);
-		if (!ret) {
-			/*
-			 * The ftrace_ops is now removed from the list,
-			 * so there'll be no new users. We must ensure
-			 * all current users are done before we free
-			 * the control data.
-			 * Note synchronize_sched() is not enough, as we
-			 * use preempt_disable() to do RCU, but the function
-			 * tracer can be called where RCU is not active
-			 * (before user_exit()).
-			 */
-			schedule_on_each_cpu(ftrace_sync);
-			control_ops_free(ops);
-		}
 	} else
 		ret = remove_ftrace_ops(&ftrace_ops_list, ops);
 
@@ -521,17 +507,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	if (ftrace_enabled)
 		update_ftrace_function();
 
-	/*
-	 * Dynamic ops may be freed, we must make sure that all
-	 * callers are done before leaving this function.
-	 *
-	 * Again, normal synchronize_sched() is not good enough.
-	 * We need to do a hard force of sched synchronization.
-	 */
-	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
-		schedule_on_each_cpu(ftrace_sync);
-
-
 	return 0;
 }
 
@@ -2208,10 +2183,41 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 		command |= FTRACE_UPDATE_TRACE_FUNC;
 	}
 
-	if (!command || !ftrace_enabled)
+	if (!command || !ftrace_enabled) {
+		/*
+		 * If these are control ops, they still need their
+		 * per_cpu field freed. Since, function tracing is
+		 * not currently active, we can just free them
+		 * without synchronizing all CPUs.
+		 */
+		if (ops->flags & FTRACE_OPS_FL_CONTROL)
+			control_ops_free(ops);
 		return 0;
+	}
 
 	ftrace_run_update_code(command);
+
+	/*
+	 * Dynamic ops may be freed, we must make sure that all
+	 * callers are done before leaving this function.
+	 * The same goes for freeing the per_cpu data of the control
+	 * ops.
+	 *
+	 * Again, normal synchronize_sched() is not good enough.
+	 * We need to do a hard force of sched synchronization.
+	 * This is because we use preempt_disable() to do RCU, but
+	 * the function tracers can be called where RCU is not watching
+	 * (like before user_exit()). We can not rely on the RCU
+	 * infrastructure to do the synchronization, thus we must do it
+	 * ourselves.
+	 */
+	if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_CONTROL)) {
+		schedule_on_each_cpu(ftrace_sync);
+
+		if (ops->flags & FTRACE_OPS_FL_CONTROL)
+			control_ops_free(ops);
+	}
+
 	return 0;
 }
 
-- 
1.8.4.3


