Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3DPGjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:39:09 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53842 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3DPGjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:39:06 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 08/15] KVM: MMU: allow unmap invalid rmap out of mmu-lock
Date: Tue, 16 Apr 2013 14:32:46 +0800
Message-Id: <1366093973-2617-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
x-cbid: 13041606-9264-0000-0000-00000388840E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_list_clear_concurrently allows us to reset pte-desc entry
out of mmu-lock. We can reset spte out of mmu-lock if we can protect the
lifecycle of sp, we use this way to achieve the goal:

unmap_memslot_rmap_nolock():
for-each-rmap-in-slot:
      preempt_disable
      kvm->arch.being_unmapped_rmap = rmapp
      clear spte and reset rmap entry
      kvm->arch.being_unmapped_rmap = NULL
      preempt_enable

Other patch like zap-sp and mmu-notify which are protected
by mmu-lock:
      clear spte and reset rmap entry
retry:
      if (kvm->arch.being_unmapped_rmap == rmap)
		goto retry
(the wait is very rare and clear one rmap is very fast, it
is not bad even if wait is needed)

Then, we can sure the spte is always available when we do
unmap_memslot_rmap_nolock

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu.c              |  114 ++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu.h              |    2 +-
 3 files changed, 110 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5fd6ed1..1ad9a34 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -536,6 +536,8 @@ struct kvm_arch {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+	unsigned long *being_unmapped_rmap;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	int iommu_flags;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2a7a5d0..e6414d2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1104,10 +1104,10 @@ static int slot_rmap_add(struct kvm_memory_slot *slot,
 	return slot->arch.ops->rmap_add(vcpu, spte, rmapp);
 }
 
-static void slot_rmap_remove(struct kvm_memory_slot *slot,
+static void slot_rmap_remove(struct kvm_memory_slot *slot, struct kvm *kvm,
 			     unsigned long *rmapp, u64 *spte)
 {
-	slot->arch.ops->rmap_remove(spte, rmapp);
+	slot->arch.ops->rmap_remove(kvm, spte, rmapp);
 }
 
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
@@ -1132,7 +1132,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	sp = page_header(__pa(spte));
 	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
 	rmapp = gfn_to_rmap(kvm, &slot, gfn, sp->role.level);
-	slot_rmap_remove(slot, rmapp, spte);
+	slot_rmap_remove(slot, kvm, rmapp, spte);
 }
 
 /*
@@ -1589,9 +1589,14 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 	return kvm_handle_hva(kvm, hva, 0, slot_rmap_test_age);
 }
 
+static void rmap_remove_spte(struct kvm *kvm, u64 *spte, unsigned long *rmapp)
+{
+	pte_list_remove(spte, rmapp);
+}
+
 static struct rmap_operations normal_rmap_ops = {
 	.rmap_add = pte_list_add,
-	.rmap_remove = pte_list_remove,
+	.rmap_remove = rmap_remove_spte,
 
 	.rmap_write_protect = __rmap_write_protect,
 
@@ -1613,9 +1618,27 @@ static int invalid_rmap_add(struct kvm_vcpu *vcpu, u64 *spte,
 	return 0;
 }
 
-static void invalid_rmap_remove(u64 *spte, unsigned long *rmapp)
+static void sync_being_unmapped_rmap(struct kvm *kvm, unsigned long *rmapp)
+{
+	/*
+	 * Ensure all the sptes on the rmap have been zapped and
+	 * the rmap's entries have been reset so that
+	 * unmap_invalid_rmap_nolock can not get any spte from the
+	 * rmap after calling sync_being_unmapped_rmap().
+	 */
+	smp_mb();
+retry:
+	if (unlikely(ACCESS_ONCE(kvm->arch.being_unmapped_rmap) == rmapp)) {
+		cpu_relax();
+		goto retry;
+	}
+}
+
+static void
+invalid_rmap_remove(struct kvm *kvm, u64 *spte, unsigned long *rmapp)
 {
 	pte_list_clear_concurrently(spte, rmapp);
+	sync_being_unmapped_rmap(kvm, rmapp);
 }
 
 static bool invalid_rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
@@ -1635,7 +1658,11 @@ static int __kvm_unmap_invalid_rmapp(unsigned long *rmapp)
 		if (sptep == PTE_LIST_SPTE_SKIP)
 			continue;
 
-		/* Do not call .rmap_remove(). */
+		/*
+		 * Do not call .rmap_remove() since we do not want to wait
+		 * on sync_being_unmapped_rmap() when all sptes should be
+		 * removed from the rmap.
+		 */
 		if (mmu_spte_clear_track_bits(sptep))
 			pte_list_clear_concurrently(sptep, rmapp);
 	}
@@ -1645,7 +1672,10 @@ static int __kvm_unmap_invalid_rmapp(unsigned long *rmapp)
 
 static int kvm_unmap_invalid_rmapp(struct kvm *kvm, unsigned long *rmapp)
 {
-	return __kvm_unmap_invalid_rmapp(rmapp);
+	int ret = __kvm_unmap_invalid_rmapp(rmapp);
+
+	sync_being_unmapped_rmap(kvm, rmapp);
+	return ret;
 }
 
 static int invalid_rmap_set_pte(struct kvm *kvm, unsigned long *rmapp,
@@ -1686,6 +1716,76 @@ static struct rmap_operations invalid_rmap_ops = {
 	.rmap_unmap = kvm_unmap_invalid_rmapp
 };
 
+typedef void (*handle_rmap_fun)(unsigned long *rmapp, void *data);
+static void walk_memslot_rmap_nolock(struct kvm_memory_slot *slot,
+				     handle_rmap_fun fun, void *data)
+{
+	int level;
+
+	for (level = PT_PAGE_TABLE_LEVEL;
+	      level < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++level) {
+		unsigned long idx, *rmapp;
+
+		rmapp = slot->arch.rmap[level - PT_PAGE_TABLE_LEVEL];
+		idx = gfn_to_index(slot->base_gfn + slot->npages - 1,
+				   slot->base_gfn, level) + 1;
+		/*
+		 * Walk ramp from the high index to low index to reduce
+		 * possible wait in sync_being_unmapped_rmap().
+		 */
+		while (idx--)
+			fun(rmapp + idx, data);
+	}
+}
+
+static void unmap_rmap_no_lock_begin(struct kvm *kvm, unsigned long *rmapp)
+{
+	preempt_disable();
+	kvm->arch.being_unmapped_rmap = rmapp;
+
+	/*
+	 * Set being_unmapped_rmap should be before read/write any
+	 * sptes on the rmaps.
+	 * See the comment in sync_being_unmapped_rmap().
+	 */
+	smp_mb();
+}
+
+static void unmap_rmap_no_lock_end(struct kvm *kvm)
+{
+	/*
+	 * Ensure clearing spte and resetting rmap's entries has
+	 * been finished.
+	 * See the comment in sync_being_unmapped_rmap().
+	 */
+	smp_mb();
+	kvm->arch.being_unmapped_rmap = NULL;
+	preempt_enable();
+}
+
+static void unmap_invalid_rmap_nolock(unsigned long *rmapp, void *data)
+{
+	struct kvm *kvm = (struct kvm *)data;
+
+	if (!ACCESS_ONCE(*rmapp))
+		return;
+
+	unmap_rmap_no_lock_begin(kvm, rmapp);
+	__kvm_unmap_invalid_rmapp(rmapp);
+	unmap_rmap_no_lock_end(kvm);
+}
+
+static void
+unmap_memslot_rmap_nolock(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	/* Only invalid rmaps can be unmapped out of mmu-lock. */
+	WARN_ON(slot->arch.ops != &invalid_rmap_ops);
+	/* Use slots_lock to protect kvm->arch.being_unmapped_rmap. */
+	WARN_ON(!mutex_is_locked(&kvm->slots_lock));
+
+	walk_memslot_rmap_nolock(slot, unmap_invalid_rmap_nolock, kvm);
+}
+
 #ifdef MMU_DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bb2b22e..d6aa31a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -117,7 +117,7 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
 struct rmap_operations {
 	int (*rmap_add)(struct kvm_vcpu *vcpu, u64 *spte,
 			unsigned long *rmap);
-	void (*rmap_remove)(u64 *spte, unsigned long *rmap);
+	void (*rmap_remove)(struct kvm *kvm, u64 *spte, unsigned long *rmap);
 
 	bool (*rmap_write_protect)(struct kvm *kvm, unsigned long *rmap,
 				   bool pt_protect);
-- 
1.7.7.6

