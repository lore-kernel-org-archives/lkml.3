Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbaGORWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:22:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48257 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaGORW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:22:26 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Seth Bollinger <sethb@digi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 64/94] serial: Test for no tx data on tx restart
Date: Tue, 15 Jul 2014 20:01:19 +0300
Message-Id: <1405443709-15288-64-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

Commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c,
'serial_core: Fix conditional start_tx on ring buffer not empty'
exposes an incorrect assumption in several drivers' start_tx methods;
the tx ring buffer can, in fact, be empty when restarting tx while
performing flow control.

Affected drivers:
sunsab.c
ip22zilog.c
pmac_zilog.c
sunzilog.c
m32r_sio.c
imx.c

Other in-tree serial drivers either are not affected or already
test for empty tx ring buffer before transmitting.

Test for empty tx ring buffer in start_tx() method, after transmitting
x_char (if applicable).

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Seth Bollinger <sethb@digi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Cc: stable <stable@vger.kernel.org> # 3.15
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/tty/serial/imx.c        |    3 +++
 drivers/tty/serial/ip22zilog.c  |    2 ++
 drivers/tty/serial/m32r_sio.c   |    8 +++++---
 drivers/tty/serial/pmac_zilog.c |    3 +++
 drivers/tty/serial/sunsab.c     |    3 +++
 drivers/tty/serial/sunzilog.c   |    2 ++
 6 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index e2f9387..56bd9aa 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -567,6 +567,9 @@ static void imx_start_tx(struct uart_port *port)
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
+	if (uart_circ_empty(&port.state->xmit))
+		return;
+
 	if (USE_IRDA(sport)) {
 		/* half duplex in IrDA mode; have to disable receive mode */
 		temp = readl(sport->port.membase + UCR4);
diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index 1efd4c3..99b7b86 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -603,6 +603,8 @@ static void ip22zilog_start_tx(struct uart_port *port)
 	} else {
 		struct circ_buf *xmit = &port->state->xmit;
 
+		if (uart_circ_empty(xmit))
+			return;
 		writeb(xmit->buf[xmit->tail], &channel->data);
 		ZSDELAY();
 		ZS_WSYNC(channel);
diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index 68f2c53..5702828 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -266,9 +266,11 @@ static void m32r_sio_start_tx(struct uart_port *port)
 	if (!(up->ier & UART_IER_THRI)) {
 		up->ier |= UART_IER_THRI;
 		serial_out(up, UART_IER, up->ier);
-		serial_out(up, UART_TX, xmit->buf[xmit->tail]);
-		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
-		up->port.icount.tx++;
+		if (!uart_circ_empty(xmit)) {
+			serial_out(up, UART_TX, xmit->buf[xmit->tail]);
+			xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+			up->port.icount.tx++;
+		}
 	}
 	while((serial_in(up, UART_LSR) & UART_EMPTY) != UART_EMPTY);
 #else
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 8193635..f7ad5b9 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -653,6 +653,8 @@ static void pmz_start_tx(struct uart_port *port)
 	} else {
 		struct circ_buf *xmit = &port->state->xmit;
 
+		if (uart_circ_empty(xmit))
+			goto out;
 		write_zsdata(uap, xmit->buf[xmit->tail]);
 		zssync(uap);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
@@ -661,6 +663,7 @@ static void pmz_start_tx(struct uart_port *port)
 		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 			uart_write_wakeup(&uap->port);
 	}
+ out:
 	pmz_debug("pmz: start_tx() done.\n");
 }
 
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 80a58ec..2f57df9 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -427,6 +427,9 @@ static void sunsab_start_tx(struct uart_port *port)
 	struct circ_buf *xmit = &up->port.state->xmit;
 	int i;
 
+	if (uart_circ_empty(xmit))
+		return;
+
 	up->interrupt_mask1 &= ~(SAB82532_IMR1_ALLS|SAB82532_IMR1_XPR);
 	writeb(up->interrupt_mask1, &up->regs->w.imr1);
 	
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index a85db8b..02df394 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -703,6 +703,8 @@ static void sunzilog_start_tx(struct uart_port *port)
 	} else {
 		struct circ_buf *xmit = &port->state->xmit;
 
+		if (uart_circ_empty(xmit))
+			return;
 		writeb(xmit->buf[xmit->tail], &channel->data);
 		ZSDELAY();
 		ZS_WSYNC(channel);
-- 
1.7.10.4

