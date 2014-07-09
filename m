Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaGIN6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:58:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47723 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaGIN6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:58:31 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH] w1: ds2482: add support for ds2482-101 sleep pin
Date: Wed,  9 Jul 2014 15:58:17 +0200
Message-Id: <1404914297-3108-1-git-send-email-s.trumtrar@pengutronix.de>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ds2482-101 version of the chip has an active-low sleep pin. Add this as a
gpio to the probe function and describe the DT binding accordingly.
If the pin wouldn't be added and pulled high, the device would not be able to
be probed.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 Documentation/devicetree/bindings/w1/ds2482.txt | 18 ++++++++++++++++++
 drivers/w1/masters/ds2482.c                     |  9 +++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/w1/ds2482.txt

diff --git a/Documentation/devicetree/bindings/w1/ds2482.txt b/Documentation/devicetree/bindings/w1/ds2482.txt
new file mode 100644
index 0000000..e065207
--- /dev/null
+++ b/Documentation/devicetree/bindings/w1/ds2482.txt
@@ -0,0 +1,18 @@
+ds2482 devicetree bindings
+
+Required properties:
+
+ - compatible: "dallas,ds2482"
+
+Optional properties:
+
+ - sleep-gpios: if specified, the ds2482 has a low-active sleep-pin (ds2482-101).
+
+Example:
+
+	1wire@18 {
+		compatible = "dallas,ds2482";
+		reg = <0x18>;
+		sleep-gpios = <&gpio4 2 0>;
+	};
+
diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index e033491..b6b6024 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <asm/delay.h>
 
 #include "../w1.h"
@@ -128,6 +129,7 @@ struct ds2482_data {
 	u8			channel;
 	u8			read_prt;	/* see DS2482_PTR_CODE_xxx */
 	u8			reg_config;
+	struct gpio_desc	*slpz_gpio;
 };
 
 
@@ -449,6 +451,7 @@ static int ds2482_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct ds2482_data *data;
+	struct gpio_desc *gpio;
 	int err = -ENODEV;
 	int temp1;
 	int idx;
@@ -466,6 +469,12 @@ static int ds2482_probe(struct i2c_client *client,
 	data->client = client;
 	i2c_set_clientdata(client, data);
 
+	gpio = devm_gpiod_get(&client->dev, "sleep");
+	if (!IS_ERR(gpio)) {
+		data->slpz_gpio = gpio;
+		gpiod_direction_output(data->slpz_gpio, 1);
+	}
+
 	/* Reset the device (sets the read_ptr to status) */
 	if (ds2482_send_cmd(data, DS2482_CMD_RESET) < 0) {
 		dev_warn(&client->dev, "DS2482 reset failed.\n");
-- 
2.0.0

