Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab3IYBnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:43:03 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36934 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634Ab3IYBm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/10] rcu: Add tracing to rcu_gp_kthread()
Date: Tue, 24 Sep 2013 18:42:33 -0700
Message-Id: <1380073359-31959-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0928-0000-0000-000001DB9FFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds tracing to the rcu_gp_kthread() function in order to
help trace down hangs potentially involving this kthread.

Reported-by: Clark Williams <williams@redhat.com>
Reported-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/trace/events/rcu.h | 28 +++++++++++++++++++---------
 kernel/rcutree.c           | 18 ++++++++++++++++++
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index ee2376c..60077e1 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -39,15 +39,25 @@ TRACE_EVENT(rcu_utilization,
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 
 /*
- * Tracepoint for grace-period events: starting and ending a grace
- * period ("start" and "end", respectively), a CPU noting the start
- * of a new grace period or the end of an old grace period ("cpustart"
- * and "cpuend", respectively), a CPU passing through a quiescent
- * state ("cpuqs"), a CPU coming online or going offline ("cpuonl"
- * and "cpuofl", respectively), a CPU being kicked for being too
- * long in dyntick-idle mode ("kick"), a CPU accelerating its new
- * callbacks to RCU_NEXT_READY_TAIL ("AccReadyCB"), and a CPU
- * accelerating its new callbacks to RCU_WAIT_TAIL ("AccWaitCB").
+ * Tracepoint for grace-period events.  Takes a string identifying the
+ * RCU flavor, the grace-period number, and a string identifying the
+ * grace-period-related event as follows:
+ *
+ *	"AccReadyCB": CPU acclerates new callbacks to RCU_NEXT_READY_TAIL.
+ *	"AccWaitCB": CPU accelerates new callbacks to RCU_WAIT_TAIL.
+ *	"start": Start a grace period.
+ *	"cpustart": CPU first notices a grace-period start.
+ *	"cpuqs": CPU passes through a quiescent state.
+ *	"cpuonl": CPU comes online.
+ *	"cpuofl": CPU goes offline.
+ *	"reqwait": GP kthread sleeps waiting for grace-period request.
+ *	"reqwaitsig": GP kthread awakened by signal from reqwait state.
+ *	"fqswait": GP kthread waiting until time to force quiescent states.
+ *	"fqsstart": GP kthread starts forcing quiescent states.
+ *	"fqsend": GP kthread done forcing quiescent states.
+ *	"fqswaitsig": GP kthread awakened by signal from fqswait state.
+ *	"end": End a grace period.
+ *	"cpuend": CPU first notices a grace-period end.
  */
 TRACE_EVENT(rcu_grace_period,
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6d028fd..78d3715 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1480,6 +1480,9 @@ static int __noreturn rcu_gp_kthread(void *arg)
 
 		/* Handle grace-period start. */
 		for (;;) {
+			trace_rcu_grace_period(rsp->name,
+					       ACCESS_ONCE(rsp->gpnum),
+					       TPS("reqwait"));
 			wait_event_interruptible(rsp->gp_wq,
 						 ACCESS_ONCE(rsp->gp_flags) &
 						 RCU_GP_FLAG_INIT);
@@ -1487,6 +1490,9 @@ static int __noreturn rcu_gp_kthread(void *arg)
 				break;
 			cond_resched();
 			flush_signals(current);
+			trace_rcu_grace_period(rsp->name,
+					       ACCESS_ONCE(rsp->gpnum),
+					       TPS("reqwaitsig"));
 		}
 
 		/* Handle quiescent-state forcing. */
@@ -1500,6 +1506,9 @@ static int __noreturn rcu_gp_kthread(void *arg)
 		for (;;) {
 			if (!ret)
 				rsp->jiffies_force_qs = jiffies + j;
+			trace_rcu_grace_period(rsp->name,
+					       ACCESS_ONCE(rsp->gpnum),
+					       TPS("fqswait"));
 			ret = wait_event_interruptible_timeout(rsp->gp_wq,
 					((gf = ACCESS_ONCE(rsp->gp_flags)) &
 					 RCU_GP_FLAG_FQS) ||
@@ -1513,12 +1522,21 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			/* If time for quiescent-state forcing, do it. */
 			if (ULONG_CMP_GE(jiffies, rsp->jiffies_force_qs) ||
 			    (gf & RCU_GP_FLAG_FQS)) {
+				trace_rcu_grace_period(rsp->name,
+						       ACCESS_ONCE(rsp->gpnum),
+						       TPS("fqsstart"));
 				fqs_state = rcu_gp_fqs(rsp, fqs_state);
+				trace_rcu_grace_period(rsp->name,
+						       ACCESS_ONCE(rsp->gpnum),
+						       TPS("fqsend"));
 				cond_resched();
 			} else {
 				/* Deal with stray signal. */
 				cond_resched();
 				flush_signals(current);
+				trace_rcu_grace_period(rsp->name,
+						       ACCESS_ONCE(rsp->gpnum),
+						       TPS("fqswaitsig"));
 			}
 			j = jiffies_till_next_fqs;
 			if (j > HZ) {
-- 
1.8.1.5

