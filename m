Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaKESnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:43:00 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35393 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037AbaKESlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:41:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 1/4] serial: core: Simplify console suspend logic in uart_suspend_port()
Date: Wed,  5 Nov 2014 13:40:51 -0500
Message-Id: <1415212854-16944-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com>
References: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the uart port being suspended is a console and consoles are
not suspending (kernel command line contains no_console_suspend),
then no action is performed for that port, and the function can
return early.

If the function has not returned early, then one of the conditions
is not true, so the expression
   (console_suspend_enabled || !uart_console(uport))
must be true and can be eliminated.

Similarly, the expression
   (console_suspend_enabled && uart_console(uport))
simplifies to just uart_console(uport).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c5fb08c..158e667 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1959,23 +1959,24 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 	}
 	put_device(tty_dev);
 
-	if (console_suspend_enabled || !uart_console(uport))
-		uport->suspended = 1;
+	/* Nothing to do if the console is not suspending */
+	if (!console_suspend_enabled && uart_console(uport))
+		goto unlock;
+
+	uport->suspended = 1;
 
 	if (port->flags & ASYNC_INITIALIZED) {
 		const struct uart_ops *ops = uport->ops;
 		int tries;
 
-		if (console_suspend_enabled || !uart_console(uport)) {
-			set_bit(ASYNCB_SUSPENDED, &port->flags);
-			clear_bit(ASYNCB_INITIALIZED, &port->flags);
-
-			spin_lock_irq(&uport->lock);
-			ops->stop_tx(uport);
-			ops->set_mctrl(uport, 0);
-			ops->stop_rx(uport);
-			spin_unlock_irq(&uport->lock);
-		}
+		set_bit(ASYNCB_SUSPENDED, &port->flags);
+		clear_bit(ASYNCB_INITIALIZED, &port->flags);
+
+		spin_lock_irq(&uport->lock);
+		ops->stop_tx(uport);
+		ops->set_mctrl(uport, 0);
+		ops->stop_rx(uport);
+		spin_unlock_irq(&uport->lock);
 
 		/*
 		 * Wait for the transmitter to empty.
@@ -1987,19 +1988,17 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 				drv->dev_name,
 				drv->tty_driver->name_base + uport->line);
 
-		if (console_suspend_enabled || !uart_console(uport))
-			ops->shutdown(uport);
+		ops->shutdown(uport);
 	}
 
 	/*
 	 * Disable the console device before suspending.
 	 */
-	if (console_suspend_enabled && uart_console(uport))
+	if (uart_console(uport))
 		console_stop(uport->cons);
 
-	if (console_suspend_enabled || !uart_console(uport))
-		uart_change_pm(state, UART_PM_STATE_OFF);
-
+	uart_change_pm(state, UART_PM_STATE_OFF);
+unlock:
 	mutex_unlock(&port->mutex);
 
 	return 0;
-- 
2.1.3

