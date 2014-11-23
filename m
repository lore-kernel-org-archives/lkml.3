Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaKWSPC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:15:02 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42566 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaKWSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:14:29 -0500
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
Subject: [RFC 3/4] KVM: arm: vgic: cleanup forwarded IRQs on destroy
Date: Sun, 23 Nov 2014 19:12:52 +0100
Message-Id: <1416766373-13569-4-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
References: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the VGIC is destroyed it must take care of
- restoring the forwarded IRQs in non forwarded state,
- deactivating the IRQ in case the guest left without doing it
- cleaning nodes of the phys_map rbtree

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index f592219..21419ac 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -32,6 +32,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
+#include <linux/spinlock.h>
 
 /*
  * How the whole thing works (courtesy of Christoffer Dall):
@@ -102,6 +103,8 @@ static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
 static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+static void vgic_clean_irq_phys_map(struct kvm_vcpu *vcpu,
+				    struct rb_root *root);
 
 static const struct vgic_ops *vgic_ops;
 static const struct vgic_params *vgic;
@@ -1813,6 +1816,36 @@ static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
 	return NULL;
 }
 
+static void vgic_clean_irq_phys_map(struct kvm_vcpu *vcpu,
+				    struct rb_root *root)
+{
+	unsigned long flags;
+
+	while (1) {
+		struct rb_node *node = rb_first(root);
+		struct irq_phys_map *map;
+		struct irq_desc *desc;
+		struct irq_data *d;
+		struct irq_chip *chip;
+
+		if (!node)
+			break;
+
+		map = container_of(node, struct irq_phys_map, node);
+		desc = irq_to_desc(map->phys_irq);
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		d = &desc->irq_data;
+		chip = desc->irq_data.chip;
+		irqd_clr_irq_forwarded(d);
+		chip->irq_eoi(d);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+		rb_erase(node, root);
+		kfree(map);
+	}
+}
+
 int vgic_get_phys_irq(struct kvm_vcpu *vcpu, int virt_irq)
 {
 	struct irq_phys_map *map;
@@ -1855,6 +1888,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
+	vgic_clean_irq_phys_map(vcpu, &vgic_cpu->irq_phys_map);
 	kfree(vgic_cpu->pending_shared);
 	kfree(vgic_cpu->vgic_irq_lr_map);
 	vgic_cpu->pending_shared = NULL;
@@ -1920,6 +1954,8 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_destroy(vcpu);
 
+	vgic_clean_irq_phys_map(vcpu, &dist->irq_phys_map);
+
 	vgic_free_bitmap(&dist->irq_enabled);
 	vgic_free_bitmap(&dist->irq_level);
 	vgic_free_bitmap(&dist->irq_pending);
-- 
1.9.1

