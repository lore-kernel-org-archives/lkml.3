Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaBTOoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:44:34 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:47307 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaBTOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:43:25 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 10/10] spi: sh-msiof: Use core message handling instead of spi-bitbang
Date: Thu, 20 Feb 2014 15:43:09 +0100
Message-Id: <1392907389-21798-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

The only remaining feature of spi-bitbang used by this driver is the
chipselect() callback, which just does conditional GPIO.
This is handled fine by the SPI core's spi_set_cs(), hence switch the
driver to use the core message handling through our own transfer_one()
method.

Remove the call to spi_master_put() in sh_msiof_spi_remove(), as our SPI
master is now registered using devm_spi_register_master()
(spi_bitbang_start() uses the non-managed version).

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/Kconfig        |    1 -
 drivers/spi/spi-sh-msiof.c |   65 ++++++++++++--------------------------------
 2 files changed, 17 insertions(+), 49 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 339da4b15ec2..35d5c029393a 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -416,7 +416,6 @@ config SPI_SH_MSIOF
 	tristate "SuperH MSIOF SPI controller"
 	depends on HAVE_CLK
 	depends on SUPERH || ARCH_SHMOBILE || COMPILE_TEST
-	select SPI_BITBANG
 	help
 	  SPI driver for SuperH and SH Mobile MSIOF blocks.
 
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index bd300fcb7116..642b0b637df1 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -26,7 +26,6 @@
 
 #include <linux/spi/sh_msiof.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/spi_bitbang.h>
 
 #include <asm/unaligned.h>
 
@@ -36,7 +35,6 @@ struct sh_msiof_chipdata {
 };
 
 struct sh_msiof_spi_priv {
-	struct spi_bitbang bitbang; /* must be first for spi_bitbang.c */
 	void __iomem *mapbase;
 	struct clk *clk;
 	struct platform_device *pdev;
@@ -452,8 +450,7 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 		 */
 		spi->cs_gpio = (uintptr_t)spi->controller_data;
 	}
-
-	return spi_bitbang_setup(spi);
+	return 0;
 }
 
 static int sh_msiof_prepare_message(struct spi_master *master,
@@ -488,20 +485,6 @@ static int sh_msiof_unprepare_message(struct spi_master *master,
 	return 0;
 }
 
-static void sh_msiof_spi_chipselect(struct spi_device *spi, int is_on)
-{
-	int value;
-
-	/* chip select is active low unless SPI_CS_HIGH is set */
-	if (spi->mode & SPI_CS_HIGH)
-		value = (is_on == BITBANG_CS_ACTIVE) ? 1 : 0;
-	else
-		value = (is_on == BITBANG_CS_ACTIVE) ? 0 : 1;
-
-	if (spi->cs_gpio >= 0)
-		gpio_set_value(spi->cs_gpio, value);
-}
-
 static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 				  void (*tx_fifo)(struct sh_msiof_spi_priv *,
 						  const void *, int, int),
@@ -571,9 +554,11 @@ static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
 	return ret;
 }
 
-static int sh_msiof_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
+static int sh_msiof_transfer_one(struct spi_master *master,
+				 struct spi_device *spi,
+				 struct spi_transfer *t)
 {
-	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
+	struct sh_msiof_spi_priv *p = spi_master_get_devdata(master);
 	void (*tx_fifo)(struct sh_msiof_spi_priv *, const void *, int, int);
 	void (*rx_fifo)(struct sh_msiof_spi_priv *, void *, int, int);
 	int bits;
@@ -654,13 +639,6 @@ static int sh_msiof_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
 		words -= n;
 	}
 
-	return bytes_done;
-}
-
-static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
-				  u32 word, u8 bits)
-{
-	BUG(); /* unused but needed by bitbang code */
 	return 0;
 }
 
@@ -795,7 +773,7 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 	if (p->info->rx_fifo_override)
 		p->rx_fifo_size = p->info->rx_fifo_override;
 
-	/* init master and bitbang code */
+	/* init master code */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 	master->mode_bits |= SPI_LSB_FIRST | SPI_3WIRE;
 	master->flags = p->chipdata->master_flags;
@@ -803,24 +781,20 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 	master->dev.of_node = pdev->dev.of_node;
 	master->num_chipselect = p->info->num_chipselect;
 	master->setup = sh_msiof_spi_setup;
-	master->cleanup = spi_bitbang_cleanup;
 	master->prepare_message = sh_msiof_prepare_message;
 	master->unprepare_message = sh_msiof_unprepare_message;
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(8, 32);
+	master->transfer_one = sh_msiof_transfer_one;
 
-	p->bitbang.master = master;
-	p->bitbang.chipselect = sh_msiof_spi_chipselect;
-	p->bitbang.setup_transfer = spi_bitbang_setup_transfer;
-	p->bitbang.txrx_bufs = sh_msiof_spi_txrx;
-	p->bitbang.txrx_word[SPI_MODE_0] = sh_msiof_spi_txrx_word;
-	p->bitbang.txrx_word[SPI_MODE_1] = sh_msiof_spi_txrx_word;
-	p->bitbang.txrx_word[SPI_MODE_2] = sh_msiof_spi_txrx_word;
-	p->bitbang.txrx_word[SPI_MODE_3] = sh_msiof_spi_txrx_word;
+	ret = devm_spi_register_master(&pdev->dev, master);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "spi_register_master error.\n");
+		goto err2;
+	}
 
-	ret = spi_bitbang_start(&p->bitbang);
-	if (ret == 0)
-		return 0;
+	return 0;
 
+ err2:
 	pm_runtime_disable(&pdev->dev);
 	clk_unprepare(p->clk);
  err1:
@@ -831,15 +805,10 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 static int sh_msiof_spi_remove(struct platform_device *pdev)
 {
 	struct sh_msiof_spi_priv *p = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = spi_bitbang_stop(&p->bitbang);
-	if (!ret) {
-		pm_runtime_disable(&pdev->dev);
-		clk_unprepare(p->clk);
-		spi_master_put(p->bitbang.master);
-	}
-	return ret;
+	pm_runtime_disable(&pdev->dev);
+	clk_unprepare(p->clk);
+	return 0;
 }
 
 static struct platform_device_id spi_driver_ids[] = {
-- 
1.7.9.5

