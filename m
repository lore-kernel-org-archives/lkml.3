Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab3CZNa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:30:28 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55440 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808Ab3CZNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:30:25 -0400
From: Yuxuan Shui <yshuiv7@gmail.com>
To: rui.zhang@intel.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuxuan Shui <yshuiv7@gmail.com>
Subject: [PATCH] Thermal: Don't resolve THERMAL_NO_LIMIT to max_state.
Date: Tue, 26 Mar 2013 21:29:49 +0800
Message-Id: <1364304589-24335-1-git-send-email-yshuiv7@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_state may change at runtime, for example, when loading/unloading
cpufreq policy.

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
---
 drivers/thermal/step_wise.c   | 11 ++++++++---
 drivers/thermal/thermal_sys.c |  5 ++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 407cde3..2edb7e9 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -54,18 +54,23 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 {
 	struct thermal_cooling_device *cdev = instance->cdev;
 	unsigned long cur_state;
+	unsigned long max_state;
+	int upper;
 
 	cdev->ops->get_cur_state(cdev, &cur_state);
+	cdev->ops->get_max_state(cdev, &max_state);
+
+	upper = instance->upper == THERMAL_NO_LIMIT ? max_state : instance->upper;
 
 	switch (trend) {
 	case THERMAL_TREND_RAISING:
 		if (throttle)
-			cur_state = cur_state < instance->upper ?
-				    (cur_state + 1) : instance->upper;
+			cur_state = cur_state < upper ?
+				    (cur_state + 1) : upper;
 		break;
 	case THERMAL_TREND_RAISE_FULL:
 		if (throttle)
-			cur_state = instance->upper;
+			cur_state = upper;
 		break;
 	case THERMAL_TREND_DROPPING:
 		if (cur_state == instance->lower) {
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5b7863a..f02e4d4 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1134,11 +1134,10 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 
 	cdev->ops->get_max_state(cdev, &max_state);
 
-	/* lower default 0, upper default max_state */
+	/* lower default 0 */
 	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
-	upper = upper == THERMAL_NO_LIMIT ? max_state : upper;
 
-	if (lower > upper || upper > max_state)
+	if (lower > upper || (upper != THERMAL_NO_LIMIT && upper > max_state))
 		return -EINVAL;
 
 	dev =
-- 
1.8.2

