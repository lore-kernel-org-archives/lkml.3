Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3D0DOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 23:14:09 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:32929 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3D0DNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 23:13:35 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
Date: Sat, 27 Apr 2013 11:13:20 +0800
Message-Id: <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042703-5816-0000-0000-000007BA66C4
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
 arch/x86/kvm/mmu.c              |   77 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu.h              |    2 +
 3 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 18635ae..7adf8f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -220,6 +220,7 @@ struct kvm_mmu_page {
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
+	unsigned long mmu_valid_gen;
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 #ifdef CONFIG_X86_32
@@ -527,6 +528,7 @@ struct kvm_arch {
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	unsigned long mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 004cc87..63110c7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1838,6 +1838,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
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
@@ -1864,6 +1869,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		role.quadrant = quadrant;
 	}
 	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
+		if (!is_valid_sp(vcpu->kvm, sp))
+			continue;
+
 		if (!need_sync && sp->unsync)
 			need_sync = true;
 
@@ -1900,6 +1908,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 		account_shadowed(vcpu->kvm, gfn);
 	}
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	init_shadow_page_table(sp);
 	trace_kvm_mmu_get_page(sp, true);
 	return sp;
@@ -2070,8 +2079,12 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
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
@@ -4194,6 +4207,68 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+static void
+memslot_unmap_rmaps(struct kvm_memory_slot *slot, struct kvm *kvm)
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
+
+		while (idx--) {
+			kvm_unmap_rmapp(kvm, rmapp + idx, slot, 0);
+
+			if (need_resched() || spin_needbreak(&kvm->mmu_lock))
+				cond_resched_lock(&kvm->mmu_lock);
+		}
+	}
+}
+
+/*
+ * Fast invalid all shadow pages belong to @slot.
+ *
+ * @slot != NULL means the invalidation is caused the memslot specified
+ * by @slot is being deleted, in this case, we should ensure that rmap
+ * and lpage-info of the @slot can not be used after calling the function.
+ *
+ * @slot == NULL means the invalidation due to other reasons, we need
+ * not care rmap and lpage-info since they are still valid after calling
+ * the function.
+ */
+void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
+{
+	spin_lock(&kvm->mmu_lock);
+	kvm->arch.mmu_valid_gen++;
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
+
+	if (slot)
+		memslot_unmap_rmaps(slot, kvm);
+	spin_unlock(&kvm->mmu_lock);
+}
+
 void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2adcbc2..94670f0 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -97,4 +97,6 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
 	return (mmu->permissions[pfec >> 1] >> pte_access) & 1;
 }
 
+void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
+				   struct kvm_memory_slot *slot);
 #endif
-- 
1.7.7.6

