Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3LQWvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:51:52 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:42719 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab3LQWvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:51:45 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 07/13] sched: Enable IPI reception on timekeeper under nohz full system
Date: Tue, 17 Dec 2013 23:51:26 +0100
Message-Id: <1387320692-28460-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need the default timekeeping CPU to be able to receive IPIs sent
from full dynticks CPUs when they wake up from full system idle state.

Therefore we need an entrypoint from the scheduler IPI so that the
need to poll on timekeeping duty is re-evaluated from irq_exit().

In order to achieve this, lets take the scheduler IPI everytime as long
as there is at least one full dynticks CPU around. Full dynticks CPUs
are interested too in taking scheduler IPIs to reevaluate their tick.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
---
 kernel/sched/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e85cda2..f46a7bc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1502,9 +1502,9 @@ void scheduler_ipi(void)
 	if (tif_need_resched())
 		set_preempt_need_resched();
 
-	if (llist_empty(&this_rq()->wake_list)
-			&& !tick_nohz_full_cpu(smp_processor_id())
-			&& !got_nohz_idle_kick())
+	if (llist_empty(&this_rq()->wake_list) &&
+	    !tick_nohz_full_enabled() &&
+	    !got_nohz_idle_kick())
 		return;
 
 	/*
-- 
1.8.3.1

