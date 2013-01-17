Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab3AQBmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:42:43 -0500
Received: from mail-ye0-f182.google.com ([209.85.213.182]:41625 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab3AQBmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:42:42 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Cc: jonghwa3.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, durgadoss.r@intel.com, joe@perches.com
Subject: [PATCH V3 2/3] thermal: exynos: Miscellaneous fixes to support falling threshold interrupt
Date: Wed, 16 Jan 2013 17:42:18 -0800
Message-Id: <1358386938-13577-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <CADGdYn4CeWB5zHuHrfSLYsyOCA_zcSgm9LHTwtei1zAhfmDJNQ@mail.gmail.com>
References: <CADGdYn4CeWB5zHuHrfSLYsyOCA_zcSgm9LHTwtei1zAhfmDJNQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below fixes are done to support falling threshold interrupt,
* Falling interrupt status macro corrected according to exynos5 data sheet.
* The get trend function modified to calculate trip temperature correctly.
* The clearing of interrupt status in the isr is now done after handling
  the event that caused the interrupt.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
Changes since V2,
Incorporated Joe Perches <joe@perches.com> review comments about coding
guidelines.

This path is based on thermal maintainer next tree.

 drivers/thermal/exynos_thermal.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index dcd13f7..f4dd68a 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -82,7 +82,7 @@
 
 #define EXYNOS_TRIMINFO_RELOAD		0x1
 #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
-#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 16)
+#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
 #define EXYNOS_MUX_ADDR_VALUE		6
 #define EXYNOS_MUX_ADDR_SHIFT		20
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
@@ -373,7 +373,14 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
 static int exynos_get_trend(struct thermal_zone_device *thermal,
 			int trip, enum thermal_trend *trend)
 {
-	if (thermal->temperature >= trip)
+	int ret;
+	unsigned long trip_temp;
+
+	ret = exynos_get_trip_temp(thermal, trip, &trip_temp);
+	if (ret < 0)
+		return ret;
+
+	if (thermal->temperature >= trip_temp)
 		*trend = THERMAL_TREND_RAISING;
 	else
 		*trend = THERMAL_TREND_DROPPING;
@@ -712,10 +719,9 @@ static void exynos_tmu_work(struct work_struct *work)
 	struct exynos_tmu_data *data = container_of(work,
 			struct exynos_tmu_data, irq_work);
 
+	exynos_report_trigger();
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
-
-
 	if (data->soc == SOC_ARCH_EXYNOS)
 		writel(EXYNOS_TMU_CLEAR_RISE_INT |
 				EXYNOS_TMU_CLEAR_FALL_INT,
@@ -723,10 +729,9 @@ static void exynos_tmu_work(struct work_struct *work)
 	else
 		writel(EXYNOS4210_TMU_INTCLEAR_VAL,
 				data->base + EXYNOS_TMU_REG_INTCLEAR);
-
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
-	exynos_report_trigger();
+
 	enable_irq(data->irq);
 }
 
-- 
1.7.5.4

