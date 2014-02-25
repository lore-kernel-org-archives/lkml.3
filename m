Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaBYKYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:24:06 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:41274 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaBYKVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:21:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 4/6] spi: sh-msiof: Move clock management to (un)prepare_message()
Date: Tue, 25 Feb 2014 11:21:11 +0100
Message-Id: <1393323673-2751-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
References: <1393323673-2751-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Move clock management and pin configuration from the bitbang chipselect()
method to the SPI core prepare_message() and unprepare_message() methods.

As spi_master.{,un}prepare_message() is guaranteed to be called in
matching pairs, the clock management synchronization is no longer needed.

As sh_msiof_spi_set_pin_regs() is no longer called at spi_master.setup()
time (through spi_bitbang_setup() and the spi_bitbang.chipselect()
callback), we now have to take care of that ourselves.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - Removed clock management synchronization,
  - Configure pins in the .setup() routine.

 drivers/spi/spi-sh-msiof.c |   61 +++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 3baef2bacaed..18e3a8d628e9 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -45,7 +45,6 @@ struct sh_msiof_spi_priv {
 	const struct sh_msiof_chipdata *chipdata;
 	struct sh_msiof_spi_info *info;
 	struct completion done;
-	unsigned long flags;
 	int tx_fifo_size;
 	int rx_fifo_size;
 };
@@ -458,6 +457,7 @@ static int sh_msiof_spi_setup_transfer(struct spi_device *spi,
 static int sh_msiof_spi_setup(struct spi_device *spi)
 {
 	struct device_node	*np = spi->master->dev.of_node;
+	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
 
 	if (!np) {
 		/*
@@ -467,12 +467,46 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 		spi->cs_gpio = (uintptr_t)spi->controller_data;
 	}
 
+	/* Configure pins before deasserting CS */
+	sh_msiof_spi_set_pin_regs(p, !!(spi->mode & SPI_CPOL),
+				  !!(spi->mode & SPI_CPHA),
+				  !!(spi->mode & SPI_3WIRE),
+				  !!(spi->mode & SPI_LSB_FIRST),
+				  !!(spi->mode & SPI_CS_HIGH));
+
 	return spi_bitbang_setup(spi);
 }
 
+static int sh_msiof_prepare_message(struct spi_master *master,
+				    struct spi_message *msg)
+{
+	struct sh_msiof_spi_priv *p = spi_master_get_devdata(master);
+	const struct spi_device *spi = msg->spi;
+
+	pm_runtime_get_sync(&p->pdev->dev);
+	clk_enable(p->clk);
+
+	/* Configure pins before asserting CS */
+	sh_msiof_spi_set_pin_regs(p, !!(spi->mode & SPI_CPOL),
+				  !!(spi->mode & SPI_CPHA),
+				  !!(spi->mode & SPI_3WIRE),
+				  !!(spi->mode & SPI_LSB_FIRST),
+				  !!(spi->mode & SPI_CS_HIGH));
+	return 0;
+}
+
+static int sh_msiof_unprepare_message(struct spi_master *master,
+				      struct spi_message *msg)
+{
+	struct sh_msiof_spi_priv *p = spi_master_get_devdata(master);
+
+	clk_disable(p->clk);
+	pm_runtime_put(&p->pdev->dev);
+	return 0;
+}
+
 static void sh_msiof_spi_chipselect(struct spi_device *spi, int is_on)
 {
-	struct sh_msiof_spi_priv *p = spi_master_get_devdata(spi->master);
 	int value;
 
 	/* chip select is active low unless SPI_CS_HIGH is set */
@@ -481,29 +515,8 @@ static void sh_msiof_spi_chipselect(struct spi_device *spi, int is_on)
 	else
 		value = (is_on == BITBANG_CS_ACTIVE) ? 0 : 1;
 
-	if (is_on == BITBANG_CS_ACTIVE) {
-		if (!test_and_set_bit(0, &p->flags)) {
-			pm_runtime_get_sync(&p->pdev->dev);
-			clk_enable(p->clk);
-		}
-
-		/* Configure pins before asserting CS */
-		sh_msiof_spi_set_pin_regs(p, !!(spi->mode & SPI_CPOL),
-					  !!(spi->mode & SPI_CPHA),
-					  !!(spi->mode & SPI_3WIRE),
-					  !!(spi->mode & SPI_LSB_FIRST),
-					  !!(spi->mode & SPI_CS_HIGH));
-	}
-
 	if (spi->cs_gpio >= 0)
 		gpio_set_value(spi->cs_gpio, value);
-
-	if (is_on == BITBANG_CS_INACTIVE) {
-		if (test_and_clear_bit(0, &p->flags)) {
-			clk_disable(p->clk);
-			pm_runtime_put(&p->pdev->dev);
-		}
-	}
 }
 
 static int sh_msiof_spi_txrx_once(struct sh_msiof_spi_priv *p,
@@ -810,6 +823,8 @@ static int sh_msiof_spi_probe(struct platform_device *pdev)
 	master->num_chipselect = p->info->num_chipselect;
 	master->setup = sh_msiof_spi_setup;
 	master->cleanup = spi_bitbang_cleanup;
+	master->prepare_message = sh_msiof_prepare_message;
+	master->unprepare_message = sh_msiof_unprepare_message;
 
 	p->bitbang.master = master;
 	p->bitbang.chipselect = sh_msiof_spi_chipselect;
-- 
1.7.9.5

