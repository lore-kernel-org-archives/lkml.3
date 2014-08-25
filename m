Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaHYN3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:29:04 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46957 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaHYN26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:28:58 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: [RFC 9/9] KVM: KVM_VFIO: ARM: implement irq forwarding control
Date: Mon, 25 Aug 2014 15:27:44 +0200
Message-Id: <1408973264-30384-10-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>
References: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements ARM specific KVM-VFIO device group commands:
- KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ
- KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ
capability can be queried using KVM_HAS_DEVICE_ATTR.

The new commands enable to set IRQ forwarding on/off for a given
IRQ index of a VFIO platform device.

as soon as a forwarded irq is set, a reference to the VFIO device
is taken by the kvm-vfio device.

The kvm-vfio device stores in the kvm_vfio_arch_data the list
of "assigned" devices (kvm_vfio_device). Each kvm_vfio_device
stores the list of assigned IRQs (potentially allowed a subset of
IRQ to be forwarded)

The kvm-vfio device programs both the GIC and vGIC. Also it
clears the active bit on destruction, in case the guest did not
do it itself.

Changing the forwarded state is not allowed in the critical
section starting from VFIO IRQ handler to LR programming. It is
up to the client to take care of this.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/include/asm/kvm_host.h |   2 +
 arch/arm/kvm/Makefile           |   2 +-
 arch/arm/kvm/kvm_vfio_arm.c     | 599 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 602 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/kvm/kvm_vfio_arm.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 4f1edbf..5c300f6 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -25,6 +25,8 @@
 #include <asm/fpstate.h>
 #include <kvm/arm_arch_timer.h>
 
+#define __KVM_HAVE_ARCH_KVM_VFIO
+
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
 #else
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index ea1fa76..26a5a42 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -19,7 +19,7 @@ kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vf
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
-obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
+obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o kvm_vfio_arm.o
 obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic.o
 obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic-v2.o
 obj-$(CONFIG_KVM_ARM_TIMER) += $(KVM)/arm/arch_timer.o
diff --git a/arch/arm/kvm/kvm_vfio_arm.c b/arch/arm/kvm/kvm_vfio_arm.c
new file mode 100644
index 0000000..6619e0b
--- /dev/null
+++ b/arch/arm/kvm/kvm_vfio_arm.c
@@ -0,0 +1,599 @@
+/*
+ * Copyright (C) 2014 Linaro Ltd.
+ * Authors: Eric Auger <eric.auger@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/kvm_host.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/vfio.h>
+#include <linux/irq.h>
+#include <asm/kvm_host.h>
+#include <asm/kvm.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+
+struct vfio_device;
+
+enum kvm_irq_fwd_action {
+	KVM_VFIO_IRQ_SET_FORWARD,
+	KVM_VFIO_IRQ_SET_NORMAL,
+	KVM_VFIO_IRQ_CLEANUP,
+};
+
+/* internal structure describing a forwarded IRQ */
+struct __kvm_arch_fwd_irq {
+	struct list_head link;
+	__u32 irq_index; /* platform device irq index */
+	__u32 hwirq; /*physical IRQ */
+	__u32 guest_irq; /* virtual IRQ */
+	struct kvm_vcpu *vcpu; /* vcpu to inject into*/
+};
+
+struct kvm_vfio_device {
+	struct list_head node;
+	struct vfio_device *vfio_device;
+	/* list of forwarded IRQs for that VFIO device */
+	struct list_head fwd_irq_list;
+	int fd;
+};
+
+struct kvm_vfio_arch_data {
+	/* list of kvm_vfio_devices for which some IRQs are forwarded*/
+	struct list_head assigned_device_list;
+};
+
+/**
+ * set_fwd_state - change the forwarded state of an IRQ
+ * @pfwd: the forwarded irq struct
+ * @action: action to perform (set forward, set back normal, cleanup)
+ *
+ * programs the GIC and VGIC
+ * returns the VGIC map/unmap return status
+ * It is the responsability of the caller to make sure the physical IRQ
+ * is not active. there is a critical section between the start of the
+ * VFIO IRQ handler and LR programming.
+ */
+int set_fwd_state(struct __kvm_arch_fwd_irq *pfwd,
+		  enum kvm_irq_fwd_action action)
+{
+	int ret;
+	struct irq_desc *desc = irq_to_desc(pfwd->hwirq);
+	struct irq_data *d = &desc->irq_data;
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	disable_irq(pfwd->hwirq);
+	/* no fwd state change can happen if the IRQ is in progress */
+	if (irqd_irq_inprogress(d)) {
+		kvm_err("%s cannot change fwd state (IRQ %d in progress\n",
+			__func__, pfwd->hwirq);
+		enable_irq(pfwd->hwirq);
+		return -1;
+	}
+
+	if (action == KVM_VFIO_IRQ_SET_FORWARD) {
+		irqd_set_irq_forwarded(d);
+		ret = vgic_map_phys_irq(pfwd->vcpu,
+					pfwd->guest_irq + VGIC_NR_PRIVATE_IRQS,
+					pfwd->hwirq);
+	} else if (action == KVM_VFIO_IRQ_SET_NORMAL) {
+		irqd_clr_irq_forwarded(d);
+		ret = vgic_unmap_phys_irq(pfwd->vcpu,
+					  pfwd->guest_irq +
+						VGIC_NR_PRIVATE_IRQS,
+					  pfwd->hwirq);
+	} else if (action == KVM_VFIO_IRQ_CLEANUP) {
+		irqd_clr_irq_forwarded(d);
+		/*
+		 * in case the guest did not complete the
+		 * virtual IRQ, let's do it for him.
+		 * when cleanup is called, VCPU have already
+		 * been freed, do not manipulate VGIC
+		 */
+		chip->irq_eoi(d);
+		ret = 0;
+	} else {
+		enable_irq(pfwd->hwirq);
+		ret = -EINVAL;
+	}
+
+	enable_irq(pfwd->hwirq);
+	return ret;
+}
+
+/**
+ * find_in_assigned_devices - look for the device in the assigned
+ * device list
+ * @kv: the kvm-vfio device
+ * @vdev: the vfio_device to look for
+ *
+ * returns the associated kvm_vfio_device if the device is known,
+ * meaning at least 1 IRQ is forwarded for this device.
+ * in the device is not registered, returns NULL.
+ */
+struct kvm_vfio_device *find_in_assigned_devices(struct kvm_vfio *kv,
+						 struct vfio_device *vdev)
+{
+	struct kvm_vfio_device *kvm_vdev_iter;
+	struct kvm_vfio_arch_data *arch_data =
+			kvm_vfio_device_get_arch_data(kv);
+
+	list_for_each_entry(kvm_vdev_iter,
+			    &arch_data->assigned_device_list, node) {
+		if (kvm_vdev_iter->vfio_device == vdev)
+			return kvm_vdev_iter;
+	}
+	return NULL;
+}
+
+/**
+ * find_in_fwd_irq - look for a forwarded irq in the device IRQ list
+ * @kvm_vdev: the kvm_vfio_device
+ * @irq_index: irq index
+ *
+ * returns the forwarded irq struct if it exists, NULL in the negative
+ */
+struct __kvm_arch_fwd_irq *find_in_fwd_irq(struct kvm_vfio_device *kvm_vdev,
+					   int irq_index)
+{
+	struct __kvm_arch_fwd_irq *fwd_irq_iter;
+
+	list_for_each_entry(fwd_irq_iter, &kvm_vdev->fwd_irq_list, link) {
+		if (fwd_irq_iter->irq_index == irq_index)
+			return fwd_irq_iter;
+	}
+	return NULL;
+}
+
+/**
+ * remove_assigned_device - put a given device from the list
+ * @kv: the kvm-vfio device
+ * @vdev: the vfio-device to remove
+ *
+ * change the state of all forwarded IRQs, free the forwarded IRQ list,
+ * remove the corresponding kvm_vfio_device from the assigned device
+ * list.
+ * returns true if the device could be removed, false in the negative
+ */
+bool remove_assigned_device(struct kvm_vfio *kv,
+			    struct vfio_device *vdev)
+{
+	struct kvm_vfio_device *kvm_vdev_iter, *tmp_vdev;
+	struct __kvm_arch_fwd_irq *fwd_irq_iter, *tmp_irq;
+	bool removed = false;
+	struct kvm_vfio_arch_data *arch_data =
+			kvm_vfio_device_get_arch_data(kv);
+	int ret;
+
+	list_for_each_entry_safe(kvm_vdev_iter, tmp_vdev,
+				 &arch_data->assigned_device_list, node) {
+		if (kvm_vdev_iter->vfio_device == vdev) {
+			/* loop on all its forwarded IRQ */
+			list_for_each_entry_safe(fwd_irq_iter, tmp_irq,
+						 &kvm_vdev_iter->fwd_irq_list,
+						 link) {
+				ret = set_fwd_state(fwd_irq_iter,
+						    KVM_VFIO_IRQ_SET_NORMAL);
+				if (ret < 0)
+					return ret;
+				list_del(&fwd_irq_iter->link);
+				kfree(fwd_irq_iter);
+			}
+			/* all IRQs could be deassigned */
+			list_del(&kvm_vdev_iter->node);
+			kvm_vfio_device_put_external_user(
+				kvm_vdev_iter->vfio_device);
+			kfree(kvm_vdev_iter);
+			removed = true;
+			break;
+		}
+	}
+	return removed;
+}
+
+/**
+ * remove_fwd_irq - remove a forwarded irq
+ *
+ * @kv: kvm-vfio device
+ * kvm_vdev: the kvm_vfio_device the IRQ belongs to
+ * irq_index: the index of the IRQ
+ *
+ * change the forwarded state of the IRQ, remove the IRQ from
+ * the device forwarded IRQ list. In case it is the last one,
+ * put the device
+ */
+int remove_fwd_irq(struct kvm_vfio *kv,
+		   struct kvm_vfio_device *kvm_vdev,
+		   int irq_index)
+{
+	struct __kvm_arch_fwd_irq *fwd_irq_iter, *tmp_irq;
+	int ret = -1;
+
+	list_for_each_entry_safe(fwd_irq_iter, tmp_irq,
+				 &kvm_vdev->fwd_irq_list, link) {
+			if (fwd_irq_iter->irq_index == irq_index) {
+				ret = set_fwd_state(fwd_irq_iter,
+						    KVM_VFIO_IRQ_SET_NORMAL);
+				if (ret < 0)
+					break;
+				list_del(&fwd_irq_iter->link);
+				kfree(fwd_irq_iter);
+				ret = 0;
+				break;
+			}
+	}
+	if (list_empty(&kvm_vdev->fwd_irq_list))
+		remove_assigned_device(kv, kvm_vdev->vfio_device);
+
+	return ret;
+}
+
+/**
+ * free_all_fwd_irq - cancel forwarded IRQs and put all devices
+ * @kv: kvm-vfio device
+ *
+ * loop on all got devices and their associated forwarded IRQs
+ * restore the non forwarded state, remove IRQs and their devices from
+ * the respective list, put the vfio platform devices
+ *
+ * When this function is called, the vcpu already are destroyed. No
+ * vgic manipulation can happen hence the KVM_VFIO_IRQ_CLEANUP
+ * set_fwd_state action
+ */
+int free_all_fwd_irq(struct kvm_vfio *kv)
+{
+	struct __kvm_arch_fwd_irq *fwd_irq_iter, *tmp_irq;
+	struct kvm_vfio_device *kvm_vdev_iter, *tmp_vdev;
+	struct kvm_vfio_arch_data *arch_data =
+			kvm_vfio_device_get_arch_data(kv);
+
+	/* loop on all the assigned devices */
+	list_for_each_entry_safe(kvm_vdev_iter, tmp_vdev,
+				 &arch_data->assigned_device_list, node) {
+
+		/* loop on all its forwarded IRQ */
+		list_for_each_entry_safe(fwd_irq_iter, tmp_irq,
+					 &kvm_vdev_iter->fwd_irq_list, link) {
+			set_fwd_state(fwd_irq_iter, KVM_VFIO_IRQ_CLEANUP);
+			list_del(&fwd_irq_iter->link);
+			kfree(fwd_irq_iter);
+		}
+		list_del(&kvm_vdev_iter->node);
+		kvm_vfio_device_put_external_user(kvm_vdev_iter->vfio_device);
+		kfree(kvm_vdev_iter);
+	}
+	return 0;
+}
+
+/**
+ * get_vfio_device - returns the vfio-device corresponding to this fd
+ * @fd:fd of the vfio platform device
+ *
+ * checks it is a vfio device
+ * increment its ref counter
+ */
+static struct vfio_device *get_vfio_device(int fd)
+{
+	struct fd f;
+	struct vfio_device *vdev;
+
+	f = fdget(fd);
+	if (!f.file)
+		return NULL;
+	vdev = kvm_vfio_device_get_external_user(f.file);
+	fdput(f);
+	return vdev;
+}
+
+/**
+ * put_vfio_device: put the vfio platform device
+ * @vdev: vfio_device to put
+ *
+ * decrement the ref counter
+ */
+static void put_vfio_device(struct vfio_device *vdev)
+{
+	kvm_vfio_device_put_external_user(vdev);
+}
+
+/**
+ * validate_forward-checks whether forwarding a given IRQ is meaningful
+ * @vdev:  vfio_device the IRQ belongs to
+ * @fwd_irq: user struct containing the irq_index to forward
+ * @kvm_vdev: if a forwarded IRQ already exists for that VFIO device,
+ * kvm_vfio_device that holds it
+ * @hwirq: irq numberthe irq index corresponds to
+ *
+ * checks the vfio-device is a platform vfio device
+ * checks the irq_index corresponds to an actual hwirq and
+ * checks this hwirq is not already forwarded
+ * returns < 0 on following errors:
+ * not a platform device, bad irq index, already forwarded
+ */
+static int validate_forward(struct kvm_vfio *kv,
+			    struct vfio_device *vdev,
+			    struct kvm_arch_forwarded_irq *fwd_irq,
+			    struct kvm_vfio_device **kvm_vdev,
+			    int *hwirq)
+{
+	int type;
+	struct device *dev;
+	struct platform_device *platdev;
+
+	*hwirq = -1;
+	*kvm_vdev = NULL;
+	type = kvm_vfio_external_get_type(vdev);
+	if (type & VFIO_DEVICE_FLAGS_PLATFORM) {
+		dev = kvm_vfio_external_get_base_device(vdev);
+		platdev = to_platform_device(dev);
+		*hwirq = platform_get_irq(platdev, fwd_irq->irq_index);
+		if (*hwirq < 0) {
+			kvm_err("%s incorrect index\n",	__func__);
+			return -EINVAL;
+		}
+	} else {
+		kvm_err("%s not a platform device\n", __func__);
+		return -EINVAL;
+	}
+	/* is a ref to this device already owned by the KVM-VFIO device? */
+	*kvm_vdev = find_in_assigned_devices(kv, vdev);
+	if (*kvm_vdev) {
+		if (find_in_fwd_irq(*kvm_vdev, fwd_irq->irq_index)) {
+			kvm_err("%s irq %d already forwarded\n",
+				__func__, *hwirq);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/**
+ * validate_deassign: check a deassignment is meaningful
+ * @kv: the kvm_vfio device
+ * @vdev: the vfio_device whose irq to deassign belongs to
+ * @fwd_irq: the user struct that contains the fd and irq_index of the irq
+ * @kvm_vdev: the kvm_vfio_device the forwarded irq belongs to, if
+ * it exists
+ *
+ * returns 0 if the provided irq effectively is forwarded
+ * (a ref to this vfio_device is hold and this irq belongs to
+ * the forwarded irq of this device)
+ * returns -EINVAL in the negative
+ */
+static int validate_deassign(struct kvm_vfio *kv,
+			     struct vfio_device *vdev,
+			     struct kvm_arch_forwarded_irq *fwd_irq,
+			     struct kvm_vfio_device **kvm_vdev)
+{
+	struct __kvm_arch_fwd_irq *pfwd;
+
+	*kvm_vdev = find_in_assigned_devices(kv, vdev);
+	if (!kvm_vdev) {
+		kvm_err("%s no forwarded irq for this device\n", __func__);
+		return -EINVAL;
+	}
+	pfwd = find_in_fwd_irq(*kvm_vdev, fwd_irq->irq_index);
+	if (!pfwd) {
+		kvm_err("%s irq %d is not forwarded\n", __func__, fwd_irq->fd);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * insert_and_forward - set a forwarded IRQ
+ * @kdev: the kvm device
+ * @vdev: the vfio device the IRQ belongs to
+ * @fwd_irq: the user struct containing the irq_index and guest irq
+ * @must_put: tells the caller whether the vfio_device must be put after
+ * the call (ref must be released in case a ref onto this device was
+ * wad already hold or in case of new device and failure)
+ *
+ * validate the injection, activate forward and store the information
+ * about which irq and which device is concerned so that on deassign or
+ * kvm-vfio destruction everuthing can be cleaned up.
+ */
+static int insert_and_forward(struct kvm_device *kdev,
+			      struct vfio_device *vdev,
+			      struct kvm_arch_forwarded_irq *fwd_irq,
+			      bool *must_put)
+{
+	int ret;
+	struct __kvm_arch_fwd_irq *pfwd = NULL;
+	struct kvm_vfio_device *kvm_vdev = NULL;
+	struct kvm_vfio *kv = kdev->private;
+	struct kvm_vfio_arch_data *arch_data =
+			kvm_vfio_device_get_arch_data(kv);
+	int hwirq;
+
+	*must_put = true;
+	ret = validate_forward(kv, vdev, fwd_irq, &kvm_vdev, &hwirq);
+	if (ret < 0)
+		return -EINVAL;
+
+	pfwd = kzalloc(sizeof(*pfwd), GFP_KERNEL);
+	if (!pfwd)
+		return -ENOMEM;
+
+	pfwd->irq_index = fwd_irq->irq_index;
+	pfwd->guest_irq = fwd_irq->guest_irq;
+	pfwd->hwirq = hwirq;
+	pfwd->vcpu = kvm_get_vcpu(kdev->kvm, 0);
+	ret = set_fwd_state(pfwd, KVM_VFIO_IRQ_SET_FORWARD);
+	if (ret < 0) {
+		set_fwd_state(pfwd, KVM_VFIO_IRQ_CLEANUP);
+		kfree(pfwd);
+		return ret;
+	}
+
+	if (!kvm_vdev) {
+		/* create & insert the new device and keep the ref */
+		kvm_vdev = kzalloc(sizeof(*kvm_vdev), GFP_KERNEL);
+		if (!kvm_vdev) {
+			set_fwd_state(pfwd, false);
+			kfree(pfwd);
+			return -ENOMEM;
+		}
+
+		kvm_vdev->vfio_device = vdev;
+		kvm_vdev->fd = fwd_irq->fd;
+		INIT_LIST_HEAD(&kvm_vdev->fwd_irq_list);
+		list_add(&kvm_vdev->node, &arch_data->assigned_device_list);
+		/*
+		 * the only case where we keep the ref:
+		 * new device and forward setting successful
+		 */
+		*must_put = false;
+	}
+
+	list_add(&pfwd->link, &kvm_vdev->fwd_irq_list);
+
+	kvm_debug("forwarding set for fd=%d, hwirq=%d, guest_irq=%d\n",
+		  fwd_irq->fd, hwirq, fwd_irq->guest_irq);
+
+	return 0;
+}
+
+/**
+ * cancel_and_delete_forward - remove a forwarded IRQ
+ * @kdev: the kvm device
+ * @vdev: the vfio_device
+ * @fwd_irq: user struct
+ * after checking this IRQ effectively is forwarded, change its state,
+ * remove it from the corresponding kvm_vfio_device list
+ */
+static int cancel_and_delete_forward(struct kvm_device *kdev,
+				     struct vfio_device *vdev,
+				     struct kvm_arch_forwarded_irq *fwd_irq)
+{
+	struct kvm_vfio *kv = kdev->private;
+	struct kvm_vfio_device *kvm_vdev;
+	int ret;
+
+	ret = validate_deassign(kv, vdev, fwd_irq, &kvm_vdev);
+	if (ret < 0)
+		return -EINVAL;
+
+	ret = remove_fwd_irq(kv, kvm_vdev, fwd_irq->irq_index);
+	if (ret < 0)
+		kvm_err("%s fail cancelling forward (fd=%d, index=%d)\n",
+				__func__, fwd_irq->fd, fwd_irq->irq_index);
+	else
+		kvm_debug("%s forward cancelled for IRQ (fd=%d, index=%d)\n",
+				__func__, fwd_irq->fd, fwd_irq->irq_index);
+	return ret;
+}
+
+/**
+ * kvm_vfio_set_device - the top function for interracting with a vfio
+ * device
+ */
+
+static int kvm_vfio_set_device(struct kvm_device *kdev, long attr, u64 arg)
+{
+	struct kvm_vfio *kv = kdev->private;
+	struct vfio_device *vdev;
+	struct kvm_arch_forwarded_irq fwd_irq; /* user struct */
+	int32_t __user *argp = (int32_t __user *)(unsigned long)arg;
+
+	switch (attr) {
+	case KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ:{
+		bool must_put;
+		int ret;
+
+		if (copy_from_user(&fwd_irq, argp, sizeof(fwd_irq)))
+			return -EFAULT;
+		vdev = get_vfio_device(fwd_irq.fd);
+		if (IS_ERR(vdev))
+			return PTR_ERR(vdev);
+		kvm_vfio_lock(kv);
+		ret = insert_and_forward(kdev, vdev, &fwd_irq, &must_put);
+		if (must_put)
+			put_vfio_device(vdev);
+		kvm_vfio_unlock(kv);
+		return ret;
+		}
+	case KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ: {
+		int ret;
+
+		if (copy_from_user(&fwd_irq, argp, sizeof(fwd_irq)))
+			return -EFAULT;
+		vdev = get_vfio_device(fwd_irq.fd);
+		if (IS_ERR(vdev))
+			return PTR_ERR(vdev);
+
+		kvm_vfio_device_put_external_user(vdev);
+		kvm_vfio_lock(kv);
+		ret = cancel_and_delete_forward(kdev, vdev, &fwd_irq);
+		kvm_vfio_unlock(kv);
+		return ret;
+	}
+	default:
+		return -ENXIO;
+	}
+}
+
+void kvm_arch_vfio_destroy(struct kvm_device *dev)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_arch_data *arch_data =
+			kvm_vfio_device_get_arch_data(kv);
+
+	free_all_fwd_irq(kv);
+	kfree(arch_data);
+}
+
+int kvm_arch_vfio_init(struct kvm_device *dev)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_arch_data *ptr;
+
+	ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&ptr->assigned_device_list);
+	kvm_vfio_device_set_arch_data(kv, ptr);
+	return 0;
+}
+
+
+int kvm_arch_vfio_has_attr(struct kvm_device *dev,
+			   struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_VFIO_DEVICE:
+		switch (attr->attr) {
+		case KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ:
+		case KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ:
+			return 0;
+		}
+		break;
+	}
+	return -ENXIO;
+}
+
+int kvm_arch_vfio_set_attr(struct kvm_device *dev,
+			   struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_VFIO_DEVICE:
+		return kvm_vfio_set_device(dev, attr->attr, attr->addr);
+	default:
+		return -ENXIO;
+	}
+}
+
+
-- 
1.9.1

