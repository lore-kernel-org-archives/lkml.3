Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3HPWlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:41:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3HPWlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 057/133] serial/mxs-auart: increase time to wait for transmitter to become idle
Date: Fri, 16 Aug 2013 15:33:19 -0700
Message-Id: <1376692475-28413-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/mxs-auart.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 6b00fa5..8bb306b 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -883,7 +883,7 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 	struct mxs_auart_port *s;
 	struct uart_port *port;
 	unsigned int old_ctrl0, old_ctrl2;
-	unsigned int to = 1000;
+	unsigned int to = 20000;
 
 	if (co->index >= MXS_AUART_PORTS || co->index < 0)
 		return;
@@ -904,18 +904,23 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 
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
1.8.1.2

