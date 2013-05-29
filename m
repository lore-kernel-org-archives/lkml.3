Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967122Ab3E2W60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:58:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43381 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966998Ab3E2W6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:58:20 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <ruslan.ruslichenko@ti.com>, Eduardo Valentin <eduardo.valentin@ti.com>,
        Durgadoss R <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFT][PATCH 1/1] thermal: step_wise: return instance->target by default
Date: Wed, 29 May 2013 18:58:05 -0400
Message-ID: <1369868285-18049-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/thermal/step_wise.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)
---

Hello all,

I am requesting for tests on this patch. Based on an internal
discussion with Ruslan, I concluded that this code needs improvement.

Ruslan, I did not keep your original code because I believe the
get_target_state needs a better implementation for code readiness.
Besides, I also believe we are facing the bug of emul_temp in your case [1],
so this patch is not really fixing anything, but improving the
code quality and making sure the instance behaves as expected.
The fact you see the cooling device stuck at 1 is most probably because
the thermal core uses trend computed by the driver, not by emul_temp.

I have implemented a different improvement as you may find below. But
I kept a Reported-by under your name.

In any case, because I believe this change in step_wise is significant,
I am sending this patch for broader review and I kindly ask interested
audience for testing it.

[1] - https://patchwork.kernel.org/patch/2632831/

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 4d4ddae..769bfa3 100644
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
1.8.2.1.342.gfa7285d

