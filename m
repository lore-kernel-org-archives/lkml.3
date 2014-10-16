Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaJPV5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:57:55 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44541 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751345AbaJPV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:57:52 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 10/10] serial: core: Fix port count when uart_open() errors
Date: Thu, 16 Oct 2014 16:54:27 -0400
Message-Id: <1413492867-20679-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A port count mismatch occurs if mutex_lock_interruptible()
exits uart_open() and the port has already been opened. This may
prematurely close a port on an open tty. Since uart_close() is _always_
called if uart_open() fails, the port count must be corrected if errors
occur.

Always increment the port count in uart_open(), regardless of errors;
always decrement the port count in uart_close(). Note that
tty_port_close_start() decrements the port count when uart_open()
was successful.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 6a3571e..3f02c2b 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1337,8 +1337,16 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	struct uart_port *uport;
 	unsigned long flags;
 
-	if (!state)
+	if (!state) {
+		struct uart_driver *drv = tty->driver->driver_state;
+
+		state = drv->state + tty->index;
+		port = &state->port;
+		spin_lock_irq(&port->lock);
+		--port->count;
+		spin_unlock_irq(&port->lock);
 		return;
+	}
 
 	uport = state->uart_port;
 	port = &state->port;
@@ -1555,6 +1563,10 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 
 	pr_debug("uart_open(%d) called\n", line);
 
+	spin_lock_irq(&port->lock);
+	++port->count;
+	spin_unlock_irq(&port->lock);
+
 	/*
 	 * We take the semaphore here to guarantee that we won't be re-entered
 	 * while allocating the state structure, or while we request any IRQs
@@ -1567,17 +1579,11 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 		goto end;
 	}
 
-	port->count++;
 	if (!state->uart_port || state->uart_port->flags & UPF_DEAD) {
 		retval = -ENXIO;
-		goto err_dec_count;
+		goto err_unlock;
 	}
 
-	/*
-	 * Once we set tty->driver_data here, we are guaranteed that
-	 * uart_close() will decrement the driver module use count.
-	 * Any failures from here onwards should not touch the count.
-	 */
 	tty->driver_data = state;
 	state->uart_port->state = state;
 	state->port.low_latency =
@@ -1598,8 +1604,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 
 end:
 	return retval;
-err_dec_count:
-	port->count--;
+err_unlock:
 	mutex_unlock(&port->mutex);
 	goto end;
 }
-- 
2.1.1

