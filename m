Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaJPU5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:57:09 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37138 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752784AbaJPUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:54:40 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 02/10] serial: core: Flush ldisc after dropping port mutex in uart_close()
Date: Thu, 16 Oct 2014 16:54:19 -0400
Message-Id: <1413492867-20679-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty buffers (and any line discipline buffers) must be flushed after
the UART hardware has shutdown; otherwise, a racing open on the same
tty may receive data from the previous session, which is a security
hazard. However, holding the port mutex while flushing the line
discipline buffers creates a lock inversion if the set_termios()
handler takes the port mutex (as it does in the followup patch,
'serial: Fix locking for uart driver set_termios method'.

Flush the ldisc buffers after dropping the port mutex; the tty lock
is still held which prevents a concurrent open() from advancing while
flushing. Since no new rx data is possible after uart_shutdown() until
a new open reinitializes the port, the later flush has no impact on
what data is being discarded.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index ce0e762..6203c6c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1360,9 +1360,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	mutex_lock(&port->mutex);
 	uart_shutdown(tty, state);
-
-	tty_ldisc_flush(tty);
-
 	tty_port_tty_set(port, NULL);
 	tty->closing = 0;
 	spin_lock_irqsave(&port->lock, flags);
@@ -1389,6 +1386,8 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	wake_up_interruptible(&port->close_wait);
 
 	mutex_unlock(&port->mutex);
+
+	tty_ldisc_flush(tty);
 }
 
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
-- 
2.1.1

