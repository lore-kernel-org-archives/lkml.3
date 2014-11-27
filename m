Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaK0UH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:07:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbaK0UH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:07:57 -0500
Date: Thu, 27 Nov 2014 22:07:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v6 01/46] virtio: add low-level APIs for feature bits
Message-ID: <1417118789-18231-2-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417118789-18231-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add low level APIs to test/set/clear feature bits.
For use by transports, to make it easier to
write code independent of feature bit array format.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_config.h | 53 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 7f4ef66..249fcd6 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -77,11 +77,47 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
 					 unsigned int fbit);
 
 /**
- * virtio_has_feature - helper to determine if this device has this feature.
+ * __virtio_test_bit - helper to test feature bits. For use by transports.
+ *                     Devices should normally use virtio_has_feature,
+ *                     which includes more checks.
  * @vdev: the device
  * @fbit: the feature bit
  */
-static inline bool virtio_has_feature(const struct virtio_device *vdev,
+static inline bool __virtio_test_bit(const struct virtio_device *vdev,
+				     unsigned int fbit)
+{
+	/* Did you forget to fix assumptions on max features? */
+	if (__builtin_constant_p(fbit))
+		BUILD_BUG_ON(fbit >= 32);
+	else
+		BUG_ON(fbit >= 32);
+
+	return test_bit(fbit, vdev->features);
+}
+
+/**
+ * __virtio_set_bit - helper to set feature bits. For use by transports.
+ * @vdev: the device
+ * @fbit: the feature bit
+ */
+static inline void __virtio_set_bit(struct virtio_device *vdev,
+				    unsigned int fbit)
+{
+	/* Did you forget to fix assumptions on max features? */
+	if (__builtin_constant_p(fbit))
+		BUILD_BUG_ON(fbit >= 32);
+	else
+		BUG_ON(fbit >= 32);
+
+	set_bit(fbit, vdev->features);
+}
+
+/**
+ * __virtio_clear_bit - helper to set feature bits. For use by transports.
+ * @vdev: the device
+ * @fbit: the feature bit
+ */
+static inline void __virtio_clear_bit(struct virtio_device *vdev,
 				      unsigned int fbit)
 {
 	/* Did you forget to fix assumptions on max features? */
@@ -90,10 +126,21 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 	else
 		BUG_ON(fbit >= 32);
 
+	clear_bit(fbit, vdev->features);
+}
+
+/**
+ * virtio_has_feature - helper to determine if this device has this feature.
+ * @vdev: the device
+ * @fbit: the feature bit
+ */
+static inline bool virtio_has_feature(const struct virtio_device *vdev,
+				      unsigned int fbit)
+{
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);
 
-	return test_bit(fbit, vdev->features);
+	return __virtio_test_bit(vdev, fbit);
 }
 
 static inline
-- 
MST

