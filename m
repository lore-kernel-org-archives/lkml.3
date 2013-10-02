Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3JBO4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:56:53 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:53621 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3JBO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:45 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 7/7] KVM: mmu: replace assertions with MMU_WARN_ON, a conditional WARN_ON
Date: Wed,  2 Oct 2013 16:56:16 +0200
Message-Id: <1380725776-14948-8-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the direction of the conditions consistent with code that
is already using WARN_ON.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 699eab3..550e33d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -62,30 +62,16 @@ enum {
 #undef MMU_DEBUG
 
 #ifdef MMU_DEBUG
+static bool dbg = 0;
+module_param(dbg, bool, 0644);
 
 #define pgprintk(x...) do { if (dbg) printk(x); } while (0)
 #define rmap_printk(x...) do { if (dbg) printk(x); } while (0)
-
+#define MMU_WARN_ON(x) WARN_ON(x)
 #else
-
 #define pgprintk(x...) do { } while (0)
 #define rmap_printk(x...) do { } while (0)
-
-#endif
-
-#ifdef MMU_DEBUG
-static bool dbg = 0;
-module_param(dbg, bool, 0644);
-#endif
-
-#ifndef MMU_DEBUG
-#define ASSERT(x) do { } while (0)
-#else
-#define ASSERT(x)							\
-	if (!(x)) {							\
-		printk(KERN_WARNING "assertion failed %s:%d: %s\n",	\
-		       __FILE__, __LINE__, #x);				\
-	}
+#define MMU_WARN_ON(x) do { } while (0)
 #endif
 
 #define PTE_PREFETCH_NUM		8
@@ -1533,7 +1519,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 
 static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
 {
-	ASSERT(is_empty_shadow_page(sp->spt));
+	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
@@ -3016,7 +3002,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		for (i = 0; i < 4; ++i) {
 			hpa_t root = vcpu->arch.mmu.pae_root[i];
 
-			ASSERT(!VALID_PAGE(root));
+			MMU_WARN_ON(VALID_PAGE(root));
 			spin_lock(&vcpu->kvm->mmu_lock);
 			make_mmu_pages_available(vcpu);
 			sp = kvm_mmu_get_page(vcpu, i << (30 - PAGE_SHIFT),
@@ -3054,7 +3040,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
-		ASSERT(!VALID_PAGE(root));
+		MMU_WARN_ON(VALID_PAGE(root));
 
 		spin_lock(&vcpu->kvm->mmu_lock);
 		make_mmu_pages_available(vcpu);
@@ -3079,7 +3065,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
-		ASSERT(!VALID_PAGE(root));
+		MMU_WARN_ON(VALID_PAGE(root));
 		if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
 			pdptr = vcpu->arch.mmu.get_pdptr(vcpu, i);
 			if (!is_present_gpte(pdptr)) {
@@ -3301,7 +3287,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	if (r)
 		return r;
 
-	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
+	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	gfn = gva >> PAGE_SHIFT;
 
@@ -3367,7 +3353,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	int write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
-	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
+	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, gpa, error_code, true);
@@ -3655,7 +3641,7 @@ static void paging64_init_context_common(struct kvm_vcpu *vcpu,
 	update_permission_bitmask(vcpu, context, false);
 	update_last_pte_bitmap(vcpu, context);
 
-	ASSERT(is_pae(vcpu));
+	MMU_WARN_ON(!is_pae(vcpu));
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
@@ -3745,7 +3731,7 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
 	bool smep = kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
 	struct kvm_mmu *context = vcpu->arch.walk_mmu;
 
-	ASSERT(!VALID_PAGE(context->root_hpa));
+	MMU_WARN_ON(VALID_PAGE(context->root_hpa));
 
 	if (!is_paging(vcpu))
 		nonpaging_init_context(vcpu, context);
@@ -3768,7 +3754,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly)
 {
 	struct kvm_mmu *context = vcpu->arch.walk_mmu;
 
-	ASSERT(!VALID_PAGE(context->root_hpa));
+	MMU_WARN_ON(VALID_PAGE(context->root_hpa));
 
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 
@@ -4230,7 +4216,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_setup(struct kvm_vcpu *vcpu)
 {
-	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
+	MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	init_kvm_mmu(vcpu);
 }
-- 
1.8.3.1

