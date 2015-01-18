Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbbARU23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 15:28:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34296 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbARU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 15:28:27 -0500
Date: Sun, 18 Jan 2015 21:28:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: edubezval@gmail.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-omap@vger.kernel.org
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: [PATCHv2] thermal: add omap3 support
Message-ID: <20150118202824.GB29014@amd>
References: <20150103111146.GB7065@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103111146.GB7065@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for omap3430 sensor. Tested on Nokia N900.

Fix help text to be closer to english.

Ifdefs in ti-bandgap.h are not neccessary, as users have #ifdefs,
already.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal/ti-soc-thermal/Kconfig
index bd4c7be..65c478e 100644
--- a/drivers/thermal/ti-soc-thermal/Kconfig
+++ b/drivers/thermal/ti-soc-thermal/Kconfig
@@ -21,13 +21,28 @@ config TI_THERMAL
 	  This includes trip points definitions, extrapolation rules and
 	  CPU cooling device bindings.
 
+config OMAP3_THERMAL
+	bool "Texas Instruments OMAP3 thermal support"
+	depends on TI_SOC_THERMAL
+	depends on ARCH_OMAP3
+	help
+	  If you say yes here you get thermal support for the Texas Instruments
+	  OMAP3 SoC family. The current chips supported are:
+	   - OMAP3430
+
+	  OMAP3 chips normally don't need thermal management, and sensors in
+	  this generation are not very accurate, nor they are very close to
+	  the important hotspots.
+
+	  Say 'N' here.
+
 config OMAP4_THERMAL
 	bool "Texas Instruments OMAP4 thermal support"
 	depends on TI_SOC_THERMAL
 	depends on ARCH_OMAP4
 	help
 	  If you say yes here you get thermal support for the Texas Instruments
-	  OMAP4 SoC family. The current chip supported are:
+	  OMAP4 SoC family. The current chips supported are:
 	   - OMAP4430
 	   - OMAP4460
 	   - OMAP4470
@@ -41,7 +56,7 @@ config OMAP5_THERMAL
 	depends on SOC_OMAP5
 	help
 	  If you say yes here you get thermal support for the Texas Instruments
-	  OMAP5 SoC family. The current chip supported are:
+	  OMAP5 SoC family. The current chips supported are:
 	   - OMAP5430
 
 	  This includes alert interrupts generation and also the TSHUT
@@ -53,7 +68,7 @@ config DRA752_THERMAL
 	depends on SOC_DRA7XX
 	help
 	  If you say yes here you get thermal support for the Texas Instruments
-	  DRA752 SoC family. The current chip supported are:
+	  DRA752 SoC family. The current chips supported are:
 	   - DRA752
 
 	  This includes alert interrupts generation and also the TSHUT
diff --git a/drivers/thermal/ti-soc-thermal/Makefile b/drivers/thermal/ti-soc-thermal/Makefile
index 1226b24..0f89bdf 100644
--- a/drivers/thermal/ti-soc-thermal/Makefile
+++ b/drivers/thermal/ti-soc-thermal/Makefile
@@ -2,5 +2,6 @@ obj-$(CONFIG_TI_SOC_THERMAL)		+= ti-soc-thermal.o
 ti-soc-thermal-y			:= ti-bandgap.o
 ti-soc-thermal-$(CONFIG_TI_THERMAL)	+= ti-thermal-common.o
 ti-soc-thermal-$(CONFIG_DRA752_THERMAL)	+= dra752-thermal-data.o
+ti-soc-thermal-$(CONFIG_OMAP3_THERMAL)	+= omap3-thermal-data.o
 ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
 ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c b/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c
new file mode 100644
index 0000000..5cee2a35
--- /dev/null
+++ b/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c
@@ -0,0 +1,103 @@
+/*
+ * OMAP3 thermal driver.
+ *
+ * Copyright (C) 2011-2012 Texas Instruments Inc.
+ * Copyright (C) 2014 Pavel Machek <pavel@ucw.cz>
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
+ * Note
+ * http://www.ti.com/lit/er/sprz278f/sprz278f.pdf "Advisory
+ * 3.1.1.186 MMC OCP Clock Not Gated When Thermal Sensor Is Used"
+ *
+ * Also TI says:
+ * Just be careful when you try to make thermal policy like decisions
+ * based on this sensor. Placement of the sensor w.r.t the actual logic
+ * generating heat has to be a factor as well. If you are just looking
+ * for an approximation temperature (thermometerish kind), you might be
+ * ok with this. I am not sure we'd find any TI data around this.. just a
+ * heads up.
+ */
+
+#include "ti-thermal.h"
+#include "ti-bandgap.h"
+
+/*
+ * OMAP34XX has one instance of thermal sensor for MPU
+ * need to describe the individual bit fields
+ */
+static struct temp_sensor_registers
+omap34xx_mpu_temp_sensor_registers = {
+	.temp_sensor_ctrl = 0,
+	.bgap_soc_mask = BIT(8),
+	.bgap_eocz_mask = BIT(7),
+	.bgap_dtemp_mask = 0x7f,
+
+	.bgap_mode_ctrl = 0,
+	.mode_ctrl_mask = BIT(9),
+};
+
+/* Thresholds and limits for OMAP34XX MPU temperature sensor */
+static struct temp_sensor_data omap34xx_mpu_temp_sensor_data = {
+	.min_freq = 32768,
+	.max_freq = 32768,
+	.max_temp = -99000,
+	.min_temp = 99000,
+	.hyst_val = 5000,
+};
+
+/*
+ * Temperature values in milli degree celsius
+ */
+static const int
+omap34xx_adc_to_temp[128] = {
+	-40000, -40000, -40000, -40000, -40000, -39000, -38000, -36000,
+	-34000, -32000, -31000,	-29000, -28000, -26000, -25000, -24000,
+	-22000, -21000, -19000, -18000, -17000, -15000,	-14000, -12000,
+	-11000, -9000, -8000, -7000, -5000, -4000, -2000, -1000, 0000,
+	1000, 3000, 4000, 5000, 7000, 8000, 10000, 11000, 13000, 14000,
+	15000, 17000, 18000, 20000, 21000, 22000, 24000, 25000, 27000,
+	28000, 30000, 31000, 32000, 34000, 35000, 37000, 38000, 39000,
+	41000, 42000, 44000, 45000, 47000, 48000, 49000, 51000, 52000,
+	53000, 55000, 56000, 58000, 59000, 60000, 62000, 63000, 65000,
+	66000, 67000, 69000, 70000, 72000, 73000, 74000, 76000, 77000,
+	79000, 80000, 81000, 83000, 84000, 85000, 87000, 88000, 89000,
+	91000, 92000, 94000, 95000, 96000, 98000, 99000, 100000,
+	102000, 103000, 105000, 106000, 107000, 109000, 110000, 111000,
+	113000, 114000, 116000, 117000, 118000, 120000, 121000, 122000,
+	124000, 124000, 125000, 125000, 125000, 125000,	125000
+};
+
+/* OMAP34XX data */
+const struct ti_bandgap_data omap34xx_data = {
+	.features = TI_BANDGAP_FEATURE_CLK_CTRL /* | TI_BANDGAP_FEATURE_MODE_CONFIG */,
+	.fclock_name = "ts_fck",
+	.div_ck_name = "ts_fck",
+	.conv_table = omap34xx_adc_to_temp,
+	.adc_start_val = 0,
+	.adc_end_val = 127,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
+
+	.sensors = {
+		{
+		.registers = &omap34xx_mpu_temp_sensor_registers,
+		.ts_data = &omap34xx_mpu_temp_sensor_data,
+		.domain = "cpu",
+		.slope = 0,
+		.constant = 20000,
+		.slope_pcb = 0,
+		.constant_pcb = 20000,
+		.register_cooling = NULL,
+		.unregister_cooling = NULL,
+		},
+	},
+	.sensor_count = 1,
+};
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 634b6ce..2fde78c 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1509,6 +1510,12 @@ static SIMPLE_DEV_PM_OPS(ti_bandgap_dev_pm_ops, ti_bandgap_suspend,
 #endif
 
 static const struct of_device_id of_ti_bandgap_match[] = {
+#ifdef CONFIG_OMAP3_THERMAL
+	{
+		.compatible = "ti,omap34xx-bandgap",
+		.data = (void *)&omap34xx_data,
+	},
+#endif
 #ifdef CONFIG_OMAP4_THERMAL
 	{
 		.compatible = "ti,omap4430-bandgap",
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.h b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
index b3adf72..9ba9a6b 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.h
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
@@ -331,6 +331,7 @@ struct ti_temp_sensor {
 #define TI_BANDGAP_FEATURE_FREEZE_BIT		BIT(7)
 #define TI_BANDGAP_FEATURE_COUNTER_DELAY	BIT(8)
 #define TI_BANDGAP_FEATURE_HISTORY_BUFFER	BIT(9)
+#define TI_BANDGAP_FEATURE_UNRELIABLE		BIT(10)
 #define TI_BANDGAP_HAS(b, f)			\
 			((b)->conf->features & TI_BANDGAP_FEATURE_ ## f)
 
@@ -384,25 +385,10 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data);
 void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id);
 int ti_bandgap_get_trend(struct ti_bandgap *bgp, int id, int *trend);
 
-#ifdef CONFIG_OMAP4_THERMAL
+extern const struct ti_bandgap_data omap34xx_data;
 extern const struct ti_bandgap_data omap4430_data;
 extern const struct ti_bandgap_data omap4460_data;
 extern const struct ti_bandgap_data omap4470_data;
-#else
-#define omap4430_data					NULL
-#define omap4460_data					NULL
-#define omap4470_data					NULL
-#endif
-
-#ifdef CONFIG_OMAP5_THERMAL
 extern const struct ti_bandgap_data omap5430_data;
-#else
-#define omap5430_data					NULL
-#endif
-
-#ifdef CONFIG_DRA752_THERMAL
 extern const struct ti_bandgap_data dra752_data;
-#else
-#define dra752_data					NULL
-#endif
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
