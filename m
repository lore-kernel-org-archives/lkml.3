Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3EUUUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:20:42 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45866 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab3EUUUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:20:39 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 2/2] usb: misc: usb3503: Adding device tree entry 'disabled-ports'
Date: Wed, 22 May 2013 05:20:09 +0900
Message-Id: <1369167613-27282-2-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369167613-27282-1-git-send-email-tobetter@gmail.com>
References: <1369167613-27282-1-git-send-email-tobetter@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add a property 'disabled-ports' representing the unused port
of USB3503. USB3503 can support up to 3 USB host port and each ports can be
controlled to be enabled or disabled. Do not describe this property if all
ports must be enabled.

You can represent the ports to disable in the device tree.

	usb3503@08{
		...
		disabled-ports = <2 3>;
		...
	};

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 Documentation/devicetree/bindings/usb/usb3503.txt |    5 +++++
 drivers/usb/misc/usb3503.c                        |   14 ++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/usb3503.txt b/Documentation/devicetree/bindings/usb/usb3503.txt
index 6813a71..8c5be48 100644
--- a/Documentation/devicetree/bindings/usb/usb3503.txt
+++ b/Documentation/devicetree/bindings/usb/usb3503.txt
@@ -4,6 +4,10 @@ Required properties:
 - compatible: Should be "smsc,usb3503".
 - reg: Specifies the i2c slave address, it should be 0x08.
 - connect-gpios: Should specify GPIO for connect.
+- disabled-ports: Should specify the ports unused.
+	'1' or '2' or '3' are availe for this property to describe the port
+	number. 1~3 property values are possible to be desribed.
+	Do not describe this property if all ports have to be enabled.
 - intn-gpios: Should specify GPIO for interrupt.
 - reset-gpios: Should specify GPIO for reset.
 - initial-mode: Should specify initial mode.
@@ -14,6 +18,7 @@ Examples:
 		compatible = "smsc,usb3503";
 		reg = <0x08>;
 		connect-gpios = <&gpx3 0 1>;
+		disabled-ports = <2 3>;
 		intn-gpios = <&gpx3 4 1>;
 		reset-gpios = <&gpx3 5 1>;
 		initial-mode = <1>;
diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
index ab24bb3..1908ec6 100644
--- a/drivers/usb/misc/usb3503.c
+++ b/drivers/usb/misc/usb3503.c
@@ -186,6 +186,8 @@ static int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	struct usb3503 *hub;
 	int err = -ENOMEM;
 	u32 mode = USB3503_MODE_UNKNOWN;
+	const u32 *property;
+	int len;
 
 	hub = kzalloc(sizeof(struct usb3503), GFP_KERNEL);
 	if (!hub) {
@@ -203,6 +205,18 @@ static int usb3503_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 		hub->gpio_reset		= pdata->gpio_reset;
 		hub->mode		= pdata->initial_mode;
 	} else if (np) {
+		hub->port_off_mask = 0;
+
+		property = of_get_property(np, "disabled-ports", &len);
+		if (property && (len / sizeof(u32)) > 0) {
+			int i;
+			for (i = 0; i < len / sizeof(u32); i++) {
+				u32 port = be32_to_cpu(property[i]);
+				if ((1 <= port) && (port <= 3))
+					hub->port_off_mask |= (1 << port);
+			}
+		}
+
 		hub->gpio_intn	= of_get_named_gpio(np, "connect-gpios", 0);
 		if (hub->gpio_intn == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
-- 
1.7.9.5

