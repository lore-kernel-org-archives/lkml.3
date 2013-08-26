Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3HZInT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:43:19 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55533 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab3HZInL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:43:11 -0400
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
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH V13 3/4] kvm hypervisor: Simplify kvm_for_each_vcpu with kvm_irq_delivery_to_apic
Date: Mon, 26 Aug 2013 14:18:35 +0530
Message-Id: <1377506916-26946-4-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377506916-26946-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <y>
 <1377506916-26946-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082608-5806-0000-0000-0000228A5662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that we are using APIC_DM_REMRD which has reserved usage.
In future if APIC_DM_REMRD usage is standardized, then we should
find some other way or go back to old method.

Suggested-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kvm/lapic.c |  5 ++++-
 arch/x86/kvm/x86.c   | 25 ++++++-------------------
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
-- 
1.7.11.7

