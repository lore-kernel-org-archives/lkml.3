Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaK3PKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 10:10:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbaK3PKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 10:10:40 -0500
Date: Sun, 30 Nov 2014 17:10:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v7 13/46] virtio: simplify feature bit handling
Message-ID: <1417359787-10138-14-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417359787-10138-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we use u64 for bits, we can simply & them together.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 9248125..3e78f4b 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -160,6 +160,7 @@ static int virtio_dev_probe(struct device *_d)
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 	u64 device_features;
+	u64 driver_features;
 	unsigned status;
 
 	/* We have a driver! */
@@ -168,15 +169,16 @@ static int virtio_dev_probe(struct device *_d)
 	/* Figure out what features the device supports. */
 	device_features = dev->config->get_features(dev);
 
-	/* Features supported by both device and driver into dev->features. */
-	dev->features = 0;
+	/* Figure out what features the driver supports. */
+	driver_features = 0;
 	for (i = 0; i < drv->feature_table_size; i++) {
 		unsigned int f = drv->feature_table[i];
 		BUG_ON(f >= 64);
-		if (device_features & (1ULL << f))
-			__virtio_set_bit(dev, f);
+		driver_features |= (1ULL << f);
 	}
 
+	dev->features = driver_features & device_features;
+
 	/* Transport features always preserved to pass to finalize_features. */
 	for (i = VIRTIO_TRANSPORT_F_START; i < VIRTIO_TRANSPORT_F_END; i++)
 		if (device_features & (1ULL << i))
-- 
MST

