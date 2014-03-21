Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbaCUJIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:08:35 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:36716 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760186AbaCUJIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:08:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH resend] serial_core: Fix pm imbalance on unbind
Date: Fri, 21 Mar 2014 10:08:25 +0100
Message-Id: <1395392905-29569-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

When a serial port is closed, uart_close() takes care of shutting down the
hardware, and powering it down.

When a serial port is unbound while in use, uart_close() bypasses all of
this, as this is supposed to be done through uart_hangup() (invoked via
tty_vhangup() in uart_remove_one_port()).

However, uart_hangup() does not set the hardware's power state, leaving it
powered up.  This may also lead to unbounded nesting counts in clock and
power management, depending on their internal implementation.

Make sure to power down the port in uart_hangup(), except when the port is
used as a serial console. For serial consoles, this must be postponed until
after their deregistration in uart_remove_one_port() (symmetry with
registration in uart_configure_port(), invoked from uart_add_one_port()).

After this, the module clock used by the sh-sci driver is disabled on
unbind while the serial port is in use.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/tty/serial/serial_core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2cf5649a6dc0..56dda84f82a5 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1452,6 +1452,8 @@ static void uart_hangup(struct tty_struct *tty)
 		clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
 		spin_unlock_irqrestore(&port->lock, flags);
 		tty_port_tty_set(port, NULL);
+		if (!uart_console(state->uart_port))
+			uart_change_pm(state, UART_PM_STATE_OFF);
 		wake_up_interruptible(&port->open_wait);
 		wake_up_interruptible(&port->delta_msr_wait);
 	}
@@ -2681,10 +2683,12 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	}
 
 	/*
-	 * If the port is used as a console, unregister it
+	 * If the port is used as a console, unregister it, and power it down
 	 */
-	if (uart_console(uport))
+	if (uart_console(uport)) {
 		unregister_console(uport->cons);
+		uart_change_pm(state, UART_PM_STATE_OFF);
+	}
 
 	/*
 	 * Free the port IO and memory resources, if any.
-- 
1.7.9.5

