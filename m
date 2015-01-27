Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbbA0MZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:25:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549AbbA0MTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 108/126] USB: console: fix potential use after free
Date: Tue, 27 Jan 2015 12:16:53 +0000
Message-Id: <1422361031-19364-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 32a4bf2e81ec378e5925d4e069e0677a6c86a6ad upstream.

Use tty kref to release the fake tty in usb_console_setup to avoid use
after free if the underlying serial driver has acquired a reference.

Note that using the tty destructor release_one_tty requires some more
state to be initialised.

Fixes: 4a90f09b20f4 ("tty: usb-serial krefs")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/console.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index e56f394b58d8..29fa1c3d0089 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -46,6 +46,8 @@ static struct console usbcons;
  * ------------------------------------------------------------
  */
 
+static const struct tty_operations usb_console_fake_tty_ops = {
+};
 
 /*
  * The parsing of the command line works exactly like the
@@ -137,14 +139,17 @@ static int usb_console_setup(struct console *co, char *options)
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
@@ -162,7 +167,7 @@ static int usb_console_setup(struct console *co, char *options)
 			serial->type->set_termios(tty, port, &dummy);
 
 			tty_port_tty_set(&port->port, NULL);
-			kfree(tty);
+			tty_kref_put(tty);
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 	}
@@ -178,8 +183,8 @@ static int usb_console_setup(struct console *co, char *options)
 
  fail:
 	tty_port_tty_set(&port->port, NULL);
- free_tty:
-	kfree(tty);
+ put_tty:
+	tty_kref_put(tty);
  reset_open_count:
 	port->port.count = 0;
 	usb_autopm_put_interface(serial->interface);
-- 
2.1.4

