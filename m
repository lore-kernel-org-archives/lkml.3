Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904AbaEMO4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:56:08 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44454 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbaEMO4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:56:00 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: [PATCH 4/5] KVM: vmx: force CPL=0 on real->protected mode transition
Date: Tue, 13 May 2014 16:55:40 +0200
Message-Id: <1399992941-11600-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
References: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing 1 to CR0.PE, the CPL remains 0 even if bits 0-1 of CS
disagree.  Before calling vmx_set_cr0, VCPU_EXREG_CPL was cleared
by vmx_vcpu_run, so set it again and make sure that enter_pmode
does not change it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7dc5fdd30d7f..7440cce3bf30 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3102,7 +3102,7 @@ static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		 * CS and SS RPL should be equal during guest entry according
 		 * to VMX spec, but in reality it is not always so. Since vcpu
 		 * is in the middle of the transition from real mode to
-		 * protected mode it is safe to assume that RPL 0 is a good
+		 * protected mode, the CPL is 0; thus RPL 0 is a good
 		 * default value.
 		 */
 		if (seg == VCPU_SREG_CS || seg == VCPU_SREG_SS)
@@ -3110,7 +3110,7 @@ static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		save->dpl = save->selector & SELECTOR_RPL_MASK;
 		save->s = 1;
 	}
-	vmx_set_segment(vcpu, save, seg, false);
+	vmx_set_segment(vcpu, save, seg, true);
 }
 
 static void enter_pmode(struct kvm_vcpu *vcpu)
@@ -3151,10 +3151,6 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 	fix_pmode_seg(vcpu, VCPU_SREG_DS, &vmx->rmode.segs[VCPU_SREG_DS]);
 	fix_pmode_seg(vcpu, VCPU_SREG_FS, &vmx->rmode.segs[VCPU_SREG_FS]);
 	fix_pmode_seg(vcpu, VCPU_SREG_GS, &vmx->rmode.segs[VCPU_SREG_GS]);
-
-	/* CPL is always 0 when CPU enters protected mode */
-	__set_bit(VCPU_EXREG_CPL, (ulong *)&vcpu->arch.regs_avail);
-	vmx->cpl = 0;
 }
 
 static void fix_rmode_seg(int seg, struct kvm_segment *save)
@@ -3397,11 +3393,21 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	else {
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON;
 
-		if (vmx->rmode.vm86_active && (cr0 & X86_CR0_PE))
-			enter_pmode(vcpu);
+		if (cr0 & X86_CR0_PE) {
+			/*
+			 * CPL is always 0 when CPU enters protected
+			 * mode, bits 0-1 of CS do not matter.
+			 */
+			__set_bit(VCPU_EXREG_CPL,
+				  (ulong *)&vcpu->arch.regs_avail);
+			vmx->cpl = 0;
 
-		if (!vmx->rmode.vm86_active && !(cr0 & X86_CR0_PE))
-			enter_rmode(vcpu);
+			if (vmx->rmode.vm86_active)
+				enter_pmode(vcpu);
+		} else {
+			if (!vmx->rmode.vm86_active)
+				enter_rmode(vcpu);
+		}
 	}
 
 #ifdef CONFIG_X86_64
-- 
1.8.3.1


