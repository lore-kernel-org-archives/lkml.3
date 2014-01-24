Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaAXIuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:50:15 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:49570 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaAXIoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:15 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 02/14] spi: rspi: Use core message handling
Date: Fri, 24 Jan 2014 09:43:52 +0100
Message-Id: <1390553044-11860-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Let the generic SPI core handle SPI messages, calling into our
rspi_transfer_one() method.

rspi_assert_ssl() and rspi_negate_ssl() are absorbed into
rspi_prepare_message() and rspi_unprepare_message(), as they actually
enable/disable the whole SPI function, instead of just (de)asserting the
chip select line.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |  111 +++++++++++++++---------------------------------
 1 file changed, 34 insertions(+), 77 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index ccd5cf201d04..0e4d169c90d7 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -25,8 +25,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
-#include <linux/list.h>
-#include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
@@ -181,10 +179,7 @@ struct rspi_data {
 	void __iomem *addr;
 	u32 max_speed_hz;
 	struct spi_master *master;
-	struct list_head queue;
-	struct work_struct ws;
 	wait_queue_head_t wait;
-	spinlock_t lock;
 	struct clk *clk;
 	u8 spsr;
 	u16 spcmd;
@@ -345,16 +340,6 @@ static int rspi_wait_for_interrupt(struct rspi_data *rspi, u8 wait_mask,
 	return 0;
 }
 
-static void rspi_assert_ssl(const struct rspi_data *rspi)
-{
-	rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) | SPCR_SPE, RSPI_SPCR);
-}
-
-static void rspi_negate_ssl(const struct rspi_data *rspi)
-{
-	rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) & ~SPCR_SPE, RSPI_SPCR);
-}
-
 static int rspi_send_pio(struct rspi_data *rspi, struct spi_transfer *t)
 {
 	int remain = t->len;
@@ -739,56 +724,27 @@ static int rspi_is_dma(const struct rspi_data *rspi, struct spi_transfer *t)
 	return 0;
 }
 
-static void rspi_work(struct work_struct *work)
+static int rspi_transfer_one(struct spi_master *master, struct spi_device *spi,
+			     struct spi_transfer *xfer)
 {
-	struct rspi_data *rspi = container_of(work, struct rspi_data, ws);
-	struct spi_message *mesg;
-	struct spi_transfer *t;
-	unsigned long flags;
-	int ret;
-
-	while (1) {
-		spin_lock_irqsave(&rspi->lock, flags);
-		if (list_empty(&rspi->queue)) {
-			spin_unlock_irqrestore(&rspi->lock, flags);
-			break;
-		}
-		mesg = list_entry(rspi->queue.next, struct spi_message, queue);
-		list_del_init(&mesg->queue);
-		spin_unlock_irqrestore(&rspi->lock, flags);
-
-		rspi_assert_ssl(rspi);
-
-		list_for_each_entry(t, &mesg->transfers, transfer_list) {
-			if (t->tx_buf) {
-				if (rspi_is_dma(rspi, t))
-					ret = rspi_send_dma(rspi, t);
-				else
-					ret = send_pio(rspi, t);
-				if (ret < 0)
-					goto error;
-			}
-			if (t->rx_buf) {
-				if (rspi_is_dma(rspi, t))
-					ret = rspi_receive_dma(rspi, t);
-				else
-					ret = receive_pio(rspi, t);
-				if (ret < 0)
-					goto error;
-			}
-			mesg->actual_length += t->len;
-		}
-		rspi_negate_ssl(rspi);
+	struct rspi_data *rspi = spi_master_get_devdata(master);
+	int ret = 0;
 
-		mesg->status = 0;
-		mesg->complete(mesg->context);
+	if (xfer->tx_buf) {
+		if (rspi_is_dma(rspi, xfer))
+			ret = rspi_send_dma(rspi, xfer);
+		else
+			ret = send_pio(rspi, xfer);
+		if (ret < 0)
+			return ret;
 	}
-
-	return;
-
-error:
-	mesg->status = ret;
-	mesg->complete(mesg->context);
+	if (xfer->rx_buf) {
+		if (rspi_is_dma(rspi, xfer))
+			ret = rspi_receive_dma(rspi, xfer);
+		else
+			ret = receive_pio(rspi, xfer);
+	}
+	return ret;
 }
 
 static int rspi_setup(struct spi_device *spi)
@@ -808,24 +764,26 @@ static int rspi_setup(struct spi_device *spi)
 	return 0;
 }
 
-static int rspi_transfer(struct spi_device *spi, struct spi_message *mesg)
+static void rspi_cleanup(struct spi_device *spi)
 {
-	struct rspi_data *rspi = spi_master_get_devdata(spi->master);
-	unsigned long flags;
-
-	mesg->actual_length = 0;
-	mesg->status = -EINPROGRESS;
+}
 
-	spin_lock_irqsave(&rspi->lock, flags);
-	list_add_tail(&mesg->queue, &rspi->queue);
-	schedule_work(&rspi->ws);
-	spin_unlock_irqrestore(&rspi->lock, flags);
+static int rspi_prepare_message(struct spi_master *master,
+				struct spi_message *message)
+{
+	struct rspi_data *rspi = spi_master_get_devdata(master);
 
+	rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) | SPCR_SPE, RSPI_SPCR);
 	return 0;
 }
 
-static void rspi_cleanup(struct spi_device *spi)
+static int rspi_unprepare_message(struct spi_master *master,
+				  struct spi_message *message)
 {
+	struct rspi_data *rspi = spi_master_get_devdata(master);
+
+	rspi_write8(rspi, rspi_read8(rspi, RSPI_SPCR) & ~SPCR_SPE, RSPI_SPCR);
+	return 0;
 }
 
 static irqreturn_t rspi_irq(int irq, void *_sr)
@@ -972,9 +930,6 @@ static int rspi_probe(struct platform_device *pdev)
 	}
 	clk_enable(rspi->clk);
 
-	INIT_LIST_HEAD(&rspi->queue);
-	spin_lock_init(&rspi->lock);
-	INIT_WORK(&rspi->ws, rspi_work);
 	init_waitqueue_head(&rspi->wait);
 
 	if (rspi_pd && rspi_pd->num_chipselect)
@@ -984,8 +939,10 @@ static int rspi_probe(struct platform_device *pdev)
 
 	master->bus_num = pdev->id;
 	master->setup = rspi_setup;
-	master->transfer = rspi_transfer;
+	master->transfer_one = rspi_transfer_one;
 	master->cleanup = rspi_cleanup;
+	master->prepare_message = rspi_prepare_message;
+	master->unprepare_message = rspi_unprepare_message;
 	master->mode_bits = SPI_CPHA | SPI_CPOL;
 
 	ret = devm_request_irq(&pdev->dev, irq, rspi_irq, 0,
-- 
1.7.9.5

