Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3EaAhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:37:12 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59456 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3EaAgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:36:45 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v8 03/11] KVM: MMU: fast invalidate all pages
Date: Fri, 31 May 2013 08:36:22 +0800
Message-Id: <1369960590-14138-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053100-6102-0000-0000-0000039CF5E4
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
Then the obsolete pages (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen)
are zapped by using lock-break technique

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu.c              |   90 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu.h              |    1 +
 3 files changed, 93 insertions(+), 0 deletions(-)

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
index f8ca2f3..d71bf8f 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1511,6 +1511,12 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	if (!direct)
 		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	/*
+	 * The active_mmu_pages list is the FIFO list, do not move the
+	 * page until it is zapped. kvm_zap_obsolete_pages depends on
+	 * this feature. See the comments in kvm_zap_obsolete_pages().
+	 */
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	sp->parent_ptes = 0;
 	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
@@ -1838,6 +1844,11 @@ static void clear_sp_write_flooding_count(u64 *spte)
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
@@ -1900,6 +1911,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 		account_shadowed(vcpu->kvm, gfn);
 	}
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	init_shadow_page_table(sp);
 	trace_kvm_mmu_get_page(sp, true);
 	return sp;
@@ -2070,8 +2082,10 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	ret = mmu_zap_unsync_children(kvm, sp, invalid_list);
 	kvm_mmu_page_unlink_children(kvm, sp);
 	kvm_mmu_unlink_parents(kvm, sp);
+
 	if (!sp->role.invalid && !sp->role.direct)
 		unaccount_shadowed(kvm, sp->gfn);
+
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
 	if (!sp->root_count) {
@@ -4195,6 +4209,82 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
+static void kvm_zap_obsolete_pages(struct kvm *kvm)
+{
+	struct kvm_mmu_page *sp, *node;
+	LIST_HEAD(invalid_list);
+
+restart:
+	list_for_each_entry_safe_reverse(sp, node,
+	      &kvm->arch.active_mmu_pages, link) {
+		/*
+		 * No obsolete page exists before new created page since
+		 * active_mmu_pages is the FIFO list.
+		 */
+		if (!is_obsolete_sp(kvm, sp))
+			break;
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
+		 * Since we are reversely walking the list and the invalid
+		 * list will be moved to the head, skip the invalid page
+		 * can help us to avoid the infinity list walking.
+		 */
+		if (sp->role.invalid)
+			continue;
+
+		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			cond_resched_lock(&kvm->mmu_lock);
+			goto restart;
+		}
+
+		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
+			goto restart;
+	}
+
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+}
+
+/*
+ * Fast invalidate all shadow pages and use lock-break technique
+ * to zap obsolete pages.
+ *
+ * It's required when memslot is being deleted or VM is being
+ * destroyed, in these cases, we should ensure that KVM MMU does
+ * not use any resource of the being-deleted slot or all slots
+ * after calling the function.
+ */
+void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
+{
+	spin_lock(&kvm->mmu_lock);
+	kvm->arch.mmu_valid_gen++;
+
+	kvm_zap_obsolete_pages(kvm);
+	spin_unlock(&kvm->mmu_lock);
+}
+
 void kvm_mmu_zap_mmio_sptes(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2adcbc2..922bfae 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -97,4 +97,5 @@ static inline bool permission_fault(struct kvm_mmu *mmu, unsigned pte_access,
 	return (mmu->permissions[pfec >> 1] >> pte_access) & 1;
 }
 
+void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm);
 #endif
-- 
1.7.7.6

