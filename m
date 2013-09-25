Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab3IYB3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:29:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49340 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3IYB33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:29 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/11] rcu: Have rcutiny tracepoints use tracepoint_string()
Date: Tue, 24 Sep 2013 18:29:20 -0700
Message-Id: <1380072561-31134-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-1344-0000-0000-000001EAFF0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit extends the work done in f7f7bac9 (rcu: Have the RCU
tracepoints use the tracepoint_string infrastructure) to cover rcutiny.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcu.h     |  7 +++++++
 kernel/rcutiny.c | 17 ++++++++++-------
 kernel/rcutree.c |  7 -------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/rcu.h b/kernel/rcu.h
index 7713196..7859a0a 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -122,4 +122,11 @@ int rcu_jiffies_till_stall_check(void);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
 
+/*
+ * Strings used in tracepoints need to be exported via the
+ * tracing system such that tools like perf and trace-cmd can
+ * translate the string address pointers to actual text.
+ */
+#define TPS(x)  tracepoint_string(x)
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 9ed6075..e99eb5f 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -35,6 +35,7 @@
 #include <linux/time.h>
 #include <linux/cpu.h>
 #include <linux/prefetch.h>
+#include <linux/ftrace_event.h>
 
 #ifdef CONFIG_RCU_TRACE
 #include <trace/events/rcu.h>
@@ -58,16 +59,17 @@ static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 static void rcu_idle_enter_common(long long newval)
 {
 	if (newval) {
-		RCU_TRACE(trace_rcu_dyntick("--=",
+		RCU_TRACE(trace_rcu_dyntick(TPS("--="),
 					    rcu_dynticks_nesting, newval));
 		rcu_dynticks_nesting = newval;
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting, newval));
+	RCU_TRACE(trace_rcu_dyntick(TPS("Start"),
+				    rcu_dynticks_nesting, newval));
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
+		RCU_TRACE(trace_rcu_dyntick(TPS("Entry error: not idle task"),
 					    rcu_dynticks_nesting, newval));
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
@@ -120,15 +122,15 @@ EXPORT_SYMBOL_GPL(rcu_irq_exit);
 static void rcu_idle_exit_common(long long oldval)
 {
 	if (oldval) {
-		RCU_TRACE(trace_rcu_dyntick("++=",
+		RCU_TRACE(trace_rcu_dyntick(TPS("++="),
 					    oldval, rcu_dynticks_nesting));
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
+	RCU_TRACE(trace_rcu_dyntick(TPS("End"), oldval, rcu_dynticks_nesting));
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
-		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
+		RCU_TRACE(trace_rcu_dyntick(TPS("Exit error: not idle task"),
 			  oldval, rcu_dynticks_nesting));
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
@@ -304,7 +306,8 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		RCU_TRACE(cb_count++);
 	}
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
-	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count, 0, need_resched(),
+	RCU_TRACE(trace_rcu_batch_end(rcp->name,
+				      cb_count, 0, need_resched(),
 				      is_idle_task(current),
 				      false));
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b618d72..62aab5c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -61,13 +61,6 @@
 
 #include "rcu.h"
 
-/*
- * Strings used in tracepoints need to be exported via the
- * tracing system such that tools like perf and trace-cmd can
- * translate the string address pointers to actual text.
- */
-#define TPS(x)	tracepoint_string(x)
-
 /* Data structures. */
 
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
-- 
1.8.1.5

