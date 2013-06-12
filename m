Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3FLOC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:02:56 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59153 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3FLOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:02:53 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 5/6] rcu: Prevent CPU from stopping tick if awaited for quiescent state report
Date: Wed, 12 Jun 2013 16:02:37 +0200
Message-Id: <1371045758-5296-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU runs in full dynticks mode in the kernel, it is outside
the RCU user mode. If another CPU has started a grace period and is
waiting for this CPU to report a quiescent state, the lack of a tick
may extend the grace period. This is typically not a problem because
the kernel code is supposed to quickly resume to either:

* userspace, in this case we'll enter into RCU user mode and thus
get rid of our quiescent state report duty.

* schedule to idle, which involve the same as the userspace case

* schedule another task, but then this implies we have more than
one task in the runqueue and we kept the tick for the scheduler
to correctly handle the multitasking.

Now it's always good to consider a worst case which here could be
that the CPU eventually stays in the kernel longer than expected
and can then extend a grace period longer than we can afford.

Restarting the tick can be a good idea in this case:

* this way we can report we are outside a softirq if an RCU_bh qs
is pending.

* we can kick the rcu softirq if we need to report a RCU_sched bh, as
that involve a context switch.

RCU already sends an IPI to kick such annoying full dynticks CPUs.
Now this patch implements the other side: restart the tick from the
IPI if we need to report a quiescent state.

NOTE: we can probably do better and rather act from the IPI without
restarting the tick.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcupdate.h |    3 +++
 kernel/rcutree_plugin.h  |   43 +++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c |    5 +++++
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 4ccd68e..6e3c5cf 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1006,5 +1006,8 @@ extern bool rcu_is_nocb_cpu(int cpu);
 static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
 
+#ifdef CONFIG_NO_HZ_FULL
+extern bool rcu_can_stop_tick(void);
+#endif
 
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3db5a37..391386f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2350,3 +2350,46 @@ static void rcu_kick_nohz_cpu(int cpu)
 		smp_send_reschedule(cpu);
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
+
+#ifdef CONFIG_NO_HZ_FULL
+/*
+ * This pairs with rcu_kick_nohz_cpu. It is called from the
+ * irq exit path to check if the CPU needs to restart its tick
+ * to report a quiescent state after extending the grace period
+ * for too long.
+ */
+bool rcu_can_stop_tick(void)
+{
+	struct rcu_state *rsp;
+	struct rcu_data *rdp;
+
+	WARN_ON_ONCE(!irqs_disabled());
+
+	/* We are already in extended quiescent state */
+	if (rcu_is_cpu_idle())
+		return true;
+
+	/*
+	 * Note there is no guarantee that we'll see the new grace period
+	 * that the IPI sender wants us to see in the RCU global state. Some
+	 * ordering against the IPI send/receive and rsp->gpnum is probably
+	 * required to enforce that.
+	 *
+	 * Besides, note_new_gp_num() might ignore the new grace period if
+	 * the rnp lock is contended.
+	 *
+	 * Either we need to resend the ipi periodically if no progress is made
+	 * or we need to fix these ordering/locking issues for this code to be
+	 * correct.
+	 */
+	for_each_rcu_flavor(rsp) {
+		 rdp = this_cpu_ptr(rsp->rda);
+		 check_for_new_grace_period(rsp, rdp);
+
+		 if (rdp->qs_pending && !rdp->passed_quiesce)
+			 return false;
+	}
+
+	return true;
+}
+#endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index dbb8f76..917b871 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -170,6 +170,11 @@ static bool can_stop_full_tick(void)
 		return false;
 	}
 
+	if (!rcu_can_stop_tick()) {
+		trace_tick_stop(0, "RCU needs tick\n");
+		return false;
+	}
+
 	/* sched_clock_tick() needs us? */
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 	/*
-- 
1.7.5.4

