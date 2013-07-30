Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3G3NIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:08:15 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54581 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3G3NHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:07:55 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 11/12] KVM: MMU: locklessly write-protect the page
Date: Tue, 30 Jul 2013 21:02:09 +0800
Message-Id: <1375189330-24066-12-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073012-2000-0000-0000-00000D19E821
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when mark memslot dirty logged or get dirty page, we need to
write-protect large guest memory, it is the heavy work, especially, we need to
hold mmu-lock which is also required by vcpu to fix its page table fault and
mmu-notifier when host page is being changed. In the extreme cpu / memory used
guest, it becomes a scalability issue

This patch introduces a way to locklessly write-protect guest memory

Now, lockless rmap walk, lockless shadow page table access and lockless spte
wirte-protection are ready, it is the time to implements page write-protection
out of mmu-lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ---
 arch/x86/kvm/mmu.c              | 62 ++++++++++++++++++++++++++++-------------
 arch/x86/kvm/mmu.h              |  6 ++++
 arch/x86/kvm/x86.c              | 19 +++++++++----
 4 files changed, 62 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dc842b6..3ef5645 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -780,10 +780,6 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
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
index 7f3391f..a50eea8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1365,8 +1365,30 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
 	return flush;
 }
 
-/**
- * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
+static void __rmap_write_protect_lockless(u64 *sptep, int level)
+{
+	u64 spte;
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
+static void rmap_write_protect_lockless(unsigned long *rmapp, int level)
+{
+	pte_list_walk_lockless(rmapp, __rmap_write_protect_lockless, level);
+}
+
+/*
+ * kvm_mmu_write_protect_pt_masked_lockless - write protect selected PT level
+ * pages out of mmu-lock.
+ *
  * @kvm: kvm instance
  * @slot: slot to protect
  * @gfn_offset: start of the BITS_PER_LONG pages we care about
@@ -1375,16 +1397,17 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
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
+		rmap_write_protect_lockless(rmapp, PT_PAGE_TABLE_LEVEL);
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -2661,6 +2684,15 @@ set_pte:
 			++vcpu->kvm->stat.lpages;
 	}
 
+	/*
+	 * We should put the sptep into rmap before dirty log
+	 * otherwise the lockless spte write-protect path will
+	 * clear the dirty bit map but fail to find the spte.
+	 *
+	 * See the comments in kvm_vm_ioctl_get_dirty_log().
+	 */
+	smp_wmb();
+
 	if (pte_access & ACC_WRITE_MASK)
 		mark_page_dirty(vcpu->kvm, gfn);
 done:
@@ -4422,7 +4454,7 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 	return init_kvm_mmu(vcpu);
 }
 
-void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
+void kvm_mmu_slot_remove_write_access_lockless(struct kvm *kvm, int slot)
 {
 	struct kvm_memory_slot *memslot;
 	gfn_t last_gfn;
@@ -4431,8 +4463,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 	memslot = id_to_memslot(kvm->memslots, slot);
 	last_gfn = memslot->base_gfn + memslot->npages - 1;
 
-	spin_lock(&kvm->mmu_lock);
-
+	kvm_mmu_rcu_free_page_begin(kvm);
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		unsigned long *rmapp;
@@ -4441,19 +4472,12 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 		rmapp = memslot->arch.rmap[i - PT_PAGE_TABLE_LEVEL];
 		last_index = gfn_to_index(last_gfn, memslot->base_gfn, i);
 
-		for (index = 0; index <= last_index; ++index, ++rmapp) {
-			if (*rmapp)
-				__rmap_write_protect(kvm, rmapp, false);
-
-			if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-				kvm_flush_remote_tlbs(kvm);
-				cond_resched_lock(&kvm->mmu_lock);
-			}
-		}
+		for (index = 0; index <= last_index; ++index, ++rmapp)
+			rmap_write_protect_lockless(rmapp, i);
 	}
+	kvm_mmu_rcu_free_page_end(kvm);
 
 	kvm_flush_remote_tlbs(kvm);
-	spin_unlock(&kvm->mmu_lock);
 }
 
 #define BATCH_ZAP_PAGES	10
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 85405f1..2a66c57 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -137,4 +137,10 @@ static inline void kvm_mmu_rcu_free_page_end(struct kvm *kvm)
 
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
index d2caeb9..4983eb3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3531,8 +3531,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 	dirty_bitmap_buffer = dirty_bitmap + n / sizeof(long);
 	memset(dirty_bitmap_buffer, 0, n);
 
-	spin_lock(&kvm->mmu_lock);
-
+	kvm_mmu_rcu_free_page_begin(kvm);
 	for (i = 0; i < n / sizeof(long); i++) {
 		unsigned long mask;
 		gfn_t offset;
@@ -3542,17 +3541,25 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 
 		is_dirty = true;
 
+		/*
+		 * xchg acts as a full barrier that ensures
+		 * clearing dirty bitmap before read rmap.
+		 *
+		 * See the comments in set_spte().
+		 */
 		mask = xchg(&dirty_bitmap[i], 0);
+
 		dirty_bitmap_buffer[i] = mask;
 
 		offset = i * BITS_PER_LONG;
-		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
+		kvm_mmu_write_protect_pt_masked_lockless(kvm, memslot,
+							 offset, mask);
 	}
+	kvm_mmu_rcu_free_page_end(kvm);
+
 	if (is_dirty)
 		kvm_flush_remote_tlbs(kvm);
 
-	spin_unlock(&kvm->mmu_lock);
-
 	r = -EFAULT;
 	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
 		goto out;
@@ -7088,7 +7095,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * not be created until the end of the logging.
 	 */
 	if ((change != KVM_MR_DELETE) && (mem->flags & KVM_MEM_LOG_DIRTY_PAGES))
-		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
+		kvm_mmu_slot_remove_write_access_lockless(kvm, mem->slot);
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
-- 
1.8.1.4

