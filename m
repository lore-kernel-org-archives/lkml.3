Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaLINya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:54:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178AbaLINxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:53:50 -0500
Date: Tue, 9 Dec 2014 15:53:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 2/2] virtio_ccw: finalize_features error handling
Message-ID: <1418133187-12436-3-git-send-email-mst@redhat.com>
References: <1418133187-12436-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418133187-12436-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

We previously tried to use device even if finalize_features failed, but
that's wrong since driver and device are now out of sync.

Fail probe if we detect failures during finalize_features.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/s390/kvm/virtio_ccw.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index f92b9e6..71d7802 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -757,6 +757,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct virtio_feature_desc *features;
 	struct ccw1 *ccw;
+	int ret;
 
 	if (vcdev->revision >= 1 &&
 	    !__virtio_test_bit(vdev, VIRTIO_F_VERSION_1)) {
@@ -767,12 +768,13 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
 	if (!ccw)
-		return 0;
+		return -ENOMEM;
 
 	features = kzalloc(sizeof(*features), GFP_DMA | GFP_KERNEL);
-	if (!features)
+	if (!features) {
+		ret = -ENOMEM;
 		goto out_free;
-
+	}
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
@@ -783,7 +785,9 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
 	ccw->cda = (__u32)(unsigned long)features;
-	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+	if (ret)
+		goto out_free;
 
 	if (vcdev->revision == 0)
 		goto out_free;
@@ -795,13 +799,13 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
 	ccw->cda = (__u32)(unsigned long)features;
-	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 
 out_free:
 	kfree(features);
 	kfree(ccw);
 
-	return 0;
+	return ret;
 }
 
 static void virtio_ccw_get_config(struct virtio_device *vdev,
-- 
MST

