Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbbAUPFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:05:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228AbbAUPFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:05:34 -0500
Date: Wed, 21 Jan 2015 17:05:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH post-squash 6/9] virtio_pci_modern: support devices with no
 config
Message-ID: <1421852670-23742-7-git-send-email-mst@redhat.com>
References: <1421852670-23742-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421852670-23742-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtio 1.0 spec lists device config as optional.
Set get/set callbacks to NULL. Drivers can check that
and fail gracefully.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/virtio/virtio_pci_modern.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 0e54cc8..68ebc20 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -422,6 +422,21 @@ static void del_vq(struct virtio_pci_vq_info *info)
 	free_pages_exact(info->queue, vring_pci_size(info->num));
 }
 
+static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
+	.get		= NULL,
+	.set		= NULL,
+	.generation	= vp_generation,
+	.get_status	= vp_get_status,
+	.set_status	= vp_set_status,
+	.reset		= vp_reset,
+	.find_vqs	= vp_modern_find_vqs,
+	.del_vqs	= vp_del_vqs,
+	.get_features	= vp_get_features,
+	.finalize_features = vp_finalize_features,
+	.bus_name	= vp_bus_name,
+	.set_vq_affinity = vp_set_vq_affinity,
+};
+
 static const struct virtio_config_ops virtio_pci_config_ops = {
 	.get		= vp_get,
 	.set		= vp_set,
@@ -652,9 +667,11 @@ int virtio_pci_modern_probe(struct virtio_pci_device *vp_dev)
 						&vp_dev->device_len);
 		if (!vp_dev->device)
 			goto err_map_device;
-	}
 
-	vp_dev->vdev.config = &virtio_pci_config_ops;
+		vp_dev->vdev.config = &virtio_pci_config_ops;
+	} else {
+		vp_dev->vdev.config = &virtio_pci_config_nodev_ops;
+	}
 
 	vp_dev->config_vector = vp_config_vector;
 	vp_dev->setup_vq = setup_vq;
-- 
MST

