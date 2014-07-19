Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbaGSAoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:44:44 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42751 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaGSAob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:44:31 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 02/10] nohz: Kick full dynticks timer targets with an empty IPI
Date: Sat, 19 Jul 2014 02:44:13 +0200
Message-Id: <1405730661-9355-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
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
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f3063c..f3e48b8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -693,7 +693,7 @@ static bool wake_up_full_nohz_cpu(int cpu)
 	if (tick_nohz_full_cpu(cpu)) {
 		if (cpu != smp_processor_id() ||
 		    tick_nohz_tick_stopped())
-			tick_nohz_full_kick_cpu(cpu);
+			irq_work_void_on(cpu);
 		return true;
 	}
 
-- 
1.8.3.1

