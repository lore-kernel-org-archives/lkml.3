Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353Ab3DDUlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:41:09 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36768 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760032Ab3DDUlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:41:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH] TTY: io_ti, stop dereferencing potential NULL
Date: Thu,  4 Apr 2013 22:41:01 +0200
Message-Id: <1365108061-5132-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_port_tty_get might return a tty which is NULL. But it is
dereferenced unconditionally in edge_send. Stop dereferencing that by
sending usb_serial_port pointer around.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Johan Hovold <jhovold@gmail.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/serial/io_ti.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 0ccc422..f2a1601 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -206,7 +206,7 @@ static int restart_read(struct edgeport_port *edge_port);
 
 static void edge_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
-static void edge_send(struct tty_struct *tty);
+static void edge_send(struct usb_serial_port *port, struct tty_struct *tty);
 
 /* sysfs attributes */
 static int edge_create_sysfs_attrs(struct usb_serial_port *port);
@@ -1712,7 +1712,7 @@ static void edge_bulk_out_callback(struct urb *urb)
 
 	/* send any buffered data */
 	tty = tty_port_tty_get(&port->port);
-	edge_send(tty);
+	edge_send(port, tty);
 	tty_kref_put(tty);
 }
 
@@ -1940,14 +1940,13 @@ static int edge_write(struct tty_struct *tty, struct usb_serial_port *port,
 
 	count = kfifo_in_locked(&edge_port->write_fifo, data, count,
 							&edge_port->ep_lock);
-	edge_send(tty);
+	edge_send(port, tty);
 
 	return count;
 }
 
-static void edge_send(struct tty_struct *tty)
+static void edge_send(struct usb_serial_port *port, struct tty_struct *tty)
 {
-	struct usb_serial_port *port = tty->driver_data;
 	int count, result;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned long flags;
-- 
1.8.2


