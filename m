Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaAXIro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:47:44 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:49663 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaAXIoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:18 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v3 10/14] spi: rspi: Add support for loopback mode
Date: Fri, 24 Jan 2014 09:44:00 +0100
Message-Id: <1390553044-11860-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Add support for specifying loopback mode.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v3:
  - This became a lot simpler after merging the send_pio() and
    receive_pio() methods

 drivers/spi/spi-rspi.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 0c7556978d2e..28db8770aaf3 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -183,8 +183,9 @@ struct rspi_data {
 	struct spi_master *master;
 	wait_queue_head_t wait;
 	struct clk *clk;
-	u8 spsr;
 	u16 spcmd;
+	u8 spsr;
+	u8 sppcr;
 	int rx_irq, tx_irq;
 	const struct spi_ops *ops;
 
@@ -252,8 +253,8 @@ static int rspi_set_config_register(struct rspi_data *rspi, int access_size)
 {
 	int spbr;
 
-	/* Sets output mode(CMOS) and MOSI signal(from previous transfer) */
-	rspi_write8(rspi, 0x00, RSPI_SPPCR);
+	/* Sets output mode, MOSI signal, and (optionally) loopback */
+	rspi_write8(rspi, rspi->sppcr, RSPI_SPPCR);
 
 	/* Sets transfer bit rate */
 	spbr = clk_get_rate(rspi->clk) / (2 * rspi->max_speed_hz) - 1;
@@ -288,8 +289,8 @@ static int rspi_rz_set_config_register(struct rspi_data *rspi, int access_size)
 {
 	int spbr;
 
-	/* Sets output mode */
-	rspi_write8(rspi, 0x00, RSPI_SPPCR);
+	/* Sets output mode, MOSI signal, and (optionally) loopback */
+	rspi_write8(rspi, rspi->sppcr, RSPI_SPPCR);
 
 	/* Sets transfer bit rate */
 	spbr = clk_get_rate(rspi->clk) / (2 * rspi->max_speed_hz) - 1;
@@ -322,8 +323,8 @@ static int qspi_set_config_register(struct rspi_data *rspi, int access_size)
 	u16 spcmd;
 	int spbr;
 
-	/* Sets output mode(CMOS) and MOSI signal(from previous transfer) */
-	rspi_write8(rspi, 0x00, RSPI_SPPCR);
+	/* Sets output mode, MOSI signal, and (optionally) loopback */
+	rspi_write8(rspi, rspi->sppcr, RSPI_SPPCR);
 
 	/* Sets transfer bit rate */
 	spbr = clk_get_rate(rspi->clk) / (2 * rspi->max_speed_hz);
@@ -829,6 +830,11 @@ static int rspi_setup(struct spi_device *spi)
 	if (spi->mode & SPI_CPHA)
 		rspi->spcmd |= SPCMD_CPHA;
 
+	/* CMOS output mode and MOSI signal from previous transfer */
+	rspi->sppcr = 0;
+	if (spi->mode & SPI_LOOP)
+		rspi->sppcr |= SPPCR_SPLP;
+
 	set_config_register(rspi, 8);
 
 	return 0;
@@ -1050,7 +1056,7 @@ static int rspi_probe(struct platform_device *pdev)
 	master->cleanup = rspi_cleanup;
 	master->prepare_message = rspi_prepare_message;
 	master->unprepare_message = rspi_unprepare_message;
-	master->mode_bits = SPI_CPHA | SPI_CPOL;
+	master->mode_bits = SPI_CPHA | SPI_CPOL | SPI_LOOP;
 
 	ret = platform_get_irq_byname(pdev, "rx");
 	if (ret < 0) {
-- 
1.7.9.5

