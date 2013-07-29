Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3G2WP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:15:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:49587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab3G2WP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:15:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,773,1367996400"; 
   d="scan'208";a="353861255"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH] pch_uart: Fix signed-ness and casting of uartclk related fields
Date: Mon, 29 Jul 2013 15:15:07 -0700
Message-Id: <ffa173ec15e8f7fcce6cf9f988110448a4dcf072.1375136107.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Storing one struct per known board would be overkill. Pre-cast the
driver_data pointer to an unsigned long to avoid the pointer to int
compiler warning:

drivers/tty/serial/pch_uart.c:431:10: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]

Unify the signed-ness of the baud and uartclk types throughout the
driver.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index bc0aa08..5040c51 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -232,7 +232,7 @@ struct eg20t_port {
 	unsigned int iobase;
 	struct pci_dev *pdev;
 	int fifo_size;
-	int uartclk;
+	unsigned int uartclk;
 	int start_tx;
 	int start_rx;
 	int tx_empty;
@@ -419,7 +419,7 @@ static struct dmi_system_id pch_uart_dmi_table[] = {
 };
 
 /* Return UART clock, checking for board specific clocks. */
-static int pch_uart_get_uartclk(void)
+static unsigned int pch_uart_get_uartclk(void)
 {
 	const struct dmi_system_id *d;
 
@@ -428,7 +428,7 @@ static int pch_uart_get_uartclk(void)
 
 	d = dmi_first_match(pch_uart_dmi_table);
 	if (d)
-		return (int)d->driver_data;
+		return (unsigned long)d->driver_data;
 
 	return DEFAULT_UARTCLK;
 }
@@ -449,7 +449,7 @@ static void pch_uart_hal_disable_interrupt(struct eg20t_port *priv,
 	iowrite8(ier, priv->membase + UART_IER);
 }
 
-static int pch_uart_hal_set_line(struct eg20t_port *priv, int baud,
+static int pch_uart_hal_set_line(struct eg20t_port *priv, unsigned int baud,
 				 unsigned int parity, unsigned int bits,
 				 unsigned int stb)
 {
@@ -484,7 +484,7 @@ static int pch_uart_hal_set_line(struct eg20t_port *priv, int baud,
 	lcr |= bits;
 	lcr |= stb;
 
-	dev_dbg(priv->port.dev, "%s:baud = %d, div = %04x, lcr = %02x (%lu)\n",
+	dev_dbg(priv->port.dev, "%s:baud = %u, div = %04x, lcr = %02x (%lu)\n",
 		 __func__, baud, div, lcr, jiffies);
 	iowrite8(PCH_UART_LCR_DLAB, priv->membase + UART_LCR);
 	iowrite8(dll, priv->membase + PCH_UART_DLL);
@@ -1390,9 +1390,8 @@ static void pch_uart_shutdown(struct uart_port *port)
 static void pch_uart_set_termios(struct uart_port *port,
 				 struct ktermios *termios, struct ktermios *old)
 {
-	int baud;
 	int rtn;
-	unsigned int parity, bits, stb;
+	unsigned int baud, parity, bits, stb;
 	struct eg20t_port *priv;
 	unsigned long flags;
 
-- 
1.8.3.1

