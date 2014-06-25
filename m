Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaFYJ3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:29:25 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51407 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755523AbaFYJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:29:04 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, eric.auger@linaro.org,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 9/9] KVM: arm: timer: make the interrupt state part of the timer state
Date: Wed, 25 Jun 2014 10:28:50 +0100
Message-Id: <1403688530-23273-10-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to remove the crude hack where we sneak the masked bit
into the timer's control register, make use of the forwarded
interrupt API to save/restore the active state of the interrupt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h |  3 +++
 virt/kvm/arm/arch_timer.c    | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 6d9aedd..6a69f42 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -53,6 +53,9 @@ struct arch_timer_cpu {
 	/* Background timer active */
 	bool				armed;
 
+	/* Is interrupt active at the distributor level */
+	u32				irq_active;
+
 	/* Timer IRQ */
 	const struct kvm_irq_level	*irq;
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 22fa819..57817c5 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -63,7 +63,7 @@ static void kvm_timer_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	timer->cntv_ctl |= ARCH_TIMER_CTRL_IT_MASK;
+	timer->irq_active = IRQ_FWD_STATE_ACTIVE;
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
 			    timer->irq->irq,
 			    timer->irq->level);
@@ -117,6 +117,16 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * populate the CPU timer again.
 	 */
 	timer_disarm(timer);
+
+	if (timer->irq_active) {
+		int ret;
+
+		ret = irq_set_fwd_state(host_vtimer_irq,
+					timer->irq_active,
+					IRQ_FWD_STATE_ACTIVE);
+		if (ret)
+			kvm_err("unable to restore timer state");
+	}
 }
 
 /**
@@ -130,8 +140,16 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	cycle_t cval, now;
+	int ret;
 	u64 ns;
 
+	ret = irq_get_fwd_state(host_vtimer_irq, &timer->irq_active,
+				IRQ_FWD_STATE_ACTIVE);
+	if (ret)
+		kvm_err("unable to retrieve timer state");
+	if (timer->irq_active)
+		irq_set_fwd_state(host_vtimer_irq, 0, IRQ_FWD_STATE_ACTIVE);
+
 	if ((timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) ||
 		!(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE))
 		return;
@@ -166,6 +184,12 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * vcpu timer irq number when the vcpu is reset.
 	 */
 	timer->irq = irq;
+
+	/*
+	 * Tell the VGIC that the virtual interrupt is tied to a
+	 * physical interrupt. We do that once per VCPU.
+	 */
+	vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
 }
 
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
@@ -290,6 +314,10 @@ int kvm_timer_hyp_init(void)
 	}
 
 	kvm_info("%s IRQ%d\n", np->name, ppi);
+
+	/* Tell the GIC we're forwarding the interrupt to a guest */
+	irqd_set_irq_forwarded(irq_get_irq_data(host_vtimer_irq));
+
 	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
 
 	goto out;
@@ -305,6 +333,7 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
 	timer_disarm(timer);
+	vgic_unmap_phys_irq(vcpu, timer->irq->irq, host_vtimer_irq);
 }
 
 int kvm_timer_init(struct kvm *kvm)
-- 
1.8.3.4

