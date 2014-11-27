Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaK0Mbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:31:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbaK0Mbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:31:46 -0500
Date: Thu, 27 Nov 2014 14:31:30 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v5 17/45] KVM: s390: virtio-ccw revision 1 SET_VQ
Message-ID: <1417091078-24611-18-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

The CCW_CMD_SET_VQ command has a different format for revision 1+
devices, allowing to specify a more complex virtqueue layout. For
now, we stay however with the old layout and simply use the new
command format for virtio-1 devices.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/s390/kvm/virtio_ccw.c | 54 +++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 193e8f1..ad06e11 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -68,13 +68,22 @@ struct virtio_ccw_device {
 	void *airq_info;
 };
 
-struct vq_info_block {
+struct vq_info_block_legacy {
 	__u64 queue;
 	__u32 align;
 	__u16 index;
 	__u16 num;
 } __packed;
 
+struct vq_info_block {
+	__u64 desc;
+	__u32 res0;
+	__u16 index;
+	__u16 num;
+	__u64 avail;
+	__u64 used;
+} __packed;
+
 struct virtio_feature_desc {
 	__u32 features;
 	__u8 index;
@@ -100,7 +109,10 @@ struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
 	int num;
 	void *queue;
-	struct vq_info_block *info_block;
+	union {
+		struct vq_info_block s;
+		struct vq_info_block_legacy l;
+	} *info_block;
 	int bit_nr;
 	struct list_head node;
 	long cookie;
@@ -411,13 +423,22 @@ static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
 	spin_unlock_irqrestore(&vcdev->lock, flags);
 
 	/* Release from host. */
-	info->info_block->queue = 0;
-	info->info_block->align = 0;
-	info->info_block->index = index;
-	info->info_block->num = 0;
+	if (vcdev->revision == 0) {
+		info->info_block->l.queue = 0;
+		info->info_block->l.align = 0;
+		info->info_block->l.index = index;
+		info->info_block->l.num = 0;
+		ccw->count = sizeof(info->info_block->l);
+	} else {
+		info->info_block->s.desc = 0;
+		info->info_block->s.index = index;
+		info->info_block->s.num = 0;
+		info->info_block->s.avail = 0;
+		info->info_block->s.used = 0;
+		ccw->count = sizeof(info->info_block->s);
+	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->count = sizeof(*info->info_block);
 	ccw->cda = (__u32)(unsigned long)(info->info_block);
 	ret = ccw_io_helper(vcdev, ccw,
 			    VIRTIO_CCW_DOING_SET_VQ | index);
@@ -500,13 +521,22 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	}
 
 	/* Register it with the host. */
-	info->info_block->queue = (__u64)info->queue;
-	info->info_block->align = KVM_VIRTIO_CCW_RING_ALIGN;
-	info->info_block->index = i;
-	info->info_block->num = info->num;
+	if (vcdev->revision == 0) {
+		info->info_block->l.queue = (__u64)info->queue;
+		info->info_block->l.align = KVM_VIRTIO_CCW_RING_ALIGN;
+		info->info_block->l.index = i;
+		info->info_block->l.num = info->num;
+		ccw->count = sizeof(info->info_block->l);
+	} else {
+		info->info_block->s.desc = (__u64)info->queue;
+		info->info_block->s.index = i;
+		info->info_block->s.num = info->num;
+		info->info_block->s.avail = (__u64)virtqueue_get_avail(vq);
+		info->info_block->s.used = (__u64)virtqueue_get_used(vq);
+		ccw->count = sizeof(info->info_block->s);
+	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->count = sizeof(*info->info_block);
 	ccw->cda = (__u32)(unsigned long)(info->info_block);
 	err = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_VQ | i);
 	if (err) {
-- 
MST

