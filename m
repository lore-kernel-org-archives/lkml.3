Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3JWQ3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:29:09 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48138 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3JWQ3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:29:01 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-input@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Cc: grant.likely@secretlab.ca, dmitry.torokhov@gmail.com,
        rob.herring@calxeda.com, rob@landley.net, badarkhe.manish@gmail.com
Subject: [PATCH V4 1/2] tps6507x-ts: Add DT support
Date: Wed, 23 Oct 2013 21:58:52 +0530
Message-Id: <1382545733-8865-2-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382545733-8865-1-git-send-email-badarkhe.manish@gmail.com>
References: <1382545733-8865-1-git-send-email-badarkhe.manish@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree based support for TI's tps6507x touchscreen.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
Changes since V3:
 - Rebased on top of Dmitry's changes
 - Removed error handling for optional DT properties

Changes since V2:
 - Removed unnecessary code.
 - Updated Documentation to provide proper names of
   devicetree properties.

Changes since V1:
 - Updated documentation to specify tps6507x as multifunctional
   device.
 - return proper error value in absence of platform and DT
   data for touchscreen.
 - Updated commit message.

:100755 100755 8fffa3c... e1b9cfd... M	Documentation/devicetree/bindings/mfd/tps6507x.txt
:100644 100644 db604e0... 0cf0eb1... M	drivers/input/touchscreen/tps6507x-ts.c
 Documentation/devicetree/bindings/mfd/tps6507x.txt |   24 ++++++-
 drivers/input/touchscreen/tps6507x-ts.c            |   72 ++++++++++++--------
 2 files changed, 67 insertions(+), 29 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/Documentation/devicetree/bindings/mfd/tps6507x.txt
index 8fffa3c..e1b9cfd 100755
--- a/Documentation/devicetree/bindings/mfd/tps6507x.txt
+++ b/Documentation/devicetree/bindings/mfd/tps6507x.txt
@@ -1,4 +1,8 @@
-TPS6507x Power Management Integrated Circuit
+TPS6507x Multifunctional Device.
+
+Features provided by TPS6507x:
+        1.Power Management Integrated Circuit.
+        2.Touch-Screen.
 
 Required properties:
 - compatible: "ti,tps6507x"
@@ -23,6 +27,9 @@ Required properties:
        vindcdc1_2-supply: VDCDC1 and VDCDC2 input.
        vindcdc3-supply  : VDCDC3 input.
        vldo1_2-supply   : VLDO1 and VLDO2 input.
+- tsc: This node specifies touch screen data.
+	ti,poll-period : Time at which touch input is getting sampled in ms.
+	ti,min-pressure: Minimum pressure value to trigger touch.
 
 Regulator Optional properties:
 - defdcdc_default: It's property of DCDC2 and DCDC3 regulators.
@@ -30,6 +37,14 @@ Regulator Optional properties:
 			1: If defdcdc pin of DCDC2/DCDC3 is driven HIGH.
   If this property is not defined, it defaults to 0 (not enabled).
 
+Touchscreen Optional properties:
+- ti,vendor : Touchscreen vendor id to populate
+	      in sysclass interface.
+- ti,product: Touchscreen product id to populate
+	      in sysclass interface.
+- ti,version: Touchscreen version id to populate
+	      in sysclass interface.
+
 Example:
 
 	pmu: tps6507x@48 {
@@ -88,4 +103,11 @@ Example:
 			};
 		};
 
+		tsc {
+			ti,poll-period = <30>;
+			ti,min-pressure = <0x30>;
+			ti,vendor = <0>;
+			ti,product = <65070>;
+			ti,version = <0x100>;
+		};
 	};
diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index db604e0..0cf0eb1 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -22,6 +22,8 @@
 #include <linux/mfd/tps6507x.h>
 #include <linux/input/tps6507x-ts.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #define TSC_DEFAULT_POLL_PERIOD 30 /* ms */
 #define TPS_DEFAULT_MIN_PRESSURE 0x30
@@ -206,33 +208,54 @@ done:
 	tps6507x_adc_standby(tsc);
 }
 
+static void tsc_init_data(struct tps6507x_ts *tsc,
+		struct input_dev *input_dev)
+{
+	struct device_node *node = tsc->dev->of_node;
+	const struct tps6507x_board *tps_board =
+			dev_get_platdata(tsc->dev);
+	const struct touchscreen_init_data *init_data = NULL;
+
+	if (node)
+		node = of_find_node_by_name(node, "tsc");
+	if (tps_board)
+		/*
+		 * init_data points to array of touchscreen_init structure
+		 * coming from the board-evm file.
+		 */
+		init_data = tps_board->tps6507x_ts_init_data;
+
+	if (node == NULL || init_data == NULL) {
+		tsc->poll_dev->poll_interval = TSC_DEFAULT_POLL_PERIOD;
+		tsc->min_pressure = TPS_DEFAULT_MIN_PRESSURE;
+	} else if (init_data) {
+		tsc->poll_dev->poll_interval = init_data->poll_period;
+		tsc->min_pressure = init_data->min_pressure;
+		input_dev->id.vendor = init_data->vendor;
+		input_dev->id.product = init_data->product;
+		input_dev->id.version = init_data->version;
+	} else if (node) {
+		of_property_read_u32(node, "ti,poll-period",
+				&tsc->poll_dev->poll_interval);
+		of_property_read_u16(node, "ti,min-pressure",
+				&tsc->min_pressure);
+		of_property_read_u16(node, "ti,vendor",
+				&input_dev->id.vendor);
+		of_property_read_u16(node, "ti,product",
+				&input_dev->id.product);
+		of_property_read_u16(node, "ti,version",
+				&input_dev->id.version);
+	}
+}
+
 static int tps6507x_ts_probe(struct platform_device *pdev)
 {
 	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
-	const struct tps6507x_board *tps_board;
-	const struct touchscreen_init_data *init_data;
 	struct tps6507x_ts *tsc;
 	struct input_polled_dev *poll_dev;
 	struct input_dev *input_dev;
 	int error;
 
-	/*
-	 * tps_board points to pmic related constants
-	 * coming from the board-evm file.
-	 */
-	tps_board = dev_get_platdata(tps6507x_dev->dev);
-	if (!tps_board) {
-		dev_err(tps6507x_dev->dev,
-			"Could not find tps6507x platform data\n");
-		return -ENODEV;
-	}
-
-	/*
-	 * init_data points to array of regulator_init structures
-	 * coming from the board-evm file.
-	 */
-	init_data = tps_board->tps6507x_ts_init_data;
-
 	tsc = devm_kzalloc(&pdev->dev, sizeof(struct tps6507x_ts), GFP_KERNEL);
 	if (!tsc) {
 		dev_err(tps6507x_dev->dev, "failed to allocate driver data\n");
@@ -241,8 +264,6 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 
 	tsc->mfd = tps6507x_dev;
 	tsc->dev = tps6507x_dev->dev;
-	tsc->min_pressure = init_data ?
-			init_data->min_pressure : TPS_DEFAULT_MIN_PRESSURE;
 
 	snprintf(tsc->phys, sizeof(tsc->phys),
 		 "%s/input0", dev_name(tsc->dev));
@@ -258,8 +279,6 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 
 	poll_dev->private = tsc;
 	poll_dev->poll = tps6507x_ts_poll;
-	poll_dev->poll_interval = init_data ?
-			init_data->poll_period : TSC_DEFAULT_POLL_PERIOD;
 
 	input_dev = poll_dev->input;
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
@@ -273,11 +292,8 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 	input_dev->phys = tsc->phys;
 	input_dev->dev.parent = tsc->dev;
 	input_dev->id.bustype = BUS_I2C;
-	if (init_data) {
-		input_dev->id.vendor = init_data->vendor;
-		input_dev->id.product = init_data->product;
-		input_dev->id.version = init_data->version;
-	}
+
+	tsc_init_data(tsc, input_dev);
 
 	error = tps6507x_adc_standby(tsc);
 	if (error)
-- 
1.7.10.4

