Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbbAUVfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:35:09 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:39465 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbbAUVeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:34:18 -0500
From: Olliver Schinagl <o.schinagl@ultimaker.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Alexander Shiyan <shc_work@mail.ru>,
        Wolfram Sang <wsa@the-dreams.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: [PATCH v2 4/4] leds: no longer use unnamed gpios
Date: Wed, 21 Jan 2015 22:33:48 +0100
Message-Id: <1421876028-22799-5-git-send-email-o.schinagl@ultimaker.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com>
References: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

The gpio document says we should not use unnamed bindings for gpios.
This patch uses the 'led-' prefix to the gpios and updates code and
documents. Because the devm_get_gpiod_from_child() falls back to using
old-style unnamed gpios, we can update the code first, and update
dts files as time allows.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 Documentation/devicetree/bindings/leds/leds-gpio.txt | 12 ++++++------
 drivers/input/keyboard/gpio_keys_polled.c            | 20 ++++++++++++--------
 drivers/leds/leds-gpio.c                             |  2 +-
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/leds-gpio.txt b/Documentation/devicetree/bindings/leds/leds-gpio.txt
index fea1ebf..1ac7ccb5 100644
--- a/Documentation/devicetree/bindings/leds/leds-gpio.txt
+++ b/Documentation/devicetree/bindings/leds/leds-gpio.txt
@@ -7,7 +7,7 @@ Each LED is represented as a sub-node of the gpio-leds device.  Each
 node's name represents the name of the corresponding LED.
 
 LED sub-node properties:
-- gpios :  Should specify the LED's GPIO, see "gpios property" in
+- led-gpios :  Should specify the LED's GPIO, see "gpios property" in
   Documentation/devicetree/bindings/gpio/gpio.txt.  Active low LEDs should be
   indicated using flags in the GPIO specifier.
 - label :  (optional)
@@ -32,12 +32,12 @@ leds {
 	compatible = "gpio-leds";
 	hdd {
 		label = "IDE Activity";
-		gpios = <&mcu_pio 0 GPIO_ACTIVE_LOW>;
+		led-gpios = <&mcu_pio 0 GPIO_ACTIVE_LOW>;
 		linux,default-trigger = "ide-disk";
 	};
 
 	fault {
-		gpios = <&mcu_pio 1 GPIO_ACTIVE_HIGH>;
+		led-gpios = <&mcu_pio 1 GPIO_ACTIVE_HIGH>;
 		/* Keep LED on if BIOS detected hardware fault */
 		default-state = "keep";
 	};
@@ -46,11 +46,11 @@ leds {
 run-control {
 	compatible = "gpio-leds";
 	red {
-		gpios = <&mpc8572 6 GPIO_ACTIVE_HIGH>;
+		led-gpios = <&mpc8572 6 GPIO_ACTIVE_HIGH>;
 		default-state = "off";
 	};
 	green {
-		gpios = <&mpc8572 7 GPIO_ACTIVE_HIGH>;
+		led-gpios = <&mpc8572 7 GPIO_ACTIVE_HIGH>;
 		default-state = "on";
 	};
 };
@@ -59,7 +59,7 @@ leds {
 	compatible = "gpio-leds";
 
 	charger-led {
-		gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
+		led-gpios = <&gpio1 2 GPIO_ACTIVE_HIGH>;
 		linux,default-trigger = "max8903-charger-charging";
 		retain-state-suspended;
 	};
diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 097d721..eadb472 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -125,15 +125,19 @@ static struct gpio_keys_platform_data *gpio_keys_polled_get_devtree_pdata(struct
 	device_for_each_child_node(dev, child) {
 		struct gpio_desc *desc;
 
-		desc = devm_get_gpiod_from_child(dev, NULL, child);
+		desc = devm_get_gpiod_from_child(dev, "gpio_keys_polled",
+						 child);
 		if (IS_ERR(desc)) {
-			error = PTR_ERR(desc);
-			if (error != -EPROBE_DEFER)
-				dev_err(dev,
-					"Failed to get gpio flags, error: %d\n",
-					error);
-			fwnode_handle_put(child);
-			return ERR_PTR(error);
+			desc = devm_get_gpiod_from_child(dev, NULL, child);
+			if (IS_ERR(desc)) {
+				error = PTR_ERR(desc);
+				if (error != -EPROBE_DEFER)
+					dev_err(dev,
+						"Failed to get gpio flags, error: %d\n",
+						error);
+				fwnode_handle_put(child);
+				return ERR_PTR(error);
+			}
 		}
 
 		button = &pdata->buttons[pdata->nbuttons++];
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 8e5af69..5b7bc84 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -184,7 +184,7 @@ static struct gpio_leds_priv *gpio_leds_create(struct platform_device *pdev)
 		struct gpio_led led = {};
 		const char *state = NULL;
 
-		led.gpiod = devm_get_gpiod_from_child(dev, NULL, child);
+		led.gpiod = devm_get_gpiod_from_child(dev, "led", child);
 		if (IS_ERR(led.gpiod)) {
 			fwnode_handle_put(child);
 			goto err;
-- 
2.1.4

