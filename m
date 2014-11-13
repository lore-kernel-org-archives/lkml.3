Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaKMFxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 00:53:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaKMFxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 00:53:05 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH 1/2] virito: introduce methods of fixing device features
Date: Thu, 13 Nov 2014 13:52:53 +0800
Message-Id: <1415857974-23326-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buggy host may advertised buggy host features (a usual case is that host
advertise a feature whose dependencies were missed). In this case, driver
should detect and disable the buggy features by itself.

This patch introduces driver specific fix_features() method which is called
just before features finalizing to detect and disable buggy features
advertised by host.

Virtio-net will be the first user.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio.c       |  4 ++++
 include/linux/virtio.h        |  1 +
 include/linux/virtio_config.h | 12 ++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index df598dd..7001d6e 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -181,6 +181,10 @@ static int virtio_dev_probe(struct device *_d)
 		if (device_features & (1 << i))
 			set_bit(i, dev->features);
 
+	/* Fix buggy features advertised by host */
+	if (drv->fix_features)
+		drv->fix_features(dev);
+
 	dev->config->finalize_features(dev);
 
 	err = drv->probe(dev);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 65261a7..9d01b54 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -142,6 +142,7 @@ struct virtio_driver {
 	void (*scan)(struct virtio_device *dev);
 	void (*remove)(struct virtio_device *dev);
 	void (*config_changed)(struct virtio_device *dev);
+	void (*fix_features)(struct virtio_device *dev);
 #ifdef CONFIG_PM
 	int (*freeze)(struct virtio_device *dev);
 	int (*restore)(struct virtio_device *dev);
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 7f4ef66..7bd89ea 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -96,6 +96,18 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 	return test_bit(fbit, vdev->features);
 }
 
+static inline void virtio_disable_feature(struct virtio_device *vdev,
+                                          unsigned int fbit)
+{
+	BUG_ON(fbit >= VIRTIO_TRANSPORT_F_START);
+	BUG_ON(vdev->config->get_status(vdev) &
+	       ~(VIRTIO_CONFIG_S_ACKNOWLEDGE | VIRTIO_CONFIG_S_DRIVER));
+
+	virtio_check_driver_offered_feature(vdev, fbit);
+
+	clear_bit(fbit, vdev->features);
+}
+
 static inline
 struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
 					vq_callback_t *c, const char *n)
-- 
1.9.1

