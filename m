Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3JBO6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:58:11 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51912 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3JBO4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:39 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 4/7] KVM: mmu: change useless int return types to void
Date: Wed,  2 Oct 2013 16:56:13 +0200
Message-Id: <1380725776-14948-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_mmu initialization is mostly filling in function pointers, there is
no way for it to fail.  Clean up unused return values.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +--
 arch/x86/kvm/mmu.c              | 71 ++++++++++++++++-------------------------
 arch/x86/kvm/mmu.h              |  4 +--
 arch/x86/kvm/svm.c              |  8 ++---
 arch/x86/kvm/vmx.c              |  6 ++--
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 37 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 00a0e4c..94d9341 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -778,11 +778,11 @@ void kvm_mmu_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
-int kvm_mmu_setup(struct kvm_vcpu *vcpu);
+void kvm_mmu_setup(struct kvm_vcpu *vcpu);
 void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 		u64 dirty_mask, u64 nx_mask, u64 x_mask);
 
-int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
+void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
 void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d318d42..40772ef 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3419,8 +3419,8 @@ out_unlock:
 	return 0;
 }
 
-static int nonpaging_init_context(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu *context)
+static void nonpaging_init_context(struct kvm_vcpu *vcpu,
+				   struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -3432,7 +3432,6 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
 	context->nx = false;
-	return 0;
 }
 
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
@@ -3647,9 +3646,9 @@ static void update_last_pte_bitmap(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	mmu->last_pte_bitmap = map;
 }
 
-static int paging64_init_context_common(struct kvm_vcpu *vcpu,
-					struct kvm_mmu *context,
-					int level)
+static void paging64_init_context_common(struct kvm_vcpu *vcpu,
+					 struct kvm_mmu *context,
+					 int level)
 {
 	context->nx = is_nx(vcpu);
 	context->root_level = level;
@@ -3667,17 +3666,16 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
 	context->shadow_root_level = level;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = false;
-	return 0;
 }
 
-static int paging64_init_context(struct kvm_vcpu *vcpu,
-				 struct kvm_mmu *context)
+static void paging64_init_context(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu *context)
 {
-	return paging64_init_context_common(vcpu, context, PT64_ROOT_LEVEL);
+	paging64_init_context_common(vcpu, context, PT64_ROOT_LEVEL);
 }
 
-static int paging32_init_context(struct kvm_vcpu *vcpu,
-				 struct kvm_mmu *context)
+static void paging32_init_context(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu *context)
 {
 	context->nx = false;
 	context->root_level = PT32_ROOT_LEVEL;
@@ -3694,16 +3692,15 @@ static int paging32_init_context(struct kvm_vcpu *vcpu,
 	context->shadow_root_level = PT32E_ROOT_LEVEL;
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = false;
-	return 0;
 }
 
-static int paging32E_init_context(struct kvm_vcpu *vcpu,
-				  struct kvm_mmu *context)
+static void paging32E_init_context(struct kvm_vcpu *vcpu,
+				   struct kvm_mmu *context)
 {
-	return paging64_init_context_common(vcpu, context, PT32E_ROOT_LEVEL);
+	paging64_init_context_common(vcpu, context, PT32E_ROOT_LEVEL);
 }
 
-static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *context = vcpu->arch.walk_mmu;
 
@@ -3743,37 +3740,32 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 
 	update_permission_bitmask(vcpu, context, false);
 	update_last_pte_bitmap(vcpu, context);
-
-	return 0;
 }
 
-int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
+void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
-	int r;
 	bool smep = kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	if (!is_paging(vcpu))
-		r = nonpaging_init_context(vcpu, context);
+		nonpaging_init_context(vcpu, context);
 	else if (is_long_mode(vcpu))
-		r = paging64_init_context(vcpu, context);
+		paging64_init_context(vcpu, context);
 	else if (is_pae(vcpu))
-		r = paging32E_init_context(vcpu, context);
+		paging32E_init_context(vcpu, context);
 	else
-		r = paging32_init_context(vcpu, context);
+		paging32_init_context(vcpu, context);
 
 	vcpu->arch.mmu.base_role.nxe = is_nx(vcpu);
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
 	vcpu->arch.mmu.base_role.cr0_wp  = is_write_protection(vcpu);
 	vcpu->arch.mmu.base_role.smep_andnot_wp
 		= smep && !is_write_protection(vcpu);
-
-	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
 
-int kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
+void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 		bool execonly)
 {
 	ASSERT(vcpu);
@@ -3793,24 +3785,19 @@ int kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 
 	update_permission_bitmask(vcpu, context, true);
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
-static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
+static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
-	int r = kvm_init_shadow_mmu(vcpu, vcpu->arch.walk_mmu);
-
+	kvm_init_shadow_mmu(vcpu, vcpu->arch.walk_mmu);
 	vcpu->arch.walk_mmu->set_cr3           = kvm_x86_ops->set_cr3;
 	vcpu->arch.walk_mmu->get_cr3           = get_cr3;
 	vcpu->arch.walk_mmu->get_pdptr         = kvm_pdptr_read;
 	vcpu->arch.walk_mmu->inject_page_fault = kvm_inject_page_fault;
-
-	return r;
 }
 
-static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
@@ -3847,11 +3834,9 @@ static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 
 	update_permission_bitmask(vcpu, g_context, false);
 	update_last_pte_bitmap(vcpu, g_context);
-
-	return 0;
 }
 
-static int init_kvm_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_mmu(struct kvm_vcpu *vcpu)
 {
 	if (mmu_is_nested(vcpu))
 		return init_kvm_nested_mmu(vcpu);
@@ -3861,12 +3846,12 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 		return init_kvm_softmmu(vcpu);
 }
 
-int kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
+void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
 
 	kvm_mmu_unload(vcpu);
-	return init_kvm_mmu(vcpu);
+	init_kvm_mmu(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
@@ -4250,12 +4235,12 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	return alloc_mmu_pages(vcpu);
 }
 
-int kvm_mmu_setup(struct kvm_vcpu *vcpu)
+void kvm_mmu_setup(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
-	return init_kvm_mmu(vcpu);
+	init_kvm_mmu(vcpu);
 }
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 77e044a..2926152 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -70,8 +70,8 @@ enum {
 };
 
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
-int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
-int kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
+void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
+void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 		bool execonly);
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c0bc803..c7168a5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1959,11 +1959,9 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	nested_svm_vmexit(svm);
 }
 
-static int nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
+static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 {
-	int r;
-
-	r = kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);
+	kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);
 
 	vcpu->arch.mmu.set_cr3           = nested_svm_set_tdp_cr3;
 	vcpu->arch.mmu.get_cr3           = nested_svm_get_tdp_cr3;
@@ -1971,8 +1969,6 @@ static int nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.inject_page_fault = nested_svm_inject_npf_exit;
 	vcpu->arch.mmu.shadow_root_level = get_npt_level();
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
-
-	return r;
 }
 
 static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index be7fd0e..2db9164 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7499,9 +7499,9 @@ static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
 	return get_vmcs12(vcpu)->ept_pointer;
 }
 
-static int nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
+static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 {
-	int r = kvm_init_shadow_ept_mmu(vcpu, &vcpu->arch.mmu,
+	kvm_init_shadow_ept_mmu(vcpu, &vcpu->arch.mmu,
 			nested_vmx_ept_caps & VMX_EPT_EXECUTE_ONLY_BIT);
 
 	vcpu->arch.mmu.set_cr3           = vmx_set_cr3;
@@ -7509,8 +7509,6 @@ static int nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.inject_page_fault = nested_ept_inject_page_fault;
 
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
-
-	return r;
 }
 
 static void nested_ept_uninit_mmu_context(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4a33fdb..a9632ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6688,7 +6688,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	if (r)
 		return r;
 	kvm_vcpu_reset(vcpu);
-	r = kvm_mmu_setup(vcpu);
+	kvm_mmu_setup(vcpu);
 	vcpu_put(vcpu);
 
 	return r;
-- 
1.8.3.1


