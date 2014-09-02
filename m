Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaIBPOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:14:10 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62560 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaIBPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:14:05 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jroedel@suse.de, agraf@suse.de, valentine.sinitsyn@gmail.com,
        jan.kiszka@siemens.com, gleb@cloudius-systems.com,
        avi@cloudius-systems.com
Subject: [PATCH 3/4] KVM: x86: inject nested page faults on emulated instructions
Date: Tue,  2 Sep 2014 17:13:49 +0200
Message-Id: <1409670830-14544-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for the following patch to work correctly.  If a nested page
fault happens during emulation, we must inject a vmexit, not a page fault.
Luckily we already have the required machinery: it is enough to return
X86EMUL_INTERCEPTED instead of X86EMUL_PROPAGATE_FAULT.

Reported-by: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e4ed85e07a01..9e3b74c044ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -416,6 +416,16 @@ void kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 		vcpu->arch.mmu.inject_page_fault(vcpu, fault);
 }
 
+static inline int kvm_propagate_or_intercept(struct kvm_vcpu *vcpu,
+					     struct x86_exception *exception)
+{
+	if (likely(!exception->nested_page_fault))
+		return X86EMUL_PROPAGATE_FAULT;
+
+	vcpu->arch.mmu.inject_page_fault(vcpu, exception);
+	return X86EMUL_INTERCEPTED;
+}
+
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	atomic_inc(&vcpu->arch.nmi_queued);
@@ -4122,7 +4132,7 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 		int ret;
 
 		if (gpa == UNMAPPED_GVA)
-			return X86EMUL_PROPAGATE_FAULT;
+			return kvm_propagate_or_intercept(vcpu, exception);
 		ret = kvm_read_guest_page(vcpu->kvm, gpa >> PAGE_SHIFT, data,
 					  offset, toread);
 		if (ret < 0) {
@@ -4152,7 +4162,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 	gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr, access|PFERR_FETCH_MASK,
 						    exception);
 	if (unlikely(gpa == UNMAPPED_GVA))
-		return X86EMUL_PROPAGATE_FAULT;
+		return kvm_propagate_or_intercept(vcpu, exception);
 
 	offset = addr & (PAGE_SIZE-1);
 	if (WARN_ON(offset + bytes > PAGE_SIZE))
@@ -4203,7 +4213,7 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
 		int ret;
 
 		if (gpa == UNMAPPED_GVA)
-			return X86EMUL_PROPAGATE_FAULT;
+			return kvm_propagate_or_intercept(vcpu, exception);
 		ret = kvm_write_guest(vcpu->kvm, gpa, data, towrite);
 		if (ret < 0) {
 			r = X86EMUL_IO_NEEDED;
@@ -4350,7 +4360,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	ret = vcpu_mmio_gva_to_gpa(vcpu, addr, &gpa, exception, write);
 
 	if (ret < 0)
-		return X86EMUL_PROPAGATE_FAULT;
+		return kvm_propagate_or_intercept(vcpu, exception);
 
 	/* For APIC access vmexit */
 	if (ret)
-- 
1.8.3.1


