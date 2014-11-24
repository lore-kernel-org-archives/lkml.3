Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaKXLxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:53:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbaKXLxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:53:33 -0500
Date: Mon, 24 Nov 2014 13:53:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 09/41] virtio: simplify feature bit handling
Message-ID: <1416829787-14252-10-git-send-email-mst@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416829787-14252-1-git-send-email-mst@redhat.com>
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
index a3df817..0f44cff 100644
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
-			dev->features |= (1ULL << f);
+		driver_features |= (1ULL << f);
 	}
 
+	dev->features = driver_features & device_features;
+
 	/* Transport features always preserved to pass to finalize_features. */
 	for (i = VIRTIO_TRANSPORT_F_START; i < VIRTIO_TRANSPORT_F_END; i++)
 		if (device_features & (1ULL << i))
-- 
MST

