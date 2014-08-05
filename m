Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaHEMgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:36:20 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40315 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaHEMgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:36:19 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty: serial: serial_core.c: printk replacement
Date: Tue,  5 Aug 2014 18:05:45 +0530
Message-Id: <1407242145-3132-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk replaced with corresponding dev_err, dev_alert, dev_notice and pr_info.
pr_info has been used instead of dev_info as there is a check for port->dev being NULL or not.
fixed two broken user-visible strings used by the corresponding printk

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---

For my previous patch ,Jiri Slaby told to investigate further as I have used uport->dev and there was a check for whether it is NULL. 
For this patch instead of uport->dev , i have used tty_dev as that one gave a better desciption of the device than uport->dev.


 drivers/tty/serial/serial_core.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 29a7be4..78aa38d 100644
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
@@ -1975,12 +1976,11 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 		for (tries = 3; !ops->tx_empty(uport) && tries; tries--)
 			msleep(10);
 		if (!tries)
-			printk(KERN_ERR "%s%s%s%d: Unable to drain "
-					"transmitter\n",
-			       uport->dev ? dev_name(uport->dev) : "",
-			       uport->dev ? ": " : "",
-			       drv->dev_name,
-			       drv->tty_driver->name_base + uport->line);
+			dev_err(tty_dev, "%s%s%s%d: Unable to drain transmitter\n",
+				uport->dev ? dev_name(uport->dev) : "",
+				uport->dev ? ": " : "",
+				drv->dev_name,
+				drv->tty_driver->name_base + uport->line);
 
 		if (console_suspend_enabled || !uart_console(uport))
 			ops->shutdown(uport);
@@ -2109,7 +2109,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 		break;
 	}
 
-	printk(KERN_INFO "%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
+	pr_info("%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
 	       port->dev ? dev_name(port->dev) : "",
 	       port->dev ? ": " : "",
 	       drv->dev_name,
@@ -2640,7 +2640,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
-		printk(KERN_ERR "Cannot register tty device on line %d\n",
+		dev_err(uport->dev, "Cannot register tty device on line %d\n",
 		       uport->line);
 	}
 
@@ -2675,7 +2675,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	BUG_ON(in_interrupt());
 
 	if (state->uart_port != uport)
-		printk(KERN_ALERT "Removing wrong port: %p != %p\n",
+		dev_alert(uport->dev, "Removing wrong port: %p != %p\n",
 			state->uart_port, uport);
 
 	mutex_lock(&port_mutex);
-- 
1.8.1.2

