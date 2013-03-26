Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab3CZPXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965188Ab3CZPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 097/150] USB: serial: fix interface refcounting
Date: Tue, 26 Mar 2013 15:19:56 +0000
Message-Id: <1364311249-14454-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d7971051e4df825e0bc11b995e87bfe86355b8e5 upstream.

Make sure the interface is not released before our serial device.

Note that drivers are still not allowed to access the interface in
any way that may interfere with another driver that may have gotten
bound to the same interface after disconnect returns.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/usb-serial.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 771adbd..2418551 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -157,6 +157,7 @@ static void destroy_serial(struct kref *kref)
 		}
 	}
 
+	usb_put_intf(serial->interface);
 	usb_put_dev(serial->dev);
 	kfree(serial);
 }
@@ -614,7 +615,7 @@ static struct usb_serial *create_serial(struct usb_device *dev,
 	}
 	serial->dev = usb_get_dev(dev);
 	serial->type = driver;
-	serial->interface = interface;
+	serial->interface = usb_get_intf(interface);
 	kref_init(&serial->kref);
 	mutex_init(&serial->disc_mutex);
 	serial->minor = SERIAL_TTY_NO_MINOR;
-- 
1.8.1.2

