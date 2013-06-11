Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3FKMz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:55:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55213 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab3FKMzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:55:55 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: [PATCH V5 26/30] thermal: exynos: Add hardware mode thermal calibration support
Date: Tue, 11 Jun 2013 18:23:36 +0530
Message-Id: <1370955220-2949-27-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for h/w mode calibration in the TMU controller.
soc's like 5440 support this features.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |   15 +++++++++++++++
 drivers/thermal/samsung/exynos_tmu.h      |    6 ++++++
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 drivers/thermal/samsung/exynos_tmu_data.h |    2 ++
 4 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index af0e6ca..7a259f4 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -73,6 +73,9 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp_code;
 
+	if (pdata->cal_mode == HW_MODE)
+		return temp;
+
 	if (data->soc == SOC_ARCH_EXYNOS4210)
 		/* temp should range between 25 and 125 */
 		if (temp < 25 || temp > 125) {
@@ -107,6 +110,9 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp;
 
+	if (pdata->cal_mode == HW_MODE)
+		return temp_code;
+
 	if (data->soc == SOC_ARCH_EXYNOS4210)
 		/* temp_code should range between 75 and 175 */
 		if (temp_code < 75 || temp_code > 175) {
@@ -155,6 +161,9 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
 		__raw_writel(1, data->base + reg->triminfo_ctrl);
 
+	if (pdata->cal_mode == HW_MODE)
+		goto skip_calib_data;
+
 	/* Save trimming info in order to perform calibration */
 	if (data->soc == SOC_ARCH_EXYNOS5440) {
 		/*
@@ -190,6 +199,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			(pdata->efuse_value >> reg->triminfo_85_shift) &
 			EXYNOS_TMU_TEMP_MASK;
 
+skip_calib_data:
 	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
 		dev_err(&pdev->dev, "Invalid max trigger level\n");
 		goto out;
@@ -319,6 +329,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 		con |= (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
 	}
 
+	if (pdata->cal_mode == HW_MODE) {
+		con &= ~(reg->calib_mode_mask << reg->calib_mode_shift);
+		con |= pdata->cal_type << reg->calib_mode_shift;
+	}
+
 	if (on) {
 		con |= (1 << reg->core_en_shift);
 		interrupt_en =
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 73aaed7..abfa1eb 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -88,6 +88,10 @@ enum soc_type {
  * @buf_slope_sel_shift: shift bits of amplifier gain value in tmu_ctrl
 	register.
  * @buf_slope_sel_mask: mask bits of amplifier gain value in tmu_ctrl register.
+ * @calib_mode_shift: shift bits of calibration mode value in tmu_ctrl
+	register.
+ * @calib_mode_mask: mask bits of calibration mode value in tmu_ctrl
+	register.
  * @therm_trip_tq_en_shift: shift bits of thermal trip enable by TQ pin in
 	tmu_ctrl register.
  * @core_en_shift: shift bits of TMU core enable bit in tmu_ctrl register.
@@ -149,6 +153,8 @@ struct exynos_tmu_registers {
 	u32	therm_trip_en_shift;
 	u32	buf_slope_sel_shift;
 	u32	buf_slope_sel_mask;
+	u32	calib_mode_shift;
+	u32	calib_mode_mask;
 	u32	therm_trip_tq_en_shift;
 	u32	core_en_shift;
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index b34e726..47c5d6b 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -189,6 +189,8 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
 	.buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
 	.buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
+	.calib_mode_shift = EXYNOS_TMU_CALIB_MODE_SHIFT,
+	.calib_mode_mask = EXYNOS_TMU_CALIB_MODE_MASK,
 	.core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
 	.tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
 	.tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 43ce5fb..dc7feb5 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -75,6 +75,8 @@
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
 #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
 #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
+#define EXYNOS_TMU_CALIB_MODE_SHIFT	4
+#define EXYNOS_TMU_CALIB_MODE_MASK	0x3
 
 #define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
 #define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
-- 
1.7.1

