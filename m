Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967800Ab3HICTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:19:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967462Ab3HIB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [ 024/102] serial/mxs-auart: increase time to wait for transmitter to become idle
Date: Thu,  8 Aug 2013 18:57:00 -0700
Message-Id: <20130809015015.541574023@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 079a036f4283e2b0e5c26080b8c5112bc0cc1831 upstream.

Without this patch the driver waits ~1 ms for the UART to become idle. At
115200n8 this time is (theoretically) enough to transfer 11.5 characters
(= 115200 bits/s / (10 Bits/char) * 1ms). As the mxs-auart has a fifo size
of 16 characters the clock is gated too early. The problem is worse for
lower baud rates.

This only happens to really shut down the transmitter in the middle of a
transfer if /dev/ttyAPPx isn't opened in userspace (e.g. by a getty) but
was at least once (because the bootloader doesn't disable the transmitter).

So increase the timeout to 20 ms which should be enough for 9600n8, too.
Moreover skip gating the clock if the timeout is elapsed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/mxs-auart.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -851,7 +851,7 @@ auart_console_write(struct console *co,
 	struct mxs_auart_port *s;
 	struct uart_port *port;
 	unsigned int old_ctrl0, old_ctrl2;
-	unsigned int to = 1000;
+	unsigned int to = 20000;
 
 	if (co->index >= MXS_AUART_PORTS || co->index < 0)
 		return;
@@ -872,18 +872,23 @@ auart_console_write(struct console *co,
 
 	uart_console_write(port, str, count, mxs_auart_console_putchar);
 
-	/*
-	 * Finally, wait for transmitter to become empty
-	 * and restore the TCR
-	 */
+	/* Finally, wait for transmitter to become empty ... */
 	while (readl(port->membase + AUART_STAT) & AUART_STAT_BUSY) {
+		udelay(1);
 		if (!to--)
 			break;
-		udelay(1);
 	}
 
-	writel(old_ctrl0, port->membase + AUART_CTRL0);
-	writel(old_ctrl2, port->membase + AUART_CTRL2);
+	/*
+	 * ... and restore the TCR if we waited long enough for the transmitter
+	 * to be idle. This might keep the transmitter enabled although it is
+	 * unused, but that is better than to disable it while it is still
+	 * transmitting.
+	 */
+	if (!(readl(port->membase + AUART_STAT) & AUART_STAT_BUSY)) {
+		writel(old_ctrl0, port->membase + AUART_CTRL0);
+		writel(old_ctrl2, port->membase + AUART_CTRL2);
+	}
 
 	clk_disable(s->clk);
 }


