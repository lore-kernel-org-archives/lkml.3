Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaJWQX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbaJWQVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:21:22 -0400
Date: Thu, 23 Oct 2014 19:24:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC v4 11/17] virtio: add legacy feature table support
Message-ID: <1414081380-14623-12-git-send-email-mst@redhat.com>
References: <1414081380-14623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414081380-14623-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio blk has some legacy feature bits that modern drivers
must not negotiate, but are needed for old legacy hosts
(e.g. that dn't support virtio scsi).
Allow a separate legacy feature table for such cases.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h  |  4 ++++
 drivers/virtio/virtio.c | 18 +++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index d6359a5..f70411e 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -130,6 +130,8 @@ int virtio_device_restore(struct virtio_device *dev);
  * @id_table: the ids serviced by this driver.
  * @feature_table: an array of feature numbers supported by this driver.
  * @feature_table_size: number of entries in the feature table array.
+ * @feature_table_legacy: same as feature_table but when working in legacy mode.
+ * @feature_table_size_legacy: number of entries in feature table legacy array.
  * @probe: the function to call when a device is found.  Returns 0 or -errno.
  * @remove: the function to call when a device is removed.
  * @config_changed: optional function to call when the device configuration
@@ -140,6 +142,8 @@ struct virtio_driver {
 	const struct virtio_device_id *id_table;
 	const unsigned int *feature_table;
 	unsigned int feature_table_size;
+	const unsigned int *feature_table_legacy;
+	unsigned int feature_table_size_legacy;
 	int (*probe)(struct virtio_device *dev);
 	void (*scan)(struct virtio_device *dev);
 	void (*remove)(struct virtio_device *dev);
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 0f44cff..85a164e 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -161,6 +161,7 @@ static int virtio_dev_probe(struct device *_d)
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 	u64 device_features;
 	u64 driver_features;
+	u64 driver_features_legacy;
 	unsigned status;
 
 	/* We have a driver! */
@@ -177,7 +178,22 @@ static int virtio_dev_probe(struct device *_d)
 		driver_features |= (1ULL << f);
 	}
 
-	dev->features = driver_features & device_features;
+	/* Some drivers have a separate feature tables for virtio v1.0 */
+	if (drv->feature_table_legacy) {
+		driver_features_legacy = 0;
+		for (i = 0; i < drv->feature_table_size_legacy; i++) {
+			unsigned int f = drv->feature_table_legacy[i];
+			BUG_ON(f >= 64);
+			driver_features_legacy |= (1ULL << f);
+		}
+	} else {
+		driver_features_legacy = driver_features;
+	}
+
+	if (driver_features & device_features & (1ULL << VIRTIO_F_VERSION_1))
+		dev->features = driver_features & device_features;
+	else
+		dev->features = driver_features_legacy & device_features;
 
 	/* Transport features always preserved to pass to finalize_features. */
 	for (i = VIRTIO_TRANSPORT_F_START; i < VIRTIO_TRANSPORT_F_END; i++)
-- 
MST

