Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaIAMxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:53:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52735 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaIAMxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:53:32 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: [RFC v2 1/9] KVM: ARM: VGIC: fix multiple injection of level sensitive forwarded IRQ
Date: Mon,  1 Sep 2014 14:52:40 +0200
Message-Id: <1409575968-5329-2-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix multiple injection of level sensitive forwarded IRQs.
With current code, the second injection fails since the state bitmaps
are not reset (process_maintenance is not called anymore).
New implementation consists in fully bypassing the vgic state
management for forwarded IRQ (checks are ignored in
vgic_update_irq_pending). This obviously assumes the forwarded IRQ is
injected from kernel side.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

It was attempted to reset the states in __kvm_vgic_sync_hwstate, checking
the emptied LR of forwarded IRQ. However surprisingly this solution does
not seem to work. Some times, a new forwarded IRQ injection is observed
while the LR of the previous instance was not observed as empty.

v1 -> v2:
- fix vgic state bypass in vgic_queue_hwirq
---
 virt/kvm/arm/vgic.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 0007300..8ef495b 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1259,7 +1259,9 @@ static bool vgic_queue_sgi(struct kvm_vcpu *vcpu, int irq)
 
 static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
 {
-	if (vgic_irq_is_queued(vcpu, irq))
+	bool is_forwarded =  (vgic_get_phys_irq(vcpu, irq) > 0);
+
+	if (vgic_irq_is_queued(vcpu, irq) && !is_forwarded)
 		return true; /* level interrupt, already queued */
 
 	if (vgic_queue_irq(vcpu, 0, irq)) {
@@ -1517,14 +1519,18 @@ static bool vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	int edge_triggered, level_triggered;
 	int enabled;
 	bool ret = true;
+	bool is_forwarded;
 
 	spin_lock(&dist->lock);
 
 	vcpu = kvm_get_vcpu(kvm, cpuid);
+	is_forwarded = (vgic_get_phys_irq(vcpu, irq_num) > 0);
+
 	edge_triggered = vgic_irq_is_edge(vcpu, irq_num);
 	level_triggered = !edge_triggered;
 
-	if (!vgic_validate_injection(vcpu, irq_num, level)) {
+	if (!is_forwarded &&
+		!vgic_validate_injection(vcpu, irq_num, level)) {
 		ret = false;
 		goto out;
 	}
@@ -1557,7 +1563,8 @@ static bool vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 		goto out;
 	}
 
-	if (level_triggered && vgic_irq_is_queued(vcpu, irq_num)) {
+	if (!is_forwarded &&
+		level_triggered && vgic_irq_is_queued(vcpu, irq_num)) {
 		/*
 		 * Level interrupt in progress, will be picked up
 		 * when EOId.
-- 
1.9.1

