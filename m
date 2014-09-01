Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaIAPUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:20:00 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33101 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaIAPT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:19:58 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] serial: serial_core.c: printk replacement
Date: Mon,  1 Sep 2014 20:49:43 +0530
Message-Id: <1409584783-3021-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk replaced with corresponding dev_* .
fixed two broken user-visible strings used by the corresponding printk.
the null check for uport->dev and port->dev is removed as dev_* will check for
null while printing.
printing of dev_name(uport->dev) and dev_name(port->dev) also removed as those
are being printed by dev_* . 

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/tty/serial/serial_core.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 29a7be4..079f18d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -892,10 +892,11 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
 			 */
 			if (uport->flags & UPF_SPD_MASK) {
 				char buf[64];
-				printk(KERN_NOTICE
-				       "%s sets custom speed on %s. This "
-				       "is deprecated.\n", current->comm,
-				       tty_name(port->tty, buf));
+
+				dev_notice(uport->dev,
+				       "%s sets custom speed on %s. This is deprecated.\n",
+				      current->comm,
+				      tty_name(port->tty, buf));
 			}
 			uart_change_speed(tty, state, NULL);
 		}
@@ -1975,12 +1976,9 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 		for (tries = 3; !ops->tx_empty(uport) && tries; tries--)
 			msleep(10);
 		if (!tries)
-			printk(KERN_ERR "%s%s%s%d: Unable to drain "
-					"transmitter\n",
-			       uport->dev ? dev_name(uport->dev) : "",
-			       uport->dev ? ": " : "",
-			       drv->dev_name,
-			       drv->tty_driver->name_base + uport->line);
+			dev_err(uport->dev, "%s%d: Unable to drain transmitter\n",
+				drv->dev_name,
+				drv->tty_driver->name_base + uport->line);
 
 		if (console_suspend_enabled || !uart_console(uport))
 			ops->shutdown(uport);
@@ -2109,9 +2107,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 		break;
 	}
 
-	printk(KERN_INFO "%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
-	       port->dev ? dev_name(port->dev) : "",
-	       port->dev ? ": " : "",
+	dev_info(port->dev, "%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
 	       drv->dev_name,
 	       drv->tty_driver->name_base + port->line,
 	       address, port->irq, port->uartclk / 16, uart_type(port));
@@ -2640,7 +2636,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
-		printk(KERN_ERR "Cannot register tty device on line %d\n",
+		dev_err(uport->dev, "Cannot register tty device on line %d\n",
 		       uport->line);
 	}
 
@@ -2675,7 +2671,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	BUG_ON(in_interrupt());
 
 	if (state->uart_port != uport)
-		printk(KERN_ALERT "Removing wrong port: %p != %p\n",
+		dev_alert(uport->dev, "Removing wrong port: %p != %p\n",
 			state->uart_port, uport);
 
 	mutex_lock(&port_mutex);
-- 
1.8.1.2

