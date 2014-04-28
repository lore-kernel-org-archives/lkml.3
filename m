Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbaD1PzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:55:05 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38292 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbaD1Py6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:54:58 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v5 10/11] VFIO_PLATFORM: Initial interrupts support
Date: Mon, 28 Apr 2014 17:52:50 +0200
Message-Id: <1398700371-20096-11-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to set an eventfd for a patform device's interrupt,
and also to trigger the interrupt eventfd from userspace for testing.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform.c         |  36 +++++++-
 drivers/vfio/platform/vfio_platform_irq.c     | 123 +++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |   7 ++
 3 files changed, 162 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 2e16595..8aa5d10 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -174,10 +174,40 @@ static long vfio_platform_ioctl(void *device_data,
 
 		return copy_to_user((void __user *)arg, &info, minsz);
 
-	} else if (cmd == VFIO_DEVICE_SET_IRQS)
-		return -EINVAL;
+	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
+		struct vfio_irq_set hdr;
+		int ret = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (hdr.argsz < minsz)
+			return -EINVAL;
+
+		if (hdr.index >= vdev->num_irqs)
+			return -EINVAL;
+
+		if (hdr.start != 0 || hdr.count > 1)
+			return -EINVAL;
+
+		if (hdr.count == 0 &&
+			(!(hdr.flags & VFIO_IRQ_SET_DATA_NONE) ||
+			 !(hdr.flags & VFIO_IRQ_SET_ACTION_TRIGGER)))
+			return -EINVAL;
+
+		if (hdr.flags & ~(VFIO_IRQ_SET_DATA_TYPE_MASK |
+				  VFIO_IRQ_SET_ACTION_TYPE_MASK))
+			return -EINVAL;
+
+		ret = vfio_platform_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
+						   hdr.start, hdr.count,
+						   (void *)arg+minsz);
+
+		return ret;
 
-	else if (cmd == VFIO_DEVICE_RESET)
+	} else if (cmd == VFIO_DEVICE_RESET)
 		return -EINVAL;
 
 	return -ENOTTY;
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 075c401..433edc1 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -31,6 +31,9 @@
 
 #include "vfio_platform_private.h"
 
+static int vfio_set_trigger(struct vfio_platform_device *vdev,
+			    int index, int fd);
+
 int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 {
 	int cnt = 0, i;
@@ -47,9 +50,11 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 
 	for (i = 0; i < cnt; i++) {
 		struct vfio_platform_irq irq;
+		int hwirq = platform_get_irq(vdev->pdev, i);
 
-		irq.flags = 0;
+		irq.flags = VFIO_IRQ_INFO_EVENTFD;
 		irq.count = 1;
+		irq.hwirq = hwirq;
 
 		vdev->irq[i] = irq;
 	}
@@ -59,5 +64,121 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 
 void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
 {
+	int i;
+
+	for (i = 0; i < vdev->num_irqs; i++)
+		vfio_set_trigger(vdev, i, -1);
+
 	kfree(vdev->irq);
 }
+
+static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
+{
+	struct eventfd_ctx *trigger = dev_id;
+
+	eventfd_signal(trigger, 1);
+
+	return IRQ_HANDLED;
+}
+
+static int vfio_set_trigger(struct vfio_platform_device *vdev,
+			    int index, int fd)
+{
+	struct vfio_platform_irq *irq = &vdev->irq[index];
+	struct eventfd_ctx *trigger;
+	int ret;
+
+	if (irq->trigger) {
+		free_irq(irq->hwirq, irq);
+		kfree(irq->name);
+		eventfd_ctx_put(irq->trigger);
+		irq->trigger = NULL;
+	}
+
+	if (fd < 0) /* Disable only */
+		return 0;
+
+	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
+						irq->hwirq, vdev->pdev->name);
+	if (!irq->name)
+		return -ENOMEM;
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		kfree(irq->name);
+		return PTR_ERR(trigger);
+	}
+
+	irq->trigger = trigger;
+
+	ret = request_irq(irq->hwirq, vfio_irq_handler, 0, irq->name, irq);
+	if (ret) {
+		kfree(irq->name);
+		eventfd_ctx_put(trigger);
+		irq->trigger = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
+				     unsigned index, unsigned start,
+				     unsigned count, uint32_t flags, void *data)
+{
+	struct vfio_platform_irq *irq = &vdev->irq[index];
+	uint8_t arr;
+	int32_t fd;
+
+	switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
+	case VFIO_IRQ_SET_DATA_NONE:
+		if (count == 0)
+			return vfio_set_trigger(vdev, index, -1);
+
+		vfio_irq_handler(irq->hwirq, irq);
+		return 0;
+
+	case VFIO_IRQ_SET_DATA_BOOL:
+		if (copy_from_user(&arr, data, sizeof(uint8_t)))
+			return -EFAULT;
+
+		if (arr == 0x1) {
+			vfio_irq_handler(irq->hwirq, irq);
+			return 0;
+		}
+
+		return -EINVAL;
+
+	case VFIO_IRQ_SET_DATA_EVENTFD:
+		if (copy_from_user(&fd, data, sizeof(int32_t)))
+			return -EFAULT;
+
+		return vfio_set_trigger(vdev, index, fd);
+	}
+
+	return -EFAULT;
+}
+
+int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
+				 uint32_t flags, unsigned index, unsigned start,
+				 unsigned count, void *data)
+{
+	int (*func)(struct vfio_platform_device *vdev, unsigned index,
+		    unsigned start, unsigned count, uint32_t flags,
+		    void *data) = NULL;
+
+	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+	case VFIO_IRQ_SET_ACTION_MASK:
+	case VFIO_IRQ_SET_ACTION_UNMASK:
+		/* XXX not implemented */
+		break;
+	case VFIO_IRQ_SET_ACTION_TRIGGER:
+		func = vfio_platform_set_irq_trigger;
+		break;
+	}
+
+	if (!func)
+		return -ENOTTY;
+
+	return func(vdev, index, start, count, flags, data);
+}
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 9776cff..e21c15a 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -25,8 +25,11 @@
 	((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
 
 struct vfio_platform_irq {
+	struct eventfd_ctx	*trigger;
 	u32			flags;
 	u32			count;
+	int			hwirq;
+	char			*name;
 };
 
 struct vfio_platform_region {
@@ -47,4 +50,8 @@ extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
 
 extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
 
+extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
+			uint32_t flags, unsigned index, unsigned start,
+			unsigned count, void *data);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
1.8.3.2

