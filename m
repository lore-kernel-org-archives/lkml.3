Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaLaVdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 16:33:09 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:60495 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaLaVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 16:33:07 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] serial: omap_8250: Fix RTS handling, part B
Date: Wed, 31 Dec 2014 16:32:49 -0500
Message-Id: <1420061569-502-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the OMAP3 UART ignores MCR[1] (RTS) in autoRTS mode, autoRTS
mode must not be enabled unless RTS is set (or port->mctrl & TIOCM_RTS,
which is equivalent).

Fixes premature raising of RTS in omap_8250_set_termios() -- RTS was
raised even before UART mode was selected.
Fixes raise of RTS after port has been shutdown; omap_8250_pm() re-enabled
RTS after omap_8250_shutdown().

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_omap.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 428f384..316c37b 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -272,7 +272,10 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 	serial_dl_write(up, priv->quot);
 
-	serial_out(up, UART_EFR, priv->efr);
+	if (up->port.mctrl & TIOCM_RTS)
+		serial_out(up, UART_EFR, priv->efr);
+	else
+		serial_out(up, UART_EFR, priv->efr & ~UART_EFR_RTS);
 
 	/* Configure flow control */
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
@@ -468,18 +471,18 @@ static void omap_8250_set_termios(struct uart_port *port,
 static void omap_8250_pm(struct uart_port *port, unsigned int state,
 			 unsigned int oldstate)
 {
-	struct uart_8250_port *up =
-		container_of(port, struct uart_8250_port, port);
-	struct omap8250_priv *priv = up->port.private_data;
+	struct uart_8250_port *up = up_to_u8250p(port);
+	u8 efr;
 
 	pm_runtime_get_sync(port->dev);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, priv->efr | UART_EFR_ECB);
+	efr = serial_in(up, UART_EFR);
+	serial_out(up, UART_EFR, efr | UART_EFR_ECB);
 	serial_out(up, UART_LCR, 0);
 
 	serial_out(up, UART_IER, (state != 0) ? UART_IERX_SLEEP : 0);
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, priv->efr);
+	serial_out(up, UART_EFR, efr);
 	serial_out(up, UART_LCR, 0);
 
 	pm_runtime_mark_last_busy(port->dev);
-- 
2.2.1

