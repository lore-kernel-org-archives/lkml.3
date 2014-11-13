Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaKMPCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:02:22 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42775 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaKMPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:02:17 -0500
X-AuditID: cbfee61a-f79c06d000004e71-44-5464c7f794ca
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 02/33] thermal: exynos: remove needless tmu_status
 abstraction
Date: Thu, 13 Nov 2014 16:00:57 +0100
Message-id: <1415890888-8881-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd3vx1NCDFZ/ULNouBpisXHGelaL
	+VeusVqcbXrDbvHm4WZGi8u75rBZfO49wmgx4/w+JosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DKaLm6mb1gm07Fnqfv2RsYd6p1MXJySAiYSDxddI4dwhaT
	uHBvPVsXIxeHkMB0RolV93exQzhdTBJvXu4Bq2ITsJKY2L6KEcQWEdCSOHFpOxNIEbPAMiaJ
	S9/mM4EkhAWCJd5t/skCYrMIqEp87u0Gs3kF3CUuN51ghlinKNH9bAIbiM0p4CHxaupfsKFC
	QDXXHr1jnsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcIA9k9rBuLLB4hCjAAej
	Eg/vC5aUECHWxLLiytxDjBIczEoivN6HgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJ
	pCeWpGanphakFsFkmTg4pRoYxarz3O2ik1OmSOT6BNTKNrzNjlhkccHgeP7NTWa8fZd23/c/
	9ZFdKOn6HfMY078yjDF7Ts+fOEt51vMtO9p5H/X7vZ4cE/go+GTCB/eAo3MKgyxONk7k1jP9
	eOCvmueaZsGo9Suubq/Ki2J6pvpvQneA1SULM6lF+S/KtsRY1Z7leij20kpWiaU4I9FQi7mo
	OBEAYHCa0CwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->tmu_status is used only in exynos_tmu_initialize() and it
is accessed only if TMU_SUPPORT_READY_STATUS flag is set.  This
flag is not set for Exynos5440 and TMU_STATUS register offset
is identical for all other SoC types so the abstraction is not
needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 2 +-
 drivers/thermal/samsung/exynos_tmu.h      | 3 ---
 drivers/thermal/samsung/exynos_tmu_data.c | 6 ------
 drivers/thermal/samsung/exynos_tmu_data.h | 1 -
 4 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index bb05355..ac43637 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -154,7 +154,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		clk_enable(data->clk_sec);
 
 	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
-		status = readb(data->base + reg->tmu_status);
+		status = readb(data->base + EXYNOS_TMU_REG_STATUS);
 		if (!status) {
 			ret = -EBUSY;
 			goto out;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 91e2317..7849d8f 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -83,7 +83,6 @@ enum soc_type {
  * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl register.
  * @therm_trip_mode_mask: mask bits of tripping mode in tmu_ctrl register.
  * @therm_trip_en_shift: shift bits of tripping enable in tmu_ctrl register.
- * @tmu_status: register drescribing the TMU status.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
  * @threshold_temp: register containing the base threshold level.
  * @threshold_th0: Register containing first set of rising levels.
@@ -115,8 +114,6 @@ struct exynos_tmu_registers {
 	u32	therm_trip_mode_mask;
 	u32	therm_trip_en_shift;
 
-	u32	tmu_status;
-
 	u32	tmu_cur_temp;
 
 	u32	threshold_temp;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index a6088ff..49c8142 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -27,7 +27,6 @@
 #if defined(CONFIG_CPU_EXYNOS4210)
 static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_temp = EXYNOS4210_TMU_REG_THRESHOLD_TEMP,
 	.threshold_th0 = EXYNOS4210_TMU_REG_TRIG_LEVEL0,
@@ -92,7 +91,6 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -173,7 +171,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -263,7 +260,6 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -341,7 +337,6 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -427,7 +422,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
 	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
 	.threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 63de598..e02ef99 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -88,7 +88,6 @@
 #define EXYNOS5440_TMU_S0_7_TRIM		0x000
 #define EXYNOS5440_TMU_S0_7_CTRL		0x020
 #define EXYNOS5440_TMU_S0_7_DEBUG		0x040
-#define EXYNOS5440_TMU_S0_7_STATUS		0x060
 #define EXYNOS5440_TMU_S0_7_TEMP		0x0f0
 #define EXYNOS5440_TMU_S0_7_TH0			0x110
 #define EXYNOS5440_TMU_S0_7_TH1			0x130
-- 
1.8.2.3

