Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbbAGRxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:53:08 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35321 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbbAGRw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:56 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/10] rcu: Improve diagnostics for spurious RCU CPU stall warnings
Date: Wed,  7 Jan 2015 09:52:42 -0800
Message-Id: <1420653168-6434-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
 <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0025-0000-0000-00000791FE0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current RCU CPU stall warning code will print "Stall ended before
state dump start" any time that the stall-warning code is triggered on
a CPU that has already reported a quiescent state for the current grace
period and if all quiescent states have been reported for the current
grace period.  However, a true stall can result in these symptoms, for
example, by preventing RCU's grace-period kthreads from ever running

This commit therefore checks for this condition, reporting the end of
the stall only if one of the grace-period counters has actually advanced.
Otherwise, it reports the last time that the grace-period kthread made
meaningful progress.  (In normal situations, the grace-period kthread
should make meaningful progress at least every jiffies_till_next_fqs
jiffies.)

Reported-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Miroslav Benes <mbenes@suse.cz>
---
 Documentation/RCU/stallwarn.txt |  5 +++++
 kernel/rcu/tree.c               | 32 +++++++++++++++++++++++++++-----
 kernel/rcu/tree.h               |  2 ++
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index ed186a902d31..55f9707fe60a 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -187,6 +187,11 @@ o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the
 	behavior, you might need to replace some of the cond_resched()
 	calls with calls to cond_resched_rcu_qs().
 
+o	Anything that prevents RCU's grace-period kthreads from running.
+	This can result in the "All QSes seen" console-log message.
+	This message will include information on when the kthread last
+	ran and how often it should be expected to run.
+
 o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
 	happen to preempt a low-priority task in the middle of an RCU
 	read-side critical section.   This is especially damaging if
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 654b15be1e36..a2ceb66bcd67 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1066,11 +1066,13 @@ static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
 	}
 }
 
-static void print_other_cpu_stall(struct rcu_state *rsp)
+static void print_other_cpu_stall(struct rcu_state *rsp, unsigned long gpnum)
 {
 	int cpu;
 	long delta;
 	unsigned long flags;
+	unsigned long gpa;
+	unsigned long j;
 	int ndetected = 0;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	long totqlen = 0;
@@ -1123,10 +1125,22 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	pr_cont("(detected by %d, t=%ld jiffies, g=%ld, c=%ld, q=%lu)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
 	       (long)rsp->gpnum, (long)rsp->completed, totqlen);
-	if (ndetected == 0)
-		pr_err("INFO: Stall ended before state dump start\n");
-	else
+	if (ndetected) {
 		rcu_dump_cpu_stacks(rsp);
+	} else {
+		if (ACCESS_ONCE(rsp->gpnum) != gpnum ||
+		    ACCESS_ONCE(rsp->completed) == gpnum) {
+			pr_err("INFO: Stall ended before state dump start\n");
+		} else {
+			j = jiffies;
+			gpa = ACCESS_ONCE(rsp->gp_activity);
+			pr_err("All QSes seen, last %s kthread activity %ld (%ld-%ld), jiffies_till_next_fqs=%ld\n",
+			       rsp->name, j - gpa, j, gpa,
+			       jiffies_till_next_fqs);
+			/* In this case, the current CPU might be at fault. */
+			sched_show_task(current);
+		}
+	}
 
 	/* Complain about tasks blocking the grace period. */
 
@@ -1226,7 +1240,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 		   ULONG_CMP_GE(j, js + RCU_STALL_RAT_DELAY)) {
 
 		/* They had a few time units to dump stack, so complain. */
-		print_other_cpu_stall(rsp);
+		print_other_cpu_stall(rsp, gpnum);
 	}
 }
 
@@ -1622,6 +1636,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
 	smp_mb__after_unlock_lock();
@@ -1682,6 +1697,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched_rcu_qs();
+		ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	}
 
 	mutex_unlock(&rsp->onoff_mutex);
@@ -1698,6 +1714,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	unsigned long maxj;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	rsp->n_force_qs++;
 	if (fqs_state == RCU_SAVE_DYNTICK) {
 		/* Collect dyntick-idle snapshots. */
@@ -1736,6 +1753,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	raw_spin_lock_irq(&rnp->lock);
 	smp_mb__after_unlock_lock();
 	gp_duration = jiffies - rsp->gp_start;
@@ -1772,6 +1790,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched_rcu_qs();
+		ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
@@ -1821,6 +1840,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			if (rcu_gp_init(rsp))
 				break;
 			cond_resched_rcu_qs();
+			ACCESS_ONCE(rsp->gp_activity) = jiffies;
 			WARN_ON(signal_pending(current));
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
@@ -1864,9 +1884,11 @@ static int __noreturn rcu_gp_kthread(void *arg)
 						       ACCESS_ONCE(rsp->gpnum),
 						       TPS("fqsend"));
 				cond_resched_rcu_qs();
+				ACCESS_ONCE(rsp->gp_activity) = jiffies;
 			} else {
 				/* Deal with stray signal. */
 				cond_resched_rcu_qs();
+				ACCESS_ONCE(rsp->gp_activity) = jiffies;
 				WARN_ON(signal_pending(current));
 				trace_rcu_grace_period(rsp->name,
 						       ACCESS_ONCE(rsp->gpnum),
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index e300848cc0cf..5ec81cf938fd 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -488,6 +488,8 @@ struct rcu_state {
 						/*  due to no GP active. */
 	unsigned long gp_start;			/* Time at which GP started, */
 						/*  but in jiffies. */
+	unsigned long gp_activity;		/* Time of last GP kthread */
+						/*  activity in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
 	unsigned long jiffies_resched;		/* Time at which to resched */
-- 
1.8.1.5

