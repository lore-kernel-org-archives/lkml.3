Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaG1RlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:41:00 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:58981 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaG1Rhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:37:48 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 02/10] nohz: Kick full dynticks timer targets with an empty IPI
Date: Mon, 28 Jul 2014 19:37:28 +0200
Message-Id: <1406569056-30217-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we enqueue a new timer on a dynticks target, we must send it an
IPI so that it reschedules the next tick accordingly.

Now all we need for that is to run irq_exit() on the target. Hence
an empty IRQ is way enough. We don't need to run tick_nohz_full_check()
and all the overhead that comes with the several cmpxchg() necessary for
irq work list and state progress.

So lets use a void irq work instead.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f3063c..171f9ce 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -685,15 +685,13 @@ static void wake_up_idle_cpu(int cpu)
 static bool wake_up_full_nohz_cpu(int cpu)
 {
 	/*
-	 * We just need the target to call irq_exit() and re-evaluate
-	 * the next tick. The nohz full kick at least implies that.
-	 * If needed we can still optimize that later with an
-	 * empty IRQ.
+	 * Kick the target to make it call irq_exit() and re-evaluate
+	 * the next tick.
 	 */
 	if (tick_nohz_full_cpu(cpu)) {
 		if (cpu != smp_processor_id() ||
 		    tick_nohz_tick_stopped())
-			tick_nohz_full_kick_cpu(cpu);
+			kick_cpu_async(cpu);
 		return true;
 	}
 
-- 
1.8.3.1

