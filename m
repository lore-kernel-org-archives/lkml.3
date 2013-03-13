Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3CME4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:56:10 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55476 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3CME4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:56:08 -0400
Message-ID: <514006DF.5090604@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 12:55:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/6] KVM: MMU: move mmu related members into a separate struct
References: <514006AC.2020904@linux.vnet.ibm.com>
In-Reply-To: <514006AC.2020904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031304-6102-0000-0000-000003255FF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all mmu related members from kvm_arch to a separate struct named
kvm_mmu_cache, so we can easily reset the mmu cache when we zap all shadow
pages

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    6 +++++-
 arch/x86/kvm/mmu.c              |   36 ++++++++++++++++++++----------------
 arch/x86/kvm/mmu.h              |    4 ++--
 arch/x86/kvm/mmu_audit.c        |    2 +-
 arch/x86/kvm/x86.c              |   11 ++++++-----
 5 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 635a74d..85291b08 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -525,7 +525,7 @@ struct kvm_apic_map {
 	struct kvm_lapic *logical_map[16][16];
 };

-struct kvm_arch {
+struct kvm_mmu_cache {
 	unsigned int n_used_mmu_pages;
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
@@ -535,6 +535,10 @@ struct kvm_arch {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+};
+
+struct kvm_arch {
+	struct kvm_mmu_cache mmu_cache;
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	int iommu_flags;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fdacabb..c52d147 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -751,7 +751,7 @@ static void account_shadowed(struct kvm *kvm, gfn_t gfn)
 		linfo = lpage_info_slot(gfn, slot, i);
 		linfo->write_count += 1;
 	}
-	kvm->arch.indirect_shadow_pages++;
+	kvm->arch.mmu_cache.indirect_shadow_pages++;
 }

 static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
@@ -767,7 +767,7 @@ static void unaccount_shadowed(struct kvm *kvm, gfn_t gfn)
 		linfo->write_count -= 1;
 		WARN_ON(linfo->write_count < 0);
 	}
-	kvm->arch.indirect_shadow_pages--;
+	kvm->arch.mmu_cache.indirect_shadow_pages--;
 }

 static int has_wrprotected_page(struct kvm *kvm,
@@ -1456,7 +1456,7 @@ static int is_empty_shadow_page(u64 *spt)
  */
 static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 {
-	kvm->arch.n_used_mmu_pages += nr;
+	kvm->arch.mmu_cache.n_used_mmu_pages += nr;
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }

@@ -1507,7 +1507,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	if (!direct)
 		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
+	list_add(&sp->link, &vcpu->kvm->arch.mmu_cache.active_mmu_pages);
 	sp->parent_ptes = 0;
 	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
@@ -1646,7 +1646,8 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,

 #define for_each_gfn_sp(_kvm, _sp, _gfn)				\
 	hlist_for_each_entry(_sp,					\
-	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
+	&(_kvm)->arch.mmu_cache.mmu_page_hash[kvm_page_table_hashfn(_gfn)],\
+	       hash_link)						\
 		if ((_sp)->gfn != (_gfn)) {} else

 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
@@ -1842,6 +1843,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     unsigned access,
 					     u64 *parent_pte)
 {
+	struct kvm_mmu_cache *cache;
 	union kvm_mmu_page_role role;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
@@ -1886,8 +1888,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		return sp;
 	sp->gfn = gfn;
 	sp->role = role;
+	cache = &vcpu->kvm->arch.mmu_cache;
 	hlist_add_head(&sp->hash_link,
-		&vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)]);
+		       &cache->mmu_page_hash[kvm_page_table_hashfn(gfn)]);
 	if (!direct) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
 			kvm_flush_remote_tlbs(vcpu->kvm);
@@ -2076,7 +2079,7 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 		list_move(&sp->link, invalid_list);
 		kvm_mod_used_mmu_pages(kvm, -1);
 	} else {
-		list_move(&sp->link, &kvm->arch.active_mmu_pages);
+		list_move(&sp->link, &kvm->arch.mmu_cache.active_mmu_pages);
 		kvm_reload_remote_mmus(kvm);
 	}

@@ -2115,10 +2118,10 @@ static bool prepare_zap_oldest_mmu_page(struct kvm *kvm,
 {
 	struct kvm_mmu_page *sp;

-	if (list_empty(&kvm->arch.active_mmu_pages))
+	if (list_empty(&kvm->arch.mmu_cache.active_mmu_pages))
 		return false;

-	sp = list_entry(kvm->arch.active_mmu_pages.prev,
+	sp = list_entry(kvm->arch.mmu_cache.active_mmu_pages.prev,
 			struct kvm_mmu_page, link);
 	kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);

@@ -2135,17 +2138,17 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)

 	spin_lock(&kvm->mmu_lock);

-	if (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages) {
+	if (kvm->arch.mmu_cache.n_used_mmu_pages > goal_nr_mmu_pages) {
 		/* Need to free some mmu pages to achieve the goal. */
-		while (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages)
+		while (kvm->arch.mmu_cache.n_used_mmu_pages > goal_nr_mmu_pages)
 			if (!prepare_zap_oldest_mmu_page(kvm, &invalid_list))
 				break;

 		kvm_mmu_commit_zap_page(kvm, &invalid_list);
-		goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;
+		goal_nr_mmu_pages = kvm->arch.mmu_cache.n_used_mmu_pages;
 	}

-	kvm->arch.n_max_mmu_pages = goal_nr_mmu_pages;
+	kvm->arch.mmu_cache.n_max_mmu_pages = goal_nr_mmu_pages;

 	spin_unlock(&kvm->mmu_lock);
 }
@@ -3941,7 +3944,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 * If we don't have indirect shadow pages, it means no page is
 	 * write-protected, so we can exit simply.
 	 */
-	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
+	if (!ACCESS_ONCE(vcpu->kvm->arch.mmu_cache.indirect_shadow_pages))
 		return;

 	zap_page = remote_flush = local_flush = false;
@@ -4178,7 +4181,8 @@ void kvm_mmu_zap_all(struct kvm *kvm)

 	spin_lock(&kvm->mmu_lock);
 restart:
-	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link)
+	list_for_each_entry_safe(sp, node,
+	      &kvm->arch.mmu_cache.active_mmu_pages, link)
 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
 			goto restart;

@@ -4214,7 +4218,7 @@ static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
 		 * want to shrink a VM that only started to populate its MMU
 		 * anyway.
 		 */
-		if (!kvm->arch.n_used_mmu_pages)
+		if (!kvm->arch.mmu_cache.n_used_mmu_pages)
 			continue;

 		idx = srcu_read_lock(&kvm->srcu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6987108..2e61c24 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -57,8 +57,8 @@ int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);

 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
 {
-	return kvm->arch.n_max_mmu_pages -
-		kvm->arch.n_used_mmu_pages;
+	return kvm->arch.mmu_cache.n_max_mmu_pages -
+		kvm->arch.mmu_cache.n_used_mmu_pages;
 }

 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index daff69e..a2712c1 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -89,7 +89,7 @@ static void walk_all_active_sps(struct kvm *kvm, sp_handler fn)
 {
 	struct kvm_mmu_page *sp;

-	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link)
+	list_for_each_entry(sp, &kvm->arch.mmu_cache.active_mmu_pages, link)
 		fn(kvm, sp);
 }

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 35b4912..9cb899c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3274,7 +3274,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);

 	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
-	kvm->arch.n_requested_mmu_pages = kvm_nr_mmu_pages;
+	kvm->arch.mmu_cache.n_requested_mmu_pages = kvm_nr_mmu_pages;

 	mutex_unlock(&kvm->slots_lock);
 	return 0;
@@ -3282,7 +3282,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,

 static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 {
-	return kvm->arch.n_max_mmu_pages;
+	return kvm->arch.mmu_cache.n_max_mmu_pages;
 }

 static int kvm_vm_ioctl_get_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
@@ -4795,10 +4795,11 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,

 	/* The instructions are well-emulated on direct mmu. */
 	if (vcpu->arch.mmu.direct_map) {
+		struct kvm_mmu_cache *cache = &vcpu->kvm->arch.mmu_cache;
 		unsigned int indirect_shadow_pages;

 		spin_lock(&vcpu->kvm->mmu_lock);
-		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
+		indirect_shadow_pages = cache->indirect_shadow_pages;
 		spin_unlock(&vcpu->kvm->mmu_lock);

 		if (indirect_shadow_pages)
@@ -6756,7 +6757,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		return -EINVAL;

-	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+	INIT_LIST_HEAD(&kvm->arch.mmu_cache.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);

 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
@@ -6952,7 +6953,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 			       "failed to munmap memory\n");
 	}

-	if (!kvm->arch.n_requested_mmu_pages)
+	if (!kvm->arch.mmu_cache.n_requested_mmu_pages)
 		nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);

 	if (nr_mmu_pages)
-- 
1.7.7.6

