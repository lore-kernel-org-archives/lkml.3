Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaLHNGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:06:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaLHNGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:06:15 -0500
Date: Mon, 8 Dec 2014 15:06:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dahi@linux.vnet.ibm.com, cornelia.huck@de.ibm.com, rusty@rustcorp.com.au,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v3 4/6] virtio_ccw: rev 1 devices set VIRTIO_F_VERSION_1
Message-ID: <1418042769-25539-5-git-send-email-mst@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418042769-25539-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What does it mean if rev 1 device does not set
VIRTIO_F_VERSION_1? E.g. is it native endian?

Let's not even try to drive such devices:
fail attempts to finalize features.
virtio core will detect this and bail out.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/s390/kvm/virtio_ccw.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 789275f..f9f87ba 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -758,6 +758,13 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	struct virtio_feature_desc *features;
 	struct ccw1 *ccw;
 
+	if (vcdev->revision == 1 &&
+	    !__virtio_test_bit(vdev, VIRTIO_F_VERSION_1)) {
+		dev_err(&vdev->dev, "virtio: device uses revision 1 "
+			"but does not have VIRTIO_F_VERSION_1\n");
+		return -EINVAL;
+	}
+
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
 	if (!ccw)
 		return 0;
-- 
MST

