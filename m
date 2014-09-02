Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaIBNH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:07:26 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51737 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaIBNHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:07:22 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [PATCH v11 13/19] serial: amba-pl011: Use container_of() to get uart_amba_port
Date: Tue,  2 Sep 2014 14:00:47 +0100
Message-Id: <1409662853-29313-14-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Universally adopt container_of() for all pointer conversion from
uart_port to uart_amba_port.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/tty/serial/amba-pl011.c | 54 +++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 8572f2a..02016fc 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -678,7 +678,8 @@ static void pl011_dma_flush_buffer(struct uart_port *port)
 __releases(&uap->port.lock)
 __acquires(&uap->port.lock)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 
 	if (!uap->using_tx_dma)
 		return;
@@ -1163,7 +1164,8 @@ static inline bool pl011_dma_rx_running(struct uart_amba_port *uap)
 
 static void pl011_stop_tx(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 
 	uap->im &= ~UART011_TXIM;
 	writew(uap->im, uap->port.membase + UART011_IMSC);
@@ -1172,7 +1174,8 @@ static void pl011_stop_tx(struct uart_port *port)
 
 static void pl011_start_tx(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 
 	if (!pl011_dma_tx_start(uap)) {
 		uap->im |= UART011_TXIM;
@@ -1182,7 +1185,8 @@ static void pl011_start_tx(struct uart_port *port)
 
 static void pl011_stop_rx(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 
 	uap->im &= ~(UART011_RXIM|UART011_RTIM|UART011_FEIM|
 		     UART011_PEIM|UART011_BEIM|UART011_OEIM);
@@ -1193,7 +1197,8 @@ static void pl011_stop_rx(struct uart_port *port)
 
 static void pl011_enable_ms(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 
 	uap->im |= UART011_RIMIM|UART011_CTSMIM|UART011_DCDMIM|UART011_DSRMIM;
 	writew(uap->im, uap->port.membase + UART011_IMSC);
@@ -1349,14 +1354,16 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 
 static unsigned int pl011_tx_empty(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned int status = readw(uap->port.membase + UART01x_FR);
 	return status & (UART01x_FR_BUSY|UART01x_FR_TXFF) ? 0 : TIOCSER_TEMT;
 }
 
 static unsigned int pl011_get_mctrl(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned int result = 0;
 	unsigned int status = readw(uap->port.membase + UART01x_FR);
 
@@ -1374,7 +1381,8 @@ static unsigned int pl011_get_mctrl(struct uart_port *port)
 
 static void pl011_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
 	cr = readw(uap->port.membase + UART011_CR);
@@ -1402,7 +1410,8 @@ static void pl011_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static void pl011_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned long flags;
 	unsigned int lcr_h;
 
@@ -1420,7 +1429,8 @@ static void pl011_break_ctl(struct uart_port *port, int break_state)
 
 static void pl011_quiesce_irqs(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned char __iomem *regs = uap->port.membase;
 
 	writew(readw(regs + UART011_MIS), regs + UART011_ICR);
@@ -1442,7 +1452,8 @@ static void pl011_quiesce_irqs(struct uart_port *port)
 
 static int pl011_get_poll_char(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned int status;
 
 	/*
@@ -1461,7 +1472,8 @@ static int pl011_get_poll_char(struct uart_port *port)
 static void pl011_put_poll_char(struct uart_port *port,
 			 unsigned char ch)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 
 	while (readw(uap->port.membase + UART01x_FR) & UART01x_FR_TXFF)
 		barrier();
@@ -1473,7 +1485,8 @@ static void pl011_put_poll_char(struct uart_port *port,
 
 static int pl011_hwinit(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	int retval;
 
 	/* Optionaly enable pins to be muxed in and configured */
@@ -1526,7 +1539,8 @@ static void pl011_write_lcr_h(struct uart_amba_port *uap, unsigned int lcr_h)
 
 static int pl011_startup(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned int cr, lcr_h, fbrd, ibrd;
 	int retval;
 
@@ -1618,7 +1632,8 @@ static void pl011_shutdown_channel(struct uart_amba_port *uap,
 
 static void pl011_shutdown(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
 	/*
@@ -1680,7 +1695,8 @@ static void
 pl011_set_termios(struct uart_port *port, struct ktermios *termios,
 		     struct ktermios *old)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	unsigned int lcr_h, old_cr;
 	unsigned long flags;
 	unsigned int baud, quot, clkdiv;
@@ -1822,7 +1838,8 @@ pl011_set_termios(struct uart_port *port, struct ktermios *termios,
 
 static const char *pl011_type(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 	return uap->port.type == PORT_AMBA ? uap->type : NULL;
 }
 
@@ -1900,7 +1917,8 @@ static struct uart_amba_port *amba_ports[UART_NR];
 
 static void pl011_console_putchar(struct uart_port *port, int ch)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+	    container_of(port, struct uart_amba_port, port);
 
 	while (readw(uap->port.membase + UART01x_FR) & UART01x_FR_TXFF)
 		barrier();
-- 
1.9.3

