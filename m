Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaKWSOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:14:35 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49016 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaKWSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:14:32 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: [RFC 4/4] KVM: arm: vgic: handle irqfd forwarded IRQ injection before vgic readiness
Date: Sun, 23 Nov 2014 19:12:53 +0100
Message-Id: <1416766373-13569-5-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
References: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch handles the case where irqfd attempts to inject
a forwarded IRQ before the vgic is ready to accept it. We
cannot simply return pretending nothing happened since the IRQ
will never be deactivated by the guest. Indeed, the corresponding
virtual IRQ cannot be injected into the guest and the host
must deactivate it.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 21419ac..27394b0 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2672,6 +2672,13 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id,
 		u32 irq, int level, bool line_status)
 {
 	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, 0);
+	int phys_irq =  vgic_get_phys_irq(vcpu, spi);
+	bool is_forwarded = (phys_irq >= 0);
+	unsigned long flags;
+	struct irq_desc *desc;
+	struct irq_data *d;
+	struct irq_chip *chip;
 
 	kvm_debug("irqfd sets vIRQ %d to %d\n", irq, level);
 
@@ -2679,6 +2686,19 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id,
 		if (spi > kvm->arch.vgic.nr_irqs)
 			return -EINVAL;
 		return kvm_vgic_inject_irq(kvm, 0, spi, level);
+	}
+
+	if (level && is_forwarded) {
+		/*
+		 * the virtual IRQ never is injected into the guest
+		 * it must be manually completed on host side.
+		 */
+		desc = irq_to_desc(phys_irq);
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		d = &desc->irq_data;
+		chip = desc->irq_data.chip;
+		chip->irq_eoi(d);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (level && kvm_irq_has_notifier(kvm, 0, irq)) {
 		/*
 		 * any IRQ injected before vgic readiness is
-- 
1.9.1

