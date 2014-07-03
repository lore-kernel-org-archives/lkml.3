Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090AbaGCKL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:11:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302AbaGCJVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/198] KVM: lapic: sync highest ISR to hardware apic on EOI
Date: Thu,  3 Jul 2014 10:18:07 +0100
Message-Id: <1404379241-8590-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit fc57ac2c9ca8109ea97fcc594f4be436944230cc upstream.

When Hyper-V enlightenments are in effect, Windows prefers to issue an
Hyper-V MSR write to issue an EOI rather than an x2apic MSR write.
The Hyper-V MSR write is not handled by the processor, and besides
being slower, this also causes bugs with APIC virtualization.  The
reason is that on EOI the processor will modify the highest in-service
interrupt (SVI) field of the VMCS, as explained in section 29.1.4 of
the SDM; every other step in EOI virtualization is already done by
apic_send_eoi or on VM entry, but this one is missing.

We need to do the same, and be careful not to muck with the isr_count
and highest_isr_cache fields that are unused when virtual interrupt
delivery is enabled.

Reviewed-by: Yang Zhang <yang.z.zhang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/lapic.c | 62 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 256816b73460..ad86e3b1df92 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -370,6 +370,8 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
+	/* Note that we never get here with APIC virtualization enabled.  */
+
 	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
 		++apic->isr_count;
 	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -381,12 +383,48 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	apic->highest_isr_cache = vec;
 }
 
+static inline int apic_find_highest_isr(struct kvm_lapic *apic)
+{
+	int result;
+
+	/*
+	 * Note that isr_count is always 1, and highest_isr_cache
+	 * is always -1, with APIC virtualization enabled.
+	 */
+	if (!apic->isr_count)
+		return -1;
+	if (likely(apic->highest_isr_cache != -1))
+		return apic->highest_isr_cache;
+
+	result = find_highest_vector(apic->regs + APIC_ISR);
+	ASSERT(result == -1 || result >= 16);
+
+	return result;
+}
+
 static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 {
-	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
+	struct kvm_vcpu *vcpu;
+	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
+		return;
+
+	vcpu = apic->vcpu;
+
+	/*
+	 * We do get here for APIC virtualization enabled if the guest
+	 * uses the Hyper-V APIC enlightenment.  In this case we may need
+	 * to trigger a new interrupt delivery by writing the SVI field;
+	 * on the other hand isr_count and highest_isr_cache are unused
+	 * and must be left alone.
+	 */
+	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
+		kvm_x86_ops->hwapic_isr_update(vcpu->kvm,
+					       apic_find_highest_isr(apic));
+	else {
 		--apic->isr_count;
-	BUG_ON(apic->isr_count < 0);
-	apic->highest_isr_cache = -1;
+		BUG_ON(apic->isr_count < 0);
+		apic->highest_isr_cache = -1;
+	}
 }
 
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
@@ -466,22 +504,6 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
 }
 
-static inline int apic_find_highest_isr(struct kvm_lapic *apic)
-{
-	int result;
-
-	/* Note that isr_count is always 1 with vid enabled */
-	if (!apic->isr_count)
-		return -1;
-	if (likely(apic->highest_isr_cache != -1))
-		return apic->highest_isr_cache;
-
-	result = find_highest_vector(apic->regs + APIC_ISR);
-	ASSERT(result == -1 || result >= 16);
-
-	return result;
-}
-
 void kvm_apic_update_tmr(struct kvm_vcpu *vcpu, u32 *tmr)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -1619,6 +1641,8 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	int vector = kvm_apic_has_interrupt(vcpu);
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
+	/* Note that we never get here with APIC virtualization enabled.  */
+
 	if (vector == -1)
 		return -1;
 
-- 
1.9.1

