Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaC1M37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:29:59 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40330 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaC1M34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:29:56 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Cc: rjw@rjwysocki.net, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC PATCHC 2/3] idle: store the idle state the cpu is
Date: Fri, 28 Mar 2014 13:29:55 +0100
Message-Id: <1396009796-31598-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the cpu enters idle it stores the cpuidle power info in the struct
rq which in turn could be used to take a right decision when balancing
a task.

As soon as the cpu exits the idle state, the structure is filled with the
NULL pointer.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/idle.c  |   17 +++++++++++++++--
 kernel/sched/sched.h |    5 +++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 8f4390a..5c32c11 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -12,6 +12,8 @@
 
 #include <trace/events/power.h>
 
+#include "sched.h"
+
 static int __read_mostly cpu_idle_force_poll;
 
 void cpu_idle_poll_ctrl(bool enable)
@@ -69,7 +71,7 @@ void __weak arch_cpu_idle(void)
  * NOTE: no locks or semaphores should be used here
  * return non-zero on failure
  */
-static int cpuidle_idle_call(void)
+static int cpuidle_idle_call(struct cpuidle_power **power)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
@@ -143,6 +145,10 @@ static int cpuidle_idle_call(void)
 			if (!ret) {
 				trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
+				*power = &drv->states[next_state].power;
+
+				wmb();
+
 				/*
 				 * Enter the idle state previously
 				 * returned by the governor
@@ -154,6 +160,10 @@ static int cpuidle_idle_call(void)
 				entered_state = cpuidle_enter(drv, dev,
 							      next_state);
 
+				*power = NULL;
+
+				wmb();
+
 				trace_cpu_idle_rcuidle(PWR_EVENT_EXIT,
 						       dev->cpu);
 
@@ -198,6 +208,9 @@ static int cpuidle_idle_call(void)
  */
 static void cpu_idle_loop(void)
 {
+	struct rq *rq = this_rq();
+	struct cpuidle_power **power = &rq->power;
+
 	while (1) {
 		tick_nohz_idle_enter();
 
@@ -223,7 +236,7 @@ static void cpu_idle_loop(void)
 			if (cpu_idle_force_poll || tick_check_broadcast_expired())
 				cpu_idle_poll();
 			else
-				cpuidle_idle_call();
+				cpuidle_idle_call(power);
 
 			arch_cpu_idle_exit();
 		}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1929deb..1bcac35 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -14,6 +14,7 @@
 #include "cpuacct.h"
 
 struct rq;
+struct cpuidle_power;
 
 extern __read_mostly int scheduler_running;
 
@@ -632,6 +633,10 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+#ifdef CONFIG_CPU_IDLE
+	struct cpuidle_power *power;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
-- 
1.7.9.5

