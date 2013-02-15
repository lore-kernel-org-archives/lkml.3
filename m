Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3BOTwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:52:09 -0500
Received: from mail-ye0-f202.google.com ([209.85.213.202]:52552 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3BOTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:52:07 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
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
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH v3 1/3] i2c: mux: Add i2c-arbitrator-cros-ec 'mux' driver
Date: Fri, 15 Feb 2013 11:46:11 -0800
Message-Id: <1360957573-864-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360887677-20758-1-git-send-email-dianders@chromium.org>
References: <1360887677-20758-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-arbitrator-cros-ec driver implements the arbitration scheme
that the Embedded Controller (EC) on the ARM Chromebook expects to use
for bus multimastering.  This i2c-arbitrator-cros-ec driver could also
be used in other places where standard I2C bus arbitration can't be
used and two extra GPIOs are available for arbitration.

This driver is based on code that Simon Glass added to the i2c-s3c2410
driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
mux driver is as suggested by Grant Likely.  See
<https://patchwork.kernel.org/patch/1877311/> for some history.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes in v3:
- Handle of_find_i2c_adapter_by_node() failure more properly by
  changing init order.
- Don't warn on -EPROBE_DEFER from calls that could return it.
- Move to module_platform_driver().  As we pull in parts of the system
  that rely on devices under this i2c bus we'll need to make sure they
  can handle the fact that they'll be initted later now.

Changes in v2:
- Renamed to i2c-arbitrator-cros-ec.
- Documented "microsecond" properties as optional; removed
  "bus-arbitration" prefix since it was just extra wordy.
- Split GPIOs into two properties to make it cleaner.
- Capitalized I2C in freeform text.
- Get 'active low' from device tree.

 .../bindings/i2c/i2c-arbitrator-cros-ec.txt        |  76 +++++++
 drivers/i2c/muxes/Kconfig                          |  11 +
 drivers/i2c/muxes/Makefile                         |   2 +
 drivers/i2c/muxes/i2c-arbitrator-cros-ec.c         | 222 +++++++++++++++++++++
 4 files changed, 311 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt
 create mode 100644 drivers/i2c/muxes/i2c-arbitrator-cros-ec.c

diff --git a/Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt b/Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt
new file mode 100644
index 0000000..1f893e7
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-arbitrator-cros-ec.txt
@@ -0,0 +1,76 @@
+GPIO-based Arbitration used by the ARM Chromebook (exynos5250-snow)
+===================================================================
+This uses GPIO lines between the AP (Application Processor) and an attached
+EC (Embedded Controller) which both want to talk on the same I2C bus as master.
+
+The AP and EC each have a 'bus claim' line, which is an output that the
+other can see. These are both active low, with pull-ups enabled.
+
+- AP_CLAIM: output from AP, signalling to the EC that the AP wants the bus
+- EC_CLAIM: output from EC, signalling to the AP that the EC wants the bus
+
+This mechanism is used instead of standard I2C multimaster to avoid some of the
+subtle driver and silicon bugs that are often present with I2C multimaster.
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
+- compatible: i2c-arbitrator-cros-ec
+- ap-claim-gpio: The GPIO that we (the AP) use to claim the bus.
+- ec-claim-gpio: The GPIO that the other side (the EC) uses the claim the bus.
+- Standard I2C mux properties. See mux.txt in this directory.
+- Single I2C child bus node at reg 0. See mux.txt in this directory.
+
+Optional properties:
+- slew-delay-us: microseconds to wait for a GPIO to go high. Default is 10 us.
+- wait-retry-us: we'll attempt another claim after this many microseconds.
+    Default is 3000 us.
+- wait-free-us: we'll give up after this many microseconds. Default is 50000 us.
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
+		compatible = "i2c-arbitrator-cros-ec";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&{/i2c@12CA0000}>;
+
+		ap-claim-gpio = <&gpf0 3 1 0x10000 0>;
+		ec-claim-gpio = <&gpe0 4 0 0x10003 0>;
+		slew-delay-us = <10>;
+		wait-retry-us = <3000>;
+		wait-free-us = <50000>;
+
+		i2c@0 {
+			reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			i2c@52 {
+				// Normal I2C device
+			};
+		};
+	};
diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index 0be5b83..ca19378 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -5,6 +5,17 @@
 menu "Multiplexer I2C Chip support"
 	depends on I2C_MUX
 
+config I2C_ARBITRATOR_CROS_EC
+	tristate "GPIO-based I2C arbitrator used on exynos5250-snow"
+	depends on GENERIC_GPIO && OF
+	help
+	  If you say yes to this option, support will be included for an
+	  I2C multimaster arbitration scheme using GPIOs that is used in
+	  the Samsung ARM Chromebook (exynos5250-snow).
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-arbitrator-cros-ec.
+
 config I2C_MUX_GPIO
 	tristate "GPIO-based I2C multiplexer"
 	depends on GENERIC_GPIO
diff --git a/drivers/i2c/muxes/Makefile b/drivers/i2c/muxes/Makefile
index 76da869..e60dcc1 100644
--- a/drivers/i2c/muxes/Makefile
+++ b/drivers/i2c/muxes/Makefile
@@ -1,6 +1,8 @@
 #
 # Makefile for multiplexer I2C chip drivers.
 
+obj-$(CONFIG_I2C_ARBITRATOR_CROS_EC)	+= i2c-arbitrator-cros-ec.o
+
 obj-$(CONFIG_I2C_MUX_GPIO)	+= i2c-mux-gpio.o
 obj-$(CONFIG_I2C_MUX_PCA9541)	+= i2c-mux-pca9541.o
 obj-$(CONFIG_I2C_MUX_PCA954x)	+= i2c-mux-pca954x.o
diff --git a/drivers/i2c/muxes/i2c-arbitrator-cros-ec.c b/drivers/i2c/muxes/i2c-arbitrator-cros-ec.c
new file mode 100644
index 0000000..f95b591
--- /dev/null
+++ b/drivers/i2c/muxes/i2c-arbitrator-cros-ec.c
@@ -0,0 +1,222 @@
+/*
+ * I2C arbitrator driver for the ARM Chromebook
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
+/**
+ * struct i2c_arbitrator_data - Driver data for I2C arbitrator
+ *
+ * @parent: Parent adapter
+ * @child: Child bus
+ * @ap_gpio: GPIO we'll use to claim.
+ * @ap_gpio_release: 0 if active high; 1 if active low; AKA if the GPIO == this
+ *   then consider it released.
+ * @ec_gpio: GPIO that the other side will use to claim.
+ * @ec_gpio_release: 0 if active high; 1 if active low; AKA if the GPIO == this
+ *   then consider it released.
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
+	int		ap_gpio_release;
+	int		ec_gpio;
+	int		ec_gpio_release;
+	unsigned int	slew_delay_us;
+	unsigned int	wait_retry_us;
+	unsigned int	wait_free_us;
+};
+
+
+/**
+ * i2c_arbitrator_select - claim the I2C bus
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
+		gpio_set_value(arb->ap_gpio, !arb->ap_gpio_release);
+		udelay(arb->slew_delay_us);
+
+		/* Wait for the EC to release it */
+		stop_retry = jiffies + usecs_to_jiffies(arb->wait_retry_us) + 1;
+		while (time_before(jiffies, stop_retry)) {
+			int gpio_val = !!gpio_get_value(arb->ec_gpio);
+
+			if (gpio_val == arb->ec_gpio_release) {
+				/* We got it, so return */
+				return 0;
+			}
+
+			usleep_range(50, 200);
+		}
+
+		/* It didn't release, so give up, wait, and try again */
+		gpio_set_value(arb->ap_gpio, arb->ap_gpio_release);
+
+		usleep_range(arb->wait_retry_us, arb->wait_retry_us * 2);
+	} while (time_before(jiffies, stop_time));
+
+	/* Give up, release our claim */
+	gpio_set_value(arb->ap_gpio, arb->ap_gpio_release);
+	udelay(arb->slew_delay_us);
+	dev_err(&adap->dev, "Could not claim bus, timeout\n");
+	return -EBUSY;
+}
+
+/**
+ * i2c_arbitrator_deselect - release the I2C bus
+ *
+ * Release the I2C bus using the GPIO-based signalling protocol.
+ */
+static int i2c_arbitrator_deselect(struct i2c_adapter *adap, void *data,
+				   u32 chan)
+{
+	const struct i2c_arbitrator_data *arb = data;
+
+	/* Release the bus and wait for the EC to notice */
+	gpio_set_value(arb->ap_gpio, arb->ap_gpio_release);
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
+	enum of_gpio_flags gpio_flags;
+	unsigned long out_init;
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
+	/* Request GPIOs */
+	ret = of_get_named_gpio_flags(np, "ap-claim-gpio", 0, &gpio_flags);
+	if (ret == -EPROBE_DEFER || WARN_ON(!gpio_is_valid(ret)))
+		return ret;
+	arb->ap_gpio = ret;
+	arb->ap_gpio_release = !!(gpio_flags & OF_GPIO_ACTIVE_LOW);
+	out_init = (gpio_flags & OF_GPIO_ACTIVE_LOW) ?
+		GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+	ret = devm_gpio_request_one(&pdev->dev, arb->ap_gpio, out_init,
+				    "ap-claim-gpio");
+	if (ret == -EPROBE_DEFER || WARN_ON(ret))
+		return ret;
+
+	ret = of_get_named_gpio_flags(np, "ec-claim-gpio", 0, &gpio_flags);
+	if (ret == -EPROBE_DEFER || WARN_ON(!gpio_is_valid(ret)))
+		return ret;
+	arb->ec_gpio = ret;
+	arb->ec_gpio_release = !!(gpio_flags & OF_GPIO_ACTIVE_LOW);
+	ret = devm_gpio_request_one(&pdev->dev, arb->ec_gpio, GPIOF_IN,
+				    "ec-claim-gpio");
+	if (ret == -EPROBE_DEFER || WARN_ON(ret))
+		return ret;
+
+	/* Arbitration parameters */
+	if (of_property_read_u32(np, "slew-delay-us", &arb->slew_delay_us))
+		arb->slew_delay_us = 10;
+	if (of_property_read_u32(np, "wait-retry-us", &arb->wait_retry_us))
+		arb->wait_retry_us = 3000;
+	if (of_property_read_u32(np, "wait-free-us", &arb->wait_free_us))
+		arb->wait_free_us = 50000;
+
+	/* Find our parent */
+	parent_np = of_parse_phandle(np, "i2c-parent", 0);
+	if (WARN_ON(!parent_np))
+		return -EINVAL;
+	arb->parent = of_find_i2c_adapter_by_node(parent_np);
+	if (WARN_ON(!arb->parent))
+		return -EINVAL;
+
+	/* Actually add the mux adapter */
+	arb->child = i2c_add_mux_adapter(arb->parent, &pdev->dev, arb, 0, 0, 0,
+					 i2c_arbitrator_select,
+					 i2c_arbitrator_deselect);
+	if (WARN_ON(!arb->child)) {
+		ret = -ENODEV;
+		i2c_put_adapter(arb->parent);
+	}
+
+	return ret;
+}
+
+static int i2c_arbitrator_remove(struct platform_device *pdev)
+{
+	struct i2c_arbitrator_data *arb = platform_get_drvdata(pdev);
+
+	i2c_del_mux_adapter(arb->child);
+	i2c_put_adapter(arb->parent);
+
+	return 0;
+}
+
+static const struct of_device_id i2c_arbitrator_of_match[] = {
+	{ .compatible = "i2c-arbitrator-cros-ec", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, i2c_arbitrator_of_match);
+
+static struct platform_driver i2c_arbitrator_driver = {
+	.probe	= i2c_arbitrator_probe,
+	.remove	= i2c_arbitrator_remove,
+	.driver	= {
+		.owner	= THIS_MODULE,
+		.name	= "i2c-arbitrator-cros-ec",
+		.of_match_table = of_match_ptr(i2c_arbitrator_of_match),
+	},
+};
+
+module_platform_driver(i2c_arbitrator_driver);
+
+MODULE_DESCRIPTION("I2C arbitrator driver for the ARM Chromebook");
+MODULE_AUTHOR("Doug Anderson <dianders@chromium.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:i2c-arbitrator-cros-ec");
-- 
1.8.1

