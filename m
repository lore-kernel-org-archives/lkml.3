Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaC3XgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:36:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36480 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, "Tejun Heo" <tj@kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>, "Jiri Olsa" <jolsa@redhat.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.23182856@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 034/200] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: drop change for control ops]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -283,6 +283,17 @@ static int __register_ftrace_function(st
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
@@ -311,9 +322,13 @@ static int __unregister_ftrace_function(
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

