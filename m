Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaC0Laz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:30:55 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:42274 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaC0Lat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:30:49 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [RFC PATCH 2/5] KVM: x86: avoid useless set of KVM_REQ_EVENT after emulation
Date: Thu, 27 Mar 2014 12:30:35 +0100
Message-Id: <1395919838-18466-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
References: <1395919838-18466-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite the provisions to emulate up to 130 consecutive instructions, in
practice KVM will emulate just one before exiting handle_invalid_guest_state,
because x86_emulate_instructionn always sets KVM_REQ_EVENT.

However, we only need to do this if an interrupt could be injected,
which happens a) if an interrupt shadow bit (STI or MOV SS) has gone
away; b) if the interrupt flag has just been set (because other
instructions than STI can set it without enabling an interrupt shadow).

This cuts another 250-300 clock cycles from the cost of emulating an
instruction (530-870 cycles before the patch on kvm-unit-tests,
290-600 afterwards).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd31aada351b..ce9523345f2e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -87,6 +87,7 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
+static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 
 struct kvm_x86_ops *kvm_x86_ops;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
@@ -4856,8 +4857,10 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 	 * means that the last instruction is an sti. We should not
 	 * leave the flag on in this case. The same goes for mov ss
 	 */
-	if (!(int_shadow & mask))
+	if (unlikely(int_shadow) && !(int_shadow & mask)) {
 		kvm_x86_ops->set_interrupt_shadow(vcpu, mask);
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	}
 }
 
 static void inject_emulated_exception(struct kvm_vcpu *vcpu)
@@ -5083,20 +5086,18 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 	return dr6;
 }
 
-static void kvm_vcpu_check_singlestep(struct kvm_vcpu *vcpu, int *r)
+static void kvm_vcpu_check_singlestep(struct kvm_vcpu *vcpu, unsigned long rflags, int *r)
 {
 	struct kvm_run *kvm_run = vcpu->run;
 
 	/*
-	 * Use the "raw" value to see if TF was passed to the processor.
-	 * Note that the new value of the flags has not been saved yet.
+	 * rflags is the old, "raw" value of the flags.  The new value has
+	 * not been saved yet.
 	 *
 	 * This is correct even for TF set by the guest, because "the
 	 * processor will not generate this exception after the instruction
 	 * that sets the TF flag".
 	 */
-	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
-
 	if (unlikely(rflags & X86_EFLAGS_TF)) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 			kvm_run->debug.arch.dr6 = DR6_BS | DR6_FIXED_1;
@@ -5263,13 +5264,15 @@ restart:
 		r = EMULATE_DONE;
 
 	if (writeback) {
+		unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
-		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 		kvm_rip_write(vcpu, ctxt->eip);
 		if (r == EMULATE_DONE)
-			kvm_vcpu_check_singlestep(vcpu, &r);
-		kvm_set_rflags(vcpu, ctxt->eflags);
+			kvm_vcpu_check_singlestep(vcpu, rflags, &r);
+		__kvm_set_rflags(vcpu, ctxt->eflags);
+		if (unlikely((ctxt->eflags & ~rflags) & X86_EFLAGS_IF))
+			kvm_make_request(KVM_REQ_EVENT, vcpu);
 	} else
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = true;
 
@@ -7385,12 +7388,17 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_get_rflags);
 
-void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
+static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
 	    kvm_is_linear_rip(vcpu, vcpu->arch.singlestep_rip))
 		rflags |= X86_EFLAGS_TF;
 	kvm_x86_ops->set_rflags(vcpu, rflags);
+}
+
+void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
+{
+	__kvm_set_rflags(vcpu, rflags);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_set_rflags);
-- 
1.8.3.1


