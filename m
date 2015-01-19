Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbbASQpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:45:38 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39665 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbASQpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:45:35 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH v8 4/5] KVM: arm/arm64: remove coarse grain dist locking at kvm_vgic_sync_hwstate
Date: Mon, 19 Jan 2015 17:43:12 +0100
Message-Id: <1421685793-3547-5-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421685793-3547-1-git-send-email-eric.auger@linaro.org>
References: <1421685793-3547-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prepare for irqfd addition, coarse grain locking is removed at
kvm_vgic_sync_hwstate level and finer grain locking is introduced in
vgic_process_maintenance only.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index c84f53df..18060ea 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1447,6 +1447,7 @@ epilog:
 static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 {
 	u32 status = vgic_get_interrupt_status(vcpu);
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	bool level_pending = false;
 
 	kvm_debug("STATUS = %08x\n", status);
@@ -1464,6 +1465,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 			WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
 
+			spin_lock(&dist->lock);
 			vgic_irq_clear_queued(vcpu, vlr.irq);
 			WARN_ON(vlr.state & LR_STATE_MASK);
 			vlr.state = 0;
@@ -1491,6 +1493,8 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 				vgic_cpu_irq_clear(vcpu, vlr.irq);
 			}
 
+			spin_unlock(&dist->lock);
+
 			/*
 			 * Despite being EOIed, the LR may not have
 			 * been marked as empty.
@@ -1505,10 +1509,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 	return level_pending;
 }
 
-/*
- * Sync back the VGIC state after a guest run. The distributor lock is
- * needed so we don't get preempted in the middle of the state processing.
- */
+/* Sync back the VGIC state after a guest run */
 static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
@@ -1555,14 +1556,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
-
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return;
 
-	spin_lock(&dist->lock);
 	__kvm_vgic_sync_hwstate(vcpu);
-	spin_unlock(&dist->lock);
 }
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
-- 
1.9.1

