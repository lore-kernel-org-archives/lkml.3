Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaLCHyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:54:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaLCHuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852356"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 13/25] KVM: Define a new interface kvm_find_dest_vcpu() for VT-d PI
Date: Wed,  3 Dec 2014 15:39:42 +0800
Message-Id: <1417592394-24343-14-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines a new interface kvm_find_dest_vcpu for
VT-d PI, which can returns the destination vCPU of the
interrupt for guests.

Since VT-d PI cannot handle broadcast/multicast interrupt,
Here we only handle Fixed and Lowest priority interrupts.

The current method of handling guest lowest priority interrtups
is to use a counter 'apic_arb_prio' for each vCPU, we choose the
vCPU with smallest 'apic_arb_prio' and then increase it by 1.
However, for VT-d PI, we cannot re-use this, since we no longer
have control to 'apic_arb_prio' with posted interrupt direct
delivery by Hardware.

Here, we introduce a similar way with 'apic_arb_prio' to handle
guest lowest priority interrtups when VT-d PI is used. Here is the
ideas:
- Each vCPU has a counter 'round_robin_counter'.
- When guests sets an interrupts to lowest priority, we choose
the vCPU with smallest 'round_robin_counter' as the destination,
then increase it.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/include/asm/kvm_host.h |    4 +++
 virt/kvm/irq_comm.c             |   41 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ed0c30..7a41808 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -358,6 +358,7 @@ struct kvm_vcpu_arch {
 	struct kvm_lapic *apic;    /* kernel irqchip context */
 	unsigned long apic_attention;
 	int32_t apic_arb_prio;
+	int32_t round_robin_counter;
 	int mp_state;
 	u64 ia32_misc_enable_msr;
 	bool tpr_access_reporting;
@@ -1093,4 +1094,7 @@ int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
 void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
 void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
 
+bool kvm_find_dest_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
+			struct kvm_vcpu **dest_vcpu);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 963b899..f3c5d69 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -317,6 +317,47 @@ out:
 	return r;
 }
 
+int kvm_compare_rr_counter(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
+{
+	return vcpu1->arch.round_robin_counter -
+			vcpu2->arch.round_robin_counter;
+}
+
+bool kvm_find_dest_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
+				struct kvm_vcpu **dest_vcpu)
+{
+	int i, r = 0;
+	struct kvm_vcpu *vcpu, *dest = NULL;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_apic_present(vcpu))
+			continue;
+
+		if (!kvm_apic_match_dest(vcpu, NULL, irq->shorthand,
+					irq->dest_id, irq->dest_mode))
+			continue;
+
+		if (!kvm_is_dm_lowest_prio(irq)) {
+			r++;
+			*dest_vcpu = vcpu;
+		} else if (kvm_lapic_enabled(vcpu)) {
+			if (!dest)
+				dest = vcpu;
+			else if (kvm_compare_rr_counter(vcpu, dest) < 0)
+				dest = vcpu;
+		}
+	}
+
+	if (dest) {
+		dest->arch.round_robin_counter++;
+		*dest_vcpu = dest;
+		return true;
+	} else if (r == 1)
+		return true;
+
+	return false;
+}
+
 #define IOAPIC_ROUTING_ENTRY(irq) \
 	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
 	  .u.irqchip = { .irqchip = KVM_IRQCHIP_IOAPIC, .pin = (irq) } }
-- 
1.7.1

