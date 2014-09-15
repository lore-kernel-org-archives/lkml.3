Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbaIOWzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:55:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50923 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbaIOWQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 160/187] KVM: nVMX: fix "acknowledge interrupt on exit" when APICv is in use
Date: Mon, 15 Sep 2014 15:09:30 -0700
Message-Id: <1410818997-9432-161-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wanpeng Li <wanpeng.li@linux.intel.com>

commit 56cc2406d68c0f09505c389e276f27a99f495cbd upstream.

After commit 77b0f5d (KVM: nVMX: Ack and write vector info to intr_info
if L1 asks us to), "Acknowledge interrupt on exit" behavior can be
emulated. To do so, KVM will ask the APIC for the interrupt vector if
during a nested vmexit if VM_EXIT_ACK_INTR_ON_EXIT is set.  With APICv,
kvm_get_apic_interrupt would return -1 and give the following WARNING:

Call Trace:
 [<ffffffff81493563>] dump_stack+0x49/0x5e
 [<ffffffff8103f0eb>] warn_slowpath_common+0x7c/0x96
 [<ffffffffa059709a>] ? nested_vmx_vmexit+0xa4/0x233 [kvm_intel]
 [<ffffffff8103f11a>] warn_slowpath_null+0x15/0x17
 [<ffffffffa059709a>] nested_vmx_vmexit+0xa4/0x233 [kvm_intel]
 [<ffffffffa0594295>] ? nested_vmx_exit_handled+0x6a/0x39e [kvm_intel]
 [<ffffffffa0537931>] ? kvm_apic_has_interrupt+0x80/0xd5 [kvm]
 [<ffffffffa05972ec>] vmx_check_nested_events+0xc3/0xd3 [kvm_intel]
 [<ffffffffa051ebe9>] inject_pending_event+0xd0/0x16e [kvm]
 [<ffffffffa051efa0>] vcpu_enter_guest+0x319/0x704 [kvm]

To fix this, we cannot rely on the processor's virtual interrupt delivery,
because "acknowledge interrupt on exit" must only update the virtual
ISR/PPR/IRR registers (and SVI, which is just a cache of the virtual ISR)
but it should not deliver the interrupt through the IDT.  Thus, KVM has
to deliver the interrupt "by hand", similar to the treatment of EOI in
commit fc57ac2c9ca8 (KVM: lapic: sync highest ISR to hardware apic on
EOI, 2014-05-14).

The patch modifies kvm_cpu_get_interrupt to always acknowledge an
interrupt; there are only two callers, and the other is not affected
because it is never reached with kvm_apic_vid_enabled() == true.  Then it
modifies apic_set_isr and apic_clear_irr to update SVI and RVI in addition
to the registers.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: "Zhang, Yang Z" <yang.z.zhang@intel.com>
Tested-by: Liu, RongrongX <rongrongx.liu@intel.com>
Tested-by: Felipe Reyes <freyes@suse.com>
Fixes: 77b0f5d67ff2781f36831cba79674c3e97bd7acf
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/irq.c   |  2 +-
 arch/x86/kvm/lapic.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 484bc87..3ec38cb 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -108,7 +108,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 
 	vector = kvm_cpu_get_extint(v);
 
-	if (kvm_apic_vid_enabled(v->kvm) || vector != -1)
+	if (vector != -1)
 		return vector;			/* PIC */
 
 	return kvm_get_apic_interrupt(v);	/* APIC */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 92bbb39..f52e300 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -352,25 +352,46 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
 
 static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 {
-	apic->irr_pending = false;
+	struct kvm_vcpu *vcpu;
+
+	vcpu = apic->vcpu;
+
 	apic_clear_vector(vec, apic->regs + APIC_IRR);
-	if (apic_search_irr(apic) != -1)
-		apic->irr_pending = true;
+	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
+		/* try to update RVI */
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	else {
+		vec = apic_search_irr(apic);
+		apic->irr_pending = (vec != -1);
+	}
 }
 
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
-	/* Note that we never get here with APIC virtualization enabled.  */
+	struct kvm_vcpu *vcpu;
+
+	if (__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
+		return;
+
+	vcpu = apic->vcpu;
 
-	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
-		++apic->isr_count;
-	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
 	/*
-	 * ISR (in service register) bit is set when injecting an interrupt.
-	 * The highest vector is injected. Thus the latest bit set matches
-	 * the highest bit in ISR.
+	 * With APIC virtualization enabled, all caching is disabled
+	 * because the processor can modify ISR under the hood.  Instead
+	 * just set SVI.
 	 */
-	apic->highest_isr_cache = vec;
+	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
+		kvm_x86_ops->hwapic_isr_update(vcpu->kvm, vec);
+	else {
+		++apic->isr_count;
+		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
+		/*
+		 * ISR (in service register) bit is set when injecting an interrupt.
+		 * The highest vector is injected. Thus the latest bit set matches
+		 * the highest bit in ISR.
+		 */
+		apic->highest_isr_cache = vec;
+	}
 }
 
 static inline int apic_find_highest_isr(struct kvm_lapic *apic)
@@ -1627,11 +1648,16 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	int vector = kvm_apic_has_interrupt(vcpu);
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	/* Note that we never get here with APIC virtualization enabled.  */
-
 	if (vector == -1)
 		return -1;
 
+	/*
+	 * We get here even with APIC virtualization enabled, if doing
+	 * nested virtualization and L1 runs with the "acknowledge interrupt
+	 * on exit" mode.  Then we cannot inject the interrupt via RVI,
+	 * because the process would deliver it through the IDT.
+	 */
+
 	apic_set_isr(vector, apic);
 	apic_update_ppr(apic);
 	apic_clear_irr(vector, apic);
-- 
1.9.1

