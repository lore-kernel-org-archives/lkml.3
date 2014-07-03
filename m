Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaGCJ1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:27:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795AbaGCJZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 192/198] USB: serial: fix potential runtime pm imbalance at device remove
Date: Thu,  3 Jul 2014 10:20:35 +0100
Message-Id: <1404379241-8590-193-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/bus.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/bus.c b/drivers/usb/serial/bus.c
index f053b302a00d..eef55b53c0b5 100644
--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -98,13 +98,19 @@ static int usb_serial_device_remove(struct device *dev)
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
@@ -118,7 +124,9 @@ static int usb_serial_device_remove(struct device *dev)
 	dev_info(dev, "%s converter now disconnected from ttyUSB%d\n",
 		 driver->description, minor);
 
-	usb_autopm_put_interface(port->serial->interface);
+	if (!autopm_err)
+		usb_autopm_put_interface(port->serial->interface);
+
 	return retval;
 }
 
-- 
1.9.1

