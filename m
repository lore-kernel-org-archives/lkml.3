Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192AbaLKRBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:01:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589AbaLKRBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:01:43 -0500
Date: Thu, 11 Dec 2014 19:01:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.or,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/3] virtio: set VIRTIO_CONFIG_S_FEATURES_OK on restore
Message-ID: <1418317279-13915-2-git-send-email-mst@redhat.com>
References: <1418317279-13915-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418317279-13915-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio 1.0 devices require that drivers set VIRTIO_CONFIG_S_FEATURES_OK
after finalizing features.
virtio core missed doing this on restore, fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index f226658..b9f70df 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -162,6 +162,27 @@ static void virtio_config_enable(struct virtio_device *dev)
 	spin_unlock_irq(&dev->config_lock);
 }
 
+static int virtio_finalize_features(struct virtio_device *dev)
+{
+	int ret = dev->config->finalize_features(dev);
+	unsigned status;
+
+	if (ret)
+		return ret;
+
+	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
+		return 0;
+
+	add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
+	status = dev->config->get_status(dev);
+	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
+		dev_err(&dev->dev, "virtio: device refuses features: %x\n",
+			status);
+		return -ENODEV;
+	}
+	return 0;
+}
+
 static int virtio_dev_probe(struct device *_d)
 {
 	int err, i;
@@ -170,7 +191,6 @@ static int virtio_dev_probe(struct device *_d)
 	u64 device_features;
 	u64 driver_features;
 	u64 driver_features_legacy;
-	unsigned status;
 
 	/* We have a driver! */
 	add_status(dev, VIRTIO_CONFIG_S_DRIVER);
@@ -208,21 +228,10 @@ static int virtio_dev_probe(struct device *_d)
 		if (device_features & (1ULL << i))
 			__virtio_set_bit(dev, i);
 
-	err = dev->config->finalize_features(dev);
+	err = virtio_finalize_features(dev);
 	if (err)
 		goto err;
 
-	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
-		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
-		status = dev->config->get_status(dev);
-		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
-			dev_err(_d, "virtio: device refuses features: %x\n",
-			       status);
-			err = -ENODEV;
-			goto err;
-		}
-	}
-
 	err = drv->probe(dev);
 	if (err)
 		goto err;
@@ -372,7 +381,7 @@ int virtio_device_restore(struct virtio_device *dev)
 	/* We have a driver! */
 	add_status(dev, VIRTIO_CONFIG_S_DRIVER);
 
-	ret = dev->config->finalize_features(dev);
+	ret = virtio_finalize_features(dev);
 	if (ret)
 		goto err;
 
-- 
MST

