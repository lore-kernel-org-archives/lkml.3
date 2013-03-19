Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3CSPvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:51:32 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61491 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3CSPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:51:31 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH] x86: let userspace inject interrupts into the local APIC
Date: Tue, 19 Mar 2013 16:51:13 +0100
Message-Id: <1363708273-19653-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no way for userspace to inject interrupts into a VCPU's
local APIC, which is important in order to inject INITs coming from
the chipset.  KVM_INTERRUPT is currently disabled when the in-kernel
local APIC is used, so we can repurpose it.  The shorthand destination
field must contain APIC_DEST_SELF, which has a double effect: first,
the ICR2 register is not used and the 32-bit field of KVM_INTERRUPT is
enough; second, it ensures that the valid range of the irq field is
distinct in the userspace-APIC and kernel-APIC cases.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virtual/kvm/api.txt | 13 ++++++++++---
 arch/x86/kvm/lapic.c              | 20 +++++++++++++++-----
 arch/x86/kvm/lapic.h              |  1 +
 arch/x86/kvm/x86.c                |  6 +++---
 4 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 4237c27..a69706b 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -396,8 +396,8 @@ Type: vcpu ioctl
 Parameters: struct kvm_interrupt (in)
 Returns: 0 on success, -1 on error
 
-Queues a hardware interrupt vector to be injected.  This is only
-useful if in-kernel local APIC or equivalent is not used.
+Queues a hardware interrupt vector to be injected into either the VCPU
+or into the in-kernel local APIC or equivalent (if in use).
 
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
@@ -407,7 +407,14 @@ struct kvm_interrupt {
 
 X86:
 
-Note 'irq' is an interrupt vector, not an interrupt pin or line.
+If the in-kernel local APIC is enabled, 'irq' is sent to the local APIC
+as if it were written to the ICR register, except that it is not reflected
+into ICR if the guest reads it.  The destination (bits 18 and 19) must be
+set to APIC_DEST_SELF.
+
+If the in-kernel local APIC is disabled, 'irq' is an interrupt vector (not
+an interrupt pin or line) that is injected synchronously into the VCPU.
+
 
 PPC:
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a8e9369..efb67f7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -826,12 +826,9 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 }
 EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
 
-static void apic_send_ipi(struct kvm_lapic *apic)
+static void apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 {
-	u32 icr_low = kvm_apic_get_reg(apic, APIC_ICR);
-	u32 icr_high = kvm_apic_get_reg(apic, APIC_ICR2);
 	struct kvm_lapic_irq irq;
-
 	irq.vector = icr_low & APIC_VECTOR_MASK;
 	irq.delivery_mode = icr_low & APIC_MODE_MASK;
 	irq.dest_mode = icr_low & APIC_DEST_MASK;
@@ -855,6 +852,16 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq);
 }
 
+int kvm_lapic_ioctl_interrupt(struct kvm_vcpu *vcpu, u32 value)
+{
+	if ((value & APIC_SHORT_MASK) != APIC_DEST_SELF)
+		return -EINVAL;
+
+	apic_send_ipi(vcpu->arch.apic, value, 0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_lapic_ioctl_interrupt);
+
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
 	ktime_t remaining;
@@ -1155,7 +1162,10 @@ static int apic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 	case APIC_ICR:
 		/* No delay here, so we always clear the pending bit */
 		apic_set_reg(apic, APIC_ICR, val & ~(1 << 12));
-		apic_send_ipi(apic);
+		apic_send_ipi(apic,
+			      kvm_apic_get_reg(apic, APIC_ICR),
+			      kvm_apic_get_reg(apic, APIC_ICR2));
+
 		break;
 
 	case APIC_ICR2:
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2c721b9..0631b5c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -49,6 +49,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
+int kvm_lapic_ioctl_interrupt(struct kvm_vcpu *vcpu, u32 value);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e0a8ba..ab4a401 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2703,11 +2703,11 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 				    struct kvm_interrupt *irq)
 {
-	if (irq->irq >= KVM_NR_INTERRUPTS)
-		return -EINVAL;
 	if (irqchip_in_kernel(vcpu->kvm))
-		return -ENXIO;
+		return kvm_lapic_ioctl_interrupt(vcpu, irq->irq);
 
+	if (irq->irq >= KVM_NR_INTERRUPTS)
+		return -EINVAL;
 	kvm_queue_interrupt(vcpu, irq->irq, false);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
-- 
1.8.1.4

