Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3JBO4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:56:36 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40779 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab3JBO4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:32 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 1/7] KVM: mmu: remove uninteresting MMU "free" callbacks
Date: Wed,  2 Oct 2013 16:56:10 +0200
Message-Id: <1380725776-14948-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The free MMU callback has been a wrapper for mmu_free_roots since mmu_free_roots
itself was introduced (commit 17ac10a, [PATCH] KVM: MU: Special treatment
for shadow pae root pages, 2007-01-05), and has always been the same for all
MMU cases.  Remove the indirection as it is useless.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu.c              | 22 ++++------------------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c76ff74..3ea4d40 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -261,7 +261,6 @@ struct kvm_mmu {
 			  bool prefault);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
-	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    struct x86_exception *exception);
 	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cf95cfe..1c4d580 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3424,18 +3424,12 @@ out_unlock:
 	return 0;
 }
 
-static void nonpaging_free(struct kvm_vcpu *vcpu)
-{
-	mmu_free_roots(vcpu);
-}
-
 static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu *context)
 {
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
-	context->free = nonpaging_free;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
 	context->update_pte = nonpaging_update_pte;
@@ -3471,11 +3465,6 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
 	vcpu->arch.mmu.inject_page_fault(vcpu, fault);
 }
 
-static void paging_free(struct kvm_vcpu *vcpu)
-{
-	nonpaging_free(vcpu);
-}
-
 static bool sync_mmio_spte(struct kvm *kvm, u64 *sptep, gfn_t gfn,
 			   unsigned access, int *nr_present)
 {
@@ -3683,7 +3672,6 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->sync_page = paging64_sync_page;
 	context->invlpg = paging64_invlpg;
 	context->update_pte = paging64_update_pte;
-	context->free = paging_free;
 	context->shadow_root_level = level;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = false;
@@ -3709,7 +3697,6 @@ static int paging32_init_context(struct kvm_vcpu *vcpu,
 	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
-	context->free = paging_free;
 	context->sync_page = paging32_sync_page;
 	context->invlpg = paging32_invlpg;
 	context->update_pte = paging32_update_pte;
@@ -3732,7 +3719,6 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->base_role.word = 0;
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = tdp_page_fault;
-	context->free = nonpaging_free;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
 	context->update_pte = nonpaging_update_pte;
@@ -3812,7 +3798,6 @@ int kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 	context->sync_page = ept_sync_page;
 	context->invlpg = ept_invlpg;
 	context->update_pte = ept_update_pte;
-	context->free = paging_free;
 	context->root_level = context->shadow_root_level;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = false;
@@ -3890,9 +3875,10 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 static void destroy_kvm_mmu(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
-	if (VALID_PAGE(vcpu->arch.mmu.root_hpa))
-		/* mmu.free() should set root_hpa = INVALID_PAGE */
-		vcpu->arch.mmu.free(vcpu);
+	if (VALID_PAGE(vcpu->arch.mmu.root_hpa)) {
+		mmu_free_roots(vcpu);
+		WARN_ON(VALID_PAGE(vcpu->arch.mmu.root_hpa));
+	}
 }
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
-- 
1.8.3.1


