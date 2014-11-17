Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaKQJRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:17:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbaKQJRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:17:46 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V3 2/2] virtio-net: sanitize buggy features advertised by host
Date: Mon, 17 Nov 2014 17:17:18 +0800
Message-Id: <1416215838-21700-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1416215838-21700-1-git-send-email-jasowang@redhat.com>
References: <1416215838-21700-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to detect the possible buggy features advertised by host
and sanitize them. One example is booting virtio-net with only ctrl_vq
disabled, qemu may still advertise many features which depends on it. This
will trigger several BUG()s in virtnet_send_command().

This patch utilizes the sanitize_features() method, and disables all
features that depends on ctrl_vq if it was not advertised.

This fixes the crash when booting with ctrl_vq=off using qemu.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- fix the cut-and-paste error
Changes from V2:
- loop through an array of feature bits
- switch to use dev_warn()
---
 drivers/net/virtio_net.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ec2a8b4..6fadd8c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1948,6 +1948,31 @@ static int virtnet_restore(struct virtio_device *vdev)
 }
 #endif
 
+static void virtnet_sanitize_features(struct virtio_device *dev)
+{
+	unsigned int features_for_ctrl_vq[] = {
+		VIRTIO_NET_F_CTRL_RX,
+		VIRTIO_NET_F_CTRL_VLAN,
+		VIRTIO_NET_F_GUEST_ANNOUNCE,
+		VIRTIO_NET_F_MQ,
+		VIRTIO_NET_F_CTRL_MAC_ADDR
+	};
+	int i;
+
+	if (!virtio_has_feature(dev, VIRTIO_NET_F_CTRL_VQ)) {
+		for (i = 0; i < ARRAY_SIZE(features_for_ctrl_vq); i++) {
+			unsigned int f = features_for_ctrl_vq[i];
+			if (virtio_has_feature(dev, f)) {
+				virtio_disable_feature(dev, f);
+				dev_warn(&dev->dev,
+					 "buggy hyperviser: disable feature "
+					 "0x%x since VIRTIO_NET_F_CTRL_VQ was "
+					 "not advertised.\n", f);
+			}
+		}
+	}
+}
+
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -1975,6 +2000,7 @@ static struct virtio_driver virtio_net_driver = {
 	.probe =	virtnet_probe,
 	.remove =	virtnet_remove,
 	.config_changed = virtnet_config_changed,
+	.sanitize_features = virtnet_sanitize_features,
 #ifdef CONFIG_PM_SLEEP
 	.freeze =	virtnet_freeze,
 	.restore =	virtnet_restore,
-- 
1.9.1

