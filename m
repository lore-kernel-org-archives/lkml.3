Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaFPNYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:24:08 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55394 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751383AbaFPNYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:24:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH tty-next 20/22] serial: Refactor uart_flush_buffer() from uart_close()
Date: Mon, 16 Jun 2014 09:17:17 -0400
Message-Id: <1402924639-5164-21-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
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
 drivers/tty/serial/amba-pl011.c   | 1 +
 drivers/tty/serial/atmel_serial.c | 2 ++
 drivers/tty/serial/serial-tegra.c | 2 ++
 drivers/tty/serial/serial_core.c  | 1 -
 drivers/tty/serial/timbuart.c     | 2 ++
 5 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index dacf0a0..4255eef 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1676,6 +1676,7 @@ static void pl011_shutdown(struct uart_port *port)
 			plat->exit();
 	}
 
+	pl011_dma_flush_buffer(port);
 }
 
 static void
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 53eeea1..8aea441 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1664,6 +1664,8 @@ static void atmel_shutdown(struct uart_port *port)
 	 * Free the interrupt
 	 */
 	free_irq(port->irq, port);
+
+	atmel_flush_buffer(port);
 }
 
 /*
diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index d5c2a28..2f5d699 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1042,6 +1042,8 @@ static void tegra_uart_shutdown(struct uart_port *u)
 	tegra_uart_dma_channel_free(tup, true);
 	tegra_uart_dma_channel_free(tup, false);
 	free_irq(u->irq, tup);
+
+	tegra_uart_flush_buffer(u);
 }
 
 static void tegra_uart_enable_ms(struct uart_port *u)
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f13a769..212ee07 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1351,7 +1351,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	mutex_lock(&port->mutex);
 	uart_shutdown(tty, state);
-	uart_flush_buffer(tty);
 
 	tty_ldisc_flush(tty);
 
diff --git a/drivers/tty/serial/timbuart.c b/drivers/tty/serial/timbuart.c
index f87097a..57d8dc0 100644
--- a/drivers/tty/serial/timbuart.c
+++ b/drivers/tty/serial/timbuart.c
@@ -278,6 +278,8 @@ static void timbuart_shutdown(struct uart_port *port)
 	dev_dbg(port->dev, "%s\n", __func__);
 	free_irq(port->irq, uart);
 	iowrite32(0, port->membase + TIMBUART_IER);
+
+	timbuart_flush_buffer(port);
 }
 
 static int get_bindex(int baud)
-- 
2.0.0

