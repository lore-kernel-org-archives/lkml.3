Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3CRVkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:40:55 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44965 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab3CRVhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:37:02 -0400
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
Subject: [PATCH tip/core/rcu 06/15] rcu: Distinguish "rcuo" kthreads by RCU flavor
Date: Mon, 18 Mar 2013 14:36:41 -0700
Message-Id: <1363642610-21390-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318213608.GA20296@linux.vnet.ibm.com>
 <1363642610-21390-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-3620-0000-0000-000001AC9323
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, the per-no-CBs-CPU kthreads are named "rcuo" followed by
the CPU number, for example, "rcuo".  This is problematic given that
there are either two or three RCU flavors, each of which gets a per-CPU
kthread with exactly the same name.  This commit therefore introduces
a one-letter abbreviation for each RCU flavor, namely 'b' for RCU-bh,
'p' for RCU-preempt, and 's' for RCU-sched.  This abbreviation is used
to distinguish the "rcuo" kthreads, for example, for CPU 0 we would have
"rcuob/0", "rcuop/0", and "rcuos/0".

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 Documentation/kernel-parameters.txt |  7 +++++--
 init/Kconfig                        | 13 +++++++------
 kernel/rcutree.c                    |  7 ++++---
 kernel/rcutree.h                    |  1 +
 kernel/rcutree_plugin.h             |  5 +++--
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..a17ba16 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2461,9 +2461,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index 5e9e617..2849d55 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -666,12 +666,13 @@ config RCU_NOCB_CPU
 
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
1.8.1.5

