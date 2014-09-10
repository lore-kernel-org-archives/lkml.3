Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaIJTIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:08:07 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49022 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753273AbaIJTHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:07:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 07/14] serial: core: Use spin_lock_irq() in uart_set_termios()
Date: Wed, 10 Sep 2014 15:06:29 -0400
Message-Id: <1410375996-4693-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uart_set_termios() is called with interrupts enabled; no need to
save and restore the interrupt state when taking the uart port lock.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 1f52a7d..66e2de6 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1244,7 +1244,6 @@ static void uart_set_termios(struct tty_struct *tty,
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *uport = state->uart_port;
-	unsigned long flags;
 	unsigned int cflag = tty->termios.c_cflag;
 	unsigned int iflag_mask = IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK;
 	bool sw_changed = false;
@@ -1298,19 +1297,19 @@ static void uart_set_termios(struct tty_struct *tty,
 
 	/* Handle turning off CRTSCTS */
 	if ((old_termios->c_cflag & CRTSCTS) && !(cflag & CRTSCTS)) {
-		spin_lock_irqsave(&uport->lock, flags);
+		spin_lock_irq(&uport->lock);
 		uport->hw_stopped = 0;
 		__uart_start(tty);
-		spin_unlock_irqrestore(&uport->lock, flags);
+		spin_unlock_irq(&uport->lock);
 	}
 	/* Handle turning on CRTSCTS */
 	else if (!(old_termios->c_cflag & CRTSCTS) && (cflag & CRTSCTS)) {
-		spin_lock_irqsave(&uport->lock, flags);
+		spin_lock_irq(&uport->lock);
 		if (!(uport->ops->get_mctrl(uport) & TIOCM_CTS)) {
 			uport->hw_stopped = 1;
 			uport->ops->stop_tx(uport);
 		}
-		spin_unlock_irqrestore(&uport->lock, flags);
+		spin_unlock_irq(&uport->lock);
 	}
 }
 
-- 
2.1.0

