Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3JAUPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:15:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab3JAUPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:15:15 -0400
Subject: [PATCH 2/4] kvm/x86: Convert iommu_flags to iommu_noncoherent
To: gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 01 Oct 2013 14:15:12 -0600
Message-ID: <20131001201512.31715.19677.stgit@bling.home>
In-Reply-To: <20131001200757.31715.22994.stgit@bling.home>
References: <20131001200757.31715.22994.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Default to operating in coherent mode.  This simplifies the logic when
we switch to a model of registering and unregistering noncoherent I/O
with KVM.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |    2 +-
 arch/x86/include/asm/kvm_host.h  |    2 +-
 arch/x86/kvm/vmx.c               |    2 +-
 arch/x86/kvm/x86.c               |    2 +-
 include/linux/kvm_host.h         |    3 ---
 virt/kvm/iommu.c                 |   16 ++++++++--------
 6 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 989dd3f..1933b7a 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -480,7 +480,7 @@ struct kvm_arch {
 
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
-	int iommu_flags;
+	bool iommu_noncoherent;
 
 	unsigned long irq_sources_bitmap;
 	unsigned long irq_states[KVM_IOAPIC_NUM_PINS];
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76ff74..1b6b5f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -557,7 +557,7 @@ struct kvm_arch {
 
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
-	int iommu_flags;
+	bool iommu_noncoherent;
 	struct kvm_pic *vpic;
 	struct kvm_ioapic *vioapic;
 	struct kvm_pit *vpit;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a1216de..8b2270a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7405,7 +7405,7 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (is_mmio)
 		ret = MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
 	else if (vcpu->kvm->arch.iommu_domain &&
-		!(vcpu->kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY))
+		 vcpu->kvm->arch.iommu_noncoherent)
 		ret = kvm_get_guest_memory_type(vcpu, gfn) <<
 		      VMX_EPT_MT_EPTE_SHIFT;
 	else
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5ca72a..b1231b0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2716,7 +2716,7 @@ static void wbinvd_ipi(void *garbage)
 static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.iommu_domain &&
-		!(vcpu->kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY);
+	       vcpu->kvm->arch.iommu_noncoherent;
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0fbbc7a..f46da56 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -747,9 +747,6 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 
-/* For vcpu->arch.iommu_flags */
-#define KVM_IOMMU_CACHE_COHERENCY	0x1
-
 #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 72a130b..9cde444 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -79,7 +79,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 	flags = IOMMU_READ;
 	if (!(slot->flags & KVM_MEM_READONLY))
 		flags |= IOMMU_WRITE;
-	if (kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY)
+	if (!kvm->arch.iommu_noncoherent)
 		flags |= IOMMU_CACHE;
 
 
@@ -158,7 +158,8 @@ int kvm_assign_device(struct kvm *kvm,
 {
 	struct pci_dev *pdev = NULL;
 	struct iommu_domain *domain = kvm->arch.iommu_domain;
-	int r, last_flags;
+	int r;
+	bool noncoherent;
 
 	/* check if iommu exists and in use */
 	if (!domain)
@@ -174,15 +175,13 @@ int kvm_assign_device(struct kvm *kvm,
 		return r;
 	}
 
-	last_flags = kvm->arch.iommu_flags;
-	if (iommu_domain_has_cap(kvm->arch.iommu_domain,
-				 IOMMU_CAP_CACHE_COHERENCY))
-		kvm->arch.iommu_flags |= KVM_IOMMU_CACHE_COHERENCY;
+	noncoherent = !iommu_domain_has_cap(kvm->arch.iommu_domain,
+					    IOMMU_CAP_CACHE_COHERENCY);
 
 	/* Check if need to update IOMMU page table for guest memory */
-	if ((last_flags ^ kvm->arch.iommu_flags) ==
-			KVM_IOMMU_CACHE_COHERENCY) {
+	if (noncoherent != kvm->arch.iommu_noncoherent) {
 		kvm_iommu_unmap_memslots(kvm);
+		kvm->arch.iommu_noncoherent = noncoherent;
 		r = kvm_iommu_map_memslots(kvm);
 		if (r)
 			goto out_unmap;
@@ -350,6 +349,7 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
 	mutex_lock(&kvm->slots_lock);
 	kvm_iommu_unmap_memslots(kvm);
 	kvm->arch.iommu_domain = NULL;
+	kvm->arch.iommu_noncoherent = false;
 	mutex_unlock(&kvm->slots_lock);
 
 	iommu_domain_free(domain);

