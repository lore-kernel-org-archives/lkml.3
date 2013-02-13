Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab3BMTBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:01:08 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60814 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756988Ab3BMTBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:01:06 -0500
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 14:01:06 EST
X-Sasl-enc: VGCRSm6Bpql5yZRBRYd/OtiN1I33QNb3xSzkaGk1qkGY 1360781407
From: "Emilio G. Cota" <cota@braap.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vme: add missing put_device() after device_register() fails
Date: Wed, 13 Feb 2013 13:47:54 -0500
Message-Id: <1360781274-14405-1-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Emilio G. Cota" <cota@braap.org>

put_device() must be called after device_register() fails,
since device_register() always initializes the refcount
on the device structure.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/vme/vme.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vme/vme.c b/drivers/vme/vme.c
index 95a9f71..5e6c7d7 100644
--- a/drivers/vme/vme.c
+++ b/drivers/vme/vme.c
@@ -1366,26 +1366,27 @@ static int __vme_register_driver_bus(struct vme_driver *drv,
 		err = device_register(&vdev->dev);
 		if (err)
 			goto err_reg;
 
 		if (vdev->dev.platform_data) {
 			list_add_tail(&vdev->drv_list, &drv->devices);
 			list_add_tail(&vdev->bridge_list, &bridge->devices);
 		} else
 			device_unregister(&vdev->dev);
 	}
 	return 0;
 
 err_reg:
+	put_device(&vdev->dev);
 	kfree(vdev);
 err_devalloc:
 	list_for_each_entry_safe(vdev, tmp, &drv->devices, drv_list) {
 		list_del(&vdev->drv_list);
 		list_del(&vdev->bridge_list);
 		device_unregister(&vdev->dev);
 	}
 	return err;
 }
 
 static int __vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
 {
 	struct vme_bridge *bridge;
-- 
1.7.9.5

