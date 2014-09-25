Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaIYOpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:45:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:31554 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbaIYOnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:43:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,597,1406617200"; 
   d="scan'208";a="578908390"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v3 1/3] mfd: viperboard: allocate I/O buffer separately
Date: Thu, 25 Sep 2014 17:43:15 +0300
Message-Id: <1411656197-26517-2-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
References: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the I/O buffer is allocated part of the device status
structure, potentially sharing the same cache line with other members
in this structure.

Allocate the buffer separately, to avoid the I/O operations corrupting
the device status structure due to cache line sharing.

Compiled tested only as I don't have access to hardware.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/viperboard.c       | 8 ++++++++
 include/linux/mfd/viperboard.h | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index e00f534..5f62f4e 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -64,6 +64,12 @@ static int vprbrd_probe(struct usb_interface *interface,
 		return -ENOMEM;
 	}
 
+	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
+	if (vb->buf == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	mutex_init(&vb->lock);
 
 	vb->usb_dev = usb_get_dev(interface_to_usbdev(interface));
@@ -105,6 +111,7 @@ static int vprbrd_probe(struct usb_interface *interface,
 error:
 	if (vb) {
 		usb_put_dev(vb->usb_dev);
+		kfree(vb->buf);
 		kfree(vb);
 	}
 
@@ -118,6 +125,7 @@ static void vprbrd_disconnect(struct usb_interface *interface)
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

