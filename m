Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaBJTmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:42:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaBJTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:42:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 051/124] ftrace: Use schedule_on_each_cpu() as a heavy synchronize_sched()
Date: Mon, 10 Feb 2014 11:39:51 -0800
Message-Id: <1392061264-28124-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 7614c3dc74733dff4b0e774f7a894b9ea6ec508c upstream.

The function tracer uses preempt_disable/enable_notrace() for
synchronization between reading registered ftrace_ops and unregistering
them.

Most of the ftrace_ops are global permanent structures that do not
require this synchronization. That is, ops may be added and removed from
the hlist but are never freed, and wont hurt if a synchronization is
missed.

But this is not true for dynamically created ftrace_ops or control_ops,
which are used by the perf function tracing.

The problem here is that the function tracer can be used to trace
kernel/user context switches as well as going to and from idle.
Basically, it can be used to trace blind spots of the RCU subsystem.
This means that even though preempt_disable() is done, a
synchronize_sched() will ignore CPUs that haven't made it out of user
space or idle. These can include functions that are being traced just
before entering or exiting the kernel sections.

To implement the RCU synchronization, instead of using
synchronize_sched() the use of schedule_on_each_cpu() is performed. This
means that when a dynamically allocated ftrace_ops, or a control ops is
being unregistered, all CPUs must be touched and execute a ftrace_sync()
stub function via the work queues. This will rip CPUs out from idle or
in dynamic tick mode. This only happens when a user disables perf
function tracing or other dynamically allocated function tracers, but it
allows us to continue to debug RCU and context tracking with function
tracing.

Link: http://lkml.kernel.org/r/1369785676.15552.55.camel@gandalf.local.home

Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ kamal: 3.8-stable prereq for a4c35ed2
  "ftrace: Fix synchronization location disabling and freeing ftrace_ops" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/trace/ftrace.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c7f6959..0ae6f97 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -367,6 +367,17 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	return 0;
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
 static int __unregister_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret;
@@ -391,8 +402,12 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 			 * so there'll be no new users. We must ensure
 			 * all current users are done before we free
 			 * the control data.
+			 * Note synchronize_sched() is not enough, as we
+			 * use preempt_disable() to do RCU, but the function
+			 * tracer can be called where RCU is not active
+			 * (before user_exit()).
 			 */
-			synchronize_sched();
+			schedule_on_each_cpu(ftrace_sync);
 			control_ops_free(ops);
 		}
 	} else
@@ -407,9 +422,13 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	/*
 	 * Dynamic ops may be freed, we must make sure that all
 	 * callers are done before leaving this function.
+	 *
+	 * Again, normal synchronize_sched() is not good enough.
+	 * We need to do a hard force of sched synchronization.
 	 */
 	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
-		synchronize_sched();
+		schedule_on_each_cpu(ftrace_sync);
+
 
 	return 0;
 }
-- 
1.8.3.2

