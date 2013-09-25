Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab3IYBnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:43:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59081 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab3IYBm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/10] rcu: Add tracing for rcuo no-CBs CPU wakeup handshake
Date: Tue, 24 Sep 2013 18:42:35 -0700
Message-Id: <1380073359-31959-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-9332-0000-0000-000001876378
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Lost wakeups from call_rcu() to the rcuo kthreads can result in hangs
that are difficult to diagnose.  This commit therefore adds tracing to
help pin down the cause of these hangs.

Reported-by: Clark Williams <williams@redhat.com>
Reported-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
[ paulmck: Add const per kbuild test robot's advice. ]
---
 include/trace/events/rcu.h | 37 +++++++++++++++++++++++++++++++++++++
 kernel/rcutree_plugin.h    | 14 +++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 98466c6..4301cd9 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -172,6 +172,42 @@ TRACE_EVENT(rcu_grace_period_init,
 );
 
 /*
+ * Tracepoint for RCU no-CBs CPU callback handoffs.  This event is intended
+ * to assist debugging of these handoffs.
+ *
+ * The first argument is the name of the RCU flavor, and the second is
+ * the number of the offloaded CPU are extracted.  The third and final
+ * argument is a string as follows:
+ *
+ *	"WakeEmpty": Wake rcuo kthread, first CB to empty list.
+ *	"WakeOvf": Wake rcuo kthread, CB list is huge.
+ *	"WakeNot": Don't wake rcuo kthread.
+ *	"WakeNotPoll": Don't wake rcuo kthread because it is polling.
+ *	"WokeEmpty": rcuo kthread woke to find empty list.
+ *	"WokeNonEmpty": rcuo kthread woke to find non-empty list.
+ */
+TRACE_EVENT(rcu_nocb_wake,
+
+	TP_PROTO(const char *rcuname, int cpu, const char *reason),
+
+	TP_ARGS(rcuname, cpu, reason),
+
+	TP_STRUCT__entry(
+		__field(const char *, rcuname)
+		__field(int, cpu)
+		__field(const char *, reason)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->cpu = cpu;
+		__entry->reason = reason;
+	),
+
+	TP_printk("%s %d %s", __entry->rcuname, __entry->cpu, __entry->reason)
+);
+
+/*
  * Tracepoint for tasks blocking within preemptible-RCU read-side
  * critical sections.  Track the type of RCU (which one day might
  * include SRCU), the grace-period number that the task is blocking
@@ -667,6 +703,7 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_future_grace_period(rcuname, gpnum, completed, c, \
 				      level, grplo, grphi, event) \
 				      do { } while (0)
+#define trace_rcu_nocb_wake(rcuname, cpu, reason) do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 130c97b..f4ed24b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2108,15 +2108,22 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 
 	/* If we are not being polled and there is a kthread, awaken it ... */
 	t = ACCESS_ONCE(rdp->nocb_kthread);
-	if (rcu_nocb_poll | !t)
+	if (rcu_nocb_poll | !t) {
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+				    TPS("WakeNotPoll"));
 		return;
+	}
 	len = atomic_long_read(&rdp->nocb_q_count);
 	if (old_rhpp == &rdp->nocb_head) {
 		wake_up(&rdp->nocb_wq); /* ... only if queue was empty ... */
 		rdp->qlen_last_fqs_check = 0;
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeEmpty"));
 	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
 		wake_up_process(t); /* ... or if many callbacks queued. */
 		rdp->qlen_last_fqs_check = LONG_MAX / 2;
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeOvf"));
+	} else {
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeNot"));
 	}
 	return;
 }
@@ -2233,10 +2240,15 @@ static int rcu_nocb_kthread(void *arg)
 			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
 		list = ACCESS_ONCE(rdp->nocb_head);
 		if (!list) {
+			if (!rcu_nocb_poll)
+				trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+						    TPS("WokeEmpty"));
 			schedule_timeout_interruptible(1);
 			flush_signals(current);
 			continue;
 		}
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+				    TPS("WokeNonEmpty"));
 
 		/*
 		 * Extract queued callbacks, update counts, and wait
-- 
1.8.1.5

