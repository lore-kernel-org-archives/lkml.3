Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbaD3MBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:01:25 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:48646 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818AbaD3MBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:01:06 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@elte.hu
Cc: rjw@rjwysocki.net, amit.kucheria@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/2] sched: idle: Store the idle state the cpu is
Date: Wed, 30 Apr 2014 14:01:03 +0200
Message-Id: <1398859263-7632-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org>
References: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the cpu enters idle it stores the cpuidle state pointer in the struct
rq which in turn could be used to take a right decision when balancing
a task.

As soon as the cpu exits the idle state, the structure is filled back with the
NULL pointer.

There are a couple of situations where the idle state pointer could be changed
while looking at it:

1. For x86/acpi with dynamic c-states, when a laptop switches from battery
   to AC that could result on removing the deeper idle state. The acpi driver
   triggers:
	'acpi_processor_cst_has_changed'
		'cpuidle_pause_and_lock'
			'cpuidle_uninstall_idle_handler'
				'kick_all_cpus_sync'.

All cpus will exit their idle state and the pointed object will be set to NULL.

2. The cpuidle driver is unloaded. Logically that could happen but not in
practice because the drivers are always compiled in and 95% of the drivers are
not coded to unregister the driver. In any case, the unloading code must call
'cpuidle_unregister_device', that calls 'cpuidle_pause_and_lock' leading to
'kick_all_cpus_sync' as mentioned above.

The race can happen if we use the pointer and then one of these two situations
occurs at the same moment.

In order to be safe, the idle state pointer stored in the rq must be used inside
a rcu_read_lock section where we are protected with the 'rcu_barrier' in the
'cpuidle_uninstall_idle_handler' function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c |    6 ++++++
 kernel/sched/idle.c       |    7 +++++++
 kernel/sched/sched.h      |    5 +++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 8236746..6a13f40 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -190,6 +190,12 @@ void cpuidle_install_idle_handler(void)
  */
 void cpuidle_uninstall_idle_handler(void)
 {
+	/*
+	 * Wait for the scheduler to finish to use the idle state he
+	 * may pointing to when looking for the cpu idle states
+	 */
+	rcu_barrier();
+
 	if (enabled_devices) {
 		initialized = 0;
 		kick_all_cpus_sync();
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index f2f4bc9..09029f6 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -12,6 +12,8 @@
 
 #include <trace/events/power.h>
 
+#include "sched.h"
+
 static int __read_mostly cpu_idle_force_poll;
 
 void cpu_idle_poll_ctrl(bool enable)
@@ -66,6 +68,7 @@ void __weak arch_cpu_idle(void)
 #ifdef CONFIG_CPU_IDLE
 static int __cpuidle_idle_call(void)
 {
+	struct rq *rq = this_rq();
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state, ret;
@@ -114,6 +117,8 @@ static int __cpuidle_idle_call(void)
 		if (!ret) {
 			trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
+			rq->idle_state = &drv->states[next_state];
+
 			/*
 			 * Enter the idle state previously returned by
 			 * the governor decision. This function will
@@ -123,6 +128,8 @@ static int __cpuidle_idle_call(void)
 			 */
 			entered_state = cpuidle_enter(drv, dev, next_state);
 
+			rq->idle_state = NULL;
+
 			trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
 			if (broadcast)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 456e492..bace64a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -14,6 +14,7 @@
 #include "cpuacct.h"
 
 struct rq;
+struct cpuidle_state;
 
 extern __read_mostly int scheduler_running;
 
@@ -643,6 +644,10 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+#ifdef CONFIG_CPU_IDLE
+	struct cpuidle_state *idle_state;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
-- 
1.7.9.5

