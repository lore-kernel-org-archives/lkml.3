Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaGFPao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 11:30:44 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33818 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138AbaGFPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 11:30:12 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Seth Bollinger <sethb@digi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 1/2] serial: Test for no tx data on tx restart
Date: Sun,  6 Jul 2014 11:29:52 -0400
Message-Id: <1404660593-12172-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404660593-12172-1-git-send-email-peter@hurleysoftware.com>
References: <20140609205917.GA913@drone.musicnaut.iki.fi>
 <1404660593-12172-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/tty/serial/imx.c        | 3 +++
 drivers/tty/serial/ip22zilog.c  | 2 ++
 drivers/tty/serial/m32r_sio.c   | 8 +++++---
 drivers/tty/serial/pmac_zilog.c | 3 +++
 drivers/tty/serial/sunsab.c     | 3 +++
 drivers/tty/serial/sunzilog.c   | 2 ++
 6 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 3b6c1a2..23c1dae 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -563,6 +563,9 @@ static void imx_start_tx(struct uart_port *port)
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
2.0.0

