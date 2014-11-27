Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaK0UIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:08:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaK0UIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:08:30 -0500
Date: Thu, 27 Nov 2014 22:08:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v6 06/46] virtio_ccw: add support for 64 bit features.
Message-ID: <1417118789-18231-7-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417118789-18231-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Negotiate full 64 bit features.
Change u32 to u64, make sure to use 1ULL everywhere.

Note: devices guarantee that VERSION_1 is clear unless
revision 1 is negotiated.

Based on patches by Rusty, Thomas Huth and Cornelia.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/s390/kvm/virtio_ccw.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 244d611..abba04d 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -664,7 +664,8 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct virtio_feature_desc *features;
-	int ret, rc;
+	int ret;
+	u64 rc;
 	struct ccw1 *ccw;
 
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
@@ -677,7 +678,6 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 		goto out_free;
 	}
 	/* Read the feature bits from the host. */
-	/* TODO: Features > 32 bits */
 	features->index = 0;
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
@@ -691,6 +691,16 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 
 	rc = le32_to_cpu(features->features);
 
+	/* Read second half feature bits from the host. */
+	features->index = 1;
+	ccw->cmd_code = CCW_CMD_READ_FEAT;
+	ccw->flags = 0;
+	ccw->count = sizeof(*features);
+	ccw->cda = (__u32)(unsigned long)features;
+	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
+	if (ret == 0)
+		rc |= (u64)le32_to_cpu(features->features) << 32;
+
 out_free:
 	kfree(features);
 	kfree(ccw);
@@ -714,12 +724,18 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
-	/* Make sure we don't have any features > 32 bits! */
-	BUG_ON((u32)vdev->features != vdev->features);
-
 	features->index = 0;
-	features->features = cpu_to_le32(vdev->features);
-	/* Write the feature bits to the host. */
+	features->features = cpu_to_le32((u32)vdev->features);
+	/* Write the first half of the feature bits to the host. */
+	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
+	ccw->flags = 0;
+	ccw->count = sizeof(*features);
+	ccw->cda = (__u32)(unsigned long)features;
+	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+
+	features->index = 1;
+	features->features = cpu_to_le32(vdev->features >> 32);
+	/* Write the second half of the feature bits to the host. */
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-- 
MST

