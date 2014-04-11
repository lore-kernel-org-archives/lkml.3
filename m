Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433AbaDKN7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:59:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39762 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbaDKNzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:55:52 -0400
Message-Id: <20140411135218.546673774@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Apr 2014 15:42:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 7/8] sched,idle: Delay clearing the polling bit
References: <20140411134243.160989490@infradead.org>
Content-Disposition: inline; filename=sched-idle-polling-fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the generic idle functions assuming !polling we should only clear
the polling bit at the very last opportunity in order to avoid
spurious IPIs.

Ideally we'd flip the default to polling, but that means auditing all
arch idle functions.

Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/idle.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -78,12 +78,10 @@ static int cpuidle_idle_call(void)
 
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
-	 * case, exit the function after re-enabling the local irq and
-	 * set again the polling flag
+	 * case, exit the function after re-enabling the local irq.
 	 */
-	if (current_clr_polling_and_test()) {
+	if (need_resched()) {
 		local_irq_enable();
-		__current_set_polling();
 		return 0;
 	}
 
@@ -127,7 +125,7 @@ static int cpuidle_idle_call(void)
 			broadcast = !!(drv->states[next_state].flags &
 				       CPUIDLE_FLAG_TIMER_STOP);
 
-			if (broadcast)
+			if (broadcast) {
 				/*
 				 * Tell the time framework to switch
 				 * to a broadcast timer because our
@@ -139,6 +137,7 @@ static int cpuidle_idle_call(void)
 				ret = clockevents_notify(
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
 					&dev->cpu);
+			}
 
 			if (!ret) {
 				trace_cpu_idle_rcuidle(next_state, dev->cpu);
@@ -175,8 +174,12 @@ static int cpuidle_idle_call(void)
 	 * We can't use the cpuidle framework, let's use the default
 	 * idle routine
 	 */
-	if (ret)
-		arch_cpu_idle();
+	if (ret) {
+		if (!current_clr_polling_and_test())
+			arch_cpu_idle();
+		else
+			local_irq_enable();
+	}
 
 	__current_set_polling();
 


