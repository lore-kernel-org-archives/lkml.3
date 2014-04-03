Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaDCPSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:18:48 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:57955 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaDCPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:18:46 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        christophe.barnichon@st.com, Eric Auger <eric.auger@linaro.org>
Subject: [PATCH] ARM: KVM: Handle IPA unmapping on memory region deletion
Date: Thu,  3 Apr 2014 17:17:46 +0200
Message-Id: <1396538266-13245-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when a KVM region is removed using
kvm_vm_ioctl_set_memory_region (with memory region size equal to 0), the
corresponding intermediate physical memory is not unmapped.

This patch unmaps the region's IPA range in
kvm_arch_commit_memory_region using unmap_stage2_range.

The patch was tested on QEMU VFIO based use case where RAM memory region
creation/deletion frequently happens for IRQ handling.

Notes:
- the KVM_MR_MOVE case shall request some similar addition but I cannot test
  this currently

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/include/asm/kvm_mmu.h | 2 ++
 arch/arm/kvm/arm.c             | 8 ++++++++
 arch/arm/kvm/mmu.c             | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 2d122ad..a91c863 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -52,6 +52,8 @@ void kvm_free_stage2_pgd(struct kvm *kvm);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size);
 
+void unmap_stage2_range(struct kvm *kvm, phys_addr_t guest_ipa, u64 size);
+
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index bd18bb8..9a4bc10 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -241,6 +241,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *old,
 				   enum kvm_mr_change change)
 {
+	if (change == KVM_MR_DELETE) {
+		gpa_t gpa = old->base_gfn << PAGE_SHIFT;
+		u64 size = old->npages << PAGE_SHIFT;
+
+		spin_lock(&kvm->mmu_lock);
+		unmap_stage2_range(kvm, gpa, size);
+		spin_unlock(&kvm->mmu_lock);
+	}
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 7789857..e8580e2 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -443,7 +443,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
+void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 {
 	unmap_range(kvm, kvm->arch.pgd, start, size);
 }
-- 
1.9.1

