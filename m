Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaJVPvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbaJVPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:47:17 -0400
Date: Wed, 22 Oct 2014 18:50:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH RFC v2 09/16] virtio: set FEATURES_OK
Message-ID: <1413992894-22976-10-git-send-email-mst@redhat.com>
References: <1413992894-22976-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413992894-22976-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set FEATURES_OK as per virtio 1.0 spec

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_config.h |  2 ++
 drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index f3fe33a..a6d0cde 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -38,6 +38,8 @@
 #define VIRTIO_CONFIG_S_DRIVER		2
 /* Driver has used its parts of the config, and is happy */
 #define VIRTIO_CONFIG_S_DRIVER_OK	4
+/* Driver has finished configuring features */
+#define VIRTIO_CONFIG_S_FEATURES_OK	8
 /* We've given up on this device. */
 #define VIRTIO_CONFIG_S_FAILED		0x80
 
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index d213567..a3df817 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -160,6 +160,7 @@ static int virtio_dev_probe(struct device *_d)
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 	u64 device_features;
+	unsigned status;
 
 	/* We have a driver! */
 	add_status(dev, VIRTIO_CONFIG_S_DRIVER);
@@ -183,18 +184,32 @@ static int virtio_dev_probe(struct device *_d)
 
 	dev->config->finalize_features(dev);
 
+	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
+		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
+		status = dev->config->get_status(dev);
+		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
+			printk(KERN_ERR "virtio: device refuses features: %x\n",
+			       status);
+			err = -ENODEV;
+			goto err;
+		}
+	}
+
 	err = drv->probe(dev);
 	if (err)
-		add_status(dev, VIRTIO_CONFIG_S_FAILED);
-	else {
-		add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
-		if (drv->scan)
-			drv->scan(dev);
+		goto err;
 
-		virtio_config_enable(dev);
-	}
+	add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
+	if (drv->scan)
+		drv->scan(dev);
+
+	virtio_config_enable(dev);
 
+	return 0;
+err:
+	add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	return err;
+
 }
 
 static int virtio_dev_remove(struct device *_d)
-- 
MST

