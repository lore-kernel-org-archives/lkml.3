Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3CYBdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:33:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33916 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab3CYBPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:38 -0400
Message-Id: <20130325010532.502038825@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 083/104] USB: serial: fix interface refcounting
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d7971051e4df825e0bc11b995e87bfe86355b8e5 upstream.

Make sure the interface is not released before our serial device.

Note that drivers are still not allowed to access the interface in
any way that may interfere with another driver that may have gotten
bound to the same interface after disconnect returns.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb-serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -168,6 +168,7 @@ static void destroy_serial(struct kref *
 		}
 	}
 
+	usb_put_intf(serial->interface);
 	usb_put_dev(serial->dev);
 	kfree(serial);
 }
@@ -624,7 +625,7 @@ static struct usb_serial *create_serial(
 	}
 	serial->dev = usb_get_dev(dev);
 	serial->type = driver;
-	serial->interface = interface;
+	serial->interface = usb_get_intf(interface);
 	kref_init(&serial->kref);
 	mutex_init(&serial->disc_mutex);
 	serial->minor = SERIAL_TTY_NO_MINOR;


