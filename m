Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3EGNCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:02:13 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61535 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab3EGNCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:02:08 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V3 07/21] thermal: exynos: Add extra entries in the tmu platform data
Date: Tue,  7 May 2013 18:30:57 +0530
Message-Id: <1367931671-3906-8-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds entries min_efuse_value, max_efuse_value, default_temp_offset,
trigger_type, cal_type, trim_first_point, trim_second_point and
trigger_enable in the TMU platform data structure. Also the driver is modified
to use the data passed by these new platform memebers instead of the constant
macros. All these changes helps in separating the SOC specific data part from
the TMU driver.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |   43 +++++++++++------------
 drivers/thermal/samsung/exynos_tmu.h      |   52 +++++++++++++++++++----------
 drivers/thermal/samsung/exynos_tmu_data.c |   33 ++++++++++++++----
 3 files changed, 80 insertions(+), 48 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index a43afc4..77b6a37 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -53,7 +53,6 @@
 #define EXYNOS_TMU_BUF_SLOPE_SEL_MASK	0xf
 #define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT	8
 #define EXYNOS_TMU_CORE_EN_SHIFT	0
-#define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET	50
 
 /* Exynos4210 specific registers */
 #define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
@@ -98,9 +97,6 @@
 #define EXYNOS_TMU_INTEN_FALL1_SHIFT	20
 #define EXYNOS_TMU_INTEN_FALL2_SHIFT	24
 
-#define EFUSE_MIN_VALUE 40
-#define EFUSE_MAX_VALUE 100
-
 #ifdef CONFIG_THERMAL_EMULATION
 #define EXYNOS_EMUL_TIME	0x57F0
 #define EXYNOS_EMUL_TIME_MASK	0xffff
@@ -140,15 +136,16 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 
 	switch (pdata->cal_type) {
 	case TYPE_TWO_POINT_TRIMMING:
-		temp_code = (temp - 25) *
-		    (data->temp_error2 - data->temp_error1) /
-		    (85 - 25) + data->temp_error1;
+		temp_code = (temp - pdata->first_point_trim) *
+			(data->temp_error2 - data->temp_error1) /
+			(pdata->second_point_trim - pdata->first_point_trim) +
+			data->temp_error1;
 		break;
 	case TYPE_ONE_POINT_TRIMMING:
-		temp_code = temp + data->temp_error1 - 25;
+		temp_code = temp + data->temp_error1 - pdata->first_point_trim;
 		break;
 	default:
-		temp_code = temp + EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET;
+		temp_code = temp + pdata->default_temp_offset;
 		break;
 	}
 out:
@@ -173,14 +170,16 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 
 	switch (pdata->cal_type) {
 	case TYPE_TWO_POINT_TRIMMING:
-		temp = (temp_code - data->temp_error1) * (85 - 25) /
-		    (data->temp_error2 - data->temp_error1) + 25;
+		temp = (temp_code - data->temp_error1) *
+			(pdata->second_point_trim - pdata->first_point_trim) /
+			(data->temp_error2 - data->temp_error1) +
+			pdata->first_point_trim;
 		break;
 	case TYPE_ONE_POINT_TRIMMING:
-		temp = temp_code - data->temp_error1 + 25;
+		temp = temp_code - data->temp_error1 + pdata->first_point_trim;
 		break;
 	default:
-		temp = temp_code - EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET;
+		temp = temp_code - pdata->default_temp_offset;
 		break;
 	}
 out:
@@ -213,8 +212,8 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	data->temp_error1 = trim_info & EXYNOS_TMU_TRIM_TEMP_MASK;
 	data->temp_error2 = ((trim_info >> 8) & EXYNOS_TMU_TRIM_TEMP_MASK);
 
-	if ((EFUSE_MIN_VALUE > data->temp_error1) ||
-			(data->temp_error1 > EFUSE_MAX_VALUE) ||
+	if ((pdata->min_efuse_value > data->temp_error1) ||
+			(data->temp_error1 > pdata->max_efuse_value) ||
 			(data->temp_error2 != 0))
 		data->temp_error1 = pdata->efuse_value;
 
@@ -304,10 +303,10 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 	if (on) {
 		con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
 		interrupt_en =
-		pdata->trigger_level3_en << EXYNOS_TMU_INTEN_RISE3_SHIFT |
-		pdata->trigger_level2_en << EXYNOS_TMU_INTEN_RISE2_SHIFT |
-		pdata->trigger_level1_en << EXYNOS_TMU_INTEN_RISE1_SHIFT |
-		pdata->trigger_level0_en << EXYNOS_TMU_INTEN_RISE0_SHIFT;
+		pdata->trigger_enable[3] << EXYNOS_TMU_INTEN_RISE3_SHIFT |
+		pdata->trigger_enable[2] << EXYNOS_TMU_INTEN_RISE2_SHIFT |
+		pdata->trigger_enable[1] << EXYNOS_TMU_INTEN_RISE1_SHIFT |
+		pdata->trigger_enable[0] << EXYNOS_TMU_INTEN_RISE0_SHIFT;
 		if (pdata->threshold_falling)
 			interrupt_en |=
 				interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
@@ -542,9 +541,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 
 	/* Register the sensor with thermal management interface */
 	(&exynos_sensor_conf)->private_data = data;
-	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
-			pdata->trigger_level1_en + pdata->trigger_level2_en +
-			pdata->trigger_level3_en;
+	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_enable[0] +
+			pdata->trigger_enable[1] + pdata->trigger_enable[2]+
+			pdata->trigger_enable[3];
 
 	for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
 		exynos_sensor_conf.trip_data.trip_val[i] =
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 342fb1f..70cc518 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -29,6 +29,17 @@ enum calibration_type {
 	TYPE_NONE,
 };
 
+enum calibration_mode {
+	SW_MODE,
+	HW_MODE,
+};
+
+enum trigger_type {
+	THROTTLE,
+	SW_TRIP,
+	HW_TRIP,
+};
+
 enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS,
@@ -54,18 +65,13 @@ enum soc_type {
  *	3: temperature for trigger_level3 interrupt
  *	   condition for trigger_level3 interrupt:
  *		current temperature > threshold + trigger_levels[3]
- * @trigger_level0_en:
- *	1 = enable trigger_level0 interrupt,
- *	0 = disable trigger_level0 interrupt
- * @trigger_level1_en:
- *	1 = enable trigger_level1 interrupt,
- *	0 = disable trigger_level1 interrupt
- * @trigger_level2_en:
- *	1 = enable trigger_level2 interrupt,
- *	0 = disable trigger_level2 interrupt
- * @trigger_level3_en:
- *	1 = enable trigger_level3 interrupt,
- *	0 = disable trigger_level3 interrupt
+ * @trigger_type: defines the type of trigger. Possible values are,
+ *	0: THROTTLE trigger type
+ *	1: SW_TRIP trigger type
+ *	2: HW_TRIP
+ * @trigger_enable[]: array to denote which trigger levels are enabled.
+ *	1 = enable trigger_level[] interrupt,
+ *	0 = disable trigger_level[] interrupt
  * @gain: gain of amplifier in the positive-TC generator block
  *	0 <= gain <= 15
  * @reference_voltage: reference voltage of amplifier
@@ -75,7 +81,13 @@ enum soc_type {
  *	000, 100, 101, 110 and 111 can be different modes
  * @type: determines the type of SOC
  * @efuse_value: platform defined fuse value
+ * @min_efuse_value: minimum valid trimming data
+ * @max_efuse_value: maximum valid trimming data
+ * @first_point_trim: temp value of the first point trimming
+ * @second_point_trim: temp value of the second point trimming
+ * @default_temp_offset: default temperature offset in case of no trimming
  * @cal_type: calibration type for temperature
+ * @cal_mode: calibration mode for temperature
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
  *	applicable to only some of the trigger levels.
@@ -85,18 +97,22 @@ enum soc_type {
 struct exynos_tmu_platform_data {
 	u8 threshold;
 	u8 threshold_falling;
-	u8 trigger_levels[4];
-	bool trigger_level0_en;
-	bool trigger_level1_en;
-	bool trigger_level2_en;
-	bool trigger_level3_en;
-
+	u8 trigger_levels[MAX_TRIP_COUNT];
+	enum trigger_type trigger_type[MAX_TRIP_COUNT];
+	bool trigger_enable[MAX_TRIP_COUNT];
 	u8 gain;
 	u8 reference_voltage;
 	u8 noise_cancel_mode;
+
 	u32 efuse_value;
+	u32 min_efuse_value;
+	u32 max_efuse_value;
+	u8 first_point_trim;
+	u8 second_point_trim;
+	u8 default_temp_offset;
 
 	enum calibration_type cal_type;
+	enum calibration_mode cal_mode;
 	enum soc_type type;
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 13a60ca..ee6a3c9 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -22,6 +22,7 @@
 
 #include "exynos_thermal_common.h"
 #include "exynos_tmu.h"
+#include "exynos_tmu_data.h"
 
 #if defined(CONFIG_CPU_EXYNOS4210)
 struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
@@ -29,13 +30,21 @@ struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
 	.trigger_levels[0] = 5,
 	.trigger_levels[1] = 20,
 	.trigger_levels[2] = 30,
-	.trigger_level0_en = 1,
-	.trigger_level1_en = 1,
-	.trigger_level2_en = 1,
-	.trigger_level3_en = 0,
+	.trigger_enable[0] = 1,
+	.trigger_enable[1] = 1,
+	.trigger_enable[2] = 1,
+	.trigger_enable[3] = 0,
+	.trigger_type[0] = 0,
+	.trigger_type[1] = 0,
+	.trigger_type[2] = 1,
 	.gain = 15,
 	.reference_voltage = 7,
 	.cal_type = TYPE_ONE_POINT_TRIMMING,
+	.min_efuse_value = 40,
+	.max_efuse_value = 100,
+	.first_point_trim = 25,
+	.second_point_trim = 85,
+	.default_temp_offset = 50,
 	.freq_tab[0] = {
 		.freq_clip_max = 800 * 1000,
 		.temp_level = 85,
@@ -55,15 +64,23 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
 	.trigger_levels[0] = 85,
 	.trigger_levels[1] = 103,
 	.trigger_levels[2] = 110,
-	.trigger_level0_en = 1,
-	.trigger_level1_en = 1,
-	.trigger_level2_en = 1,
-	.trigger_level3_en = 0,
+	.trigger_enable[0] = 1,
+	.trigger_enable[1] = 1,
+	.trigger_enable[2] = 1,
+	.trigger_enable[3] = 0,
+	.trigger_type[0] = 0,
+	.trigger_type[1] = 0,
+	.trigger_type[2] = 1,
 	.gain = 8,
 	.reference_voltage = 16,
 	.noise_cancel_mode = 4,
 	.cal_type = TYPE_ONE_POINT_TRIMMING,
 	.efuse_value = 55,
+	.min_efuse_value = 40,
+	.max_efuse_value = 100,
+	.first_point_trim = 25,
+	.second_point_trim = 85,
+	.default_temp_offset = 50,
 	.freq_tab[0] = {
 		.freq_clip_max = 800 * 1000,
 		.temp_level = 85,
-- 
1.7.1

