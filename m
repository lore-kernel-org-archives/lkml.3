Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3JCCzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 22:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab3JCCzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 22:55:19 -0400
Subject: [PATCH v2 4/4] kvm: Add VFIO device for handling IOMMU cache
 coherency
To: gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Wed, 02 Oct 2013 20:55:15 -0600
Message-ID: <20131003025134.8850.97617.stgit@bling.home>
In-Reply-To: <20131001201524.31715.4300.stgit@bling.home>
References: <20131001201524.31715.4300.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far we've succeeded at making KVM and VFIO mostly unaware of each
other, but there's an important point where that breaks down.  Intel
VT-d hardware may or may not support snoop control.  When snoop
control is available, intel-iommu promotes No-Snoop transactions on
PCIe to be cache coherent.  That allows KVM to handle things like the
x86 WBINVD opcode as a nop.  When the hardware does not support this,
KVM must implement a hardware visible WBINVD for the guest.

We could simply let userspace tell KVM how to handle WBINVD, but it's
privileged for a reason.  Allowing an arbitrary user to enable
physical WBINVD gives them more access to the hardware.  Previously,
this has only been enabled for guests supporting legacy PCI device
assignment.  In such cases it's necessary for proper guest execution.
We therefore create a new KVM-VFIO virtual device.  The user can add
and remove VFIO groups to this device via file descriptors.  KVM
makes use of the VFIO external user interface to validate that the
user has access to physical hardware and, for now, assumes the I/O
is noncoherent.  Eventually we'll add an interface to allow KVM to
determine the conherency of the domain as noted in the TODO.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: Patches 1-3 of v1 series remain the same, not resent
  - Fix cast warning from (int32_t *)u64 from get_user calls
  - Add a Kconfig variable to protect kvm_vfio_ops for archs
    not (yet) building virt/kvm/vfio.c

Both of these identified by the 0-day build bots (thanks!)

 Documentation/virtual/kvm/devices/vfio.txt |   22 ++
 arch/x86/kvm/Kconfig                       |    1 
 arch/x86/kvm/Makefile                      |    2 
 include/linux/kvm_host.h                   |    1 
 include/uapi/linux/kvm.h                   |    4 
 virt/kvm/Kconfig                           |    3 
 virt/kvm/kvm_main.c                        |    5 +
 virt/kvm/vfio.c                            |  263 ++++++++++++++++++++++++++++
 8 files changed, 300 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/virtual/kvm/devices/vfio.txt
 create mode 100644 virt/kvm/vfio.c

diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
new file mode 100644
index 0000000..ef51740
--- /dev/null
+++ b/Documentation/virtual/kvm/devices/vfio.txt
@@ -0,0 +1,22 @@
+VFIO virtual device
+===================
+
+Device types supported:
+  KVM_DEV_TYPE_VFIO
+
+Only one VFIO instance may be created per VM.  The created device
+tracks VFIO groups in use by the VM and features of those groups
+important to the correctness and acceleration of the VM.  As groups
+are enabled and disabled for use by the VM, KVM should be updated
+about their presence.  When registered with KVM, a reference to the
+VFIO-group is held by KVM.
+
+Groups:
+  KVM_DEV_VFIO_GROUP
+
+KVM_DEV_VFIO_GROUP attributes:
+  KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
+  KVM_DEV_VFIO_GROUP_DEL: Remove a VFIO group from VFIO-KVM device tracking
+
+For each, kvm_device_attr.addr points to an int32_t file descriptor
+for the VFIO group.
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index a47a3e5..b89c5db 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -38,6 +38,7 @@ config KVM
 	select PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
+	select KVM_VFIO
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index bf4fb04..25d22b2 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -9,7 +9,7 @@ KVM := ../../../virt/kvm
 
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/ioapic.o \
 				$(KVM)/coalesced_mmio.o $(KVM)/irq_comm.o \
-				$(KVM)/eventfd.o $(KVM)/irqchip.o
+				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= $(KVM)/assigned-dev.o $(KVM)/iommu.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e239c93..8a6bfa0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1082,6 +1082,7 @@ struct kvm_device *kvm_device_from_filp(struct file *filp);
 
 extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_xics_ops;
+extern struct kvm_device_ops kvm_vfio_ops;
 
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 99c2533..7c1a349 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -843,6 +843,10 @@ struct kvm_device_attr {
 #define KVM_DEV_TYPE_FSL_MPIC_20	1
 #define KVM_DEV_TYPE_FSL_MPIC_42	2
 #define KVM_DEV_TYPE_XICS		3
+#define KVM_DEV_TYPE_VFIO		4
+#define  KVM_DEV_VFIO_GROUP			1
+#define   KVM_DEV_VFIO_GROUP_ADD			1
+#define   KVM_DEV_VFIO_GROUP_DEL			2
 
 /*
  * ioctls for VM fds
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 779262f..fbe1a48 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -27,3 +27,6 @@ config HAVE_KVM_MSI
 
 config HAVE_KVM_CPU_RELAX_INTERCEPT
        bool
+
+config KVM_VFIO
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8727820..662ce0d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2273,6 +2273,11 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		ops = &kvm_xics_ops;
 		break;
 #endif
+#ifdef CONFIG_KVM_VFIO
+	case KVM_DEV_TYPE_VFIO:
+		ops = &kvm_vfio_ops;
+		break;
+#endif
 	default:
 		return -ENODEV;
 	}
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
new file mode 100644
index 0000000..2e336a7
--- /dev/null
+++ b/virt/kvm/vfio.c
@@ -0,0 +1,263 @@
+/*
+ * VFIO-KVM bridge pseudo device
+ *
+ * Copyright (C) 2013 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/kvm_host.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+
+struct kvm_vfio_group {
+	struct list_head node;
+	struct vfio_group *vfio_group;
+};
+
+struct kvm_vfio {
+	struct list_head group_list;
+	struct mutex lock;
+	bool noncoherent;
+};
+
+static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
+{
+	struct vfio_group *vfio_group;
+	struct vfio_group *(*fn)(struct file *);
+
+	fn = symbol_get(vfio_group_get_external_user);
+	if (!fn)
+		return ERR_PTR(-EINVAL);
+
+	vfio_group = fn(filep);
+
+	symbol_put(vfio_group_get_external_user);
+
+	return vfio_group;
+}
+
+static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
+{
+	void (*fn)(struct vfio_group *);
+
+	fn = symbol_get(vfio_group_put_external_user);
+	if (!fn)
+		return;
+
+	fn(vfio_group);
+
+	symbol_put(vfio_group_put_external_user);
+}
+
+/*
+ * Groups can use the same or different IOMMU domains.  If the same then
+ * adding a new group may change the coherency of groups we've previously
+ * been told about.  We don't want to care about any of that so we retest
+ * each group and bail as soon as we find one that's noncoherent.  This
+ * means we only ever [un]register_noncoherent_dma once for the whole device.
+ */
+static void kvm_vfio_update_coherency(struct kvm_device *dev)
+{
+	struct kvm_vfio *kv = dev->private;
+	bool noncoherent = false;
+	struct kvm_vfio_group *kvg;
+
+	mutex_lock(&kv->lock);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		/*
+		 * TODO: We need an interface to check the coherency of
+		 * the IOMMU domain this group is using.  For now, assume
+		 * it's always noncoherent.
+		 */
+		noncoherent = true;
+		break;
+	}
+
+	if (noncoherent != kv->noncoherent) {
+		kv->noncoherent = noncoherent;
+
+		if (kv->noncoherent)
+			kvm_arch_register_noncoherent_dma(dev->kvm);
+		else
+			kvm_arch_unregister_noncoherent_dma(dev->kvm);
+	}
+
+	mutex_unlock(&kv->lock);
+}
+
+static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct vfio_group *vfio_group;
+	struct kvm_vfio_group *kvg;
+	void __user *argp = (void __user *)arg;
+	struct fd f;
+	int32_t fd;
+	int ret;
+
+	switch (attr) {
+	case KVM_DEV_VFIO_GROUP_ADD:
+		if (get_user(fd, (int32_t __user *)argp))
+			return -EFAULT;
+
+		f = fdget(fd);
+		if (!f.file)
+			return -EBADF;
+
+		vfio_group = kvm_vfio_group_get_external_user(f.file);
+		fdput(f);
+
+		if (IS_ERR(vfio_group))
+			return PTR_ERR(vfio_group);
+
+		mutex_lock(&kv->lock);
+
+		list_for_each_entry(kvg, &kv->group_list, node) {
+			if (kvg->vfio_group == vfio_group) {
+				mutex_unlock(&kv->lock);
+				kvm_vfio_group_put_external_user(vfio_group);
+				return -EEXIST;
+			}
+		}
+
+		kvg = kzalloc(sizeof(*kvg), GFP_KERNEL);
+		if (!kvg) {
+			mutex_unlock(&kv->lock);
+			kvm_vfio_group_put_external_user(vfio_group);
+			return -ENOMEM;
+		}
+
+		list_add_tail(&kvg->node, &kv->group_list);
+		kvg->vfio_group = vfio_group;
+
+		mutex_unlock(&kv->lock);
+
+		kvm_vfio_update_coherency(dev);
+
+		return 0;
+
+	case KVM_DEV_VFIO_GROUP_DEL:
+		if (get_user(fd, (int32_t __user *)argp))
+			return -EFAULT;
+
+		f = fdget(fd);
+		if (!f.file)
+			return -EBADF;
+
+		vfio_group = kvm_vfio_group_get_external_user(f.file);
+		fdput(f);
+
+		if (IS_ERR(vfio_group))
+			return PTR_ERR(vfio_group);
+
+		ret = -ENOENT;
+
+		mutex_lock(&kv->lock);
+
+		list_for_each_entry(kvg, &kv->group_list, node) {
+			if (kvg->vfio_group != vfio_group)
+				continue;
+
+			list_del(&kvg->node);
+			kvm_vfio_group_put_external_user(kvg->vfio_group);
+			kfree(kvg);
+			ret = 0;
+			break;
+		}
+
+		mutex_unlock(&kv->lock);
+
+		kvm_vfio_group_put_external_user(vfio_group);
+
+		kvm_vfio_update_coherency(dev);
+
+		return ret;
+	}
+
+	return -ENXIO;
+}
+
+static int kvm_vfio_set_attr(struct kvm_device *dev,
+			     struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_VFIO_GROUP:
+		return kvm_vfio_set_group(dev, attr->attr, attr->addr);
+	}
+
+	return -ENXIO;
+}
+
+static int kvm_vfio_has_attr(struct kvm_device *dev,
+			     struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_VFIO_GROUP:
+		switch (attr->attr) {
+		case KVM_DEV_VFIO_GROUP_ADD:
+		case KVM_DEV_VFIO_GROUP_DEL:
+			return 0;
+		}
+
+		break;
+	}
+
+	return -ENXIO;
+}
+
+static void kvm_vfio_destroy(struct kvm_device *dev)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct kvm_vfio_group *kvg, *tmp;
+
+	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
+		kvm_vfio_group_put_external_user(kvg->vfio_group);
+		list_del(&kvg->node);
+		kfree(kvg);
+	}
+
+	kvm_vfio_update_coherency(dev);
+
+	kfree(kv);
+}
+
+static int kvm_vfio_create(struct kvm_device *dev, u32 type)
+{
+	struct kvm_device *tmp;
+	struct kvm_vfio *kv;
+
+	/* Only one VFIO "device" per VM */
+	list_for_each_entry(tmp, &dev->kvm->devices, vm_node)
+		if (tmp->ops == &kvm_vfio_ops)
+			return -EBUSY;
+
+	kv = kzalloc(sizeof(*kv), GFP_KERNEL);
+	if (!kv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&kv->group_list);
+	mutex_init(&kv->lock);
+
+	dev->private = kv;
+
+	return 0;
+}
+
+struct kvm_device_ops kvm_vfio_ops = {
+	.name = "kvm-vfio",
+	.create = kvm_vfio_create,
+	.destroy = kvm_vfio_destroy,
+	.set_attr = kvm_vfio_set_attr,
+	.has_attr = kvm_vfio_has_attr,
+};

