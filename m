Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaEHOiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:38:07 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:65016 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaEHOiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:38:03 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        rjw@rjwysocki.net
Subject: [RFC PATCH 4/5] thermal: cpu_cooling: Release the upper cooling limit checks
Date: Thu,  8 May 2014 20:07:59 +0530
Message-Id: <1399559880-20562-5-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
References: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required as with addition of cpufreq cooling notifiers
mechanism the client can enable some more cooling states at a later
point of time. Say when minimum p state is reached then ACPI specific
throttling is enabled which may add some more cooling states.

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
index 71b0ec0..36bb107 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -921,7 +921,6 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
-	unsigned long max_state;
 	int result;
 
 	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
@@ -939,13 +938,11 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
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
index f7e11c7..3748e6d 100644
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

