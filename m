Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbaHEJPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:15:13 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:11360
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932792AbaHEJPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:15:10 -0400
From: Anson Huang <b20788@freescale.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>, <shawn.guo@linaro.org>,
        <eduardo.valentin@ti.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH] Thermal: imx: add i.mx6sx thermal support
Date: Tue, 5 Aug 2014 17:12:43 +0800
Message-ID: <1407229963-32662-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(31966008)(74662001)(76482001)(77982001)(48376002)(74502001)(79102001)(83322001)(19580405001)(46102001)(87286001)(50466002)(50986999)(104166001)(97736001)(99396002)(81156004)(106466001)(102836001)(95666004)(105606002)(26826002)(68736004)(4396001)(44976005)(19580395003)(89996001)(83072002)(50226001)(87936001)(69596002)(88136002)(6806004)(21056001)(575784001)(93916002)(84676001)(92726001)(85852003)(92566001)(2201001)(62966002)(77156001)(229853001)(107046002)(36756003)(64706001)(80022001)(47776003)(33646002)(85306004)(20776003)(81542001)(81342001)(104016003)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB564;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Anson.Huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i.MX6SX has some new features of thermal interrupt function,
there are LOW, HIGH and PANIC irq for thermal sensor, so add
platform data to separate different thermal version;

The reset value of LOW ALARM is 0 which means the highest
temp, so the LOW ALARM will be triggered once irq is enabled,
so we need to correct it before enabling thermal irq;

Enable PANIC ALARM as critical trip point, it will trigger
system reset via SRC module once PANIC IRQ is triggered, it
is pure hardware function, so use it instead of software
reset by cooling device.

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 .../devicetree/bindings/thermal/imx-thermal.txt    |    2 +-
 drivers/thermal/imx_thermal.c                      |   88 +++++++++++++++++---
 2 files changed, 76 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/imx-thermal.txt b/Documentation/devicetree/bindings/thermal/imx-thermal.txt
index 1f0f672..95c05b1 100644
--- a/Documentation/devicetree/bindings/thermal/imx-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/imx-thermal.txt
@@ -1,7 +1,7 @@
 * Temperature Monitor (TEMPMON) on Freescale i.MX SoCs
 
 Required properties:
-- compatible : "fsl,imx6q-thermal"
+- compatible : "fsl,imx6q-tempmon" for V1, "fsl,imx6sx-tempmon" for V2.
 - fsl,tempmon : phandle pointer to system controller that contains TEMPMON
   control registers, e.g. ANATOP on imx6q.
 - fsl,tempmon-data : phandle pointer to fuse controller that contains TEMPMON
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 2c516f2..2276e74 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -19,6 +19,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
@@ -31,6 +32,10 @@
 
 #define MISC0				0x0150
 #define MISC0_REFTOP_SELBIASOFF		(1 << 3)
+#define MISC1				0x0160
+#define MISC1_IRQ_TEMPHIGH		(1 << 29)
+#define MISC1_IRQ_TEMPLOW		(1 << 28)
+#define MISC1_IRQ_TEMPPANIC		(1 << 27)
 
 #define TEMPSENSE0			0x0180
 #define TEMPSENSE0_ALARM_VALUE_SHIFT	20
@@ -43,6 +48,11 @@
 
 #define TEMPSENSE1			0x0190
 #define TEMPSENSE1_MEASURE_FREQ		0xffff
+#define TEMPSENSE2			0x0290
+#define TEMPSENSE2_LOW_VALUE_SHIFT	0
+#define TEMPSENSE2_LOW_VALUE_MASK	0xfff
+#define TEMPSENSE2_PANIC_VALUE_SHIFT	16
+#define TEMPSENSE2_PANIC_VALUE_MASK	0xfff0000
 
 #define OCOTP_ANA1			0x04e0
 
@@ -66,6 +76,21 @@ enum imx_thermal_trip {
 #define FACTOR1				15976
 #define FACTOR2				4297157
 
+#define TEMPMON_V1			1
+#define TEMPMON_V2			2
+
+struct thermal_soc_data {
+	u32 version;
+};
+
+static struct thermal_soc_data thermal_imx6q_data = {
+	.version = TEMPMON_V1,
+};
+
+static struct thermal_soc_data thermal_imx6sx_data = {
+	.version = TEMPMON_V2,
+};
+
 struct imx_thermal_data {
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
@@ -79,8 +104,21 @@ struct imx_thermal_data {
 	bool irq_enabled;
 	int irq;
 	struct clk *thermal_clk;
+	const struct thermal_soc_data *socdata;
 };
 
+static void imx_set_panic_temp(struct imx_thermal_data *data,
+			       signed long panic_temp)
+{
+	struct regmap *map = data->tempmon;
+	int critical_value;
+
+	critical_value = (data->c2 - panic_temp) / data->c1;
+	regmap_write(map, TEMPSENSE2 + REG_CLR, TEMPSENSE2_PANIC_VALUE_MASK);
+	regmap_write(map, TEMPSENSE2 + REG_SET, critical_value <<
+			TEMPSENSE2_PANIC_VALUE_SHIFT);
+}
+
 static void imx_set_alarm_temp(struct imx_thermal_data *data,
 			       signed long alarm_temp)
 {
@@ -142,13 +180,15 @@ static int imx_get_temp(struct thermal_zone_device *tz, unsigned long *temp)
 	/* See imx_get_sensor_data() for formula derivation */
 	*temp = data->c2 - n_meas * data->c1;
 
-	/* Update alarm value to next higher trip point */
-	if (data->alarm_temp == data->temp_passive && *temp >= data->temp_passive)
-		imx_set_alarm_temp(data, data->temp_critical);
-	if (data->alarm_temp == data->temp_critical && *temp < data->temp_passive) {
-		imx_set_alarm_temp(data, data->temp_passive);
-		dev_dbg(&tz->device, "thermal alarm off: T < %lu\n",
-			data->alarm_temp / 1000);
+	/* Update alarm value to next higher trip point, only V1 needs it */
+	if (data->socdata->version == TEMPMON_V1) {
+		if (data->alarm_temp == data->temp_passive && *temp >= data->temp_passive)
+			imx_set_alarm_temp(data, data->temp_critical);
+		if (data->alarm_temp == data->temp_critical && *temp < data->temp_passive) {
+			imx_set_alarm_temp(data, data->temp_passive);
+			dev_dbg(&tz->device, "thermal alarm off: T < %lu\n",
+				data->alarm_temp / 1000);
+		}
 	}
 
 	if (*temp != data->last_temp) {
@@ -398,8 +438,17 @@ static irqreturn_t imx_thermal_alarm_irq_thread(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
+static const struct of_device_id of_imx_thermal_match[] = {
+	{ .compatible = "fsl,imx6q-tempmon", .data = &thermal_imx6q_data, },
+	{ .compatible = "fsl,imx6sx-tempmon", .data = &thermal_imx6sx_data, },
+	{ /* end */ }
+};
+MODULE_DEVICE_TABLE(of, of_imx_thermal_match);
+
 static int imx_thermal_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *of_id =
+		of_match_device(of_imx_thermal_match, &pdev->dev);
 	struct imx_thermal_data *data;
 	struct cpumask clip_cpus;
 	struct regmap *map;
@@ -418,6 +467,21 @@ static int imx_thermal_probe(struct platform_device *pdev)
 	}
 	data->tempmon = map;
 
+	data->socdata = of_id->data;
+
+	/* make sure the IRQ flag is clear before enable irq */
+	regmap_write(map, MISC1 + REG_CLR, MISC1_IRQ_TEMPHIGH);
+	if (data->socdata->version == TEMPMON_V2) {
+		regmap_write(map, MISC1 + REG_CLR, MISC1_IRQ_TEMPLOW |
+			MISC1_IRQ_TEMPPANIC);
+		/*
+		 * reset value of LOW ALARM is incorrect, set it to lowest
+		 * value to avoid false trigger of low alarm.
+		 */
+		regmap_write(map, TEMPSENSE2 + REG_SET,
+			TEMPSENSE2_LOW_VALUE_MASK);
+	}
+
 	data->irq = platform_get_irq(pdev, 0);
 	if (data->irq < 0)
 		return data->irq;
@@ -489,6 +553,10 @@ static int imx_thermal_probe(struct platform_device *pdev)
 	measure_freq = DIV_ROUND_UP(32768, 10); /* 10 Hz */
 	regmap_write(map, TEMPSENSE1 + REG_SET, measure_freq);
 	imx_set_alarm_temp(data, data->temp_passive);
+
+	if (data->socdata->version == TEMPMON_V2)
+		imx_set_panic_temp(data, data->temp_critical);
+
 	regmap_write(map, TEMPSENSE0 + REG_CLR, TEMPSENSE0_POWER_DOWN);
 	regmap_write(map, TEMPSENSE0 + REG_SET, TEMPSENSE0_MEASURE_TEMP);
 
@@ -550,12 +618,6 @@ static int imx_thermal_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(imx_thermal_pm_ops,
 			 imx_thermal_suspend, imx_thermal_resume);
 
-static const struct of_device_id of_imx_thermal_match[] = {
-	{ .compatible = "fsl,imx6q-tempmon", },
-	{ /* end */ }
-};
-MODULE_DEVICE_TABLE(of, of_imx_thermal_match);
-
 static struct platform_driver imx_thermal = {
 	.driver = {
 		.name	= "imx_thermal",
-- 
1.7.9.5

