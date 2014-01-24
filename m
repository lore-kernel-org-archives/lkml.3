Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaAXIoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:44:20 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:49647 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaAXIoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:17 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 06/14] spi: rspi: Merge rspi_send_pio() and rspi_receive_pio()
Date: Fri, 24 Jan 2014 09:43:56 +0100
Message-Id: <1390553044-11860-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

rspi_send_pio() and rspi_receive_pio() are very similar:
  - the former only sends data, using TX Only Mode,
  - the latter sends and receives full duplex data to/from the hardware,
    but uses dummy transmit data.
Merge them into rspi_transfer_out_in(), now supporting full duplex if
needed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |  101 ++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 55 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index d837c5029308..cc90136d02c8 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -389,27 +389,6 @@ static int rspi_data_out_in(struct rspi_data *rspi, u8 data)
 	return rspi_data_in(rspi);
 }
 
-static int rspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
-{
-	int remain = t->len, ret;
-	const u8 *data = t->tx_buf;
-
-	while (remain > 0) {
-		rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) | SPCR_TXMD,
-			    RSPI_SPCR);
-
-		ret = rspi_data_out(rspi, *data++);
-		if (ret < 0)
-			return ret;
-		remain--;
-	}
-
-	/* Waiting for the last transmission */
-	rspi_wait_for_interrupt(rspi, SPSR_SPTEF, SPCR_SPTIE);
-
-	return 0;
-}
-
 static int qspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
 	int remain = t->len, ret;
@@ -563,28 +542,6 @@ static void rspi_receive_init(const struct rspi_data *rspi)
 			    RSPI_SPSR);
 }
 
-static int rspi_receive_pio(struct rspi_data *rspi, struct spi_transfer *t)
-{
-	int remain = t->len, ret;
-	u8 *data = t->rx_buf;
-
-	rspi_receive_init(rspi);
-
-	while (remain > 0) {
-		rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) & ~SPCR_TXMD,
-			    RSPI_SPCR);
-
-		/* dummy write data for generate clock */
-		ret = rspi_data_out_in(rspi, DUMMY_DATA);
-		if (ret < 0)
-			return ret;
-		*data++ = ret;
-		remain--;
-	}
-
-	return 0;
-}
-
 static void qspi_receive_init(const struct rspi_data *rspi)
 {
 	u8 spsr;
@@ -729,27 +686,61 @@ static int rspi_is_dma(const struct rspi_data *rspi, struct spi_transfer *t)
 	return 0;
 }
 
+static int rspi_transfer_out_in(struct rspi_data *rspi,
+				struct spi_transfer *xfer)
+{
+	int remain = xfer->len, ret;
+	const u8 *tx_buf = xfer->tx_buf;
+	u8 *rx_buf = xfer->rx_buf;
+	u8 spcr, data;
+
+	rspi_receive_init(rspi);
+
+	spcr = rspi_read8(rspi, RSPI_SPCR);
+	if (rx_buf)
+		spcr &= ~SPCR_TXMD;
+	else
+		spcr |= SPCR_TXMD;
+	rspi_write8(rspi, spcr, RSPI_SPCR);
+
+	while (remain > 0) {
+		data = tx_buf ? *tx_buf++ : DUMMY_DATA;
+		ret = rspi_data_out(rspi, data);
+		if (ret < 0)
+			return ret;
+		if (rx_buf) {
+			ret = rspi_data_in(rspi);
+			if (ret < 0)
+				return ret;
+			*rx_buf++ = ret;
+		}
+		remain--;
+	}
+
+	/* Wait for the last transmission */
+	rspi_wait_for_interrupt(rspi, SPSR_SPTEF, SPCR_SPTIE);
+
+	return 0;
+}
+
 static int rspi_transfer_one(struct spi_master *master, struct spi_device *spi,
 			     struct spi_transfer *xfer)
 {
 	struct rspi_data *rspi = spi_master_get_devdata(master);
-	int ret = 0;
+	int ret;
+
+	if (!rspi_is_dma(rspi, xfer))
+		return rspi_transfer_out_in(rspi, xfer);
 
 	if (xfer->tx_buf) {
-		if (rspi_is_dma(rspi, xfer))
-			ret = rspi_send_dma(rspi, xfer);
-		else
-			ret = rspi_send_pio(rspi, xfer);
+		ret = rspi_send_dma(rspi, xfer);
 		if (ret < 0)
 			return ret;
 	}
-	if (xfer->rx_buf) {
-		if (rspi_is_dma(rspi, xfer))
-			ret = rspi_receive_dma(rspi, xfer);
-		else
-			ret = rspi_receive_pio(rspi, xfer);
-	}
-	return ret;
+	if (xfer->rx_buf)
+		return rspi_receive_dma(rspi, xfer);
+
+	return 0;
 }
 
 static int qspi_transfer_one(struct spi_master *master, struct spi_device *spi,
-- 
1.7.9.5

