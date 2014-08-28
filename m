Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920AbaH1OPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:15:47 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57571 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaH1OPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:15:45 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] serial: serial_core.c: printk replacement
Date: Thu, 28 Aug 2014 19:45:28 +0530
Message-Id: <1409235328-24648-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk replaced with corresponding pr_err, dev_alert, dev_notice and pr_info.
fixed two broken user-visible strings used by the corresponding printk

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

In the first patch i sent Greg suggested to use dev_err instead of pr_err , but as later Jiri pointed out in my later patches that uport->dev is having a null check so can not be used , tty_dev is also having a put_device , so back to pr_err. 

 drivers/tty/serial/serial_core.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 29a7be4..0e03c31 100644
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
+			pr_err("%s%s%s%d: Unable to drain transmitter\n",
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

