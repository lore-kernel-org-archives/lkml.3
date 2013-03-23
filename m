Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab3CWM7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 08:59:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34615 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3CWM73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:59:29 -0400
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-doc@vger.kernel.org>
CC: <dmitry.torokhov@gmail.com>, <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH 1/2] tps6507x-ts: Add DT support
Date: Sat, 23 Mar 2013 18:29:30 +0530
Message-ID: <1364043571-9210-2-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364043571-9210-1-git-send-email-manishv.b@ti.com>
References: <1364043571-9210-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based support for TI's tps6507x touchscreen.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
:100755 100755 8fffa3c... 6d3b3a6... M	Documentation/devicetree/bindings/mfd/tps6507x.txt
:100644 100644 65e0f9a... 6890f05... M	drivers/input/touchscreen/tps6507x-ts.c
 Documentation/devicetree/bindings/mfd/tps6507x.txt |   22 ++++
 drivers/input/touchscreen/tps6507x-ts.c            |  104 ++++++++++++++------
 2 files changed, 96 insertions(+), 30 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/Documentation/devicetree/bindings/mfd/tps6507x.txt
index 8fffa3c..6d3b3a6 100755
--- a/Documentation/devicetree/bindings/mfd/tps6507x.txt
+++ b/Documentation/devicetree/bindings/mfd/tps6507x.txt
@@ -23,6 +23,12 @@ Required properties:
        vindcdc1_2-supply: VDCDC1 and VDCDC2 input.
        vindcdc3-supply  : VDCDC3 input.
        vldo1_2-supply   : VLDO1 and VLDO2 input.
+- tsc: This node specifies touch screen data.
+	ti,poll_period : Time at which touch input is getting sampled in ms.
+	ti,min_pressure: Minimum pressure value to trigger touch.
+	ti,vref	       : voltage reference for ADC.
+		      0: Reference voltage for ADC is disabled.
+		      1: Reference voltage for ADC is enabled.
 
 Regulator Optional properties:
 - defdcdc_default: It's property of DCDC2 and DCDC3 regulators.
@@ -30,6 +36,14 @@ Regulator Optional properties:
 			1: If defdcdc pin of DCDC2/DCDC3 is driven HIGH.
   If this property is not defined, it defaults to 0 (not enabled).
 
+Touchscreen Optional properties:
+- ti,vendor : Touchscreen vendor id to poppulate
+	      in sysclass interface.
+- ti,product: Touchscreen product id to poppulate
+	      in sysclass interface.
+- ti,version: Touchscreen version id to poppulate
+	      in sysclass interface.
+
 Example:
 
 	pmu: tps6507x@48 {
@@ -88,4 +102,12 @@ Example:
 			};
 		};
 
+		tsc {
+			ti,poll_period = <30>;
+			ti,min_pressure = <0x30>;
+			ti,vref = <0>;
+			ti,vendor = <0>;
+			ti,product = <65070>;
+			ti,version = <0x100>;
+		};
 	};
diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index 65e0f9a..6890f05 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -21,6 +21,8 @@
 #include <linux/mfd/tps6507x.h>
 #include <linux/input/tps6507x-ts.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #define TSC_DEFAULT_POLL_PERIOD 30 /* ms */
 #define TPS_DEFAULT_MIN_PRESSURE 0x30
@@ -231,36 +233,82 @@ done:
 	ret = tps6507x_adc_standby(tsc);
 }
 
+static int tsc_init_data(struct tps6507x_dev *tps6507x_dev,
+		struct input_dev *input_dev)
+{
+	struct device_node *node = tps6507x_dev->dev->of_node;
+	struct tps6507x_board *tps_board =
+		(struct tps6507x_board *)tps6507x_dev->dev->platform_data;
+	struct touchscreen_init_data *init_data = NULL;
+	u32 val32;
+	int err;
+
+	if (node)
+		node = of_find_node_by_name(node, "tsc");
+	if (tps_board)
+		init_data = tps_board->tps6507x_ts_init_data;
+
+	if (init_data) {
+		tps6507x_dev->ts->poll_period = init_data->poll_period;
+		tps6507x_dev->ts->min_pressure = init_data->min_pressure;
+		tps6507x_dev->ts->vref = init_data->vref;
+		input_dev->id.vendor = init_data->vendor;
+		input_dev->id.product = init_data->product;
+		input_dev->id.version = init_data->version;
+	} else if (node) {
+		err = of_property_read_u32(node, "ti,poll_period", &val32);
+		if (err < 0)
+			goto error_ret;
+		else
+			tps6507x_dev->ts->poll_period = val32;
+
+		err = of_property_read_u32(node, "ti,min_pressure", &val32);
+		if (err < 0)
+			goto error_ret;
+		else
+			tps6507x_dev->ts->min_pressure = val32;
+
+		err = of_property_read_u32(node, "ti,vref", &val32);
+		if (err < 0)
+			goto error_ret;
+		else
+			tps6507x_dev->ts->vref = val32;
+
+		err = of_property_read_u32(node, "ti,vendor", &val32);
+		if (err < 0)
+			goto error_ret;
+		else
+			input_dev->id.vendor = val32;
+
+		err = of_property_read_u32(node, "ti,product", &val32);
+		if (err < 0)
+			goto error_ret;
+		else
+			input_dev->id.product = val32;
+
+		err = of_property_read_u32(node, "ti,version", &val32);
+		if (err < 0)
+			goto error_ret;
+		else
+			input_dev->id.version = val32;
+	} else {
+		err = -EINVAL;
+	}
+
+	return 0;
+
+error_ret:
+	return err;
+}
+
 static int tps6507x_ts_probe(struct platform_device *pdev)
 {
 	int error;
 	struct tps6507x_ts *tsc;
 	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
-	struct touchscreen_init_data *init_data;
 	struct input_dev *input_dev;
-	struct tps6507x_board *tps_board;
 	int schd;
 
-	/**
-	 * tps_board points to pmic related constants
-	 * coming from the board-evm file.
-	 */
-
-	tps_board = (struct tps6507x_board *)tps6507x_dev->dev->platform_data;
-
-	if (!tps_board) {
-		dev_err(tps6507x_dev->dev,
-			"Could not find tps6507x platform data\n");
-		return -EIO;
-	}
-
-	/**
-	 * init_data points to array of regulator_init structures
-	 * coming from the board-evm file.
-	 */
-
-	init_data = tps_board->tps6507x_ts_init_data;
-
 	tsc = devm_kzalloc(&pdev->dev, sizeof(struct tps6507x_ts), GFP_KERNEL);
 	if (!tsc) {
 		dev_err(tps6507x_dev->dev, "failed to allocate driver data\n");
@@ -301,14 +349,10 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 
 	INIT_DELAYED_WORK(&tsc->work, tps6507x_ts_handler);
 
-	if (init_data) {
-		tsc->poll_period = init_data->poll_period;
-		tsc->vref = init_data->vref;
-		tsc->min_pressure = init_data->min_pressure;
-		input_dev->id.vendor = init_data->vendor;
-		input_dev->id.product = init_data->product;
-		input_dev->id.version = init_data->version;
-	} else {
+	error = tsc_init_data(tps6507x_dev, input_dev);
+
+	if (error) {
+		dev_warn(&pdev->dev, "Use default platform data\n");
 		tsc->poll_period = TSC_DEFAULT_POLL_PERIOD;
 		tsc->min_pressure = TPS_DEFAULT_MIN_PRESSURE;
 	}
-- 
1.7.4.1

