Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3DPGfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:35:31 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:39971 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab3DPGf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:35:28 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 12/15] KVM: MMU: fast invalid all shadow pages
Date: Tue, 16 Apr 2013 14:32:50 +0800
Message-Id: <1366093973-2617-13-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-5564-0000-0000-00000784D232
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
walk and zap all shadow pages one by one, also it need to zap all guest
page's rmap and all shadow page's parent spte list. Particularly, things
become worse if guest uses more memory or vcpus. It is not good for
scalability.

In this patch, we introduce a faster way to invalid all shadow pages.
KVM maintains a global mmu invalid generation-number which is stored in
kvm->arch.mmu_valid_gen and every shadow page stores the current global
generation-number into sp->mmu_valid_gen when it is created.

When KVM need zap all shadow pages sptes, it just simply increase the
global generation-number then reload root shadow pages on all vcpus.
Vcpu will create a new shadow page table according to current kvm's
generation-number. It ensures the old pages are not used any more.

The invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
are keeped in mmu-cache until page allocator reclaims page.

If the invalidation is due to memslot changed, its rmap amd lpage-info
will be freed soon, in order to avoiding use invalid memory, we unmap
all sptes on its rmap and always reset the large-info all memslots so
that rmap and lpage info can be safely freed.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu.c              |   85 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu.h              |    4 ++
 arch/x86/kvm/x86.c              |    6 +++
 4 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1ad9a34..6f8ee18 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -223,6 +223,7 @@ struct kvm_mmu_page {
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
+	unsigned long mmu_valid_gen;
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 #ifdef CONFIG_X86_32
@@ -531,6 +532,7 @@ struct kvm_arch {
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	unsigned long mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9ac584f..12129b7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1732,6 +1732,11 @@ static struct rmap_operations invalid_rmap_ops = {
 	.rmap_unmap = kvm_unmap_invalid_rmapp
 };
 
+static void init_invalid_memslot_rmap_ops(struct kvm_memory_slot *slot)
+{
+	slot->arch.ops = &invalid_rmap_ops;
+}
+
 typedef void (*handle_rmap_fun)(unsigned long *rmapp, void *data);
 static void walk_memslot_rmap_nolock(struct kvm_memory_slot *slot,
 				     handle_rmap_fun fun, void *data)
@@ -1812,6 +1817,65 @@ void free_meslot_rmap_desc_nolock(struct kvm_memory_slot *slot)
 	walk_memslot_rmap_nolock(slot, free_rmap_desc_nolock, NULL);
 }
 
+/*
+ * Fast invalid all shadow pages belong to @slot.
+ *
+ * @slot != NULL means the invalidation is caused the memslot specified
+ * by @slot is being deleted, in this case, we should ensure that rmap
+ * and lpage-info of the @slot can not be used after calling the function.
+ * Specially, if @slot is INVALID_ALL_SLOTS, all slots will be deleted
+ * soon, it always happens when kvm is being destroyed.
+ *
+ * @slot == NULL means the invalidation due to other reasons, we need
+ * not care rmap and lpage-info since they are still valid after calling
+ * the function.
+ */
+void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
+{
+	struct kvm_memory_slot *each_slot;
+
+	spin_lock(&kvm->mmu_lock);
+	kvm->arch.mmu_valid_gen++;
+
+	if (slot == INVALID_ALL_SLOTS)
+		kvm_for_each_memslot(each_slot, kvm_memslots(kvm))
+			init_invalid_memslot_rmap_ops(each_slot);
+	else if (slot)
+		init_invalid_memslot_rmap_ops(slot);
+
+	/*
+	 * All shadow paes are invalid, reset the large page info,
+	 * then we can safely desotry the memslot, it is also good
+	 * for large page used.
+	 */
+	kvm_clear_all_lpage_info(kvm);
+
+	/*
+	 * Notify all vcpus to reload its shadow page table
+	 * and flush TLB. Then all vcpus will switch to new
+	 * shadow page table with the new mmu_valid_gen.
+	 *
+	 * Note: we should do this under the protection of
+	 * mmu-lock, otherwise, vcpu would purge shadow page
+	 * but miss tlb flush.
+	 */
+	kvm_reload_remote_mmus(kvm);
+	spin_unlock(&kvm->mmu_lock);
+
+	if (slot == INVALID_ALL_SLOTS)
+		kvm_for_each_memslot(each_slot, kvm_memslots(kvm))
+			unmap_memslot_rmap_nolock(kvm, each_slot);
+	else if (slot)
+		unmap_memslot_rmap_nolock(kvm, slot);
+
+	/*
+	 * To ensure that all vcpus and mmu-notify are not clearing
+	 * spte and rmap entry.
+	 */
+	synchronize_srcu_expedited(&kvm->srcu);
+}
+
 #ifdef MMU_DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
@@ -2219,6 +2283,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sp);
 }
 
+static bool is_valid_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	return likely(sp->mmu_valid_gen == kvm->arch.mmu_valid_gen);
+}
+
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
@@ -2245,6 +2314,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		role.quadrant = quadrant;
 	}
 	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
+		if (!is_valid_sp(vcpu->kvm, sp))
+			continue;
+
 		if (!need_sync && sp->unsync)
 			need_sync = true;
 
@@ -2281,6 +2353,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 		account_shadowed(vcpu->kvm, gfn);
 	}
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	init_shadow_page_table(sp);
 	trace_kvm_mmu_get_page(sp, true);
 	return sp;
@@ -2451,8 +2524,12 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	kvm_mmu_page_unlink_children(kvm, sp);
 	kvm_mmu_unlink_parents(kvm, sp);
-	if (!sp->role.invalid && !sp->role.direct)
+
+	if (!sp->role.invalid && !sp->role.direct &&
+	      /* Invalid-gen pages are not accounted. */
+	      is_valid_sp(kvm, sp))
 		unaccount_shadowed(kvm, sp->gfn);
+
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
 	if (!sp->root_count) {
@@ -3256,7 +3333,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 
 		sp = page_header(root);
 		--sp->root_count;
-		if (!sp->root_count && sp->role.invalid) {
+		if (!is_valid_sp(vcpu->kvm, sp) ||
+		      (!sp->root_count && sp->role.invalid)) {
 			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
 			kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 		}
@@ -3271,7 +3349,8 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 			root &= PT64_BASE_ADDR_MASK;
 			sp = page_header(root);
 			--sp->root_count;
-			if (!sp->root_count && sp->role.invalid)
+			if (!is_valid_sp(vcpu->kvm, sp) ||
+			      (!sp->root_count && sp->role.invalid))
 				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
 							 &invalid_list);
 		}
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index ab434b7..f01c5ce 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -131,4 +131,8 @@ struct rmap_operations {
 
 void init_memslot_rmap_ops(struct kvm_memory_slot *slot);
 void free_meslot_rmap_desc_nolock(struct kvm_memory_slot *slot);
+
+#define INVALID_ALL_SLOTS	((struct kvm_memory_slot *)(~0))
+void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
+				   struct kvm_memory_slot *slot);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc4956c..6dbb80c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6863,6 +6863,12 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 	if (!free->arch.rmap[0])
 		return;
 
+	/*
+	 * Vcpus and mmu-notify can not see the rmap of this slot which
+	 * can be safely freed.
+	 */
+	free_meslot_rmap_desc_nolock(free);
+
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		kvm_kvfree(free->arch.rmap[i]);
 		free->arch.rmap[i] = NULL;
-- 
1.7.7.6

