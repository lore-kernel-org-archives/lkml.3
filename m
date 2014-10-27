Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaJ0P1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:27:40 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:44479 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaJ0P1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:27:38 -0400
From: Torsten Fleischer <torfl6749@gmail.com>
X-Google-Original-From: Torsten Fleischer
To: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org
Cc: Torsten Fleischer <torfl6749@gmail.com>
Subject: [PATCH 1/1] spi: spi-gpio: Add dt support for a single device with no chip select
Date: Mon, 27 Oct 2014 16:27:17 +0100
Message-Id: <1414423637-2817-1-git-send-email-torfl6749@gmail.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Torsten Fleischer <torfl6749@gmail.com>

Use an empty 'cs-gpios' property if a single device is connected which
has no chip select.
This refers to the discussion at https://lkml.org/lkml/2013/11/13/62.

Signed-off-by: Torsten Fleischer <torfl6749@gmail.com>
---
 Documentation/devicetree/bindings/spi/spi-gpio.txt |  6 ++++--
 drivers/spi/spi-gpio.c                             | 10 +++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-gpio.txt b/Documentation/devicetree/bindings/spi/spi-gpio.txt
index 8a824be..ad8795f 100644
--- a/Documentation/devicetree/bindings/spi/spi-gpio.txt
+++ b/Documentation/devicetree/bindings/spi/spi-gpio.txt
@@ -8,8 +8,10 @@ Required properties:
  - gpio-sck: GPIO spec for the SCK line to use
  - gpio-miso: GPIO spec for the MISO line to use
  - gpio-mosi: GPIO spec for the MOSI line to use
- - cs-gpios: GPIOs to use for chipselect lines
- - num-chipselects: number of chipselect lines
+ - cs-gpios: GPIOs to use for chipselect lines. Leave this property empty if
+             a single device with no chip select is connected.
+ - num-chipselects: Number of chipselect lines. Has to be "1" even if a single
+                    device with no chip select is connected.
 
 Example:
 
diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 9f59553..b343818a 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -461,9 +461,13 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		 * property of the node.
 		 */
 
-		for (i = 0; i < SPI_N_CHIPSEL; i++)
-			spi_gpio->cs_gpios[i] =
-				of_get_named_gpio(np, "cs-gpios", i);
+		if ((SPI_N_CHIPSEL == 1) &&
+				(of_gpio_named_count(np, "cs-gpios") == 0))
+			spi_gpio->cs_gpios[0] = SPI_GPIO_NO_CHIPSELECT;
+		else
+			for (i = 0; i < SPI_N_CHIPSEL; i++)
+				spi_gpio->cs_gpios[i] =
+					of_get_named_gpio(np, "cs-gpios", i);
 	}
 #endif
 
-- 
1.8.4.5

