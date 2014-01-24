Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaAXIth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:49:37 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:37756 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaAXIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:16 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 05/14] spi: rspi: Abstract transfer_one() for RSPI and QSPI
Date: Fri, 24 Jan 2014 09:43:55 +0100
Message-Id: <1390553044-11860-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Split off qspi_transfer_one() (which doesn't support DMA yet) from
rspi_transfer_one().
Replace the abstraction of send_pio()/receive_pio() by the abstracrion of
transfer_one().

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 4b27513e7204..d837c5029308 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -239,8 +239,8 @@ static u16 rspi_read_data(const struct rspi_data *rspi)
 /* optional functions */
 struct spi_ops {
 	int (*set_config_register)(struct rspi_data *rspi, int access_size);
-	int (*send_pio)(struct rspi_data *rspi, struct spi_transfer *t);
-	int (*receive_pio)(struct rspi_data *rspi, struct spi_transfer *t);
+	int (*transfer_one)(struct spi_master *master, struct spi_device *spi,
+			    struct spi_transfer *xfer);
 };
 
 /*
@@ -432,8 +432,6 @@ static int qspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
 	return 0;
 }
 
-#define send_pio(spi, t) spi->ops->send_pio(spi, t)
-
 static void rspi_dma_complete(void *arg)
 {
 	struct rspi_data *rspi = arg;
@@ -617,8 +615,6 @@ static int qspi_receive_pio(struct rspi_data *rspi, struct spi_transfer *t)
 	return 0;
 }
 
-#define receive_pio(spi, t) spi->ops->receive_pio(spi, t)
-
 static int rspi_receive_dma(struct rspi_data *rspi, struct spi_transfer *t)
 {
 	struct scatterlist sg, sg_dummy;
@@ -743,7 +739,7 @@ static int rspi_transfer_one(struct spi_master *master, struct spi_device *spi,
 		if (rspi_is_dma(rspi, xfer))
 			ret = rspi_send_dma(rspi, xfer);
 		else
-			ret = send_pio(rspi, xfer);
+			ret = rspi_send_pio(rspi, xfer);
 		if (ret < 0)
 			return ret;
 	}
@@ -751,8 +747,24 @@ static int rspi_transfer_one(struct spi_master *master, struct spi_device *spi,
 		if (rspi_is_dma(rspi, xfer))
 			ret = rspi_receive_dma(rspi, xfer);
 		else
-			ret = receive_pio(rspi, xfer);
+			ret = rspi_receive_pio(rspi, xfer);
+	}
+	return ret;
+}
+
+static int qspi_transfer_one(struct spi_master *master, struct spi_device *spi,
+			     struct spi_transfer *xfer)
+{
+	struct rspi_data *rspi = spi_master_get_devdata(master);
+	int ret = 0;
+
+	if (xfer->tx_buf) {
+		ret = qspi_send_pio(rspi, xfer);
+		if (ret < 0)
+			return ret;
 	}
+	if (xfer->rx_buf)
+		ret = qspi_receive_pio(rspi, xfer);
 	return ret;
 }
 
@@ -948,7 +960,7 @@ static int rspi_probe(struct platform_device *pdev)
 
 	master->bus_num = pdev->id;
 	master->setup = rspi_setup;
-	master->transfer_one = rspi_transfer_one;
+	master->transfer_one = ops->transfer_one;
 	master->cleanup = rspi_cleanup;
 	master->prepare_message = rspi_prepare_message;
 	master->unprepare_message = rspi_unprepare_message;
@@ -990,14 +1002,12 @@ error1:
 
 static struct spi_ops rspi_ops = {
 	.set_config_register =		rspi_set_config_register,
-	.send_pio =			rspi_send_pio,
-	.receive_pio =			rspi_receive_pio,
+	.transfer_one =			rspi_transfer_one,
 };
 
 static struct spi_ops qspi_ops = {
 	.set_config_register =		qspi_set_config_register,
-	.send_pio =			qspi_send_pio,
-	.receive_pio =			qspi_receive_pio,
+	.transfer_one =			qspi_transfer_one,
 };
 
 static struct platform_device_id spi_driver_ids[] = {
-- 
1.7.9.5

