Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaKWSO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:14:29 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34008 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaKWSOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:14:23 -0500
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
Subject: [RFC 1/4] KVM: arm: vgic: fix state machine for forwarded IRQ
Date: Sun, 23 Nov 2014 19:12:50 +0100
Message-Id: <1416766373-13569-2-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
References: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix multiple injection of level sensitive forwarded IRQs.
With current code, the second injection fails since the state bitmaps
are not reset (process_maintenance is not called anymore).

New implementation follows those principles:
- A forwarded IRQ only can be sampled when it is pending
- when queueing the IRQ (programming the LR), the pending state is removed
  as for edge sensitive IRQs
- an injection of a forwarded IRQ is considered always valid since
  coming from the HW and level always is 1.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- integration in new vgic_can_sample_irq
- remove the pending state when programming the LR

v1 -> v2:
- fix vgic state bypass in vgic_queue_hwirq

Conflicts:
	virt/kvm/arm/vgic.c
---
 virt/kvm/arm/vgic.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index ccb3801..5484e3d 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -360,7 +360,10 @@ static void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq)
 
 static bool vgic_can_sample_irq(struct kvm_vcpu *vcpu, int irq)
 {
-	return vgic_irq_is_edge(vcpu, irq) || !vgic_irq_is_queued(vcpu, irq);
+	bool is_forwarded =  (vgic_get_phys_irq(vcpu, irq) >= 0);
+
+	return vgic_irq_is_edge(vcpu, irq) || !vgic_irq_is_queued(vcpu, irq) ||
+		(is_forwarded && vgic_dist_irq_is_pending(vcpu, irq));
 }
 
 static u32 mmio_data_read(struct kvm_exit_mmio *mmio, u32 mask)
@@ -1295,6 +1298,7 @@ static bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	struct vgic_lr vlr;
 	int lr;
+	bool is_forwarded =  (vgic_get_phys_irq(vcpu, irq) >= 0);
 
 	/* Sanitize the input... */
 	BUG_ON(sgi_source_id & ~7);
@@ -1330,7 +1334,7 @@ static bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_source_id, int irq)
 	vlr.irq = irq;
 	vlr.source = sgi_source_id;
 	vlr.state = LR_STATE_PENDING;
-	if (!vgic_irq_is_edge(vcpu, irq))
+	if (!vgic_irq_is_edge(vcpu, irq) && !is_forwarded)
 		vlr.state |= LR_EOI_INT;
 
 	vgic_set_lr(vcpu, lr, vlr);
@@ -1371,11 +1375,12 @@ static bool vgic_queue_sgi(struct kvm_vcpu *vcpu, int irq)
 
 static bool vgic_queue_hwirq(struct kvm_vcpu *vcpu, int irq)
 {
+	bool is_forwarded = (vgic_get_phys_irq(vcpu, irq) >= 0);
 	if (!vgic_can_sample_irq(vcpu, irq))
 		return true; /* level interrupt, already queued */
 
 	if (vgic_queue_irq(vcpu, 0, irq)) {
-		if (vgic_irq_is_edge(vcpu, irq)) {
+		if (vgic_irq_is_edge(vcpu, irq) || is_forwarded) {
 			vgic_dist_irq_clear_pending(vcpu, irq);
 			vgic_cpu_irq_clear(vcpu, irq);
 		} else {
@@ -1636,14 +1641,17 @@ static bool vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 	int edge_triggered, level_triggered;
 	int enabled;
 	bool ret = true;
+	bool is_forwarded;
 
 	spin_lock(&dist->lock);
 
 	vcpu = kvm_get_vcpu(kvm, cpuid);
+	is_forwarded = (vgic_get_phys_irq(vcpu, irq_num) >= 0);
+
 	edge_triggered = vgic_irq_is_edge(vcpu, irq_num);
 	level_triggered = !edge_triggered;
 
-	if (!vgic_validate_injection(vcpu, irq_num, level)) {
+	if (!vgic_validate_injection(vcpu, irq_num, level) && !is_forwarded) {
 		ret = false;
 		goto out;
 	}
-- 
1.9.1

