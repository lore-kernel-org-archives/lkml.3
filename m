Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaB0NZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:25:52 -0500
Received: from mout.gmx.net ([212.227.17.22]:60786 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaB0NZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:25:51 -0500
From: xypron.glpk@gmx.de
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Memory leak in usbip_exported_device_new
Date: Thu, 27 Feb 2014 14:25:19 +0100
Message-Id: <1393507520-10040-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:rYcq386rUUx9a4bqwuXa1IJ8jVOFNqEECNjl3ObGjMTa+iO5nZk
 kPbs/9HD1RYCk+DN95JZkUc8jTx8zC6G5yA1FhBpWbEKRR8GW4WuPdvIgLsDnHMkCT8ietg
 OPmdw8lUp7v34Zzi+szFMn9tVXlMokRZFXbP+SU2zVC27n0kr8XgpxKqmw+9RL1xu9wFKnC
 tSlIgu18E9DSlImhhpsKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

Memory was leaked and a device not closed.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index 71a449c..6a92f0f 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -102,6 +102,7 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
 {
 	struct usbip_exported_device *edev = NULL;
+	struct usbip_exported_device *edev_old;
 	size_t size;
 	int i;
 
@@ -127,8 +128,10 @@ static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
 	size = sizeof(*edev) + edev->udev.bNumInterfaces *
 		sizeof(struct usbip_usb_interface);
 
+	edev_old = edev;
 	edev = realloc(edev, size);
 	if (!edev) {
+		edev = edev_old;
 		dbg("realloc failed");
 		goto err;
 	}
-- 
1.7.10.4

