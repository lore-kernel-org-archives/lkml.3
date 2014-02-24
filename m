Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaBXINL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:13:11 -0500
Received: from mx.mmd.net ([80.83.0.3]:55412 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaBXINC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:13:02 -0500
From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, tuukka.tikkanen@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] Cpuidle: Move perf multiplier calculation out of the selection loop
Date: Mon, 24 Feb 2014 08:29:35 +0200
Message-Id: <1393223377-5744-6-git-send-email-tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The menu governor performance multiplier defines a minimum predicted
idle duration to latency ratio. Instead of checking this separately
in every iteration of the state selection loop, adjust the overall
latency restriction for the whole loop if this restriction is tighter
than what is set by the QoS subsystem.

The original test
s->exit_latency * multiplier > data->predicted_us
becomes
s->exit_latency > data->predicted_us / multiplier
by dividing both sides of the comparison by "multiplier".

While division is likely to be several times slower than multiplication,
the minor performance hit allows making a generic sleep state selection
function based on (sleep duration, maximum latency) tuple.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index b347c10..71b5232 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -288,7 +288,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	struct menu_device *data = &__get_cpu_var(menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
-	int multiplier;
+	unsigned int interactivity_req;
 	struct timespec t;
 
 	if (data->needs_update) {
@@ -310,8 +310,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 
 	data->bucket = which_bucket(data->next_timer_us);
 
-	multiplier = performance_multiplier();
-
 	/*
 	 * if the correction factor is 0 (eg first time init or cpu hotplug
 	 * etc), we actually want to start out with a unity factor.
@@ -331,6 +329,15 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	get_typical_interval(data);
 
 	/*
+	 * Performance multiplier defines a minimum predicted idle
+	 * duration / latency ratio. Adjust the latency limit if
+	 * necessary.
+	 */
+	interactivity_req = data->predicted_us / performance_multiplier();
+	if (latency_req > interactivity_req)
+		latency_req = interactivity_req;
+
+	/*
 	 * We want to default to C1 (hlt), not to busy polling
 	 * unless the timer is happening really really soon.
 	 */
@@ -353,8 +360,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 			continue;
 		if (s->exit_latency > latency_req)
 			continue;
-		if (s->exit_latency * multiplier > data->predicted_us)
-			continue;
 
 		data->last_state_idx = i;
 	}
-- 
1.7.9.5

