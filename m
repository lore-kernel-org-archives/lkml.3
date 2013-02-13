Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138Ab3BMSCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:02:35 -0500
Received: from mail-qc0-f201.google.com ([209.85.216.201]:37517 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965100Ab3BMSCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:31 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Stephen Warren <swarren@nvidia.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH v1 1/4] i2c: mux: Add i2c-arbitrator 'mux' driver
Date: Wed, 13 Feb 2013 10:02:09 -0800
Message-Id: <1360778532-7480-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-arbitrator driver implements the arbitration scheme that the
Embedded Controller (EC) on the ARM Chromebook expects to use for bus
multimastering.  This i2c-arbitrator driver could also be used in
other places where standard i2c bus arbitration can't be used and two
extra GPIOs are available for arbitration.

This driver is based on code that Simon Glass added to the i2c-s3c2410
driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
mux driver is as suggested by Grant Likely.  See
<https://patchwork.kernel.org/patch/1877311/> for some history.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes in v1: None

 .../devicetree/bindings/i2c/i2c-arbitrator.txt     |  76 +++++++
 drivers/i2c/muxes/Kconfig                          |  11 +
 drivers/i2c/muxes/Makefile                         |   1 +
 drivers/i2c/muxes/i2c-arbitrator.c                 | 242 +++++++++++++++++++++
 4 files changed, 330 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt
 create mode 100644 drivers/i2c/muxes/i2c-arbitrator.c

diff --git a/Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt b/Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt
new file mode 100644
index 0000000..bb9cca7
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-arbitrator.txt
@@ -0,0 +1,76 @@
+GPIO-based Arbitration
+======================
+This uses GPIO lines between the AP (Application Processor) and an attached
+EC (Embedded Controller) which both want to talk on the same I2C bus as master.
+
+The AP and EC each have a 'bus claim' line, which is an output that the
+other can see. These are both active low, with pull-ups enabled.
+
+- AP_CLAIM: output from AP, signalling to the EC that the AP wants the bus
+- EC_CLAIM: output from EC, signalling to the AP that the EC wants the bus
+
+
+This mechanism is used instead of standard i2c multimaster to avoid some of the
+subtle driver and silicon bugs that are often present with i2c multimaster.
+
+
+Algorithm:
+
+The basic algorithm is to assert your line when you want the bus, then make
+sure that the other side doesn't want it also. A detailed explanation is best
+done with an example.
+
+Let's say the AP wants to claim the bus. It:
+1. Asserts AP_CLAIM.
+2. Waits a little bit for the other side to notice (slew time, say 10
+   microseconds).
+3. Checks EC_CLAIM. If this is not asserted then the AP has the bus and we are
+   done.
+4. Otherwise, wait for a few milliseconds and see if EC_CLAIM is released.
+5. If not, back off, release the claim and wait for a few more milliseconds.
+6. Go back to 1 (until retry time has expired).
+
+
+Required properties:
+- compatible: i2c-arbitrator
+- bus-arbitration-gpios: Two GPIOs to use with the GPIO-based bus
+    arbitration protocol.  The first should be an output, and is used to
+    claim the I2C bus for us (AP_CLAIM).  The second should be an input and
+    signals that the other side wants to claim the bus (EC_CLAIM).
+- bus-arbitration-slew-delay-us: microseconds to wait for a GPIO to go high.
+- bus-arbitration-wait-retry-us: we'll attempt another claim after this many
+    microseconds.
+- bus-arbitration-wait-free-us: we'll give up after this many microseconds.
+- Standard I2C mux properties. See mux.txt in this directory.
+- Single I2C child bus node at reg 0. See mux.txt in this directory.
+
+
+Example:
+	i2c@12CA0000 {
+		compatible = "acme,some-i2c-device";
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	i2c-arbitrator {
+		compatible = "i2c-arbitrator";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&{/i2c@12CA0000}>;
+
+		bus-arbitration-gpios = <&gpf0 3 1 0 0>, <&gpe0 4 0 3 0>;
+		bus-arbitration-slew-delay-us = <10>;
+		bus-arbitration-wait-retry-us = <3000>;
+		bus-arbitration-wait-free-us = <50000>;
+
+		i2c@0 {
+			reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			i2c@52 {
+				// Normal i2c device
+			};
+		};
+	};
diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index 0be5b83..714bf16 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -5,6 +5,17 @@
 menu "Multiplexer I2C Chip support"
 	depends on I2C_MUX
 
+config I2C_ARBITRATOR
+	tristate "GPIO-based I2C arbitrator"
+	depends on GENERIC_GPIO && OF
+	help
+	  If you say yes to this option, support will be included for an
+	  i2c multimaster arbitration scheme using GPIOs (as opposed to
+	  using standard i2c multimaster mode).
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-arbitrator.
+
 config I2C_MUX_GPIO
 	tristate "GPIO-based I2C multiplexer"
 	depends on GENERIC_GPIO
diff --git a/drivers/i2c/muxes/Makefile b/drivers/i2c/muxes/Makefile
index 76da869..adfe147 100644
--- a/drivers/i2c/muxes/Makefile
+++ b/drivers/i2c/muxes/Makefile
@@ -1,6 +1,7 @@
 #
 # Makefile for multiplexer I2C chip drivers.
 
+obj-$(CONFIG_I2C_ARBITRATOR)	+= i2c-arbitrator.o
 obj-$(CONFIG_I2C_MUX_GPIO)	+= i2c-mux-gpio.o
 obj-$(CONFIG_I2C_MUX_PCA9541)	+= i2c-mux-pca9541.o
 obj-$(CONFIG_I2C_MUX_PCA954x)	+= i2c-mux-pca954x.o
diff --git a/drivers/i2c/muxes/i2c-arbitrator.c b/drivers/i2c/muxes/i2c-arbitrator.c
new file mode 100644
index 0000000..c3bbdf7
--- /dev/null
+++ b/drivers/i2c/muxes/i2c-arbitrator.c
@@ -0,0 +1,242 @@
+/*
+ * I2C arbitrator using GPIO API
+ *
+ * Copyright (C) 2012 Google, Inc
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/i2c-mux.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/of_i2c.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+
+enum {
+	I2C_ARB_GPIO_AP,		/* AP claims i2c bus */
+	I2C_ARB_GPIO_EC,		/* EC claims i2c bus */
+
+	I2C_ARB_GPIO_COUNT,
+};
+
+/**
+ * struct i2c_arbitrator_data - Driver data for i2c arbitrator
+ *
+ * @parent: Parent adapter
+ * @child: Child bus
+ * @ap_gpio: GPIO we'll use to claim.
+ * @ec_gpio: GPIO that the other side will use to claim.
+ * @slew_delay_us: microseconds to wait for a GPIO to go high.
+ * @wait_retry_us: we'll attempt another claim after this many microseconds.
+ * @wait_free_us: we'll give up after this many microseconds.
+ */
+
+struct i2c_arbitrator_data {
+	struct i2c_adapter *parent;
+	struct i2c_adapter *child;
+
+	int		ap_gpio;
+	int		ec_gpio;
+	unsigned int	slew_delay_us;
+	unsigned int	wait_retry_us;
+	unsigned int	wait_free_us;
+};
+
+
+/**
+ * i2c_arbitrator_select - claim the i2c bus
+ *
+ * Use the GPIO-based signalling protocol; return -EBUSY if we fail.
+ */
+static int i2c_arbitrator_select(struct i2c_adapter *adap, void *data, u32 chan)
+{
+	const struct i2c_arbitrator_data *arb = data;
+	unsigned long stop_retry, stop_time;
+
+	/* Start a round of trying to claim the bus */
+	stop_time = jiffies + usecs_to_jiffies(arb->wait_free_us) + 1;
+	do {
+		/* Indicate that we want to claim the bus */
+		gpio_set_value(arb->ap_gpio, 0);
+		udelay(arb->slew_delay_us);
+
+		/* Wait for the EC to release it */
+		stop_retry = jiffies + usecs_to_jiffies(arb->wait_retry_us) + 1;
+		while (time_before(jiffies, stop_retry)) {
+			if (gpio_get_value(arb->ec_gpio)) {
+				/* We got it, so return */
+				return 0;
+			}
+
+			usleep_range(50, 200);
+		}
+
+		/* It didn't release, so give up, wait, and try again */
+		gpio_set_value(arb->ap_gpio, 1);
+
+		usleep_range(arb->wait_retry_us, arb->wait_retry_us * 2);
+	} while (time_before(jiffies, stop_time));
+
+	/* Give up, release our claim */
+	gpio_set_value(arb->ap_gpio, 1);
+	udelay(arb->slew_delay_us);
+	dev_err(&adap->dev, "Could not claim bus, timeout\n");
+	return -EBUSY;
+}
+
+/**
+ * i2c_arbitrator_deselect - release the i2c bus
+ *
+ * Release the i2c bus using the GPIO-based signalling protocol.
+ */
+static int i2c_arbitrator_deselect(struct i2c_adapter *adap, void *data,
+				   u32 chan)
+{
+	const struct i2c_arbitrator_data *arb = data;
+
+	/* Release the bus and wait for the EC to notice */
+	gpio_set_value(arb->ap_gpio, 1);
+	udelay(arb->slew_delay_us);
+
+	return 0;
+}
+
+static int i2c_arbitrator_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *parent_np;
+	struct i2c_arbitrator_data *arb;
+	int ret;
+
+	/* We only support probing from device tree; no platform_data */
+	if (WARN_ON(!np))
+		return -ENODEV;
+	if (WARN_ON(pdev->dev.platform_data))
+		return -EINVAL;
+
+	arb = devm_kzalloc(&pdev->dev, sizeof(*arb), GFP_KERNEL);
+	if (WARN_ON(!arb))
+		return -ENOMEM;
+	platform_set_drvdata(pdev, arb);
+
+	/* Find our parent */
+	parent_np = of_parse_phandle(np, "i2c-parent", 0);
+	if (WARN_ON(!parent_np))
+		return -EINVAL;
+	arb->parent = of_find_i2c_adapter_by_node(parent_np);
+	if (WARN_ON(!arb->parent))
+		return -EINVAL;
+
+	/* Request GPIOs */
+	ret = of_get_named_gpio(np, "bus-arbitration-gpios", I2C_ARB_GPIO_AP);
+	if (gpio_is_valid(ret)) {
+		arb->ap_gpio = ret;
+		ret = gpio_request_one(arb->ap_gpio, GPIOF_OUT_INIT_HIGH,
+				       "bus-arbitration-ap");
+	}
+	if (WARN_ON(ret))
+		goto ap_request_failed;
+
+	ret = of_get_named_gpio(np, "bus-arbitration-gpios", I2C_ARB_GPIO_EC);
+	if (gpio_is_valid(ret)) {
+		arb->ec_gpio = ret;
+		ret = gpio_request_one(arb->ec_gpio, GPIOF_IN,
+				       "bus-arbitration-ec");
+	}
+	if (WARN_ON(ret))
+		goto ec_request_failed;
+
+	/* Arbitration parameters */
+	if (of_property_read_u32(np, "bus-arbitration-slew-delay-us",
+				 &arb->slew_delay_us))
+		arb->slew_delay_us = 10;
+	if (of_property_read_u32(np, "bus-arbitration-wait-retry-us",
+				 &arb->wait_retry_us))
+		arb->wait_retry_us = 3000;
+	if (of_property_read_u32(np, "bus-arbitration-wait-free-us",
+				 &arb->wait_free_us))
+		arb->wait_free_us = 50000;
+
+	/* Actually add the mux adapter */
+	arb->child = i2c_add_mux_adapter(arb->parent, &pdev->dev, arb, 0, 0, 0,
+					 i2c_arbitrator_select,
+					 i2c_arbitrator_deselect);
+	if (WARN_ON(!arb->child)) {
+		ret = -ENODEV;
+		goto add_adapter_failed;
+	}
+
+	return 0;
+
+add_adapter_failed:
+	gpio_free(arb->ec_gpio);
+ec_request_failed:
+	gpio_free(arb->ap_gpio);
+ap_request_failed:
+	i2c_put_adapter(arb->parent);
+
+	return ret;
+}
+
+static int i2c_arbitrator_remove(struct platform_device *pdev)
+{
+	struct i2c_arbitrator_data *arb = platform_get_drvdata(pdev);
+
+	i2c_del_mux_adapter(arb->child);
+
+	gpio_free(arb->ec_gpio);
+	gpio_free(arb->ap_gpio);
+
+	platform_set_drvdata(pdev, NULL);
+	i2c_put_adapter(arb->parent);
+
+	return 0;
+}
+
+static const struct of_device_id i2c_arbitrator_of_match[] = {
+	{ .compatible = "i2c-arbitrator", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, i2c_arbitrator_of_match);
+
+static struct platform_driver i2c_arbitrator_driver = {
+	.probe	= i2c_arbitrator_probe,
+	.remove	= i2c_arbitrator_remove,
+	.driver	= {
+		.owner	= THIS_MODULE,
+		.name	= "i2c-arbitrator",
+		.of_match_table = of_match_ptr(i2c_arbitrator_of_match),
+	},
+};
+
+static int __init i2c_arbitrator_init(void)
+{
+	return platform_driver_register(&i2c_arbitrator_driver);
+}
+subsys_initcall(i2c_arbitrator_init);
+
+static void __exit i2c_arbitrator_exit(void)
+{
+	platform_driver_unregister(&i2c_arbitrator_driver);
+}
+module_exit(i2c_arbitrator_exit);
+
+MODULE_DESCRIPTION("GPIO-based I2C arbitrator driver");
+MODULE_AUTHOR("Doug Anderson <dianders@chromium.org>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:i2c-arbitrator");
-- 
1.8.1

