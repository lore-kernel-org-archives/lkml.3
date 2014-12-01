Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaLAQDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbaLAQDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:03:45 -0500
Date: Mon, 1 Dec 2014 18:03:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v8 05/50] virtio: assert 32 bit features in transports
Message-ID: <1417449619-24896-6-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point, no transports set any of the high 32 feature bits.
Since transports generally can't (yet) cope with such bits, add BUG_ON
checks to make sure they are not set by mistake.

Based on rproc patch by Rusty.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/lguest/lguest_device.c         | 3 +++
 drivers/misc/mic/card/mic_virtio.c     | 3 +++
 drivers/remoteproc/remoteproc_virtio.c | 3 +++
 drivers/s390/kvm/kvm_virtio.c          | 3 +++
 drivers/s390/kvm/virtio_ccw.c          | 3 +++
 drivers/virtio/virtio_mmio.c           | 3 +++
 drivers/virtio/virtio_pci.c            | 3 +++
 7 files changed, 21 insertions(+)

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index d81170a..9b77b66 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -136,6 +136,9 @@ static void lg_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
 	/*
 	 * Since lguest is currently x86-only, we're little-endian.  That
 	 * means we could just memcpy.  But it's not time critical, and in
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index f5e7561..d027d29 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -96,6 +96,9 @@ static void mic_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
 	memset_io(out_features, 0, feature_len);
 	bits = min_t(unsigned, feature_len,
 		sizeof(vdev->features)) * 8;
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 62897db..627737e 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -227,6 +227,9 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features */
 	vring_transport_features(vdev);
 
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
 	/*
 	 * Remember the finalized features of our vdev, and provide it
 	 * to the remote processor once it is powered on.
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 2336c7e..f5575cc 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -103,6 +103,9 @@ static void kvm_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
 	memset(out_features, 0, desc->feature_len);
 	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
 	for (i = 0; i < bits; i++) {
diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 56d7895..244d611 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -714,6 +714,9 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
 	features->index = 0;
 	features->features = cpu_to_le32(vdev->features);
 	/* Write the feature bits to the host. */
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index c63d0ef..aec1dae 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -159,6 +159,9 @@ static void vm_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
 	writel(0, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SEL);
 	writel(vdev->features, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
 }
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 7e0efa7..dd6df97 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -119,6 +119,9 @@ static void vp_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
 	/* We only support 32 feature bits. */
 	iowrite32(vdev->features, vp_dev->ioaddr + VIRTIO_PCI_GUEST_FEATURES);
 }
-- 
MST

