Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaH1SlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:41:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60500 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaH1Sif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:38:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/14] rcu: Eliminate redundant rcu_sysidle_state variable
Date: Thu, 28 Aug 2014 11:38:13 -0700
Message-Id: <1409251097-26734-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828183754.GA25488@linux.vnet.ibm.com>
 <1409251097-26734-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-0928-0000-0000-00000467FE12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Now that we have rcu_state_p, which references rcu_preempt_state for
TREE_PREEMPT_RCU and rcu_sched_state for TREE_RCU, we don't need a
separate rcu_sysidle_state variable.  This commit therefore eliminates
rcu_preempt_state in favor of rcu_state_p.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcu/tree_plugin.h | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index af01133dfd67..010f63ee6ee8 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2690,16 +2690,6 @@ static void __maybe_unused rcu_kick_nohz_cpu(int cpu)
 
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 
-/*
- * Define RCU flavor that holds sysidle state.  This needs to be the
- * most active flavor of RCU.
- */
-#ifdef CONFIG_PREEMPT_RCU
-static struct rcu_state *rcu_sysidle_state = &rcu_preempt_state;
-#else /* #ifdef CONFIG_PREEMPT_RCU */
-static struct rcu_state *rcu_sysidle_state = &rcu_sched_state;
-#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
-
 static int full_sysidle_state;		/* Current system-idle state. */
 #define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
 #define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
@@ -2841,7 +2831,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 	 * not the flavor of RCU that tracks sysidle state, or if this
 	 * is an offline or the timekeeping CPU, nothing to do.
 	 */
-	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
+	if (!*isidle || rdp->rsp != rcu_state_p ||
 	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
 		return;
 	if (rcu_gp_in_progress(rdp->rsp))
@@ -2867,7 +2857,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
  */
 static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 {
-	return rsp == rcu_sysidle_state;
+	return rsp == rcu_state_p;
 }
 
 /*
@@ -2945,7 +2935,7 @@ static void rcu_sysidle_cancel(void)
 static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
 			       unsigned long maxj, bool gpkt)
 {
-	if (rsp != rcu_sysidle_state)
+	if (rsp != rcu_state_p)
 		return;  /* Wrong flavor, ignore. */
 	if (gpkt && nr_cpu_ids <= CONFIG_NO_HZ_FULL_SYSIDLE_SMALL)
 		return;  /* Running state machine from timekeeping CPU. */
@@ -3014,13 +3004,12 @@ bool rcu_sys_is_idle(void)
 
 			/* Scan all the CPUs looking for nonidle CPUs. */
 			for_each_possible_cpu(cpu) {
-				rdp = per_cpu_ptr(rcu_sysidle_state->rda, cpu);
+				rdp = per_cpu_ptr(rcu_state_p->rda, cpu);
 				rcu_sysidle_check_cpu(rdp, &isidle, &maxj);
 				if (!isidle)
 					break;
 			}
-			rcu_sysidle_report(rcu_sysidle_state,
-					   isidle, maxj, false);
+			rcu_sysidle_report(rcu_state_p, isidle, maxj, false);
 			oldrss = rss;
 			rss = ACCESS_ONCE(full_sysidle_state);
 		}
@@ -3047,7 +3036,7 @@ bool rcu_sys_is_idle(void)
 	 * provided by the memory allocator.
 	 */
 	if (nr_cpu_ids > CONFIG_NO_HZ_FULL_SYSIDLE_SMALL &&
-	    !rcu_gp_in_progress(rcu_sysidle_state) &&
+	    !rcu_gp_in_progress(rcu_state_p) &&
 	    !rsh.inuse && xchg(&rsh.inuse, 1) == 0)
 		call_rcu(&rsh.rh, rcu_sysidle_cb);
 	return false;
-- 
1.8.1.5

