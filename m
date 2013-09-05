Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267Ab3IEKa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:30:56 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58593 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935733Ab3IEK3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:49 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 13/15] KVM: MMU: locklessly write-protect the page
Date: Thu,  5 Sep 2013 18:29:16 +0800
Message-Id: <1378376958-27252-14-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-0260-0000-0000-000003936B2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when mark memslot dirty logged or get dirty page, we need to
write-protect large guest memory, it is the heavy work, especially, we
need to hold mmu-lock which is also required by vcpu to fix its page table
fault and mmu-notifier when host page is being changed. In the extreme
cpu / memory used guest, it becomes a scalability issue

This patch introduces a way to locklessly write-protect guest memory

Now, lockless rmap walk, lockless shadow page table access and lockless
spte wirte-protection are ready, it is the time to implements page
write-protection out of mmu-lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ----
 arch/x86/kvm/mmu.c              | 53 +++++++++++++++++++++++++++++------------
 arch/x86/kvm/mmu.h              |  6 +++++
 arch/x86/kvm/x86.c              | 11 ++++-----
 4 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8e4ca0d..00b44b1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -789,10 +789,6 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask);
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
-void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
-				     struct kvm_memory_slot *slot,
-				     gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f551fc7..44b7822 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1376,8 +1376,31 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	return flush;
 }
 
-/**
- * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
+static void __rmap_write_protect_lockless(u64 *sptep)
+{
+	u64 spte;
+	int level = page_header(__pa(sptep))->role.level;
+
+retry:
+	spte = mmu_spte_get_lockless(sptep);
+	if (unlikely(!is_last_spte(spte, level) || !is_writable_pte(spte)))
+		return;
+
+	if (likely(cmpxchg64(sptep, spte, spte & ~PT_WRITABLE_MASK) == spte))
+		return;
+
+	goto retry;
+}
+
+static void rmap_write_protect_lockless(unsigned long *rmapp)
+{
+	pte_list_walk_lockless(rmapp, __rmap_write_protect_lockless);
+}
+
+/*
+ * kvm_mmu_write_protect_pt_masked_lockless - write protect selected PT level
+ * pages out of mmu-lock.
+ *
  * @kvm: kvm instance
  * @slot: slot to protect
  * @gfn_offset: start of the BITS_PER_LONG pages we care about
@@ -1386,16 +1409,17 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
  * Used when we do not need to care about huge page mappings: e.g. during dirty
  * logging we do not have any such mappings.
  */
-void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
-				     struct kvm_memory_slot *slot,
-				     gfn_t gfn_offset, unsigned long mask)
+void
+kvm_mmu_write_protect_pt_masked_lockless(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn_offset, unsigned long mask)
 {
 	unsigned long *rmapp;
 
 	while (mask) {
 		rmapp = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 				      PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmapp, false);
+		rmap_write_protect_lockless(rmapp);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -4547,7 +4571,7 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 	return init_kvm_mmu(vcpu);
 }
 
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
+void kvm_mmu_slot_remove_write_access_lockless(struct kvm *kvm, int slot)
 {
 	struct kvm_memory_slot *memslot;
 	gfn_t last_gfn;
@@ -4556,8 +4580,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 	memslot = id_to_memslot(kvm->memslots, slot);
 	last_gfn = memslot->base_gfn + memslot->npages - 1;
 
-	spin_lock(&kvm->mmu_lock);
-
+	kvm_mmu_rcu_free_page_begin(kvm);
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		unsigned long *rmapp;
@@ -4567,15 +4590,15 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 		last_index = gfn_to_index(last_gfn, memslot->base_gfn, i);
 
 		for (index = 0; index <= last_index; ++index, ++rmapp) {
-			if (*rmapp)
-				__rmap_write_protect(kvm, rmapp, false);
+			rmap_write_protect_lockless(rmapp);
 
-			if (need_resched() || spin_needbreak(&kvm->mmu_lock))
-				cond_resched_lock(&kvm->mmu_lock);
+			if (need_resched()) {
+				kvm_mmu_rcu_free_page_end(kvm);
+				kvm_mmu_rcu_free_page_begin(kvm);
+			}
 		}
 	}
-
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_rcu_free_page_end(kvm);
 
 	/*
 	 * We can flush all the TLBs out of the mmu lock without TLB
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 61217f3..2ac649e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -139,4 +139,10 @@ static inline void kvm_mmu_rcu_free_page_end(struct kvm *kvm)
 
 	rcu_read_unlock();
 }
+
+void kvm_mmu_slot_remove_write_access_lockless(struct kvm *kvm, int slot);
+void
+kvm_mmu_write_protect_pt_masked_lockless(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn_offset, unsigned long mask);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5582b66..33d483a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3543,8 +3543,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	dirty_bitmap_buffer = dirty_bitmap + n / sizeof(long);
 	memset(dirty_bitmap_buffer, 0, n);
 
-	spin_lock(&kvm->mmu_lock);
-
+	kvm_mmu_rcu_free_page_begin(kvm);
 	for (i = 0; i < n / sizeof(long); i++) {
 		unsigned long mask;
 		gfn_t offset;
@@ -3568,10 +3567,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 		dirty_bitmap_buffer[i] = mask;
 
 		offset = i * BITS_PER_LONG;
-		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
+		kvm_mmu_write_protect_pt_masked_lockless(kvm, memslot,
+							 offset, mask);
 	}
-
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_rcu_free_page_end(kvm);
 
 	/*
 	 * All the TLBs can be flushed out of mmu lock, see the comments in
@@ -7231,7 +7230,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * See the comments in fast_page_fault().
 	 */
 	if ((change != KVM_MR_DELETE) && (mem->flags & KVM_MEM_LOG_DIRTY_PAGES))
-		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
+		kvm_mmu_slot_remove_write_access_lockless(kvm, mem->slot);
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
-- 
1.8.1.4

