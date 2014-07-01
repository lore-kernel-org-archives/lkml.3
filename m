Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbaGAPPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:15:41 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:38866 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbaGAPPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:15:39 -0400
From: Alex Elder <elder@linaro.org>
To: gregkh@linuxfoundation.org
Cc: heikki.krogerus@linux.intel.com, david.daney@cavium.com,
        loic.poulain@intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] serial: 8250_dw: support high baudrates if possible
Date: Tue,  1 Jul 2014 10:15:34 -0500
Message-Id: <1404227734-14180-1-git-send-email-elder@linaro.org>
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
more likely to achieve a specified baud.  A new function
dw8250_adjustable_clk() determines whether such clock rate
adjustment is an option.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Limit clock changing to specific compatible devices.

 drivers/tty/serial/8250/8250_dw.c | 57 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 51b307a..77cae28 100644
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
@@ -282,6 +319,21 @@ static void dw8250_setup_port(struct uart_8250_port *up)
 		up->capabilities |= UART_CAP_AFE;
 }
 
+/*
+ * Returns true if the UART clock's rate can be adjusted in order to
+ * achieve higher baud rates.
+ */
+static bool dw8250_adjustable_clk(struct uart_port *p)
+{
+	struct device_node *np = p->dev->of_node;
+
+	if (of_device_is_compatible(np, "brcm,bcm11351-dw-apb-uart"))
+		return true;
+	if (of_device_is_compatible(np, "brcm,bcm21664-dw-apb-uart"))
+		return true;
+	return false;
+}
+
 static int dw8250_probe_of(struct uart_port *p,
 			   struct dw8250_data *data)
 {
@@ -289,6 +341,9 @@ static int dw8250_probe_of(struct uart_port *p,
 	u32			val;
 	bool has_ucv = true;
 
+	if (dw8250_adjustable_clk(p))
+		p->set_termios = dw8250_set_termios;
+
 	if (of_device_is_compatible(np, "cavium,octeon-3860-uart")) {
 #ifdef __BIG_ENDIAN
 		/*
@@ -510,6 +565,8 @@ static const struct dev_pm_ops dw8250_pm_ops = {
 static const struct of_device_id dw8250_of_match[] = {
 	{ .compatible = "snps,dw-apb-uart" },
 	{ .compatible = "cavium,octeon-3860-uart" },
+	{ .compatible = "brcm,bcm11351-dw-apb-uart" },
+	{ .compatible = "brcm,bcm21664-dw-apb-uart" },
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, dw8250_of_match);
-- 
1.9.1

