Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3JDMYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:24:20 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46525 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab3JDMYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:24:18 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] PPC: KVM: vfio kvm device: support spapr tce
Date: Fri,  4 Oct 2013 22:24:10 +1000
Message-Id: <1380889450-25550-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.4.rc4
In-Reply-To: <20131001200757.31715.22994.stgit@bling.home>
References: <20131001200757.31715.22994.stgit@bling.home>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100412-3568-0000-0000-000004576694
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a very rough change set required for ppc64 to use this KVM device.

vfio_rm.c is a piece of code which is going to be called from the realmode (MMU off),
and I will put everything spapr-related under #ifdef CONFIG_SPAPR_TCE_IOMMU,
it is just friday and I have to run :)

This is an RFC but it works.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/Kconfig  |  1 +
 arch/powerpc/kvm/Makefile |  4 ++++
 include/linux/kvm_host.h  |  8 ++++---
 include/linux/vfio.h      |  3 +++
 include/uapi/linux/kvm.h  |  1 +
 virt/kvm/vfio.c           | 46 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/vfio_rm.c        | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 114 insertions(+), 3 deletions(-)
 create mode 100644 virt/kvm/vfio_rm.c

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 61b3535..d1b7f64 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -60,6 +60,7 @@ config KVM_BOOK3S_64
 	select KVM_BOOK3S_64_HANDLER
 	select KVM
 	select SPAPR_TCE_IOMMU
+	select KVM_VFIO
 	---help---
 	  Support running unmodified book3s_64 and book3s_32 guest kernels
 	  in virtual machines on book3s_64 host processors.
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 6646c95..fc2878b 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -55,6 +55,8 @@ kvm-objs-$(CONFIG_KVM_E500MC) := $(kvm-e500mc-objs)
 
 kvm-book3s_64-objs-$(CONFIG_KVM_BOOK3S_64_PR) := \
 	$(KVM)/coalesced_mmio.o \
+	$(KVM)/vfio.o \
+	$(KVM)/vfio_rm.o \
 	fpu.o \
 	book3s_paired_singles.o \
 	book3s_pr.o \
@@ -76,6 +78,7 @@ kvm-book3s_64-objs-$(CONFIG_KVM_BOOK3S_64_HV) := \
 kvm-book3s_64-builtin-xics-objs-$(CONFIG_KVM_XICS) := \
 	book3s_hv_rm_xics.o
 kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HV) := \
+	$(KVM)/vfio_rm.o \
 	book3s_hv_rmhandlers.o \
 	book3s_hv_rm_mmu.o \
 	book3s_64_vio_hv.o \
@@ -89,6 +92,7 @@ kvm-book3s_64-objs-$(CONFIG_KVM_XICS) += \
 
 kvm-book3s_64-module-objs := \
 	$(KVM)/kvm_main.o \
+	$(KVM)/vfio.o \
 	$(KVM)/eventfd.o \
 	powerpc.o \
 	emulate.o \
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ad2b581..43c0290 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -407,6 +407,8 @@ struct kvm {
 #endif
 	long tlbs_dirty;
 	struct list_head devices;
+
+	struct kvm_vfio *vfio;
 };
 
 #define kvm_err(fmt, ...) \
@@ -677,15 +679,15 @@ void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
 bool kvm_arch_has_noncoherent_dma(struct kvm *kvm);
 #else
-static inline void kvm_arch_register_noncoherent_dma(void)
+static inline void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 {
 }
 
-static inline void kvm_arch_unregister_noncoherent_dma(void)
+static inline void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
 {
 }
 
-static inline bool kvm_arch_has_noncoherent_dma(void)
+static inline bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 {
 	return false;
 }
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 24579a0..681e19b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -97,4 +97,7 @@ extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
 
+extern struct iommu_group *vfio_find_group_by_liobn(struct kvm *kvm,
+		unsigned long liobn);
+
 #endif /* VFIO_H */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7c1a349..a74ad16 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -847,6 +847,7 @@ struct kvm_device_attr {
 #define  KVM_DEV_VFIO_GROUP			1
 #define   KVM_DEV_VFIO_GROUP_ADD			1
 #define   KVM_DEV_VFIO_GROUP_DEL			2
+#define  KVM_DEV_VFIO_SPAPR_TCE_LIOBN		2
 
 /*
  * ioctls for VM fds
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 2e336a7..39dea9f 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -22,6 +22,7 @@
 struct kvm_vfio_group {
 	struct list_head node;
 	struct vfio_group *vfio_group;
+	uint64_t liobn; /* sPAPR */
 };
 
 struct kvm_vfio {
@@ -188,12 +189,52 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 	return -ENXIO;
 }
 
+static int kvm_vfio_set_spapr_tce_liobn(struct kvm_device *dev,
+		long attr, u64 arg)
+{
+	struct kvm_vfio *kv = dev->private;
+	struct vfio_group *vfio_group;
+	struct kvm_vfio_group *kvg;
+	void __user *argp = (void __user *)arg;
+	struct fd f;
+	int32_t fd;
+	uint64_t liobn = attr;
+
+	if (get_user(fd, (int32_t __user *)argp))
+		return -EFAULT;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	vfio_group = kvm_vfio_group_get_external_user(f.file);
+	fdput(f);
+
+	list_for_each_entry(kvg, &kv->group_list, node) {
+		if (kvg->vfio_group == vfio_group) {
+			WARN_ON(kvg->liobn);
+			kvg->liobn = liobn;
+			kvm_vfio_group_put_external_user(vfio_group);
+			return 0;
+		}
+	}
+
+	kvm_vfio_group_put_external_user(vfio_group);
+
+	return -ENXIO;
+}
+
 static int kvm_vfio_set_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
 	case KVM_DEV_VFIO_GROUP:
 		return kvm_vfio_set_group(dev, attr->attr, attr->addr);
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	case KVM_DEV_VFIO_SPAPR_TCE_LIOBN:
+		return kvm_vfio_set_spapr_tce_liobn(dev, attr->attr,
+				attr->addr);
+#endif
 	}
 
 	return -ENXIO;
@@ -211,6 +252,10 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 		}
 
 		break;
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	case KVM_DEV_VFIO_SPAPR_TCE_LIOBN:
+		return 0;
+#endif
 	}
 
 	return -ENXIO;
@@ -250,6 +295,7 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
 	mutex_init(&kv->lock);
 
 	dev->private = kv;
+	dev->kvm->vfio = kv;
 
 	return 0;
 }
diff --git a/virt/kvm/vfio_rm.c b/virt/kvm/vfio_rm.c
new file mode 100644
index 0000000..ee9fd96
--- /dev/null
+++ b/virt/kvm/vfio_rm.c
@@ -0,0 +1,54 @@
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
+	uint64_t liobn; /* sPAPR */
+};
+
+struct kvm_vfio {
+	struct list_head group_list;
+	struct mutex lock;
+	bool noncoherent;
+};
+
+struct vfio_group {
+	struct kref			kref;
+	int				minor;
+	atomic_t			container_users;
+	struct iommu_group		*iommu_group;
+	struct vfio_container		*container;
+	struct list_head		device_list;
+	struct mutex			device_lock;
+	struct device			*dev;
+	struct notifier_block		nb;
+	struct list_head		vfio_next;
+	struct list_head		container_next;
+	atomic_t			opened;
+};
+
+struct iommu_group *vfio_find_group_by_liobn(struct kvm *kvm, unsigned long liobn)
+{
+	struct kvm_vfio_group *kvg;
+
+	if (!kvm->vfio)
+		return NULL;
+
+	list_for_each_entry(kvg, &kvm->vfio->group_list, node) {
+		if (kvg->liobn == liobn)
+			return kvg->vfio_group->iommu_group;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_find_group_by_liobn);
+
+
-- 
1.8.4.rc4

