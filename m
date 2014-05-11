Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbaEKXeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 19:34:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62532 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950AbaEKXeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 19:34:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5/5] nohz: Use IPI implicit full barrier against rq->nr_running r/w
Date: Mon, 12 May 2014 01:33:57 +0200
Message-Id: <1399851237-2226-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A full dynticks CPU is allowed to stop its tick when a single task runs.
Meanwhile when a new task gets enqueued, the CPU must be notified so that
it restart its tick to maintain local fairness and other accounting details.

This notification is performed by way of an IPI. Then when the target
receives the IPI, we expect it to see the new value of rq->nr_running.

Hence the following ordering scenario:

   CPU 0                   CPU 1

   write rq->running       get IPI
   smp_wmb()               smp_rmb()
   send IPI                read rq->nr_running

But Paul Mckenney says that nowadays IPIs imply a full barrier on
all architectures. So we can safely remove this pair and rely on the
implicit barriers that come along IPI send/receive. Lets
just comment on this new assumption.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c  |  9 +++++----
 kernel/sched/sched.h | 10 ++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 00ac248..0d78470 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -670,10 +670,11 @@ bool sched_can_stop_tick(void)
 
        rq = this_rq();
 
-       /* Make sure rq->nr_running update is visible after the IPI */
-       smp_rmb();
-
-       /* More than one running task need preemption */
+       /*
+	* More than one running task need preemption.
+	* nr_running update is assumed to be visible
+	* after IPI is sent from wakers.
+	*/
        if (rq->nr_running > 1)
                return false;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6089e00..219bfbd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1223,8 +1223,14 @@ static inline void inc_nr_running(struct rq *rq)
 #ifdef CONFIG_NO_HZ_FULL
 	if (rq->nr_running == 2) {
 		if (tick_nohz_full_cpu(rq->cpu)) {
-			/* Order rq->nr_running write against the IPI */
-			smp_wmb();
+			/*
+			 * Tick is needed if more than one task runs on a CPU.
+			 * Send the target an IPI to kick it out of nohz mode.
+			 *
+			 * We assume that IPI implies full memory barrier and the
+			 * new value of rq->nr_running is visible on reception
+			 * from the target.
+			 */
 			tick_nohz_full_kick_cpu(rq->cpu);
 		}
        }
-- 
1.8.3.1

