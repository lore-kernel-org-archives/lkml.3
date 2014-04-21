Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaDURHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:07:31 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:61097 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaDURHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:07:24 -0400
From: Doug Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        linux-samsung-soc@vger.kernel.org, olof@lixom.net,
        Doug Anderson <dianders@chromium.org>, jslaby@suse.cz,
        paul.gortmaker@windriver.com, jg1.han@samsung.com, asierra@xes-inc.com,
        swarren@nvidia.com, heikki.krogerus@linux.intel.com,
        jschultz@xes-inc.com, kyle@infradead.org, mingo@elte.hu,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] serial_core: Commonalize crlf when working w/ a non open console port
Date: Mon, 21 Apr 2014 10:06:43 -0700
Message-Id: <1398100003-4172-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397841448-12942-1-git-send-email-dianders@chromium.org>
References: <1397841448-12942-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (efe2f29 kgdboc,kdb: Allow kdb to work on a non open console port)
support was added to directly use the "write_char" functions when
doing kdb over a non-open console port.  This is great, but it ends up
bypassing the normal code in uart_console_write() that adds a carriage
return before any newlines.

There appears to have been a trend to add this support directly in
some console driver's poll_put_char() functions.  This had a few side
effects, including:
- In this case we were doing LFCR, not CRLF.  This was fixed in
  uart_console_write() back in (d358788 [SERIAL] kernel console should
  send CRLF not LFCR)
- Not all serial drivers had the LFCR code in their poll_put_char()
  functions.  In my case I was running serial/samsung.c which lacked
  it.

I've moved the handling to uart_poll_put_char() to fix the above
problems.  Now when I use kdb (and don't point console= to the same
UART) I no longer get:

[0]kdb>
       [0]kdb>
              [0]kdb>

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Moved from kdb to serial_core

 drivers/tty/serial/8250/8250_core.c | 5 -----
 drivers/tty/serial/pch_uart.c       | 5 -----
 drivers/tty/serial/pxa.c            | 5 -----
 drivers/tty/serial/serial_core.c    | 3 +++
 drivers/tty/serial/serial_txx9.c    | 5 -----
 5 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 81f909c..ffee982 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1926,13 +1926,8 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	wait_for_xmitr(up, BOTH_EMPTY);
 	/*
 	 *	Send the character out.
-	 *	If a LF, also do CR...
 	 */
 	serial_port_out(port, UART_TX, c);
-	if (c == 10) {
-		wait_for_xmitr(up, BOTH_EMPTY);
-		serial_port_out(port, UART_TX, 13);
-	}
 
 	/*
 	 *	Finally, wait for transmitter to become empty
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 0931b3f..11e631d 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1588,13 +1588,8 @@ static void pch_uart_put_poll_char(struct uart_port *port,
 	wait_for_xmitr(priv, UART_LSR_THRE);
 	/*
 	 * Send the character out.
-	 * If a LF, also do CR...
 	 */
 	iowrite8(c, priv->membase + PCH_UART_THR);
-	if (c == 10) {
-		wait_for_xmitr(priv, UART_LSR_THRE);
-		iowrite8(13, priv->membase + PCH_UART_THR);
-	}
 
 	/*
 	 * Finally, wait for transmitter to become empty
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index f9f20f3..9e7ee39 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -711,13 +711,8 @@ static void serial_pxa_put_poll_char(struct uart_port *port,
 	wait_for_xmitr(up);
 	/*
 	 *	Send the character out.
-	 *	If a LF, also do CR...
 	 */
 	serial_out(up, UART_TX, c);
-	if (c == 10) {
-		wait_for_xmitr(up);
-		serial_out(up, UART_TX, 13);
-	}
 
 	/*
 	 *	Finally, wait for transmitter to become empty
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f26834d..5dba976 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2236,6 +2236,9 @@ static void uart_poll_put_char(struct tty_driver *driver, int line, char ch)
 		return;
 
 	port = state->uart_port;
+
+	if (ch == '\n')
+		port->ops->poll_put_char(port, '\r');
 	port->ops->poll_put_char(port, ch);
 }
 #endif
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index 90a080b..60f49b9 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -535,13 +535,8 @@ static void serial_txx9_put_poll_char(struct uart_port *port, unsigned char c)
 	wait_for_xmitr(up);
 	/*
 	 *	Send the character out.
-	 *	If a LF, also do CR...
 	 */
 	sio_out(up, TXX9_SITFIFO, c);
-	if (c == 10) {
-		wait_for_xmitr(up);
-		sio_out(up, TXX9_SITFIFO, 13);
-	}
 
 	/*
 	 *	Finally, wait for transmitter to become empty
-- 
1.9.1.423.g4596e3a

