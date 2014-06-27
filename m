Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaF0T6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:58:14 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:64564 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaF0T4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:56:46 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>, sjg@chromium.org,
        afaerber@suse.de, stephan@synkhronix.com, olof@lixom.net,
        Doug Anderson <dianders@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] i2c: cros_ec: Support a limited i2c tunnel for exynos5250-spring
Date: Fri, 27 Jun 2014 12:56:13 -0700
Message-Id: <1403898973-19571-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403898973-19571-1-git-send-email-dianders@chromium.org>
References: <1403898973-19571-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On exynos5250-spring the battery and tps65090 regulator are sitting on
an i2c bus behind the EC (much like on exynos5420-peach-pit).  However
on spring we don't have the full EC_CMD_I2C_PASSTHRU command.

For the production kernel of spring we used a solution like this:
- Fork the tps65090 driver and make a version that talks straight to
  the cros_ec MFD driver and sends special EC commands for talking to
  the regulator.
- Add code into the i2c tunnel to look for i2c transfers and convert
  them into special EC commands for talking to the battery.

For reference:
* http://crosreview.com/66116
* https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/regulator/cros_ec-tps65090.c

The above solution works great but is a bunch of code.  It appears
that we can make do with the limited i2c passthrough commands that
actually happened to be present on the exynos5250-spring EC.  Doing
this we can present ourselves as supporting a small subset of smbus.
We might need to do a few extra transfers here and there but we don't
need any extra code.

Seriss-cc: linux-samsung-soc
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/i2c/busses/i2c-cros-ec-tunnel.c | 92 ++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
index 6d7d009..c52c491 100644
--- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
+++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
@@ -38,6 +38,76 @@ struct ec_i2c_device {
 	u8 response_buf[256];
 };
 
+static int ec_smbus_xfer(struct i2c_adapter *adap, u16 addr,
+			   unsigned short flags, char read_write,
+			   u8 command, int size, union i2c_smbus_data *data)
+{
+	struct ec_i2c_device *bus = adap->algo_data;
+	struct cros_ec_command msg = {};
+	int result;
+
+	if (read_write == I2C_SMBUS_WRITE) {
+		struct ec_params_i2c_write params;
+
+		params.addr = addr << 1;
+		params.port = bus->remote_bus;
+		params.offset = command;
+
+		if (size == I2C_SMBUS_WORD_DATA) {
+			params.data = data->word;
+			params.write_size = 16;
+		} else if (size == I2C_SMBUS_BYTE_DATA) {
+			params.data = data->byte;
+			params.write_size = 8;
+		} else {
+			return -EINVAL;
+		}
+
+		msg.command = EC_CMD_I2C_WRITE;
+		msg.outdata = (uint8_t *)&params;
+		msg.outsize = sizeof(params);
+
+		result = bus->ec->cmd_xfer(bus->ec, &msg);
+		if (result < 0)
+			return -EIO;
+
+		return 0;
+	} else if (read_write == I2C_SMBUS_READ) {
+		struct ec_params_i2c_read params;
+		struct ec_response_i2c_read response;
+
+		params.addr = addr << 1;
+		params.port = bus->remote_bus;
+		params.offset = command;
+
+		if (size == I2C_SMBUS_WORD_DATA)
+			params.read_size = 16;
+		else if (size == I2C_SMBUS_BYTE_DATA)
+			params.read_size = 8;
+		else
+			return -EINVAL;
+
+		msg.command = EC_CMD_I2C_READ;
+		msg.outdata = (uint8_t *)&params;
+		msg.outsize = sizeof(params);
+		msg.indata = (uint8_t *)&response;
+		msg.insize = sizeof(response);
+
+		result = bus->ec->cmd_xfer(bus->ec, &msg);
+		if (result < 0)
+			return -EIO;
+
+		if (size == I2C_SMBUS_WORD_DATA)
+			data->word = response.data;
+		else
+			data->byte = response.data;
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 /**
  * ec_i2c_count_message - Count bytes needed for ec_i2c_construct_message
  *
@@ -233,6 +303,11 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
 	if (result < 0)
 		goto exit;
 
+	if (msg.result == EC_RES_INVALID_COMMAND) {
+		result = -EINVAL;
+		goto exit;
+	}
+
 	result = ec_i2c_parse_response(response, i2c_msgs, &num);
 	if (result < 0)
 		goto exit;
@@ -258,6 +333,16 @@ static const struct i2c_algorithm ec_i2c_algorithm = {
 	.functionality	= ec_i2c_functionality,
 };
 
+static u32 ec_smbus_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA;
+}
+
+static const struct i2c_algorithm ec_i2c_limited_algorithm = {
+	.smbus_xfer	= ec_smbus_xfer,
+	.functionality	= ec_smbus_functionality,
+};
+
 static int ec_i2c_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -288,11 +373,16 @@ static int ec_i2c_probe(struct platform_device *pdev)
 
 	bus->adap.owner = THIS_MODULE;
 	strlcpy(bus->adap.name, "cros-ec-i2c-tunnel", sizeof(bus->adap.name));
-	bus->adap.algo = &ec_i2c_algorithm;
 	bus->adap.algo_data = bus;
 	bus->adap.dev.parent = &pdev->dev;
 	bus->adap.dev.of_node = np;
 
+	/* Test if we can support full passthrough or just limited */
+	if (ec_i2c_xfer(&bus->adap, NULL, 0) == 0)
+		bus->adap.algo = &ec_i2c_algorithm;
+	else
+		bus->adap.algo = &ec_i2c_limited_algorithm;
+
 	err = i2c_add_adapter(&bus->adap);
 	if (err) {
 		dev_err(dev, "cannot register i2c adapter\n");
-- 
2.0.0.526.g5318336

