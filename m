Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaI2SZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:25:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:53420 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaI2SZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:25:33 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 12/13] tty: serial: 8250: omap: add custom irq handling
Date: Mon, 29 Sep 2014 20:06:48 +0200
Message-Id: <1412014009-13315-13-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have (or will have) custom DMA callbacks in the omap driver due to
the different behaviour in the RX and TX case. To make this work
we need a few changes in the IRQ handler to invoke the rx_handler again
after the "manual" mode or retry the tx_handler again before falling
back to the manual mode.

Heikki didn't want to see the extra hacks in the generic / default irq
handler and Peter wasn't too happy about an OMAP-only IRQ handler. The
way I planned it is to use this extra IRQ routine only in DMA case. If
Peter dislike this approach then I hope Heikki doesn't block changes in
the default IRQ handler :)

Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h      |  2 ++
 drivers/tty/serial/8250/8250_core.c |  6 ++--
 drivers/tty/serial/8250/8250_omap.c | 55 +++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 4bb831ab5db0..28097a912c10 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -119,6 +119,8 @@ static inline void serial_dl_write(struct uart_8250_port *up, int value)
 }
 
 struct uart_8250_port *serial8250_get_port(int line);
+void serial8250_rpm_get(struct uart_8250_port *p);
+void serial8250_rpm_put(struct uart_8250_port *p);
 
 #if defined(__alpha__) && !defined(CONFIG_PCI)
 /*
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 93b0799936fd..6a3b4399bf3c 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -541,20 +541,22 @@ void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
 }
 EXPORT_SYMBOL_GPL(serial8250_clear_and_reinit_fifos);
 
-static void serial8250_rpm_get(struct uart_8250_port *p)
+void serial8250_rpm_get(struct uart_8250_port *p)
 {
 	if (!(p->capabilities & UART_CAP_RPM))
 		return;
 	pm_runtime_get_sync(p->port.dev);
 }
+EXPORT_SYMBOL_GPL(serial8250_rpm_get);
 
-static void serial8250_rpm_put(struct uart_8250_port *p)
+void serial8250_rpm_put(struct uart_8250_port *p)
 {
 	if (!(p->capabilities & UART_CAP_RPM))
 		return;
 	pm_runtime_mark_last_busy(p->port.dev);
 	pm_runtime_put_autosuspend(p->port.dev);
 }
+EXPORT_SYMBOL_GPL(serial8250_rpm_put);
 
 /*
  * These two wrappers ensure that enable_runtime_pm_tx() can be called more than
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 1659858e595a..6500547f8fda 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -13,6 +13,7 @@
 #include <linux/serial_8250.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
+#include <linux/tty_flip.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/of.h>
@@ -854,6 +855,60 @@ static int omap_8250_tx_dma(struct uart_8250_port *p)
 	return ret;
 }
 
+/*
+ * This is mostly serial8250_handle_irq(). We have a slightly different DMA
+ * hoook for RX/TX and need different logic for them in the ISR. Therefore we
+ * use the default routine in the non-DMA case and this one for with DMA.
+ */
+static int omap_8250_dma_handle_irq(struct uart_port *port)
+{
+	struct uart_8250_port *up = up_to_u8250p(port);
+	unsigned char status;
+	unsigned long flags;
+	u8 iir;
+	int dma_err = 0;
+
+	serial8250_rpm_get(up);
+
+	iir = serial_port_in(port, UART_IIR);
+	if (iir & UART_IIR_NO_INT) {
+		serial8250_rpm_put(up);
+		return 0;
+	}
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	status = serial_port_in(port, UART_LSR);
+
+	if (status & (UART_LSR_DR | UART_LSR_BI)) {
+
+		dma_err = omap_8250_rx_dma(up, iir);
+		if (dma_err) {
+			status = serial8250_rx_chars(up, status);
+			omap_8250_rx_dma(up, 0);
+		}
+	}
+	serial8250_modem_status(up);
+	if (status & UART_LSR_THRE && up->dma->tx_err) {
+		if (uart_tx_stopped(&up->port) ||
+		    uart_circ_empty(&up->port.state->xmit)) {
+			up->dma->tx_err = 0;
+			serial8250_tx_chars(up);
+		} else  {
+			/*
+			 * try again due to an earlier failer which
+			 * might have been resolved by now.
+			 */
+			dma_err = omap_8250_tx_dma(up);
+			if (dma_err)
+				serial8250_tx_chars(up);
+		}
+	}
+
+	spin_unlock_irqrestore(&port->lock, flags);
+	serial8250_rpm_put(up);
+	return 1;
+}
 #endif
 
 static int omap8250_probe(struct platform_device *pdev)
-- 
2.1.0

