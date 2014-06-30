Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaF3MhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:37:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbaF3Mbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 138/181] USB: serial: fix potential runtime pm imbalance at device remove
Date: Mon, 30 Jun 2014 13:52:39 +0200
Message-Id: <b66a52fd34a39404eccbf8048cb137167767f859.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c14829fad88dbeda57253590695b85ba51270621 upstream.

Only call usb_autopm_put_interface() if the corresponding
usb_autopm_get_interface() was successful.

This prevents a potential runtime PM counter imbalance should
usb_autopm_get_interface() fail. Note that the USB PM usage counter is
reset when the interface is unbound, but that the runtime PM counter may
be left unbalanced.

Also add comment on why we don't need to worry about racing
resume/suspend on autopm_get failures.

Fixes: d5fd650cfc7f ("usb: serial: prevent suspend/resume from racing
against probe/remove")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/bus.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/bus.c b/drivers/usb/serial/bus.c
index 6335490d5760..74fc63b2e7fc 100644
--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -97,13 +97,19 @@ static int usb_serial_device_remove(struct device *dev)
 	struct usb_serial_port *port;
 	int retval = 0;
 	int minor;
+	int autopm_err;
 
 	port = to_usb_serial_port(dev);
 	if (!port)
 		return -ENODEV;
 
-	/* make sure suspend/resume doesn't race against port_remove */
-	usb_autopm_get_interface(port->serial->interface);
+	/*
+	 * Make sure suspend/resume doesn't race against port_remove.
+	 *
+	 * Note that no further runtime PM callbacks will be made if
+	 * autopm_get fails.
+	 */
+	autopm_err = usb_autopm_get_interface(port->serial->interface);
 
 	minor = port->minor;
 	tty_unregister_device(usb_serial_tty_driver, minor);
@@ -117,7 +123,9 @@ static int usb_serial_device_remove(struct device *dev)
 	dev_info(dev, "%s converter now disconnected from ttyUSB%d\n",
 		 driver->description, minor);
 
-	usb_autopm_put_interface(port->serial->interface);
+	if (!autopm_err)
+		usb_autopm_put_interface(port->serial->interface);
+
 	return retval;
 }
 
-- 
2.0.0

