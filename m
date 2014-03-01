Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaCAD5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 22:57:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:11451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752843AbaCADwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 22:52:38 -0500
Message-Id: <20140301035235.949219502@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 28 Feb 2014 22:52:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>, Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RT 01/14] rcu: Dont activate RCU core on NO_HZ_FULL CPUs
References: <20140301035209.031474616@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-rcu-Don-t-activate-RCU-core-on-NO_HZ_FULL-CPUs.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.32-rt31-rc2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Whenever a CPU receives a scheduling-clock interrupt, RCU checks to see
if the RCU core needs anything from this CPU.  If so, RCU raises
RCU_SOFTIRQ to carry out any needed processing.

This approach has worked well historically, but it is undesirable on
NO_HZ_FULL CPUs.  Such CPUs are expected to spend almost all of their time
in userspace, so that scheduling-clock interrupts can be disabled while
there is only one runnable task on the CPU in question.  Unfortunately,
raising any softirq has the potential to wake up ksoftirqd, which would
provide the second runnable task on that CPU, preventing disabling of
scheduling-clock interrupts.

What is needed instead is for RCU to leave NO_HZ_FULL CPUs alone,
relying on the grace-period kthreads' quiescent-state forcing to
do any needed RCU work on behalf of those CPUs.

This commit therefore refrains from raising RCU_SOFTIRQ on any
NO_HZ_FULL CPUs during any grace periods that have been in effect
for less than one second.  The one-second limit handles the case
where an inappropriate workload is running on a NO_HZ_FULL CPU
that features lots of scheduling-clock interrupts, but no idle
or userspace time.

Cc: stable-rt@vger.kernel.org
Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Mike Galbraith <bitbucket@online.de>
Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c        |  4 ++++
 kernel/rcutree.h        |  1 +
 kernel/rcutree_plugin.h | 20 ++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 55915b1..75743cb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2749,6 +2749,10 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rsp, rdp);
 
+	/* Is this CPU a NO_HZ_FULL CPU that should ignore RCU? */
+	if (rcu_nohz_full_cpu(rsp))
+		return 0;
+
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
 	    rdp->qs_pending && !rdp->passed_quiesce) {
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 8491f47..7e0b397 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -541,6 +541,7 @@ static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static void rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index dc0c4b2..481a124 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2356,3 +2356,23 @@ static void rcu_kick_nohz_cpu(int cpu)
 		smp_send_reschedule(cpu);
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
+
+/*
+ * Is this CPU a NO_HZ_FULL CPU that should ignore RCU so that the
+ * grace-period kthread will do force_quiescent_state() processing?
+ * The idea is to avoid waking up RCU core processing on such a
+ * CPU unless the grace period has extended for too long.
+ *
+ * This code relies on the fact that all NO_HZ_FULL CPUs are also
+ * CONFIG_RCU_NOCB_CPUs.
+ */
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(smp_processor_id()) &&
+	    (!rcu_gp_in_progress(rsp) ||
+	     ULONG_CMP_LT(jiffies, ACCESS_ONCE(rsp->gp_start) + HZ)))
+		return 1;
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+	return 0;
+}
-- 
1.8.5.3


