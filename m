Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab3FXORV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:17:21 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:36646 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3FXORS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:17:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-fbdev@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCHv2 1/2] video: hx8357: Make IM pins optional
Date: Mon, 24 Jun 2013 16:16:54 +0200
Message-Id: <1372083415-9734-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372083415-9734-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372083415-9734-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

The IM pins of the HX8357 controller are used to define the interface used to
feed pixel stream to the LCD panel.

Most of the time, these pins are directly routed to either the ground or the VCC
to set their values.

Remove the need to assign GPIOs to these pins when we are in such a case.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/video/backlight/hx8357.c | 53 +++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index a0482b5..69f5672 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -76,6 +76,7 @@ struct hx8357_data {
 	unsigned		reset;
 	struct spi_device	*spi;
 	int			state;
+	u8			use_im_pins;
 };
 
 static u8 hx8357_seq_power[] = {
@@ -250,9 +251,11 @@ static int hx8357_lcd_init(struct lcd_device *lcdev)
 	 * Set the interface selection pins to SPI mode, with three
 	 * wires
 	 */
-	gpio_set_value_cansleep(lcd->im_pins[0], 1);
-	gpio_set_value_cansleep(lcd->im_pins[1], 0);
-	gpio_set_value_cansleep(lcd->im_pins[2], 1);
+	if (lcd->use_im_pins) {
+		gpio_set_value_cansleep(lcd->im_pins[0], 1);
+		gpio_set_value_cansleep(lcd->im_pins[1], 0);
+		gpio_set_value_cansleep(lcd->im_pins[2], 1);
+	}
 
 	/* Reset the screen */
 	gpio_set_value(lcd->reset, 1);
@@ -424,26 +427,32 @@ static int hx8357_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < HX8357_NUM_IM_PINS; i++) {
-		lcd->im_pins[i] = of_get_named_gpio(spi->dev.of_node,
-						"im-gpios", i);
-		if (lcd->im_pins[i] == -EPROBE_DEFER) {
-			dev_info(&spi->dev, "GPIO requested is not here yet, deferring the probe\n");
-			return -EPROBE_DEFER;
-		}
-		if (!gpio_is_valid(lcd->im_pins[i])) {
-			dev_err(&spi->dev, "Missing dt property: im-gpios\n");
-			return -EINVAL;
+	if (of_find_property(spi->dev.of_node, "im-gpios", NULL)) {
+		lcd->use_im_pins = 1;
+
+		for (i = 0; i < HX8357_NUM_IM_PINS; i++) {
+			lcd->im_pins[i] = of_get_named_gpio(spi->dev.of_node,
+							    "im-gpios", i);
+			if (lcd->im_pins[i] == -EPROBE_DEFER) {
+				dev_info(&spi->dev, "GPIO requested is not here yet, deferring the probe\n");
+				return -EPROBE_DEFER;
+			}
+			if (!gpio_is_valid(lcd->im_pins[i])) {
+				dev_err(&spi->dev, "Missing dt property: im-gpios\n");
+				return -EINVAL;
+			}
+
+			ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
+						    GPIOF_OUT_INIT_LOW,
+						    "im_pins");
+			if (ret) {
+				dev_err(&spi->dev, "failed to request gpio %d: %d\n",
+					lcd->im_pins[i], ret);
+				return -EINVAL;
+			}
 		}
-
-		ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
-					GPIOF_OUT_INIT_LOW, "im_pins");
-		if (ret) {
-			dev_err(&spi->dev, "failed to request gpio %d: %d\n",
-				lcd->im_pins[i], ret);
-			return -EINVAL;
-		}
-	}
+	} else
+		lcd->use_im_pins = 0;
 
 	lcdev = lcd_device_register("mxsfb", &spi->dev, lcd, &hx8357_ops);
 	if (IS_ERR(lcdev)) {
-- 
1.8.1.2

