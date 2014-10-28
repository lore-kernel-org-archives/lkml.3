Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaJ1WgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:36:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60947 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaJ1W1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:27:03 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/7] rcu: Avoid IPIing idle CPUs from synchronize_sched_expedited()
Date: Tue, 28 Oct 2014 15:22:58 -0700
Message-Id: <1414534982-29203-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0029-0000-0000-000000F5063A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, synchronize_sched_expedited() sends IPIs to all online CPUs,
even those that are idle or executing in nohz_full= userspace.  Because
idle CPUs and nohz_full= userspace CPUs are in extended quiescent states,
there is no need to IPI them in the first place.  This commit therefore
avoids IPIing CPUs that are already in extended quiescent states.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7f73c5edf8cf..9e3c20f117cd 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2950,6 +2950,9 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
  */
 void synchronize_sched_expedited(void)
 {
+	cpumask_var_t cm;
+	bool cma = false;
+	int cpu;
 	long firstsnap, s, snap;
 	int trycount = 0;
 	struct rcu_state *rsp = &rcu_sched_state;
@@ -2984,11 +2987,26 @@ void synchronize_sched_expedited(void)
 	}
 	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
 
+	/* Offline CPUs, idle CPUs, and any CPU we run on are quiescent. */
+	cma = zalloc_cpumask_var(&cm, GFP_KERNEL);
+	if (cma) {
+		cpumask_copy(cm, cpu_online_mask);
+		cpumask_clear_cpu(raw_smp_processor_id(), cm);
+		for_each_cpu(cpu, cm) {
+			struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+			if (!(atomic_add_return(0, &rdtp->dynticks) & 0x1))
+				cpumask_clear_cpu(cpu, cm);
+		}
+		if (cpumask_weight(cm) == 0)
+			goto all_cpus_idle;
+	}
+
 	/*
 	 * Each pass through the following loop attempts to force a
 	 * context switch on each CPU.
 	 */
-	while (try_stop_cpus(cpu_online_mask,
+	while (try_stop_cpus(cma ? cm : cpu_online_mask,
 			     synchronize_sched_expedited_cpu_stop,
 			     NULL) == -EAGAIN) {
 		put_online_cpus();
@@ -3000,6 +3018,7 @@ void synchronize_sched_expedited(void)
 			/* ensure test happens before caller kfree */
 			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_workdone1);
+			free_cpumask_var(cm);
 			return;
 		}
 
@@ -3009,6 +3028,7 @@ void synchronize_sched_expedited(void)
 		} else {
 			wait_rcu_gp(call_rcu_sched);
 			atomic_long_inc(&rsp->expedited_normal);
+			free_cpumask_var(cm);
 			return;
 		}
 
@@ -3018,6 +3038,7 @@ void synchronize_sched_expedited(void)
 			/* ensure test happens before caller kfree */
 			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_workdone2);
+			free_cpumask_var(cm);
 			return;
 		}
 
@@ -3032,6 +3053,7 @@ void synchronize_sched_expedited(void)
 			/* CPU hotplug operation in flight, use normal GP. */
 			wait_rcu_gp(call_rcu_sched);
 			atomic_long_inc(&rsp->expedited_normal);
+			free_cpumask_var(cm);
 			return;
 		}
 		snap = atomic_long_read(&rsp->expedited_start);
@@ -3039,6 +3061,9 @@ void synchronize_sched_expedited(void)
 	}
 	atomic_long_inc(&rsp->expedited_stoppedcpus);
 
+all_cpus_idle:
+	free_cpumask_var(cm);
+
 	/*
 	 * Everyone up to our most recent fetch is covered by our grace
 	 * period.  Update the counter, but only if our work is still
-- 
1.8.1.5

