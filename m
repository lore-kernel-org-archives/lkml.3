Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3JWNas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:30:48 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56191 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab3JWNaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:30:08 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 13/15] KVM: MMU: locklessly write-protect the page
Date: Wed, 23 Oct 2013 21:29:31 +0800
Message-Id: <1382534973-13197-14-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102313-3864-0000-0000-00000AB5854E
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
 arch/x86/include/asm/kvm_host.h |  4 ---
 arch/x86/kvm/mmu.c              | 59 ++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/mmu.h              |  6 +++++
 arch/x86/kvm/x86.c              | 11 ++++----
 4 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index df9ae10..cdb6f29 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -793,10 +793,6 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask);
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
-void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
-				     struct kvm_memory_slot *slot,
-				     gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm);
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8b96d96..d82bbec 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1386,8 +1386,37 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	return flush;
 }
 
-/**
- * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
+static void __rmap_write_protect_lockless(u64 *sptep)
+{
+	u64 spte;
+
+retry:
+	/*
+	 * Note we may partly read the sptep on 32bit host, however, we
+	 * allow this case because:
+	 * - we do not access the page got from the sptep.
+	 * - cmpxchg64 can detect that case and avoid setting a wrong value
+	 *   to the sptep.
+	 */
+	spte = *rcu_dereference(sptep);
+	if (unlikely(!is_last_spte(spte) || !is_writable_pte(spte)))
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
@@ -1396,16 +1425,17 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
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
@@ -4477,7 +4507,7 @@ void kvm_mmu_setup(struct kvm_vcpu *vcpu)
 	init_kvm_mmu(vcpu);
 }
 
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
+void kvm_mmu_slot_remove_write_access_lockless(struct kvm *kvm, int slot)
 {
 	struct kvm_memory_slot *memslot;
 	gfn_t last_gfn;
@@ -4486,8 +4516,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 	memslot = id_to_memslot(kvm->memslots, slot);
 	last_gfn = memslot->base_gfn + memslot->npages - 1;
 
-	spin_lock(&kvm->mmu_lock);
-
+	rcu_read_lock();
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		unsigned long *rmapp;
@@ -4497,15 +4526,15 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 		last_index = gfn_to_index(last_gfn, memslot->base_gfn, i);
 
 		for (index = 0; index <= last_index; ++index, ++rmapp) {
-			if (*rmapp)
-				__rmap_write_protect(kvm, rmapp, false);
+			rmap_write_protect_lockless(rmapp);
 
-			if (need_resched() || spin_needbreak(&kvm->mmu_lock))
-				cond_resched_lock(&kvm->mmu_lock);
+			if (need_resched()) {
+				rcu_read_lock();
+				rcu_read_unlock();
+			}
 		}
 	}
-
-	spin_unlock(&kvm->mmu_lock);
+	rcu_read_unlock();
 
 	/*
 	 * We can flush all the TLBs out of the mmu lock without TLB
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2926152..33f313b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -117,4 +117,10 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
 }
 
 void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm);
+
+void kvm_mmu_slot_remove_write_access_lockless(struct kvm *kvm, int slot);
+void
+kvm_mmu_write_protect_pt_masked_lockless(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn_offset, unsigned long mask);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4ac3a27..c6233e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3554,8 +3554,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	dirty_bitmap_buffer = dirty_bitmap + n / sizeof(long);
 	memset(dirty_bitmap_buffer, 0, n);
 
-	spin_lock(&kvm->mmu_lock);
-
+	rcu_read_lock();
 	for (i = 0; i < n / sizeof(long); i++) {
 		unsigned long mask;
 		gfn_t offset;
@@ -3579,10 +3578,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 		dirty_bitmap_buffer[i] = mask;
 
 		offset = i * BITS_PER_LONG;
-		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
+		kvm_mmu_write_protect_pt_masked_lockless(kvm, memslot,
+							 offset, mask);
 	}
-
-	spin_unlock(&kvm->mmu_lock);
+	rcu_read_unlock();
 
 	/*
 	 * All the TLBs can be flushed out of mmu lock, see the comments in
@@ -7246,7 +7245,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * See the comments in fast_page_fault().
 	 */
 	if ((change != KVM_MR_DELETE) && (mem->flags & KVM_MEM_LOG_DIRTY_PAGES))
-		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
+		kvm_mmu_slot_remove_write_access_lockless(kvm, mem->slot);
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
-- 
1.8.1.4

