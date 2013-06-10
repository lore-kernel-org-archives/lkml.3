Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3FJVcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:32:45 -0400
Received: from mail.ispras.ru ([83.149.199.45]:42569 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab3FJVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:32:43 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] usbvision-video: fix memory leak of alt_max_pkt_size
Date: Tue, 11 Jun 2013 01:32:29 +0400
Message-Id: <1370899949-16987-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. usbvision->alt_max_pkt_size is not deallocated anywhere.
2. if allocation of usbvision->alt_max_pkt_size fails,
there is no proper deallocation of already acquired resources.

The patch adds kfree(usbvision->alt_max_pkt_size) to
usbvision_release() as soon as other deallocations happen there.
It calls usbvision_release() if allocation of
usbvision->alt_max_pkt_size fails as soon as usbvision_release()
is safe to work with incompletely initialized usbvision structure.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/usbvision/usbvision-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index d34c2af..443e783 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1459,6 +1459,7 @@ static void usbvision_release(struct usb_usbvision *usbvision)
 
 	usbvision_remove_sysfs(usbvision->vdev);
 	usbvision_unregister_video(usbvision);
+	kfree(usbvision->alt_max_pkt_size);
 
 	usb_free_urb(usbvision->ctrl_urb);
 
@@ -1574,6 +1575,7 @@ static int usbvision_probe(struct usb_interface *intf,
 	usbvision->alt_max_pkt_size = kmalloc(32 * usbvision->num_alt, GFP_KERNEL);
 	if (usbvision->alt_max_pkt_size == NULL) {
 		dev_err(&intf->dev, "usbvision: out of memory!\n");
+		usbvision_release(usbvision);
 		return -ENOMEM;
 	}
 
-- 
1.8.1.2

