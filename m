Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3CME4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:56:47 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36449 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3CME4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:56:46 -0400
Message-ID: <51400705.9080405@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 12:56:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/6] KVM: MMU: introduce mmu_cache->pte_list_descs
References: <514006AC.2020904@linux.vnet.ibm.com>
In-Reply-To: <514006AC.2020904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031304-9264-0000-0000-0000035267A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This list is used to link all the pte_list_desc used by mmu cache, so
we can easily free the memory used by gfn's rmap and parent spte list

[ The new function name: kvm_mmu_init is vey similar with init_kvm_mmu
  which actually init vcpu mmu, will rename init_kvm_mmu to init_vcpu_mmu ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
 ---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   14 +++++++++++++-
 arch/x86/kvm/mmu.h              |    1 +
 arch/x86/kvm/x86.c              |    2 +-
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85291b08..04d8897 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -535,6 +535,7 @@ struct kvm_mmu_cache {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	struct list_head pte_list_descs;
 };

 struct kvm_arch {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c52d147..4152766 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -156,6 +156,7 @@ module_param(dbg, bool, 0644);
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
 	struct pte_list_desc *more;
+	struct list_head list;
 };

 struct kvm_shadow_walk_iterator {
@@ -701,11 +702,16 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)

 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	struct pte_list_desc *desc;
+
+	desc = mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	list_add(&desc->list, &vcpu->kvm->arch.mmu_cache.pte_list_descs);
+	return desc;
 }

 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 {
+	list_del(&pte_list_desc->list);
 	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
 }

@@ -4320,6 +4326,12 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);

+void kvm_mmu_init(struct kvm *kvm)
+{
+	INIT_LIST_HEAD(&kvm->arch.mmu_cache.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.mmu_cache.pte_list_descs);
+}
+
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2e61c24..76adc5f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -50,6 +50,7 @@
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)

+void kvm_mmu_init(struct kvm *kvm);
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cb899c..7083568 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6757,7 +6757,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		return -EINVAL;

-	INIT_LIST_HEAD(&kvm->arch.mmu_cache.active_mmu_pages);
+	kvm_mmu_init(kvm);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);

 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
-- 
1.7.7.6

