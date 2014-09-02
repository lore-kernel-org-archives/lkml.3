Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaIBPOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:14:31 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:47470 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbaIBPOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:14:07 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jroedel@suse.de, agraf@suse.de, valentine.sinitsyn@gmail.com,
        jan.kiszka@siemens.com, gleb@cloudius-systems.com,
        avi@cloudius-systems.com
Subject: [PATCH 4/4] KVM: x86: propagate exception from permission checks on the nested page fault
Date: Tue,  2 Sep 2014 17:13:50 +0200
Message-Id: <1409670830-14544-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if a permission error happens during the translation of
the final GPA to HPA, walk_addr_generic returns 0 but does not fill
in walker->fault.  To avoid this, add an x86_exception* argument
to the translate_gpa function, and let it fill in walker->fault.
The nested_page_fault field will be true, since the walk_mmu is the
nested_mmu and translate_gpu instead operates on the "outer" (NPT)
instance.

Reported-by: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 9 ++++++---
 arch/x86/kvm/mmu.c              | 2 +-
 arch/x86/kvm/paging_tmpl.h      | 7 ++++---
 arch/x86/kvm/x86.c              | 9 +++++----
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 08cc299ec6f4..6bf2f3c7e180 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -262,7 +262,8 @@ struct kvm_mmu {
 				  struct x86_exception *fault);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    struct x86_exception *exception);
-	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access);
+	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+			       struct x86_exception *exception);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva);
@@ -924,7 +925,8 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
-gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access);
+gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+			   struct x86_exception *exception);
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 			      struct x86_exception *exception);
 gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
@@ -944,7 +946,8 @@ void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu);
 void kvm_enable_tdp(void);
 void kvm_disable_tdp(void);
 
-static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
+static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+				  struct x86_exception *exception)
 {
 	return gpa;
 }
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5b93a597e0c8..76398fe15df2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3200,7 +3200,7 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
 {
 	if (exception)
 		exception->error_code = 0;
-	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access);
+	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access, exception);
 }
 
 static bool quickly_check_mmio_pf(struct kvm_vcpu *vcpu, u64 addr, bool direct)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 99d4c4e836a0..a97e9214ebce 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -321,14 +321,15 @@ retry_walk:
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
 		real_gfn = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
-					      PFERR_USER_MASK|PFERR_WRITE_MASK);
+					      PFERR_USER_MASK|PFERR_WRITE_MASK,
+					      &walker->fault);
 
 		/*
 		 * Can this happen (except if the guest is playing TOCTTOU games)?
 		 * We should have gotten a nested page fault on table_gfn instead.
 		 */
 		if (unlikely(real_gfn == UNMAPPED_GVA))
-			goto error;
+			return 0;
 
 		real_gfn = gpa_to_gfn(real_gfn);
 
@@ -370,7 +371,7 @@ retry_walk:
 	if (PTTYPE == 32 && walker->level == PT_DIRECTORY_LEVEL && is_cpuid_PSE36())
 		gfn += pse36_gfn_delta(pte);
 
-	real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn), access);
+	real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn), access, &walker->fault);
 	if (real_gpa == UNMAPPED_GVA)
 		return 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e3b74c044ed..022513bf92f1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -467,11 +467,12 @@ int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gfn_t ngfn, void *data, int offset, int len,
 			    u32 access)
 {
+	struct x86_exception exception;
 	gfn_t real_gfn;
 	gpa_t ngpa;
 
 	ngpa     = gfn_to_gpa(ngfn);
-	real_gfn = mmu->translate_gpa(vcpu, ngpa, access);
+	real_gfn = mmu->translate_gpa(vcpu, ngpa, access, &exception);
 	if (real_gfn == UNMAPPED_GVA)
 		return -EFAULT;
 
@@ -4073,16 +4074,16 @@ void kvm_get_segment(struct kvm_vcpu *vcpu,
 	kvm_x86_ops->get_segment(vcpu, var, seg);
 }
 
-gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
+gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
+			   struct x86_exception *exception)
 {
 	gpa_t t_gpa;
-	struct x86_exception exception;
 
 	BUG_ON(!mmu_is_nested(vcpu));
 
 	/* NPT walks are always user-walks */
 	access |= PFERR_USER_MASK;
-	t_gpa  = vcpu->arch.mmu.gva_to_gpa(vcpu, gpa, access, &exception);
+	t_gpa  = vcpu->arch.mmu.gva_to_gpa(vcpu, gpa, access, exception);
 
 	return t_gpa;
 }
-- 
1.8.3.1

