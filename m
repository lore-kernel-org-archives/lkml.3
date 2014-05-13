Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbaEMO5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:57:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39761 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981AbaEMOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:55:58 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH 3/5] KVM: vmx: always compute the CPL on KVM_SET_SREGS
Date: Tue, 13 May 2014 16:55:39 +0200
Message-Id: <1399992941-11600-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
References: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not obvious that the CPL will be guessed right the next time
we run vmx_get_cpl.  Make the code similar to SVM, and do the "guess"
already during vmx_set_segment while we have the correct value of CR0.PE.

For unrestricted guest mode, there is still a small window where CR0.PE
and we could set the CS selector to a real mode value.  It is not clear
how the processor could know the correct CPL on the next vmentry in this
case; the only way to solve it would be to force invalid guest state
in that case and emulate protected mode entry until the long jump.
Do not do this yet, since unrestricted guest seems to work with the
test case that prompted this change.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 10256c27694d..7dc5fdd30d7f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3603,14 +3603,6 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
 	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 
 	vmx_segment_cache_clear(vmx);
-	if (seg == VCPU_SREG_CS) {
-		if (set_cpl) {
-			__set_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
-			vmx->cpl = var->cpl;
-		} else
-			__clear_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
-	}
-
 	if (vmx->rmode.vm86_active && seg != VCPU_SREG_LDTR) {
 		vmx->rmode.segs[seg] = *var;
 		if (seg == VCPU_SREG_TR)
@@ -3640,6 +3632,14 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
 
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
 
+	if (seg == VCPU_SREG_CS) {
+		__set_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
+		if (set_cpl)
+			vmx->cpl = var->cpl;
+		else
+			vmx->cpl = vmx_get_cpl(vcpu);
+	}
+
 out:
 	vmx->emulation_required = emulation_required(vcpu);
 }
-- 
1.8.3.1


