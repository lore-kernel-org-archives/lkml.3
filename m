Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3HZInH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:43:07 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58897 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3HZInD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:43:03 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>, <gleb@redhat.com>,
        <pbonzini@redhat.com>
Cc: <jeremy@goop.org>, <konrad.wilk@oracle.com>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <agraf@suse.de>, digitaleric@google.com,
        <riel@redhat.com>, <avi.kivity@gmail.com>,
        <habanero@linux.vnet.ibm.com>, <chegu_vinod@hp.com>,
        <ouyang@cs.pitt.edu>, <drjones@redhat.com>, linux-doc@vger.kernel.org,
        <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <andi@firstfloor.org>,
        <virtualization@lists.linux-foundation.org>, <mtosatti@redhat.com>,
        <srivatsa.vaddagiri@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH V13 2/4] kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks
Date: Mon, 26 Aug 2013 14:18:34 +0530
Message-Id: <1377506916-26946-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377506916-26946-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <y>
 <1377506916-26946-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082608-9332-0000-0000-00000134B142
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

kvm_hc_kick_cpu allows the calling vcpu to kick another vcpu out of halt state.
the presence of these hypercalls is indicated to guest via
kvm_feature_pv_unhalt.

Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
During migration, any vcpu that got kicked but did not become runnable
(still in halted state) should be runnable after migration.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
[Raghu: Apic related changes, folding pvunhalted into vcpu_runnable
 Added flags for future use (suggested by Gleb)]
[ Raghu: fold pv_unhalt flag as suggested by Eric Northup]
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/cpuid.c            |  3 ++-
 arch/x86/kvm/x86.c              | 44 ++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f87f7fc..1d1f711 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -511,6 +511,11 @@ struct kvm_vcpu_arch {
 	 * instruction.
 	 */
 	bool write_fault_to_shadow_pgtable;
+
+	/* pv related host specific info */
+	struct {
+		bool pv_unhalted;
+	} pv;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a20ecb5..b110fe6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -413,7 +413,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
 			     (1 << KVM_FEATURE_ASYNC_PF) |
 			     (1 << KVM_FEATURE_PV_EOI) |
-			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
+			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
+			     (1 << KVM_FEATURE_PV_UNHALT);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d21bce5..1e73dab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5495,6 +5495,36 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/*
+ * kvm_pv_kick_cpu_op:  Kick a vcpu.
+ *
+ * @apicid - apicid of vcpu to be kicked.
+ */
+static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
+{
+	struct kvm_vcpu *vcpu = NULL;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_apic_present(vcpu))
+			continue;
+
+		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
+			break;
+	}
+	if (vcpu) {
+		/*
+		 * Setting unhalt flag here can result in spurious runnable
+		 * state when unhalt reset does not happen in vcpu_block.
+		 * But that is harmless since that should soon result in halt.
+		 */
+		vcpu->arch.pv.pv_unhalted = true;
+		/* We need everybody see unhalt before vcpu unblocks */
+		smp_wmb();
+		kvm_vcpu_kick(vcpu);
+	}
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -5528,6 +5558,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
 		break;
+	case KVM_HC_KICK_CPU:
+		kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
+		ret = 0;
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
@@ -5950,6 +5984,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 				kvm_apic_accept_events(vcpu);
 				switch(vcpu->arch.mp_state) {
 				case KVM_MP_STATE_HALTED:
+					vcpu->arch.pv.pv_unhalted = false;
 					vcpu->arch.mp_state =
 						KVM_MP_STATE_RUNNABLE;
 				case KVM_MP_STATE_RUNNABLE:
@@ -6249,7 +6284,12 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
 	kvm_apic_accept_events(vcpu);
-	mp_state->mp_state = vcpu->arch.mp_state;
+	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
+					vcpu->arch.pv.pv_unhalted)
+		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+	else
+		mp_state->mp_state = vcpu->arch.mp_state;
+
 	return 0;
 }
 
@@ -6770,6 +6810,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	BUG_ON(vcpu->kvm == NULL);
 	kvm = vcpu->kvm;
 
+	vcpu->arch.pv.pv_unhalted = false;
 	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
 	if (!irqchip_in_kernel(kvm) || kvm_vcpu_is_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
@@ -7103,6 +7144,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 		!vcpu->arch.apf.halted)
 		|| !list_empty_careful(&vcpu->async_pf.done)
 		|| kvm_apic_has_events(vcpu)
+		|| vcpu->arch.pv.pv_unhalted
 		|| atomic_read(&vcpu->arch.nmi_queued) ||
 		(kvm_arch_interrupt_allowed(vcpu) &&
 		 kvm_cpu_has_interrupt(vcpu));
-- 
1.7.11.7

