Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaEELSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:18:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54885 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaEELSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:18:39 -0400
X-AuditID: cbfee61b-b7f766d00000646c-27-5367738d207e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 04/10] thermal: exynos: remove dead code for
 TYPE_TWO_POINT_TRIMMING calibration
Date: Mon, 05 May 2014 13:15:33 +0200
Message-id: <1399288539-1793-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jAd3e4vRggz1nTC0aroZYbJyxntVi
	zf6fTBZnm96wW1zeNYfN4nPvEUaLGef3MVmcOX2J1eLJwz42i/UzXrM4cHks3vOSyWPL1XYW
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8ak5deYC275VmyftZipgfGiQxcjJ4eE
	gInE381T2CFsMYkL99azdTFycQgJLGKUmL1nHzuE08Uk0fWxnRmkik3ASmJi+ypGEFtEQE/i
	xosnTCBFzALHmSR+/j7PBpIQFkiSOLH0JZjNIqAq8XjRfLAGXgF3id5NL9gg1ilKdD+bAGZz
	CnhI7H/5GGyBEFDNwceTmScw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERx0z6R3
	MK5qsDjEKMDBqMTDm8CcHizEmlhWXJl7iFGCg1lJhDc7ESjEm5JYWZValB9fVJqTWnyIUZqD
	RUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBsWzmv9WWh59N2GXsYJR0x1zyIWdL411nvbOx
	d54s15kd15u31eGrQ9oCVdlJZw0e9tfWm4qyaOTrlqcq7s648OLNt8T8bVk5dxu/PzVbuE/W
	u4NV9wjry+3+PEdq/F4L/b4o+GHty4Trt8Q2iKY4sM37pnUnSP/n9bS+ez5visR8F60Syij/
	qMRSnJFoqMVcVJwIANA+aKM2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only TYPE_ONE_POINT_TRIMMING calibration is used so remove
the dead code for TYPE_TWO_POINT_TRIMMING calibration.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 55 ++++++-------------------------
 drivers/thermal/samsung/exynos_tmu.h      | 20 +----------
 drivers/thermal/samsung/exynos_tmu_data.c | 17 +---------
 drivers/thermal/samsung/exynos_tmu_data.h |  2 --
 4 files changed, 12 insertions(+), 82 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 9f2a5ee..903566f 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -47,8 +47,7 @@
  * @irq_work: pointer to the irq work structure.
  * @lock: lock to implement synchronization.
  * @clk: pointer to the clock structure.
- * @temp_error1: fused value of the first point trim.
- * @temp_error2: fused value of the second point trim.
+ * @temp_error: fused value of the first point trim.
  * @regulator: pointer to the TMU regulator structure.
  * @reg_conf: pointer to structure to register with core thermal.
  */
@@ -62,14 +61,13 @@ struct exynos_tmu_data {
 	struct work_struct irq_work;
 	struct mutex lock;
 	struct clk *clk;
-	u8 temp_error1, temp_error2;
+	u8 temp_error;
 	struct regulator *regulator;
 	struct thermal_sensor_conf *reg_conf;
 };
 
 /*
  * TMU treats temperature as a mapped temperature code.
- * The temperature is converted differently depending on the calibration type.
  */
 static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 {
@@ -83,20 +81,7 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 			goto out;
 		}
 
-	switch (pdata->cal_type) {
-	case TYPE_TWO_POINT_TRIMMING:
-		temp_code = (temp - pdata->first_point_trim) *
-			(data->temp_error2 - data->temp_error1) /
-			(pdata->second_point_trim - pdata->first_point_trim) +
-			data->temp_error1;
-		break;
-	case TYPE_ONE_POINT_TRIMMING:
-		temp_code = temp + data->temp_error1 - pdata->first_point_trim;
-		break;
-	default:
-		temp_code = temp + pdata->default_temp_offset;
-		break;
-	}
+	temp_code = temp + data->temp_error - pdata->first_point_trim;
 out:
 	return temp_code;
 }
@@ -117,20 +102,7 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 			goto out;
 		}
 
-	switch (pdata->cal_type) {
-	case TYPE_TWO_POINT_TRIMMING:
-		temp = (temp_code - data->temp_error1) *
-			(pdata->second_point_trim - pdata->first_point_trim) /
-			(data->temp_error2 - data->temp_error1) +
-			pdata->first_point_trim;
-		break;
-	case TYPE_ONE_POINT_TRIMMING:
-		temp = temp_code - data->temp_error1 + pdata->first_point_trim;
-		break;
-	default:
-		temp = temp_code - pdata->default_temp_offset;
-		break;
-	}
+	temp = temp_code - data->temp_error + pdata->first_point_trim;
 out:
 	return temp;
 }
@@ -179,19 +151,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	} else {
 		trim_info = readl(data->base + reg->triminfo_data);
 	}
-	data->temp_error1 = trim_info & EXYNOS_TMU_TEMP_MASK;
-	data->temp_error2 = ((trim_info >> reg->triminfo_85_shift) &
-				EXYNOS_TMU_TEMP_MASK);
-
-	if (!data->temp_error1 ||
-		(pdata->min_efuse_value > data->temp_error1) ||
-		(data->temp_error1 > pdata->max_efuse_value))
-		data->temp_error1 = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
-
-	if (!data->temp_error2)
-		data->temp_error2 =
-			(pdata->efuse_value >> reg->triminfo_85_shift) &
-			EXYNOS_TMU_TEMP_MASK;
+	data->temp_error = trim_info & EXYNOS_TMU_TEMP_MASK;
+
+	if (!data->temp_error ||
+	    pdata->min_efuse_value > data->temp_error ||
+	    data->temp_error > pdata->max_efuse_value)
+		data->temp_error = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
 
 	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
 		dev_err(&pdev->dev, "Invalid max trigger level\n");
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index e417af8..186e39e 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -26,14 +26,6 @@
 
 #include "exynos_thermal_common.h"
 
-enum calibration_type {
-	TYPE_ONE_POINT_TRIMMING,
-	TYPE_ONE_POINT_TRIMMING_25,
-	TYPE_ONE_POINT_TRIMMING_85,
-	TYPE_TWO_POINT_TRIMMING,
-	TYPE_NONE,
-};
-
 enum soc_type {
 	SOC_ARCH_EXYNOS4210 = 1,
 	SOC_ARCH_EXYNOS4412,
@@ -74,8 +66,6 @@ enum soc_type {
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
  * @triminfo_data: register containing 2 pont trimming data
- * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data reg.
- * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data reg.
  * @triminfo_ctrl: trim info controller register.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
@@ -116,8 +106,6 @@ enum soc_type {
  */
 struct exynos_tmu_registers {
 	u32	triminfo_data;
-	u32	triminfo_25_shift;
-	u32	triminfo_85_shift;
 
 	u32	triminfo_ctrl;
 
@@ -207,10 +195,7 @@ struct exynos_tmu_registers {
  * @min_efuse_value: minimum valid trimming data
  * @max_efuse_value: maximum valid trimming data
  * @first_point_trim: temp value of the first point trimming
- * @second_point_trim: temp value of the second point trimming
- * @default_temp_offset: default temperature offset in case of no trimming
  * @test_mux; information if SoC supports test MUX
- * @cal_type: calibration type for temperature
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
  *	applicable to only some of the trigger levels.
@@ -232,15 +217,12 @@ struct exynos_tmu_platform_data {
 	u8 reference_voltage;
 	u8 noise_cancel_mode;
 
-	u32 efuse_value;
+	u8 efuse_value;
 	u32 min_efuse_value;
 	u32 max_efuse_value;
 	u8 first_point_trim;
-	u8 second_point_trim;
-	u8 default_temp_offset;
 	u8 test_mux;
 
-	enum calibration_type cal_type;
 	enum soc_type type;
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 4b992d9..c32d186 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -27,8 +27,6 @@
 #if defined(CONFIG_CPU_EXYNOS4210)
 static const struct exynos_tmu_registers exynos4210_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
 	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
@@ -66,12 +64,9 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		.max_trigger_level = 4,
 		.gain = 15,
 		.reference_voltage = 7,
-		.cal_type = TYPE_ONE_POINT_TRIMMING,
 		.min_efuse_value = 40,
 		.max_efuse_value = 100,
 		.first_point_trim = 25,
-		.second_point_trim = 85,
-		.default_temp_offset = 50,
 		.freq_tab[0] = {
 			.freq_clip_max = 800 * 1000,
 			.temp_level = 85,
@@ -93,8 +88,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.triminfo_ctrl = EXYNOS_TMU_TRIMINFO_CON,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
@@ -145,13 +138,10 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.gain = 8, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
-	.cal_type = TYPE_ONE_POINT_TRIMMING, \
 	.efuse_value = 55, \
 	.min_efuse_value = 40, \
 	.max_efuse_value = 100, \
 	.first_point_trim = 25, \
-	.second_point_trim = 85, \
-	.default_temp_offset = 50, \
 	.freq_tab[0] = { \
 		.freq_clip_max = 1400 * 1000, \
 		.temp_level = 70, \
@@ -195,8 +185,6 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
 	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
@@ -240,13 +228,10 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.gain = 5, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
-	.cal_type = TYPE_ONE_POINT_TRIMMING, \
-	.efuse_value = 0x5b2d, \
+	.efuse_value = 45, \
 	.min_efuse_value = 16, \
 	.max_efuse_value = 76, \
 	.first_point_trim = 25, \
-	.second_point_trim = 70, \
-	.default_temp_offset = 25, \
 	.type = SOC_ARCH_EXYNOS5440, \
 	.registers = &exynos5440_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index 1fed00d..734d1f9 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -51,8 +51,6 @@
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
 
-#define EXYNOS_TRIMINFO_25_SHIFT	0
-#define EXYNOS_TRIMINFO_85_SHIFT	8
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
 #define EXYNOS_TMU_RISE_INT_SHIFT	0
 #define EXYNOS_TMU_FALL_INT_MASK	0x111
-- 
1.8.2.3

