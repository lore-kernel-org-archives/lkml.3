Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaAXIqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:46:43 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:56734 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaAXIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:19 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 07/14] spi: rspi: Merge qspi_send_pio() and qspi_receive_pio()
Date: Fri, 24 Jan 2014 09:43:57 +0100
Message-Id: <1390553044-11860-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

qspi_send_pio() and qspi_receive_pio() are very similar: they both send
and receive full duplex data to/from the hardware, but ignore the data
stream in the unused direction.
Merge them into qspi_transfer_out_in(), now supporting real full duplex.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |   79 +++++++++++++++++-------------------------------
 1 file changed, 28 insertions(+), 51 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index cc90136d02c8..5d39cd3eba62 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -389,28 +389,6 @@ static int rspi_data_out_in(struct rspi_data *rspi, u8 data)
 	return rspi_data_in(rspi);
 }
 
-static int qspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
-{
-	int remain = t->len, ret;
-	const u8 *data = t->tx_buf;
-
-	rspi_write8(rspi, SPBFCR_TXRST, QSPI_SPBFCR);
-	rspi_write8(rspi, 0x00, QSPI_SPBFCR);
-
-	while (remain > 0) {
-		/* dummy read */
-		ret = rspi_data_out_in(rspi, *data++);
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
 static void rspi_dma_complete(void *arg)
 {
 	struct rspi_data *rspi = arg;
@@ -550,26 +528,7 @@ static void qspi_receive_init(const struct rspi_data *rspi)
 	if (spsr & SPSR_SPRF)
 		rspi_read_data(rspi);   /* dummy read */
 	rspi_write8(rspi, SPBFCR_TXRST | SPBFCR_RXRST, QSPI_SPBFCR);
-	rspi_write8(rspi, 0x00, QSPI_SPBFCR);
-}
-
-static int qspi_receive_pio(struct rspi_data *rspi, struct spi_transfer *t)
-{
-	int remain = t->len, ret;
-	u8 *data = t->rx_buf;
-
-	qspi_receive_init(rspi);
-
-	while (remain > 0) {
-		/* dummy write for generate clock */
-		ret = rspi_data_out_in(rspi, DUMMY_DATA);
-		if (ret < 0)
-			return ret;
-		*data++ = ret;
-		remain--;
-	}
-
-	return 0;
+	rspi_write8(rspi, 0, QSPI_SPBFCR);
 }
 
 static int rspi_receive_dma(struct rspi_data *rspi, struct spi_transfer *t)
@@ -743,20 +702,38 @@ static int rspi_transfer_one(struct spi_master *master, struct spi_device *spi,
 	return 0;
 }
 
-static int qspi_transfer_one(struct spi_master *master, struct spi_device *spi,
-			     struct spi_transfer *xfer)
+static int qspi_transfer_out_in(struct rspi_data *rspi,
+				struct spi_transfer *xfer)
 {
-	struct rspi_data *rspi = spi_master_get_devdata(master);
-	int ret = 0;
+	int remain = xfer->len, ret;
+	const u8 *tx_buf = xfer->tx_buf;
+	u8 *rx_buf = xfer->rx_buf;
+	u8 data;
 
-	if (xfer->tx_buf) {
-		ret = qspi_send_pio(rspi, xfer);
+	qspi_receive_init(rspi);
+
+	while (remain > 0) {
+		data = tx_buf ? *tx_buf++ : DUMMY_DATA;
+		ret = rspi_data_out_in(rspi, data);
 		if (ret < 0)
 			return ret;
+		if (rx_buf)
+			*rx_buf++ = ret;
+		remain--;
 	}
-	if (xfer->rx_buf)
-		ret = qspi_receive_pio(rspi, xfer);
-	return ret;
+
+	/* Wait for the last transmission */
+	rspi_wait_for_interrupt(rspi, SPSR_SPTEF, SPCR_SPTIE);
+
+	return 0;
+}
+
+static int qspi_transfer_one(struct spi_master *master, struct spi_device *spi,
+			     struct spi_transfer *xfer)
+{
+	struct rspi_data *rspi = spi_master_get_devdata(master);
+
+	return qspi_transfer_out_in(rspi, xfer);
 }
 
 static int rspi_setup(struct spi_device *spi)
-- 
1.7.9.5

