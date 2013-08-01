Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3HAImN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:42:13 -0400
Received: from up.free-electrons.com ([94.23.35.102]:52084 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752922Ab3HAIks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:40:48 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com, Thomas Petazzoni <thomas@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 2/3] video: hx8357: Make IM pins optional
Date: Thu,  1 Aug 2013 10:40:36 +0200
Message-Id: <1375346437-18991-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375346437-18991-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375346437-18991-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IM pins of the HX8357 controller are used to define the interface
used to feed pixel stream to the LCD panel.

Most of the time, these pins are directly routed to either the ground or
the VCC to set their values.

Remove the need to assign GPIOs to these pins when we are in such a case.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/hx8357.c | 52 ++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index a0482b5..47237fa 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -76,6 +76,7 @@ struct hx8357_data {
 	unsigned		reset;
 	struct spi_device	*spi;
 	int			state;
+	bool			use_im_pins;
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
@@ -424,25 +427,32 @@ static int hx8357_probe(struct spi_device *spi)
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
-		}
-
-		ret = devm_gpio_request_one(&spi->dev, lcd->im_pins[i],
-					GPIOF_OUT_INIT_LOW, "im_pins");
-		if (ret) {
-			dev_err(&spi->dev, "failed to request gpio %d: %d\n",
-				lcd->im_pins[i], ret);
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
+	} else {
+		lcd->use_im_pins = 0;
 	}
 
 	lcdev = lcd_device_register("mxsfb", &spi->dev, lcd, &hx8357_ops);
-- 
1.8.3.4

