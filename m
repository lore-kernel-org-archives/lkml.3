Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaLJLup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:50:45 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59095 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbaLJLum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:50:42 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-33-548833902d87
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, akpm@linux-foundation.org, kgene.kim@samsung.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        l.czerwinski@samsung.com, s.nawrocki@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 5/6] serial: samsung: add DMA support for TX
Date: Wed, 10 Dec 2014 12:49:26 +0100
Message-id: <1418212167-28992-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
References: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd0Jxh0hBidXKVrMWb+GzaJ58Xo2
	i8+/d7Fa9C64ymZxtukNu8WvaZPYLC7vmsNmcWZxL7vF2iN32S0eHN7JbnH4TTurA7fHiRm/
	WTz2z13D7tG3ZRWjx5kFR9g9Pm+SC2CN4rJJSc3JLEst0rdL4MpofNDJWLA/qGLyshlMDYzv
	XboYOTgkBEwk1k7j7mLkBDLFJC7cW8/WxcjFISQwnVFiwYFj7BBOO5PEscdvWUGq2AR0JLZ8
	n8AIYosIyEk8uf2HGaSIWWAqk8Sm65OYQKYKC9hIPPlSA1LDIqAq8WROLzuIzSvgKnFm1nZm
	iG1yEiePTQabySngJrHq2QowWwioZu3tGWwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAgOvmfSOxhXNVgcYhTgYFTi4Q243B4ixJpYVlyZe4hRgoNZSYT3jWRHiBBvSmJlVWpR
	fnxRaU5q8SFGaQ4WJXFeJfu2ECGB9MSS1OzU1ILUIpgsEwenVAOjXdVi1Tcun/JvL/jFXLNH
	0HHy4qrFvr4Caj9jnS5ICN0N4+hx39DK94mzTIMl8V5Cx6IfL+T2uXlnPZNnKLrV/WSlXO+i
	VsegmH36Mt2KjYdyfhe1J7Wv589fWTPn3qHbDy5vLjtRoDb9qq+o93LZjG0ZsWZvj180dU/9
	+1j9ammrCofA7mYlluKMREMt5qLiRACqpcULOgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TX DMA transfers support for samsung serial driver. It's enabled
when "dmas" property is defined in serial device-tree node, otherwise
TX transfers are prerformed using PIO.

TX DMA is used for data segments larger than fifosize to reduce number
of interrupts during data transmission. For buffers shorter than fifosize
PIO mode is selected.

Data blocks for DMA transfers are aligned to cache line size to avoid
problems with coherency (some areas of TX circ buffer can be used by
CPU during DMA transaction, so we have to ensure that our data is always
consistent).

Based on previous work of Sylwester Nawrocki and Lukasz Czerwinski.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/tty/serial/samsung.c | 238 ++++++++++++++++++++++++++++++++++++++++---
 drivers/tty/serial/samsung.h |   3 +
 2 files changed, 225 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 825c819..c046180 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -81,6 +81,8 @@ static void dbg(const char *fmt, ...)
 #define S3C24XX_SERIAL_MAJOR	204
 #define S3C24XX_SERIAL_MINOR	64
 
+#define S3C24XX_TX_PIO			1
+#define S3C24XX_TX_DMA			2
 /* macros to change one thing to another */
 
 #define tx_enabled(port) ((port)->unused[0])
@@ -157,33 +159,217 @@ static void s3c24xx_serial_rx_disable(struct uart_port *port)
 static void s3c24xx_serial_stop_tx(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
+	struct s3c24xx_uart_dma *dma = ourport->dma;
+	struct circ_buf *xmit = &port->state->xmit;
+	struct dma_tx_state state;
+	int count;
 
-	if (tx_enabled(port)) {
-		if (s3c24xx_serial_has_interrupt_mask(port))
-			__set_bit(S3C64XX_UINTM_TXD,
-				portaddrl(port, S3C64XX_UINTM));
-		else
-			disable_irq_nosync(ourport->tx_irq);
-		tx_enabled(port) = 0;
-		if (port->flags & UPF_CONS_FLOW)
-			s3c24xx_serial_rx_enable(port);
+	if (!tx_enabled(port))
+		return;
+
+	if (s3c24xx_serial_has_interrupt_mask(port))
+		__set_bit(S3C64XX_UINTM_TXD,
+			portaddrl(port, S3C64XX_UINTM));
+	else
+		disable_irq_nosync(ourport->tx_irq);
+
+	if (dma && dma->tx_chan && ourport->tx_in_progress == S3C24XX_TX_DMA) {
+		dmaengine_pause(dma->tx_chan);
+		dmaengine_tx_status(dma->tx_chan, dma->tx_cookie, &state);
+		dmaengine_terminate_all(dma->tx_chan);
+		dma_sync_single_for_cpu(ourport->port.dev,
+			dma->tx_transfer_addr, dma->tx_size, DMA_TO_DEVICE);
+		async_tx_ack(dma->tx_desc);
+		count = dma->tx_bytes_requested - state.residue;
+		xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+		port->icount.tx += count;
 	}
+
+	tx_enabled(port) = 0;
+	ourport->tx_in_progress = 0;
+
+	if (port->flags & UPF_CONS_FLOW)
+		s3c24xx_serial_rx_enable(port);
+
+	ourport->tx_mode = 0;
+}
+
+static void s3c24xx_serial_start_next_tx(struct s3c24xx_uart_port *ourport);
+
+static void s3c24xx_serial_tx_dma_complete(void *args)
+{
+	struct s3c24xx_uart_port *ourport = args;
+	struct uart_port *port = &ourport->port;
+	struct circ_buf *xmit = &port->state->xmit;
+	struct s3c24xx_uart_dma *dma = ourport->dma;
+	struct dma_tx_state state;
+	unsigned long flags;
+	int count;
+
+
+	dmaengine_tx_status(dma->tx_chan, dma->tx_cookie, &state);
+	count = dma->tx_bytes_requested - state.residue;
+	async_tx_ack(dma->tx_desc);
+
+	dma_sync_single_for_cpu(ourport->port.dev, dma->tx_transfer_addr,
+				dma->tx_size, DMA_TO_DEVICE);
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	port->icount.tx += count;
+	ourport->tx_in_progress = 0;
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(port);
+
+	s3c24xx_serial_start_next_tx(ourport);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static void enable_tx_dma(struct s3c24xx_uart_port *ourport)
+{
+	struct uart_port *port = &ourport->port;
+	u32 ucon;
+
+	/* Mask Tx interrupt */
+	if (s3c24xx_serial_has_interrupt_mask(port))
+		__set_bit(S3C64XX_UINTM_TXD,
+			  portaddrl(port, S3C64XX_UINTM));
+	else
+		disable_irq_nosync(ourport->tx_irq);
+
+	/* Enable tx dma mode */
+	ucon = rd_regl(port, S3C2410_UCON);
+	ucon &= ~(S3C64XX_UCON_TXBURST_MASK | S3C64XX_UCON_TXMODE_MASK);
+	ucon |= (dma_get_cache_alignment() >= 16) ?
+		S3C64XX_UCON_TXBURST_16 : S3C64XX_UCON_TXBURST_1;
+	ucon |= S3C64XX_UCON_TXMODE_DMA;
+	wr_regl(port,  S3C2410_UCON, ucon);
+
+	ourport->tx_mode = S3C24XX_TX_DMA;
+}
+
+static void enable_tx_pio(struct s3c24xx_uart_port *ourport)
+{
+	struct uart_port *port = &ourport->port;
+	u32 ucon, ufcon;
+
+	/* Set ufcon txtrig */
+	ourport->tx_in_progress = S3C24XX_TX_PIO;
+	ufcon = rd_regl(port, S3C2410_UFCON);
+	wr_regl(port,  S3C2410_UFCON, ufcon);
+
+	/* Enable tx pio mode */
+	ucon = rd_regl(port, S3C2410_UCON);
+	ucon &= ~(S3C64XX_UCON_TXMODE_MASK);
+	ucon |= S3C64XX_UCON_TXMODE_CPU;
+	wr_regl(port,  S3C2410_UCON, ucon);
+
+	/* Unmask Tx interrupt */
+	if (s3c24xx_serial_has_interrupt_mask(port))
+		__clear_bit(S3C64XX_UINTM_TXD,
+			    portaddrl(port, S3C64XX_UINTM));
+	else
+		enable_irq(ourport->tx_irq);
+
+	ourport->tx_mode = S3C24XX_TX_PIO;
 }
 
-static void s3c24xx_serial_start_tx(struct uart_port *port)
+static void s3c24xx_serial_start_tx_pio(struct s3c24xx_uart_port *ourport)
+{
+	if (ourport->tx_mode != S3C24XX_TX_PIO)
+		enable_tx_pio(ourport);
+}
+
+static int s3c24xx_serial_start_tx_dma(struct s3c24xx_uart_port *ourport,
+				      unsigned int count)
+{
+	struct uart_port *port = &ourport->port;
+	struct circ_buf *xmit = &port->state->xmit;
+	struct s3c24xx_uart_dma *dma = ourport->dma;
+
+
+	if (ourport->tx_mode != S3C24XX_TX_DMA)
+		enable_tx_dma(ourport);
+
+	while (xmit->tail & (dma_get_cache_alignment() - 1)) {
+		if (rd_regl(port, S3C2410_UFSTAT) & ourport->info->tx_fifofull)
+			return 0;
+		wr_regb(port, S3C2410_UTXH, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		port->icount.tx++;
+		count--;
+	}
+
+	dma->tx_size = count & ~(dma_get_cache_alignment() - 1);
+	dma->tx_transfer_addr = dma->tx_addr + xmit->tail;
+
+	dma_sync_single_for_device(ourport->port.dev, dma->tx_transfer_addr,
+				dma->tx_size, DMA_TO_DEVICE);
+
+	dma->tx_desc = dmaengine_prep_slave_single(dma->tx_chan,
+				dma->tx_transfer_addr, dma->tx_size,
+				DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
+	if (!dma->tx_desc) {
+		dev_err(ourport->port.dev, "Unable to get desc for Tx\n");
+		return -EIO;
+	}
+
+	dma->tx_desc->callback = s3c24xx_serial_tx_dma_complete;
+	dma->tx_desc->callback_param = ourport;
+	dma->tx_bytes_requested = dma->tx_size;
+
+	ourport->tx_in_progress = S3C24XX_TX_DMA;
+	dma->tx_cookie = dmaengine_submit(dma->tx_desc);
+	dma_async_issue_pending(dma->tx_chan);
+	return 0;
+}
+
+static void s3c24xx_serial_start_next_tx(struct s3c24xx_uart_port *ourport)
+{
+	struct uart_port *port = &ourport->port;
+	struct circ_buf *xmit = &port->state->xmit;
+	unsigned long count;
+
+	/* Get data size up to the end of buffer */
+	count = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
+
+	if (!count) {
+		s3c24xx_serial_stop_tx(port);
+		return;
+	}
+
+	if (!ourport->dma || !ourport->dma->tx_chan || count < port->fifosize)
+		s3c24xx_serial_start_tx_pio(ourport);
+	else
+		s3c24xx_serial_start_tx_dma(ourport, count);
+}
+
+void s3c24xx_serial_start_tx(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
+	struct circ_buf *xmit = &port->state->xmit;
 
 	if (!tx_enabled(port)) {
 		if (port->flags & UPF_CONS_FLOW)
 			s3c24xx_serial_rx_disable(port);
 
-		if (s3c24xx_serial_has_interrupt_mask(port))
-			__clear_bit(S3C64XX_UINTM_TXD,
-				portaddrl(port, S3C64XX_UINTM));
-		else
-			enable_irq(ourport->tx_irq);
 		tx_enabled(port) = 1;
+		if (!ourport->dma || !ourport->dma->tx_chan) {
+			if (s3c24xx_serial_has_interrupt_mask(port))
+				__clear_bit(S3C64XX_UINTM_TXD,
+						portaddrl(port, S3C64XX_UINTM));
+			else
+				enable_irq(ourport->tx_irq);
+
+			s3c24xx_serial_start_tx_pio(ourport);
+		}
+	}
+
+	if (ourport->dma && ourport->dma->tx_chan) {
+		if (!uart_circ_empty(xmit) && !ourport->tx_in_progress)
+			s3c24xx_serial_start_next_tx(ourport);
 	}
 }
 
@@ -333,10 +519,17 @@ static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
 	struct uart_port *port = &ourport->port;
 	struct circ_buf *xmit = &port->state->xmit;
 	unsigned long flags;
-	int count = port->fifosize;
+	int count;
 
 	spin_lock_irqsave(&port->lock, flags);
 
+	count = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
+
+	if (ourport->dma && ourport->dma->tx_chan && count >= port->fifosize) {
+		s3c24xx_serial_start_tx_dma(ourport, count);
+		goto out;
+	}
+
 	if (port->x_char) {
 		wr_regb(port, S3C2410_UTXH, port->x_char);
 		port->icount.tx++;
@@ -355,6 +548,7 @@ static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
 
 	/* try and drain the buffer... */
 
+	count = port->fifosize;
 	while (!uart_circ_empty(xmit) && count-- > 0) {
 		if (rd_regl(port, S3C2410_UFSTAT) & ourport->info->tx_fifofull)
 			break;
@@ -572,6 +766,7 @@ static void s3c24xx_serial_shutdown(struct uart_port *port)
 	if (ourport->dma)
 		s3c24xx_serial_release_dma(ourport);
 
+	ourport->tx_in_progress = 0;
 }
 
 static int s3c24xx_serial_startup(struct uart_port *port)
@@ -650,8 +845,19 @@ static int s3c64xx_serial_startup(struct uart_port *port)
 	tx_enabled(port) = 0;
 	ourport->tx_claimed = 1;
 
+	spin_lock_irqsave(&port->lock, flags);
+
+	ufcon = rd_regl(port, S3C2410_UFCON);
+	ufcon |= S3C2410_UFCON_RESETRX | S3C2410_UFCON_RESETTX;
+	wr_regl(port, S3C2410_UFCON, ufcon);
+
+	enable_rx_pio(ourport);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
 	/* Enable Rx Interrupt */
 	__clear_bit(S3C64XX_UINTM_RXD, portaddrl(port, S3C64XX_UINTM));
+
 	dbg("s3c64xx_serial_startup ok\n");
 	return ret;
 }
diff --git a/drivers/tty/serial/samsung.h b/drivers/tty/serial/samsung.h
index 8dc250c..e60011c 100644
--- a/drivers/tty/serial/samsung.h
+++ b/drivers/tty/serial/samsung.h
@@ -86,6 +86,9 @@ struct s3c24xx_uart_port {
 	unsigned int			rx_irq;
 	unsigned int			tx_irq;
 
+	unsigned int			tx_in_progress;
+	unsigned int			tx_mode;
+
 	struct s3c24xx_uart_info	*info;
 	struct clk			*clk;
 	struct clk			*baudclk;
-- 
1.9.1

