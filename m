Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3JAUP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:15:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab3JAUPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:15:21 -0400
Subject: [PATCH 3/4] kvm: Create non-coherent DMA registeration
To: gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 01 Oct 2013 14:15:18 -0600
Message-ID: <20131001201518.31715.50233.stgit@bling.home>
In-Reply-To: <20131001200757.31715.22994.stgit@bling.home>
References: <20131001200757.31715.22994.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently use some ad-hoc arch variables tied to legacy KVM device
assignment to manage emulation of instructions that depend on whether
non-coherent DMA is present.  Create an interface for this so that we
can register coherency for other devices, like vfio assigned devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/vmx.c              |    3 +--
 arch/x86/kvm/x86.c              |   21 +++++++++++++++++++--
 include/linux/kvm_host.h        |   19 +++++++++++++++++++
 virt/kvm/iommu.c                |    6 ++++++
 5 files changed, 47 insertions(+), 4 deletions(-)

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
index 8b2270a..a982c9e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7404,8 +7404,7 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
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
index b1231b0..feec86d 100644
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
@@ -7420,6 +7419,24 @@ bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
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
index f46da56..e239c93 100644
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
+static inline void kvm_arch_register_noncoherent_dma(void)
+{
+}
+
+static inline void kvm_arch_unregister_noncoherent_dma(void)
+{
+}
+
+static inline bool kvm_arch_has_noncoherent_dma(void)
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
 

