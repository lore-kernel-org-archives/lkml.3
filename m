Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaHAINU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:13:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:40144 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbaHAINT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,778,1400050800"; 
   d="scan'208";a="552253985"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 2/2] KVM: nVMX: fix acknowledge interrupt on exit when APICv is in use
Date: Fri,  1 Aug 2014 16:13:13 +0800
Message-Id: <1406880793-16854-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

If enabling APIC-v, all interrupts to L1 are delivered through APIC-v.
But when L2 is running, external interrupt will casue L1 vmexit with
reason external interrupt. Then L1 will pick up the interrupt through
vmcs12. when L1 ack the interrupt, since the APIC-v is enabled when
L1 is running, so APIC-v hardware still will do vEOI updating. The problem
is that the interrupt is delivered not through APIC-v hardware, this means
SVI/RVI/vPPR are not setting, but hardware required them when doing vEOI
updating. The solution is that, when L1 tried to pick up the interrupt
from vmcs12, then hypervisor will help to update the SVI/RVI/vPPR to make
sure the following vEOI updating and vPPR updating corrently.
    
Also, since interrupt is delivered through vmcs12, so APIC-v hardware will
not cleare vIRR and hypervisor need to clear it before L1 running.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: "Zhang, Yang Z" <yang.z.zhang@intel.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/lapic.c | 18 ++++++++++++++++++
 arch/x86/kvm/lapic.h |  1 +
 arch/x86/kvm/vmx.c   | 10 ++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3855103..06942b9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -534,6 +534,24 @@ static void apic_set_tpr(struct kvm_lapic *apic, u32 tpr)
 	apic_update_ppr(apic);
 }
 
+int kvm_lapic_ack_apicv(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	int vec;
+
+	vec = kvm_apic_has_interrupt(vcpu);
+
+	if (vec == -1)
+		return vec;
+
+	apic_set_vector(vec, apic->regs + APIC_ISR);
+	apic_update_ppr(apic);
+	apic_clear_vector(vec, apic->regs + APIC_IRR);
+
+	return vec;
+}
+EXPORT_SYMBOL_GPL(kvm_lapic_ack_apicv);
+
 int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest)
 {
 	return dest == 0xff || kvm_apic_id(apic) == dest;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 6a11845..ead1392 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -169,5 +169,6 @@ static inline bool kvm_apic_has_events(struct kvm_vcpu *vcpu)
 }
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
+int kvm_lapic_ack_apicv(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b8122b3..c604f3c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8766,6 +8766,16 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
 	    && nested_exit_intr_ack_set(vcpu)) {
 		int irq = kvm_cpu_get_interrupt(vcpu);
+
+		if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm)) {
+			irq = kvm_lapic_ack_apicv(vcpu);
+			if (irq >= 0) {
+				vmx_hwapic_isr_update(vcpu->kvm, irq);
+				/* try to update RVI */
+				kvm_make_request(KVM_REQ_EVENT, vcpu);
+			}
+		}
+
 		WARN_ON(irq < 0);
 		vmcs12->vm_exit_intr_info = irq |
 			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
-- 
1.9.1

