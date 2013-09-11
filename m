Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3IKFcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:32:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab3IKE5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:22 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=9ZLvSYyHmaMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DLYgexd9l-AA:10 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=hBxSID4HHt7pqLnuovwA:9 a=XNN-oNMjSfgA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042913.962173160@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [130/251] serial/mxs-auart: increase time to wait for transmitter to become
 idle
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0130-serial-mxs-auart-increase-time-to-wait-for-transmitt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

[ Upstream commit 079a036f4283e2b0e5c26080b8c5112bc0cc1831 ]

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

Cc: stable@vger.kernel.org # v2.6.39+
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/serial/mxs-auart.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 634be9b..647609d 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -550,7 +550,7 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 	struct mxs_auart_port *s;
 	struct uart_port *port;
 	unsigned int old_ctrl0, old_ctrl2;
-	unsigned int to = 1000;
+	unsigned int to = 20000;
 
 	if (co->index >	MXS_AUART_PORTS || co->index < 0)
 		return;
@@ -571,18 +571,23 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 
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
-- 
1.7.10.4


