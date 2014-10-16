Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaJPUyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:54:51 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51631 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752795AbaJPUyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:54:41 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH -next 01/10] serial: Refactor uart_flush_buffer() from uart_close()
Date: Thu, 16 Oct 2014 16:54:18 -0400
Message-Id: <1413492867-20679-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the context of the final tty & port close, flushing the tx
ring buffer after the hardware has already been shutdown and
the ring buffer freed is neither required nor desirable.

uart_flush_buffer() performs 3 operations:
1. Resets tx ring buffer indices, but the tx ring buffer has
   already been freed and the indices are reset if the port is
   re-opened.
2. Calls uart driver's flush_buffer() method
   5 in-tree uart drivers define flush_buffer() methods:
     amba-pl011, atmel-serial, imx, serial-tegra, timbuart
   These have been refactored into the shutdown() method, if
   required.
3. Kicks the ldisc for more writing, but this is undesirable.
   The file handle is being released; any waiting writer will
   will be kicked out by tty_release() with a warning. Further,
   the N_TTY ldisc may generate SIGIO for a file handle which
   is no longer valid.

Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/amba-pl011.c   |  1 +
 drivers/tty/serial/atmel_serial.c | 28 +++++++++++++++-------------
 drivers/tty/serial/serial-tegra.c | 30 ++++++++++++++++--------------
 drivers/tty/serial/serial_core.c  |  1 -
 drivers/tty/serial/timbuart.c     |  2 ++
 5 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 8572f2a..5b82d7a 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1674,6 +1674,7 @@ static void pl011_shutdown(struct uart_port *port)
 			plat->exit();
 	}
 
+	pl011_dma_flush_buffer(port);
 }
 
 static void
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index d7d4584..8b13d4d 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1801,6 +1801,20 @@ free_irq:
 }
 
 /*
+ * Flush any TX data submitted for DMA. Called when the TX circular
+ * buffer is reset.
+ */
+static void atmel_flush_buffer(struct uart_port *port)
+{
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+
+	if (atmel_use_pdc_tx(port)) {
+		UART_PUT_TCR(port, 0);
+		atmel_port->pdc_tx.ofs = 0;
+	}
+}
+
+/*
  * Disable the port
  */
 static void atmel_shutdown(struct uart_port *port)
@@ -1851,20 +1865,8 @@ static void atmel_shutdown(struct uart_port *port)
 	atmel_free_gpio_irq(port);
 
 	atmel_port->ms_irq_enabled = false;
-}
 
-/*
- * Flush any TX data submitted for DMA. Called when the TX circular
- * buffer is reset.
- */
-static void atmel_flush_buffer(struct uart_port *port)
-{
-	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
-
-	if (atmel_use_pdc_tx(port)) {
-		UART_PUT_TCR(port, 0);
-		atmel_port->pdc_tx.ofs = 0;
-	}
+	atmel_flush_buffer(port);
 }
 
 /*
diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 53d7c31..78a5cf6 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1034,6 +1034,20 @@ fail_rx_dma:
 	return ret;
 }
 
+/*
+ * Flush any TX data submitted for DMA and PIO. Called when the
+ * TX circular buffer is reset.
+ */
+static void tegra_uart_flush_buffer(struct uart_port *u)
+{
+	struct tegra_uart_port *tup = to_tegra_uport(u);
+
+	tup->tx_bytes = 0;
+	if (tup->tx_dma_chan)
+		dmaengine_terminate_all(tup->tx_dma_chan);
+	return;
+}
+
 static void tegra_uart_shutdown(struct uart_port *u)
 {
 	struct tegra_uart_port *tup = to_tegra_uport(u);
@@ -1046,6 +1060,8 @@ static void tegra_uart_shutdown(struct uart_port *u)
 	tegra_uart_dma_channel_free(tup, true);
 	tegra_uart_dma_channel_free(tup, false);
 	free_irq(u->irq, tup);
+
+	tegra_uart_flush_buffer(u);
 }
 
 static void tegra_uart_enable_ms(struct uart_port *u)
@@ -1174,20 +1190,6 @@ static void tegra_uart_set_termios(struct uart_port *u,
 	return;
 }
 
-/*
- * Flush any TX data submitted for DMA and PIO. Called when the
- * TX circular buffer is reset.
- */
-static void tegra_uart_flush_buffer(struct uart_port *u)
-{
-	struct tegra_uart_port *tup = to_tegra_uport(u);
-
-	tup->tx_bytes = 0;
-	if (tup->tx_dma_chan)
-		dmaengine_terminate_all(tup->tx_dma_chan);
-	return;
-}
-
 static const char *tegra_uart_type(struct uart_port *u)
 {
 	return TEGRA_UART_TYPE;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 221ca6f..ce0e762 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1360,7 +1360,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	mutex_lock(&port->mutex);
 	uart_shutdown(tty, state);
-	uart_flush_buffer(tty);
 
 	tty_ldisc_flush(tty);
 
diff --git a/drivers/tty/serial/timbuart.c b/drivers/tty/serial/timbuart.c
index 0d11d50..e9e2523 100644
--- a/drivers/tty/serial/timbuart.c
+++ b/drivers/tty/serial/timbuart.c
@@ -273,6 +273,8 @@ static void timbuart_shutdown(struct uart_port *port)
 	dev_dbg(port->dev, "%s\n", __func__);
 	free_irq(port->irq, uart);
 	iowrite32(0, port->membase + TIMBUART_IER);
+
+	timbuart_flush_buffer(port);
 }
 
 static int get_bindex(int baud)
-- 
2.1.1

