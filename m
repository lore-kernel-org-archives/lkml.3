Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbaFLKcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:32:42 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:44005 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbaFLKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:32:34 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 2/9] serial/arc: Refactor by referencing to uart_port where possible
Date: Thu, 12 Jun 2014 16:01:32 +0530
Message-ID: <1402569099-9900-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARC UART MMIO helpers would take arc_uart_port and then reference
generic uart_port->membase member. So change them to difrectly refer to
uart_port and fix call sites accordingly.

This removes the need for to_arc_port() converion almost eveeywhere and
makes code a bit easier to read.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 drivers/tty/serial/arc_uart.c | 155 +++++++++++++++++++-----------------------
 1 file changed, 69 insertions(+), 86 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 32fb8b94ff7c..4d971281e3d9 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -72,7 +72,7 @@
 #define RXOERR  0x02	/* OverFlow Err: Char recv but RXFULL still set */
 
 /* Uart bit fiddling helpers: lowest level */
-#define RBASE(uart, reg)      (uart->port.membase + reg)
+#define RBASE(port, reg)      (port->membase + reg)
 #define UART_REG_SET(u, r, v) writeb((v), RBASE(u, r))
 #define UART_REG_GET(u, r)    readb(RBASE(u, r))
 
@@ -129,19 +129,15 @@ static struct uart_driver arc_uart_driver = {
 
 static void arc_serial_stop_rx(struct uart_port *port)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
-
-	UART_RX_IRQ_DISABLE(uart);
+	UART_RX_IRQ_DISABLE(port);
 }
 
 static void arc_serial_stop_tx(struct uart_port *port)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
-
-	while (!(UART_GET_STATUS(uart) & TXEMPTY))
+	while (!(UART_GET_STATUS(port) & TXEMPTY))
 		cpu_relax();
 
-	UART_TX_IRQ_DISABLE(uart);
+	UART_TX_IRQ_DISABLE(port);
 }
 
 /*
@@ -149,10 +145,9 @@ static void arc_serial_stop_tx(struct uart_port *port)
  */
 static unsigned int arc_serial_tx_empty(struct uart_port *port)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
 	unsigned int stat;
 
-	stat = UART_GET_STATUS(uart);
+	stat = UART_GET_STATUS(port);
 	if (stat & TXEMPTY)
 		return TIOCSER_TEMT;
 
@@ -166,24 +161,24 @@ static unsigned int arc_serial_tx_empty(struct uart_port *port)
  *     = by uart_start( ) before calling us
  *     = tx_ist checks that too before calling
  */
-static void arc_serial_tx_chars(struct arc_uart_port *uart)
+static void arc_serial_tx_chars(struct uart_port *port)
 {
-	struct circ_buf *xmit = &uart->port.state->xmit;
+	struct circ_buf *xmit = &port->state->xmit;
 	int sent = 0;
 	unsigned char ch;
 
-	if (unlikely(uart->port.x_char)) {
-		UART_SET_DATA(uart, uart->port.x_char);
-		uart->port.icount.tx++;
-		uart->port.x_char = 0;
+	if (unlikely(port->x_char)) {
+		UART_SET_DATA(port, port->x_char);
+		port->icount.tx++;
+		port->x_char = 0;
 		sent = 1;
 	} else if (xmit->tail != xmit->head) {	/* TODO: uart_circ_empty */
 		ch = xmit->buf[xmit->tail];
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
-		uart->port.icount.tx++;
-		while (!(UART_GET_STATUS(uart) & TXEMPTY))
+		port->icount.tx++;
+		while (!(UART_GET_STATUS(port) & TXEMPTY))
 			cpu_relax();
-		UART_SET_DATA(uart, ch);
+		UART_SET_DATA(port, ch);
 		sent = 1;
 	}
 
@@ -192,10 +187,10 @@ static void arc_serial_tx_chars(struct arc_uart_port *uart)
 	 * By Hard ISR to schedule processing in software interrupt part
 	 */
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
-		uart_write_wakeup(&uart->port);
+		uart_write_wakeup(port);
 
 	if (sent)
-		UART_TX_IRQ_ENABLE(uart);
+		UART_TX_IRQ_ENABLE(port);
 }
 
 /*
@@ -204,12 +199,10 @@ static void arc_serial_tx_chars(struct arc_uart_port *uart)
  */
 static void arc_serial_start_tx(struct uart_port *port)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
-
-	arc_serial_tx_chars(uart);
+	arc_serial_tx_chars(port);
 }
 
-static void arc_serial_rx_chars(struct arc_uart_port *uart, unsigned int status)
+static void arc_serial_rx_chars(struct uart_port *port, unsigned int status)
 {
 	unsigned int ch, flg = 0;
 
@@ -229,15 +222,15 @@ static void arc_serial_rx_chars(struct arc_uart_port *uart, unsigned int status)
 		 */
 		if (unlikely(status & (RXOERR | RXFERR))) {
 			if (status & RXOERR) {
-				uart->port.icount.overrun++;
+				port->icount.overrun++;
 				flg = TTY_OVERRUN;
-				UART_CLR_STATUS(uart, RXOERR);
+				UART_CLR_STATUS(port, RXOERR);
 			}
 
 			if (status & RXFERR) {
-				uart->port.icount.frame++;
+				port->icount.frame++;
 				flg = TTY_FRAME;
-				UART_CLR_STATUS(uart, RXFERR);
+				UART_CLR_STATUS(port, RXFERR);
 			}
 		} else
 			flg = TTY_NORMAL;
@@ -245,16 +238,16 @@ static void arc_serial_rx_chars(struct arc_uart_port *uart, unsigned int status)
 		if (status & RXEMPTY)
 			continue;
 
-		ch = UART_GET_DATA(uart);
-		uart->port.icount.rx++;
+		ch = UART_GET_DATA(port);
+		port->icount.rx++;
 
-		if (!(uart_handle_sysrq_char(&uart->port, ch)))
-			uart_insert_char(&uart->port, status, RXOERR, ch, flg);
+		if (!(uart_handle_sysrq_char(port, ch)))
+			uart_insert_char(port, status, RXOERR, ch, flg);
 
-		spin_unlock(&uart->port.lock);
-		tty_flip_buffer_push(&uart->port.state->port);
-		spin_lock(&uart->port.lock);
-	} while (!((status = UART_GET_STATUS(uart)) & RXEMPTY));
+		spin_unlock(&port->lock);
+		tty_flip_buffer_push(&port->state->port);
+		spin_lock(&port->lock);
+	} while (!((status = UART_GET_STATUS(port)) & RXEMPTY));
 }
 
 /*
@@ -287,10 +280,10 @@ static void arc_serial_rx_chars(struct arc_uart_port *uart, unsigned int status)
 
 static irqreturn_t arc_serial_isr(int irq, void *dev_id)
 {
-	struct arc_uart_port *uart = dev_id;
+	struct uart_port *port = dev_id;
 	unsigned int status;
 
-	status = UART_GET_STATUS(uart);
+	status = UART_GET_STATUS(port);
 
 	/*
 	 * Single IRQ for both Rx (data available) Tx (room available) Interrupt
@@ -300,9 +293,9 @@ static irqreturn_t arc_serial_isr(int irq, void *dev_id)
 	if (status & RXIENB) {
 
 		/* already in ISR, no need of xx_irqsave */
-		spin_lock(&uart->port.lock);
-		arc_serial_rx_chars(uart, status);
-		spin_unlock(&uart->port.lock);
+		spin_lock(&port->lock);
+		arc_serial_rx_chars(port, status);
+		spin_unlock(&port->lock);
 	}
 
 	if ((status & TXIENB) && (status & TXEMPTY)) {
@@ -310,14 +303,14 @@ static irqreturn_t arc_serial_isr(int irq, void *dev_id)
 		/* Unconditionally disable further Tx-Interrupts.
 		 * will be enabled by tx_chars() if needed.
 		 */
-		UART_TX_IRQ_DISABLE(uart);
+		UART_TX_IRQ_DISABLE(port);
 
-		spin_lock(&uart->port.lock);
+		spin_lock(&port->lock);
 
-		if (!uart_tx_stopped(&uart->port))
-			arc_serial_tx_chars(uart);
+		if (!uart_tx_stopped(port))
+			arc_serial_tx_chars(port);
 
-		spin_unlock(&uart->port.lock);
+		spin_unlock(&port->lock);
 	}
 
 	return IRQ_HANDLED;
@@ -354,18 +347,15 @@ static void arc_serial_break_ctl(struct uart_port *port, int break_state)
 
 static int arc_serial_startup(struct uart_port *port)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
-
 	/* Before we hook up the ISR, Disable all UART Interrupts */
-	UART_ALL_IRQ_DISABLE(uart);
+	UART_ALL_IRQ_DISABLE(port);
 
-	if (request_irq(uart->port.irq, arc_serial_isr, 0, "arc uart rx-tx",
-			uart)) {
-		dev_warn(uart->port.dev, "Unable to attach ARC UART intr\n");
+	if (request_irq(port->irq, arc_serial_isr, 0, "arc uart rx-tx", port)) {
+		dev_warn(port->dev, "Unable to attach ARC UART intr\n");
 		return -EBUSY;
 	}
 
-	UART_RX_IRQ_ENABLE(uart); /* Only Rx IRQ enabled to begin with */
+	UART_RX_IRQ_ENABLE(port); /* Only Rx IRQ enabled to begin with */
 
 	return 0;
 }
@@ -373,8 +363,7 @@ static int arc_serial_startup(struct uart_port *port)
 /* This is not really needed */
 static void arc_serial_shutdown(struct uart_port *port)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
-	free_irq(uart->port.irq, uart);
+	free_irq(port->irq, port);
 }
 
 static void
@@ -411,12 +400,12 @@ arc_serial_set_termios(struct uart_port *port, struct ktermios *new,
 
 	spin_lock_irqsave(&port->lock, flags);
 
-	UART_ALL_IRQ_DISABLE(uart);
+	UART_ALL_IRQ_DISABLE(port);
 
-	UART_SET_BAUDL(uart, uartl);
-	UART_SET_BAUDH(uart, uarth);
+	UART_SET_BAUDL(port, uartl);
+	UART_SET_BAUDH(port, uarth);
 
-	UART_RX_IRQ_ENABLE(uart);
+	UART_RX_IRQ_ENABLE(port);
 
 	/*
 	 * UART doesn't support Parity/Hardware Flow Control;
@@ -439,9 +428,7 @@ arc_serial_set_termios(struct uart_port *port, struct ktermios *new,
 
 static const char *arc_serial_type(struct uart_port *port)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
-
-	return uart->port.type == PORT_ARC ? DRIVER_NAME : NULL;
+	return port->type == PORT_ARC ? DRIVER_NAME : NULL;
 }
 
 static void arc_serial_release_port(struct uart_port *port)
@@ -470,35 +457,30 @@ arc_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
  */
 static void arc_serial_config_port(struct uart_port *port, int flags)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
-
 	if (flags & UART_CONFIG_TYPE)
-		uart->port.type = PORT_ARC;
+		port->type = PORT_ARC;
 }
 
 #if defined(CONFIG_CONSOLE_POLL) || defined(CONFIG_SERIAL_ARC_CONSOLE)
 
 static void arc_serial_poll_putchar(struct uart_port *port, int chr)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
-
-	while (!(UART_GET_STATUS(uart) & TXEMPTY))
+	while (!(UART_GET_STATUS(port) & TXEMPTY))
 		cpu_relax();
 
-	UART_SET_DATA(uart, (unsigned char)chr);
+	UART_SET_DATA(port, (unsigned char)chr);
 }
 #endif
 
 #ifdef CONFIG_CONSOLE_POLL
 static int arc_serial_poll_getchar(struct uart_port *port)
 {
-	struct arc_uart_port *uart = to_arc_port(port);
 	unsigned char chr;
 
-	while (!(UART_GET_STATUS(uart) & RXEMPTY))
+	while (!(UART_GET_STATUS(port) & RXEMPTY))
 		cpu_relax();
 
-	chr = UART_GET_DATA(uart);
+	chr = UART_GET_DATA(port);
 	return chr;
 }
 #endif
@@ -532,6 +514,7 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 	struct resource *res, *res2;
 	unsigned long *plat_data;
 	struct arc_uart_port *uart = &arc_uart_ports[dev_id];
+	struct uart_port *port = &uart->port;
 
 	plat_data = dev_get_platdata(&pdev->dev);
 	if (!plat_data)
@@ -540,7 +523,7 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 	uart->is_emulated = !!plat_data[0];	/* workaround ISS bug */
 
 	if (is_early_platform_device(pdev)) {
-		uart->port.uartclk = plat_data[1];
+		port->uartclk = plat_data[1];
 		uart->baud = plat_data[2];
 	} else {
 		struct device_node *np = pdev->dev.of_node;
@@ -550,7 +533,7 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 			dev_err(&pdev->dev, "clock-frequency property NOTset\n");
 			return -EINVAL;
 		}
-		uart->port.uartclk = val;
+		port->uartclk = val;
 
 		if (of_property_read_u32(np, "current-speed", &val)) {
 			dev_err(&pdev->dev, "current-speed property NOT set\n");
@@ -567,26 +550,26 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 	if (!res2)
 		return -ENODEV;
 
-	uart->port.mapbase = res->start;
-	uart->port.membase = ioremap_nocache(res->start, resource_size(res));
-	if (!uart->port.membase)
+	port->mapbase = res->start;
+	port->membase = ioremap_nocache(res->start, resource_size(res));
+	if (!port->membase)
 		/* No point of dev_err since UART itself is hosed here */
 		return -ENXIO;
 
-	uart->port.irq = res2->start;
-	uart->port.dev = &pdev->dev;
-	uart->port.iotype = UPIO_MEM;
-	uart->port.flags = UPF_BOOT_AUTOCONF;
-	uart->port.line = dev_id;
-	uart->port.ops = &arc_serial_pops;
+	port->irq = res2->start;
+	port->dev = &pdev->dev;
+	port->iotype = UPIO_MEM;
+	port->flags = UPF_BOOT_AUTOCONF;
+	port->line = dev_id;
+	port->ops = &arc_serial_pops;
 
-	uart->port.fifosize = ARC_UART_TX_FIFO_SIZE;
+	port->fifosize = ARC_UART_TX_FIFO_SIZE;
 
 	/*
 	 * uart_insert_char( ) uses it in decideding whether to ignore a
 	 * char or not. Explicitly setting it here, removes the subtelty
 	 */
-	uart->port.ignore_status_mask = 0;
+	port->ignore_status_mask = 0;
 
 	return 0;
 }
-- 
1.8.3.2

