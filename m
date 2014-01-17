Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaAQEhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 23:37:32 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34491 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAQEha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 23:37:30 -0500
Subject: [PATCH V2] cpuidle/governors: Fix logic in selection of idle states
To: svaidy@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        benh@kernel.crashing.org, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        tuukka.tikkanen@linaro.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 17 Jan 2014 10:03:52 +0530
Message-ID: <20140117043351.21531.14192.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011704-1542-0000-0000-0000054DFBAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpuidle governors today are not handling scenarios where no idle state
can be chosen. Such scenarios coud arise if the user has disabled all the
idle states at runtime or the latency requirement from the cpus is very strict.

The menu governor returns 0th index of the idle state table when no other
idle state is suitable. This is even when the idle state corresponding to this
index is disabled or the latency requirement is strict and the exit_latency
of the lowest idle state is also not acceptable. Hence this patch
fixes this logic in the menu governor by defaulting to an idle state index
of -1 unless any other state is suitable.

The ladder governor needs a few more fixes in addition to that required in the
menu governor. When the ladder governor decides to demote the idle state of a
CPU, it does not check if the lower idle states are enabled. Add this logic
in addition to the logic where it chooses an index of -1 if it can neither
promote or demote the idle state of a cpu nor can it choose the current idle
state.

The cpuidle_idle_call() will return back if the governor decides upon not
entering any idle state. However it cannot return an error code because all
archs have the logic today that if the call to cpuidle_idle_call() fails, it
means that the cpuidle driver failed to *function*; for instance due to
errors during registration. As a result they end up deciding upon a
default idle state on their own, which could very well be a deep idle state.
This is incorrect in cases where no idle state is suitable.

Besides for the scenario that this patch is addressing, the call actually
succeeds. Its just that no idle state is thought to be suitable by the governors.
Under such a circumstance return success code without entering any idle
state.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Changes from V1:https://lkml.org/lkml/2014/1/14/26

1. Change the return code to success from -EINVAL due to the reason mentioned
in the changelog.
2. Add logic that the patch is addressing in the ladder governor as well.
3. Added relevant comments and removed redundant logic as suggested in the
above thread.
---

 drivers/cpuidle/cpuidle.c          |   15 +++++-
 drivers/cpuidle/governors/ladder.c |   98 ++++++++++++++++++++++++++----------
 drivers/cpuidle/governors/menu.c   |    7 +--
 3 files changed, 89 insertions(+), 31 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a55e68f..831b664 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -131,8 +131,9 @@ int cpuidle_idle_call(void)
 
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(drv, dev);
+
+	dev->last_residency = 0;
 	if (need_resched()) {
-		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
 		if (cpuidle_curr_governor->reflect)
 			cpuidle_curr_governor->reflect(dev, next_state);
@@ -140,6 +141,18 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
+	/* Unlike in the need_resched() case, we return here because the
+	 * governor did not find a suitable idle state. However idle is still
+	 * in progress as we are not asked to reschedule. Hence we return
+	 * without enabling interrupts.
+	 *
+	 * NOTE: The return code should still be success, since the verdict of this
+	 * call is "do not enter any idle state" and not a failed call due to
+	 * errors.
+	 */
+	if (next_state < 0)
+		return 0;
+
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 9f08e8c..f495f57 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -58,6 +58,36 @@ static inline void ladder_do_selection(struct ladder_device *ldev,
 	ldev->last_state_idx = new_idx;
 }
 
+static int can_promote(struct ladder_device *ldev, int last_idx,
+				int last_residency)
+{
+	struct ladder_device_state *last_state;
+
+	last_state = &ldev->states[last_idx];
+	if (last_residency > last_state->threshold.promotion_time) {
+		last_state->stats.promotion_count++;
+		last_state->stats.demotion_count = 0;
+		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count)
+			return 1;
+	}
+	return 0;
+}
+
+static int can_demote(struct ladder_device *ldev, int last_idx,
+			int last_residency)
+{
+	struct ladder_device_state *last_state;
+
+	last_state = &ldev->states[last_idx];
+	if (last_residency < last_state->threshold.demotion_time) {
+		last_state->stats.demotion_count++;
+		last_state->stats.promotion_count = 0;
+		if (last_state->stats.demotion_count >= last_state->threshold.demotion_count)
+			return 1;
+	}
+	return 0;
+}
+
 /**
  * ladder_select_state - selects the next state to enter
  * @drv: cpuidle driver
@@ -73,29 +103,33 @@ static int ladder_select_state(struct cpuidle_driver *drv,
 
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0)) {
-		ladder_do_selection(ldev, last_idx, 0);
-		return 0;
+		if (last_idx >= 0)
+			ladder_do_selection(ldev, last_idx, -1);
+		goto out;
 	}
 
-	last_state = &ldev->states[last_idx];
-
-	if (drv->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID) {
-		last_residency = cpuidle_get_last_residency(dev) - \
-					 drv->states[last_idx].exit_latency;
+	if (last_idx >= 0) {
+		if (drv->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID) {
+			last_residency = cpuidle_get_last_residency(dev) - \
+						 drv->states[last_idx].exit_latency;
+		} else {
+			last_state = &ldev->states[last_idx];
+			last_residency = last_state->threshold.promotion_time + 1;
+		}
 	}
-	else
-		last_residency = last_state->threshold.promotion_time + 1;
 
 	/* consider promotion */
 	if (last_idx < drv->state_count - 1 &&
 	    !drv->states[last_idx + 1].disabled &&
 	    !dev->states_usage[last_idx + 1].disable &&
-	    last_residency > last_state->threshold.promotion_time &&
 	    drv->states[last_idx + 1].exit_latency <= latency_req) {
-		last_state->stats.promotion_count++;
-		last_state->stats.demotion_count = 0;
-		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
-			ladder_do_selection(ldev, last_idx, last_idx + 1);
+		if (last_idx >= 0) {
+			if (can_promote(ldev, last_idx, last_residency)) {
+				ladder_do_selection(ldev, last_idx, last_idx + 1);
+				return last_idx + 1;
+			}
+		} else {
+			ldev->last_state_idx = last_idx + 1;
 			return last_idx + 1;
 		}
 	}
@@ -107,26 +141,36 @@ static int ladder_select_state(struct cpuidle_driver *drv,
 	    drv->states[last_idx].exit_latency > latency_req)) {
 		int i;
 
-		for (i = last_idx - 1; i > CPUIDLE_DRIVER_STATE_START; i--) {
-			if (drv->states[i].exit_latency <= latency_req)
+		for (i = last_idx - 1; i >= CPUIDLE_DRIVER_STATE_START; i--) {
+			if (drv->states[i].exit_latency <= latency_req &&
+				!(drv->states[i].disabled || dev->states_usage[i].disable))
 				break;
 		}
-		ladder_do_selection(ldev, last_idx, i);
-		return i;
+		if (i >= 0) {
+			ladder_do_selection(ldev, last_idx, i);
+			return i;
+		}
+		goto out;
 	}
 
-	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
-	    last_residency < last_state->threshold.demotion_time) {
-		last_state->stats.demotion_count++;
-		last_state->stats.promotion_count = 0;
-		if (last_state->stats.demotion_count >= last_state->threshold.demotion_count) {
-			ladder_do_selection(ldev, last_idx, last_idx - 1);
-			return last_idx - 1;
+	if (last_idx > CPUIDLE_DRIVER_STATE_START) {
+		int i = last_idx - 1;
+
+		if (can_demote(ldev, last_idx, last_residency) &&
+			!(drv->states[i].disabled || dev->states_usage[i].disable)) {
+			ladder_do_selection(ldev, last_idx, i);
+			return i;
 		}
+		/* We come here when the last_idx is still a suitable idle state, just that
+		 * promotion or demotion is not ideal.
+		 */
+		ldev->last_state_idx = last_idx;
+		return last_idx;
 	}
 
-	/* otherwise remain at the current state */
-	return last_idx;
+	/* we come here if no idle state is suitable */
+out:	ldev->last_state_idx = -1;
+	return ldev->last_state_idx;
 }
 
 /**
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index cf7f2f0..e9f17ce 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -297,12 +297,12 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		data->needs_update = 0;
 	}
 
-	data->last_state_idx = 0;
+	data->last_state_idx = -1;
 	data->exit_us = 0;
 
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0))
-		return 0;
+		return data->last_state_idx;
 
 	/* determine the expected residency time, round up */
 	t = ktime_to_timespec(tick_nohz_get_sleep_length());
@@ -368,7 +368,8 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 /**
  * menu_reflect - records that data structures need update
  * @dev: the CPU
- * @index: the index of actual entered state
+ * @index: the index of actual entered state or -1 if no idle state is
+ * suitable.
  *
  * NOTE: it's important to be fast here because this operation will add to
  *       the overall exit latency.

