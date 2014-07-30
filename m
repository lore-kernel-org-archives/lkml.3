Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaG3OH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:07:58 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57163 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaG3OH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:07:56 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty: serial: serial_core.c: printk replacement
Date: Wed, 30 Jul 2014 19:37:16 +0530
Message-Id: <1406729236-19887-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <[PATCH] tty: serial: serial_core.c: printk replacement>
References: <[PATCH] tty: serial: serial_core.c: printk replacement>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


printk replaced with corresponding dev_* 
fixed two broken user-visible strings used by the corresponding printk


Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/tty/serial/serial_core.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 8bb19da..ef48d0f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -891,10 +891,10 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
 			 */
 			if (uport->flags & UPF_SPD_MASK) {
 				char buf[64];
-				printk(KERN_NOTICE
-				       "%s sets custom speed on %s. This "
-				       "is deprecated.\n", current->comm,
-				       tty_name(port->tty, buf));
+
+				dev_notice(uport->dev,
+				"%s sets custom speed on %s. This is deprecated.\n",
+				current->comm, tty_name(port->tty, buf));
 			}
 			uart_change_speed(tty, state, NULL);
 		}
@@ -1974,8 +1974,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 		for (tries = 3; !ops->tx_empty(uport) && tries; tries--)
 			msleep(10);
 		if (!tries)
-			printk(KERN_ERR "%s%s%s%d: Unable to drain "
-					"transmitter\n",
+			dev_err(uport->dev,
+				"%s%s%s%d: Unable to drain transmitter\n",
 			       uport->dev ? dev_name(uport->dev) : "",
 			       uport->dev ? ": " : "",
 			       drv->dev_name,
@@ -2108,7 +2108,8 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 		break;
 	}
 
-	printk(KERN_INFO "%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
+	dev_info(port->dev,
+		       "%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
 	       port->dev ? dev_name(port->dev) : "",
 	       port->dev ? ": " : "",
 	       drv->dev_name,
@@ -2637,7 +2638,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
-		printk(KERN_ERR "Cannot register tty device on line %d\n",
+		dev_err(uport->dev, "Cannot register tty device on line %d\n",
 		       uport->line);
 	}
 
@@ -2672,7 +2673,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	BUG_ON(in_interrupt());
 
 	if (state->uart_port != uport)
-		printk(KERN_ALERT "Removing wrong port: %p != %p\n",
+		dev_alert(uport->dev, "Removing wrong port: %p != %p\n",
 			state->uart_port, uport);
 
 	mutex_lock(&port_mutex);
-- 
1.8.1.2

build tested on x86_64 and arm (mini2440 board)
