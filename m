Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaIVOrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:47:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:20970 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbaIVOrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:47:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,571,1406617200"; 
   d="scan'208";a="479187570"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH] mfd: viperboard: allocate I/O buffer separately
Date: Mon, 22 Sep 2014 17:46:52 +0300
Message-Id: <1411397212-31625-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the I/O buffer is allocated part of the device status
structure, potentially sharing the same cache line with other members
in this structure.

Allocate the buffer separately, to avoid the I/O operations corrupting
the device status structure due to cache line sharing.

Compiled tested only, as I don't have access to hardware.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/viperboard.c       | 16 ++++++++++------
 include/linux/mfd/viperboard.h |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index e00f534..d27c131 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -59,9 +59,13 @@ static int vprbrd_probe(struct usb_interface *interface,
 
 	/* allocate memory for our device state and initialize it */
 	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
-	if (vb == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+	if (vb == NULL)
 		return -ENOMEM;
+
+	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
+	if (vb->buf == NULL) {
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	mutex_init(&vb->lock);
@@ -103,10 +107,9 @@ static int vprbrd_probe(struct usb_interface *interface,
 	return 0;
 
 error:
-	if (vb) {
-		usb_put_dev(vb->usb_dev);
-		kfree(vb);
-	}
+	usb_put_dev(vb->usb_dev);
+	kfree(vb->buf);
+	kfree(vb);
 
 	return ret;
 }
@@ -118,6 +121,7 @@ static void vprbrd_disconnect(struct usb_interface *interface)
 	mfd_remove_devices(&interface->dev);
 	usb_set_intfdata(interface, NULL);
 	usb_put_dev(vb->usb_dev);
+	kfree(vb->buf);
 	kfree(vb);
 
 	dev_dbg(&interface->dev, "disconnected\n");
diff --git a/include/linux/mfd/viperboard.h b/include/linux/mfd/viperboard.h
index 1934528..af928d0 100644
--- a/include/linux/mfd/viperboard.h
+++ b/include/linux/mfd/viperboard.h
@@ -103,7 +103,7 @@ struct vprbrd_i2c_addr_msg {
 struct vprbrd {
 	struct usb_device *usb_dev; /* the usb device for this device */
 	struct mutex lock;
-	u8 buf[sizeof(struct vprbrd_i2c_write_msg)];
+	u8 *buf;
 	struct platform_device pdev;
 };
 
-- 
1.9.1

