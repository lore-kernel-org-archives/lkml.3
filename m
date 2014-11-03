Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaKCQSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:18:10 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:58836 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaKCQSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:18:07 -0500
From: Torsten Fleischer <torfl6749@gmail.com>
X-Google-Original-From: Torsten Fleischer
To: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org
Cc: Torsten Fleischer <torfl6749@gmail.com>
Subject: [PATCH v2 1/1] spi: spi-gpio: Add dt support for a single device with no chip select
Date: Mon,  3 Nov 2014 17:17:55 +0100
Message-Id: <1415031475-2268-1-git-send-email-torfl6749@gmail.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Torsten Fleischer <torfl6749@gmail.com>

In order to describe a single slave device that has no chip select line
the 'num-chipselects' property has to be <0> and the 'cs-gpios' property
doesn't need to be set.

Signed-off-by: Torsten Fleischer <torfl6749@gmail.com>
---
 Documentation/devicetree/bindings/spi/spi-gpio.txt |  6 ++++--
 drivers/spi/spi-gpio.c                             | 21 +++++++++++++++------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-gpio.txt b/Documentation/devicetree/bindings/spi/spi-gpio.txt
index 8a824be..a95603b 100644
--- a/Documentation/devicetree/bindings/spi/spi-gpio.txt
+++ b/Documentation/devicetree/bindings/spi/spi-gpio.txt
@@ -8,8 +8,10 @@ Required properties:
  - gpio-sck: GPIO spec for the SCK line to use
  - gpio-miso: GPIO spec for the MISO line to use
  - gpio-mosi: GPIO spec for the MOSI line to use
- - cs-gpios: GPIOs to use for chipselect lines
- - num-chipselects: number of chipselect lines
+ - cs-gpios: GPIOs to use for chipselect lines.
+             Not needed if num-chipselects = <0>.
+ - num-chipselects: Number of chipselect lines. Should be <0> if a single device
+                    with no chip select is connected.
 
 Example:
 
diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 9f59553..f0492c9 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -413,6 +413,7 @@ static int spi_gpio_probe(struct platform_device *pdev)
 	struct spi_gpio_platform_data	*pdata;
 	u16 master_flags = 0;
 	bool use_of = 0;
+	int num_devices;
 
 	status = spi_gpio_probe_dt(pdev);
 	if (status < 0)
@@ -422,16 +423,21 @@ static int spi_gpio_probe(struct platform_device *pdev)
 
 	pdata = dev_get_platdata(&pdev->dev);
 #ifdef GENERIC_BITBANG
-	if (!pdata || !pdata->num_chipselect)
+	if (!pdata || (!use_of && !pdata->num_chipselect))
 		return -ENODEV;
 #endif
 
+	if (use_of && !SPI_N_CHIPSEL)
+		num_devices = 1;
+	else
+		num_devices = SPI_N_CHIPSEL;
+
 	status = spi_gpio_request(pdata, dev_name(&pdev->dev), &master_flags);
 	if (status < 0)
 		return status;
 
 	master = spi_alloc_master(&pdev->dev, sizeof(*spi_gpio) +
-					(sizeof(int) * SPI_N_CHIPSEL));
+					(sizeof(int) * num_devices));
 	if (!master) {
 		status = -ENOMEM;
 		goto gpio_free;
@@ -446,7 +452,7 @@ static int spi_gpio_probe(struct platform_device *pdev)
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(1, 32);
 	master->flags = master_flags;
 	master->bus_num = pdev->id;
-	master->num_chipselect = SPI_N_CHIPSEL;
+	master->num_chipselect = num_devices;
 	master->setup = spi_gpio_setup;
 	master->cleanup = spi_gpio_cleanup;
 #ifdef CONFIG_OF
@@ -461,9 +467,12 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		 * property of the node.
 		 */
 
-		for (i = 0; i < SPI_N_CHIPSEL; i++)
-			spi_gpio->cs_gpios[i] =
-				of_get_named_gpio(np, "cs-gpios", i);
+		if (!SPI_N_CHIPSEL)
+			spi_gpio->cs_gpios[0] = SPI_GPIO_NO_CHIPSELECT;
+		else
+			for (i = 0; i < SPI_N_CHIPSEL; i++)
+				spi_gpio->cs_gpios[i] =
+					of_get_named_gpio(np, "cs-gpios", i);
 	}
 #endif
 
-- 
1.8.4.5

