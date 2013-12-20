Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3LTTRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:17:52 -0500
Received: from mail.ispras.ru ([83.149.199.45]:35463 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab3LTTRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:17:48 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] go7007-loader: fix usb_dev leak
Date: Fri, 20 Dec 2013 23:17:32 +0400
Message-Id: <1387567052-23938-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is usb_get_dev() in go7007_loader_probe(),
but there is no usb_put_dev() anywhere.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/media/go7007/go7007-loader.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007-loader.c b/drivers/staging/media/go7007/go7007-loader.c
index f846ad5819dc..2b15952e4c18 100644
--- a/drivers/staging/media/go7007/go7007-loader.c
+++ b/drivers/staging/media/go7007/go7007-loader.c
@@ -60,7 +60,7 @@ static int go7007_loader_probe(struct usb_interface *interface,
 
 	if (usbdev->descriptor.bNumConfigurations != 1) {
 		dev_err(&interface->dev, "can't handle multiple config\n");
-		return -ENODEV;
+		goto failed2;
 	}
 
 	vendor = le16_to_cpu(usbdev->descriptor.idVendor);
@@ -109,6 +109,7 @@ static int go7007_loader_probe(struct usb_interface *interface,
 	return 0;
 
 failed2:
+	usb_put_dev(usbdev);
 	dev_err(&interface->dev, "probe failed\n");
 	return -ENODEV;
 }
@@ -116,6 +117,7 @@ failed2:
 static void go7007_loader_disconnect(struct usb_interface *interface)
 {
 	dev_info(&interface->dev, "disconnect\n");
+	usb_put_dev(interface_to_usbdev(interface));
 	usb_set_intfdata(interface, NULL);
 }
 
-- 
1.8.3.2

