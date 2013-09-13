Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3IMPlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:41:45 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:37396 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab3IMPll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:41:41 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 3/3] USB : serial : pl2303 wake up after dcd status check.
Date: Fri, 13 Sep 2013 17:35:13 +0200
Message-Id: <1379086513-2434-4-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Fri, 13 Sep 2013 17:41:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to be done this way in other drivers (ch341, 8250, ...).
And get tty reference only if dcd_change need to be called.

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/usb/serial/pl2303.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index e7a84f0..8b81188 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -854,15 +854,16 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
 	spin_unlock_irqrestore(&priv->lock, flags);
 	if (priv->line_status & UART_BREAK_ERROR)
 		usb_serial_handle_break(port);
-	wake_up_interruptible(&port->port.delta_msr_wait);
 
-	tty = tty_port_tty_get(&port->port);
-	if (!tty)
-		return;
-	if ((priv->line_status ^ prev_line_status) & UART_DCD)
-		usb_serial_handle_dcd_change(port, tty,
-				priv->line_status & UART_DCD);
-	tty_kref_put(tty);
+	if ((priv->line_status ^ prev_line_status) & UART_DCD) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty)
+			usb_serial_handle_dcd_change(port, tty,
+					priv->line_status & UART_DCD);
+		tty_kref_put(tty);
+	}
+
+	wake_up_interruptible(&port->port.delta_msr_wait);
 }
 
 static void pl2303_read_int_callback(struct urb *urb)
-- 
1.7.12.1

