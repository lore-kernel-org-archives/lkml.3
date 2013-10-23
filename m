Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3JWNbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:31:50 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60229 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3JWNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:30:07 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 10/15] KVM: MMU: allocate shadow pages from slab
Date: Wed, 23 Oct 2013 21:29:28 +0800
Message-Id: <1382534973-13197-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102313-8878-0000-0000-000009652134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate shadow pages from slab instead of page-allocator, frequent
shadow page allocation and free can be hit in the slab cache, it is
very useful for shadow mmu

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/mmu.c              | 46 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5cbf316..df9ae10 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -389,6 +389,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu *walk_mmu;
 
 	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
+	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_page_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
@@ -946,7 +947,7 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
 
-	return (struct kvm_mmu_page *)page_private(page);
+	return (struct kvm_mmu_page *)(page->mapping);
 }
 
 static inline u16 kvm_read_ldt(void)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f3ae74e6..1bcc8c8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -178,6 +178,7 @@ struct kvm_shadow_walk_iterator {
 	     __shadow_walk_next(&(_walker), spte))
 
 static struct kmem_cache *pte_list_desc_cache;
+static struct kmem_cache *mmu_shadow_page_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
@@ -746,7 +747,14 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 				   GFP_KERNEL);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
+
+	r = mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
+				   mmu_shadow_page_cache, 4,
+				   GFP_KERNEL);
+	if (r)
+		goto out;
+
+	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 4);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
@@ -760,6 +768,8 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
 				pte_list_desc_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+				mmu_shadow_page_cache);
 	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
 	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
 				mmu_page_header_cache);
@@ -1675,12 +1685,28 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
+static void set_page_header(struct kvm_mmu_page *sp)
+{
+	struct page *page = virt_to_page(sp->spt);
+
+	WARN_ON(page->mapping);
+	page->mapping = (struct address_space *)sp;
+}
+
+static void clear_page_header(struct kvm_mmu_page *sp)
+{
+	struct page *page = virt_to_page(sp->spt);
+
+	page->mapping = NULL;
+}
+
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
-	free_page((unsigned long)sp->spt);
+	clear_page_header(sp);
+	kmem_cache_free(mmu_shadow_page_cache, sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
 	kmem_cache_free(mmu_page_header_cache, sp);
@@ -1719,10 +1745,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page *sp;
 
 	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
+	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	if (!direct)
 		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	set_page_header(sp);
 
 	/*
 	 * The active_mmu_pages list is the FIFO list, do not move the
@@ -2046,12 +2072,13 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 	}
 }
 
-static void init_shadow_page_table(struct kvm_mmu_page *sp)
+static void init_shadow_page_table(void *p)
 {
+	u64 *sptp = (u64 *)p;
 	int i;
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
-		sp->spt[i] = 0ull;
+		sptp[i] = 0ull;
 }
 
 static void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
@@ -2137,7 +2164,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		account_shadowed(vcpu->kvm, gfn);
 	}
 	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	init_shadow_page_table(sp);
 	trace_kvm_mmu_get_page(sp, true);
 	return sp;
 }
@@ -4683,6 +4709,12 @@ int kvm_mmu_module_init(void)
 	if (!pte_list_desc_cache)
 		goto nomem;
 
+	mmu_shadow_page_cache = kmem_cache_create("mmu_shadow_page_cache",
+						  PAGE_SIZE, PAGE_SIZE, 0,
+						  init_shadow_page_table);
+	if (!mmu_shadow_page_cache)
+		goto nomem;
+
 	mmu_page_header_cache = kmem_cache_create("kvm_mmu_page_header",
 						  sizeof(struct kvm_mmu_page),
 						  0, 0, NULL);
-- 
1.8.1.4

