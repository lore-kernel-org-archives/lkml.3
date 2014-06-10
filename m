Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbaFJPPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:15:34 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44501 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaFJPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:15:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5/6] nohz: Use nohz own full kick on 2nd task enqueue
Date: Tue, 10 Jun 2014 17:15:08 +0200
Message-Id: <1402413309-3415-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a nohz full remote kick based on irq work, lets use
it to notify a CPU that it's exiting single task mode.

This unbloats a bit the scheduler IPI that the nohz code was abusing
for its cool "callable anywhere/anytime" properties.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c  | 5 +----
 kernel/sched/sched.h | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 03dc7e9..5d25274 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1506,9 +1506,7 @@ void scheduler_ipi(void)
 	 */
 	preempt_fold_need_resched();
 
-	if (llist_empty(&this_rq()->wake_list)
-			&& !tick_nohz_full_cpu(smp_processor_id())
-			&& !got_nohz_idle_kick())
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
 		return;
 
 	/*
@@ -1525,7 +1523,6 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
-	tick_nohz_full_check();
 	sched_ttwu_pending();
 
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 456e492..6089e00 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1225,7 +1225,7 @@ static inline void inc_nr_running(struct rq *rq)
 		if (tick_nohz_full_cpu(rq->cpu)) {
 			/* Order rq->nr_running write against the IPI */
 			smp_wmb();
-			smp_send_reschedule(rq->cpu);
+			tick_nohz_full_kick_cpu(rq->cpu);
 		}
        }
 #endif
-- 
1.8.3.1

