Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaKYQzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:55:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaKYQmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:42:07 -0500
Date: Tue, 25 Nov 2014 18:41:35 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v4 04/42] virtio: disable virtio 1.0 in transports
Message-ID: <1416933600-21398-5-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416933600-21398-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disable virtio 1.0 in transports that don't
support it yet.
We will gradually re-enable as support is added.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/lguest/lguest_device.c     | 3 ++-
 drivers/misc/mic/card/mic_virtio.c | 2 ++
 drivers/s390/kvm/virtio_ccw.c      | 3 ++-
 drivers/virtio/virtio_mmio.c       | 2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 4d29bcd..4deaf88 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -106,7 +106,8 @@ static u64 lg_get_features(struct virtio_device *vdev)
 		if (in_features[i / 8] & (1 << (i % 8)))
 			features |= (1ULL << i);
 
-	return features;
+	/* lguest is not in virtio 1.0 */
+	return features & ~BIT_ULL(VIRTIO_F_VERSION_1);
 }
 
 /*
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 6d94f04..edc77f1 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -82,6 +82,8 @@ static u64 mic_get_features(struct virtio_device *vdev)
 		if (ioread8(&in_features[i / 8]) & (BIT_ULL(i % 8)))
 			features |= BIT_ULL(i);
 
+	/* MIC is not in virtio 1.0, disable it for now. */
+	features &= ~BIT_ULL(VIRTIO_F_VERSION_1);
 	return features;
 }
 
diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index abba04d..08536f0 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -704,7 +704,8 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 out_free:
 	kfree(features);
 	kfree(ccw);
-	return rc;
+	/* TODO: enable virtio 1.0 */
+	return rc & ~BIT_ULL(VIRTIO_F_VERSION_1);;
 }
 
 static void virtio_ccw_finalize_features(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index fd01c6d..e1d38a9 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -151,6 +151,8 @@ static u64 vm_get_features(struct virtio_device *vdev)
 	features = readl(vm_dev->base + VIRTIO_MMIO_HOST_FEATURES);
 	writel(1, vm_dev->base + VIRTIO_MMIO_HOST_FEATURES_SEL);
 	features |= ((u64)readl(vm_dev->base + VIRTIO_MMIO_HOST_FEATURES) << 32);
+	/* TODO: enable virtio 1.0 support */
+	features &= ~BIT_ULL(VIRTIO_F_VERSION_1);
 	return features;
 }
 
-- 
MST

