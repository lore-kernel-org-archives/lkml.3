Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3JCP6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:58:49 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57321 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3JCP6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:58:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 15/16] cpuidle: don't call poll_idle_init() for every cpu
Date: Thu,  3 Oct 2013 21:26:54 +0530
Message-Id: <ee9b99a281df92e71b75ff786336a54b5f9b428e.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

poll_idle_init() just initializes drv->states[0] and so that is required to be
done only once for each driver. Currently it is called from
cpuidle_enable_device() which is called for every CPU that the driver supports.
And that is not required. Move it to a better place and call it from
__cpuidle_register_driver() so that it is initialized only once.

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/cpuidle.c | 41 -----------------------------------------
 drivers/cpuidle/driver.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 1a6e9f5..1caf95d 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -227,45 +227,6 @@ void cpuidle_resume(void)
 	mutex_unlock(&cpuidle_lock);
 }
 
-#ifdef CONFIG_ARCH_HAS_CPU_RELAX
-static int poll_idle(struct cpuidle_device *dev,
-		struct cpuidle_driver *drv, int index)
-{
-	ktime_t	t1, t2;
-	s64 diff;
-
-	t1 = ktime_get();
-	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
-
-	t2 = ktime_get();
-	diff = ktime_to_us(ktime_sub(t2, t1));
-	if (diff > INT_MAX)
-		diff = INT_MAX;
-
-	dev->last_residency = (int) diff;
-
-	return index;
-}
-
-static void poll_idle_init(struct cpuidle_driver *drv)
-{
-	struct cpuidle_state *state = &drv->states[0];
-
-	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
-	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
-	state->exit_latency = 0;
-	state->target_residency = 0;
-	state->power_usage = -1;
-	state->flags = 0;
-	state->enter = poll_idle;
-	state->disabled = false;
-}
-#else
-static void poll_idle_init(struct cpuidle_driver *drv) {}
-#endif /* CONFIG_ARCH_HAS_CPU_RELAX */
-
 /**
  * cpuidle_enable_device - enables idle PM for a CPU
  * @dev: the CPU
@@ -295,8 +256,6 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 	if (!dev->state_count)
 		dev->state_count = drv->state_count;
 
-	poll_idle_init(drv);
-
 	ret = cpuidle_add_device_sysfs(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 662d934..d5b5294 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -10,6 +10,7 @@
 
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/cpuidle.h>
 #include <linux/cpumask.h>
 #include <linux/clockchips.h>
@@ -177,6 +178,45 @@ static void __cpuidle_driver_init(struct cpuidle_driver *drv)
 	}
 }
 
+#ifdef CONFIG_ARCH_HAS_CPU_RELAX
+static int poll_idle(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
+{
+	ktime_t	t1, t2;
+	s64 diff;
+
+	t1 = ktime_get();
+	local_irq_enable();
+	while (!need_resched())
+		cpu_relax();
+
+	t2 = ktime_get();
+	diff = ktime_to_us(ktime_sub(t2, t1));
+	if (diff > INT_MAX)
+		diff = INT_MAX;
+
+	dev->last_residency = (int) diff;
+
+	return index;
+}
+
+static void poll_idle_init(struct cpuidle_driver *drv)
+{
+	struct cpuidle_state *state = &drv->states[0];
+
+	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
+	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
+	state->exit_latency = 0;
+	state->target_residency = 0;
+	state->power_usage = -1;
+	state->flags = 0;
+	state->enter = poll_idle;
+	state->disabled = false;
+}
+#else
+static void poll_idle_init(struct cpuidle_driver *drv) {}
+#endif /* !CONFIG_ARCH_HAS_CPU_RELAX */
+
 /**
  * __cpuidle_register_driver: register the driver
  * @drv: a valid pointer to a struct cpuidle_driver
@@ -210,6 +250,8 @@ static int __cpuidle_register_driver(struct cpuidle_driver *drv)
 		on_each_cpu_mask(drv->cpumask, cpuidle_setup_broadcast_timer,
 				 (void *)CLOCK_EVT_NOTIFY_BROADCAST_ON, 1);
 
+	poll_idle_init(drv);
+
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

