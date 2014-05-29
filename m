Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbaE2IQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:16:19 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42607 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbaE2IQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:16:14 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, edubezval@gmail.com, rjw@rjwysocki.net,
        linux-arm-kernel@lists.infradead.org, lenb@kernel.org
Subject: [PATCH v1 5/6] thermal: thermal_core: Remove the max cooling limit check in registration
Date: Thu, 29 May 2014 13:45:33 +0530
Message-Id: <1401351334-11210-6-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required as with the addition of the cooling notifiers mechanism the
client can enable some more cooling states at a later point of time and
hence max cooling state is dynamic entity now. Say when minimum p state
is reached then ACPI specific throttling is enabled which may add some
more cooling states.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/step_wise.c    |    2 +-
 drivers/thermal/thermal_core.c |    9 +++------
 include/linux/thermal.h        |    1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index f251521..7d65617 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -72,7 +72,7 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 		}
 		break;
 	case THERMAL_TREND_RAISE_FULL:
-		if (throttle)
+		if (instance->upper != THERMAL_CSTATE_MAX && throttle)
 			next_target = instance->upper;
 		break;
 	case THERMAL_TREND_DROPPING:
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 1a60f83..743bb83 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -923,7 +923,6 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
-	unsigned long max_state;
 	int result;
 
 	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
@@ -941,13 +940,11 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	if (tz != pos1 || cdev != pos2)
 		return -EINVAL;
 
-	cdev->ops->get_max_state(cdev, &max_state);
-
-	/* lower default 0, upper default max_state */
+	/* lower default 0, upper default THERMAL_CSTATE_MAX */
 	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
-	upper = upper == THERMAL_NO_LIMIT ? max_state : upper;
+	upper = upper == THERMAL_NO_LIMIT ? THERMAL_CSTATE_MAX : upper;
 
-	if (lower > upper || upper > max_state)
+	if (lower > upper)
 		return -EINVAL;
 
 	dev =
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 3fb1b92..6cfe8c8 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -36,6 +36,7 @@
 
 /* invalid cooling state */
 #define THERMAL_CSTATE_INVALID -1UL
+#define THERMAL_CSTATE_MAX 1UL
 
 /* No upper/lower limit requirement */
 #define THERMAL_NO_LIMIT	THERMAL_CSTATE_INVALID
-- 
1.7.1

