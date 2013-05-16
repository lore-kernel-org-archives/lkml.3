Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3EPMSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:18:14 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41452 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3EPMSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:18:10 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 3/8] KVM: MMU: fast invalidate all pages
Date: Thu, 16 May 2013 20:17:48 +0800
Message-Id: <1368706673-8530-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051612-2000-0000-0000-00000C23D84C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
walk and zap all shadow pages one by one, also it need to zap all guest
page's rmap and all shadow page's parent spte list. Particularly, things
become worse if guest uses more memory or vcpus. It is not good for
scalability

In this patch, we introduce a faster way to invalidate all shadow pages.
KVM maintains a global mmu invalid generation-number which is stored in
kvm->arch.mmu_valid_gen and every shadow page stores the current global
generation-number into sp->mmu_valid_gen when it is created

When KVM need zap all shadow pages sptes, it just simply increase the
global generation-number then reload root shadow pages on all vcpus.
Vcpu will create a new shadow page table according to current kvm's
generation-number. It ensures the old pages are not used any more.
Then the invalid-gen pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
are zapped by using lock-break technique

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu.c              |   98 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu.h              |    2 +
 3 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3741c65..bff7d46 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -222,6 +222,7 @@ struct kvm_mmu_page {
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
+	unsigned long mmu_valid_gen;
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 #ifdef CONFIG_X86_32
@@ -529,6 +530,7 @@ struct kvm_arch {
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	unsigned long mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 682ecb4..d9343fe 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1839,6 +1839,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sp);
 }
 
+static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
+}
+
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
@@ -1865,6 +1870,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		role.quadrant = quadrant;
 	}
 	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
+		if (is_obsolete_sp(vcpu->kvm, sp))
+			continue;
+
 		if (!need_sync && sp->unsync)
 			need_sync = true;
 
@@ -1901,6 +1909,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 		account_shadowed(vcpu->kvm, gfn);
 	}
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	init_shadow_page_table(sp);
 	trace_kvm_mmu_get_page(sp, true);
 	return sp;
@@ -2071,8 +2080,10 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	kvm_mmu_page_unlink_children(kvm, sp);
 	kvm_mmu_unlink_parents(kvm, sp);
+
 	if (!sp->role.invalid && !sp->role.direct)
 		unaccount_shadowed(kvm, sp->gfn);
+
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
 
@@ -4196,6 +4207,93 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+static void zap_invalid_pages(struct kvm *kvm)
+{
+	struct kvm_mmu_page *sp, *node;
+	LIST_HEAD(invalid_list);
+
+restart:
+	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
+		if (!is_obsolete_sp(kvm, sp))
+			continue;
+
+		/*
+		 * Do not repeatedly zap a root page to avoid unnecessary
+		 * KVM_REQ_MMU_RELOAD, otherwise we may not be able to
+		 * progress:
+		 *    vcpu 0                        vcpu 1
+		 *                         call vcpu_enter_guest():
+		 *                            1): handle KVM_REQ_MMU_RELOAD
+		 *                                and require mmu-lock to
+		 *                                load mmu
+		 * repeat:
+		 *    1): zap root page and
+		 *        send KVM_REQ_MMU_RELOAD
+		 *
+		 *    2): if (cond_resched_lock(mmu-lock))
+		 *
+		 *                            2): hold mmu-lock and load mmu
+		 *
+		 *                            3): see KVM_REQ_MMU_RELOAD bit
+		 *                                on vcpu->requests is set
+		 *                                then return 1 to call
+		 *                                vcpu_enter_guest() again.
+		 *            goto repeat;
+		 *
+		 */
+		if (sp->role.invalid)
+			continue;
+		/*
+		 * Need not flush tlb since we only zap the sp with invalid
+		 * generation number.
+		 */
+		if (cond_resched_lock(&kvm->mmu_lock))
+			goto restart;
+
+		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
+			goto restart;
+	}
+
+	/*
+	 * Should flush tlb before free page tables since lockless-walking
+	 * may use the pages.
+	 */
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+}
+
+/*
+ * Fast invalidate all shadow pages belong to @slot.
+ *
+ * @slot != NULL means the invalidation is caused the memslot specified
+ * by @slot is being deleted, in this case, we should ensure that rmap
+ * and lpage-info of the @slot can not be used after calling the function.
+ *
+ * @slot == NULL means the invalidation due to other reasons, we need
+ * not care rmap and lpage-info since they are still valid after calling
+ * the function.
+ */
+void kvm_mmu_invalidate_memslot_pages(struct kvm *kvm,
+				      struct kvm_memory_slot *slot)
+{
+	spin_lock(&kvm->mmu_lock);
+	kvm->arch.mmu_valid_gen++;
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
+		zap_invalid_pages(kvm);
+	spin_unlock(&kvm->mmu_lock);
+}
+
 void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2adcbc2..bd57466 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -97,4 +97,6 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
 	return (mmu->permissions[pfec >> 1] >> pte_access) & 1;
 }
 
+void kvm_mmu_invalidate_memslot_pages(struct kvm *kvm,
+				      struct kvm_memory_slot *slot);
 #endif
-- 
1.7.7.6

