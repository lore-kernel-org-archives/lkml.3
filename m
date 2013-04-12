Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab3DLXU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:20:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48052 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab3DLXTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:19:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/7] rcu: Kick adaptive-ticks CPUs that are holding up RCU grace periods
Date: Fri, 12 Apr 2013 16:19:10 -0700
Message-Id: <1365808754-20762-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041223-7182-0000-0000-000006380AC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Adaptive-ticks CPUs inform RCU when they enter kernel mode, but they do
not necessarily turn the scheduler-clock tick back on.  This state of
affairs could result in RCU waiting on an adaptive-ticks CPU running
for an extended period in kernel mode.  Such a CPU will never run the
RCU state machine, and could therefore indefinitely extend the RCU state
machine, sooner or later resulting in an OOM condition.

This patch, inspired by an earlier patch by Frederic Weisbecker, therefore
causes RCU's force-quiescent-state processing to check for this condition
and to send an IPI to CPUs that remain in that state for too long.
"Too long" currently means about three jiffies by default, which is
quite some time for a CPU to remain in the kernel without blocking.
The rcu_tree.jiffies_till_first_fqs and rcutree.jiffies_till_next_fqs
sysfs variables may be used to tune "too long" if needed.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        | 10 ++++++++++
 kernel/rcutree.h        |  1 +
 kernel/rcutree_plugin.h | 17 +++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index bc3eac5..3710d74 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -799,6 +799,16 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 		rdp->offline_fqs++;
 		return 1;
 	}
+
+	/*
+	 * There is a possibility that a CPU in adaptive-ticks state
+	 * might run in the kernel with the scheduling-clock tick disabled
+	 * for an extended time period.  Invoke rcu_kick_nohz_cpu() to
+	 * force the CPU to restart the scheduling-clock tick in this
+	 * CPU is in this state.
+	 */
+	rcu_kick_nohz_cpu(rdp->cpu);
+
 	return 0;
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 14ee407..08972c9 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -538,6 +538,7 @@ static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
+static void rcu_kick_nohz_cpu(int cpu);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e6cf7e5..ca6e39c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2336,3 +2336,20 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
 }
 
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
+
+/*
+ * An adaptive-ticks CPU can potentially execute in kernel mode for an
+ * arbitrarily long period of time with the scheduling-clock tick turned
+ * off.  RCU will be paying attention to this CPU because it is in the
+ * kernel, but the CPU cannot be guaranteed to be executing the RCU state
+ * machine because the scheduling-clock tick has been disabled.  Therefore,
+ * if an adaptive-ticks CPU is failing to respond to the current grace
+ * period and has not be idle from an RCU perspective, kick it.
+ */
+static void rcu_kick_nohz_cpu(int cpu)
+{
+#ifdef CONFIG_NO_HZ_EXTENDED
+	if (tick_nohz_full_cpu(cpu))
+		smp_send_reschedule(cpu);
+#endif /* #ifdef CONFIG_NO_HZ_EXTENDED */
+}
-- 
1.8.1.5

