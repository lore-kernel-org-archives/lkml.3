Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3JBO4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:56:46 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53878 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3JBO4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:41 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 5/7] KVM: mmu: remove argument to kvm_init_shadow_mmu and kvm_init_shadow_ept_mmu
Date: Wed,  2 Oct 2013 16:56:14 +0200
Message-Id: <1380725776-14948-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initialization function in mmu.c can always use walk_mmu, which
is known to be vcpu->arch.mmu.  Only init_kvm_nested_mmu is used to
initialize vcpu->arch.nested_mmu.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 15 +++++++++------
 arch/x86/kvm/mmu.h |  5 ++---
 arch/x86/kvm/svm.c |  4 ++--
 arch/x86/kvm/vmx.c |  4 ++--
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 40772ef..ac598c8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3742,11 +3742,13 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	update_last_pte_bitmap(vcpu, context);
 }
 
-void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
+void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
 {
 	bool smep = kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
+	struct kvm_mmu *context = vcpu->arch.walk_mmu;
+
 	ASSERT(vcpu);
-	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
+	ASSERT(!VALID_PAGE(context->root_hpa));
 
 	if (!is_paging(vcpu))
 		nonpaging_init_context(vcpu, context);
@@ -3765,11 +3767,12 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
 
-void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-		bool execonly)
+void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly)
 {
+	struct kvm_mmu *context = vcpu->arch.walk_mmu;
+
 	ASSERT(vcpu);
-	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
+	ASSERT(!VALID_PAGE(context->root_hpa));
 
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 
@@ -3790,7 +3793,7 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
-	kvm_init_shadow_mmu(vcpu, vcpu->arch.walk_mmu);
+	kvm_init_shadow_mmu(vcpu);
 	vcpu->arch.walk_mmu->set_cr3           = kvm_x86_ops->set_cr3;
 	vcpu->arch.walk_mmu->get_cr3           = get_cr3;
 	vcpu->arch.walk_mmu->get_pdptr         = kvm_pdptr_read;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2926152..c9d3d8f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -70,9 +70,8 @@ enum {
 };
 
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
-void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
-void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-		bool execonly);
+void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu);
+void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly);
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c7168a5..37bcd6b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1961,8 +1961,8 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 
 static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 {
-	kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);
-
+	WARN_ON(mmu_is_nested(vcpu));
+	kvm_init_shadow_mmu(vcpu);
 	vcpu->arch.mmu.set_cr3           = nested_svm_set_tdp_cr3;
 	vcpu->arch.mmu.get_cr3           = nested_svm_get_tdp_cr3;
 	vcpu->arch.mmu.get_pdptr         = nested_svm_get_tdp_pdptr;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2db9164..fdd1cb8 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7501,9 +7501,9 @@ static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
 
 static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 {
-	kvm_init_shadow_ept_mmu(vcpu, &vcpu->arch.mmu,
+	WARN_ON(mmu_is_nested(vcpu));
+	kvm_init_shadow_ept_mmu(vcpu,
 			nested_vmx_ept_caps & VMX_EPT_EXECUTE_ONLY_BIT);
-
 	vcpu->arch.mmu.set_cr3           = vmx_set_cr3;
 	vcpu->arch.mmu.get_cr3           = nested_ept_get_cr3;
 	vcpu->arch.mmu.inject_page_fault = nested_ept_inject_page_fault;
-- 
1.8.3.1


