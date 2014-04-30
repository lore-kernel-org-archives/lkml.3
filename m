Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbaD3Rpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:45:39 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:33372 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256AbaD3Roi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:44:38 -0400
From: Doug Anderson <dianders@chromium.org>
To: lee.jones@linaro.org, swarren@nvidia.com, wsa@the-dreams.de
Cc: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sameo@linux.intel.com, jdelvare@suse.de,
        shane.huang@amd.com, maxime.ripard@free-electrons.com,
        laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, bjorn.andersson@sonymobile.com,
        kevin.strasser@linux.intel.com, linux@prisktech.co.nz, andrew@lunn.ch,
        andriy.shevchenko@linux.intel.com, schwidefsky@de.ibm.com,
        matt.porter@linaro.org, ch.naveen@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH v3 6/7] i2c: ChromeOS EC tunnel driver
Date: Wed, 30 Apr 2014 10:44:09 -0700
Message-Id: <1398879850-9111-7-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1398879850-9111-1-git-send-email-dianders@chromium.org>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM Chromebooks we have a few devices that are accessed by both the
AP (the main "Application Processor") and the EC (the Embedded
Controller).  These are:
* The battery (sbs-battery).
* The power management unit tps65090.

On the original Samsung ARM Chromebook these devices were on an I2C
bus that was shared between the AP and the EC and arbitrated using
some extranal GPIOs (see i2c-arb-gpio-challenge).

The original arbitration scheme worked well enough but had some
downsides:
* It was nonstandard (not using standard I2C multimaster)
* It only worked if the EC-AP communication was I2C
* It was relatively hard to debug problems (hard to tell if i2c issues
  were caused by the EC, the AP, or some device on the bus).

On the HP Chromebook 11 the design was changed to:
* The AP/EC comms were still i2c, but the battery/tps65090 were no
  longer on the bus used for AP/EC communication.  The battery was
  exposed to the AP through a limited i2c tunnel and tps65090 was
  exposed to the AP through a custom Linux driver.

On the Samsung ARM Chromebook 2 the scheme is changed yet again, now:
* The AP/EC comms are now using SPI for faster speeds.
* The EC's i2c bus is exposed to the AP through a full i2c tunnel.

The upstream "tegra124-venice2" uses the same scheme as the Samsung
ARM Chromebook 2, though it has a different set of components on the
other side of the bus.

This driver supports the scheme used by the Samsung ARM Chromebook 2.
Future patches to this driver could add support for the battery tunnel
on the HP Chromebook 11 (and perhaps could even be used to access
tps65090 on the HP Chromebook 11 instead of using a special driver,
but I haven't researched that enough).

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v3:
- Separate out packet sizing from packet stuffing.
- Get rid of useless dev_dbg.
- Check command_sendrecv against NULL.
- Don't check np against NULL.
- Get rid of useless error on memory alloc fail.
- Get rid of useless platform_set_drvdata(dev, NULL);

Changes in v2:
- Update tunnel binding as per swarren

 .../devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt |  39 +++
 drivers/i2c/busses/Kconfig                         |   9 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            | 318 +++++++++++++++++++++
 drivers/mfd/cros_ec.c                              |   5 +
 5 files changed, 372 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt
 create mode 100644 drivers/i2c/busses/i2c-cros-ec-tunnel.c

diff --git a/Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt b/Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt
new file mode 100644
index 0000000..898f030
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-cros-ec-tunnel.txt
@@ -0,0 +1,39 @@
+I2C bus that tunnels through the ChromeOS EC (cros-ec)
+======================================================
+On some ChromeOS board designs we've got a connection to the EC (embedded
+controller) but no direct connection to some devices on the other side of
+the EC (like a battery and PMIC).  To get access to those devices we need
+to tunnel our i2c commands through the EC.
+
+The node for this device should be under a cros-ec node like google,cros-ec-spi
+or google,cros-ec-i2c.
+
+
+Required properties:
+- compatible: google,cros-ec-i2c-tunnel
+- google,remote-bus: The EC bus we'd like to talk to.
+
+Optional child nodes:
+- One node per I2C device connected to the tunnelled I2C bus.
+
+
+Example:
+	cros-ec@0 {
+		compatible = "google,cros-ec-spi";
+
+		...
+
+		i2c-tunnel {
+			compatible = "google,cros-ec-i2c-tunnel";
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			google,remote-bus = <0>;
+
+			battery: sbs-battery@b {
+				compatible = "sbs,sbs-battery";
+				reg = <0xb>;
+				sbs,poll-retry-count = <1>;
+			};
+		};
+	}
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c94db1c..9a0a6cc 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -993,6 +993,15 @@ config I2C_SIBYTE
 	help
 	  Supports the SiByte SOC on-chip I2C interfaces (2 channels).
 
+config I2C_CROS_EC_TUNNEL
+	tristate "ChromeOS EC tunnel I2C bus"
+	depends on MFD_CROS_EC
+	help
+	  If you say yes here you get an I2C bus that will tunnel i2c commands
+	  through to the other side of the ChromeOS EC to the i2c bus
+	  connected there. This will work whatever the interface used to
+	  talk to the EC (SPI, I2C or LPC).
+
 config SCx200_I2C
 	tristate "NatSemi SCx200 I2C using GPIO pins (DEPRECATED)"
 	depends on SCx200_GPIO
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 18d18ff..e110ca9 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_I2C_VIPERBOARD)	+= i2c-viperboard.o
 # Other I2C/SMBus bus drivers
 obj-$(CONFIG_I2C_ACORN)		+= i2c-acorn.o
 obj-$(CONFIG_I2C_BCM_KONA)	+= i2c-bcm-kona.o
+obj-$(CONFIG_I2C_CROS_EC_TUNNEL)	+= i2c-cros-ec-tunnel.o
 obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
 obj-$(CONFIG_I2C_PCA_ISA)	+= i2c-pca-isa.o
 obj-$(CONFIG_I2C_SIBYTE)	+= i2c-sibyte.o
diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
new file mode 100644
index 0000000..8e7a714
--- /dev/null
+++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
@@ -0,0 +1,318 @@
+/*
+ *  Copyright (C) 2013 Google, Inc
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ * Expose an I2C passthrough to the ChromeOS EC.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+/**
+ * struct ec_i2c_device - Driver data for I2C tunnel
+ *
+ * @dev: Device node
+ * @adap: I2C adapter
+ * @ec: Pointer to EC device
+ * @remote_bus: The EC bus number we tunnel to on the other side.
+ * @request_buf: Buffer for transmitting data; we expect most transfers to fit.
+ * @response_buf: Buffer for receiving data; we expect most transfers to fit.
+ */
+
+struct ec_i2c_device {
+	struct device *dev;
+	struct i2c_adapter adap;
+	struct cros_ec_device *ec;
+
+	u16 remote_bus;
+
+	u8 request_buf[256];
+	u8 response_buf[256];
+};
+
+/**
+ * ec_i2c_count_message - Count bytes needed for ec_i2c_construct_message
+ *
+ * @i2c_msgs: The i2c messages to read
+ * @num: The number of i2c messages.
+ *
+ * Returns the number of bytes the messages will take up.
+ */
+static int ec_i2c_count_message(const struct i2c_msg i2c_msgs[], int num)
+{
+	int i;
+	int size;
+
+	size = sizeof(struct ec_params_i2c_passthru);
+	size += num * sizeof(struct ec_params_i2c_passthru_msg);
+	for (i = 0; i < num; i++)
+		if (!(i2c_msgs[i].flags & I2C_M_RD))
+			size += i2c_msgs[i].len;
+
+	return size;
+}
+
+/**
+ * ec_i2c_construct_message - construct a message to go to the EC
+ *
+ * This function effectively stuffs the standard i2c_msg format of Linux into
+ * a format that the EC understands.
+ *
+ * @buf: The buffer to fill.  We assume that the buffer is big enough.
+ * @i2c_msgs: The i2c messages to read.
+ * @num: The number of i2c messages.
+ * @bus_num: The remote bus number we want to talk to.
+ *
+ * Returns 0 or a negative error number.
+ */
+static int ec_i2c_construct_message(u8 *buf, const struct i2c_msg i2c_msgs[],
+				    int num, u16 bus_num)
+{
+	struct ec_params_i2c_passthru *params;
+	u8 *out_data;
+	int i;
+
+	out_data = buf + sizeof(struct ec_params_i2c_passthru) +
+		   num * sizeof(struct ec_params_i2c_passthru_msg);
+
+	params = (struct ec_params_i2c_passthru *)buf;
+	params->port = bus_num;
+	params->num_msgs = num;
+	for (i = 0; i < num; i++) {
+		const struct i2c_msg *i2c_msg = &i2c_msgs[i];
+		struct ec_params_i2c_passthru_msg *msg = &params->msg[i];
+
+		msg->len = i2c_msg->len;
+		msg->addr_flags = i2c_msg->addr;
+
+		if (i2c_msg->flags & I2C_M_TEN)
+			msg->addr_flags |= EC_I2C_FLAG_10BIT;
+
+		if (i2c_msg->flags & I2C_M_RD) {
+			msg->addr_flags |= EC_I2C_FLAG_READ;
+		} else {
+			memcpy(out_data, i2c_msg->buf, msg->len);
+			out_data += msg->len;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ec_i2c_count_response - Count bytes needed for ec_i2c_parse_response
+ *
+ * @i2c_msgs: The i2c messages to to fill up.
+ * @num: The number of i2c messages expected.
+ *
+ * Returns the number of response bytes expeced.
+ */
+static int ec_i2c_count_response(struct i2c_msg i2c_msgs[], int num)
+{
+	int size;
+	int i;
+
+	size = sizeof(struct ec_response_i2c_passthru);
+	for (i = 0; i < num; i++)
+		if (i2c_msgs[i].flags & I2C_M_RD)
+			size += i2c_msgs[i].len;
+
+	return size;
+}
+
+/**
+ * ec_i2c_parse_response - Parse a response from the EC
+ *
+ * We'll take the EC's response and copy it back into msgs.
+ *
+ * @buf: The buffer to parse.
+ * @i2c_msgs: The i2c messages to to fill up.
+ * @num: The number of i2c messages; will be modified to include the actual
+ *	 number received.
+ *
+ * Returns 0 or a negative error number.
+ */
+static int ec_i2c_parse_response(const u8 *buf, struct i2c_msg i2c_msgs[],
+				 int *num)
+{
+	const struct ec_response_i2c_passthru *resp;
+	const u8 *in_data;
+	int i;
+
+	in_data = buf + sizeof(struct ec_response_i2c_passthru);
+
+	resp = (const struct ec_response_i2c_passthru *)buf;
+	if (resp->i2c_status & EC_I2C_STATUS_TIMEOUT)
+		return -ETIMEDOUT;
+	else if (resp->i2c_status & EC_I2C_STATUS_ERROR)
+		return -EREMOTEIO;
+
+	/* Other side could send us back fewer messages, but not more */
+	if (resp->num_msgs > *num)
+		return -EPROTO;
+	*num = resp->num_msgs;
+
+	for (i = 0; i < *num; i++) {
+		struct i2c_msg *i2c_msg = &i2c_msgs[i];
+
+		if (i2c_msgs[i].flags & I2C_M_RD) {
+			memcpy(i2c_msg->buf, in_data, i2c_msg->len);
+			in_data += i2c_msg->len;
+		}
+	}
+
+	return 0;
+}
+
+static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
+		       int num)
+{
+	struct ec_i2c_device *bus = adap->algo_data;
+	struct device *dev = bus->dev;
+	const u16 bus_num = bus->remote_bus;
+	int request_len;
+	int response_len;
+	u8 *request = NULL;
+	u8 *response = NULL;
+	int result;
+
+	request_len = ec_i2c_count_message(i2c_msgs, num);
+	if (request_len < 0) {
+		dev_warn(dev, "Error constructing message %d\n", request_len);
+		result = request_len;
+		goto exit;
+	}
+	response_len = ec_i2c_count_response(i2c_msgs, num);
+	if (response_len < 0) {
+		/* Unexpected; no errors should come when NULL response */
+		dev_warn(dev, "Error preparing response %d\n", response_len);
+		result = response_len;
+		goto exit;
+	}
+
+	if (request_len <= ARRAY_SIZE(bus->request_buf)) {
+		request = bus->request_buf;
+	} else {
+		request = kzalloc(request_len, GFP_KERNEL);
+		if (request == NULL) {
+			result = -ENOMEM;
+			goto exit;
+		}
+	}
+	if (response_len <= ARRAY_SIZE(bus->response_buf)) {
+		response = bus->response_buf;
+	} else {
+		response = kzalloc(response_len, GFP_KERNEL);
+		if (response == NULL) {
+			result = -ENOMEM;
+			goto exit;
+		}
+	}
+
+	ec_i2c_construct_message(request, i2c_msgs, num, bus_num);
+	result = bus->ec->command_sendrecv(bus->ec, EC_CMD_I2C_PASSTHRU,
+					   request, request_len,
+					   response, response_len);
+	if (result)
+		goto exit;
+
+	result = ec_i2c_parse_response(response, i2c_msgs, &num);
+	if (result < 0)
+		goto exit;
+
+	/* Indicate success by saying how many messages were sent */
+	result = num;
+exit:
+	if (request != bus->request_buf)
+		kfree(request);
+	if (response != bus->response_buf)
+		kfree(response);
+
+	return result;
+}
+
+static u32 ec_i2c_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static const struct i2c_algorithm ec_i2c_algorithm = {
+	.master_xfer	= ec_i2c_xfer,
+	.functionality	= ec_i2c_functionality,
+};
+
+static int ec_i2c_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
+	struct device *dev = &pdev->dev;
+	struct ec_i2c_device *bus = NULL;
+	u32 remote_bus;
+	int err;
+
+	if (!ec->command_sendrecv) {
+		dev_err(dev, "Missing sendrecv\n");
+		return -EINVAL;
+	}
+
+	bus = devm_kzalloc(dev, sizeof(*bus), GFP_KERNEL);
+	if (bus == NULL)
+		return -ENOMEM;
+
+	err = of_property_read_u32(np, "google,remote-bus", &remote_bus);
+	if (err) {
+		dev_err(dev, "Couldn't read remote-bus property\n");
+		return err;
+	}
+	bus->remote_bus = remote_bus;
+
+	bus->ec = ec;
+	bus->dev = dev;
+
+	bus->adap.owner = THIS_MODULE;
+	strlcpy(bus->adap.name, "cros-ec-i2c-tunnel", sizeof(bus->adap.name));
+	bus->adap.algo = &ec_i2c_algorithm;
+	bus->adap.algo_data = bus;
+	bus->adap.dev.parent = &pdev->dev;
+	bus->adap.dev.of_node = np;
+
+	err = i2c_add_adapter(&bus->adap);
+	if (err) {
+		dev_err(dev, "cannot register i2c adapter\n");
+		return err;
+	}
+	platform_set_drvdata(pdev, bus);
+
+	return err;
+}
+
+static int ec_i2c_remove(struct platform_device *dev)
+{
+	struct ec_i2c_device *bus = platform_get_drvdata(dev);
+
+	i2c_del_adapter(&bus->adap);
+
+	return 0;
+}
+
+static struct platform_driver ec_i2c_tunnel_driver = {
+	.probe = ec_i2c_probe,
+	.remove = ec_i2c_remove,
+	.driver = {
+		.name = "cros-ec-i2c-tunnel",
+	},
+};
+
+module_platform_driver(ec_i2c_tunnel_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("EC I2C tunnel driver");
+MODULE_ALIAS("platform:cros-ec-i2c-tunnel");
diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
index c58ab96..61bc909 100644
--- a/drivers/mfd/cros_ec.c
+++ b/drivers/mfd/cros_ec.c
@@ -90,6 +90,11 @@ static const struct mfd_cell cros_devs[] = {
 		.id = 1,
 		.of_compatible = "google,cros-ec-keyb",
 	},
+	{
+		.name = "cros-ec-i2c-tunnel",
+		.id = 2,
+		.of_compatible = "google,cros-ec-i2c-tunnel",
+	},
 };
 
 int cros_ec_register(struct cros_ec_device *ec_dev)
-- 
1.9.1.423.g4596e3a

