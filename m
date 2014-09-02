Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaIBPOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:14:07 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35222 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbaIBPOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:14:03 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jroedel@suse.de, agraf@suse.de, valentine.sinitsyn@gmail.com,
        jan.kiszka@siemens.com, gleb@cloudius-systems.com,
        avi@cloudius-systems.com
Subject: [PATCH 2/4] KVM: nSVM: propagate the NPF EXITINFO to the guest
Date: Tue,  2 Sep 2014 17:13:48 +0200
Message-Id: <1409670830-14544-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to what the EPT code does with the exit qualification.
This allows the guest to see a valid value for bits 33:32.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h |  6 ++++++
 arch/x86/kvm/svm.c         | 26 ++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 410776528265..99d4c4e836a0 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -322,8 +322,14 @@ retry_walk:
 
 		real_gfn = mmu->translate_gpa(vcpu, gfn_to_gpa(table_gfn),
 					      PFERR_USER_MASK|PFERR_WRITE_MASK);
+
+		/*
+		 * Can this happen (except if the guest is playing TOCTTOU games)?
+		 * We should have gotten a nested page fault on table_gfn instead.
+		 */
 		if (unlikely(real_gfn == UNMAPPED_GVA))
 			goto error;
+
 		real_gfn = gpa_to_gfn(real_gfn);
 
 		host_addr = gfn_to_hva_prot(vcpu->kvm, real_gfn,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8ef704037370..bd78a3baca31 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1974,10 +1974,28 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm->vmcb->control.exit_code = SVM_EXIT_NPF;
-	svm->vmcb->control.exit_code_hi = 0;
-	svm->vmcb->control.exit_info_1 = fault->error_code;
-	svm->vmcb->control.exit_info_2 = fault->address;
+	/*
+	 * We can keep the value that the processor stored in the VMCB,
+	 * but make up something sensible if we hit the WARN.
+	 */
+	if (WARN_ON(svm->vmcb->control.exit_code != SVM_EXIT_NPF)) {
+		svm->vmcb->control.exit_code = SVM_EXIT_NPF;
+		svm->vmcb->control.exit_code_hi = 0;
+		svm->vmcb->control.exit_info_1 = (1ULL << 32);
+		svm->vmcb->control.exit_info_2 = fault->address;
+	}
+
+	/*
+	 * The present bit is always zero for page structure faults on real
+	 * hardware, but we compute it as 1 in fault->error_code.  We can
+	 * just keep the original exit info for page structure faults---but
+	 * not for other faults, because the processor's error code might
+	 * be wrong if we have just created a shadow PTE.
+	 */
+	if (svm->vmcb->control.exit_info_1 & (1ULL << 32)) {
+		svm->vmcb->control.exit_info_1 &= ~0xffffffffULL;
+		svm->vmcb->control.exit_info_1 |= fault->error_code;
+	}
 
 	nested_svm_vmexit(svm);
 }
-- 
1.8.3.1


