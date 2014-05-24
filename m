Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaEXA5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:57:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54079 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEXA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:57:38 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] spi: Set cs-gpios to output direction
Date: Fri, 23 May 2014 17:57:34 -0700
Message-Id: <1400893054-16126-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some gpios used for cs-gpios may not be configured for output by
default. In these cases gpio_set_value() won't have any effect
and so the chip select line won't toggle. Request the cs-gpios
and set them to output direction once we know if the chip select
is default high or default low.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I wonder if we should request the gpios when the master controller
probes or when a spi device is added? We only know what the default
value should be when the spi device is added. On the other hand,
we should probably fail probe if the gpio controller isn't ready when
the spi master controller probes.

Also, is it better to convert this over to the gpiod interfaces?

 drivers/spi/spi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 074f55f5d5ec..00f6365b3f87 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -431,8 +431,10 @@ int spi_add_device(struct spi_device *spi)
 		goto done;
 	}
 
-	if (master->cs_gpios)
+	if (master->cs_gpios) {
 		spi->cs_gpio = master->cs_gpios[spi->chip_select];
+		gpio_direction_output(spi->cs_gpio, !(spi->mode & SPI_CS_HIGH));
+	}
 
 	/* Drivers may modify this initial i/o setup, but will
 	 * normally rely on the device being setup.  Devices
@@ -1512,8 +1514,11 @@ static int of_spi_register_master(struct spi_master *master)
 	for (i = 0; i < master->num_chipselect; i++)
 		cs[i] = -ENOENT;
 
-	for (i = 0; i < nb; i++)
+	for (i = 0; i < nb; i++) {
 		cs[i] = of_get_named_gpio(np, "cs-gpios", i);
+		devm_gpio_request(&master->dev, cs[i], "spi-cs");
+	}
+
 
 	return 0;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

