Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3GVGNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 02:13:14 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:38737 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab3GVGNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 02:13:11 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <xen-devel@lists.xensource.com>, <peterz@infradead.org>,
        <mtosatti@redhat.com>, <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <attilio.rao@citrix.com>, <ouyang@cs.pitt.edu>,
        <gregkh@suse.de>, <agraf@suse.de>, <chegu_vinod@hp.com>,
        <torvalds@linux-foundation.org>, <avi.kivity@gmail.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <riel@redhat.com>,
        <drjones@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Mon, 22 Jul 2013 11:50:27 +0530
Message-Id: <20130722062027.24737.15135.sendpatchset@codeblue>
In-Reply-To: <20130722061631.24737.75508.sendpatchset@codeblue>
References: <20130722061631.24737.75508.sendpatchset@codeblue>
Subject: [PATCH RFC V11 16/18] kvm hypervisor : Simplify kvm_for_each_vcpu with kvm_irq_delivery_to_apic
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072206-8256-0000-0000-000008712152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm hypervisor: Simplify kvm_for_each_vcpu with kvm_irq_delivery_to_apic

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Note that we are using APIC_DM_REMRD which has reserved usage.
In future if APIC_DM_REMRD usage is standardized, then we should
find some other way or go back to old method.

Suggested-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/kvm/lapic.c |    5 ++++-
 arch/x86/kvm/x86.c   |   25 ++++++-------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index afc1124..48c13c9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -706,7 +706,10 @@ out:
 		break;
 
 	case APIC_DM_REMRD:
-		apic_debug("Ignoring delivery mode 3\n");
+		result = 1;
+		vcpu->arch.pv.pv_unhalted = 1;
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_vcpu_kick(vcpu);
 		break;
 
 	case APIC_DM_SMI:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1e73dab..640d112 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5502,27 +5502,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
  */
 static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
 {
-	struct kvm_vcpu *vcpu = NULL;
-	int i;
+	struct kvm_lapic_irq lapic_irq;
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!kvm_apic_present(vcpu))
-			continue;
+	lapic_irq.shorthand = 0;
+	lapic_irq.dest_mode = 0;
+	lapic_irq.dest_id = apicid;
 
-		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
-			break;
-	}
-	if (vcpu) {
-		/*
-		 * Setting unhalt flag here can result in spurious runnable
-		 * state when unhalt reset does not happen in vcpu_block.
-		 * But that is harmless since that should soon result in halt.
-		 */
-		vcpu->arch.pv.pv_unhalted = true;
-		/* We need everybody see unhalt before vcpu unblocks */
-		smp_wmb();
-		kvm_vcpu_kick(vcpu);
-	}
+	lapic_irq.delivery_mode = APIC_DM_REMRD;
+	kvm_irq_delivery_to_apic(kvm, 0, &lapic_irq, NULL);
 }
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)

