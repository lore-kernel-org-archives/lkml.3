Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaJFPKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:10:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbaJFPHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:07:47 -0400
Date: Mon, 6 Oct 2014 18:11:16 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 10/15] virtio: add API to enable VQs early
Message-ID: <1412608214-31944-11-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412608214-31944-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio spec 0.9.X requires DRIVER_OK to be set before
VQs are used, but some drivers use VQs before probe
function returns.
Since DRIVER_OK is set after probe, this violates the spec.

Even though under virtio 1.0 transitional devices support this
behaviour, we want to make it possible for those early callers to become
spec compliant and eventually support non-transitional devices.

Add API for drivers to call before using VQs.

Sets DRIVER_OK internally.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_config.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index e8f8f71..e36403b 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -109,6 +109,23 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
 	return vq;
 }
 
+/**
+ * virtio_enable_vqs_early - enable vq use in probe function
+ * @vdev: the device
+ *
+ * Driver must call this to use vqs in the probe function.
+ *
+ * Note: vqs are enabled automatically after probe returns.
+ */
+static inline
+void virtio_enable_vqs_early(struct virtio_device *dev)
+{
+	unsigned status = dev->config->get_status(dev);
+
+	BUG_ON(status & VIRTIO_CONFIG_S_DRIVER_OK);
+	dev->config->set_status(dev, status | VIRTIO_CONFIG_S_DRIVER_OK);
+}
+
 static inline
 const char *virtio_bus_name(struct virtio_device *vdev)
 {
-- 
MST

