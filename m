Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaCKMiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:38:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaCKMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:38:14 -0400
Date: Tue, 11 Mar 2014 05:37:45 -0700
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-8ca3c6424f4988fc19ed1067b121fbaf2e884d77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1393832934-11625-4-git-send-email-daniel.lezcano@linaro.org>
References: <1393832934-11625-4-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/idle] sched/idle:
  Move idle conditions in cpuidle_idle main function
Git-Commit-ID: 8ca3c6424f4988fc19ed1067b121fbaf2e884d77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ca3c6424f4988fc19ed1067b121fbaf2e884d77
Gitweb:     http://git.kernel.org/tip/8ca3c6424f4988fc19ed1067b121fbaf2e884d77
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 3 Mar 2014 08:48:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:52:48 +0100

sched/idle: Move idle conditions in cpuidle_idle main function

This patch moves the condition before entering idle into the cpuidle main
function located in idle.c. That simplify the idle mainloop functions and
increase the readibility of the conditions to enter truly idle.

This patch is code reorganization and does not change the behavior of the
function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: tglx@linutronix.de
Cc: rjw@rjwysocki.net
Cc: nicolas.pitre@linaro.org
Cc: preeti@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1393832934-11625-4-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/idle.c | 78 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 34 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index dc8a246..cc7a6f3 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -76,44 +76,59 @@ static int cpuidle_idle_call(void)
 	int next_state, entered_state, ret;
 	bool broadcast;
 
+	if (current_clr_polling_and_test()) {
+		local_irq_enable();
+		__current_set_polling();
+		return 0;
+	}
+
 	stop_critical_timings();
 	rcu_idle_enter();
 
 	ret = cpuidle_enabled(drv, dev);
-	if (ret < 0) {
-		arch_cpu_idle();
-		goto out;
-	}
 
-	/* ask the governor for the next state */
-	next_state = cpuidle_select(drv, dev);
+	if (!ret) {
+		/* ask the governor for the next state */
+		next_state = cpuidle_select(drv, dev);
 
-	if (need_resched()) {
-		dev->last_residency = 0;
-		/* give the governor an opportunity to reflect on the outcome */
-		cpuidle_reflect(dev, next_state);
-		local_irq_enable();
-		goto out;
-	}
+		if (current_clr_polling_and_test()) {
+			dev->last_residency = 0;
+			entered_state = next_state;
+			local_irq_enable();
+		} else {
+			broadcast = !!(drv->states[next_state].flags &
+				       CPUIDLE_FLAG_TIMER_STOP);
+
+			if (broadcast)
+				ret = clockevents_notify(
+					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
+					&dev->cpu);
 
-	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
+			if (!ret) {
+				trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
-	if (broadcast &&
-	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
-		return -EBUSY;
+				entered_state = cpuidle_enter(drv, dev,
+							      next_state);
 
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
+				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
+						       dev->cpu);
 
-	entered_state = cpuidle_enter(drv, dev, next_state);
+				if (broadcast)
+					clockevents_notify(
+						CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
+						&dev->cpu);
 
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+				/* give the governor an opportunity to reflect on the outcome */
+				cpuidle_reflect(dev, entered_state);
+			}
+		}
+	}
+
+	if (ret)
+		arch_cpu_idle();
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+	__current_set_polling();
 
-	/* give the governor an opportunity to reflect on the outcome */
-	cpuidle_reflect(dev, entered_state);
-out:
 	if (WARN_ON_ONCE(irqs_disabled()))
 		local_irq_enable();
 
@@ -150,16 +165,11 @@ static void cpu_idle_loop(void)
 			 * know that the IPI is going to arrive right
 			 * away
 			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
+			if (cpu_idle_force_poll || tick_check_broadcast_expired())
 				cpu_idle_poll();
-			} else {
-				if (!current_clr_polling_and_test()) {
-					cpuidle_idle_call();
-				} else {
-					local_irq_enable();
-				}
-				__current_set_polling();
-			}
+			else
+				cpuidle_idle_call();
+
 			arch_cpu_idle_exit();
 		}
 
