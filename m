Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaECSB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:01:59 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.96]:39376 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaECSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:01:09 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Javi Merino <javi.merino@arm.com>
Subject: [PATCH v3 3/6] thermal: Added Bang-bang thermal governor
Date: Sat,  3 May 2014 19:59:23 +0200
Message-Id: <1399139966-10625-4-git-send-email-peter@piie.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399139966-10625-1-git-send-email-peter@piie.net>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bang-bang thermal governor uses a hysteresis to switch abruptly on
or off a cooling device.  It is intended to control fans, which can
not be throttled but just switched on or off.
Bang-bang cannot be set as default governor as it is intended for
special devices only.  For those special devices the driver needs to
explicitely request it.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Javi Merino <javi.merino@arm.com>
Signed-off-by: Peter Feuerer <peter@piie.net>
---
 drivers/thermal/Kconfig         |  10 +++
 drivers/thermal/Makefile        |   1 +
 drivers/thermal/gov_bang_bang.c | 131 ++++++++++++++++++++++++++++++++++++++++
 drivers/thermal/thermal_core.c  |   5 ++
 drivers/thermal/thermal_core.h  |   8 +++
 5 files changed, 155 insertions(+)
 create mode 100644 drivers/thermal/gov_bang_bang.c

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 2d51912..2ede94f 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -84,6 +84,16 @@ config THERMAL_GOV_STEP_WISE
 	  Enable this to manage platform thermals using a simple linear
 	  governor.
 
+config THERMAL_GOV_BANG_BANG
+	bool "Bang Bang thermal governor"
+	default y
+	help
+	  Enable this to manage platform thermals using bang bang governor.
+
+	  Say 'Y' here if you want to use two point temperature regulation
+	  used for fans without throttling.  Some fan drivers depend on this
+	  governor to be enabled (e.g. acerhdf).
+
 config THERMAL_GOV_USER_SPACE
 	bool "User_space thermal governor"
 	help
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 54e4ec9..1c32a5d 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -11,6 +11,7 @@ thermal_sys-$(CONFIG_THERMAL_OF)		+= of-thermal.o
 
 # governors
 thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
+thermal_sys-$(CONFIG_THERMAL_GOV_BANG_BANG)	+= gov_bang_bang.o
 thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
 thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
 
diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
new file mode 100644
index 0000000..228d0a6
--- /dev/null
+++ b/drivers/thermal/gov_bang_bang.c
@@ -0,0 +1,131 @@
+/*
+ *  gov_bang_bang.c - A simple thermal throttling governor using hysteresis
+ *
+ *  Copyright (C) 2014 Peter Feuerer <peter@piie.net>
+ *
+ *  Based on step_wise.c with following Copyrights:
+ *  Copyright (C) 2012 Intel Corp
+ *  Copyright (C) 2012 Durgadoss R <durgadoss.r@intel.com>
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ */
+
+#include <linux/thermal.h>
+
+#include "thermal_core.h"
+
+static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
+{
+	long trip_temp;
+	unsigned long trip_hyst;
+	struct thermal_instance *instance;
+
+	tz->ops->get_trip_temp(tz, trip, &trip_temp);
+	tz->ops->get_trip_hyst(tz, trip, &trip_hyst);
+
+	dev_dbg(&tz->device, "Trip%d[temp=%ld]:temp=%d:hyst=%ld\n",
+				trip, trip_temp, tz->temperature,
+				trip_hyst);
+
+	mutex_lock(&tz->lock);
+
+	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
+		if (instance->trip != trip)
+			continue;
+
+		/* in case fan is in initial state, switch the fan off */
+		if (instance->target == THERMAL_NO_TARGET)
+			instance->target = 0;
+
+		/* in case fan is neither on nor off set the fan to active */
+		if (instance->target != 0 && instance->target != 1) {
+			pr_warn("Thermal instance %s controlled by bang-bang has unexpected state: %ld\n",
+					instance->name, instance->target);
+			instance->target = 1;
+		}
+
+		/*
+		 * enable fan when temperature exceeds trip_temp and disable
+		 * the fan in case it falls below trip_temp minus hysteresis
+		 */
+		if (instance->target == 0 && tz->temperature >= trip_temp)
+			instance->target = 1;
+		else if (instance->target == 1 &&
+				tz->temperature < trip_temp - trip_hyst)
+			instance->target = 0;
+
+		dev_dbg(&instance->cdev->device, "target=%d\n",
+					(int)instance->target);
+
+		instance->cdev->updated = false; /* cdev needs update */
+	}
+
+	mutex_unlock(&tz->lock);
+}
+
+/**
+ * bang_bang_throttle - controls devices associated with the given zone
+ * @tz - thermal_zone_device
+ * @trip - the trip point
+ *
+ * Regulation Logic: a two point regulation, deliver cooling state depending
+ * on the previous state shown in this diagram:
+ *
+ *                Fan:   OFF    ON
+ *
+ *                              |
+ *                              |
+ *          trip_temp:    +---->+
+ *                        |     |        ^
+ *                        |     |        |
+ *                        |     |   Temperature
+ * (trip_temp - hyst):    +<----+
+ *                        |
+ *                        |
+ *                        |
+ *
+ *   * If the fan is not running and temperature exceeds trip_temp, the fan
+ *     gets turned on.
+ *   * In case the fan is running, temperature must fall below
+ *     (trip_temp - hyst) so that the fan gets turned off again.
+ *
+ */
+static int bang_bang_throttle(struct thermal_zone_device *tz, int trip)
+{
+	struct thermal_instance *instance;
+
+	thermal_zone_trip_update(tz, trip);
+
+	mutex_lock(&tz->lock);
+
+	list_for_each_entry(instance, &tz->thermal_instances, tz_node)
+		thermal_cdev_update(instance->cdev);
+
+	mutex_unlock(&tz->lock);
+
+	return 0;
+}
+
+static struct thermal_governor thermal_gov_bang_bang = {
+	.name		= "bang_bang",
+	.throttle	= bang_bang_throttle,
+};
+
+int thermal_gov_bang_bang_register(void)
+{
+	return thermal_register_governor(&thermal_gov_bang_bang);
+}
+
+void thermal_gov_bang_bang_unregister(void)
+{
+	thermal_unregister_governor(&thermal_gov_bang_bang);
+}
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 71b0ec0..4c2726b 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1790,6 +1790,10 @@ static int __init thermal_register_governors(void)
 	if (result)
 		return result;
 
+	result = thermal_gov_bang_bang_register();
+	if (result)
+		return result;
+
 	return thermal_gov_user_space_register();
 }
 
@@ -1797,6 +1801,7 @@ static void thermal_unregister_governors(void)
 {
 	thermal_gov_step_wise_unregister();
 	thermal_gov_fair_share_unregister();
+	thermal_gov_bang_bang_unregister();
 	thermal_gov_user_space_unregister();
 }
 
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 3db339f..d15d243 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -69,6 +69,14 @@ static inline int thermal_gov_fair_share_register(void) { return 0; }
 static inline void thermal_gov_fair_share_unregister(void) {}
 #endif /* CONFIG_THERMAL_GOV_FAIR_SHARE */
 
+#ifdef CONFIG_THERMAL_GOV_BANG_BANG
+int thermal_gov_bang_bang_register(void);
+void thermal_gov_bang_bang_unregister(void);
+#else
+static inline int thermal_gov_bang_bang_register(void) { return 0; }
+static inline void thermal_gov_bang_bang_unregister(void) {}
+#endif /* CONFIG_THERMAL_GOV_BANG_BANG */
+
 #ifdef CONFIG_THERMAL_GOV_USER_SPACE
 int thermal_gov_user_space_register(void);
 void thermal_gov_user_space_unregister(void);
-- 
1.9.2

