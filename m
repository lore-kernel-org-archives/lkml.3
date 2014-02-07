Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaBGLua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:50:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbaBGLuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 113/233] ftrace: Fix synchronization location disabling and freeing ftrace_ops
Date: Fri,  7 Feb 2014 11:45:32 +0000
Message-Id: <1391773652-25214-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit a4c35ed241129dd142be4cadb1e5a474a56d5464 upstream.

The synchronization needed after ftrace_ops are unregistered must happen
after the callback is disabled from becing called by functions.

The current location happens after the function is being removed from the
internal lists, but not after the function callbacks were disabled, leaving
the functions susceptible of being called after their callbacks are freed.

This affects perf and any externel users of function tracing (LTTng and
SystemTap).

Fixes: cdbe61bfe704 "ftrace: Allow dynamically allocated function tracers"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/ftrace.c | 58 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f1dd607..c984033 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -439,20 +439,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
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
 
@@ -462,17 +448,6 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
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
 
@@ -2141,10 +2116,41 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
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
1.8.3.2

