Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaGNLoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:44:23 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48087 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbaGNLiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:38:55 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 02/19] KVM: x86: return all bits from get_interrupt_shadow
Date: Mon, 14 Jul 2014 13:38:26 +0200
Message-Id: <1405337923-4776-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the next patch we will need to know the full state of the
interrupt shadow; we will then set KVM_REQ_EVENT when one bit
is cleared.

However, right now get_interrupt_shadow only returns the one
corresponding to the emulated instruction, or an unconditional
0 if the emulated instruction does not have an interrupt shadow.
This is confusing and does not allow us to check for cleared
bits as mentioned above.

Clean the callback up, and modify toggle_interruptibility to
match the comment above the call.  As a small result, the
call to set_interrupt_shadow will be skipped in the common
case where int_shadow == 0 && mask == 0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              |  6 +++---
 arch/x86/kvm/vmx.c              |  4 ++--
 arch/x86/kvm/x86.c              | 10 +++++-----
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index af36f89fe67a..b8a4480176b9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -717,7 +717,7 @@ struct kvm_x86_ops {
 	int (*handle_exit)(struct kvm_vcpu *vcpu);
 	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
-	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
+	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
 	void (*set_irq)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4925a94a970a..ddf742768ecf 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -486,14 +486,14 @@ static int is_external_interrupt(u32 info)
 	return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
 }
 
-static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 ret = 0;
 
 	if (svm->vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK)
-		ret |= KVM_X86_SHADOW_INT_STI | KVM_X86_SHADOW_INT_MOV_SS;
-	return ret & mask;
+		ret = KVM_X86_SHADOW_INT_STI | KVM_X86_SHADOW_INT_MOV_SS;
+	return ret;
 }
 
 static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5c7bbde25bbf..0c9569b994f9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1943,7 +1943,7 @@ static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 
-static u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+static u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
 	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
 	int ret = 0;
@@ -1953,7 +1953,7 @@ static u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 	if (interruptibility & GUEST_INTR_STATE_MOV_SS)
 		ret |= KVM_X86_SHADOW_INT_MOV_SS;
 
-	return ret & mask;
+	return ret;
 }
 
 static void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7553530e3502..a56126e6bd75 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2978,9 +2978,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		vcpu->arch.interrupt.pending && !vcpu->arch.interrupt.soft;
 	events->interrupt.nr = vcpu->arch.interrupt.nr;
 	events->interrupt.soft = 0;
-	events->interrupt.shadow =
-		kvm_x86_ops->get_interrupt_shadow(vcpu,
-			KVM_X86_SHADOW_INT_MOV_SS | KVM_X86_SHADOW_INT_STI);
+	events->interrupt.shadow = kvm_x86_ops->get_interrupt_shadow(vcpu);
 
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending != 0;
@@ -4860,7 +4858,7 @@ static const struct x86_emulate_ops emulate_ops = {
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 {
-	u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(vcpu, mask);
+	u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(vcpu);
 	/*
 	 * an sti; sti; sequence only disable interrupts for the first
 	 * instruction. So, if the last instruction, be it emulated or
@@ -4868,7 +4866,9 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 	 * means that the last instruction is an sti. We should not
 	 * leave the flag on in this case. The same goes for mov ss
 	 */
-	if (!(int_shadow & mask))
+	if (int_shadow & mask)
+		mask = 0;
+	if (unlikely(int_shadow || mask))
 		kvm_x86_ops->set_interrupt_shadow(vcpu, mask);
 }
 
-- 
1.8.3.1


