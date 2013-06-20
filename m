Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084Ab3FTDjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:39:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935724Ab3FTDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:40 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ACRts49IUKIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ek_UtG945F0A:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=YpT1x1nesZNnTJHieWgA:9 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033639.241465107@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 05/12] ftrace: Use schedule_on_each_cpu() as a heavy synchronize_sched()
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-Use-schedule_on_each_cpu-as-a-heavy-synchroni.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

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
---
 kernel/trace/ftrace.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6c508ff..800a8a2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -413,6 +413,17 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
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
@@ -440,8 +451,12 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
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
@@ -456,9 +471,13 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
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
1.7.10.4


