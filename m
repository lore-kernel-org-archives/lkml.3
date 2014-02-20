Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaBTOql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:46:41 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:46189 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaBTOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:43:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 05/10] spi: sh-msiof: Use the core cs_gpio field, and make it optional
Date: Thu, 20 Feb 2014 15:43:04 +0100
Message-Id: <1392907389-21798-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

In current implementation, CS is controlled by GPIO, which is passed
through spi->controller_data.  However, the MSIOF HW module has a function
to output CS by itself, which is already enabled and actual switch will be
done by pinmux.

Store the GPIO number in the core cs_gpio field, and ignore it if it is
an invalid (negative) GPIO number.

Loosely based on a patch from Takashi Yoshii <takasi-y@ops.dti.ne.jp>.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
---
 drivers/spi/spi-sh-msiof.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 79e14586049b..92515c1ececa 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -445,6 +445,21 @@ static int sh_msiof_spi_setup_transfer(struct spi_device *spi,
 	return spi_bitbang_setup_transfer(spi, t);
 }
 
+static int sh_msiof_spi_setup(struct spi_device *spi)
+{
+	struct device_node	*np = spi->master->dev.of_node;
+
+	if (!np) {
+		/*
+		 * Use spi->controller_data for CS (same strategy as spi_gpio),
+		 * if any. otherwise let HW control CS
+		 */
+		spi->cs_gpio = (uintptr_t)spi->controller_data;
+	}
+
+	return spi_bitbang_setup(spi);
+}
+
 static void sh_msiof_spi_chipselect(struct spi_device *spi, int is_on)
 {
 	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
@@ -470,8 +485,8 @@ static void sh_msiof_spi_chipselect(struct spi_device *spi, int is_on)
 					  !!(spi->mode & SPI_CS_HIGH));
 	}
 
-	/* use spi->controller data for CS (same strategy as spi_gpio) */
-	gpio_set_value((uintptr_t)spi->controller_data, value);
+	if (spi->cs_gpio >= 0)
+		gpio_set_value(spi->cs_gpio, value);
 
 	if (is_on == BITBANG_CS_INACTIVE) {
 		if (test_and_clear_bit(0, &p->flags)) {
@@ -758,7 +773,7 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->dev.of_node = pdev->dev.of_node;
 	master->num_chipselect = p->info->num_chipselect;
-	master->setup = spi_bitbang_setup;
+	master->setup = sh_msiof_spi_setup;
 	master->cleanup = spi_bitbang_cleanup;
 
 	p->bitbang.master = master;
-- 
1.7.9.5

