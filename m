Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934327Ab3CTIau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:30:50 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41671 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934225Ab3CTIaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:30:46 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 1/7] KVM: MMU: introduce mmu_cache->pte_list_descs
Date: Wed, 20 Mar 2013 16:30:21 +0800
Message-Id: <1363768227-4782-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032008-9574-0000-0000-0000071F152F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This list is used to link all the pte_list_desc used by mmu cache, so
we can easily free the memory used by gfn's rmap and parent spte list

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    7 ++++---
 arch/x86/kvm/mmu.c              |   14 +++++++++++++-
 arch/x86/kvm/mmu.h              |    1 +
 arch/x86/kvm/x86.c              |    2 +-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3f205c6c..c8899c6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -526,15 +526,16 @@ struct kvm_apic_map {
 };
 
 struct kvm_arch {
+	/* MMU cache members. */
 	unsigned int n_used_mmu_pages;
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	/* Hash table of struct kvm_mmu_page. */
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
-	/*
-	 * Hash table of struct kvm_mmu_page.
-	 */
 	struct list_head active_mmu_pages;
+	struct list_head pte_list_descs;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	int iommu_flags;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c1a9b7b..dc37512 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -156,6 +156,7 @@ module_param(dbg, bool, 0644);
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
 	struct pte_list_desc *more;
+	struct list_head list;
 };
 
 struct kvm_shadow_walk_iterator {
@@ -704,11 +705,16 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	struct pte_list_desc *desc;
+
+	desc = mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	list_add(&desc->list, &vcpu->kvm->arch.pte_list_descs);
+	return desc;
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 {
+	list_del(&pte_list_desc->list);
 	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
 }
 
@@ -4337,6 +4343,12 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
 
+void kvm_mmu_cache_init(struct kvm *kvm)
+{
+	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.pte_list_descs);
+}
+
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 3b1ad00..2923fd2 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -50,6 +50,7 @@
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
 
+void kvm_mmu_cache_init(struct kvm *kvm);
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3c4787..6622ac0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6778,7 +6778,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		return -EINVAL;
 
-	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	kvm_mmu_cache_init(kvm);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
-- 
1.7.7.6

