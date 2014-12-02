Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbaLBLo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:44:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724AbaLBLoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:44:24 -0500
Date: Tue, 2 Dec 2014 13:44:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>
Subject: [PATCH RFC 2/2] virtio_balloon: drop legacy_only
Message-ID: <1417520617-2135-2-git-send-email-mst@redhat.com>
References: <1417520617-2135-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417520617-2135-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

balloon is the only driver using legacy_only ATM.
It turns out, it's easier to just make balloon support virtio 1.0
endian-ness and drop the flag from core.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h          | 2 --
 drivers/virtio/virtio.c         | 4 ----
 drivers/virtio/virtio_balloon.c | 1 -
 3 files changed, 7 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 2bbf626..f70411e 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -132,7 +132,6 @@ int virtio_device_restore(struct virtio_device *dev);
  * @feature_table_size: number of entries in the feature table array.
  * @feature_table_legacy: same as feature_table but when working in legacy mode.
  * @feature_table_size_legacy: number of entries in feature table legacy array.
- * @legacy_only: driver does not support virtio 1.0.
  * @probe: the function to call when a device is found.  Returns 0 or -errno.
  * @remove: the function to call when a device is removed.
  * @config_changed: optional function to call when the device configuration
@@ -145,7 +144,6 @@ struct virtio_driver {
 	unsigned int feature_table_size;
 	const unsigned int *feature_table_legacy;
 	unsigned int feature_table_size_legacy;
-	bool legacy_only;
 	int (*probe)(struct virtio_device *dev);
 	void (*scan)(struct virtio_device *dev);
 	void (*remove)(struct virtio_device *dev);
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index fa6b75d..2e836d8 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -197,10 +197,6 @@ static int virtio_dev_probe(struct device *_d)
 		driver_features_legacy = driver_features;
 	}
 
-	/* Detect legacy-only drivers and disable VIRTIO_F_VERSION_1. */
-	if (drv->legacy_only)
-		device_features &= ~(1ULL << VIRTIO_F_VERSION_1);
-
 	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
 		dev->features = driver_features & device_features;
 	else
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 721e32f..fed3709 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -518,7 +518,6 @@ static unsigned int features[] = {
 };
 
 static struct virtio_driver virtio_balloon_driver = {
-	.legacy_only = true,
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
-- 
MST

