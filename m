Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab3BKSEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:04:52 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:63681 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab3BKSEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:04:41 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, monstr@monstr.eu, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tty: serial: uartlite: Support uartlite on big and little endian systems
Date: Mon, 11 Feb 2013 19:04:34 +0100
Message-Id: <1360605874-18310-2-git-send-email-michal.simek@xilinx.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360605874-18310-1-git-send-email-michal.simek@xilinx.com>
References: <1360605874-18310-1-git-send-email-michal.simek@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use big and little endian accessors function to reflect system configuration.
Detection is done via control register in ulite_request_port.

Tested on Microblaze LE, BE, PPC440 and Arm zynq.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/tty/serial/uartlite.c |  101 ++++++++++++++++++++++++++++++++---------
 1 files changed, 79 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 31444be..59be23b 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -34,7 +34,7 @@
  * Register definitions
  *
  * For register details see datasheet:
- * http://www.xilinx.com/support/documentation/ip_documentation/opb_uartlite.pdf 
+ * http://www.xilinx.com/support/documentation/ip_documentation/opb_uartlite.pdf
  */
 
 #define ULITE_RX		0x00
@@ -57,6 +57,54 @@
 #define ULITE_CONTROL_RST_RX	0x02
 #define ULITE_CONTROL_IE	0x10
 
+struct uartlite_reg_ops {
+	u32 (*in)(void __iomem *addr);
+	void (*out)(u32 val, void __iomem *addr);
+};
+
+static u32 uartlite_inbe32(void __iomem *addr)
+{
+	return ioread32be(addr);
+}
+
+static void uartlite_outbe32(u32 val, void __iomem *addr)
+{
+	iowrite32be(val, addr);
+}
+
+static struct uartlite_reg_ops uartlite_be = {
+	.in = uartlite_inbe32,
+	.out = uartlite_outbe32,
+};
+
+static u32 uartlite_inle32(void __iomem *addr)
+{
+	return ioread32(addr);
+}
+
+static void uartlite_outle32(u32 val, void __iomem *addr)
+{
+	iowrite32(val, addr);
+}
+
+static struct uartlite_reg_ops uartlite_le = {
+	.in = uartlite_inle32,
+	.out = uartlite_outle32,
+};
+
+static inline u32 uart_in32(u32 offset, struct uart_port *port)
+{
+	struct uartlite_reg_ops *reg_ops = port->private_data;
+
+	return reg_ops->in(port->membase + offset);
+}
+
+static inline void uart_out32(u32 val, u32 offset, struct uart_port *port)
+{
+	struct uartlite_reg_ops *reg_ops = port->private_data;
+
+	reg_ops->out(val, port->membase + offset);
+}
 
 static struct uart_port ulite_ports[ULITE_NR_UARTS];
 
@@ -77,7 +125,7 @@ static int ulite_receive(struct uart_port *port, int stat)
 	/* stats */
 	if (stat & ULITE_STATUS_RXVALID) {
 		port->icount.rx++;
-		ch = ioread32be(port->membase + ULITE_RX);
+		ch = uart_in32(ULITE_RX, port);
 
 		if (stat & ULITE_STATUS_PARITY)
 			port->icount.parity++;
@@ -122,7 +170,7 @@ static int ulite_transmit(struct uart_port *port, int stat)
 		return 0;
 
 	if (port->x_char) {
-		iowrite32be(port->x_char, port->membase + ULITE_TX);
+		uart_out32(port->x_char, ULITE_TX, port);
 		port->x_char = 0;
 		port->icount.tx++;
 		return 1;
@@ -131,7 +179,7 @@ static int ulite_transmit(struct uart_port *port, int stat)
 	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
 		return 0;
 
-	iowrite32be(xmit->buf[xmit->tail], port->membase + ULITE_TX);
+	uart_out32(xmit->buf[xmit->tail], ULITE_TX, port);
 	xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE-1);
 	port->icount.tx++;
 
@@ -148,7 +196,7 @@ static irqreturn_t ulite_isr(int irq, void *dev_id)
 	int busy, n = 0;
 
 	do {
-		int stat = ioread32be(port->membase + ULITE_STATUS);
+		int stat = uart_in32(ULITE_STATUS, port);
 		busy  = ulite_receive(port, stat);
 		busy |= ulite_transmit(port, stat);
 		n++;
@@ -169,7 +217,7 @@ static unsigned int ulite_tx_empty(struct uart_port *port)
 	unsigned int ret;
 
 	spin_lock_irqsave(&port->lock, flags);
-	ret = ioread32be(port->membase + ULITE_STATUS);
+	ret = uart_in32(ULITE_STATUS, port);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	return ret & ULITE_STATUS_TXEMPTY ? TIOCSER_TEMT : 0;
@@ -192,7 +240,7 @@ static void ulite_stop_tx(struct uart_port *port)
 
 static void ulite_start_tx(struct uart_port *port)
 {
-	ulite_transmit(port, ioread32be(port->membase + ULITE_STATUS));
+	ulite_transmit(port, uart_in32(ULITE_STATUS, port));
 }
 
 static void ulite_stop_rx(struct uart_port *port)
@@ -220,17 +268,17 @@ static int ulite_startup(struct uart_port *port)
 	if (ret)
 		return ret;
 
-	iowrite32be(ULITE_CONTROL_RST_RX | ULITE_CONTROL_RST_TX,
-	       port->membase + ULITE_CONTROL);
-	iowrite32be(ULITE_CONTROL_IE, port->membase + ULITE_CONTROL);
+	uart_out32(ULITE_CONTROL_RST_RX | ULITE_CONTROL_RST_TX,
+		ULITE_CONTROL, port);
+	uart_out32(ULITE_CONTROL_IE, ULITE_CONTROL, port);
 
 	return 0;
 }
 
 static void ulite_shutdown(struct uart_port *port)
 {
-	iowrite32be(0, port->membase + ULITE_CONTROL);
-	ioread32be(port->membase + ULITE_CONTROL); /* dummy */
+	uart_out32(0, ULITE_CONTROL, port);
+	uart_in32(ULITE_CONTROL, port); /* dummy */
 	free_irq(port->irq, port);
 }
 
@@ -281,6 +329,8 @@ static void ulite_release_port(struct uart_port *port)
 
 static int ulite_request_port(struct uart_port *port)
 {
+	int ret;
+
 	pr_debug("ulite console: port=%p; port->mapbase=%llx\n",
 		 port, (unsigned long long) port->mapbase);
 
@@ -296,6 +346,14 @@ static int ulite_request_port(struct uart_port *port)
 		return -EBUSY;
 	}
 
+	port->private_data = &uartlite_be;
+	ret = uart_in32(ULITE_CONTROL, port);
+	uart_out32(ULITE_CONTROL_RST_TX, ULITE_CONTROL, port);
+	ret = uart_in32(ULITE_STATUS, port);
+	/* Endianess detection */
+	if ((ret & ULITE_STATUS_TXEMPTY) != ULITE_STATUS_TXEMPTY)
+		port->private_data = &uartlite_le;
+
 	return 0;
 }
 
@@ -314,20 +372,19 @@ static int ulite_verify_port(struct uart_port *port, struct serial_struct *ser)
 #ifdef CONFIG_CONSOLE_POLL
 static int ulite_get_poll_char(struct uart_port *port)
 {
-	if (!(ioread32be(port->membase + ULITE_STATUS)
-						& ULITE_STATUS_RXVALID))
+	if (!(uart_in32(ULITE_STATUS, port) & ULITE_STATUS_RXVALID))
 		return NO_POLL_CHAR;
 
-	return ioread32be(port->membase + ULITE_RX);
+	return uart_in32(ULITE_RX, port);
 }
 
 static void ulite_put_poll_char(struct uart_port *port, unsigned char ch)
 {
-	while (ioread32be(port->membase + ULITE_STATUS) & ULITE_STATUS_TXFULL)
+	while (uart_in32(ULITE_STATUS, port) & ULITE_STATUS_TXFULL)
 		cpu_relax();
 
 	/* write char to device */
-	iowrite32be(ch, port->membase + ULITE_TX);
+	uart_out32(ch, ULITE_TX, port);
 }
 #endif
 
@@ -366,7 +423,7 @@ static void ulite_console_wait_tx(struct uart_port *port)
 
 	/* Spin waiting for TX fifo to have space available */
 	for (i = 0; i < 100000; i++) {
-		val = ioread32be(port->membase + ULITE_STATUS);
+		val = uart_in32(ULITE_STATUS, port);
 		if ((val & ULITE_STATUS_TXFULL) == 0)
 			break;
 		cpu_relax();
@@ -376,7 +433,7 @@ static void ulite_console_wait_tx(struct uart_port *port)
 static void ulite_console_putchar(struct uart_port *port, int ch)
 {
 	ulite_console_wait_tx(port);
-	iowrite32be(ch, port->membase + ULITE_TX);
+	uart_out32(ch, ULITE_TX, port);
 }
 
 static void ulite_console_write(struct console *co, const char *s,
@@ -393,8 +450,8 @@ static void ulite_console_write(struct console *co, const char *s,
 		spin_lock_irqsave(&port->lock, flags);
 
 	/* save and disable interrupt */
-	ier = ioread32be(port->membase + ULITE_STATUS) & ULITE_STATUS_IE;
-	iowrite32be(0, port->membase + ULITE_CONTROL);
+	ier = uart_in32(ULITE_STATUS, port) & ULITE_STATUS_IE;
+	uart_out32(0, ULITE_CONTROL, port);
 
 	uart_console_write(port, s, count, ulite_console_putchar);
 
@@ -402,7 +459,7 @@ static void ulite_console_write(struct console *co, const char *s,
 
 	/* restore interrupt state */
 	if (ier)
-		iowrite32be(ULITE_CONTROL_IE, port->membase + ULITE_CONTROL);
+		uart_out32(ULITE_CONTROL_IE, ULITE_CONTROL, port);
 
 	if (locked)
 		spin_unlock_irqrestore(&port->lock, flags);
-- 
1.7.0.4

