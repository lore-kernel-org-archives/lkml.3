Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaF1TGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:06:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbaF1Rsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 40/77] USB: serial: fix potential runtime pm imbalance at device remove
Date: Sat, 28 Jun 2014 10:46:33 -0700
Message-Id: <20140628174523.624033956@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/bus.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -98,13 +98,19 @@ static int usb_serial_device_remove(stru
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
 
 	minor = port->number;
 	tty_unregister_device(usb_serial_tty_driver, minor);
@@ -118,7 +124,9 @@ static int usb_serial_device_remove(stru
 	dev_info(dev, "%s converter now disconnected from ttyUSB%d\n",
 		 driver->description, minor);
 
-	usb_autopm_put_interface(port->serial->interface);
+	if (!autopm_err)
+		usb_autopm_put_interface(port->serial->interface);
+
 	return retval;
 }
 


