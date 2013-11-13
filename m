Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3KMIDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:03:11 -0500
Received: from mail-de.keymile.com ([195.8.104.250]:55529 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab3KMIC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:02:58 -0500
From: Gerlando Falauto <gerlando.falauto@keymile.com>
To: linux-kernel@vger.kernel.org
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] spi: spi-gpio: Add check for cs-gpios dt property
Date: Wed, 13 Nov 2013 09:02:28 +0100
Message-Id: <1384329748-2897-1-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bindings assumed that the cs-gpios property is always there.
However, a single SPI device can also work fine without an explicit chip select.
Use the SPI_GPIO_NO_CHIPSELECT mode when the property is not present or invaild.

Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-gpio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 0021fc4..3f21208 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -463,9 +463,16 @@ static int spi_gpio_probe(struct platform_device *pdev)
 		 * property of the node.
 		 */
 
-		for (i = 0; i < SPI_N_CHIPSEL; i++)
+		for (i = 0; i < SPI_N_CHIPSEL; i++) {
 			spi_gpio->cs_gpios[i] =
 				of_get_named_gpio(np, "cs-gpios", i);
+			if ((SPI_N_CHIPSEL == 1)
+			&& !gpio_is_valid(spi_gpio->cs_gpios[i] < 0)) {
+				dev_info(&pdev->dev,
+					"no cs-gpios property, using no-cs mode\n");
+				spi_gpio->cs_gpios[i] = SPI_GPIO_NO_CHIPSELECT;
+			}
+		}
 	}
 #endif
 
-- 
1.8.0.1

