Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbbA2JCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:02:49 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44781 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754198AbbA2JCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:45 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 113/176] USB: console: fix potential use after free
Date: Wed, 28 Jan 2015 15:29:03 +0100
Message-Id: <eff21557db1aa3a80dcfb3d760c5132f29b4dfa8.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 32a4bf2e81ec378e5925d4e069e0677a6c86a6ad upstream.

Use tty kref to release the fake tty in usb_console_setup to avoid use
after free if the underlying serial driver has acquired a reference.

Note that using the tty destructor release_one_tty requires some more
state to be initialised.

Fixes: 4a90f09b20f4 ("tty: usb-serial krefs")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/console.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 3cf2de433eb8..e4ce48cf7a64 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -47,6 +47,8 @@ static struct console usbcons;
  * ------------------------------------------------------------
  */
 
+static const struct tty_operations usb_console_fake_tty_ops = {
+};
 
 /*
  * The parsing of the command line works exactly like the
@@ -139,15 +141,18 @@ static int usb_console_setup(struct console *co, char *options)
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
 				dev_err(&port->dev, "no more memory\n");
-				goto free_tty;
+				goto put_tty;
 			}
+			tty_port_tty_set(&port->port, tty);
 		}
 
 		/* only call the device specific open if this
@@ -165,7 +170,7 @@ static int usb_console_setup(struct console *co, char *options)
 			serial->type->set_termios(tty, port, &dummy);
 
 			tty_port_tty_set(&port->port, NULL);
-			kfree(tty);
+			tty_kref_put(tty);
 		}
 		set_bit(ASYNCB_INITIALIZED, &port->port.flags);
 	}
@@ -181,8 +186,8 @@ static int usb_console_setup(struct console *co, char *options)
 
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
2.2.2

