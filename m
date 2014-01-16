Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaAPIDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:03:13 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:55899 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaAPIC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:02:29 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-input@vger.kernel.org, Simon Budig <simon.budig@kernelconcepts.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCHv2 3/3] Input: edt-ft5x06: Add DT support
Date: Thu, 16 Jan 2014 09:02:18 +0100
Message-Id: <1389859338-11685-4-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389859338-11685-1-git-send-email-LW@KARO-electronics.de>
References: <1389859338-11685-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 .../bindings/input/touchscreen/edt-ft5x06.txt      |   29 +++++
 drivers/input/touchscreen/edt-ft5x06.c             |  121 +++++++++++++++++---
 2 files changed, 132 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt

diff --git a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
new file mode 100644
index 0000000..8d94cdc
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
@@ -0,0 +1,29 @@
+* EDT FT5x06 Multiple Touch Controller
+
+Required properties:
+- compatible: must be "edt,ft5x06"
+- reg: i2c slave address
+- interrupt-parent: the phandle for the interrupt controller
+- interrupts: touch controller interrupt
+
+Optional properties:
+- reset-gpios: the gpio pin to be used for resetting the controller
+- wake-gpios:  the gpio pin to be used for waking up the controller
+
+  The following properties provide default values for the
+  corresponding parameters (see Documentation/input/edt-ft5x06.txt)
+- edt,threshold: allows setting the "click"-threshold in the range from 20 to 80.
+- edt,gain: sensitivity (0..31) (lower value -> higher sensitivity)
+- edt,offset: edge compensation (0..31)
+- edt,report-rate: report rate (3..14)
+
+Example:
+
+	edt_ft5x06@38 {
+		compatible = "edt,ft5x06";
+		reg = <0x38>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <5 0>;
+		reset-gpios = <&gpio2 6 1>;
+		wake-gpios = <&gpio4 9 0>;
+	};
diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index acb6b9f..0467591 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -33,6 +33,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/input/mt.h>
 #include <linux/input/edt-ft5x06.h>
 
@@ -65,6 +66,10 @@ struct edt_ft5x06_ts_data {
 	u16 num_x;
 	u16 num_y;
 
+	int reset_pin;
+	int irq_pin;
+	int wake_pin;
+
 #if defined(CONFIG_DEBUG_FS)
 	struct dentry *debug_dir;
 	u8 *raw_buffer;
@@ -617,25 +622,38 @@ edt_ft5x06_ts_teardown_debugfs(struct edt_ft5x06_ts_data *tsdata)
 
 
 static int edt_ft5x06_ts_reset(struct i2c_client *client,
-					 int reset_pin)
+			struct edt_ft5x06_ts_data *tsdata)
 {
 	int error;
 
-	if (gpio_is_valid(reset_pin)) {
+	if (gpio_is_valid(tsdata->wake_pin)) {
+		error = devm_gpio_request_one(&client->dev, tsdata->wake_pin,
+					GPIOF_OUT_INIT_LOW, "edt-ft5x06 wake");
+		if (error) {
+			dev_err(&client->dev,
+				"Failed to request GPIO %d as wake pin, error %d\n",
+				tsdata->wake_pin, error);
+			return error;
+		}
+
+		mdelay(5);
+		gpio_set_value(tsdata->wake_pin, 1);
+	}
+	if (gpio_is_valid(tsdata->reset_pin)) {
 		/* this pulls reset down, enabling the low active reset */
-		error = devm_gpio_request_one(&client->dev, reset_pin,
+		error = devm_gpio_request_one(&client->dev, tsdata->reset_pin,
 					GPIOF_OUT_INIT_LOW,
 					"edt-ft5x06 reset");
 		if (error) {
 			dev_err(&client->dev,
 				"Failed to request GPIO %d as reset pin, error %d\n",
-				reset_pin, error);
+				tsdata->reset_pin, error);
 			return error;
 		}
 
-		mdelay(50);
-		gpio_set_value(reset_pin, 1);
-		mdelay(100);
+		mdelay(5);
+		gpio_set_value(tsdata->reset_pin, 1);
+		mdelay(300);
 	}
 
 	return 0;
@@ -675,6 +693,29 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
 	    pdata->name <= edt_ft5x06_attr_##name.limit_high)		\
 		edt_ft5x06_register_write(tsdata, reg, pdata->name)
 
+#define EDT_GET_PROP(name, var, reg) {					\
+	u32 val;							\
+	if (of_property_read_u32(np, name, &val) == 0) {		\
+		if (val >= edt_ft5x06_attr_##var.limit_low &&		\
+			val <= edt_ft5x06_attr_##var.limit_high)	\
+			edt_ft5x06_register_write(tsdata, reg, val);	\
+		else							\
+			pr_err("edt_ft5x06: property %s (%u) is out of range: %u..%u", \
+				name, val,  edt_ft5x06_attr_##var.limit_low, \
+				edt_ft5x06_attr_##var.limit_high);	\
+	}								\
+}
+
+static void edt_ft5x06_ts_get_dt_defaults(struct device_node *np,
+					struct edt_ft5x06_ts_data *tsdata)
+{
+	/* pick up defaults from the DT data */
+	EDT_GET_PROP("edt,threshold", threshold, WORK_REGISTER_THRESHOLD);
+	EDT_GET_PROP("edt,gain", gain, WORK_REGISTER_GAIN);
+	EDT_GET_PROP("edt,offset", offset, WORK_REGISTER_OFFSET);
+	EDT_GET_PROP("edt,report-rate", report_rate, WORK_REGISTER_REPORT_RATE);
+}
+
 static void
 edt_ft5x06_ts_get_defaults(struct edt_ft5x06_ts_data *tsdata,
 			   const struct edt_ft5x06_platform_data *pdata)
@@ -702,6 +743,33 @@ edt_ft5x06_ts_get_parameters(struct edt_ft5x06_ts_data *tsdata)
 	tsdata->num_y = edt_ft5x06_register_read(tsdata, WORK_REGISTER_NUM_Y);
 }
 
+#ifdef CONFIG_OF
+static int edt_ft5x06_i2c_ts_probe_dt(struct device *dev,
+				struct edt_ft5x06_ts_data *tsdata)
+{
+	struct device_node *np = dev->of_node;
+
+	if (!np)
+		return -ENODEV;
+
+	/*
+	 * irq_pin is not needed for DT setup.
+	 * irq is associated via 'interrupts' property in DT
+	 */
+	tsdata->irq_pin = -EINVAL;
+	tsdata->reset_pin = of_get_named_gpio(np, "reset-gpios", 0);
+	tsdata->wake_pin = of_get_named_gpio(np, "wake-gpios", 0);
+
+	return 0;
+}
+#else
+static inline int edt_ft5x06_i2c_ts_probe_dt(struct device *dev,
+					struct edt_ft5x06_i2c_ts_data *tsdata)
+{
+	return -ENODEV;
+}
+#endif
+
 static int edt_ft5x06_ts_probe(struct i2c_client *client,
 					 const struct i2c_device_id *id)
 {
@@ -714,27 +782,40 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 
 	dev_dbg(&client->dev, "probing for EDT FT5x06 I2C\n");
 
+	tsdata = devm_kzalloc(&client->dev, sizeof(*tsdata), GFP_KERNEL);
+	if (!tsdata) {
+		dev_err(&client->dev, "failed to allocate driver data.\n");
+		return -ENOMEM;
+	}
+
 	if (!pdata) {
-		dev_err(&client->dev, "no platform data?\n");
-		return -EINVAL;
+		error = edt_ft5x06_i2c_ts_probe_dt(&client->dev, tsdata);
+		if (error) {
+			dev_err(&client->dev,
+				"DT probe failed and no platform data present\n");
+			return error;
+		}
+	} else {
+		tsdata->reset_pin = pdata->reset_pin;
+		tsdata->irq_pin = pdata->irq_pin;
+		tsdata->wake_pin = -EINVAL;
 	}
 
-	error = edt_ft5x06_ts_reset(client, pdata->reset_pin);
+	error = edt_ft5x06_ts_reset(client, tsdata);
 	if (error)
 		return error;
 
-	if (gpio_is_valid(pdata->irq_pin)) {
-		error = devm_gpio_request_one(&client->dev, pdata->irq_pin,
-					 GPIOF_IN, "edt-ft5x06 irq");
+	if (gpio_is_valid(tsdata->irq_pin)) {
+		error = devm_gpio_request_one(&client->dev, tsdata->irq_pin,
+					GPIOF_IN, "edt-ft5x06 irq");
 		if (error) {
 			dev_err(&client->dev,
 				"Failed to request GPIO %d, error %d\n",
-				pdata->irq_pin, error);
+				tsdata->irq_pin, error);
 			return error;
 		}
 	}
 
-	tsdata = kzalloc(sizeof(*tsdata), GFP_KERNEL);
 	input = devm_input_allocate_device(&client->dev);
 	if (!input) {
 		dev_err(&client->dev, "failed to allocate input device.\n");
@@ -752,7 +833,11 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 		return error;
 	}
 
-	edt_ft5x06_ts_get_defaults(tsdata, pdata);
+	if (!pdata)
+		edt_ft5x06_ts_get_dt_defaults(client->dev.of_node, tsdata);
+	else
+		edt_ft5x06_ts_get_defaults(tsdata, pdata);
+
 	edt_ft5x06_ts_get_parameters(tsdata);
 
 	dev_dbg(&client->dev,
@@ -805,8 +890,8 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 	device_init_wakeup(&client->dev, 1);
 
 	dev_dbg(&client->dev,
-		"EDT FT5x06 initialized: IRQ pin %d, Reset pin %d.\n",
-		pdata->irq_pin, pdata->reset_pin);
+		"EDT FT5x06 initialized: IRQ %d, WAKE pin %d, Reset pin %d.\n",
+		client->irq, tsdata->wake_pin, tsdata->reset_pin);
 
 	return 0;
 }
-- 
1.7.2.5

