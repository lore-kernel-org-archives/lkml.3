Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab3DOVKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:10:40 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62917 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628Ab3DOVKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:10:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/5] rcu: Kick adaptive-ticks CPUs that are holding up RCU grace periods
Date: Mon, 15 Apr 2013 23:10:20 +0200
Message-Id: <1366060220-20271-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
References: <1366060220-20271-1-git-send-email-fweisbec@gmail.com>
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
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rcutree.c        |   10 ++++++++++
 kernel/rcutree.h        |    1 +
 kernel/rcutree_plugin.h |   18 ++++++++++++++++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b8ad82..f5ab502 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -794,6 +794,16 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
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
index c896b50..f993c0a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -539,6 +539,7 @@ static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static void init_nocb_callback_list(struct rcu_data *rdp);
 static void __init rcu_init_nocb(void);
+static void rcu_kick_nohz_cpu(int cpu);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c1cc7e1..a5745e9 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -28,6 +28,7 @@
 #include <linux/gfp.h>
 #include <linux/oom.h>
 #include <linux/smpboot.h>
+#include <linux/tick.h>
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -2502,3 +2503,20 @@ static void __init rcu_init_nocb(void)
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
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(cpu))
+		smp_send_reschedule(cpu);
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+}
-- 
1.7.5.4

