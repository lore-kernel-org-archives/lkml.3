Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaBKPLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:11:53 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52255 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaBKPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:11:44 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] idle: Add more comments to the code
Date: Tue, 11 Feb 2014 16:11:31 +0100
Message-Id: <1392131491-5265-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org>
References: <1392131491-5265-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle main function is a complex and a critical function. Added more
comments to the code.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/idle.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 72b5926..36ff1a7 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -86,19 +86,34 @@ static int cpuidle_idle_call(void)
 	if (cpu_idle_force_poll || tick_check_broadcast_expired())
 		return cpu_idle_poll();
 
+	/*
+	 * Check if the idle task must rescheduled. If it is the case,
+	 * exit the function after re-enabling the local irq and set
+	 * again the polling flag
+	 */
 	if (current_clr_polling_and_test()) {
 		local_irq_enable();
 		__current_set_polling();
 		return 0;
 	}
 
+	/*
+	 * During the idle period, stop measuring the disabled irqs
+	 * critical sections latencies
+	 */
 	stop_critical_timings();
+
+	/*
+	 * Tell the RCU framework we are entering an idle section,
+	 * so no more rcu read side critical sections and one more
+	 * step to the grace period
+	 */
 	rcu_idle_enter();
 
-	/* Ask the governor for the next state, this call can fail for
-	 * different reasons: cpuidle is not enabled or an idle state
-	 * fulfilling the constraints was not found. In this case, we fall
-	 * back to the default idle function
+	/*
+	 * Ask the governor to choose an idle state it thinks it is
+	 * convenient to go to. There is *always* a convenient idle
+	 * state but the call could fail if cpuidle is not enabled
 	 */
 	next_state = cpuidle_select(drv, dev);
 	if (next_state < 0) {
@@ -106,6 +121,10 @@ static int cpuidle_idle_call(void)
 		goto out;
 	}
 
+	/*
+	 * The idle task must be scheduled, it is pointless to go to idle,
+	 * just update no idle residency and get out of this function
+	 */
 	if (need_resched()) {
 		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
@@ -116,6 +135,12 @@ static int cpuidle_idle_call(void)
 
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
+	/*
+	 * Enter the idle state previously returned by the governor
+	 * decision. This function will block until an interrupt
+	 * occurs and will take care of re-enabling the local
+	 * interrupts
+	 */
 	entered_state = cpuidle_enter(drv, dev, next_state);
 
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
@@ -152,6 +177,10 @@ static void cpu_idle_loop(void)
 			local_irq_disable();
 			arch_cpu_idle_enter();
 
+			/*
+			 * It is up to the underlying functions to
+			 * enable the local interrupts again
+			 */
 			cpuidle_idle_call();
 
 			arch_cpu_idle_exit();
-- 
1.7.9.5

