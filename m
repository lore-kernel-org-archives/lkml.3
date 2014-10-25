Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaJYSdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:33:47 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:41568 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaJYSdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:33:43 -0400
From: "john.liuli" <john.liuli@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <qemu-devel@nongnu.org>, <peter.huangpeng@huawei.com>,
        <rusty@rustcorp.com.au>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <n.nikolaev@virtualopensystems.com>, <yingshiuan.pan@gmail.com>,
        <remy.gauguey@cea.fr>, <joel.schopp@amd.com>,
        Li Liu <john.liuli@huawei.com>
Subject: [RFC PATCH 2/2] Assign a new irq handler while irqfd enabled
Date: Sat, 25 Oct 2014 16:24:54 +0800
Message-ID: <1414225494-2208-3-git-send-email-john.liuli@huawei.com>
X-Mailer: git-send-email 1.9.0.msysgit.0
In-Reply-To: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.142.143.9]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.544B5EAA.0135,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: bba50b150d6316fe59f4e618c40f3452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Liu <john.liuli@huawei.com>

This irq handler will get the interrupt reason from a
shared memory. And will be assigned only while irqfd
enabled.

Signed-off-by: Li Liu <john.liuli@huawei.com>
---
 drivers/virtio/virtio_mmio.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 28ddb55..7229605 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -259,7 +259,31 @@ static irqreturn_t vm_interrupt(int irq, void *opaque)
 	return ret;
 }
 
+/* Notify all virtqueues on an interrupt. */
+static irqreturn_t vm_interrupt_irqfd(int irq, void *opaque)
+{
+	struct virtio_mmio_device *vm_dev = opaque;
+	struct virtio_mmio_vq_info *info;
+	unsigned long status;
+	unsigned long flags;
+	irqreturn_t ret = IRQ_NONE;
 
+	/* Read the interrupt reason and reset it */
+	status = *vm_dev->isr_mem;
+	*vm_dev->isr_mem = 0x0;
+
+	if (unlikely(status & VIRTIO_MMIO_INT_CONFIG)) {
+		virtio_config_changed(&vm_dev->vdev);
+		ret = IRQ_HANDLED;
+	}
+
+	spin_lock_irqsave(&vm_dev->lock, flags);
+	list_for_each_entry(info, &vm_dev->virtqueues, node)
+		ret |= vring_interrupt(irq, info->vq);
+	spin_unlock_irqrestore(&vm_dev->lock, flags);
+
+	return ret;
+}
 
 static void vm_del_vq(struct virtqueue *vq)
 {
@@ -391,6 +415,7 @@ error_available:
 	return ERR_PTR(err);
 }
 
+#define VIRTIO_MMIO_F_IRQFD        (1 << 7)
 static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct virtqueue *vqs[],
 		       vq_callback_t *callbacks[],
@@ -400,8 +425,13 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	unsigned int irq = platform_get_irq(vm_dev->pdev, 0);
 	int i, err;
 
-	err = request_irq(irq, vm_interrupt, IRQF_SHARED,
-			dev_name(&vdev->dev), vm_dev);
+	if (*vm_dev->isr_mem & VIRTIO_MMIO_F_IRQFD) {
+		err = request_irq(irq, vm_interrupt_irqfd, IRQF_SHARED,
+				  dev_name(&vdev->dev), vm_dev);
+	} else {
+		err = request_irq(irq, vm_interrupt, IRQF_SHARED,
+				  dev_name(&vdev->dev), vm_dev);
+	}
 	if (err)
 		return err;
 
-- 
1.7.9.5


