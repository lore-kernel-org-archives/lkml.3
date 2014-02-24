Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaBXHsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:48:01 -0500
Received: from mx.mmd.net ([80.83.0.3]:55337 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaBXHr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:47:59 -0500
From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, tuukka.tikkanen@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Cpuidle: Use actual state latency in menu governor
Date: Mon, 24 Feb 2014 08:29:32 +0200
Message-Id: <1393223377-5744-3-git-send-email-tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently menu governor records the exit latency of the state it has
chosen for the idle period. The stored latency value is then later
used to calculate the actual length of the idle period. This value
may however be incorrect, as the entered state may not be the one
chosen by the governor. The entered state information is available,
so we can use that to obtain the real exit latency.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index e9a2a27..115386a 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -124,7 +124,6 @@ struct menu_device {
 
 	unsigned int	next_timer_us;
 	unsigned int	predicted_us;
-	unsigned int	exit_us;
 	unsigned int	bucket;
 	unsigned int	correction_factor[BUCKETS];
 	unsigned int	intervals[INTERVALS];
@@ -298,7 +297,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	}
 
 	data->last_state_idx = 0;
-	data->exit_us = 0;
 
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0))
@@ -359,7 +357,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 			continue;
 
 		data->last_state_idx = i;
-		data->exit_us = s->exit_latency;
 	}
 
 	return data->last_state_idx;
@@ -410,8 +407,8 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	 * We correct for the exit latency; we are assuming here that the
 	 * exit latency happens after the event that we're interested in.
 	 */
-	if (measured_us > data->exit_us)
-		measured_us -= data->exit_us;
+	if (measured_us > target->exit_latency)
+		measured_us -= target->exit_latency;
 
 
 	/* Update our correction ratio */
-- 
1.7.9.5

