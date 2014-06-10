Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaFJPQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:16:17 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:32950 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaFJPPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:15:30 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/6] nohz: Switch to nohz full remote kick on timer enqueue
Date: Tue, 10 Jun 2014 17:15:07 +0200
Message-Id: <1402413309-3415-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new timer is enqueued on a full dynticks target, that CPU must
re-evaluate the next tick to handle the timer correctly.

This is currently performed through the scheduler IPI. Meanwhile this
happens at the cost of off-topic workarounds in that fast path to make
it call irq_exit().

As we plan to remove this hack off the scheduler IPI, lets use
the nohz full kick instead. Pretty much any IPI fits for that job
as long at it calls irq_exit(). The nohz full kick just happens to be
handy and readily available here.

If it happens to be too much an overkill in the future, we can still
turn that timer kick into an empty IPI.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d9d8ece..03dc7e9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -620,10 +620,16 @@ static void wake_up_idle_cpu(int cpu)
 
 static bool wake_up_full_nohz_cpu(int cpu)
 {
+	/*
+	 * We just need the target to call irq_exit() and re-evaluate
+	 * the next tick. The nohz full kick at least implies that.
+	 * If needed we can still optimize that later with an
+	 * empty IRQ.
+	 */
 	if (tick_nohz_full_cpu(cpu)) {
 		if (cpu != smp_processor_id() ||
 		    tick_nohz_tick_stopped())
-			smp_send_reschedule(cpu);
+			tick_nohz_full_kick_cpu(cpu);
 		return true;
 	}
 
-- 
1.8.3.1

