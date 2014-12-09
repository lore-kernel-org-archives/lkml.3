Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaLINcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:32:32 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:18983 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaLINc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:32:27 -0500
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <nicolas.ferre@atmel.com>, <gregkh@linuxfoundation.org>,
        <wenyou.yang@atmel.com>, <ludovic.desroches@atmel.com>,
        <leilei.zhao@atmel.com>, <voice.shen@atmel.com>, <josh.wu@atmel.com>,
        <linux-serial@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 4/5] tty/serial: at91: fix RTS line management when hardware handshake is enabled
Date: Tue, 9 Dec 2014 14:31:35 +0100
Message-ID: <242df21d70a04c1da8630a356341cbdf00781fda.1418131298.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1418131298.git.cyrille.pitchen@atmel.com>
References: <cover.1418131298.git.cyrille.pitchen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes many bugs in the code dealing with the hardware handshake.

As an example, in atmel_set_termios(), we used to test whether the CRTSCTS
c_cflag was set. If so, we selected the "Hardware Handshake" mode through the
Mode Register. However, few lines below the mode was reset to "Normal" (0).
So there was no way to select the "Hardware Handshake" mode. To fix this issue,
we moved the CRTSCRTS c_cflag test AFTER the mode has been reset to "Normal".

Also setting the RTSEN and RTSDIS bits in the Control Register has different
results whether the USART is set in "Normal" or "Hardware Handshake" mode:

1) "Normal" mode
- the RTSEN bit forces the RTS line to low level, which tells the remote peer
  that we are ready to received new data.
- the RTSDIS bit forces the RTS line to high level, which tells the remote peer
  to stop sending new data.

2) "Hardware Handshake" mode
- the RTSEN bit forces the RTS line to high level.
- the RTSDIS bit lets the hardware control the RTS line.

WARNING:
when FIFOs are not available or not enabled, the RTS line is controlled by the
PDC. This is why using the Hardware Handshake mode requires using the PDC
channel for reception. However the Hardware Handshake mode DOES NOT work with
DMA controller since it cannot control the RTS line.
Future designs with FIFOs will introduce a new feature: the RTS line will be
controlled by the RX FIFO using thresholds. This patch was tested with this new
design.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/tty/serial/atmel_serial.c | 91 ++++++++++++++++++++++++++-------------
 1 file changed, 61 insertions(+), 30 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 92a8b26..9e0c636 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -341,13 +341,37 @@ static u_int atmel_tx_empty(struct uart_port *port)
 static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
 {
 	unsigned int control = 0;
-	unsigned int mode;
+	unsigned int mode = UART_GET_MR(port);
+	unsigned int rts_paused, rts_ready;
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
+	/* override mode to RS485 if needed, otherwise keep the current mode */
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		if ((port->rs485.delay_rts_after_send) > 0)
+			UART_PUT_TTGR(port, port->rs485.delay_rts_after_send);
+		mode &= ~ATMEL_US_USMODE;
+		mode |= ATMEL_US_USMODE_RS485;
+	}
+
+	/* set the RTS line state according to the mode */
+	if ((mode & ATMEL_US_USMODE) == ATMEL_US_USMODE_HWHS) {
+		/* force RTS line to high level */
+		rts_paused = ATMEL_US_RTSEN;
+
+		/* give the control of the RTS line back to the hardware */
+		rts_ready = ATMEL_US_RTSDIS;
+	} else {
+		/* force RTS line to high level */
+		rts_paused = ATMEL_US_RTSDIS;
+
+		/* force RTS line to low level */
+		rts_ready = ATMEL_US_RTSEN;
+	}
+
 	if (mctrl & TIOCM_RTS)
-		control |= ATMEL_US_RTSEN;
+		control |= rts_ready;
 	else
-		control |= ATMEL_US_RTSDIS;
+		control |= rts_paused;
 
 	if (mctrl & TIOCM_DTR)
 		control |= ATMEL_US_DTREN;
@@ -359,23 +383,12 @@ static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
 	mctrl_gpio_set(atmel_port->gpios, mctrl);
 
 	/* Local loopback mode? */
-	mode = UART_GET_MR(port) & ~ATMEL_US_CHMODE;
+	mode &= ~ATMEL_US_CHMODE;
 	if (mctrl & TIOCM_LOOP)
 		mode |= ATMEL_US_CHMODE_LOC_LOOP;
 	else
 		mode |= ATMEL_US_CHMODE_NORMAL;
 
-	/* Resetting serial mode to RS232 (0x0) */
-	mode &= ~ATMEL_US_USMODE;
-
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		dev_dbg(port->dev, "Setting UART to RS485\n");
-		if ((port->rs485.delay_rts_after_send) > 0)
-			UART_PUT_TTGR(port, port->rs485.delay_rts_after_send);
-		mode |= ATMEL_US_USMODE_RS485;
-	} else {
-		dev_dbg(port->dev, "Setting UART to RS232\n");
-	}
 	UART_PUT_MR(port, mode);
 }
 
@@ -1921,12 +1934,14 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 			      struct ktermios *old)
 {
 	unsigned long flags;
-	unsigned int mode, imr, quot, baud;
+	unsigned int old_mode, mode, imr, quot, baud;
+
+	/* save the current mode register */
+	mode = old_mode = UART_GET_MR(port);
 
-	/* Get current mode register */
-	mode = UART_GET_MR(port) & ~(ATMEL_US_USCLKS | ATMEL_US_CHRL
-					| ATMEL_US_NBSTOP | ATMEL_US_PAR
-					| ATMEL_US_USMODE);
+	/* reset the mode, clock divisor, parity, stop bits and data size */
+	mode &= ~(ATMEL_US_USCLKS | ATMEL_US_CHRL | ATMEL_US_NBSTOP |
+		  ATMEL_US_PAR | ATMEL_US_USMODE);
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 	quot = uart_get_divisor(port, baud);
@@ -1971,12 +1986,6 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	} else
 		mode |= ATMEL_US_PAR_NONE;
 
-	/* hardware handshake (RTS/CTS) */
-	if (termios->c_cflag & CRTSCTS)
-		mode |= ATMEL_US_USMODE_HWHS;
-	else
-		mode |= ATMEL_US_USMODE_NORMAL;
-
 	spin_lock_irqsave(&port->lock, flags);
 
 	port->read_status_mask = ATMEL_US_OVRE;
@@ -2020,18 +2029,40 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
 
-	/* Resetting serial mode to RS232 (0x0) */
-	mode &= ~ATMEL_US_USMODE;
-
+	/* mode */
 	if (port->rs485.flags & SER_RS485_ENABLED) {
 		if ((port->rs485.delay_rts_after_send) > 0)
 			UART_PUT_TTGR(port, port->rs485.delay_rts_after_send);
 		mode |= ATMEL_US_USMODE_RS485;
+	} else if (termios->c_cflag & CRTSCTS) {
+		/* RS232 with hardware handshake (RTS/CTS) */
+		mode |= ATMEL_US_USMODE_HWHS;
+	} else {
+		/* RS232 without hadware handshake */
+		mode |= ATMEL_US_USMODE_NORMAL;
 	}
 
-	/* set the parity, stop bits and data size */
+	/* set the mode, clock divisor, parity, stop bits and data size */
 	UART_PUT_MR(port, mode);
 
+	/*
+	 * when switching the mode, set the RTS line state according to the
+	 * new mode, otherwise keep the former state
+	 */
+	if ((old_mode & ATMEL_US_USMODE) != (mode & ATMEL_US_USMODE)) {
+		unsigned int rts_state;
+
+		if ((mode & ATMEL_US_USMODE) == ATMEL_US_USMODE_HWHS) {
+			/* let the hardware control the RTS line */
+			rts_state = ATMEL_US_RTSDIS;
+		} else {
+			/* force RTS line to low level */
+			rts_state = ATMEL_US_RTSEN;
+		}
+
+		UART_PUT_CR(port, rts_state);
+	}
+
 	/* set the baud rate */
 	UART_PUT_BRGR(port, quot);
 	UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
-- 
1.8.2.2

