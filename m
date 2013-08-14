Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3HNLAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:00:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759743Ab3HNKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 09/75] serial/mxs-auart: increase time to wait for transmitter to become idle
Date: Wed, 14 Aug 2013 11:35:58 +0100
Message-Id: <1376476624-10011-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/mxs-auart.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 4313f49..64565f8 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -545,7 +545,7 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 	struct mxs_auart_port *s;
 	struct uart_port *port;
 	unsigned int old_ctrl0, old_ctrl2;
-	unsigned int to = 1000;
+	unsigned int to = 20000;
 
 	if (co->index >	MXS_AUART_PORTS || co->index < 0)
 		return;
@@ -566,18 +566,23 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 
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
1.8.3.2

