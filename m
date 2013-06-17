Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3FQNYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:24:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:50832 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357Ab3FQNYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:24:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="354717305"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm@vger.kernel.org
Cc: eduardo.valentin@ti.com, durgadoss.r@intel.com, shawn.guo@linaro.org,
        ruslan.ruslichenko@ti.com, Zhang Rui <rui.zhang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/6] thermal: step_wise: return instance->target by default
Date: Mon, 17 Jun 2013 21:24:24 +0800
Message-Id: <1371475468-5351-3-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371475468-5351-1-git-send-email-rui.zhang@intel.com>
References: <1371475468-5351-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@ti.com>

In case the trend is not changing or when there is no
request for throttling, it is expected that the instance
would not change its requested target. This patch improves
the code implementation to cover for this expected behavior.

With current implementation, the instance will always
reset to cdev.cur_state, even in not expected cases,
like those mentioned above.

This patch changes the step_wise governor implementation
of get_target so that we accomplish:
(a) - default value will be current instance->target, so
we do not change the thermal instance target unnecessarily.
(b) - the code now it is clear about what is the intention.
There is a clear statement of what are the expected outcomes
(c) - removal of hardcoded constants, now it is put in use
the THERMAL_NO_TARGET macro.
(d) - variable names are also improved so that reader can
clearly understand the difference between instance cur target,
next target and cdev cur_state.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Durgadoss R <durgadoss.r@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reported-by: Ruslan Ruslichenko <ruslan.ruslichenko@ti.com>
Signed-of-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/step_wise.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 0afbd86..d89e781 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -51,44 +51,51 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 {
 	struct thermal_cooling_device *cdev = instance->cdev;
 	unsigned long cur_state;
+	unsigned long next_target;
 
+	/*
+	 * We keep this instance the way it is by default.
+	 * Otherwise, we use the current state of the
+	 * cdev in use to determine the next_target.
+	 */
 	cdev->ops->get_cur_state(cdev, &cur_state);
+	next_target = instance->target;
 
 	switch (trend) {
 	case THERMAL_TREND_RAISING:
 		if (throttle) {
-			cur_state = cur_state < instance->upper ?
+			next_target = cur_state < instance->upper ?
 				    (cur_state + 1) : instance->upper;
-			if (cur_state < instance->lower)
-				cur_state = instance->lower;
+			if (next_target < instance->lower)
+				next_target = instance->lower;
 		}
 		break;
 	case THERMAL_TREND_RAISE_FULL:
 		if (throttle)
-			cur_state = instance->upper;
+			next_target = instance->upper;
 		break;
 	case THERMAL_TREND_DROPPING:
 		if (cur_state == instance->lower) {
 			if (!throttle)
-				cur_state = -1;
+				next_target = THERMAL_NO_TARGET;
 		} else {
-			cur_state -= 1;
-			if (cur_state > instance->upper)
-				cur_state = instance->upper;
+			next_target = cur_state - 1;
+			if (next_target > instance->upper)
+				next_target = instance->upper;
 		}
 		break;
 	case THERMAL_TREND_DROP_FULL:
 		if (cur_state == instance->lower) {
 			if (!throttle)
-				cur_state = -1;
+				next_target = THERMAL_NO_TARGET;
 		} else
-			cur_state = instance->lower;
+			next_target = instance->lower;
 		break;
 	default:
 		break;
 	}
 
-	return cur_state;
+	return next_target;
 }
 
 static void update_passive_instance(struct thermal_zone_device *tz,
-- 
1.7.9.5

