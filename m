Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3KEIGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:06:02 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53219 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3KEIF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:05:57 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2] KVM: PPC: vfio kvm device: support spapr tce
Date: Tue,  5 Nov 2013 19:05:31 +1100
Message-Id: <1383638731-13467-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.4.rc4
In-Reply-To: <20131030165234.31949.70266.stgit@bling.home>
References: <20131030165234.31949.70266.stgit@bling.home>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110508-3568-0000-0000-0000048287D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

Changes:
v2:
* it does not try to introduce a realmode search function.
Instead, liobn-to-iommu-group lookup is done by VFIO KVM device
in virtual mode and the result (iommu_group pointer) is cached
in kvm_arch so the realmode handlers do not use VFIO KVM device for that.
And the iommu groups get released on KVM termination.

I tried this, seems viable.

Did not I miss anything? Thanks.


---
 arch/powerpc/include/asm/kvm_host.h |  3 ++
 arch/powerpc/kvm/Kconfig            |  1 +
 arch/powerpc/kvm/Makefile           |  3 ++
 include/linux/vfio.h                |  3 ++
 include/uapi/linux/kvm.h            |  1 +
 virt/kvm/vfio.c                     | 74 +++++++++++++++++++++++++++++++++++++
 6 files changed, 85 insertions(+)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 48dbe8b..e1163d7 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -293,6 +293,9 @@ struct kvm_arch {
 #ifdef CONFIG_KVM_XICS
 	struct kvmppc_xics *xics;
 #endif
+#ifdef CONFIG_KVM_VFIO
+	struct kvm_vfio *vfio;
+#endif
 };
 
 /*
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
index 6646c95..2438d2e 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -87,6 +87,9 @@ kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HV) := \
 kvm-book3s_64-objs-$(CONFIG_KVM_XICS) += \
 	book3s_xics.o
 
+kvm-book3s_64-objs-$(CONFIG_KVM_VFIO) += \
+	$(KVM)/vfio.o \
+
 kvm-book3s_64-module-objs := \
 	$(KVM)/kvm_main.o \
 	$(KVM)/eventfd.o \
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
index ca4260e..f9271d5 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -22,6 +22,9 @@
 struct kvm_vfio_group {
 	struct list_head node;
 	struct vfio_group *vfio_group;
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	uint64_t liobn;
+#endif
 };
 
 struct kvm_vfio {
@@ -188,12 +191,76 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 	return -ENXIO;
 }
 
+#ifdef CONFIG_SPAPR_TCE_IOMMU
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
+struct iommu_group *vfio_find_group_by_liobn(struct kvm *kvm,
+		unsigned long liobn)
+{
+	struct kvm_vfio_group *kvg;
+
+	if (!kvm->arch.vfio)
+		return NULL;
+
+	list_for_each_entry(kvg, &kvm->arch.vfio->group_list, node) {
+		if (kvg->liobn == liobn) {
+			int group_id = vfio_external_user_iommu_id(
+					kvg->vfio_group);
+			struct iommu_group *grp =
+					iommu_group_get_by_id(group_id);
+			return grp;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_find_group_by_liobn);
+#endif
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
@@ -211,6 +278,10 @@ static int kvm_vfio_has_attr(struct kvm_device *dev,
 		}
 
 		break;
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	case KVM_DEV_VFIO_SPAPR_TCE_LIOBN:
+		return 0;
+#endif
 	}
 
 	return -ENXIO;
@@ -251,6 +322,9 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
 	mutex_init(&kv->lock);
 
 	dev->private = kv;
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	dev->kvm->arch.vfio = kv;
+#endif
 
 	return 0;
 }
-- 
1.8.4.rc4

