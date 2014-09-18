Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaIRP20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:28:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47299 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbaIRP2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:28:22 -0400
X-AuditID: cbfee61b-f79f86d00000144c-7b-541afa13ac36
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 02/33] thermal: exynos: remove needless tmu_status abstraction
Date: Thu, 18 Sep 2014 17:27:19 +0200
Message-id: <1411054070-25757-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAV2RX1IhBisCLBquhlhsnLGe1eLu
	88OMFvOvXGO1ONv0ht3izcPNjBaXd81hs/jce4TRYsb5fUwWTx72sTlweeycdZfdY/Gel0we
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlXHr1VyWgnc6FUfufWRuYHyt1sXIwSEhYCLx+qBq
	FyMnkCkmceHeerYuRi4OIYFFjBK//9xlhHC6mCSe7vnEBlLFJmAlMbF9FSOILSKgJXHi0nYm
	kCJmgVtMEq9vTAZLCAv4SZz8tQasgUVAVWLD6qdgcV4BD4n1G74yQ6xTlOh+NgGshlPAU6Lh
	1iZ2EFsIqKZty13mCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh9kz6R2Mqxos
	DjEKcDAq8fAe4JUKEWJNLCuuzD3EKMHBrCTC++cjUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
	wVbrQCGB9MSS1OzU1ILUIpgsEwenVAMjL8uX2/IOsrM+C9VMVjlkHvw8gcG142Nl1dNPxbVW
	4TseMYXLHnMNKH1ydOnCpl3uc1U83r9rLHsbFWhzTHu+9d5duxXCRCMOtKeIlUetOrlzG+uL
	Ex8kLmSFWj0p/c7jd1i20tp6+Xw/8V8BLslZq946Xst/80N6/or3CRXTVThv7bfWe+WoxFKc
	kWioxVxUnAgAfUn47i8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->tmu_status is used only in exynos_tmu_initialize() and it
is accessed only if TMU_SUPPORT_READY_STATUS flag is set.  This
flag is not set for Exynos5440 and TMU_STATUS register offset
is identical for all other SoC types so the abstraction is not
needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
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
index e0e1151..8bc475c 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -137,7 +137,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		clk_enable(data->clk_sec);
 
 	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
-		status = readb(data->base + reg->tmu_status);
+		status = readb(data->base + EXYNOS_TMU_REG_STATUS);
 		if (!status) {
 			ret = -EBUSY;
 			goto out;
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index de20dcc..30f5f41 100644
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
@@ -119,8 +118,6 @@ struct exynos_tmu_registers {
 	u32	therm_trip_mode_mask;
 	u32	therm_trip_en_shift;
 
-	u32	tmu_status;
-
 	u32	tmu_cur_temp;
 
 	u32	threshold_temp;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 0f1f1f1..4e95bbb 100644
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
@@ -93,7 +92,6 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -178,7 +176,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -272,7 +269,6 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -354,7 +350,6 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS_TMU_REG_STATUS,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -444,7 +439,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
 	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
-	.tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
 	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
 	.threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index a907c54..96cf369 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -100,7 +100,6 @@
 #define EXYNOS5440_TMU_S0_7_TRIM		0x000
 #define EXYNOS5440_TMU_S0_7_CTRL		0x020
 #define EXYNOS5440_TMU_S0_7_DEBUG		0x040
-#define EXYNOS5440_TMU_S0_7_STATUS		0x060
 #define EXYNOS5440_TMU_S0_7_TEMP		0x0f0
 #define EXYNOS5440_TMU_S0_7_TH0			0x110
 #define EXYNOS5440_TMU_S0_7_TH1			0x130
-- 
1.8.2.3

