Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaF3MO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:14:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51972 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 056/181] KVM: lapic: sync highest ISR to hardware apic on EOI
Date: Mon, 30 Jun 2014 13:51:17 +0200
Message-Id: <ec66ea0e5b022fff3a6f5704170e64f0f7d14b4d.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kvm/lapic.c | 62 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d86ff15fc89f..92bbb397f59d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -360,6 +360,8 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
+	/* Note that we never get here with APIC virtualization enabled.  */
+
 	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
 		++apic->isr_count;
 	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -371,12 +373,48 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
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
@@ -456,22 +494,6 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
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
@@ -1605,6 +1627,8 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	int vector = kvm_apic_has_interrupt(vcpu);
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
+	/* Note that we never get here with APIC virtualization enabled.  */
+
 	if (vector == -1)
 		return -1;
 
-- 
2.0.0

