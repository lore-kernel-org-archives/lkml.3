Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaIJTzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:55:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:35630 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaIJTzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:55:31 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 16/16] tty: serial: 8250: omap: add dma support
Date: Wed, 10 Sep 2014 21:30:11 +0200
Message-Id: <1410377411-26656-17-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
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
OMAP36xx (beagle board xm) or DRA7xx.

On AM375x there is "Usage Note 2.7: UART: Cannot Acknowledge Idle
Requests in Smartidle Mode When Configured for DMA Operations" in the
errata document. This problem persists even after disabling DMA in the
UART and will be addressed in the HWMOD.

Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_omap.c | 49 +++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 2a187b00ed0a..5312c9e7ab15 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -366,6 +366,10 @@ static void omap_8250_set_termios(struct uart_port *port,
 	priv->scr = OMAP_UART_SCR_RX_TRIG_GRANU1_MASK | OMAP_UART_SCR_TX_EMPTY |
 		OMAP_UART_SCR_TX_TRIG_GRANU1_MASK;
 
+	if (up->dma)
+		priv->scr |= OMAP_UART_SCR_DMAMODE_1 |
+			OMAP_UART_SCR_DMAMODE_CTL;
+
 	priv->xon = termios->c_cc[VSTART];
 	priv->xoff = termios->c_cc[VSTOP];
 
@@ -548,6 +552,11 @@ static int omap_8250_startup(struct uart_port *port)
 		priv->wer |= OMAP_UART_TX_WAKEUP_EN;
 	serial_out(up, UART_OMAP_WER, priv->wer);
 
+	if (up->dma) {
+		serial8250_rx_dma(up, 0);
+		priv->dma_active = true;
+	}
+
 	pm_runtime_mark_last_busy(port->dev);
 	pm_runtime_put_autosuspend(port->dev);
 	return 0;
@@ -566,6 +575,10 @@ static void omap_8250_shutdown(struct uart_port *port)
 	struct omap8250_priv *priv = port->private_data;
 
 	flush_work(&priv->qos_work);
+	if (up->dma) {
+		serial8250_rx_dma(up, UART_IIR_RX_TIMEOUT);
+		priv->dma_active = false;
+	}
 
 	pm_runtime_get_sync(port->dev);
 
@@ -613,6 +626,13 @@ static void omap_8250_unthrottle(struct uart_port *port)
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
@@ -712,6 +732,30 @@ static int omap8250_probe(struct platform_device *pdev)
 	pm_runtime_get_sync(&pdev->dev);
 
 	omap_serial_fill_features_erratas(&up, priv);
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
+				up.bugs |= UART_BUG_DMA_TX;
+			up.bugs |= UART_BUG_DMA_RX;
+		}
+	}
+#endif
 	ret = serial8250_register_8250_port(&up);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register 8250 port\n");
@@ -848,6 +892,8 @@ static int omap8250_runtime_suspend(struct device *dev)
 	}
 
 	omap8250_enable_wakeup(priv, true);
+	if (priv->dma_active)
+		serial8250_rx_dma(up, UART_IIR_RX_TIMEOUT);
 
 	priv->latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
 	schedule_work(&priv->qos_work);
@@ -872,6 +918,9 @@ static int omap8250_runtime_resume(struct device *dev)
 	if (loss_cntx)
 		omap8250_restore_regs(up);
 
+	if (priv->dma_active)
+		serial8250_rx_dma(up, 0);
+
 	priv->latency = priv->calc_latency;
 	schedule_work(&priv->qos_work);
 	return 0;
-- 
2.1.0

