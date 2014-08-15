Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaHOSK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:10:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:57865 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaHOSKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:10:24 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 15/15] tty: serial: 8250: omap: add dma support
Date: Fri, 15 Aug 2014 19:42:43 +0200
Message-Id: <1408124563-31541-16-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the required pieces to 8250-OMAP UART driver for DMA
support. The TX burst size is set to 1 so we can send an arbitrary
amount of bytes.

The RX burst is currently set to 48 which means we receive an DMA
interrupt every 48 bytes and have to reprogram everything. Less bytes in
the RX-FIFO mean that no DMA transfer will happen and the UART will send a
RX-timeout _or_ RDI event at which point the FIFO will be manually purged.
There is a workaround for TX-DMA on AM33xx where we put the first byte
into the FIFO to kick start the DMA process. Haven't seen this problem on
OMAP3 (beagle bone) or DRA7xx.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_omap.c | 79 +++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 368e9d8..dfd2ddd 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -31,10 +31,16 @@
 #define UART_ERRATA_i202_MDR1_ACCESS	(1 << 0)
 #define OMAP_UART_WER_HAS_TX_WAKEUP	(1 << 1)
 
+#define OMAP_UART_FCR_RX_TRIG		6
+#define OMAP_UART_FCR_TX_TRIG		4
+
 /* SCR register bitmasks */
 #define OMAP_UART_SCR_RX_TRIG_GRANU1_MASK	(1 << 7)
 #define OMAP_UART_SCR_TX_TRIG_GRANU1_MASK	(1 << 6)
 #define OMAP_UART_SCR_TX_EMPTY			(1 << 3)
+#define OMAP_UART_SCR_DMAMODE_MASK		(3 << 1)
+#define OMAP_UART_SCR_DMAMODE_1			(1 << 1)
+#define OMAP_UART_SCR_DMAMODE_CTL		(1 << 0)
 
 /* MVR register bitmasks */
 #define OMAP_UART_MVR_SCHEME_SHIFT	30
@@ -45,6 +51,12 @@
 #define OMAP_UART_MVR_MAJ_SHIFT		8
 #define OMAP_UART_MVR_MIN_MASK		0x3f
 
+#define UART_TI752_TLR_TX	0
+#define UART_TI752_TLR_RX	4
+
+#define TRIGGER_TLR_MASK(x)	((x & 0x3c) >> 2)
+#define TRIGGER_FCR_MASK(x)	(x & 3)
+
 /* Enable XON/XOFF flow control on output */
 #define OMAP_UART_SW_TX		0x08
 /* Enable XON/XOFF flow control on input */
@@ -82,6 +94,7 @@ struct omap8250_priv {
 	u32 calc_latency;
 	struct pm_qos_request pm_qos_request;
 	struct work_struct qos_work;
+	struct uart_8250_dma omap8250_dma;
 };
 
 static u32 uart_read(struct uart_8250_port *up, u32 reg)
@@ -162,6 +175,20 @@ static void omap_8250_get_divisor(struct uart_port *port, unsigned int baud,
 	}
 }
 
+static void omap8250_update_scr(struct uart_8250_port *up,
+		struct omap8250_priv *priv)
+{
+	/*
+	 * The manual recommends not to enable the DMA mode selector in the SCR
+	 * (instead of the FCR) register _and_ selecting the DMA mode as one
+	 * register write because this may lead to malfunction.
+	 */
+	if (priv->scr & OMAP_UART_SCR_DMAMODE_MASK)
+		serial_out(up, UART_OMAP_SCR,
+				priv->scr & ~OMAP_UART_SCR_DMAMODE_MASK);
+	serial_out(up, UART_OMAP_SCR, priv->scr);
+}
+
 /*
  * OMAP can use "CLK / (16 or 13) / div" for baud rate. And then we have have
  * some differences in how we want to handle flow control.
@@ -286,6 +313,9 @@ static void omap_8250_set_termios(struct uart_port *port,
 	serial_out(up, UART_TI752_TLR,
 			TRIGGER_TLR_MASK(TX_TRIGGER) << UART_TI752_TLR_TX |
 			TRIGGER_TLR_MASK(RX_TRIGGER) << UART_TI752_TLR_RX);
+	if (up->dma)
+		priv->scr |= OMAP_UART_SCR_DMAMODE_1 |
+			OMAP_UART_SCR_DMAMODE_CTL;
 	/*
 	 * We enable TRIG_GRANU for RX and TX and additionaly we set
 	 * SCR_TX_EMPTY bit. The result is the following:
@@ -294,6 +324,14 @@ static void omap_8250_set_termios(struct uart_port *port,
 	 *   once the UART decides that there no new bytes arriving.
 	 * - Once THRE is enabled, the interrupt will be fired once the FIFO is
 	 *   empty - the trigger level is ignored here.
+	 *
+	 * Once DMA is enabled:
+	 * - UART will assert the TX DMA line once there is room for TX_TRIGGER
+	 *   bytes in the TX FIFO. On each assert the DMA engine will move
+	 *   TX_TRIGGER bytes into the FIFO.
+	 * - UART will assert the RX DMA line once there are RX_TRIGGER bytes in
+	 *   the FIFO and move RX_TRIGGER bytes.
+	 * This is because treshold and trigger values are the same.
 	 */
 	priv->fcr = UART_FCR_ENABLE_FIFO;
 	priv->fcr |= TRIGGER_FCR_MASK(TX_TRIGGER) << OMAP_UART_FCR_TX_TRIG;
@@ -302,7 +340,7 @@ static void omap_8250_set_termios(struct uart_port *port,
 	serial_out(up, UART_FCR, priv->fcr);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
-	serial_out(up, UART_OMAP_SCR, priv->scr);
+	omap8250_update_scr(up, priv);
 
 	/* Reset UART_MCR_TCRTLR: this must be done with the EFR_ECB bit set */
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
@@ -525,6 +563,9 @@ static int omap_8250_startup(struct uart_port *port)
 		priv->wer |= OMAP_UART_TX_WAKEUP_EN;
 	serial_out(up, UART_OMAP_WER, priv->wer);
 
+	if (up->dma)
+		serial8250_rx_dma(up, 0);
+
 	pm_runtime_mark_last_busy(port->dev);
 	pm_runtime_put_autosuspend(port->dev);
 	return 0;
@@ -540,6 +581,8 @@ static void omap_8250_shutdown(struct uart_port *port)
 		container_of(port, struct uart_8250_port, port);
 	struct omap8250_priv *priv = port->private_data;
 
+	if (up->dma)
+		dmaengine_terminate_all(up->dma->rxchan);
 	pm_runtime_get_sync(port->dev);
 
 	serial_out(up, UART_OMAP_WER, 0);
@@ -586,6 +629,13 @@ static void omap_8250_unthrottle(struct uart_port *port)
 	pm_runtime_put_autosuspend(port->dev);
 }
 
+#ifdef CONFIG_SERIAL_8250_DMA
+static bool the_no_dma_filter_fn(struct dma_chan *chan, void *param)
+{
+	return false;
+}
+#endif
+
 static int omap8250_probe(struct platform_device *pdev)
 {
 	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -677,7 +727,29 @@ static int omap8250_probe(struct platform_device *pdev)
 	pm_runtime_get_sync(&pdev->dev);
 
 	omap_serial_fill_features_erratas(&up, priv);
-
+#ifdef CONFIG_SERIAL_8250_DMA
+	if (pdev->dev.of_node) {
+		/*
+		 * Oh DMA support. If there are no DMA properties in the DT then
+		 * we will fall back to a generic DMA channel which does not
+		 * really work here. To ensure that we do not get a generic DMA
+		 * channel assigned, we have the the_no_dma_filter_fn() here.
+		 * To avoid "failed to request DMA" messages we check for DMA
+		 * properties in DT.
+		 */
+		ret = of_property_count_strings(pdev->dev.of_node, "dma-names");
+		if (ret == 2) {
+			up.dma = &priv->omap8250_dma;
+			priv->omap8250_dma.fn = the_no_dma_filter_fn;
+			priv->omap8250_dma.rx_size = RX_TRIGGER;
+			priv->omap8250_dma.rxconf.src_maxburst = RX_TRIGGER;
+			priv->omap8250_dma.txconf.dst_maxburst = TX_TRIGGER;
+
+			if (of_machine_is_compatible("ti,am33xx"))
+				up.bugs |= UART_BUG_DMATX;
+		}
+	}
+#endif
 	ret = serial8250_register_8250_port(&up);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register 8250 port\n");
@@ -848,7 +920,8 @@ static void omap8250_restore_context(struct omap8250_priv *priv)
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	serial_out(up, UART_MCR, up->mcr);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B); /* Config B mode */
-	serial_out(up, UART_OMAP_SCR, priv->scr);
+	omap8250_update_scr(up, priv);
+
 	serial_out(up, UART_EFR, priv->efr);
 	serial_out(up, UART_LCR, up->lcr);
 	if (priv->habit & UART_ERRATA_i202_MDR1_ACCESS)
-- 
2.0.1

