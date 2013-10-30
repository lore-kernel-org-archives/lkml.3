Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3J3RCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:02:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3J3RCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:02:33 -0400
Subject: [PATCH v2 3/3] kvm: Create non-coherent DMA registeration
To: pbonzini@redhat.com, kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2013 11:02:30 -0600
Message-ID: <20131030170230.31949.34523.stgit@bling.home>
In-Reply-To: <20131030165234.31949.70266.stgit@bling.home>
References: <20131030165234.31949.70266.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently use some ad-hoc arch variables tied to legacy KVM device
assignment to manage emulation of instructions that depend on whether
non-coherent DMA is present.  Create an interface for this, adapting
legacy KVM device assignment and adding VFIO via the KVM-VFIO device.
For now we assume that non-coherent DMA is possible any time we have a
VFIO group.  Eventually an interface can be developed as part of the
VFIO external user interface to query the coherency of a group.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/vmx.c              |    3 +--
 arch/x86/kvm/x86.c              |   22 ++++++++++++++++++--
 include/linux/kvm_host.h        |   19 +++++++++++++++++
 virt/kvm/iommu.c                |    6 +++++
 virt/kvm/vfio.c                 |   44 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1b6b5f9..50c1e9c1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -558,6 +558,8 @@ struct kvm_arch {
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
+#define __KVM_HAVE_ARCH_NONCOHERENT_DMA
+	atomic_t noncoherent_dma_count;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5d0e3ab..f7fe08a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7410,8 +7410,7 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	 */
 	if (is_mmio)
 		ret = MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
-	else if (vcpu->kvm->arch.iommu_domain &&
-		 vcpu->kvm->arch.iommu_noncoherent)
+	else if (kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		ret = kvm_get_guest_memory_type(vcpu, gfn) <<
 		      VMX_EPT_MT_EPTE_SHIFT;
 	else
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b1231b0..92e1722 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2715,8 +2715,7 @@ static void wbinvd_ipi(void *garbage)
 
 static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 {
-	return vcpu->kvm->arch.iommu_domain &&
-	       vcpu->kvm->arch.iommu_noncoherent;
+	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -6981,6 +6980,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
+	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
@@ -7420,6 +7420,24 @@ bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
 			kvm_x86_ops->interrupt_allowed(vcpu);
 }
 
+void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
+{
+	atomic_inc(&kvm->arch.noncoherent_dma_count);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
+
+void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
+{
+	atomic_dec(&kvm->arch.noncoherent_dma_count);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
+
+bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
+{
+	return atomic_read(&kvm->arch.noncoherent_dma_count);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 46ce3d1..a225349 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -671,6 +671,25 @@ static inline void kvm_arch_free_vm(struct kvm *kvm)
 }
 #endif
 
+#ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
+void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
+void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
+bool kvm_arch_has_noncoherent_dma(struct kvm *kvm);
+#else
+static inline void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
+{
+}
+
+static inline void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
+{
+}
+
+static inline bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
 {
 #ifdef __KVM_HAVE_ARCH_WQP
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 9cde444..0a54456 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -140,6 +140,9 @@ static int kvm_iommu_map_memslots(struct kvm *kvm)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 
+	if (kvm->arch.iommu_noncoherent)
+		kvm_arch_register_noncoherent_dma(kvm);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
 
@@ -335,6 +338,9 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
+	if (kvm->arch.iommu_noncoherent)
+		kvm_arch_unregister_noncoherent_dma(kvm);
+
 	return 0;
 }
 
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 597c258..ca4260e 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -27,6 +27,7 @@ struct kvm_vfio_group {
 struct kvm_vfio {
 	struct list_head group_list;
 	struct mutex lock;
+	bool noncoherent;
 };
 
 static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
@@ -58,6 +59,43 @@ static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 	symbol_put(vfio_group_put_external_user);
 }
 
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
 static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 {
 	struct kvm_vfio *kv = dev->private;
@@ -105,6 +143,8 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 
 		mutex_unlock(&kv->lock);
 
+		kvm_vfio_update_coherency(dev);
+
 		return 0;
 
 	case KVM_DEV_VFIO_GROUP_DEL:
@@ -140,6 +180,8 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 
 		kvm_vfio_group_put_external_user(vfio_group);
 
+		kvm_vfio_update_coherency(dev);
+
 		return ret;
 	}
 
@@ -185,6 +227,8 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 		kfree(kvg);
 	}
 
+	kvm_vfio_update_coherency(dev);
+
 	kfree(kv);
 	kfree(dev); /* alloc by kvm_ioctl_create_device, free by .destroy */
 }

