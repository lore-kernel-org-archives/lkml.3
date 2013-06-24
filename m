Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3FXKvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:51:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46152 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3FXKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:51:35 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V7 06/30] thermal: exynos: Move exynos_thermal.h from include/* to driver/* folder
Date: Mon, 24 Jun 2013 16:20:27 +0530
Message-Id: <1372071051-3167-7-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames and moves include/linux/platform_data/exynos_thermal.h to
drivers/thermal/samsung/exynos_tmu.h. This file movement is needed as exynos
SOC's are not supporting non-DT based platforms and this file now just contains
exynos tmu driver related definations.
Also struct freq_clip_table is now moved to exynos_thermal_common.c as it fixes
the compilation issue occuring because now this new tmu header file is included
in tmu driver c file and not in the common thermal header file.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c    |    1 -
 drivers/thermal/samsung/exynos_thermal_common.h    |   16 ++++++++++++
 drivers/thermal/samsung/exynos_tmu.c               |    2 +-
 .../thermal/samsung/exynos_tmu.h                   |   26 +++++--------------
 4 files changed, 24 insertions(+), 21 deletions(-)
 rename include/linux/platform_data/exynos_thermal.h => drivers/thermal/samsung/exynos_tmu.h (84%)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index f20f458..c9edc30 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -22,7 +22,6 @@
 
 #include <linux/cpu_cooling.h>
 #include <linux/err.h>
-#include <linux/platform_data/exynos_thermal.h>
 #include <linux/slab.h>
 #include <linux/thermal.h>
 
diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 8df1848..57ce33b 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -44,6 +44,22 @@
 
 #define EXYNOS_ZONE_COUNT	3
 
+/**
+ * struct freq_clip_table
+ * @freq_clip_max: maximum frequency allowed for this cooling state.
+ * @temp_level: Temperature level at which the temperature clipping will
+ *	happen.
+ * @mask_val: cpumask of the allowed cpu's where the clipping will take place.
+ *
+ * This structure is required to be filled and passed to the
+ * cpufreq_cooling_unregister function.
+ */
+struct freq_clip_table {
+	unsigned int freq_clip_max;
+	unsigned int temp_level;
+	const struct cpumask *mask_val;
+};
+
 struct	thermal_trip_point_conf {
 	int trip_val[MAX_TRIP_COUNT];
 	int trip_count;
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 22a8874..6aa2fd2 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -27,9 +27,9 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-#include <linux/platform_data/exynos_thermal.h>
 
 #include "exynos_thermal_common.h"
+#include "exynos_tmu.h"
 
 /* Exynos generic registers */
 #define EXYNOS_TMU_REG_TRIMINFO		0x0
diff --git a/include/linux/platform_data/exynos_thermal.h b/drivers/thermal/samsung/exynos_tmu.h
similarity index 84%
rename from include/linux/platform_data/exynos_thermal.h
rename to drivers/thermal/samsung/exynos_tmu.h
index da7e627..1857609 100644
--- a/include/linux/platform_data/exynos_thermal.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -1,8 +1,9 @@
 /*
- * exynos_thermal.h - Samsung EXYNOS TMU (Thermal Management Unit)
+ * exynos_tmu.h - Samsung EXYNOS TMU (Thermal Management Unit)
  *
  *  Copyright (C) 2011 Samsung Electronics
  *  Donggeun Kim <dg77.kim@samsung.com>
+ *  Amit Daniel Kachhap <amit.daniel@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -19,10 +20,12 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifndef _LINUX_EXYNOS_THERMAL_H
-#define _LINUX_EXYNOS_THERMAL_H
+#ifndef _EXYNOS_TMU_H
+#define _EXYNOS_TMU_H
 #include <linux/cpu_cooling.h>
 
+#include "exynos_thermal_common.h"
+
 enum calibration_type {
 	TYPE_ONE_POINT_TRIMMING,
 	TYPE_TWO_POINT_TRIMMING,
@@ -33,21 +36,6 @@ enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS,
 };
-/**
- * struct freq_clip_table
- * @freq_clip_max: maximum frequency allowed for this cooling state.
- * @temp_level: Temperature level at which the temperature clipping will
- *	happen.
- * @mask_val: cpumask of the allowed cpu's where the clipping will take place.
- *
- * This structure is required to be filled and passed to the
- * cpufreq_cooling_unregister function.
- */
-struct freq_clip_table {
-	unsigned int freq_clip_max;
-	unsigned int temp_level;
-	const struct cpumask *mask_val;
-};
 
 /**
  * struct exynos_tmu_platform_data
@@ -116,4 +104,4 @@ struct exynos_tmu_platform_data {
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
 };
-#endif /* _LINUX_EXYNOS_THERMAL_H */
+#endif /* _EXYNOS_TMU_H */
-- 
1.7.1

