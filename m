Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaKWSOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:14:30 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:44102 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaKWSOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:14:25 -0500
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
Subject: [RFC 2/4] KVM: arm: vgic: add forwarded irq rbtree lock
Date: Sun, 23 Nov 2014 19:12:51 +0100
Message-Id: <1416766373-13569-3-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
References: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a lock related to the rb tree manipulation. The rb tree can be
searched in one thread (irqfd handler for instance) and map/unmap
may happen in another.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
re-arrange lock sequence in vgic_map_phys_irq
---
 include/kvm/arm_vgic.h |  1 +
 virt/kvm/arm/vgic.c    | 56 ++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ea31ac6..9b3290b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -220,6 +220,7 @@ struct vgic_dist {
 	unsigned long		*irq_pending_on_cpu;
 
 	struct rb_root		irq_phys_map;
+	spinlock_t			rb_tree_lock;
 #endif
 };
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 5484e3d..f592219 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1750,9 +1750,22 @@ static struct rb_root *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
 
 int vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
 {
-	struct rb_root *root = vgic_get_irq_phys_map(vcpu, virt_irq);
-	struct rb_node **new = &root->rb_node, *parent = NULL;
+	struct rb_root *root;
+	struct rb_node **new, *parent = NULL;
 	struct irq_phys_map *new_map;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
+	root = vgic_get_irq_phys_map(vcpu, virt_irq);
+	new = &root->rb_node;
+
+	new_map = kzalloc(sizeof(*new_map), GFP_KERNEL);
+	if (!new_map)
+		return -ENOMEM;
+
+	new_map->virt_irq = virt_irq;
+	new_map->phys_irq = phys_irq;
+
+	spin_lock(&dist->rb_tree_lock);
 
 	/* Boilerplate rb_tree code */
 	while (*new) {
@@ -1764,19 +1777,16 @@ int vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
 			new = &(*new)->rb_left;
 		else if (this->virt_irq > virt_irq)
 			new = &(*new)->rb_right;
-		else
+		else {
+			kfree(new_map);
+			spin_unlock(&dist->rb_tree_lock);
 			return -EEXIST;
+		}
 	}
 
-	new_map = kzalloc(sizeof(*new_map), GFP_KERNEL);
-	if (!new_map)
-		return -ENOMEM;
-
-	new_map->virt_irq = virt_irq;
-	new_map->phys_irq = phys_irq;
-
 	rb_link_node(&new_map->node, parent, new);
 	rb_insert_color(&new_map->node, root);
+	spin_unlock(&dist->rb_tree_lock);
 
 	return 0;
 }
@@ -1805,24 +1815,39 @@ static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
 
 int vgic_get_phys_irq(struct kvm_vcpu *vcpu, int virt_irq)
 {
-	struct irq_phys_map *map = vgic_irq_map_search(vcpu, virt_irq);
+	struct irq_phys_map *map;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	int ret;
+
+	spin_lock(&dist->rb_tree_lock);
+	map = vgic_irq_map_search(vcpu, virt_irq);
 
 	if (map)
-		return map->phys_irq;
+		ret = map->phys_irq;
+	else
+		ret =  -ENOENT;
+
+	spin_unlock(&dist->rb_tree_lock);
+	return ret;
 
-	return -ENOENT;
 }
 
 int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
 {
-	struct irq_phys_map *map = vgic_irq_map_search(vcpu, virt_irq);
+	struct irq_phys_map *map;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
+	spin_lock(&dist->rb_tree_lock);
+
+	map = vgic_irq_map_search(vcpu, virt_irq);
 
 	if (map && map->phys_irq == phys_irq) {
 		rb_erase(&map->node, vgic_get_irq_phys_map(vcpu, virt_irq));
 		kfree(map);
+		spin_unlock(&dist->rb_tree_lock);
 		return 0;
 	}
-
+	spin_unlock(&dist->rb_tree_lock);
 	return -ENOENT;
 }
 
@@ -2078,6 +2103,7 @@ int kvm_vgic_create(struct kvm *kvm)
 	}
 
 	spin_lock_init(&kvm->arch.vgic.lock);
+	spin_lock_init(&kvm->arch.vgic.rb_tree_lock);
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vctrl_base = vgic->vctrl_base;
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
-- 
1.9.1

