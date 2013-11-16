Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3KPA0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:26:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43662 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3KPAXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:47 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/16] rcu: Kick CPU halfway to RCU CPU stall warning
Date: Fri, 15 Nov 2013 16:23:23 -0800
Message-Id: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20131116002316.GA29049@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-8236-0000-0000-000003D80E1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When an RCU CPU stall warning occurs, the CPU invokes resched_cpu() on
itself.  This can help move the grace period forward in some situations,
but it would be even better to do this -before- the RCU CPU stall warning.
This commit therefore causes resched_cpu() to be called every five jiffies
once the system is halfway to an RCU CPU stall warning.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 26 +++++++++++++++++++++++++-
 kernel/rcu/tree.h |  2 ++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8a2c81e86dda..e00946e432ae 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -755,6 +755,12 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
 }
 
 /*
+ * This function really isn't for public consumption, but RCU is special in
+ * that context switches can allow the state machine to make progress.
+ */
+extern void resched_cpu(int cpu);
+
+/*
  * Return true if the specified CPU has passed through a quiescent
  * state by virtue of being in or having passed through an dynticks
  * idle state since the last call to dyntick_save_progress_counter()
@@ -812,16 +818,34 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	 */
 	rcu_kick_nohz_cpu(rdp->cpu);
 
+	/*
+	 * Alternatively, the CPU might be running in the kernel
+	 * for an extended period of time without a quiescent state.
+	 * Attempt to force the CPU through the scheduler to gain the
+	 * needed quiescent state, but only if the grace period has gone
+	 * on for an uncommonly long time.  If there are many stuck CPUs,
+	 * we will beat on the first one until it gets unstuck, then move
+	 * to the next.  Only do this for the primary flavor of RCU.
+	 */
+	if (rdp->rsp == rcu_state &&
+	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {
+		rdp->rsp->jiffies_resched += 5;
+		resched_cpu(rdp->cpu);
+	}
+
 	return 0;
 }
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	unsigned long j = ACCESS_ONCE(jiffies);
+	unsigned long j1;
 
 	rsp->gp_start = j;
 	smp_wmb(); /* Record start time before stall time. */
-	rsp->jiffies_stall = j + rcu_jiffies_till_stall_check();
+	j1 = rcu_jiffies_till_stall_check();
+	rsp->jiffies_stall = j + j1;
+	rsp->jiffies_resched = j + j1 / 2;
 }
 
 /*
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 52be957c9fe2..8e34d8674a4e 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -453,6 +453,8 @@ struct rcu_state {
 						/*  but in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
+	unsigned long jiffies_resched;		/* Time at which to resched */
+						/*  a reluctant CPU. */
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
 	const char *name;			/* Name of structure. */
-- 
1.8.1.5

