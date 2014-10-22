Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaJVOEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:04:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42081 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaJVN6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:03 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 02/10] cpuidle: Checking the zero latency inside the governors does not make sense.
Date: Wed, 22 Oct 2014 15:57:45 +0200
Message-Id: <1413986273-28522-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the zero latency is required, we don't want to invoke any cpuidle code at
all.

Move the check within the governors and do the check before selecting the
state in order to fallback to the default idle function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/governors/ladder.c | 6 ------
 drivers/cpuidle/governors/menu.c   | 4 ----
 kernel/sched/idle.c                | 8 ++++++++
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 044ee0d..a7f18e7 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -71,12 +71,6 @@ static int ladder_select_state(struct cpuidle_driver *drv,
 	int last_residency, last_idx = ldev->last_state_idx;
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 
-	/* Special case when user has set very strict latency requirement */
-	if (unlikely(latency_req == 0)) {
-		ladder_do_selection(ldev, last_idx, 0);
-		return 0;
-	}
-
 	last_state = &ldev->states[last_idx];
 
 	if (drv->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID) {
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 34db2fb..4ed3915 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -302,10 +302,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 
 	data->last_state_idx = CPUIDLE_DRIVER_STATE_START - 1;
 
-	/* Special case when user has set very strict latency requirement */
-	if (unlikely(latency_req == 0))
-		return 0;
-
 	/* determine the expected residency time, round up */
 	data->next_timer_us = ktime_to_us(tick_nohz_get_sleep_length());
 
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 11e7bc4..3042b924 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -78,6 +78,7 @@ static void cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int next_state, entered_state;
 	unsigned int broadcast;
 
@@ -104,6 +105,13 @@ static void cpuidle_idle_call(void)
 	rcu_idle_enter();
 
 	/*
+	 * The latency requirement does not allow any latency, jump to
+	 * the default idle function
+	 */
+	if (latency_req == 0)
+		goto use_default;
+
+	/*
 	 * Ask the cpuidle framework to choose a convenient idle state.
 	 * Fall back to the default arch idle method on errors.
 	 */
-- 
1.9.1

