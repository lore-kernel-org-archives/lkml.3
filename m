Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaJWQWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbaJWQWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:22:31 -0400
Date: Thu, 23 Oct 2014 19:25:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH RFC v4 16/17] KVM: s390 allow virtio_ccw status writes to fail
Message-ID: <1414081380-14623-17-git-send-email-mst@redhat.com>
References: <1414081380-14623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414081380-14623-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gracefully handle failure to write device status.
We really should handle other errors as well, but this one is needed for
virtio 1.0 compliance.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/s390/kvm/virtio_ccw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index a994078..26e737c 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -862,7 +862,9 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+	u8 old_status = vcdev->status;
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

