Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964936AbaFQR3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:29:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45506 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933555AbaFQR3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:29:52 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-d1-53a07b0d44c5
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 3/9] thermal: exynos: remove dead code for
 TYPE_TWO_POINT_TRIMMING calibration
Date: Tue, 17 Jun 2014 19:27:19 +0200
Message-id: <1403026045-16024-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jQV3e6gXBBs0nTSwaroZYbJyxntVi
	zf6fTBZnm96wW1zeNYfN4nPvEUaLGef3MVmcOX2J1eLJwz42i/UzXrM4cHks3vOSyWPL1XYW
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8b3h/PYCmZlVBy8sZ6lgfFQWBcjJ4eE
	gInElFdfmSFsMYkL99azdTFycQgJTGeUuPVxNlhCSKCLSWLns3oQm03ASmJi+ypGEFtEQE/i
	xosnTCANzALHmSR+/j7PBpIQFkiWOPfoFhOIzSKgKvHzTg8riM0r4CHR9uY0O8Q2RYnuZxPA
	6jkFPCVu3Gthg1jmITH/YifTBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCQ+6Z
	1A7GlQ0WhxgFOBiVeHg5chcEC7EmlhVX5h5ilOBgVhLhPZcFFOJNSaysSi3Kjy8qzUktPsQo
	zcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cB4tjJIROPjsu46ydbXufVzmo40H5uuYHl7
	vULj6UCfmIpXuoxsTZ1fX9Vns5/b90HQwCXcKont3avOKrsvTCUMLd/vZuXZbndie152PzDE
	/DRjxO8K2xnW5/olVRYfvSfLMEeZb5cga0pYjqP5Pyf+a7VnXi4L5Eiq+fLgu9ha5V9rZy4x
	L1BiKc5INNRiLipOBADpoC0BNQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two types of calibration (TYPE_[ONE,TWO]_POINT_TRIMMING)
implemented in the driver currently, the other ones are defined in
calibration_type enum but are not implemented.

The commit 9d97e5c8 ("hwmon: Add driver for EXYNOS4 TMU") added
TYPE_TWO_POINT_TRIMMING implementation but no users of it have
ever been added.  Thus it has been a dead code for almost 3 years
now and should be removed.

We don't keep the unused/untested features in the kernel just
in case that some future hardware might need it.  Such code has
a real maintainance cost (all other code changes have to take
the dead code into account) and usually makes future changes
more difficult, not easier (i.e. recent additions of Exynos5420
SoC and Exynos5260 SoC thermal support has not made use of any
of the driver's currently unused/untested features, moreover
the recently added code is more complex than needed because of
the existing dead code).  Also all removed dead code is still
accessible in the kernel git repository and can be easily
brought back if/when needed.

This patch does TYPE_TWO_POINT_TRIMMING and related dead code
removals.

Please note that in exynos_tmu_initialize() if ->temp_error2 was
zero then its value was obtained from bits 8-15 of efuse_value
(bits 16-31 are always zero).  After TYPE_TWO_POINT_TRIMMING code
removal ->temp_error2 was no longer needed and was also removed.
Thus only bits 0-7 of efuse_value are ever used and its type can
be changed from u32 to u8.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 55 ++++++-------------------------
 drivers/thermal/samsung/exynos_tmu.h      | 20 +----------
 drivers/thermal/samsung/exynos_tmu_data.c | 27 +--------------
 drivers/thermal/samsung/exynos_tmu_data.h |  2 --
 4 files changed, 12 insertions(+), 92 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 1050b36..1c64508 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -48,8 +48,7 @@
  * @lock: lock to implement synchronization.
  * @clk: pointer to the clock structure.
  * @clk_sec: pointer to the clock structure for accessing the base_second.
- * @temp_error1: fused value of the first point trim.
- * @temp_error2: fused value of the second point trim.
+ * @temp_error: fused value of the first point trim.
  * @regulator: pointer to the TMU regulator structure.
  * @reg_conf: pointer to structure to register with core thermal.
  */
@@ -63,14 +62,13 @@ struct exynos_tmu_data {
 	struct work_struct irq_work;
 	struct mutex lock;
 	struct clk *clk, *clk_sec;
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
@@ -84,20 +82,7 @@ static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
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
@@ -118,20 +103,7 @@ static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
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
@@ -187,19 +159,12 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		else
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
index 86c5531..60ecc61 100644
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
@@ -76,8 +68,6 @@ enum soc_type {
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
  * @triminfo_data: register containing 2 pont trimming data
- * @triminfo_25_shift: shift bit of the 25 C trim value in triminfo_data reg.
- * @triminfo_85_shift: shift bit of the 85 C trim value in triminfo_data reg.
  * @triminfo_ctrl: trim info controller register.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
@@ -118,8 +108,6 @@ enum soc_type {
  */
 struct exynos_tmu_registers {
 	u32	triminfo_data;
-	u32	triminfo_25_shift;
-	u32	triminfo_85_shift;
 
 	u32	triminfo_ctrl;
 	u32	triminfo_ctrl1;
@@ -210,10 +198,7 @@ struct exynos_tmu_registers {
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
@@ -235,15 +220,12 @@ struct exynos_tmu_platform_data {
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
index 3349e13..7a9cee5 100644
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
 #if defined(CONFIG_SOC_EXYNOS5260)
 static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL1,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
@@ -246,13 +234,10 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
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
 		.freq_clip_max = 800 * 1000, \
 		.temp_level = 85, \
@@ -286,8 +271,6 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5420)
 static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
 	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
@@ -337,13 +320,10 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
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
 		.freq_clip_max = 800 * 1000, \
 		.temp_level = 85, \
@@ -384,8 +364,6 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 #if defined(CONFIG_SOC_EXYNOS5440)
 static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
-	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
-	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
 	.tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
 	.buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
 	.buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
@@ -429,13 +407,10 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
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
index dd8d659..1f5d226 100644
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

