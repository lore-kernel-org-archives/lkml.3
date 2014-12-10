Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaLJLuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:50:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43716 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaLJLux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:50:53 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-6f-5488339ba0bc
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, akpm@linux-foundation.org, kgene.kim@samsung.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        l.czerwinski@samsung.com, s.nawrocki@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 6/6] serial: samsung: add DMA support for RX
Date: Wed, 10 Dec 2014 12:49:27 +0100
Message-id: <1418212167-28992-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
References: <1418212167-28992-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd3Zxh0hBu0TJCzmrF/DZtG8eD2b
	xeffu1gtehdcZbM42/SG3eLXtElsFpd3zWGzOLO4l91i7ZG77BYPDu9ktzj8pp3VgdvjxIzf
	LB77565h9+jbsorR48yCI+wenzfJBbBGcdmkpOZklqUW6dslcGVMO3WFqWCpT8X8L5/YGxiP
	2XcxcnJICJhI/O/sZoOwxSQu3FsPZHNxCAlMZ5SY+ecrE4TTziTx8tJbZpAqNgEdiS3fJzCC
	2CICchJPbv9hBiliFpjKJLHp+iQmkISwgI3Etq9rwIpYBFQlLjauBWvmFXCVuDZ7NhPEOjmJ
	k8cms4LYnAJuEquerQCzhYBq1t6ewTaBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jOAAfCa9g3FVg8UhRgEORiUe3oDL7SFCrIllxZW5hxglOJiVRHjfSHaECPGmJFZWpRblxxeV
	5qQWH2KU5mBREudVsm8LERJITyxJzU5NLUgtgskycXBKNTDaHTv/IU038Wli23+LoJ1l1y0W
	X331Xbtiv2HCM/HKPc8eLn6zgod3hoIQV5PToTuifcVHAp/6/njo+vhuZdXe40EuL7auuJRt
	uZwlfkKL57eU1S9UrGYfVFCb93ClwAbzEqNF7Z4rQt4s5Rfs+3zY/8uaowvi1VnUexje5eTw
	TbeJWvktOJ5DiaU4I9FQi7moOBEAGQI9JTwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RX DMA transfers support for samsung serial driver. It's enabled
when DMA controller for RX channel is specified in device-tree.

DMA transactions are started when number of bytes in RX FIFO reaches
trigger level, otherwise PIO mode is used. DMA transfer size is always
PAGE_SIZE which can cause large latency when smaller data amount is
transferred, so we always terminate DMA transaction on RX timeout
interrupt. Timeout interval is set to 64 frame times.

Based on previous work of Sylwester Nawrocki and Lukasz Czerwinski.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/tty/serial/samsung.c | 233 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/tty/serial/samsung.h |   1 +
 2 files changed, 231 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c046180..dae3c16 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -83,6 +83,8 @@ static void dbg(const char *fmt, ...)
 
 #define S3C24XX_TX_PIO			1
 #define S3C24XX_TX_DMA			2
+#define S3C24XX_RX_PIO			1
+#define S3C24XX_RX_DMA			2
 /* macros to change one thing to another */
 
 #define tx_enabled(port) ((port)->unused[0])
@@ -373,9 +375,65 @@ void s3c24xx_serial_start_tx(struct uart_port *port)
 	}
 }
 
+static void s3c24xx_uart_copy_rx_to_tty(struct s3c24xx_uart_port *ourport,
+		struct tty_port *tty, int count)
+{
+	struct s3c24xx_uart_dma *dma = ourport->dma;
+	int copied;
+
+	if (!count)
+		return;
+
+	dma_sync_single_for_cpu(ourport->port.dev, dma->rx_addr,
+				dma->rx_size, DMA_FROM_DEVICE);
+
+	ourport->port.icount.rx += count;
+	if (!tty) {
+		dev_err(ourport->port.dev, "No tty port\n");
+		return;
+	}
+	copied = tty_insert_flip_string(tty,
+			((unsigned char *)(ourport->dma->rx_buf)), count);
+	if (copied != count) {
+		WARN_ON(1);
+		dev_err(ourport->port.dev, "RxData copy to tty layer failed\n");
+	}
+}
+
+static int s3c24xx_serial_rx_fifocnt(struct s3c24xx_uart_port *ourport,
+				     unsigned long ufstat);
+
+static void uart_rx_drain_fifo(struct s3c24xx_uart_port *ourport)
+{
+	struct uart_port *port = &ourport->port;
+	struct tty_port *tty = &port->state->port;
+	unsigned int ch, ufstat;
+	unsigned int count;
+
+	ufstat = rd_regl(port, S3C2410_UFSTAT);
+	count = s3c24xx_serial_rx_fifocnt(ourport, ufstat);
+
+	if (!count)
+		return;
+
+	while (count-- > 0) {
+		ch = rd_regb(port, S3C2410_URXH);
+
+		ourport->port.icount.rx++;
+		tty_insert_flip_char(tty, ch, TTY_NORMAL);
+	}
+
+	tty_flip_buffer_push(tty);
+}
+
 static void s3c24xx_serial_stop_rx(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
+	struct s3c24xx_uart_dma *dma = ourport->dma;
+	struct tty_port *t = &port->state->port;
+	struct dma_tx_state state;
+	enum dma_status dma_status;
+	unsigned int received;
 
 	if (rx_enabled(port)) {
 		dbg("s3c24xx_serial_stop_rx: port=%p\n", port);
@@ -386,6 +444,17 @@ static void s3c24xx_serial_stop_rx(struct uart_port *port)
 			disable_irq_nosync(ourport->rx_irq);
 		rx_enabled(port) = 0;
 	}
+	if (dma && dma->rx_chan) {
+		dmaengine_pause(dma->tx_chan);
+		dma_status = dmaengine_tx_status(dma->rx_chan,
+				dma->rx_cookie, &state);
+		if (dma_status == DMA_IN_PROGRESS ||
+			dma_status == DMA_PAUSED) {
+			received = dma->rx_bytes_requested - state.residue;
+			dmaengine_terminate_all(dma->rx_chan);
+			s3c24xx_uart_copy_rx_to_tty(ourport, t, received);
+		}
+	}
 }
 
 static inline struct s3c24xx_uart_info
@@ -417,12 +486,157 @@ static int s3c24xx_serial_rx_fifocnt(struct s3c24xx_uart_port *ourport,
 	return (ufstat & info->rx_fifomask) >> info->rx_fifoshift;
 }
 
+static void s3c64xx_start_rx_dma(struct s3c24xx_uart_port *ourport);
+static void s3c24xx_serial_rx_dma_complete(void *args)
+{
+	struct s3c24xx_uart_port *ourport = args;
+	struct uart_port *port = &ourport->port;
+
+	struct s3c24xx_uart_dma *dma = ourport->dma;
+	struct tty_port *t = &port->state->port;
+	struct tty_struct *tty = tty_port_tty_get(&ourport->port.state->port);
+
+	struct dma_tx_state state;
+	unsigned long flags;
+	int received;
+
+	dmaengine_tx_status(dma->rx_chan,  dma->rx_cookie, &state);
+	received  = dma->rx_bytes_requested - state.residue;
+	async_tx_ack(dma->rx_desc);
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (received)
+		s3c24xx_uart_copy_rx_to_tty(ourport, t, received);
+
+	if (tty) {
+		tty_flip_buffer_push(t);
+		tty_kref_put(tty);
+	}
+
+	s3c64xx_start_rx_dma(ourport);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static void s3c64xx_start_rx_dma(struct s3c24xx_uart_port *ourport)
+{
+	struct s3c24xx_uart_dma *dma = ourport->dma;
+
+	dma_sync_single_for_device(ourport->port.dev, dma->rx_addr,
+				dma->rx_size, DMA_FROM_DEVICE);
+
+	dma->rx_desc = dmaengine_prep_slave_single(dma->rx_chan,
+				dma->rx_addr, dma->rx_size, DMA_DEV_TO_MEM,
+				DMA_PREP_INTERRUPT);
+	if (!dma->rx_desc) {
+		dev_err(ourport->port.dev, "Unable to get desc for Rx\n");
+		return;
+	}
+
+	dma->rx_desc->callback = s3c24xx_serial_rx_dma_complete;
+	dma->rx_desc->callback_param = ourport;
+	dma->rx_bytes_requested = dma->rx_size;
+
+	dma->rx_cookie = dmaengine_submit(dma->rx_desc);
+	dma_async_issue_pending(dma->rx_chan);
+}
 
 /* ? - where has parity gone?? */
 #define S3C2410_UERSTAT_PARITY (0x1000)
 
-static irqreturn_t
-s3c24xx_serial_rx_chars(int irq, void *dev_id)
+static void enable_rx_dma(struct s3c24xx_uart_port *ourport)
+{
+	struct uart_port *port = &ourport->port;
+	unsigned int ucon;
+
+	/* set Rx mode to DMA mode */
+	ucon = rd_regl(port, S3C2410_UCON);
+	ucon &= ~(S3C64XX_UCON_RXBURST_MASK |
+			S3C64XX_UCON_TIMEOUT_MASK |
+			S3C64XX_UCON_EMPTYINT_EN |
+			S3C64XX_UCON_DMASUS_EN |
+			S3C64XX_UCON_TIMEOUT_EN |
+			S3C64XX_UCON_RXMODE_MASK);
+	ucon |= S3C64XX_UCON_RXBURST_16 |
+			0xf << S3C64XX_UCON_TIMEOUT_SHIFT |
+			S3C64XX_UCON_EMPTYINT_EN |
+			S3C64XX_UCON_TIMEOUT_EN |
+			S3C64XX_UCON_RXMODE_DMA;
+	wr_regl(port, S3C2410_UCON, ucon);
+
+	ourport->rx_mode = S3C24XX_RX_DMA;
+}
+
+static void enable_rx_pio(struct s3c24xx_uart_port *ourport)
+{
+	struct uart_port *port = &ourport->port;
+	unsigned int ucon;
+
+	/* set Rx mode to DMA mode */
+	ucon = rd_regl(port, S3C2410_UCON);
+	ucon &= ~(S3C64XX_UCON_TIMEOUT_MASK |
+			S3C64XX_UCON_EMPTYINT_EN |
+			S3C64XX_UCON_DMASUS_EN |
+			S3C64XX_UCON_TIMEOUT_EN |
+			S3C64XX_UCON_RXMODE_MASK);
+	ucon |= 0xf << S3C64XX_UCON_TIMEOUT_SHIFT |
+			S3C64XX_UCON_TIMEOUT_EN |
+			S3C64XX_UCON_RXMODE_CPU;
+	wr_regl(port, S3C2410_UCON, ucon);
+
+	ourport->rx_mode = S3C24XX_RX_PIO;
+}
+
+static irqreturn_t s3c24xx_serial_rx_chars_dma(int irq, void *dev_id)
+{
+	unsigned int utrstat, ufstat, received;
+	struct s3c24xx_uart_port *ourport = dev_id;
+	struct uart_port *port = &ourport->port;
+	struct s3c24xx_uart_dma *dma = ourport->dma;
+	struct tty_struct *tty = tty_port_tty_get(&ourport->port.state->port);
+	struct tty_port *t = &port->state->port;
+	unsigned long flags;
+	struct dma_tx_state state;
+
+	utrstat = rd_regl(port, S3C2410_UTRSTAT);
+	ufstat = rd_regl(port, S3C2410_UFSTAT);
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (!(utrstat & S3C2410_UTRSTAT_TIMEOUT)) {
+		s3c64xx_start_rx_dma(ourport);
+		if (ourport->rx_mode == S3C24XX_RX_PIO)
+			enable_rx_dma(ourport);
+		goto finish;
+	}
+
+	if (ourport->rx_mode == S3C24XX_RX_DMA) {
+		dmaengine_pause(dma->rx_chan);
+		dmaengine_tx_status(dma->rx_chan, dma->rx_cookie, &state);
+		dmaengine_terminate_all(dma->rx_chan);
+		received = dma->rx_bytes_requested - state.residue;
+		s3c24xx_uart_copy_rx_to_tty(ourport, t, received);
+
+		enable_rx_pio(ourport);
+	}
+
+	uart_rx_drain_fifo(ourport);
+
+	if (tty) {
+		tty_flip_buffer_push(t);
+		tty_kref_put(tty);
+	}
+
+	wr_regl(port, S3C2410_UTRSTAT, S3C2410_UTRSTAT_TIMEOUT);
+
+finish:
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t s3c24xx_serial_rx_chars_pio(int irq, void *dev_id)
 {
 	struct s3c24xx_uart_port *ourport = dev_id;
 	struct uart_port *port = &ourport->port;
@@ -513,6 +727,16 @@ out:
 	return IRQ_HANDLED;
 }
 
+
+static irqreturn_t s3c24xx_serial_rx_chars(int irq, void *dev_id)
+{
+	struct s3c24xx_uart_port *ourport = dev_id;
+
+	if (ourport->dma && ourport->dma->rx_chan)
+		return s3c24xx_serial_rx_chars_dma(irq, dev_id);
+	return s3c24xx_serial_rx_chars_pio(irq, dev_id);
+}
+
 static irqreturn_t s3c24xx_serial_tx_chars(int irq, void *id)
 {
 	struct s3c24xx_uart_port *ourport = id;
@@ -818,6 +1042,8 @@ err:
 static int s3c64xx_serial_startup(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
+	unsigned long flags;
+	unsigned int ufcon;
 	int ret;
 
 	dbg("s3c64xx_serial_startup: port=%p (%08llx,%p)\n",
@@ -848,7 +1074,8 @@ static int s3c64xx_serial_startup(struct uart_port *port)
 	spin_lock_irqsave(&port->lock, flags);
 
 	ufcon = rd_regl(port, S3C2410_UFCON);
-	ufcon |= S3C2410_UFCON_RESETRX | S3C2410_UFCON_RESETTX;
+	ufcon |= S3C2410_UFCON_RESETRX | S3C2410_UFCON_RESETTX |
+			S5PV210_UFCON_RXTRIG8;
 	wr_regl(port, S3C2410_UFCON, ufcon);
 
 	enable_rx_pio(ourport);
diff --git a/drivers/tty/serial/samsung.h b/drivers/tty/serial/samsung.h
index e60011c..d275032 100644
--- a/drivers/tty/serial/samsung.h
+++ b/drivers/tty/serial/samsung.h
@@ -88,6 +88,7 @@ struct s3c24xx_uart_port {
 
 	unsigned int			tx_in_progress;
 	unsigned int			tx_mode;
+	unsigned int			rx_mode;
 
 	struct s3c24xx_uart_info	*info;
 	struct clk			*clk;
-- 
1.9.1

