Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbbAJIe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 03:34:28 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:37609 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbAJIdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 03:33:51 -0500
From: Stefan Agner <stefan@agner.ch>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 1/2] serial: fsl_lpuart: move DMA channel request to probe
Date: Sat, 10 Jan 2015 09:33:45 +0100
Message-Id: <1420878826-10214-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420878826-10214-1-git-send-email-stefan@agner.ch>
References: <1420878826-10214-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the DMA channel request to probe to avoid requesting the DMA
channel on each opening of the ttyLPx device. This also fixes a
potential issue that TX channel is not freed when only RX channel
allocation fails. The DMA channels are now handled independently,
so one could use UART with DMA only in TX direction for instance.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/tty/serial/fsl_lpuart.c | 96 +++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 52 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index e95c497..0ea0af7 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -237,7 +237,8 @@ struct lpuart_port {
 	unsigned int		rxfifo_size;
 	bool			lpuart32;
 
-	bool			lpuart_dma_use;
+	bool			lpuart_dma_tx_use;
+	bool			lpuart_dma_rx_use;
 	struct dma_chan		*dma_tx_chan;
 	struct dma_chan		*dma_rx_chan;
 	struct dma_async_tx_descriptor  *dma_tx_desc;
@@ -568,7 +569,7 @@ static void lpuart_start_tx(struct uart_port *port)
 	temp = readb(port->membase + UARTCR2);
 	writeb(temp | UARTCR2_TIE, port->membase + UARTCR2);
 
-	if (sport->lpuart_dma_use) {
+	if (sport->lpuart_dma_tx_use) {
 		if (!uart_circ_empty(xmit) && !sport->dma_tx_in_progress)
 			lpuart_prepare_tx(sport);
 	} else {
@@ -761,13 +762,13 @@ static irqreturn_t lpuart_int(int irq, void *dev_id)
 	crdma = readb(sport->port.membase + UARTCR5);
 
 	if (sts & UARTSR1_RDRF && !(crdma & UARTCR5_RDMAS)) {
-		if (sport->lpuart_dma_use)
+		if (sport->lpuart_dma_rx_use)
 			lpuart_prepare_rx(sport);
 		else
 			lpuart_rxint(irq, dev_id);
 	}
 	if (sts & UARTSR1_TDRE && !(crdma & UARTCR5_TDMAS)) {
-		if (sport->lpuart_dma_use)
+		if (sport->lpuart_dma_tx_use)
 			lpuart_pio_tx(sport);
 		else
 			lpuart_txint(irq, dev_id);
@@ -950,26 +951,17 @@ static int lpuart_dma_tx_request(struct uart_port *port)
 {
 	struct lpuart_port *sport = container_of(port,
 					struct lpuart_port, port);
-	struct dma_chan *tx_chan;
 	struct dma_slave_config dma_tx_sconfig;
 	dma_addr_t dma_bus;
 	unsigned char *dma_buf;
 	int ret;
 
-	tx_chan  = dma_request_slave_channel(sport->port.dev, "tx");
-
-	if (!tx_chan) {
-		dev_err(sport->port.dev, "Dma tx channel request failed!\n");
-		return -ENODEV;
-	}
-
-	dma_bus = dma_map_single(tx_chan->device->dev,
+	dma_bus = dma_map_single(sport->dma_tx_chan->device->dev,
 				sport->port.state->xmit.buf,
 				UART_XMIT_SIZE, DMA_TO_DEVICE);
 
-	if (dma_mapping_error(tx_chan->device->dev, dma_bus)) {
+	if (dma_mapping_error(sport->dma_tx_chan->device->dev, dma_bus)) {
 		dev_err(sport->port.dev, "dma_map_single tx failed\n");
-		dma_release_channel(tx_chan);
 		return -ENOMEM;
 	}
 
@@ -978,16 +970,14 @@ static int lpuart_dma_tx_request(struct uart_port *port)
 	dma_tx_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
 	dma_tx_sconfig.dst_maxburst = sport->txfifo_size;
 	dma_tx_sconfig.direction = DMA_MEM_TO_DEV;
-	ret = dmaengine_slave_config(tx_chan, &dma_tx_sconfig);
+	ret = dmaengine_slave_config(sport->dma_tx_chan, &dma_tx_sconfig);
 
 	if (ret < 0) {
 		dev_err(sport->port.dev,
 				"Dma slave config failed, err = %d\n", ret);
-		dma_release_channel(tx_chan);
 		return ret;
 	}
 
-	sport->dma_tx_chan = tx_chan;
 	sport->dma_tx_buf_virt = dma_buf;
 	sport->dma_tx_buf_bus = dma_bus;
 	sport->dma_tx_in_progress = 0;
@@ -999,34 +989,24 @@ static int lpuart_dma_rx_request(struct uart_port *port)
 {
 	struct lpuart_port *sport = container_of(port,
 					struct lpuart_port, port);
-	struct dma_chan *rx_chan;
 	struct dma_slave_config dma_rx_sconfig;
 	dma_addr_t dma_bus;
 	unsigned char *dma_buf;
 	int ret;
 
-	rx_chan  = dma_request_slave_channel(sport->port.dev, "rx");
-
-	if (!rx_chan) {
-		dev_err(sport->port.dev, "Dma rx channel request failed!\n");
-		return -ENODEV;
-	}
-
 	dma_buf = devm_kzalloc(sport->port.dev,
 				FSL_UART_RX_DMA_BUFFER_SIZE, GFP_KERNEL);
 
 	if (!dma_buf) {
 		dev_err(sport->port.dev, "Dma rx alloc failed\n");
-		dma_release_channel(rx_chan);
 		return -ENOMEM;
 	}
 
-	dma_bus = dma_map_single(rx_chan->device->dev, dma_buf,
+	dma_bus = dma_map_single(sport->dma_rx_chan->device->dev, dma_buf,
 				FSL_UART_RX_DMA_BUFFER_SIZE, DMA_FROM_DEVICE);
 
-	if (dma_mapping_error(rx_chan->device->dev, dma_bus)) {
+	if (dma_mapping_error(sport->dma_rx_chan->device->dev, dma_bus)) {
 		dev_err(sport->port.dev, "dma_map_single rx failed\n");
-		dma_release_channel(rx_chan);
 		return -ENOMEM;
 	}
 
@@ -1034,16 +1014,14 @@ static int lpuart_dma_rx_request(struct uart_port *port)
 	dma_rx_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
 	dma_rx_sconfig.src_maxburst = 1;
 	dma_rx_sconfig.direction = DMA_DEV_TO_MEM;
-	ret = dmaengine_slave_config(rx_chan, &dma_rx_sconfig);
+	ret = dmaengine_slave_config(sport->dma_rx_chan, &dma_rx_sconfig);
 
 	if (ret < 0) {
 		dev_err(sport->port.dev,
 				"Dma slave config failed, err = %d\n", ret);
-		dma_release_channel(rx_chan);
 		return ret;
 	}
 
-	sport->dma_rx_chan = rx_chan;
 	sport->dma_rx_buf_virt = dma_buf;
 	sport->dma_rx_buf_bus = dma_bus;
 	sport->dma_rx_in_progress = 0;
@@ -1055,31 +1033,24 @@ static void lpuart_dma_tx_free(struct uart_port *port)
 {
 	struct lpuart_port *sport = container_of(port,
 					struct lpuart_port, port);
-	struct dma_chan *dma_chan;
 
 	dma_unmap_single(sport->port.dev, sport->dma_tx_buf_bus,
 			UART_XMIT_SIZE, DMA_TO_DEVICE);
-	dma_chan = sport->dma_tx_chan;
-	sport->dma_tx_chan = NULL;
+
 	sport->dma_tx_buf_bus = 0;
 	sport->dma_tx_buf_virt = NULL;
-	dma_release_channel(dma_chan);
 }
 
 static void lpuart_dma_rx_free(struct uart_port *port)
 {
 	struct lpuart_port *sport = container_of(port,
 					struct lpuart_port, port);
-	struct dma_chan *dma_chan;
 
 	dma_unmap_single(sport->port.dev, sport->dma_rx_buf_bus,
 			FSL_UART_RX_DMA_BUFFER_SIZE, DMA_FROM_DEVICE);
 
-	dma_chan = sport->dma_rx_chan;
-	sport->dma_rx_chan = NULL;
 	sport->dma_rx_buf_bus = 0;
 	sport->dma_rx_buf_virt = NULL;
-	dma_release_channel(dma_chan);
 }
 
 static int lpuart_startup(struct uart_port *port)
@@ -1098,17 +1069,21 @@ static int lpuart_startup(struct uart_port *port)
 	sport->rxfifo_size = 0x1 << (((temp >> UARTPFIFO_RXSIZE_OFF) &
 		UARTPFIFO_FIFOSIZE_MASK) + 1);
 
-	/* Whether use dma support by dma request results */
-	if (lpuart_dma_tx_request(port) || lpuart_dma_rx_request(port)) {
-		sport->lpuart_dma_use = false;
-	} else {
-		sport->lpuart_dma_use = true;
+	if (sport->dma_rx_chan && !lpuart_dma_rx_request(port)) {
+		sport->lpuart_dma_rx_use = true;
 		setup_timer(&sport->lpuart_timer, lpuart_timer_func,
 			    (unsigned long)sport);
+	} else
+		sport->lpuart_dma_rx_use = false;
+
+
+	if (sport->dma_tx_chan && !lpuart_dma_tx_request(port)) {
+		sport->lpuart_dma_tx_use = true;
 		temp = readb(port->membase + UARTCR5);
 		temp &= ~UARTCR5_RDMAS;
 		writeb(temp | UARTCR5_TDMAS, port->membase + UARTCR5);
-	}
+	} else
+		sport->lpuart_dma_tx_use = false;
 
 	ret = devm_request_irq(port->dev, port->irq, lpuart_int, 0,
 				DRIVER_NAME, sport);
@@ -1179,12 +1154,13 @@ static void lpuart_shutdown(struct uart_port *port)
 
 	devm_free_irq(port->dev, port->irq, sport);
 
-	if (sport->lpuart_dma_use) {
+	if (sport->lpuart_dma_rx_use) {
+		lpuart_dma_rx_free(&sport->port);
 		del_timer_sync(&sport->lpuart_timer);
-
-		lpuart_dma_tx_free(port);
-		lpuart_dma_rx_free(port);
 	}
+
+	if (sport->lpuart_dma_tx_use)
+		lpuart_dma_tx_free(&sport->port);
 }
 
 static void lpuart32_shutdown(struct uart_port *port)
@@ -1306,7 +1282,7 @@ lpuart_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	if (sport->lpuart_dma_use) {
+	if (sport->lpuart_dma_rx_use) {
 		/* Calculate delay for 1.5 DMA buffers */
 		sport->dma_rx_timeout = (sport->port.timeout - HZ / 50) *
 					FSL_UART_RX_DMA_BUFFER_SIZE * 3 /
@@ -1835,6 +1811,16 @@ static int lpuart_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	sport->dma_tx_chan = dma_request_slave_channel(sport->port.dev, "tx");
+	if (!sport->dma_tx_chan)
+		dev_info(sport->port.dev, "DMA tx channel request failed, "
+				"operating without tx DMA\n");
+
+	sport->dma_rx_chan = dma_request_slave_channel(sport->port.dev, "rx");
+	if (!sport->dma_rx_chan)
+		dev_info(sport->port.dev, "DMA rx channel request failed, "
+				"operating without rx DMA\n");
+
 	return 0;
 }
 
@@ -1846,6 +1832,12 @@ static int lpuart_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(sport->clk);
 
+	if (sport->dma_tx_chan)
+		dma_release_channel(sport->dma_tx_chan);
+
+	if (sport->dma_rx_chan)
+		dma_release_channel(sport->dma_rx_chan);
+
 	return 0;
 }
 
-- 
2.2.1

