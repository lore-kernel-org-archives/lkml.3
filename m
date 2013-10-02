Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3JBO6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:58:35 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47812 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3JBO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:34 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 2/7] KVM: mmu: remove uninteresting MMU "new_cr3" callbacks
Date: Wed,  2 Oct 2013 16:56:11 +0200
Message-Id: <1380725776-14948-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new_cr3 MMU callback has been a wrapper for mmu_free_roots since commit
e676505 (KVM: MMU: Force cr3 reload with two dimensional paging on mov
cr3 emulation, 2012-07-08).

The commit message mentioned that "mmu_free_roots() is somewhat of an overkill,
but fixing that is more complicated and will be done after this minimal fix".
One year has passed, and no one really felt the need to do a different fix.
Wrap the call with a kvm_mmu_new_cr3 function for clarity, but remove the
callback.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu.c              | 13 +------------
 arch/x86/kvm/x86.c              |  2 +-
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ea4d40..00a0e4c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -253,7 +253,6 @@ struct kvm_pio_request {
  * mode.
  */
 struct kvm_mmu {
-	void (*new_cr3)(struct kvm_vcpu *vcpu);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
 	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
@@ -921,6 +920,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
+void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu);
 
 void kvm_enable_tdp(void);
 void kvm_disable_tdp(void);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1c4d580..dff856c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2570,11 +2570,6 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	kvm_release_pfn_clean(pfn);
 }
 
-static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
-{
-	mmu_free_roots(vcpu);
-}
-
 static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
 				     bool no_dirty_log)
 {
@@ -3427,7 +3422,6 @@ out_unlock:
 static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu *context)
 {
-	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
 	context->sync_page = nonpaging_sync_page;
@@ -3448,9 +3442,8 @@ void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_flush_tlb);
 
-static void paging_new_cr3(struct kvm_vcpu *vcpu)
+void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu)
 {
-	pgprintk("%s: cr3 %lx\n", __func__, kvm_read_cr3(vcpu));
 	mmu_free_roots(vcpu);
 }
 
@@ -3666,7 +3659,6 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 	update_last_pte_bitmap(vcpu, context);
 
 	ASSERT(is_pae(vcpu));
-	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
 	context->sync_page = paging64_sync_page;
@@ -3694,7 +3686,6 @@ static int paging32_init_context(struct kvm_vcpu *vcpu,
 	update_permission_bitmask(vcpu, context, false);
 	update_last_pte_bitmap(vcpu, context);
 
-	context->new_cr3 = paging_new_cr3;
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
 	context->sync_page = paging32_sync_page;
@@ -3717,7 +3708,6 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	struct kvm_mmu *context = vcpu->arch.walk_mmu;
 
 	context->base_role.word = 0;
-	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = nonpaging_invlpg;
@@ -3792,7 +3782,6 @@ int kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 
 	context->nx = true;
-	context->new_cr3 = paging_new_cr3;
 	context->page_fault = ept_page_fault;
 	context->gva_to_gpa = ept_gva_to_gpa;
 	context->sync_page = ept_sync_page;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 187f824..4a33fdb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -684,7 +684,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	vcpu->arch.cr3 = cr3;
 	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
-	vcpu->arch.mmu.new_cr3(vcpu);
+	kvm_mmu_new_cr3(vcpu);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr3);
-- 
1.8.3.1


