Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3CZX2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:28:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab3CZWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 88/98] USB: serial: fix interface refcounting
Date: Tue, 26 Mar 2013 15:43:17 -0700
Message-Id: <20130326224251.596262751@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d7971051e4df825e0bc11b995e87bfe86355b8e5 upstream.

Make sure the interface is not released before our serial device.

Note that drivers are still not allowed to access the interface in
any way that may interfere with another driver that may have gotten
bound to the same interface after disconnect returns.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -151,6 +151,7 @@ static void destroy_serial(struct kref *
 		}
 	}
 
+	usb_put_intf(serial->interface);
 	usb_put_dev(serial->dev);
 	kfree(serial);
 }
@@ -614,7 +615,7 @@ static struct usb_serial *create_serial(
 	}
 	serial->dev = usb_get_dev(dev);
 	serial->type = driver;
-	serial->interface = interface;
+	serial->interface = usb_get_intf(interface);
 	kref_init(&serial->kref);
 	mutex_init(&serial->disc_mutex);
 	serial->minor = SERIAL_TTY_NO_MINOR;


