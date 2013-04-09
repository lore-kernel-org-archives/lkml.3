Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab3DIVe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:34:59 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:53188 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964912Ab3DIVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:34:53 -0400
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        grant.likely@secretlab.ca, yuvaraj.cd@gmail.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, girish.shivananjappa@linaro.org,
        bhushan.r@samsung.com, sreekumar.c@samsung.com,
        prashanth.g@samsung.com, olof@lixom.net, djkurtz@chromium.org,
        swarren@wwwdotorg.org, linux@roeck-us.net,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>, Jean Delvare <khali@linux-fr.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH v5 1/3] i2c: mux: Add i2c-arb-gpio-challenge 'mux' driver
Date: Tue,  9 Apr 2013 14:34:28 -0700
Message-Id: <1365543270-10736-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363192583-26363-1-git-send-email-dianders@chromium.org>
References: <1363192583-26363-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-arb-gpio-challenge driver implements an I2C arbitration scheme
where masters need to claim the bus with a GPIO before they can start
a transcation.  This should generally only be used when standard I2C
multimaster isn't appropriate for some reason (errata/bugs).

This driver is based on code that Simon Glass added to the i2c-s3c2410
driver in the Chrome OS kernel 3.4 tree.  The current incarnation as a
mux driver is as suggested by Grant Likely.  See
<https://patchwork.kernel.org/patch/1877311/> for some history.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
(Sorry if you got v5 more than once--apparently the CC list has grown
 too long and my mail was rejected; resending with a shorter header)

Changes in v5:
- Renamed as per Wolfram Sang.
- Avoid references to AP and EC.
- Bindings are now generic and could support N other masters; code
  still only supports one other master.
- Replaced all instances of WARN_ON with error messages.
- Left Stephen's Reviewed-by from v4 since changes aren't huge, but
  please yell if you want it removed or don't like something about the
  new code; removed Naveen's Tested-by for now.

Changes in v4: None
Changes in v3:
- Handle of_find_i2c_adapter_by_node() failure more properly by
  changing init order.
- Don't warn on -EPROBE_DEFER from calls that could return it.
- Move to module_platform_driver().  As we pull in parts of the system
  that rely on devices under this i2c bus we'll need to make sure they
  can handle the fact that they'll be initted later now.

Changes in v2:
- Renamed to i2c-arb-gpio-challenge.
- Documented "microsecond" properties as optional; removed
  "bus-arbitration" prefix since it was just extra wordy.
- Split GPIOs into two properties to make it cleaner.
- Capitalized I2C in freeform text.
- Get 'active low' from device tree.

 .../bindings/i2c/i2c-arb-gpio-challenge.txt        |  80 +++++++
 drivers/i2c/muxes/Kconfig                          |  11 +
 drivers/i2c/muxes/Makefile                         |   2 +
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c         | 252 +++++++++++++++++++++
 4 files changed, 345 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt
 create mode 100644 drivers/i2c/muxes/i2c-arb-gpio-challenge.c

diff --git a/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt b/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt
new file mode 100644
index 0000000..726e099
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-arb-gpio-challenge.txt
@@ -0,0 +1,80 @@
+GPIO-based I2C Arbitration
+==========================
+This uses GPIO lines to arbitrate who is the master of an I2C bus in a
+multimaster situation.
+
+In many cases using GPIOs to arbitrate is not needed and a design can use
+the standard I2C multi-master rules.  Using GPIOs is generally useful in
+the case where there is a device on the bus that has errata and/or bugs
+that makes standard multimaster mode not feasible.
+
+
+Algorithm:
+
+All masters on the bus have a 'bus claim' line which is an output that the
+others can see. These are all active low with pull-ups enabled.  We'll
+describe these lines as:
+
+- OUR_CLAIM: output from us signaling to other hosts that we want the bus
+- THEIR_CLAIMS: output from others signaling that they want the bus
+
+The basic algorithm is to assert your line when you want the bus, then make
+sure that the other side doesn't want it also.  A detailed explanation is best
+done with an example.
+
+Let's say we want to claim the bus.  We:
+1. Assert OUR_CLAIM.
+2. Waits a little bit for the other sides to notice (slew time, say 10
+   microseconds).
+3. Check THEIR_CLAIMS.  If none are asserted then the we have the bus and we are
+   done.
+4. Otherwise, wait for a few milliseconds and see if THEIR_CLAIMS are released.
+5. If not, back off, release the claim and wait for a few more milliseconds.
+6. Go back to 1 (until retry time has expired).
+
+
+Required properties:
+- compatible: i2c-arb-gpio-challenge
+- our-claim-gpio: The GPIO that we use to claim the bus.
+- their-claim-gpios: The GPIOs that the other sides use the claim the bus.
+  Note that some implementations may only support a single other master.
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
+		compatible = "i2c-arb-gpio-challenge";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		i2c-parent = <&{/i2c@12CA0000}>;
+
+		our-claim-gpio = <&gpf0 3 1>;
+		their-claim-gpios = <&gpe0 4 1>;
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
index 0be5b83..ab4dcaf 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -5,6 +5,17 @@
 menu "Multiplexer I2C Chip support"
 	depends on I2C_MUX
 
+config I2C_ARB_GPIO_CHALLENGE
+	tristate "GPIO-based I2C arbitration"
+	depends on GENERIC_GPIO && OF
+	help
+	  If you say yes to this option, support will be included for an
+	  I2C multimaster arbitration scheme using GPIOs where masters have
+	  to claim the bus by asserting a GPIO.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-arb-gpio-challenge.
+
 config I2C_MUX_GPIO
 	tristate "GPIO-based I2C multiplexer"
 	depends on GENERIC_GPIO
diff --git a/drivers/i2c/muxes/Makefile b/drivers/i2c/muxes/Makefile
index 76da869..465778b 100644
--- a/drivers/i2c/muxes/Makefile
+++ b/drivers/i2c/muxes/Makefile
@@ -1,6 +1,8 @@
 #
 # Makefile for multiplexer I2C chip drivers.
 
+obj-$(CONFIG_I2C_ARB_GPIO_CHALLENGE)	+= i2c-arb-gpio-challenge.o
+
 obj-$(CONFIG_I2C_MUX_GPIO)	+= i2c-mux-gpio.o
 obj-$(CONFIG_I2C_MUX_PCA9541)	+= i2c-mux-pca9541.o
 obj-$(CONFIG_I2C_MUX_PCA954x)	+= i2c-mux-pca954x.o
diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
new file mode 100644
index 0000000..bda020a
--- /dev/null
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -0,0 +1,252 @@
+/*
+ * GPIO-based I2C Arbitration
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
+ * @our_gpio: GPIO we'll use to claim.
+ * @our_gpio_release: 0 if active high; 1 if active low; AKA if the GPIO ==
+ *   this then consider it released.
+ * @their_gpio: GPIO that the other side will use to claim.
+ * @their_gpio_release: 0 if active high; 1 if active low; AKA if the GPIO ==
+ *   this then consider it released.
+ * @slew_delay_us: microseconds to wait for a GPIO to go high.
+ * @wait_retry_us: we'll attempt another claim after this many microseconds.
+ * @wait_free_us: we'll give up after this many microseconds.
+ */
+
+struct i2c_arbitrator_data {
+	struct i2c_adapter *parent;
+	struct i2c_adapter *child;
+
+	int		our_gpio;
+	int		our_gpio_release;
+	int		their_gpio;
+	int		their_gpio_release;
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
+		gpio_set_value(arb->our_gpio, !arb->our_gpio_release);
+		udelay(arb->slew_delay_us);
+
+		/* Wait for the other master to release it */
+		stop_retry = jiffies + usecs_to_jiffies(arb->wait_retry_us) + 1;
+		while (time_before(jiffies, stop_retry)) {
+			int gpio_val = !!gpio_get_value(arb->their_gpio);
+
+			if (gpio_val == arb->their_gpio_release) {
+				/* We got it, so return */
+				return 0;
+			}
+
+			usleep_range(50, 200);
+		}
+
+		/* It didn't release, so give up, wait, and try again */
+		gpio_set_value(arb->our_gpio, arb->our_gpio_release);
+
+		usleep_range(arb->wait_retry_us, arb->wait_retry_us * 2);
+	} while (time_before(jiffies, stop_time));
+
+	/* Give up, release our claim */
+	gpio_set_value(arb->our_gpio, arb->our_gpio_release);
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
+	/* Release the bus and wait for the other master to notice */
+	gpio_set_value(arb->our_gpio, arb->our_gpio_release);
+	udelay(arb->slew_delay_us);
+
+	return 0;
+}
+
+static int i2c_arbitrator_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct device_node *parent_np;
+	struct i2c_arbitrator_data *arb;
+	enum of_gpio_flags gpio_flags;
+	unsigned long out_init;
+	int ret;
+
+	/* We only support probing from device tree; no platform_data */
+	if (!np) {
+		dev_err(dev, "Cannot find device tree node\n");
+		return -ENODEV;
+	}
+	if (dev->platform_data) {
+		dev_err(dev, "Platform data is not supported\n");
+		return -EINVAL;
+	}
+
+	arb = devm_kzalloc(dev, sizeof(*arb), GFP_KERNEL);
+	if (!arb) {
+		dev_err(dev, "Cannot allocate i2c_arbitrator_data\n");
+		return -ENOMEM;
+	}
+	platform_set_drvdata(pdev, arb);
+
+	/* Request GPIOs */
+	ret = of_get_named_gpio_flags(np, "our-claim-gpio", 0, &gpio_flags);
+	if (!gpio_is_valid(ret)) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Error getting our-claim-gpio\n");
+		return ret;
+	}
+	arb->our_gpio = ret;
+	arb->our_gpio_release = !!(gpio_flags & OF_GPIO_ACTIVE_LOW);
+	out_init = (gpio_flags & OF_GPIO_ACTIVE_LOW) ?
+		GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+	ret = devm_gpio_request_one(dev, arb->our_gpio, out_init,
+				    "our-claim-gpio");
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Error requesting our-claim-gpio\n");
+		return ret;
+	}
+
+	ret = of_get_named_gpio_flags(np, "their-claim-gpios", 0, &gpio_flags);
+	if (!gpio_is_valid(ret)) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Error getting their-claim-gpio\n");
+		return ret;
+	}
+	arb->their_gpio = ret;
+	arb->their_gpio_release = !!(gpio_flags & OF_GPIO_ACTIVE_LOW);
+	ret = devm_gpio_request_one(dev, arb->their_gpio, GPIOF_IN,
+				    "their-claim-gpio");
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Error requesting their-claim-gpio\n");
+		return ret;
+	}
+
+	/* At the moment we only support a single two master (us + 1 other) */
+	if (gpio_is_valid(of_get_named_gpio(np, "their-claim-gpios", 1))) {
+		dev_err(dev, "Only one other master is supported\n");
+		return -EINVAL;
+	}
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
+	if (!parent_np) {
+		dev_err(dev, "Cannot parse i2c-parent\n");
+		return -EINVAL;
+	}
+	arb->parent = of_find_i2c_adapter_by_node(parent_np);
+	if (!arb->parent) {
+		dev_err(dev, "Cannot find parent bus\n");
+		return -EINVAL;
+	}
+
+	/* Actually add the mux adapter */
+	arb->child = i2c_add_mux_adapter(arb->parent, dev, arb, 0, 0, 0,
+					 i2c_arbitrator_select,
+					 i2c_arbitrator_deselect);
+	if (!arb->child) {
+		dev_err(dev, "Failed to add adapter\n");
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
+	{ .compatible = "i2c-arb-gpio-challenge", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, i2c_arbitrator_of_match);
+
+static struct platform_driver i2c_arbitrator_driver = {
+	.probe	= i2c_arbitrator_probe,
+	.remove	= i2c_arbitrator_remove,
+	.driver	= {
+		.owner	= THIS_MODULE,
+		.name	= "i2c-arb-gpio-challenge",
+		.of_match_table = of_match_ptr(i2c_arbitrator_of_match),
+	},
+};
+
+module_platform_driver(i2c_arbitrator_driver);
+
+MODULE_DESCRIPTION("GPIO-based I2C Arbitration");
+MODULE_AUTHOR("Doug Anderson <dianders@chromium.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:i2c-arb-gpio-challenge");
-- 
1.8.1.3

