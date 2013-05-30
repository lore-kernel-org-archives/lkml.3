Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351Ab3E3QAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:00:55 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:61301 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934231Ab3E3QAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:00:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH 2/2] KVM: x86: handle singlestep during emulation
Date: Thu, 30 May 2013 18:00:31 +0200
Message-Id: <1369929631-2101-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929631-2101-1-git-send-email-pbonzini@redhat.com>
References: <1369929631-2101-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets debugging work better during emulation of invalid
guest state.

This time the check is done after emulation, but before writeback
of the flags; we need to check the flags *before* execution of the
instruction, we cannot check singlestep_rip because the CS base may
have already been modified.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c                 | 41 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33b51bc..0728096 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4887,6 +4887,43 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 	return dr6;
 }
 
+static int kvm_vcpu_check_singlestep(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *kvm_run = vcpu->run;
+
+	/*
+	 * Use the "raw" value to see if TF was passed to the processor.
+	 * Note that the new value of the flags has not been saved yet.
+	 *
+	 * This is correct even for TF set by the guest, because "the
+	 * processor will not generate this exception after the instruction
+	 * that sets the TF flag".
+	 */
+	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
+
+	if (unlikely(rflags & X86_EFLAGS_TF)) {
+		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
+			kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1;
+			kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
+			kvm_run->debug.arch.exception = DB_VECTOR;
+			kvm_run->exit_reason = KVM_EXIT_DEBUG;
+			return EMULATE_DO_MMIO;
+		} else {
+			vcpu->arch.emulate_ctxt.eflags &= ~X86_EFLAGS_TF;
+			/*
+			 * "Certain debug exceptions may clear bit 0-3.  The
+			 * remaining contents of the DR6 register are never
+			 * cleared by the processor".
+			 */
+			vcpu->arch.dr6 &= ~15;
+			vcpu->arch.dr6 |= DR6_BS;
+			kvm_queue_exception(vcpu, DB_VECTOR);
+		}
+	}
+
+	return EMULATE_DONE;
+}
+
 static int kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
@@ -5031,10 +5068,12 @@ restart:
 
 	if (writeback) {
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
-		kvm_set_rflags(vcpu, ctxt->eflags);
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 		kvm_rip_write(vcpu, ctxt->eip);
+		if (r == EMULATE_DONE)
+			r = kvm_vcpu_check_singlestep(vcpu);
+		kvm_set_rflags(vcpu, ctxt->eflags);
 	} else
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = true;
 
-- 
1.8.1.4

