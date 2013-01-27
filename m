Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3A0FSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 00:18:32 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59748 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3A0FQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 00:16:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/12] rcu: Distinguish "rcuo" kthreads by RCU flavor
Date: Sat, 26 Jan 2013 16:29:54 -0800
Message-Id: <1359246603-6863-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1359246603-6863-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130127002943.GA6067@linux.vnet.ibm.com>
 <1359246603-6863-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012705-3620-0000-0000-000001011216
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, the per-no-CBs-CPU kthreads are named "rcuo" followed by
the CPU number, for example, "rcuo".  This is problematic given that
there are either two or three RCU flavors, each of which gets a per-CPU
kthread with exactly the same name.  This commit therefore introduces
a one-letter abbreviation for each RCU flavor, namely 'b' for RCU-bh,
'p' for RCU-preempt, and 's' for RCU-sched.  This abbreviation use used
to distinguish the "rcuo" kthreads, for example, for CPU 0 we would have
"rcuo0b", "rcuo0p", and "rcuo0s".

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 Documentation/kernel-parameters.txt |    7 +++++--
 init/Kconfig                        |   13 +++++++------
 kernel/rcutree.c                    |    7 ++++---
 kernel/rcutree.h                    |    1 +
 kernel/rcutree_plugin.h             |    5 +++--
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6c72381..c2c3abf 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2432,9 +2432,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
 			the specified list of CPUs to be no-callback CPUs.
 			Invocation of these CPUs' RCU callbacks will
-			be offloaded to "rcuoN" kthreads created for
-			that purpose.  This reduces OS jitter on the
+			be offloaded to "rcuox/N" kthreads created for
+			that purpose, where "x" is "b" for RCU-bh, "p"
+			for RCU-preempt, and "s" for RCU-sched, and "N"
+			is the CPU number.  This reduces OS jitter on the
 			offloaded CPUs, which can be useful for HPC and
+
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
diff --git a/init/Kconfig b/init/Kconfig
index 9a04156..82f4e3c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -676,12 +676,13 @@ config RCU_NOCB_CPU
 
 	  This option offloads callback invocation from the set of
 	  CPUs specified at boot time by the rcu_nocbs parameter.
-	  For each such CPU, a kthread ("rcuoN") will be created to
-	  invoke callbacks, where the "N" is the CPU being offloaded.
-	  Nothing prevents this kthread from running on the specified
-	  CPUs, but (1) the kthreads may be preempted between each
-	  callback, and (2) affinity or cgroups can be used to force
-	  the kthreads to run on whatever set of CPUs is desired.
+	  For each such CPU, a kthread ("rcuox/N") will be created to
+	  invoke callbacks, where the "N" is the CPU being offloaded,
+	  and where the "x" is "b" for RCU-bh, "p" for RCU-preempt, and
+	  "s" for RCU-sched.  Nothing prevents this kthread from running
+	  on the specified CPUs, but (1) the kthreads may be preempted
+	  between each callback, and (2) affinity or cgroups can be used
+	  to force the kthreads to run on whatever set of CPUs is desired.
 
 	  Say Y here if you want to help to debug reduced OS jitter.
 	  Say N here if you are unsure.
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 433f426..074cb2d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -64,7 +64,7 @@
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 
-#define RCU_STATE_INITIALIZER(sname, cr) { \
+#define RCU_STATE_INITIALIZER(sname, sabbr, cr) { \
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
 	.fqs_state = RCU_GP_IDLE, \
@@ -76,13 +76,14 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
 	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
 	.name = #sname, \
+	.abbr = sabbr, \
 }
 
 struct rcu_state rcu_sched_state =
-	RCU_STATE_INITIALIZER(rcu_sched, call_rcu_sched);
+	RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
 DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 
-struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, call_rcu_bh);
+struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 static struct rcu_state *rcu_state;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e51373c..b6c2335 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -443,6 +443,7 @@ struct rcu_state {
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
 	char *name;				/* Name of structure. */
+	char abbr;				/* Abbreviated name. */
 	struct list_head flavors;		/* List of RCU flavors. */
 };
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e32236e..c016444 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -111,7 +111,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 struct rcu_state rcu_preempt_state =
-	RCU_STATE_INITIALIZER(rcu_preempt, call_rcu);
+	RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
@@ -2517,7 +2517,8 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 		return;
 	for_each_cpu(cpu, rcu_nocb_mask) {
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		t = kthread_run(rcu_nocb_kthread, rdp, "rcuo%d", cpu);
+		t = kthread_run(rcu_nocb_kthread, rdp,
+				"rcuo%c/%d", rsp->abbr, cpu);
 		BUG_ON(IS_ERR(t));
 		ACCESS_ONCE(rdp->nocb_kthread) = t;
 	}
-- 
1.7.8

