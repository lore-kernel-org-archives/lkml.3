Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbbAYTJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:09:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbbAYSJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.14 65/98] USB: console: fix potential use after free
Date: Sun, 25 Jan 2015 10:07:23 -0800
Message-Id: <20150125180715.672695800@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 32a4bf2e81ec378e5925d4e069e0677a6c86a6ad upstream.

Use tty kref to release the fake tty in usb_console_setup to avoid use
after free if the underlying serial driver has acquired a reference.

Note that using the tty destructor release_one_tty requires some more
state to be initialised.

Fixes: 4a90f09b20f4 ("tty: usb-serial krefs")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/console.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -46,6 +46,8 @@ static struct console usbcons;
  * ------------------------------------------------------------
  */
 
+static const struct tty_operations usb_console_fake_tty_ops = {
+};
 
 /*
  * The parsing of the command line works exactly like the
@@ -137,14 +139,17 @@ static int usb_console_setup(struct cons
 				goto reset_open_count;
 			}
 			kref_init(&tty->kref);
-			tty_port_tty_set(&port->port, tty);
 			tty->driver = usb_serial_tty_driver;
 			tty->index = co->index;
 			init_ldsem(&tty->ldisc_sem);
+			INIT_LIST_HEAD(&tty->tty_files);
+			kref_get(&tty->driver->kref);
+			tty->ops = &usb_console_fake_tty_ops;
 			if (tty_init_termios(tty)) {
 				retval = -ENOMEM;
-				goto free_tty;
+				goto put_tty;
 			}
+			tty_port_tty_set(&port->port, tty);
 		}
 
 		/* only call the device specific open if this
@@ -162,7 +167,7 @@ static int usb_console_setup(struct cons
 			serial->type->set_termios(tty, port, &dummy);
 
 			tty_port_tty_set(&port->port, NULL);
-			kfree(tty);
+			tty_kref_put(tty);
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 	}
@@ -178,8 +183,8 @@ static int usb_console_setup(struct cons
 
  fail:
 	tty_port_tty_set(&port->port, NULL);
- free_tty:
-	kfree(tty);
+ put_tty:
+	tty_kref_put(tty);
  reset_open_count:
 	port->port.count = 0;
 	usb_autopm_put_interface(serial->interface);


