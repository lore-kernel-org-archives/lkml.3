Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3DPGfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:35:38 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50707 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3DPGfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:35:36 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 15/15] KVM: MMU: replace kvm_zap_all with kvm_mmu_invalid_all_pages
Date: Tue, 16 Apr 2013 14:32:53 +0800
Message-Id: <1366093973-2617-16-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-2000-0000-0000-00000BBF6407
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kvm_mmu_invalid_all_pages in kvm_arch_flush_shadow_all and
rename kvm_zap_all to kvm_free_all which is used to free all
memmory used by kvm mmu when vm is being destroyed, at this time,
no vcpu exists and mmu-notify has been unregistered, so we can
free the shadow pages out of mmu-lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |   15 ++-------------
 arch/x86/kvm/x86.c              |    9 ++++-----
 3 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6f8ee18..a336055 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -771,7 +771,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
 void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     gfn_t gfn_offset, unsigned long mask);
-void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_mmu_free_all(struct kvm *kvm);
 void kvm_arch_init_generation(struct kvm *kvm);
 void kvm_mmu_invalid_mmio_sptes(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 12129b7..10c43ea 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4639,28 +4639,17 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 	spin_unlock(&kvm->mmu_lock);
 }
 
-void kvm_mmu_zap_all(struct kvm *kvm)
+void kvm_mmu_free_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
 
-	might_sleep();
-
-	spin_lock(&kvm->mmu_lock);
 restart:
-	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
+	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
 			goto restart;
 
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_commit_zap_page(kvm, &invalid_list);
-			cond_resched_lock(&kvm->mmu_lock);
-			goto restart;
-		}
-	}
-
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	spin_unlock(&kvm->mmu_lock);
 }
 
 static void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3dd0d5..4bb88f5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6840,6 +6840,7 @@ void kvm_arch_sync_events(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	kvm_mmu_free_all(kvm);
 	kvm_iommu_unmap_guest(kvm);
 	kfree(kvm->arch.vpic);
 	kfree(kvm->arch.vioapic);
@@ -7056,11 +7057,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	int idx;
-
-	idx = srcu_read_lock(&kvm->srcu);
-	kvm_mmu_zap_all(kvm);
-	srcu_read_unlock(&kvm->srcu, idx);
+	mutex_lock(&kvm->slots_lock);
+	kvm_mmu_invalid_memslot_pages(kvm, INVALID_ALL_SLOTS);
+	mutex_unlock(&kvm->slots_lock);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
1.7.7.6

