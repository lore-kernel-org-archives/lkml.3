Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaDXMYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:24:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47759 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbaDXMY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:24:27 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, linaro-kernel@lists.linaro.org
Subject: [PATCH 1/3] sched: idle: Encapsulate the code to compile it out
Date: Thu, 24 Apr 2014 14:24:49 +0200
Message-Id: <1398342291-16322-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encapsulate the large portion of cpuidle_idle_call inside another
function so when CONFIG_CPU_IDLE=n, the code will be compiled out.
Also that is benefitial for the clarity of the code as it removes
a nested indentation level.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/idle.c |  161 +++++++++++++++++++++++++++------------------------
 1 file changed, 86 insertions(+), 75 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 8f4390a..e877dd4 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -63,6 +63,90 @@ void __weak arch_cpu_idle(void)
 	local_irq_enable();
 }
 
+#ifdef CONFIG_CPU_IDLE
+static int __cpuidle_idle_call(void)
+{
+	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
+	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	int next_state, entered_state, ret;
+	bool broadcast;
+
+	/*
+	 * Check if the cpuidle framework is ready, otherwise fallback
+	 * to the default arch specific idle method
+	 */
+	ret = cpuidle_enabled(drv, dev);
+	if (ret)
+		return ret;
+
+	/*
+	 * Ask the governor to choose an idle state it thinks
+	 * it is convenient to go to. There is *always* a
+	 * convenient idle state
+	 */
+	next_state = cpuidle_select(drv, dev);
+
+	/*
+	 * The idle task must be scheduled, it is pointless to
+	 * go to idle, just update no idle residency and get
+	 * out of this function
+	 */
+	if (current_clr_polling_and_test()) {
+		dev->last_residency = 0;
+		entered_state = next_state;
+		local_irq_enable();
+	} else {
+		broadcast = !!(drv->states[next_state].flags &
+			       CPUIDLE_FLAG_TIMER_STOP);
+
+		if (broadcast)
+			/*
+			 * Tell the time framework to switch to a
+			 * broadcast timer because our local timer
+			 * will be shutdown. If a local timer is used
+			 * from another cpu as a broadcast timer, this
+			 * call may fail if it is not available
+			 */
+			ret = clockevents_notify(
+				CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
+				&dev->cpu);
+
+		if (!ret) {
+			trace_cpu_idle_rcuidle(next_state, dev->cpu);
+
+			/*
+			 * Enter the idle state previously returned by
+			 * the governor decision. This function will
+			 * block until an interrupt occurs and will
+			 * take care of re-enabling the local
+			 * interrupts
+			 */
+			entered_state = cpuidle_enter(drv, dev, next_state);
+
+			trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+
+			if (broadcast)
+				clockevents_notify(
+					CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
+					&dev->cpu);
+
+			/*
+			 * Give the governor an opportunity to reflect
+			 * on the outcome
+			 */
+			cpuidle_reflect(dev, entered_state);
+		}
+	}
+
+	return 0;
+}
+#else
+static int inline __cpuidle_idle_call(void)
+{
+	return -ENOSYS;
+}
+#endif
+
 /**
  * cpuidle_idle_call - the main idle function
  *
@@ -71,10 +155,7 @@ void __weak arch_cpu_idle(void)
  */
 static int cpuidle_idle_call(void)
 {
-	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
-	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
-	int next_state, entered_state, ret;
-	bool broadcast;
+	int ret;
 
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
@@ -101,80 +182,10 @@ static int cpuidle_idle_call(void)
 	rcu_idle_enter();
 
 	/*
-	 * Check if the cpuidle framework is ready, otherwise fallback
-	 * to the default arch specific idle method
-	 */
-	ret = cpuidle_enabled(drv, dev);
-
-	if (!ret) {
-		/*
-		 * Ask the governor to choose an idle state it thinks
-		 * it is convenient to go to. There is *always* a
-		 * convenient idle state
-		 */
-		next_state = cpuidle_select(drv, dev);
-
-		/*
-		 * The idle task must be scheduled, it is pointless to
-		 * go to idle, just update no idle residency and get
-		 * out of this function
-		 */
-		if (current_clr_polling_and_test()) {
-			dev->last_residency = 0;
-			entered_state = next_state;
-			local_irq_enable();
-		} else {
-			broadcast = !!(drv->states[next_state].flags &
-				       CPUIDLE_FLAG_TIMER_STOP);
-
-			if (broadcast)
-				/*
-				 * Tell the time framework to switch
-				 * to a broadcast timer because our
-				 * local timer will be shutdown. If a
-				 * local timer is used from another
-				 * cpu as a broadcast timer, this call
-				 * may fail if it is not available
-				 */
-				ret = clockevents_notify(
-					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
-					&dev->cpu);
-
-			if (!ret) {
-				trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
-				/*
-				 * Enter the idle state previously
-				 * returned by the governor
-				 * decision. This function will block
-				 * until an interrupt occurs and will
-				 * take care of re-enabling the local
-				 * interrupts
-				 */
-				entered_state = cpuidle_enter(drv, dev,
-							      next_state);
-
-				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
-						       dev->cpu);
-
-				if (broadcast)
-					clockevents_notify(
-						CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
-						&dev->cpu);
-
-				/*
-				 * Give the governor an opportunity to reflect on the
-				 * outcome
-				 */
-				cpuidle_reflect(dev, entered_state);
-			}
-		}
-	}
-
-	/*
 	 * We can't use the cpuidle framework, let's use the default
 	 * idle routine
 	 */
+	ret = __cpuidle_idle_call();
 	if (ret)
 		arch_cpu_idle();
 
-- 
1.7.9.5

