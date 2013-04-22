Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3DVTBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 15:01:53 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:45237 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3DVTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 15:00:05 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 05/10] sched: New helper to prevent from stopping the tick in full dynticks
Date: Mon, 22 Apr 2013 20:59:41 +0200
Message-Id: <1366657186-20556-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
References: <1366657186-20556-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a new helper to be called from the full dynticks engine
before stopping the tick in order to make sure we don't stop
it when there is more than one task running on the CPU.

This way we make sure that the tick stays alive to maintain
fairness.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    6 ++++++
 kernel/sched/core.c   |   18 ++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1ff9e0a..a74aded 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1856,6 +1856,12 @@ extern void wake_up_nohz_cpu(int cpu);
 static inline void wake_up_nohz_cpu(int cpu) { }
 #endif
 
+#ifdef CONFIG_NO_HZ_FULL
+extern bool sched_can_stop_tick(void);
+#else
+static inline bool sched_can_stop_tick(void) { return false; }
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0f0a5b3..69f7133 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -650,6 +650,24 @@ static inline bool got_nohz_idle_kick(void)
 
 #endif /* CONFIG_NO_HZ_COMMON */
 
+#ifdef CONFIG_NO_HZ_FULL
+bool sched_can_stop_tick(void)
+{
+       struct rq *rq;
+
+       rq = this_rq();
+
+       /* Make sure rq->nr_running update is visible after the IPI */
+       smp_rmb();
+
+       /* More than one running task need preemption */
+       if (rq->nr_running > 1)
+               return false;
+
+       return true;
+}
+#endif /* CONFIG_NO_HZ_FULL */
+
 void sched_avg_update(struct rq *rq)
 {
 	s64 period = sched_avg_period();
-- 
1.7.5.4

