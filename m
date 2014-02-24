Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBXHnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:43:55 -0500
Received: from mx.mmd.net ([80.83.0.3]:55322 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaBXHny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:43:54 -0500
X-Greylist: delayed 1050 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 02:43:53 EST
From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, tuukka.tikkanen@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] Cpuidle: Do not substract exit latency from assumed sleep length
Date: Mon, 24 Feb 2014 08:29:34 +0200
Message-Id: <1393223377-5744-5-git-send-email-tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The menu governor statistics update function tries to determine the
amount of time between entry to low power state and the occurrence
of the wakeup event. However, the time measured by the framework
includes exit latency on top of the desired value. This exit latency
is substracted from the measured value to obtain the desired value.

When measured value is not available, the menu governor assumes
the wakeup was caused by the timer and the time is equal to remaining
timer length. No exit latency should be substracted from this value.

This patch prevents the erroneous substraction and clarifies the
associated comment. It also removes one intermediate variable that
serves no purpose.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   44 ++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f0995dd..b347c10 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -387,32 +387,40 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int last_idx = data->last_state_idx;
-	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
 	struct cpuidle_state *target = &drv->states[last_idx];
 	unsigned int measured_us;
 	unsigned int new_factor;
 
 	/*
-	 * Ugh, this idle state doesn't support residency measurements, so we
-	 * are basically lost in the dark.  As a compromise, assume we slept
-	 * for the whole expected time.
+	 * Try to figure out how much time passed between entry to low
+	 * power state and occurrence of the wakeup event.
+	 *
+	 * If the entered idle state didn't support residency measurements,
+	 * we are basically lost in the dark how much time passed.
+	 * As a compromise, assume we slept for the whole expected time.
+	 *
+	 * Any measured amount of time will include the exit latency.
+	 * Since we are interested in when the wakeup begun, not when it
+	 * was completed, we must substract the exit latency. However, if
+	 * the measured amount of time is less than the exit latency,
+	 * assume the state was never reached and the exit latency is 0.
 	 */
-	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID)))
-		last_idle_us = data->next_timer_us;
-
+	if (unlikely(!(target->flags & CPUIDLE_FLAG_TIME_VALID))) {
+		/* Use timer value as is */
+		measured_us = data->next_timer_us;
 
-	measured_us = last_idle_us;
+	} else {
+		/* Use measured value */
+		measured_us = cpuidle_get_last_residency(dev);
 
-	/*
-	 * We correct for the exit latency; we are assuming here that the
-	 * exit latency happens after the event that we're interested in.
-	 */
-	if (measured_us > target->exit_latency)
-		measured_us -= target->exit_latency;
+		/* Deduct exit latency */
+		if (measured_us > target->exit_latency)
+			measured_us -= target->exit_latency;
 
-	/* Make sure our coefficients do not exceed unity */
-	if (measured_us > data->next_timer_us)
-		measured_us = data->next_timer_us;
+		/* Make sure our coefficients do not exceed unity */
+		if (measured_us > data->next_timer_us)
+			measured_us = data->next_timer_us;
+	}
 
 	/* Update our correction ratio */
 	new_factor = data->correction_factor[data->bucket];
@@ -439,7 +447,7 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->correction_factor[data->bucket] = new_factor;
 
 	/* update the repeating-pattern data */
-	data->intervals[data->interval_ptr++] = last_idle_us;
+	data->intervals[data->interval_ptr++] = measured_us;
 	if (data->interval_ptr >= INTERVALS)
 		data->interval_ptr = 0;
 }
-- 
1.7.9.5

