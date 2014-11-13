Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbaKMPMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:12:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50328 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaKMPDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:03:35 -0500
X-AuditID: cbfee61a-f79c06d000004e71-b3-5464c8264ccc
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 07/33] thermal: exynos: remove needless therm_trip_en_shift
 abstraction
Date: Thu, 13 Nov 2014 16:01:02 +0100
Message-id: <1415890888-8881-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQV21EykhBrvWqFg0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlrFrzlanglErFgbuPWRsY98t3MXJwSAiYSGzY59HFyAlk
	iklcuLeeDSQsJDCdUWIpZxcjF5DZxSTxb/E0RpAaNgEriYntq8BsEQEtiROXtjOBFDELLGOS
	uPRtPhNIQlggRuLCqb9gRSwCqhITJm1mA7F5Bdwlek+cZYJYpijR/WwCWJxTwEPi1VSIeiGg
	mmuP3jFPYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4tJ5J7WBc2WBxiFGAg1GJ
	h/cFS0qIEGtiWXFl7iFGCQ5mJRFe78NAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTS
	E0tSs1NTC1KLYLJMHJxSDYyql5YcPlu5Rm/uxeYUb8EFxdbZ9+y/OdcltArXMvI/n7/D0403
	Yz9b5bfznzdLNnQ2bFq4eP1DgUn5kWvLTFd42PpF1Uvf5ml6bK550vTAf+2lNgvy5l0OVnn8
	83D5/RiTjwa5GW8fx7s2/OR7WHaGbcE/aT3+kL7Ww2IyB1fKTj+11sG+iFWJpTgj0VCLuag4
	EQAr46sGKQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->therm_trip_en_shift is used only in exynos_tmu_initialize()
and not accessed on Exynos4210 (also reg->therm_trip_en_shift is
not even assigned in exynos4210_tmu_registers but it is assigned
to identical value for all other SoC types) so the register
abstraction is not needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 2 +-
 drivers/thermal/samsung/exynos_tmu.h      | 2 --
 drivers/thermal/samsung/exynos_tmu_data.c | 5 -----
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index fb38411..3f3b8cf 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -266,7 +266,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 					data->base + reg->threshold_th2);
 			}
 			con = readl(data->base + reg->tmu_ctrl);
-			con |= (1 << reg->therm_trip_en_shift);
+			con |= (1 << EXYNOS_TMU_THERM_TRIP_EN_SHIFT);
 			writel(con, data->base + reg->tmu_ctrl);
 		}
 	}
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 88c16d7..4798313 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -77,7 +77,6 @@ enum soc_type {
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
  * @tmu_ctrl: TMU main controller register.
- * @therm_trip_en_shift: shift bits of tripping enable in tmu_ctrl register.
  * @tmu_cur_temp: register containing the current temperature of the TMU.
  * @threshold_th0: Register containing first set of rising levels.
  * @threshold_th1: Register containing second set of rising levels.
@@ -100,7 +99,6 @@ enum soc_type {
  */
 struct exynos_tmu_registers {
 	u32	tmu_ctrl;
-	u32	therm_trip_en_shift;
 
 	u32	tmu_cur_temp;
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 4a44eb7..a120a8c 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -83,7 +83,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -156,7 +155,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -242,7 +240,6 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5260)
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -317,7 +314,6 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5420)
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
-	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS_TMU_REG_CURRENT_TEMP,
 	.threshold_th0 = EXYNOS_THD_TEMP_RISE,
 	.threshold_th1 = EXYNOS_THD_TEMP_FALL,
@@ -400,7 +396,6 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
-	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
 	.threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
 	.threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
-- 
1.8.2.3

