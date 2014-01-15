Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaAOCoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:44:54 -0500
Received: from ozlabs.org ([203.10.76.45]:45131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbaAOCmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 6/6] virtio: virtio_break_device() to mark all virtqueues broken.
Date: Wed, 15 Jan 2014 13:06:11 +1030
Message-Id: <1389753371-26469-6-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
References: <1389753371-26469-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good for post-apocalyptic scenarios, like S/390 hotplug.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_ring.c | 15 +++++++++++++++
 include/linux/virtio.h       |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index b74033dca384..a84350019f62 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -864,4 +864,19 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
+/*
+ * This should prevent the device from being used, allowing drivers to
+ * recover.  You may need to grab appropriate locks to flush.
+ */
+void virtio_break_device(struct virtio_device *dev)
+{
+	struct virtqueue *_vq;
+
+	list_for_each_entry(_vq, &dev->vqs, list) {
+		struct vring_virtqueue *vq = to_vvq(_vq);
+		vq->broken = true;
+	}
+}
+EXPORT_SYMBOL_GPL(virtio_break_device);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index e4abb84199be..b46671e28de2 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -106,6 +106,8 @@ static inline struct virtio_device *dev_to_virtio(struct device *_dev)
 int register_virtio_device(struct virtio_device *dev);
 void unregister_virtio_device(struct virtio_device *dev);
 
+void virtio_break_device(struct virtio_device *dev);
+
 /**
  * virtio_driver - operations for a virtio I/O driver
  * @driver: underlying device driver (populate name and owner).
-- 
1.8.3.2

