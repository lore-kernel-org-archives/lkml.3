Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab3BZW7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:59:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33317 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738Ab3BZW7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:59:03 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 14/15] staging: omap-thermal: name data files accordingly
Date: Tue, 26 Feb 2013 18:53:37 -0400
Message-ID: <1361919218-9788-15-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply changes the name of files containing data structure definition.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/Makefile             |    4 +-
 drivers/staging/omap-thermal/omap4-thermal-data.c |  262 +++++++++++++++
 drivers/staging/omap-thermal/omap4-thermal.c      |  262 ---------------
 drivers/staging/omap-thermal/omap5-thermal-data.c |  357 +++++++++++++++++++++
 drivers/staging/omap-thermal/omap5-thermal.c      |  357 ---------------------
 5 files changed, 621 insertions(+), 621 deletions(-)
 create mode 100644 drivers/staging/omap-thermal/omap4-thermal-data.c
 delete mode 100644 drivers/staging/omap-thermal/omap4-thermal.c
 create mode 100644 drivers/staging/omap-thermal/omap5-thermal-data.c
 delete mode 100644 drivers/staging/omap-thermal/omap5-thermal.c

diff --git a/drivers/staging/omap-thermal/Makefile b/drivers/staging/omap-thermal/Makefile
index 091c4d2..fbd14d1 100644
--- a/drivers/staging/omap-thermal/Makefile
+++ b/drivers/staging/omap-thermal/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_OMAP_BANDGAP)	+= omap-thermal.o
 omap-thermal-y			:= omap-bandgap.o
 omap-thermal-$(CONFIG_OMAP_THERMAL)	+= omap-thermal-common.o
-omap-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal.o
-omap-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal.o
+omap-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
+omap-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/staging/omap-thermal/omap4-thermal-data.c b/drivers/staging/omap-thermal/omap4-thermal-data.c
new file mode 100644
index 0000000..732c853
--- /dev/null
+++ b/drivers/staging/omap-thermal/omap4-thermal-data.c
@@ -0,0 +1,262 @@
+/*
+ * OMAP4 thermal driver.
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Inc.
+ * Contact:
+ *	Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include "omap-thermal.h"
+#include "omap-bandgap.h"
+
+/*
+ * OMAP4430 has one instance of thermal sensor for MPU
+ * need to describe the individual bit fields
+ */
+static struct temp_sensor_registers
+omap4430_mpu_temp_sensor_registers = {
+	.temp_sensor_ctrl = OMAP4430_TEMP_SENSOR_CTRL_OFFSET,
+	.bgap_tempsoff_mask = OMAP4430_BGAP_TEMPSOFF_MASK,
+	.bgap_soc_mask = OMAP4430_BGAP_TEMP_SENSOR_SOC_MASK,
+	.bgap_eocz_mask = OMAP4430_BGAP_TEMP_SENSOR_EOCZ_MASK,
+	.bgap_dtemp_mask = OMAP4430_BGAP_TEMP_SENSOR_DTEMP_MASK,
+
+	.bgap_mode_ctrl = OMAP4430_TEMP_SENSOR_CTRL_OFFSET,
+	.mode_ctrl_mask = OMAP4430_SINGLE_MODE_MASK,
+
+	.bgap_efuse = OMAP4430_FUSE_OPP_BGAP,
+};
+
+/* Thresholds and limits for OMAP4430 MPU temperature sensor */
+static struct temp_sensor_data omap4430_mpu_temp_sensor_data = {
+	.min_freq = OMAP4430_MIN_FREQ,
+	.max_freq = OMAP4430_MAX_FREQ,
+	.max_temp = OMAP4430_MAX_TEMP,
+	.min_temp = OMAP4430_MIN_TEMP,
+	.hyst_val = OMAP4430_HYST_VAL,
+	.adc_start_val = OMAP4430_ADC_START_VALUE,
+	.adc_end_val = OMAP4430_ADC_END_VALUE,
+};
+
+/*
+ * Temperature values in milli degree celsius
+ * ADC code values from 530 to 923
+ */
+static const int
+omap4430_adc_to_temp[OMAP4430_ADC_END_VALUE - OMAP4430_ADC_START_VALUE + 1] = {
+	-38000, -35000, -34000, -32000, -30000, -28000, -26000, -24000, -22000,
+	-20000, -18000, -17000, -15000, -13000, -12000, -10000, -8000, -6000,
+	-5000, -3000, -1000, 0, 2000, 3000, 5000, 6000, 8000, 10000, 12000,
+	13000, 15000, 17000, 19000, 21000, 23000, 25000, 27000, 28000, 30000,
+	32000, 33000, 35000, 37000, 38000, 40000, 42000, 43000, 45000, 47000,
+	48000, 50000, 52000, 53000, 55000, 57000, 58000, 60000, 62000, 64000,
+	66000, 68000, 70000, 71000, 73000, 75000, 77000, 78000, 80000, 82000,
+	83000, 85000, 87000, 88000, 90000, 92000, 93000, 95000, 97000, 98000,
+	100000, 102000, 103000, 105000, 107000, 109000, 111000, 113000, 115000,
+	117000, 118000, 120000, 122000, 123000,
+};
+
+/* OMAP4430 data */
+const struct omap_bandgap_data omap4430_data = {
+	.features = OMAP_BANDGAP_FEATURE_MODE_CONFIG |
+			OMAP_BANDGAP_FEATURE_CLK_CTRL |
+			OMAP_BANDGAP_FEATURE_POWER_SWITCH,
+	.fclock_name = "bandgap_fclk",
+	.div_ck_name = "bandgap_fclk",
+	.conv_table = omap4430_adc_to_temp,
+	.expose_sensor = omap_thermal_expose_sensor,
+	.remove_sensor = omap_thermal_remove_sensor,
+	.sensors = {
+		{
+		.registers = &omap4430_mpu_temp_sensor_registers,
+		.ts_data = &omap4430_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.slope = 0,
+		.constant = 20000,
+		.slope_pcb = 0,
+		.constant_pcb = 20000,
+		.register_cooling = omap_thermal_register_cpu_cooling,
+		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		},
+	},
+	.sensor_count = 1,
+};
+/*
+ * OMAP4460 has one instance of thermal sensor for MPU
+ * need to describe the individual bit fields
+ */
+static struct temp_sensor_registers
+omap4460_mpu_temp_sensor_registers = {
+	.temp_sensor_ctrl = OMAP4460_TEMP_SENSOR_CTRL_OFFSET,
+	.bgap_tempsoff_mask = OMAP4460_BGAP_TEMPSOFF_MASK,
+	.bgap_soc_mask = OMAP4460_BGAP_TEMP_SENSOR_SOC_MASK,
+	.bgap_eocz_mask = OMAP4460_BGAP_TEMP_SENSOR_EOCZ_MASK,
+	.bgap_dtemp_mask = OMAP4460_BGAP_TEMP_SENSOR_DTEMP_MASK,
+
+	.bgap_mask_ctrl = OMAP4460_BGAP_CTRL_OFFSET,
+	.mask_hot_mask = OMAP4460_MASK_HOT_MASK,
+	.mask_cold_mask = OMAP4460_MASK_COLD_MASK,
+
+	.bgap_mode_ctrl = OMAP4460_BGAP_CTRL_OFFSET,
+	.mode_ctrl_mask = OMAP4460_SINGLE_MODE_MASK,
+
+	.bgap_counter = OMAP4460_BGAP_COUNTER_OFFSET,
+	.counter_mask = OMAP4460_COUNTER_MASK,
+
+	.bgap_threshold = OMAP4460_BGAP_THRESHOLD_OFFSET,
+	.threshold_thot_mask = OMAP4460_T_HOT_MASK,
+	.threshold_tcold_mask = OMAP4460_T_COLD_MASK,
+
+	.tshut_threshold = OMAP4460_BGAP_TSHUT_OFFSET,
+	.tshut_hot_mask = OMAP4460_TSHUT_HOT_MASK,
+	.tshut_cold_mask = OMAP4460_TSHUT_COLD_MASK,
+
+	.bgap_status = OMAP4460_BGAP_STATUS_OFFSET,
+	.status_clean_stop_mask = OMAP4460_CLEAN_STOP_MASK,
+	.status_bgap_alert_mask = OMAP4460_BGAP_ALERT_MASK,
+	.status_hot_mask = OMAP4460_HOT_FLAG_MASK,
+	.status_cold_mask = OMAP4460_COLD_FLAG_MASK,
+
+	.bgap_efuse = OMAP4460_FUSE_OPP_BGAP,
+};
+
+/* Thresholds and limits for OMAP4460 MPU temperature sensor */
+static struct temp_sensor_data omap4460_mpu_temp_sensor_data = {
+	.tshut_hot = OMAP4460_TSHUT_HOT,
+	.tshut_cold = OMAP4460_TSHUT_COLD,
+	.t_hot = OMAP4460_T_HOT,
+	.t_cold = OMAP4460_T_COLD,
+	.min_freq = OMAP4460_MIN_FREQ,
+	.max_freq = OMAP4460_MAX_FREQ,
+	.max_temp = OMAP4460_MAX_TEMP,
+	.min_temp = OMAP4460_MIN_TEMP,
+	.hyst_val = OMAP4460_HYST_VAL,
+	.adc_start_val = OMAP4460_ADC_START_VALUE,
+	.adc_end_val = OMAP4460_ADC_END_VALUE,
+	.update_int1 = 1000,
+	.update_int2 = 2000,
+};
+
+/*
+ * Temperature values in milli degree celsius
+ * ADC code values from 530 to 923
+ */
+static const int
+omap4460_adc_to_temp[OMAP4460_ADC_END_VALUE - OMAP4460_ADC_START_VALUE + 1] = {
+	-40000, -40000, -40000, -40000, -39800, -39400, -39000, -38600, -38200,
+	-37800, -37300, -36800, -36400, -36000, -35600, -35200, -34800,
+	-34300, -33800, -33400, -33000, -32600, -32200, -31800, -31300,
+	-30800, -30400, -30000, -29600, -29200, -28700, -28200, -27800,
+	-27400, -27000, -26600, -26200, -25700, -25200, -24800, -24400,
+	-24000, -23600, -23200, -22700, -22200, -21800, -21400, -21000,
+	-20600, -20200, -19700, -19200, -18800, -18400, -18000, -17600,
+	-17200, -16700, -16200, -15800, -15400, -15000, -14600, -14200,
+	-13700, -13200, -12800, -12400, -12000, -11600, -11200, -10700,
+	-10200, -9800, -9400, -9000, -8600, -8200, -7700, -7200, -6800,
+	-6400, -6000, -5600, -5200, -4800, -4300, -3800, -3400, -3000,
+	-2600, -2200, -1800, -1300, -800, -400, 0, 400, 800, 1200, 1600,
+	2100, 2600, 3000, 3400, 3800, 4200, 4600, 5100, 5600, 6000, 6400,
+	6800, 7200, 7600, 8000, 8500, 9000, 9400, 9800, 10200, 10600, 11000,
+	11400, 11900, 12400, 12800, 13200, 13600, 14000, 14400, 14800,
+	15300, 15800, 16200, 16600, 17000, 17400, 17800, 18200, 18700,
+	19200, 19600, 20000, 20400, 20800, 21200, 21600, 22100, 22600,
+	23000, 23400, 23800, 24200, 24600, 25000, 25400, 25900, 26400,
+	26800, 27200, 27600, 28000, 28400, 28800, 29300, 29800, 30200,
+	30600, 31000, 31400, 31800, 32200, 32600, 33100, 33600, 34000,
+	34400, 34800, 35200, 35600, 36000, 36400, 36800, 37300, 37800,
+	38200, 38600, 39000, 39400, 39800, 40200, 40600, 41100, 41600,
+	42000, 42400, 42800, 43200, 43600, 44000, 44400, 44800, 45300,
+	45800, 46200, 46600, 47000, 47400, 47800, 48200, 48600, 49000,
+	49500, 50000, 50400, 50800, 51200, 51600, 52000, 52400, 52800,
+	53200, 53700, 54200, 54600, 55000, 55400, 55800, 56200, 56600,
+	57000, 57400, 57800, 58200, 58700, 59200, 59600, 60000, 60400,
+	60800, 61200, 61600, 62000, 62400, 62800, 63300, 63800, 64200,
+	64600, 65000, 65400, 65800, 66200, 66600, 67000, 67400, 67800,
+	68200, 68700, 69200, 69600, 70000, 70400, 70800, 71200, 71600,
+	72000, 72400, 72800, 73200, 73600, 74100, 74600, 75000, 75400,
+	75800, 76200, 76600, 77000, 77400, 77800, 78200, 78600, 79000,
+	79400, 79800, 80300, 80800, 81200, 81600, 82000, 82400, 82800,
+	83200, 83600, 84000, 84400, 84800, 85200, 85600, 86000, 86400,
+	86800, 87300, 87800, 88200, 88600, 89000, 89400, 89800, 90200,
+	90600, 91000, 91400, 91800, 92200, 92600, 93000, 93400, 93800,
+	94200, 94600, 95000, 95500, 96000, 96400, 96800, 97200, 97600,
+	98000, 98400, 98800, 99200, 99600, 100000, 100400, 100800, 101200,
+	101600, 102000, 102400, 102800, 103200, 103600, 104000, 104400,
+	104800, 105200, 105600, 106100, 106600, 107000, 107400, 107800,
+	108200, 108600, 109000, 109400, 109800, 110200, 110600, 111000,
+	111400, 111800, 112200, 112600, 113000, 113400, 113800, 114200,
+	114600, 115000, 115400, 115800, 116200, 116600, 117000, 117400,
+	117800, 118200, 118600, 119000, 119400, 119800, 120200, 120600,
+	121000, 121400, 121800, 122200, 122600, 123000, 123400, 123800, 124200,
+	124600, 124900, 125000, 125000, 125000, 125000
+};
+
+/* OMAP4460 data */
+const struct omap_bandgap_data omap4460_data = {
+	.features = OMAP_BANDGAP_FEATURE_TSHUT |
+			OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
+			OMAP_BANDGAP_FEATURE_TALERT |
+			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
+			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
+			OMAP_BANDGAP_FEATURE_CLK_CTRL |
+			OMAP_BANDGAP_FEATURE_COUNTER,
+	.fclock_name = "bandgap_ts_fclk",
+	.div_ck_name = "div_ts_ck",
+	.conv_table = omap4460_adc_to_temp,
+	.expose_sensor = omap_thermal_expose_sensor,
+	.remove_sensor = omap_thermal_remove_sensor,
+	.sensors = {
+		{
+		.registers = &omap4460_mpu_temp_sensor_registers,
+		.ts_data = &omap4460_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.slope = OMAP_GRADIENT_SLOPE_4460,
+		.constant = OMAP_GRADIENT_CONST_4460,
+		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4460,
+		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4460,
+		.register_cooling = omap_thermal_register_cpu_cooling,
+		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		},
+	},
+	.sensor_count = 1,
+};
+
+/* OMAP4470 data */
+const struct omap_bandgap_data omap4470_data = {
+	.features = OMAP_BANDGAP_FEATURE_TSHUT |
+			OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
+			OMAP_BANDGAP_FEATURE_TALERT |
+			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
+			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
+			OMAP_BANDGAP_FEATURE_CLK_CTRL |
+			OMAP_BANDGAP_FEATURE_COUNTER,
+	.fclock_name = "bandgap_ts_fclk",
+	.div_ck_name = "div_ts_ck",
+	.conv_table = omap4460_adc_to_temp,
+	.expose_sensor = omap_thermal_expose_sensor,
+	.remove_sensor = omap_thermal_remove_sensor,
+	.sensors = {
+		{
+		.registers = &omap4460_mpu_temp_sensor_registers,
+		.ts_data = &omap4460_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.slope = OMAP_GRADIENT_SLOPE_4470,
+		.constant = OMAP_GRADIENT_CONST_4470,
+		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4470,
+		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4470,
+		.register_cooling = omap_thermal_register_cpu_cooling,
+		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		},
+	},
+	.sensor_count = 1,
+};
diff --git a/drivers/staging/omap-thermal/omap4-thermal.c b/drivers/staging/omap-thermal/omap4-thermal.c
deleted file mode 100644
index 732c853..0000000
--- a/drivers/staging/omap-thermal/omap4-thermal.c
+++ /dev/null
@@ -1,262 +0,0 @@
-/*
- * OMAP4 thermal driver.
- *
- * Copyright (C) 2011-2012 Texas Instruments Inc.
- * Contact:
- *	Eduardo Valentin <eduardo.valentin@ti.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- */
-
-#include "omap-thermal.h"
-#include "omap-bandgap.h"
-
-/*
- * OMAP4430 has one instance of thermal sensor for MPU
- * need to describe the individual bit fields
- */
-static struct temp_sensor_registers
-omap4430_mpu_temp_sensor_registers = {
-	.temp_sensor_ctrl = OMAP4430_TEMP_SENSOR_CTRL_OFFSET,
-	.bgap_tempsoff_mask = OMAP4430_BGAP_TEMPSOFF_MASK,
-	.bgap_soc_mask = OMAP4430_BGAP_TEMP_SENSOR_SOC_MASK,
-	.bgap_eocz_mask = OMAP4430_BGAP_TEMP_SENSOR_EOCZ_MASK,
-	.bgap_dtemp_mask = OMAP4430_BGAP_TEMP_SENSOR_DTEMP_MASK,
-
-	.bgap_mode_ctrl = OMAP4430_TEMP_SENSOR_CTRL_OFFSET,
-	.mode_ctrl_mask = OMAP4430_SINGLE_MODE_MASK,
-
-	.bgap_efuse = OMAP4430_FUSE_OPP_BGAP,
-};
-
-/* Thresholds and limits for OMAP4430 MPU temperature sensor */
-static struct temp_sensor_data omap4430_mpu_temp_sensor_data = {
-	.min_freq = OMAP4430_MIN_FREQ,
-	.max_freq = OMAP4430_MAX_FREQ,
-	.max_temp = OMAP4430_MAX_TEMP,
-	.min_temp = OMAP4430_MIN_TEMP,
-	.hyst_val = OMAP4430_HYST_VAL,
-	.adc_start_val = OMAP4430_ADC_START_VALUE,
-	.adc_end_val = OMAP4430_ADC_END_VALUE,
-};
-
-/*
- * Temperature values in milli degree celsius
- * ADC code values from 530 to 923
- */
-static const int
-omap4430_adc_to_temp[OMAP4430_ADC_END_VALUE - OMAP4430_ADC_START_VALUE + 1] = {
-	-38000, -35000, -34000, -32000, -30000, -28000, -26000, -24000, -22000,
-	-20000, -18000, -17000, -15000, -13000, -12000, -10000, -8000, -6000,
-	-5000, -3000, -1000, 0, 2000, 3000, 5000, 6000, 8000, 10000, 12000,
-	13000, 15000, 17000, 19000, 21000, 23000, 25000, 27000, 28000, 30000,
-	32000, 33000, 35000, 37000, 38000, 40000, 42000, 43000, 45000, 47000,
-	48000, 50000, 52000, 53000, 55000, 57000, 58000, 60000, 62000, 64000,
-	66000, 68000, 70000, 71000, 73000, 75000, 77000, 78000, 80000, 82000,
-	83000, 85000, 87000, 88000, 90000, 92000, 93000, 95000, 97000, 98000,
-	100000, 102000, 103000, 105000, 107000, 109000, 111000, 113000, 115000,
-	117000, 118000, 120000, 122000, 123000,
-};
-
-/* OMAP4430 data */
-const struct omap_bandgap_data omap4430_data = {
-	.features = OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH,
-	.fclock_name = "bandgap_fclk",
-	.div_ck_name = "bandgap_fclk",
-	.conv_table = omap4430_adc_to_temp,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
-	.sensors = {
-		{
-		.registers = &omap4430_mpu_temp_sensor_registers,
-		.ts_data = &omap4430_mpu_temp_sensor_data,
-		.domain = "cpu",
-		.slope = 0,
-		.constant = 20000,
-		.slope_pcb = 0,
-		.constant_pcb = 20000,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
-		},
-	},
-	.sensor_count = 1,
-};
-/*
- * OMAP4460 has one instance of thermal sensor for MPU
- * need to describe the individual bit fields
- */
-static struct temp_sensor_registers
-omap4460_mpu_temp_sensor_registers = {
-	.temp_sensor_ctrl = OMAP4460_TEMP_SENSOR_CTRL_OFFSET,
-	.bgap_tempsoff_mask = OMAP4460_BGAP_TEMPSOFF_MASK,
-	.bgap_soc_mask = OMAP4460_BGAP_TEMP_SENSOR_SOC_MASK,
-	.bgap_eocz_mask = OMAP4460_BGAP_TEMP_SENSOR_EOCZ_MASK,
-	.bgap_dtemp_mask = OMAP4460_BGAP_TEMP_SENSOR_DTEMP_MASK,
-
-	.bgap_mask_ctrl = OMAP4460_BGAP_CTRL_OFFSET,
-	.mask_hot_mask = OMAP4460_MASK_HOT_MASK,
-	.mask_cold_mask = OMAP4460_MASK_COLD_MASK,
-
-	.bgap_mode_ctrl = OMAP4460_BGAP_CTRL_OFFSET,
-	.mode_ctrl_mask = OMAP4460_SINGLE_MODE_MASK,
-
-	.bgap_counter = OMAP4460_BGAP_COUNTER_OFFSET,
-	.counter_mask = OMAP4460_COUNTER_MASK,
-
-	.bgap_threshold = OMAP4460_BGAP_THRESHOLD_OFFSET,
-	.threshold_thot_mask = OMAP4460_T_HOT_MASK,
-	.threshold_tcold_mask = OMAP4460_T_COLD_MASK,
-
-	.tshut_threshold = OMAP4460_BGAP_TSHUT_OFFSET,
-	.tshut_hot_mask = OMAP4460_TSHUT_HOT_MASK,
-	.tshut_cold_mask = OMAP4460_TSHUT_COLD_MASK,
-
-	.bgap_status = OMAP4460_BGAP_STATUS_OFFSET,
-	.status_clean_stop_mask = OMAP4460_CLEAN_STOP_MASK,
-	.status_bgap_alert_mask = OMAP4460_BGAP_ALERT_MASK,
-	.status_hot_mask = OMAP4460_HOT_FLAG_MASK,
-	.status_cold_mask = OMAP4460_COLD_FLAG_MASK,
-
-	.bgap_efuse = OMAP4460_FUSE_OPP_BGAP,
-};
-
-/* Thresholds and limits for OMAP4460 MPU temperature sensor */
-static struct temp_sensor_data omap4460_mpu_temp_sensor_data = {
-	.tshut_hot = OMAP4460_TSHUT_HOT,
-	.tshut_cold = OMAP4460_TSHUT_COLD,
-	.t_hot = OMAP4460_T_HOT,
-	.t_cold = OMAP4460_T_COLD,
-	.min_freq = OMAP4460_MIN_FREQ,
-	.max_freq = OMAP4460_MAX_FREQ,
-	.max_temp = OMAP4460_MAX_TEMP,
-	.min_temp = OMAP4460_MIN_TEMP,
-	.hyst_val = OMAP4460_HYST_VAL,
-	.adc_start_val = OMAP4460_ADC_START_VALUE,
-	.adc_end_val = OMAP4460_ADC_END_VALUE,
-	.update_int1 = 1000,
-	.update_int2 = 2000,
-};
-
-/*
- * Temperature values in milli degree celsius
- * ADC code values from 530 to 923
- */
-static const int
-omap4460_adc_to_temp[OMAP4460_ADC_END_VALUE - OMAP4460_ADC_START_VALUE + 1] = {
-	-40000, -40000, -40000, -40000, -39800, -39400, -39000, -38600, -38200,
-	-37800, -37300, -36800, -36400, -36000, -35600, -35200, -34800,
-	-34300, -33800, -33400, -33000, -32600, -32200, -31800, -31300,
-	-30800, -30400, -30000, -29600, -29200, -28700, -28200, -27800,
-	-27400, -27000, -26600, -26200, -25700, -25200, -24800, -24400,
-	-24000, -23600, -23200, -22700, -22200, -21800, -21400, -21000,
-	-20600, -20200, -19700, -19200, -18800, -18400, -18000, -17600,
-	-17200, -16700, -16200, -15800, -15400, -15000, -14600, -14200,
-	-13700, -13200, -12800, -12400, -12000, -11600, -11200, -10700,
-	-10200, -9800, -9400, -9000, -8600, -8200, -7700, -7200, -6800,
-	-6400, -6000, -5600, -5200, -4800, -4300, -3800, -3400, -3000,
-	-2600, -2200, -1800, -1300, -800, -400, 0, 400, 800, 1200, 1600,
-	2100, 2600, 3000, 3400, 3800, 4200, 4600, 5100, 5600, 6000, 6400,
-	6800, 7200, 7600, 8000, 8500, 9000, 9400, 9800, 10200, 10600, 11000,
-	11400, 11900, 12400, 12800, 13200, 13600, 14000, 14400, 14800,
-	15300, 15800, 16200, 16600, 17000, 17400, 17800, 18200, 18700,
-	19200, 19600, 20000, 20400, 20800, 21200, 21600, 22100, 22600,
-	23000, 23400, 23800, 24200, 24600, 25000, 25400, 25900, 26400,
-	26800, 27200, 27600, 28000, 28400, 28800, 29300, 29800, 30200,
-	30600, 31000, 31400, 31800, 32200, 32600, 33100, 33600, 34000,
-	34400, 34800, 35200, 35600, 36000, 36400, 36800, 37300, 37800,
-	38200, 38600, 39000, 39400, 39800, 40200, 40600, 41100, 41600,
-	42000, 42400, 42800, 43200, 43600, 44000, 44400, 44800, 45300,
-	45800, 46200, 46600, 47000, 47400, 47800, 48200, 48600, 49000,
-	49500, 50000, 50400, 50800, 51200, 51600, 52000, 52400, 52800,
-	53200, 53700, 54200, 54600, 55000, 55400, 55800, 56200, 56600,
-	57000, 57400, 57800, 58200, 58700, 59200, 59600, 60000, 60400,
-	60800, 61200, 61600, 62000, 62400, 62800, 63300, 63800, 64200,
-	64600, 65000, 65400, 65800, 66200, 66600, 67000, 67400, 67800,
-	68200, 68700, 69200, 69600, 70000, 70400, 70800, 71200, 71600,
-	72000, 72400, 72800, 73200, 73600, 74100, 74600, 75000, 75400,
-	75800, 76200, 76600, 77000, 77400, 77800, 78200, 78600, 79000,
-	79400, 79800, 80300, 80800, 81200, 81600, 82000, 82400, 82800,
-	83200, 83600, 84000, 84400, 84800, 85200, 85600, 86000, 86400,
-	86800, 87300, 87800, 88200, 88600, 89000, 89400, 89800, 90200,
-	90600, 91000, 91400, 91800, 92200, 92600, 93000, 93400, 93800,
-	94200, 94600, 95000, 95500, 96000, 96400, 96800, 97200, 97600,
-	98000, 98400, 98800, 99200, 99600, 100000, 100400, 100800, 101200,
-	101600, 102000, 102400, 102800, 103200, 103600, 104000, 104400,
-	104800, 105200, 105600, 106100, 106600, 107000, 107400, 107800,
-	108200, 108600, 109000, 109400, 109800, 110200, 110600, 111000,
-	111400, 111800, 112200, 112600, 113000, 113400, 113800, 114200,
-	114600, 115000, 115400, 115800, 116200, 116600, 117000, 117400,
-	117800, 118200, 118600, 119000, 119400, 119800, 120200, 120600,
-	121000, 121400, 121800, 122200, 122600, 123000, 123400, 123800, 124200,
-	124600, 124900, 125000, 125000, 125000, 125000
-};
-
-/* OMAP4460 data */
-const struct omap_bandgap_data omap4460_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT |
-			OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_TALERT |
-			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_COUNTER,
-	.fclock_name = "bandgap_ts_fclk",
-	.div_ck_name = "div_ts_ck",
-	.conv_table = omap4460_adc_to_temp,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
-	.sensors = {
-		{
-		.registers = &omap4460_mpu_temp_sensor_registers,
-		.ts_data = &omap4460_mpu_temp_sensor_data,
-		.domain = "cpu",
-		.slope = OMAP_GRADIENT_SLOPE_4460,
-		.constant = OMAP_GRADIENT_CONST_4460,
-		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4460,
-		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4460,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
-		},
-	},
-	.sensor_count = 1,
-};
-
-/* OMAP4470 data */
-const struct omap_bandgap_data omap4470_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT |
-			OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_TALERT |
-			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_COUNTER,
-	.fclock_name = "bandgap_ts_fclk",
-	.div_ck_name = "div_ts_ck",
-	.conv_table = omap4460_adc_to_temp,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
-	.sensors = {
-		{
-		.registers = &omap4460_mpu_temp_sensor_registers,
-		.ts_data = &omap4460_mpu_temp_sensor_data,
-		.domain = "cpu",
-		.slope = OMAP_GRADIENT_SLOPE_4470,
-		.constant = OMAP_GRADIENT_CONST_4470,
-		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4470,
-		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4470,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
-		},
-	},
-	.sensor_count = 1,
-};
diff --git a/drivers/staging/omap-thermal/omap5-thermal-data.c b/drivers/staging/omap-thermal/omap5-thermal-data.c
new file mode 100644
index 0000000..b20db0c
--- /dev/null
+++ b/drivers/staging/omap-thermal/omap5-thermal-data.c
@@ -0,0 +1,357 @@
+/*
+ * OMAP5 thermal driver.
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Inc.
+ * Contact:
+ *	Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include "omap-bandgap.h"
+#include "omap-thermal.h"
+
+/*
+ * OMAP5430 has three instances of thermal sensor for MPU, GPU & CORE,
+ * need to describe the individual registers and bit fields.
+ */
+
+/*
+ * OMAP5430 MPU thermal sensor register offset and bit-fields
+ */
+static struct temp_sensor_registers
+omap5430_mpu_temp_sensor_registers = {
+	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_MPU_OFFSET,
+	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
+	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
+	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
+
+	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
+	.mask_hot_mask = OMAP5430_MASK_HOT_MPU_MASK,
+	.mask_cold_mask = OMAP5430_MASK_COLD_MPU_MASK,
+	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
+	.mask_freeze_mask = OMAP5430_MASK_FREEZE_MPU_MASK,
+	.mask_clear_mask = OMAP5430_MASK_CLEAR_MPU_MASK,
+	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK,
+
+
+	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
+	.counter_mask = OMAP5430_COUNTER_MASK,
+
+	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_MPU_OFFSET,
+	.threshold_thot_mask = OMAP5430_T_HOT_MASK,
+	.threshold_tcold_mask = OMAP5430_T_COLD_MASK,
+
+	.tshut_threshold = OMAP5430_BGAP_TSHUT_MPU_OFFSET,
+	.tshut_hot_mask = OMAP5430_TSHUT_HOT_MASK,
+	.tshut_cold_mask = OMAP5430_TSHUT_COLD_MASK,
+
+	.bgap_status = OMAP5430_BGAP_STATUS_OFFSET,
+	.status_clean_stop_mask = 0x0,
+	.status_bgap_alert_mask = OMAP5430_BGAP_ALERT_MASK,
+	.status_hot_mask = OMAP5430_HOT_MPU_FLAG_MASK,
+	.status_cold_mask = OMAP5430_COLD_MPU_FLAG_MASK,
+
+	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_MPU_OFFSET,
+	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_MPU_0_OFFSET,
+	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_MPU_1_OFFSET,
+	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_MPU_2_OFFSET,
+	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_MPU_3_OFFSET,
+	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_MPU_4_OFFSET,
+	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_MPU,
+};
+
+/*
+ * OMAP5430 GPU thermal sensor register offset and bit-fields
+ */
+static struct temp_sensor_registers
+omap5430_gpu_temp_sensor_registers = {
+	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_GPU_OFFSET,
+	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
+	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
+	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
+
+	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
+	.mask_hot_mask = OMAP5430_MASK_HOT_GPU_MASK,
+	.mask_cold_mask = OMAP5430_MASK_COLD_GPU_MASK,
+	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
+	.mask_freeze_mask = OMAP5430_MASK_FREEZE_GPU_MASK,
+	.mask_clear_mask = OMAP5430_MASK_CLEAR_GPU_MASK,
+	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK,
+
+	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
+	.counter_mask = OMAP5430_COUNTER_MASK,
+
+	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_GPU_OFFSET,
+	.threshold_thot_mask = OMAP5430_T_HOT_MASK,
+	.threshold_tcold_mask = OMAP5430_T_COLD_MASK,
+
+	.tshut_threshold = OMAP5430_BGAP_TSHUT_GPU_OFFSET,
+	.tshut_hot_mask = OMAP5430_TSHUT_HOT_MASK,
+	.tshut_cold_mask = OMAP5430_TSHUT_COLD_MASK,
+
+	.bgap_status = OMAP5430_BGAP_STATUS_OFFSET,
+	.status_clean_stop_mask = 0x0,
+	.status_bgap_alert_mask = OMAP5430_BGAP_ALERT_MASK,
+	.status_hot_mask = OMAP5430_HOT_GPU_FLAG_MASK,
+	.status_cold_mask = OMAP5430_COLD_GPU_FLAG_MASK,
+
+	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_GPU_OFFSET,
+	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_GPU_0_OFFSET,
+	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_GPU_1_OFFSET,
+	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_GPU_2_OFFSET,
+	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_GPU_3_OFFSET,
+	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_GPU_4_OFFSET,
+
+	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_GPU,
+};
+
+/*
+ * OMAP5430 CORE thermal sensor register offset and bit-fields
+ */
+static struct temp_sensor_registers
+omap5430_core_temp_sensor_registers = {
+	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_CORE_OFFSET,
+	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
+	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
+	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
+
+	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
+	.mask_hot_mask = OMAP5430_MASK_HOT_CORE_MASK,
+	.mask_cold_mask = OMAP5430_MASK_COLD_CORE_MASK,
+	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
+	.mask_freeze_mask = OMAP5430_MASK_FREEZE_CORE_MASK,
+	.mask_clear_mask = OMAP5430_MASK_CLEAR_CORE_MASK,
+	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK,
+
+	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
+	.counter_mask = OMAP5430_COUNTER_MASK,
+
+	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_CORE_OFFSET,
+	.threshold_thot_mask = OMAP5430_T_HOT_MASK,
+	.threshold_tcold_mask = OMAP5430_T_COLD_MASK,
+
+	.tshut_threshold = OMAP5430_BGAP_TSHUT_CORE_OFFSET,
+	.tshut_hot_mask = OMAP5430_TSHUT_HOT_MASK,
+	.tshut_cold_mask = OMAP5430_TSHUT_COLD_MASK,
+
+	.bgap_status = OMAP5430_BGAP_STATUS_OFFSET,
+	.status_clean_stop_mask = 0x0,
+	.status_bgap_alert_mask = OMAP5430_BGAP_ALERT_MASK,
+	.status_hot_mask = OMAP5430_HOT_CORE_FLAG_MASK,
+	.status_cold_mask = OMAP5430_COLD_CORE_FLAG_MASK,
+
+	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_CORE_OFFSET,
+	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_CORE_0_OFFSET,
+	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_CORE_1_OFFSET,
+	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_CORE_2_OFFSET,
+	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_CORE_3_OFFSET,
+	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_CORE_4_OFFSET,
+
+	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_CORE,
+};
+
+/* Thresholds and limits for OMAP5430 MPU temperature sensor */
+static struct temp_sensor_data omap5430_mpu_temp_sensor_data = {
+	.tshut_hot = OMAP5430_MPU_TSHUT_HOT,
+	.tshut_cold = OMAP5430_MPU_TSHUT_COLD,
+	.t_hot = OMAP5430_MPU_T_HOT,
+	.t_cold = OMAP5430_MPU_T_COLD,
+	.min_freq = OMAP5430_MPU_MIN_FREQ,
+	.max_freq = OMAP5430_MPU_MAX_FREQ,
+	.max_temp = OMAP5430_MPU_MAX_TEMP,
+	.min_temp = OMAP5430_MPU_MIN_TEMP,
+	.hyst_val = OMAP5430_MPU_HYST_VAL,
+	.adc_start_val = OMAP5430_ADC_START_VALUE,
+	.adc_end_val = OMAP5430_ADC_END_VALUE,
+	.update_int1 = 1000,
+	.update_int2 = 2000,
+};
+
+/* Thresholds and limits for OMAP5430 GPU temperature sensor */
+static struct temp_sensor_data omap5430_gpu_temp_sensor_data = {
+	.tshut_hot = OMAP5430_GPU_TSHUT_HOT,
+	.tshut_cold = OMAP5430_GPU_TSHUT_COLD,
+	.t_hot = OMAP5430_GPU_T_HOT,
+	.t_cold = OMAP5430_GPU_T_COLD,
+	.min_freq = OMAP5430_GPU_MIN_FREQ,
+	.max_freq = OMAP5430_GPU_MAX_FREQ,
+	.max_temp = OMAP5430_GPU_MAX_TEMP,
+	.min_temp = OMAP5430_GPU_MIN_TEMP,
+	.hyst_val = OMAP5430_GPU_HYST_VAL,
+	.adc_start_val = OMAP5430_ADC_START_VALUE,
+	.adc_end_val = OMAP5430_ADC_END_VALUE,
+	.update_int1 = 1000,
+	.update_int2 = 2000,
+};
+
+/* Thresholds and limits for OMAP5430 CORE temperature sensor */
+static struct temp_sensor_data omap5430_core_temp_sensor_data = {
+	.tshut_hot = OMAP5430_CORE_TSHUT_HOT,
+	.tshut_cold = OMAP5430_CORE_TSHUT_COLD,
+	.t_hot = OMAP5430_CORE_T_HOT,
+	.t_cold = OMAP5430_CORE_T_COLD,
+	.min_freq = OMAP5430_CORE_MIN_FREQ,
+	.max_freq = OMAP5430_CORE_MAX_FREQ,
+	.max_temp = OMAP5430_CORE_MAX_TEMP,
+	.min_temp = OMAP5430_CORE_MIN_TEMP,
+	.hyst_val = OMAP5430_CORE_HYST_VAL,
+	.adc_start_val = OMAP5430_ADC_START_VALUE,
+	.adc_end_val = OMAP5430_ADC_END_VALUE,
+	.update_int1 = 1000,
+	.update_int2 = 2000,
+};
+
+/*
+ * OMAP54xx ES2.0 : Temperature values in milli degree celsius
+ * ADC code values from 540 to 945
+ */
+static int
+omap5430_adc_to_temp[
+	OMAP5430_ADC_END_VALUE - OMAP5430_ADC_START_VALUE + 1] = {
+	/* Index 540 - 549 */
+	-40000, -40000, -40000, -40000, -39800, -39400, -39000, -38600, -38200,
+	-37800,
+	/* Index 550 - 559 */
+	-37400, -37000, -36600, -36200, -35800, -35300, -34700, -34200, -33800,
+	-33400,
+	/* Index 560 - 569 */
+	-33000, -32600, -32200, -31800, -31400, -31000, -30600, -30200, -29800,
+	-29400,
+	/* Index 570 - 579 */
+	-29000, -28600, -28200, -27700, -27100, -26600, -26200, -25800, -25400,
+	-25000,
+	/* Index 580 - 589 */
+	-24600, -24200, -23800, -23400, -23000, -22600, -22200, -21600, -21400,
+	-21000,
+	/* Index 590 - 599 */
+	-20500, -19900, -19400, -19000, -18600, -18200, -17800, -17400, -17000,
+	-16600,
+	/* Index 600 - 609 */
+	-16200, -15800, -15400, -15000, -14600, -14200, -13800,	-13400, -13000,
+	-12500,
+	/* Index 610 - 619 */
+	-11900, -11400, -11000, -10600, -10200, -9800, -9400, -9000, -8600,
+	-8200,
+	/* Index 620 - 629 */
+	-7800, -7400, -7000, -6600, -6200, -5800, -5400, -5000, -4500, -3900,
+	/* Index 630 - 639 */
+	-3400, -3000, -2600, -2200, -1800, -1400, -1000, -600, -200, 200,
+	/* Index 640 - 649 */
+	600, 1000, 1400, 1800, 2200, 2600, 3000, 3400, 3900, 4500,
+	/* Index 650 - 659 */
+	5000, 5400, 5800, 6200, 6600, 7000, 7400, 7800, 8200, 8600,
+	/* Index 660 - 669 */
+	9000, 9400, 9800, 10200, 10600, 11000, 11400, 11800, 12200, 12700,
+	/* Index 670 - 679 */
+	13300, 13800, 14200, 14600, 15000, 15400, 15800, 16200, 16600, 17000,
+	/* Index 680 - 689 */
+	17400, 17800, 18200, 18600, 19000, 19400, 19800, 20200, 20600, 21100,
+	/* Index 690 - 699 */
+	21400, 21900, 22500, 23000, 23400, 23800, 24200, 24600, 25000, 25400,
+	/* Index 700 - 709 */
+	25800, 26200, 26600, 27000, 27400, 27800, 28200, 28600, 29000, 29400,
+	/* Index 710 - 719 */
+	29800, 30200, 30600, 31000, 31400, 31900, 32500, 33000, 33400, 33800,
+	/* Index 720 - 729 */
+	34200, 34600, 35000, 35400, 35800, 36200, 36600, 37000, 37400, 37800,
+	/* Index 730 - 739 */
+	38200, 38600, 39000, 39400, 39800, 40200, 40600, 41000, 41400, 41800,
+	/* Index 740 - 749 */
+	42200, 42600, 43100, 43700, 44200, 44600, 45000, 45400, 45800, 46200,
+	/* Index 750 - 759 */
+	46600, 47000, 47400, 47800, 48200, 48600, 49000, 49400, 49800, 50200,
+	/* Index 760 - 769 */
+	50600, 51000, 51400, 51800, 52200, 52600, 53000, 53400, 53800, 54200,
+	/* Index 770 - 779 */
+	54600, 55000, 55400, 55900, 56500, 57000, 57400, 57800, 58200, 58600,
+	/* Index 780 - 789 */
+	59000, 59400, 59800, 60200, 60600, 61000, 61400, 61800, 62200, 62600,
+	/* Index 790 - 799 */
+	63000, 63400, 63800, 64200, 64600, 65000, 65400, 65800, 66200, 66600,
+	/* Index 800 - 809 */
+	67000, 67400, 67800, 68200, 68600, 69000, 69400, 69800, 70200, 70600,
+	/* Index 810 - 819 */
+	71000, 71500, 72100, 72600, 73000, 73400, 73800, 74200, 74600, 75000,
+	/* Index 820 - 829 */
+	75400, 75800, 76200, 76600, 77000, 77400, 77800, 78200, 78600, 79000,
+	/* Index 830 - 839 */
+	79400, 79800, 80200, 80600, 81000, 81400, 81800, 82200, 82600, 83000,
+	/* Index 840 - 849 */
+	83400, 83800, 84200, 84600, 85000, 85400, 85800, 86200, 86600, 87000,
+	/* Index 850 - 859 */
+	87400, 87800, 88200, 88600, 89000, 89400, 89800, 90200, 90600, 91000,
+	/* Index 860 - 869 */
+	91400, 91800, 92200, 92600, 93000, 93400, 93800, 94200, 94600, 95000,
+	/* Index 870 - 879 */
+	95400, 95800, 96200, 96600, 97000, 97500, 98100, 98600, 99000, 99400,
+	/* Index 880 - 889 */
+	99800, 100200, 100600, 101000, 101400, 101800, 102200, 102600, 103000,
+	103400,
+	/* Index 890 - 899 */
+	103800, 104200, 104600, 105000, 105400, 105800, 106200, 106600, 107000,
+	107400,
+	/* Index 900 - 909 */
+	107800, 108200, 108600, 109000, 109400, 109800, 110200, 110600, 111000,
+	111400,
+	/* Index 910 - 919 */
+	111800, 112200, 112600, 113000, 113400, 113800, 114200, 114600, 115000,
+	115400,
+	/* Index 920 - 929 */
+	115800, 116200, 116600, 117000, 117400, 117800, 118200, 118600, 119000,
+	119400,
+	/* Index 930 - 939 */
+	119800, 120200, 120600, 121000, 121400, 121800, 122400, 122600, 123000,
+	123400,
+	/* Index 940 - 945 */
+	123800, 1242000, 124600, 124900, 125000, 125000,
+};
+
+/* OMAP54xx ES2.0 data */
+/* TODO : Need to update the slope/constant for ES2.0 silicon */
+const struct omap_bandgap_data omap5430_data = {
+	.features = OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
+			OMAP_BANDGAP_FEATURE_FREEZE_BIT |
+			OMAP_BANDGAP_FEATURE_TALERT,
+	.fclock_name = "l3instr_ts_gclk_div",
+	.div_ck_name = "l3instr_ts_gclk_div",
+	.conv_table = omap5430_adc_to_temp,
+	.expose_sensor = omap_thermal_expose_sensor,
+	.remove_sensor = omap_thermal_remove_sensor,
+	.sensors = {
+		{
+		.registers = &omap5430_mpu_temp_sensor_registers,
+		.ts_data = &omap5430_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.register_cooling = omap_thermal_register_cpu_cooling,
+		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.slope = OMAP_GRADIENT_SLOPE_5430_CPU,
+		.constant = OMAP_GRADIENT_CONST_5430_CPU,
+		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_CPU,
+		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_5430_CPU,
+		},
+		{
+		.registers = &omap5430_gpu_temp_sensor_registers,
+		.ts_data = &omap5430_gpu_temp_sensor_data,
+		.domain = "gpu",
+		.slope = OMAP_GRADIENT_SLOPE_5430_GPU,
+		.constant = OMAP_GRADIENT_CONST_5430_GPU,
+		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_GPU,
+		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_5430_GPU,
+		},
+		{
+		.registers = &omap5430_core_temp_sensor_registers,
+		.ts_data = &omap5430_core_temp_sensor_data,
+		.domain = "core",
+		},
+	},
+	.sensor_count = 3,
+};
diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
deleted file mode 100644
index b20db0c..0000000
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ /dev/null
@@ -1,357 +0,0 @@
-/*
- * OMAP5 thermal driver.
- *
- * Copyright (C) 2011-2012 Texas Instruments Inc.
- * Contact:
- *	Eduardo Valentin <eduardo.valentin@ti.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- */
-
-#include "omap-bandgap.h"
-#include "omap-thermal.h"
-
-/*
- * OMAP5430 has three instances of thermal sensor for MPU, GPU & CORE,
- * need to describe the individual registers and bit fields.
- */
-
-/*
- * OMAP5430 MPU thermal sensor register offset and bit-fields
- */
-static struct temp_sensor_registers
-omap5430_mpu_temp_sensor_registers = {
-	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_MPU_OFFSET,
-	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
-	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
-	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
-
-	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
-	.mask_hot_mask = OMAP5430_MASK_HOT_MPU_MASK,
-	.mask_cold_mask = OMAP5430_MASK_COLD_MPU_MASK,
-	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
-	.mask_freeze_mask = OMAP5430_MASK_FREEZE_MPU_MASK,
-	.mask_clear_mask = OMAP5430_MASK_CLEAR_MPU_MASK,
-	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK,
-
-
-	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
-	.counter_mask = OMAP5430_COUNTER_MASK,
-
-	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_MPU_OFFSET,
-	.threshold_thot_mask = OMAP5430_T_HOT_MASK,
-	.threshold_tcold_mask = OMAP5430_T_COLD_MASK,
-
-	.tshut_threshold = OMAP5430_BGAP_TSHUT_MPU_OFFSET,
-	.tshut_hot_mask = OMAP5430_TSHUT_HOT_MASK,
-	.tshut_cold_mask = OMAP5430_TSHUT_COLD_MASK,
-
-	.bgap_status = OMAP5430_BGAP_STATUS_OFFSET,
-	.status_clean_stop_mask = 0x0,
-	.status_bgap_alert_mask = OMAP5430_BGAP_ALERT_MASK,
-	.status_hot_mask = OMAP5430_HOT_MPU_FLAG_MASK,
-	.status_cold_mask = OMAP5430_COLD_MPU_FLAG_MASK,
-
-	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_MPU_OFFSET,
-	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_MPU_0_OFFSET,
-	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_MPU_1_OFFSET,
-	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_MPU_2_OFFSET,
-	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_MPU_3_OFFSET,
-	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_MPU_4_OFFSET,
-	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_MPU,
-};
-
-/*
- * OMAP5430 GPU thermal sensor register offset and bit-fields
- */
-static struct temp_sensor_registers
-omap5430_gpu_temp_sensor_registers = {
-	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_GPU_OFFSET,
-	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
-	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
-	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
-
-	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
-	.mask_hot_mask = OMAP5430_MASK_HOT_GPU_MASK,
-	.mask_cold_mask = OMAP5430_MASK_COLD_GPU_MASK,
-	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
-	.mask_freeze_mask = OMAP5430_MASK_FREEZE_GPU_MASK,
-	.mask_clear_mask = OMAP5430_MASK_CLEAR_GPU_MASK,
-	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK,
-
-	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
-	.counter_mask = OMAP5430_COUNTER_MASK,
-
-	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_GPU_OFFSET,
-	.threshold_thot_mask = OMAP5430_T_HOT_MASK,
-	.threshold_tcold_mask = OMAP5430_T_COLD_MASK,
-
-	.tshut_threshold = OMAP5430_BGAP_TSHUT_GPU_OFFSET,
-	.tshut_hot_mask = OMAP5430_TSHUT_HOT_MASK,
-	.tshut_cold_mask = OMAP5430_TSHUT_COLD_MASK,
-
-	.bgap_status = OMAP5430_BGAP_STATUS_OFFSET,
-	.status_clean_stop_mask = 0x0,
-	.status_bgap_alert_mask = OMAP5430_BGAP_ALERT_MASK,
-	.status_hot_mask = OMAP5430_HOT_GPU_FLAG_MASK,
-	.status_cold_mask = OMAP5430_COLD_GPU_FLAG_MASK,
-
-	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_GPU_OFFSET,
-	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_GPU_0_OFFSET,
-	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_GPU_1_OFFSET,
-	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_GPU_2_OFFSET,
-	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_GPU_3_OFFSET,
-	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_GPU_4_OFFSET,
-
-	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_GPU,
-};
-
-/*
- * OMAP5430 CORE thermal sensor register offset and bit-fields
- */
-static struct temp_sensor_registers
-omap5430_core_temp_sensor_registers = {
-	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_CORE_OFFSET,
-	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
-	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
-	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
-
-	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
-	.mask_hot_mask = OMAP5430_MASK_HOT_CORE_MASK,
-	.mask_cold_mask = OMAP5430_MASK_COLD_CORE_MASK,
-	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
-	.mask_freeze_mask = OMAP5430_MASK_FREEZE_CORE_MASK,
-	.mask_clear_mask = OMAP5430_MASK_CLEAR_CORE_MASK,
-	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK,
-
-	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
-	.counter_mask = OMAP5430_COUNTER_MASK,
-
-	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_CORE_OFFSET,
-	.threshold_thot_mask = OMAP5430_T_HOT_MASK,
-	.threshold_tcold_mask = OMAP5430_T_COLD_MASK,
-
-	.tshut_threshold = OMAP5430_BGAP_TSHUT_CORE_OFFSET,
-	.tshut_hot_mask = OMAP5430_TSHUT_HOT_MASK,
-	.tshut_cold_mask = OMAP5430_TSHUT_COLD_MASK,
-
-	.bgap_status = OMAP5430_BGAP_STATUS_OFFSET,
-	.status_clean_stop_mask = 0x0,
-	.status_bgap_alert_mask = OMAP5430_BGAP_ALERT_MASK,
-	.status_hot_mask = OMAP5430_HOT_CORE_FLAG_MASK,
-	.status_cold_mask = OMAP5430_COLD_CORE_FLAG_MASK,
-
-	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_CORE_OFFSET,
-	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_CORE_0_OFFSET,
-	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_CORE_1_OFFSET,
-	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_CORE_2_OFFSET,
-	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_CORE_3_OFFSET,
-	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_CORE_4_OFFSET,
-
-	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_CORE,
-};
-
-/* Thresholds and limits for OMAP5430 MPU temperature sensor */
-static struct temp_sensor_data omap5430_mpu_temp_sensor_data = {
-	.tshut_hot = OMAP5430_MPU_TSHUT_HOT,
-	.tshut_cold = OMAP5430_MPU_TSHUT_COLD,
-	.t_hot = OMAP5430_MPU_T_HOT,
-	.t_cold = OMAP5430_MPU_T_COLD,
-	.min_freq = OMAP5430_MPU_MIN_FREQ,
-	.max_freq = OMAP5430_MPU_MAX_FREQ,
-	.max_temp = OMAP5430_MPU_MAX_TEMP,
-	.min_temp = OMAP5430_MPU_MIN_TEMP,
-	.hyst_val = OMAP5430_MPU_HYST_VAL,
-	.adc_start_val = OMAP5430_ADC_START_VALUE,
-	.adc_end_val = OMAP5430_ADC_END_VALUE,
-	.update_int1 = 1000,
-	.update_int2 = 2000,
-};
-
-/* Thresholds and limits for OMAP5430 GPU temperature sensor */
-static struct temp_sensor_data omap5430_gpu_temp_sensor_data = {
-	.tshut_hot = OMAP5430_GPU_TSHUT_HOT,
-	.tshut_cold = OMAP5430_GPU_TSHUT_COLD,
-	.t_hot = OMAP5430_GPU_T_HOT,
-	.t_cold = OMAP5430_GPU_T_COLD,
-	.min_freq = OMAP5430_GPU_MIN_FREQ,
-	.max_freq = OMAP5430_GPU_MAX_FREQ,
-	.max_temp = OMAP5430_GPU_MAX_TEMP,
-	.min_temp = OMAP5430_GPU_MIN_TEMP,
-	.hyst_val = OMAP5430_GPU_HYST_VAL,
-	.adc_start_val = OMAP5430_ADC_START_VALUE,
-	.adc_end_val = OMAP5430_ADC_END_VALUE,
-	.update_int1 = 1000,
-	.update_int2 = 2000,
-};
-
-/* Thresholds and limits for OMAP5430 CORE temperature sensor */
-static struct temp_sensor_data omap5430_core_temp_sensor_data = {
-	.tshut_hot = OMAP5430_CORE_TSHUT_HOT,
-	.tshut_cold = OMAP5430_CORE_TSHUT_COLD,
-	.t_hot = OMAP5430_CORE_T_HOT,
-	.t_cold = OMAP5430_CORE_T_COLD,
-	.min_freq = OMAP5430_CORE_MIN_FREQ,
-	.max_freq = OMAP5430_CORE_MAX_FREQ,
-	.max_temp = OMAP5430_CORE_MAX_TEMP,
-	.min_temp = OMAP5430_CORE_MIN_TEMP,
-	.hyst_val = OMAP5430_CORE_HYST_VAL,
-	.adc_start_val = OMAP5430_ADC_START_VALUE,
-	.adc_end_val = OMAP5430_ADC_END_VALUE,
-	.update_int1 = 1000,
-	.update_int2 = 2000,
-};
-
-/*
- * OMAP54xx ES2.0 : Temperature values in milli degree celsius
- * ADC code values from 540 to 945
- */
-static int
-omap5430_adc_to_temp[
-	OMAP5430_ADC_END_VALUE - OMAP5430_ADC_START_VALUE + 1] = {
-	/* Index 540 - 549 */
-	-40000, -40000, -40000, -40000, -39800, -39400, -39000, -38600, -38200,
-	-37800,
-	/* Index 550 - 559 */
-	-37400, -37000, -36600, -36200, -35800, -35300, -34700, -34200, -33800,
-	-33400,
-	/* Index 560 - 569 */
-	-33000, -32600, -32200, -31800, -31400, -31000, -30600, -30200, -29800,
-	-29400,
-	/* Index 570 - 579 */
-	-29000, -28600, -28200, -27700, -27100, -26600, -26200, -25800, -25400,
-	-25000,
-	/* Index 580 - 589 */
-	-24600, -24200, -23800, -23400, -23000, -22600, -22200, -21600, -21400,
-	-21000,
-	/* Index 590 - 599 */
-	-20500, -19900, -19400, -19000, -18600, -18200, -17800, -17400, -17000,
-	-16600,
-	/* Index 600 - 609 */
-	-16200, -15800, -15400, -15000, -14600, -14200, -13800,	-13400, -13000,
-	-12500,
-	/* Index 610 - 619 */
-	-11900, -11400, -11000, -10600, -10200, -9800, -9400, -9000, -8600,
-	-8200,
-	/* Index 620 - 629 */
-	-7800, -7400, -7000, -6600, -6200, -5800, -5400, -5000, -4500, -3900,
-	/* Index 630 - 639 */
-	-3400, -3000, -2600, -2200, -1800, -1400, -1000, -600, -200, 200,
-	/* Index 640 - 649 */
-	600, 1000, 1400, 1800, 2200, 2600, 3000, 3400, 3900, 4500,
-	/* Index 650 - 659 */
-	5000, 5400, 5800, 6200, 6600, 7000, 7400, 7800, 8200, 8600,
-	/* Index 660 - 669 */
-	9000, 9400, 9800, 10200, 10600, 11000, 11400, 11800, 12200, 12700,
-	/* Index 670 - 679 */
-	13300, 13800, 14200, 14600, 15000, 15400, 15800, 16200, 16600, 17000,
-	/* Index 680 - 689 */
-	17400, 17800, 18200, 18600, 19000, 19400, 19800, 20200, 20600, 21100,
-	/* Index 690 - 699 */
-	21400, 21900, 22500, 23000, 23400, 23800, 24200, 24600, 25000, 25400,
-	/* Index 700 - 709 */
-	25800, 26200, 26600, 27000, 27400, 27800, 28200, 28600, 29000, 29400,
-	/* Index 710 - 719 */
-	29800, 30200, 30600, 31000, 31400, 31900, 32500, 33000, 33400, 33800,
-	/* Index 720 - 729 */
-	34200, 34600, 35000, 35400, 35800, 36200, 36600, 37000, 37400, 37800,
-	/* Index 730 - 739 */
-	38200, 38600, 39000, 39400, 39800, 40200, 40600, 41000, 41400, 41800,
-	/* Index 740 - 749 */
-	42200, 42600, 43100, 43700, 44200, 44600, 45000, 45400, 45800, 46200,
-	/* Index 750 - 759 */
-	46600, 47000, 47400, 47800, 48200, 48600, 49000, 49400, 49800, 50200,
-	/* Index 760 - 769 */
-	50600, 51000, 51400, 51800, 52200, 52600, 53000, 53400, 53800, 54200,
-	/* Index 770 - 779 */
-	54600, 55000, 55400, 55900, 56500, 57000, 57400, 57800, 58200, 58600,
-	/* Index 780 - 789 */
-	59000, 59400, 59800, 60200, 60600, 61000, 61400, 61800, 62200, 62600,
-	/* Index 790 - 799 */
-	63000, 63400, 63800, 64200, 64600, 65000, 65400, 65800, 66200, 66600,
-	/* Index 800 - 809 */
-	67000, 67400, 67800, 68200, 68600, 69000, 69400, 69800, 70200, 70600,
-	/* Index 810 - 819 */
-	71000, 71500, 72100, 72600, 73000, 73400, 73800, 74200, 74600, 75000,
-	/* Index 820 - 829 */
-	75400, 75800, 76200, 76600, 77000, 77400, 77800, 78200, 78600, 79000,
-	/* Index 830 - 839 */
-	79400, 79800, 80200, 80600, 81000, 81400, 81800, 82200, 82600, 83000,
-	/* Index 840 - 849 */
-	83400, 83800, 84200, 84600, 85000, 85400, 85800, 86200, 86600, 87000,
-	/* Index 850 - 859 */
-	87400, 87800, 88200, 88600, 89000, 89400, 89800, 90200, 90600, 91000,
-	/* Index 860 - 869 */
-	91400, 91800, 92200, 92600, 93000, 93400, 93800, 94200, 94600, 95000,
-	/* Index 870 - 879 */
-	95400, 95800, 96200, 96600, 97000, 97500, 98100, 98600, 99000, 99400,
-	/* Index 880 - 889 */
-	99800, 100200, 100600, 101000, 101400, 101800, 102200, 102600, 103000,
-	103400,
-	/* Index 890 - 899 */
-	103800, 104200, 104600, 105000, 105400, 105800, 106200, 106600, 107000,
-	107400,
-	/* Index 900 - 909 */
-	107800, 108200, 108600, 109000, 109400, 109800, 110200, 110600, 111000,
-	111400,
-	/* Index 910 - 919 */
-	111800, 112200, 112600, 113000, 113400, 113800, 114200, 114600, 115000,
-	115400,
-	/* Index 920 - 929 */
-	115800, 116200, 116600, 117000, 117400, 117800, 118200, 118600, 119000,
-	119400,
-	/* Index 930 - 939 */
-	119800, 120200, 120600, 121000, 121400, 121800, 122400, 122600, 123000,
-	123400,
-	/* Index 940 - 945 */
-	123800, 1242000, 124600, 124900, 125000, 125000,
-};
-
-/* OMAP54xx ES2.0 data */
-/* TODO : Need to update the slope/constant for ES2.0 silicon */
-const struct omap_bandgap_data omap5430_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_FREEZE_BIT |
-			OMAP_BANDGAP_FEATURE_TALERT,
-	.fclock_name = "l3instr_ts_gclk_div",
-	.div_ck_name = "l3instr_ts_gclk_div",
-	.conv_table = omap5430_adc_to_temp,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
-	.sensors = {
-		{
-		.registers = &omap5430_mpu_temp_sensor_registers,
-		.ts_data = &omap5430_mpu_temp_sensor_data,
-		.domain = "cpu",
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
-		.slope = OMAP_GRADIENT_SLOPE_5430_CPU,
-		.constant = OMAP_GRADIENT_CONST_5430_CPU,
-		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_CPU,
-		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_5430_CPU,
-		},
-		{
-		.registers = &omap5430_gpu_temp_sensor_registers,
-		.ts_data = &omap5430_gpu_temp_sensor_data,
-		.domain = "gpu",
-		.slope = OMAP_GRADIENT_SLOPE_5430_GPU,
-		.constant = OMAP_GRADIENT_CONST_5430_GPU,
-		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_GPU,
-		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_5430_GPU,
-		},
-		{
-		.registers = &omap5430_core_temp_sensor_registers,
-		.ts_data = &omap5430_core_temp_sensor_data,
-		.domain = "core",
-		},
-	},
-	.sensor_count = 3,
-};
-- 
1.7.7.1.488.ge8e1c

