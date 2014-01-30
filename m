Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaA3OJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:09:46 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:57564 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbaA3OJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:09:29 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: nicolas.pitre@linaro.org, peterz@infradead.org, mingo@redhat.com,
        tglx@linutronix.de, rjw@rjwysocki.net
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Date: Thu, 30 Jan 2014 15:09:22 +0100
Message-Id: <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main cpuidle function is part of the idle.c and this one belongs to the
sched directory, allowing to integration the private structure used by the
scheduler.

We can store the idle index where the cpu is and reuse it in the scheduler
to do better decision regarding balancing and idlest cpu.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/idle.c  |    9 +++++++++
 kernel/sched/sched.h |    3 +++
 2 files changed, 12 insertions(+)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 3e85d38..eeb9f60 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -12,6 +12,8 @@
 
 #include <trace/events/power.h>
 
+#include "sched.h"
+
 static int __read_mostly cpu_idle_force_poll;
 
 void cpu_idle_poll_ctrl(bool enable)
@@ -73,6 +75,7 @@ static int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	struct rq *rq = this_rq();
 	int next_state, entered_state;
 
 	/* ask the governor for the next state */
@@ -80,6 +83,9 @@ static int cpuidle_idle_call(void)
 	if (next_state < 0)
 		return next_state;
 
+	/* let know the scheduler in which idle state the cpu will be */
+	rq->idle_index = next_state;
+
 	if (need_resched()) {
 		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
@@ -97,6 +103,9 @@ static int cpuidle_idle_call(void)
 	/* give the governor an opportunity to reflect on the outcome */
 	cpuidle_reflect(dev, entered_state);
 
+	/* we exited the idle state, let the scheduler know */
+	rq->idle_index = -1;
+
 	return 0;
 }
 #else
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 90aef084..130debf 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -654,6 +654,9 @@ struct rq {
 #endif
 
 	struct sched_avg avg;
+#ifdef CONFIG_CPU_IDLE
+	int idle_index;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
-- 
1.7.9.5

