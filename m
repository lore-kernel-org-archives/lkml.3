Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaJVPrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbaJVPrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:47:36 -0400
Date: Wed, 22 Oct 2014 18:50:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Huth <thuth@linux.vnet.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH RFC v2 12/16] KVM: s390: Set virtio-ccw transport revision
Message-ID: <1413992894-22976-13-git-send-email-mst@redhat.com>
References: <1413992894-22976-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413992894-22976-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Huth <thuth@linux.vnet.ibm.com>

With the new SET-VIRTIO-REVISION command of the virtio 1.0 standard, we
can now negotiate the virtio-ccw revision after setting a channel online.

Note that we don't negotiate version 1 yet.

[Cornelia Huck: reworked revision loop a bit]
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Thomas Huth <thuth@linux.vnet.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/s390/kvm/virtio_ccw.c | 63 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 27aab69..394ddb8 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -55,6 +55,7 @@ struct virtio_ccw_device {
 	struct ccw_device *cdev;
 	__u32 curr_io;
 	int err;
+	unsigned int revision; /* Transport revision */
 	wait_queue_head_t wait_q;
 	spinlock_t lock;
 	struct list_head virtqueues;
@@ -86,6 +87,15 @@ struct virtio_thinint_area {
 	u8 isc;
 } __packed;
 
+struct virtio_rev_info {
+	__u16 revision;
+	__u16 length;
+	__u8 data[];
+};
+
+/* the highest virtio-ccw revision we support */
+#define VIRTIO_CCW_REV_MAX 0
+
 struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
 	int num;
@@ -122,6 +132,7 @@ static struct airq_info *airq_areas[MAX_AIRQ_AREAS];
 #define CCW_CMD_WRITE_STATUS 0x31
 #define CCW_CMD_READ_VQ_CONF 0x32
 #define CCW_CMD_SET_IND_ADAPTER 0x73
+#define CCW_CMD_SET_VIRTIO_REV 0x83
 
 #define VIRTIO_CCW_DOING_SET_VQ 0x00010000
 #define VIRTIO_CCW_DOING_RESET 0x00040000
@@ -134,6 +145,7 @@ static struct airq_info *airq_areas[MAX_AIRQ_AREAS];
 #define VIRTIO_CCW_DOING_READ_VQ_CONF 0x02000000
 #define VIRTIO_CCW_DOING_SET_CONF_IND 0x04000000
 #define VIRTIO_CCW_DOING_SET_IND_ADAPTER 0x08000000
+#define VIRTIO_CCW_DOING_SET_VIRTIO_REV 0x10000000
 #define VIRTIO_CCW_INTPARM_MASK 0xffff0000
 
 static struct virtio_ccw_device *to_vc_device(struct virtio_device *vdev)
@@ -934,6 +946,7 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
 		case VIRTIO_CCW_DOING_RESET:
 		case VIRTIO_CCW_DOING_READ_VQ_CONF:
 		case VIRTIO_CCW_DOING_SET_IND_ADAPTER:
+		case VIRTIO_CCW_DOING_SET_VIRTIO_REV:
 			vcdev->curr_io &= ~activity;
 			wake_up(&vcdev->wait_q);
 			break;
@@ -1049,6 +1062,51 @@ static int virtio_ccw_offline(struct ccw_device *cdev)
 	return 0;
 }
 
+static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
+{
+	struct virtio_rev_info *rev;
+	struct ccw1 *ccw;
+	int ret;
+
+	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
+	if (!ccw)
+		return -ENOMEM;
+	rev = kzalloc(sizeof(*rev), GFP_DMA | GFP_KERNEL);
+	if (!rev) {
+		kfree(ccw);
+		return -ENOMEM;
+	}
+
+	/* Set transport revision */
+	ccw->cmd_code = CCW_CMD_SET_VIRTIO_REV;
+	ccw->flags = 0;
+	ccw->count = sizeof(*rev);
+	ccw->cda = (__u32)(unsigned long)rev;
+
+	vcdev->revision = VIRTIO_CCW_REV_MAX;
+	do {
+		rev->revision = vcdev->revision;
+		/* none of our supported revisions carry payload */
+		rev->length = 0;
+		ret = ccw_io_helper(vcdev, ccw,
+				    VIRTIO_CCW_DOING_SET_VIRTIO_REV);
+		if (ret == -EOPNOTSUPP) {
+			if (vcdev->revision == 0)
+				/*
+				 * The host device does not support setting
+				 * the revision: let's operate it in legacy
+				 * mode.
+				 */
+				ret = 0;
+			else
+				vcdev->revision--;
+		}
+	} while (ret == -EOPNOTSUPP);
+
+	kfree(ccw);
+	kfree(rev);
+	return ret;
+}
 
 static int virtio_ccw_online(struct ccw_device *cdev)
 {
@@ -1089,6 +1147,11 @@ static int virtio_ccw_online(struct ccw_device *cdev)
 	spin_unlock_irqrestore(get_ccwdev_lock(cdev), flags);
 	vcdev->vdev.id.vendor = cdev->id.cu_type;
 	vcdev->vdev.id.device = cdev->id.cu_model;
+
+	ret = virtio_ccw_set_transport_rev(vcdev);
+	if (ret)
+		goto out_free;
+
 	ret = register_virtio_device(&vcdev->vdev);
 	if (ret) {
 		dev_warn(&cdev->dev, "Failed to register virtio device: %d\n",
-- 
MST

