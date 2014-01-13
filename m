Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaAMKUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:20:11 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:58426 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAMKUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:20:05 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-input@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/2] Input: edt-ft5x06: Add DT support
Date: Mon, 13 Jan 2014 11:17:04 +0100
Message-Id: <1389608224-9975-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389608224-9975-1-git-send-email-LW@KARO-electronics.de>
References: <1389608224-9975-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the edt-ft5x06 multitouch panel driver to be
configured via DT.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 .../bindings/input/touchscreen/edt-ft5x06.txt      |   31 ++++
 drivers/input/touchscreen/edt-ft5x06.c             |  145 +++++++++++++++----
 2 files changed, 145 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt

diff --git a/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
new file mode 100644
index 0000000..629dbdd
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.txt
@@ -0,0 +1,31 @@
+* EDT FT5x06 Multiple Touch Controller
+
+Required properties:
+- compatible: must be "edt,ft5x06"
+- reg: i2c slave address
+- interrupt-parent: the phandle for the interrupt controller
+- interrupts: touch controller interrupt
+
+Optional properties:
+- reset-gpios:  the gpio pin to be used for resetting the controller
+- wakeup-gpios: the gpio pin to be used for waking up the controller
+
+  The following properties provide default values for the
+  corresponding parameters configurable via sysfs
+  (see Documentation/input/edt-ft5x06.txt)
+- threshold: allows setting the "click"-threshold in the range from 20 to 80.
+- gain: sensitivity (0..31) (lower value -> higher sensitivity)
+- offset: edge compensation (0..31)
+- report_rate: report rate (3..14)
+
+Example:
+
+	edt_ft5x06@38 {
+		compatible = "edt,ft5x06";
+		reg = <0x38>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <5 0>;
+		wakeup-gpios = <&gpio1 9 0>;
+		reset-gpios = <&gpio2 6 1>;
+		wakeup-gpios = <&gpio4 9 0>;
+	};
diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index af0d68b..02dce42 100644
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
@@ -617,24 +622,37 @@ edt_ft5x06_ts_teardown_debugfs(struct edt_ft5x06_ts_data *tsdata)
 
 
 static int edt_ft5x06_ts_reset(struct i2c_client *client,
-					 int reset_pin)
+			struct edt_ft5x06_ts_data *tsdata)
 {
 	int error;
 
-	if (gpio_is_valid(reset_pin)) {
+	if (gpio_is_valid(tsdata->wake_pin)) {
+		error = gpio_request_one(tsdata->wake_pin, GPIOF_OUT_INIT_LOW,
+					 "edt-ft5x06 wake");
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
-		error = gpio_request_one(reset_pin, GPIOF_OUT_INIT_LOW,
+		error = gpio_request_one(tsdata->reset_pin, GPIOF_OUT_INIT_LOW,
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
@@ -674,6 +692,21 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
 	    pdata->name <= edt_ft5x06_attr_##name.limit_high)		\
 		edt_ft5x06_register_write(tsdata, reg, pdata->name)
 
+#define EDT_GET_PROP(name, reg) {					\
+	const u32 *prop = of_get_property(np, #name, NULL);		\
+	if (prop)							\
+		edt_ft5x06_register_write(tsdata, reg, be32_to_cpu(*prop)); \
+}
+
+static void edt_ft5x06_ts_get_dt_defaults(struct device_node *np,
+					struct edt_ft5x06_ts_data *tsdata)
+{
+	EDT_GET_PROP(threshold, WORK_REGISTER_THRESHOLD);
+	EDT_GET_PROP(gain, WORK_REGISTER_GAIN);
+	EDT_GET_PROP(offset, WORK_REGISTER_OFFSET);
+	EDT_GET_PROP(report_rate, WORK_REGISTER_REPORT_RATE);
+}
+
 static void
 edt_ft5x06_ts_get_defaults(struct edt_ft5x06_ts_data *tsdata,
 			   const struct edt_ft5x06_platform_data *pdata)
@@ -701,6 +734,39 @@ edt_ft5x06_ts_get_parameters(struct edt_ft5x06_ts_data *tsdata)
 	tsdata->num_y = edt_ft5x06_register_read(tsdata, WORK_REGISTER_NUM_Y);
 }
 
+#ifdef CONFIG_OF
+static int edt_ft5x06_i2c_ts_probe_dt(struct device *dev,
+				struct edt_ft5x06_ts_data *tsdata)
+{
+	int ret;
+	struct device_node *np = dev->of_node;
+	enum of_gpio_flags gpio_flags;
+
+	if (!np)
+		return -ENODEV;
+
+	/*
+	 * irq_pin is not needed for DT setup.
+	 * irq is associated via 'interrupts' property in DT
+	 */
+	tsdata->irq_pin = -EINVAL;
+
+	ret = of_get_named_gpio_flags(np, "reset-gpios", 0, &gpio_flags);
+	tsdata->reset_pin = ret;
+
+	ret = of_get_named_gpio_flags(np, "wake-gpios", 0, &gpio_flags);
+	tsdata->wake_pin = ret;
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
@@ -713,30 +779,43 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 
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
-		error = gpio_request_one(pdata->irq_pin,
+	if (gpio_is_valid(tsdata->irq_pin)) {
+		error = gpio_request_one(tsdata->irq_pin,
 					 GPIOF_IN, "edt-ft5x06 irq");
 		if (error) {
 			dev_err(&client->dev,
 				"Failed to request GPIO %d, error %d\n",
-				pdata->irq_pin, error);
+				tsdata->irq_pin, error);
 			return error;
 		}
 	}
 
-	tsdata = kzalloc(sizeof(*tsdata), GFP_KERNEL);
 	input = input_allocate_device();
-	if (!tsdata || !input) {
-		dev_err(&client->dev, "failed to allocate driver data.\n");
+	if (!input) {
+		dev_err(&client->dev, "failed to allocate input device.\n");
 		error = -ENOMEM;
 		goto err_free_mem;
 	}
@@ -752,7 +831,11 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 		goto err_free_mem;
 	}
 
-	edt_ft5x06_ts_get_defaults(tsdata, pdata);
+	if (!pdata)
+		edt_ft5x06_ts_get_dt_defaults(client->dev.of_node, tsdata);
+	else
+		edt_ft5x06_ts_get_defaults(tsdata, pdata);
+
 	edt_ft5x06_ts_get_parameters(tsdata);
 
 	dev_dbg(&client->dev,
@@ -802,8 +885,8 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 	device_init_wakeup(&client->dev, 1);
 
 	dev_dbg(&client->dev,
-		"EDT FT5x06 initialized: IRQ pin %d, Reset pin %d.\n",
-		pdata->irq_pin, pdata->reset_pin);
+		"EDT FT5x06 initialized: IRQ %d, WAKE pin %d, Reset pin %d.\n",
+		client->irq, tsdata->wake_pin, tsdata->reset_pin);
 
 	return 0;
 
@@ -813,18 +896,18 @@ err_free_irq:
 	free_irq(client->irq, tsdata);
 err_free_mem:
 	input_free_device(input);
-	kfree(tsdata);
-
-	if (gpio_is_valid(pdata->irq_pin))
-		gpio_free(pdata->irq_pin);
+	if (gpio_is_valid(tsdata->irq_pin))
+		gpio_free(tsdata->irq_pin);
+	if (gpio_is_valid(tsdata->reset_pin))
+		gpio_free(tsdata->reset_pin);
+	if (gpio_is_valid(tsdata->wake_pin))
+		gpio_free(tsdata->wake_pin);
 
 	return error;
 }
 
 static int edt_ft5x06_ts_remove(struct i2c_client *client)
 {
-	const struct edt_ft5x06_platform_data *pdata =
-						dev_get_platdata(&client->dev);
 	struct edt_ft5x06_ts_data *tsdata = i2c_get_clientdata(client);
 
 	edt_ft5x06_ts_teardown_debugfs(tsdata);
@@ -833,12 +916,12 @@ static int edt_ft5x06_ts_remove(struct i2c_client *client)
 	free_irq(client->irq, tsdata);
 	input_unregister_device(tsdata->input);
 
-	if (gpio_is_valid(pdata->irq_pin))
-		gpio_free(pdata->irq_pin);
-	if (gpio_is_valid(pdata->reset_pin))
-		gpio_free(pdata->reset_pin);
-
-	kfree(tsdata);
+	if (gpio_is_valid(tsdata->irq_pin))
+		gpio_free(tsdata->irq_pin);
+	if (gpio_is_valid(tsdata->reset_pin))
+		gpio_free(tsdata->reset_pin);
+	if (gpio_is_valid(tsdata->wake_pin))
+		gpio_free(tsdata->wake_pin);
 
 	return 0;
 }
-- 
1.7.2.5

