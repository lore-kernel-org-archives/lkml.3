Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaCKMiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:38:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaCKMiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:38:07 -0400
Date: Tue, 11 Mar 2014 05:37:33 -0700
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-c8cc7d4de7a4f2fb1f8774ec2de5b49c46c42e64@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, nico@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, nico@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
In-Reply-To: <1393832934-11625-3-git-send-email-daniel.lezcano@linaro.org>
References: <1393832934-11625-3-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/idle] sched/idle: Reorganize the idle loop
Git-Commit-ID: c8cc7d4de7a4f2fb1f8774ec2de5b49c46c42e64
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

Commit-ID:  c8cc7d4de7a4f2fb1f8774ec2de5b49c46c42e64
Gitweb:     http://git.kernel.org/tip/c8cc7d4de7a4f2fb1f8774ec2de5b49c46c42e64
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 3 Mar 2014 08:48:52 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:52:47 +0100

sched/idle: Reorganize the idle loop

Now that we have the main cpuidle function in idle.c, move some code from
the idle mainloop to this function for the sake of clarity.

That removes if then else indentation difficult to follow when looking at the
code. This patch does not change the current behavior.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: tglx@linutronix.de
Cc: rjw@rjwysocki.net
Cc: preeti@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1393832934-11625-3-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/cpuidle.h |  2 ++
 kernel/sched/idle.c     | 33 +++++++++++++++------------------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 8d97962..b0238cb 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -180,6 +180,8 @@ static inline int cpuidle_enable_device(struct cpuidle_device *dev)
 {return -ENODEV; }
 static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
 static inline int cpuidle_play_dead(void) {return -ENODEV; }
+static inline struct cpuidle_driver *cpuidle_get_cpu_driver(
+	struct cpuidle_device *dev) {return NULL; }
 #endif
 
 #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d5aaf5e..dc8a246 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -63,7 +63,6 @@ void __weak arch_cpu_idle(void)
 	local_irq_enable();
 }
 
-#ifdef CONFIG_CPU_IDLE
 /**
  * cpuidle_idle_call - the main idle function
  *
@@ -77,9 +76,14 @@ static int cpuidle_idle_call(void)
 	int next_state, entered_state, ret;
 	bool broadcast;
 
+	stop_critical_timings();
+	rcu_idle_enter();
+
 	ret = cpuidle_enabled(drv, dev);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		arch_cpu_idle();
+		goto out;
+	}
 
 	/* ask the governor for the next state */
 	next_state = cpuidle_select(drv, dev);
@@ -89,7 +93,7 @@ static int cpuidle_idle_call(void)
 		/* give the governor an opportunity to reflect on the outcome */
 		cpuidle_reflect(dev, next_state);
 		local_irq_enable();
-		return 0;
+		goto out;
 	}
 
 	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
@@ -109,15 +113,15 @@ static int cpuidle_idle_call(void)
 
 	/* give the governor an opportunity to reflect on the outcome */
 	cpuidle_reflect(dev, entered_state);
+out:
+	if (WARN_ON_ONCE(irqs_disabled()))
+		local_irq_enable();
+
+	rcu_idle_exit();
+	start_critical_timings();
 
 	return 0;
 }
-#else
-static inline int cpuidle_idle_call(void)
-{
-	return -ENODEV;
-}
-#endif
 
 /*
  * Generic idle loop implementation
@@ -150,14 +154,7 @@ static void cpu_idle_loop(void)
 				cpu_idle_poll();
 			} else {
 				if (!current_clr_polling_and_test()) {
-					stop_critical_timings();
-					rcu_idle_enter();
-					if (cpuidle_idle_call())
-						arch_cpu_idle();
-					if (WARN_ON_ONCE(irqs_disabled()))
-						local_irq_enable();
-					rcu_idle_exit();
-					start_critical_timings();
+					cpuidle_idle_call();
 				} else {
 					local_irq_enable();
 				}
