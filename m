Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaG2TBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:01:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:50364 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaG2TAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:00:19 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH 7/7] tty: serial: 8250: omap: add dma support
Date: Tue, 29 Jul 2014 20:59:04 +0200
Message-Id: <1406660344-25307-8-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the required pieces to OMAP uart for DMA support. The TX
burst size is set to 1 so we can send an arbitrary amout of bytes.

The RX burst is currently set to 8 which means we receive an interrupt
every eight bytes and have to reprogramm everything. Seven bytes in the
RX-fifo mean that no transfer will happen and the UART will send a
RX-timeout event at which point the FIFO will be manually purged.
I played around with the trigger value and burst and burst of one, trigger
eight isn't really better. We receive a DMA-complete event once we
received eight. Should we receive only 7 bytes then the DMA will fetch
them and wait for the last one and there will be RX-timeout from the
UART because the RX-FIFO is empty.
Since this makes most sense for high baudrates I think I will increment
the RX size to something larger.
This works fine on DRA7. AM33xx is a diffent story and I run into two
problems:
- TX, after ptogramming the TX transfer there has to be a byte written
  into the FIFO to trigger the transfer. After that, the transfer
  continues and reloads as expected. I had a workaround for this but
  wasn't working perfectly.
- RX, after the DMA engines fetches the data from the FIFO there is not
  only a dma-complete interrupt but also an UART interrupt which
  reports nothing (because the FIFO is already empty). I managed a few
  to receive wrong data if the UART interrupt was delayed and I am not
  yet sure if this is a real problem, a theoretical one or just a bug
  somewhere in the driver(s)

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_omap.c | 92 +++++++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 4d01f45..6cc8174 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/console.h>
 #include <linux/pm_qos.h>
+#include <linux/edma.h>
 
 #include "8250.h"
 
@@ -31,10 +32,16 @@
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
@@ -45,6 +52,12 @@
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
@@ -78,6 +91,7 @@ struct omap8250_priv {
 	u32 calc_latency;
 	struct pm_qos_request pm_qos_request;
 	struct work_struct qos_work;
+	struct uart_8250_dma omap8250_dma;
 };
 
 static u32 uart_read(struct uart_8250_port *up, u32 reg)
@@ -158,6 +172,20 @@ static void omap_8250_get_divisor(struct uart_port *port, unsigned int baud,
 	}
 }
 
+static void omap8250_update_scr(struct uart_8250_port *up,
+		struct omap8250_priv *priv)
+{
+	/*
+	 * As it turns out the DMA part in the UART strikes if the CONTROL bit
+	 * and the DMA-MODE is set at the same time. Therefore we first set the
+	 * control bit with DMA off and then we switch to the required DMA mode.
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
@@ -273,7 +301,19 @@ static void omap_8250_set_termios(struct uart_port *port,
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
 	serial_out(up, UART_MCR, up->mcr | UART_MCR_TCRTLR);
 
-	priv->scr = OMAP_UART_SCR_RX_TRIG_GRANU1_MASK | OMAP_UART_SCR_TX_EMPTY;
+	serial_out(up, UART_TI752_TCR, OMAP_UART_TCR_TRIG);
+
+	serial_out(up, UART_TI752_TLR,
+			TRIGGER_TLR_MASK(1) << UART_TI752_TLR_TX |
+			TRIGGER_TLR_MASK(8) << UART_TI752_TLR_RX);
+
+	priv->scr =  OMAP_UART_SCR_RX_TRIG_GRANU1_MASK | OMAP_UART_SCR_TX_EMPTY;
+	if (up->dma) {
+		priv->scr |= OMAP_UART_SCR_DMAMODE_1 |
+			OMAP_UART_SCR_DMAMODE_CTL;
+		priv->scr |= OMAP_UART_SCR_TX_TRIG_GRANU1_MASK;
+	}
+
 	/*
 	 * NOTE: Setting OMAP_UART_SCR_RX_TRIG_GRANU1_MASK sets Enables the
 	 * granularity of 1 for TRIGGER RX level. Along with setting RX FIFO
@@ -283,13 +323,14 @@ static void omap_8250_set_termios(struct uart_port *port,
 	 * we receive an interrupt once TX FIFO (and shift) is empty as this is
 	 * what The irq routine currently expects to happen.
 	 */
-	priv->fcr = UART_FCR6_R_TRIGGER_16 | UART_FCR6_T_TRIGGER_24 |
-		UART_FCR_ENABLE_FIFO;
+	priv->fcr |= UART_FCR_ENABLE_FIFO;
+	priv->fcr |= TRIGGER_FCR_MASK(1) << OMAP_UART_FCR_TX_TRIG;
+	priv->fcr |= TRIGGER_FCR_MASK(8) << OMAP_UART_FCR_RX_TRIG;
 
 	serial_out(up, UART_FCR, priv->fcr);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
-	serial_out(up, UART_OMAP_SCR, priv->scr);
+	omap8250_update_scr(up, priv);
 
 	/* Reset UART_MCR_TCRTLR: this must be done with the EFR_ECB bit set */
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
@@ -333,13 +374,6 @@ static void omap_8250_set_termios(struct uart_port *port,
 	serial_out(up, UART_XON1, termios->c_cc[VSTART]);
 	serial_out(up, UART_XOFF1, termios->c_cc[VSTOP]);
 
-	/* Enable access to TCR/TLR */
-	serial_out(up, UART_EFR, UART_EFR_ECB);
-	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
-	serial_out(up, UART_MCR, up->mcr | UART_MCR_TCRTLR);
-
-	serial_out(up, UART_TI752_TCR, OMAP_UART_TCR_TRIG);
-
 	priv->efr = 0;
 	if (termios->c_cflag & CRTSCTS && up->port.flags & UPF_HARD_FLOW) {
 		/* Enable AUTORTS and AUTOCTS */
@@ -377,9 +411,8 @@ static void omap_8250_set_termios(struct uart_port *port,
 		else
 			up->mcr &= ~UART_MCR_XONANY;
 	}
-	serial_out(up, UART_MCR, up->mcr);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, 0);
+	serial_out(up, UART_EFR, priv->efr);
 	serial_out(up, UART_LCR, up->lcr);
 
 	port->ops->set_mctrl(port, port->mctrl);
@@ -519,6 +552,9 @@ static int omap_8250_startup(struct uart_port *port)
 		priv->wer |= OMAP_UART_TX_WAKEUP_EN;
 	serial_out(up, UART_OMAP_WER, priv->wer);
 
+	if (up->dma)
+		serial8250_rx_dma(up, 0);
+
 	pm_runtime_mark_last_busy(port->dev);
 	pm_runtime_put_autosuspend(port->dev);
 	return 0;
@@ -580,6 +616,13 @@ static void omap_8250_unthrottle(struct uart_port *port)
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
@@ -667,7 +710,27 @@ static int omap8250_probe(struct platform_device *pdev)
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
+			priv->omap8250_dma.rx_size = 8;
+			priv->omap8250_dma.rxconf.src_maxburst = 8;
+			priv->omap8250_dma.txconf.dst_maxburst = 1;
 
+		}
+	}
+#endif
 	ret = serial8250_register_8250_port(&up);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register 8250 port\n");
@@ -838,7 +901,8 @@ static void omap8250_restore_context(struct omap8250_priv *priv)
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

