Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab3CIGso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 01:48:44 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53499 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab3CIGsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 01:48:43 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: [PATCH] x86: kvm: reset the bootstrap processor when it gets an INIT
Date: Sat,  9 Mar 2013 07:48:33 +0100
Message-Id: <1362811713-25830-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After receiving an INIT signal (either via the local APIC, or through
KVM_SET_MP_STATE), the bootstrap processor should reset immediately
and start execution at 0xfffffff0.  Also, SIPIs have no effect on the
bootstrap processor.  However, KVM currently does not differentiate
between the BSP and APs.

Implement this so that userspace can correctly implement CPU soft resets
even when the in-kernel APIC is in use.  Another small change is needed,
because INITs sent to the bootstrap processor do not go through a halt
state; it is incorrect to go through kvm_vcpu_block.  I think this also
fixes a race before between sending the INIT and SIPI interrupts; if the
two were close enough, the receiving VCPU could have received the SIPI
before entering kvm_vcpu_block.  It would them stay in kvm_vcpu_block
until the next kvm_vcpu_kick.  In practice this was not a problem,
because the Intel SDM suggests to send two SIPIs with some time passing
between them; the second SIPI would unblock the VCPU.

The tests in vcpu_needs_reset are organized so that the hypervisor
will go through the same number of compare-and-jump sequences as
before in the common case.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c |  3 ++-
 arch/x86/kvm/x86.c   | 23 +++++++++++++++++++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9392f52..0c515ac 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -710,7 +710,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	case APIC_DM_STARTUP:
 		apic_debug("SIPI to vcpu %d vector 0x%02x\n",
 			   vcpu->vcpu_id, vector);
-		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
+		if (!kvm_vcpu_is_bsp(apic->vcpu) &&
+		    vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			result = 1;
 			vcpu->arch.sipi_vector = vector;
 			vcpu->arch.mp_state = KVM_MP_STATE_SIPI_RECEIVED;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c243b81..603e6ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5784,15 +5784,29 @@ out:
 	return r;
 }
 
+static inline int vcpu_needs_reset(struct kvm_vcpu *vcpu)
+{
+	/* Shortcut the test in the common case.  */
+	if (likely(vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE))
+		return 0;
+
+	if (kvm_vcpu_is_bsp(vcpu))
+		return vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED;
+	else
+		return vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED;
+}
 
 static int __vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
 	struct kvm *kvm = vcpu->kvm;
 
-	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED)) {
-		pr_debug("vcpu %d received sipi with vector # %x\n",
-			 vcpu->vcpu_id, vcpu->arch.sipi_vector);
+	if (unlikely(vcpu_needs_reset(vcpu))) {
+		if (kvm_vcpu_is_bsp(vcpu))
+			pr_debug("vcpu %d received init\n", vcpu->vcpu_id);
+		else
+			pr_debug("vcpu %d received sipi with vector # %x\n",
+				 vcpu->vcpu_id, vcpu->arch.sipi_vector);
 		kvm_lapic_reset(vcpu);
 		r = kvm_vcpu_reset(vcpu);
 		if (r)
@@ -5812,6 +5826,8 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		    !vcpu->arch.apf.halted)
 			r = vcpu_enter_guest(vcpu);
+		else if (unlikely(vcpu_needs_reset(vcpu)))
+			r = -EINTR;
 		else {
 			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
 			kvm_vcpu_block(vcpu);
@@ -5825,7 +5841,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 				case KVM_MP_STATE_RUNNABLE:
 					vcpu->arch.apf.halted = false;
 					break;
-				case KVM_MP_STATE_SIPI_RECEIVED:
 				default:
 					r = -EINTR;
 					break;
-- 
1.8.1.4

