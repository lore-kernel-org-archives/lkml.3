Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbaKTJDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069AbaKTJD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:03:26 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH net V5] virtio-net: validate features during probe
Date: Thu, 20 Nov 2014 17:03:05 +0800
Message-Id: <1416474185-10981-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently trigger BUG when VIRTIO_NET_F_CTRL_VQ
is not set but one of features depending on it is.
That's not a friendly way to report errors to
hypervisors.
Let's check, and fail probe instead.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- Drop NETIF_F_*_UFO from checklist
Changes from V2:
- only check the features for ctrl vq (this fix the real bug)
- better error message and simplify API
Changes from V3:
- pass dbit directly and even better error message
- typo fix
Changes from v4:
- add "device" before "advertise"
---
 drivers/net/virtio_net.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ec2a8b4..b0bc8ea 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1673,6 +1673,40 @@ static const struct attribute_group virtio_net_mrg_rx_group = {
 };
 #endif
 
+static bool virtnet_fail_on_feature(struct virtio_device *vdev,
+				    unsigned int fbit,
+				    const char *fname, const char *dname)
+{
+	if (!virtio_has_feature(vdev, fbit))
+		return false;
+
+	dev_err(&vdev->dev, "device advertises feature %s but not %s",
+		fname, dname);
+
+	return true;
+}
+
+#define VIRTNET_FAIL_ON(vdev, fbit, dbit)			\
+	virtnet_fail_on_feature(vdev, fbit, #fbit, dbit)
+
+static bool virtnet_validate_features(struct virtio_device *vdev)
+{
+	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ) &&
+	    (VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_RX,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_VLAN,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_GUEST_ANNOUNCE,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
+			     "VIRTIO_NET_F_CTRL_VQ"))) {
+		return false;
+	}
+
+	return true;
+}
+
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int i, err;
@@ -1680,6 +1714,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 	struct virtnet_info *vi;
 	u16 max_queue_pairs;
 
+	if (!virtnet_validate_features(vdev))
+		return -EINVAL;
+
 	/* Find if host supports multiqueue virtio_net device */
 	err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
 				   struct virtio_net_config,
-- 
1.9.1

