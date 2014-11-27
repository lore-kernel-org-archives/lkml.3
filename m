Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaK0UJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:09:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaK0UJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:09:41 -0500
Date: Thu, 27 Nov 2014 22:09:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v6 19/46] KVM: s390 allow virtio_ccw status writes to fail
Message-ID: <1417118789-18231-20-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417118789-18231-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gracefully handle failure to write device status.
We really should handle other errors as well, but this one is needed for
virtio 1.0 compliance.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/s390/kvm/virtio_ccw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index ad06e11..79f6737 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -862,7 +862,9 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+	u8 old_status = *vcdev->status;
 	struct ccw1 *ccw;
+	int ret;
 
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
 	if (!ccw)
@@ -874,7 +876,10 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 	ccw->flags = 0;
 	ccw->count = sizeof(status);
 	ccw->cda = (__u32)(unsigned long)vcdev->status;
-	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_STATUS);
+	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_STATUS);
+	/* Write failed? We assume status is unchanged. */
+	if (ret)
+		*vcdev->status = old_status;
 	kfree(ccw);
 }
 
-- 
MST

