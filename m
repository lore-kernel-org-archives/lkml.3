Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbbAIOiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:38:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbbAIOiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:38:20 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Feng Wu <feng.wu@intel.com>
Subject: [PATCH] KVM: x86: amend APIC lowest priority arbitration
Date: Fri,  9 Jan 2015 15:37:26 +0100
Message-Id: <1420814246-19033-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lowest priority should take the task priority into account.

SDM 10.6.2.4 Lowest Priority Delivery Mode.
(Too long to quote; second and last paragraphs are relevant.)

Before this patch, we strived to have the same amount of handled
lowest-priority interrupts on all VCPUs.
This is only a complication, but kept for compatibility.

Real modern Intels can't send lowest priority IPIs and the chipset
directs external ones using processors' TPR.
AMD still has rough edges.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a688fbffb34e..5b9d8c589bba 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -833,7 +833,15 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2)
 {
-	return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
+	/* XXX: AMD (2:16.6.2 Lowest Priority Messages and Arbitration)
+	 *      - uses the APR register (which also considers ISR and IRR),
+	 *      - chooses the highest APIC ID when APRs are identical,
+	 *      - and allows a focus processor.
+	 * XXX: pseudo-balancing with apic_arb_prio is a KVM-specific feature
+	 */
+	int tpr = kvm_apic_get_reg(vcpu1->arch.apic, APIC_TASKPRI) -
+	          kvm_apic_get_reg(vcpu2->arch.apic, APIC_TASKPRI);
+	return tpr ? : vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
 }
 
 static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
-- 
2.2.0

