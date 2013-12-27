Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3L0VTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 16:19:17 -0500
Received: from mail.ispras.ru ([83.149.199.45]:59848 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab3L0VTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 16:19:15 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] as102: fix leaks at failure paths in as102_usb_probe()
Date: Sat, 28 Dec 2013 01:18:39 +0400
Message-Id: <1388179119-11606-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failure handling is incomplete in as102_usb_probe().
The patch implements proper resource deallocations.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/media/as102/as102_usb_drv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 9f275f020150..c1c6152d1ab4 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -419,15 +419,22 @@ static int as102_usb_probe(struct usb_interface *intf,
 	/* request buffer allocation for streaming */
 	ret = as102_alloc_usb_stream_buffer(as102_dev);
 	if (ret != 0)
-		goto failed;
+		goto failed_stream;
 
 	/* register dvb layer */
 	ret = as102_dvb_register(as102_dev);
+	if (ret != 0)
+		goto failed_dvb;
 
 	LEAVE();
 	return ret;
 
+failed_dvb:
+	as102_free_usb_stream_buffer(as102_dev);
+failed_stream:
+	usb_deregister_dev(intf, &as102_usb_class_driver);
 failed:
+	usb_put_dev(as102_dev->bus_adap.usb_dev);
 	usb_set_intfdata(intf, NULL);
 	kfree(as102_dev);
 	return ret;
-- 
1.8.3.2

