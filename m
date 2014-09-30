Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaI3EZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:25:53 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51840 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaI3EZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:25:49 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: galak@codeaurora.org, dmitry.torokhov@gmail.com, zonque@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v4 3/3] cap11xx: support for irq-active-high option
Date: Mon, 29 Sep 2014 21:26:29 -0700
Message-Id: <1412051189-22643-4-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412051189-22643-1-git-send-email-mranostay@gmail.com>
References: <1412051189-22643-1-git-send-email-mranostay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some applications need to use the irq-active-high push-pull option.
This allows it be enabled in the device tree child node.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 Documentation/devicetree/bindings/input/cap11xx.txt | 4 ++++
 drivers/input/keyboard/cap11xx.c                    | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/input/cap11xx.txt b/Documentation/devicetree/bindings/input/cap11xx.txt
index 8031aa5..57407be 100644
--- a/Documentation/devicetree/bindings/input/cap11xx.txt
+++ b/Documentation/devicetree/bindings/input/cap11xx.txt
@@ -28,6 +28,10 @@ Optional properties:
 				Valid values are 1, 2, 4, and 8.
 				By default, a gain of 1 is set.
 
+	microchip,irq-active-high:	By default the interrupt pin is active low
+				open drain. This property allows using the active
+				high push-pull output.
+
 	linux,keycodes:		Specifies an array of numeric keycode values to
 				be used for the channels. If this property is
 				omitted, KEY_A, KEY_B, etc are used as
diff --git a/drivers/input/keyboard/cap11xx.c b/drivers/input/keyboard/cap11xx.c
index adb979e..02bedc1 100644
--- a/drivers/input/keyboard/cap11xx.c
+++ b/drivers/input/keyboard/cap11xx.c
@@ -45,6 +45,7 @@
 #define CAP11XX_REG_STANDBY_SENSITIVITY	0x42
 #define CAP11XX_REG_STANDBY_THRESH	0x43
 #define CAP11XX_REG_CONFIG2		0x44
+#define CAP11XX_REG_CONFIG2_ALT_POL	BIT(6)
 #define CAP11XX_REG_SENSOR_BASE_CNT(X)	(0x50 + (X))
 #define CAP11XX_REG_SENSOR_CALIB	(0xb1 + (X))
 #define CAP11XX_REG_SENSOR_CALIB_LSB1	0xb9
@@ -258,6 +259,13 @@ static int cap11xx_i2c_probe(struct i2c_client *i2c_client,
 			dev_err(dev, "Invalid sensor-gain value %d\n", gain32);
 	}
 
+	if (of_property_read_bool(node, "microchip,irq-active-high")) {
+		error = regmap_update_bits(priv->regmap, CAP11XX_REG_CONFIG2,
+					   CAP11XX_REG_CONFIG2_ALT_POL, 0);
+		if (error)
+			return error;
+	}
+
 	/* Provide some useful defaults */
 	for (i = 0; i < priv->num_channels; i++)
 		priv->keycodes[i] = KEY_A + i;
-- 
1.9.1

