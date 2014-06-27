Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaF0RZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:25:24 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:50750 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaF0RZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:25:21 -0400
From: Alex Elder <elder@linaro.org>
To: gregkh@linuxfoundation.org
Cc: heikki.krogerus@linux.intel.com, david.daney@cavium.com,
        loic.poulain@intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] serial: 8250_dw: support high baudrates if possible
Date: Fri, 27 Jun 2014 12:25:20 -0500
Message-Id: <1403889920-1127-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the Synopsys DesignWare 8250 driver assumes its UART clock
runs at a fixed rate.  If a "real" clock was set up using the common
clock framework, and that clock's rate is adjustable, it may be
possible to support a wider range of baud rates by changing the
UART clock rate.

This is done by setting up a uart_port->set_termios method that
requests a clock rate change if a different rate might make it
more likely to achieve a specified baud.

Signed-off-by: Alex Elder <elder@linaro.org>
---
This patch is also available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/dw8250_clock

 drivers/tty/serial/8250/8250_dw.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 51b307a..013aa9b 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -242,6 +242,43 @@ dw8250_do_pm(struct uart_port *port, unsigned int state, unsigned int old)
 		pm_runtime_put_sync_suspend(port->dev);
 }
 
+/*
+ * If our clock was configured through the common clock framework we
+ * might be able to support a wider range of baud rates by changing
+ * its frequency.  For the "traditional" baud rates (115200 or
+ * less), request the conventional 1.8432 MHz clock.  The clock
+ * frequency needs to be at least 16 times the baud rate, so
+ * use 16 times the requested rate for those higher than 115200.
+ */
+static void
+dw8250_set_termios(struct uart_port *p, struct ktermios *new,
+			struct ktermios *old)
+{
+	struct dw8250_data *data = p->private_data;
+
+	if (!IS_ERR(data->clk)) {
+		speed_t baud;
+		unsigned int rate;
+
+		baud = tty_termios_baud_rate(new);
+		BUG_ON(baud > (speed_t)UINT_MAX);
+		rate = 16 * max(115200U, (unsigned int)baud);
+
+		/*
+		 * Request a different clock rate if necessary, and
+		 * record it if successful.
+		 */
+		if (rate != p->uartclk) {
+			BUG_ON(!data->clk);
+			if (!clk_set_rate(data->clk, (unsigned long)rate))
+				p->uartclk = rate;
+		}
+	}
+
+	/* The standard code does most of the work. */
+	serial8250_do_set_termios(p, new, old);
+}
+
 static bool dw8250_dma_filter(struct dma_chan *chan, void *param)
 {
 	struct dw8250_data *data = param;
@@ -417,6 +454,7 @@ static int dw8250_probe(struct platform_device *pdev)
 	uart.port.iotype = UPIO_MEM;
 	uart.port.serial_in = dw8250_serial_in;
 	uart.port.serial_out = dw8250_serial_out;
+	uart.port.set_termios = dw8250_set_termios;
 	uart.port.private_data = data;
 
 	if (pdev->dev.of_node) {
-- 
1.9.1

