Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaLDJt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:49:56 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49558 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaLDJtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:49:52 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com
Subject: [PATCH v2 2/4] KVM: arm/arm64: vgic: add init entry to VGIC KVM device
Date: Thu,  4 Dec 2014 10:48:02 +0100
Message-Id: <1417686484-20828-3-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
References: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the advent of dynamic initialization of VGIC, this latter is
initialized very late, on the first vcpu run. This initialization
could be initiated much earlier by the user, as soon as it has
provided the requested dimensioning parameters:
- number of IRQs and number of vCPUs,
- DIST and CPU interface base address.

This patch adds a new entry to the VGIC KVM device that allows
the user to manually request the VGIC init:
- a new KVM_DEV_ARM_VGIC_GRP_CTRL group is introduced.
- Its first attribute is KVM_DEV_ARM_VGIC_CTRL_INIT

The rationale behind introducing a group is to be able to add other
controls later on, if needed.

Obviously, as soon as the init is done, the dimensioning parameters
cannot be changed.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

v1 -> v2:
- some rewording in arm-vgic.txt and in the commit message
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 11 +++++++++++
 arch/arm/include/uapi/asm/kvm.h                |  2 ++
 arch/arm64/include/uapi/asm/kvm.h              |  2 ++
 virt/kvm/arm/vgic.c                            | 14 +++++++++++++-
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index df8b0c7..30f5427 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -81,3 +81,14 @@ Groups:
     -EINVAL: Value set is out of the expected range
     -EBUSY: Value has already be set, or GIC has already been initialized
             with default values.
+
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+  Attributes:
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the VGIC, no additional parameter in
+      kvm_device_attr.addr.
+  Errors:
+    -ENXIO: VGIC not properly configured as required prior to calling
+     this attribute
+    -ENODEV: no online VCPU
+    -ENOMEM: memory shortage when allocating vgic internal data
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 77547bb..2499867 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -175,6 +175,8 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
+#define KVM_DEV_ARM_VGIC_GRP_CTRL       4
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1ed4417..b35c95a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -161,6 +161,8 @@ struct kvm_arch_memory_slot {
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
+#define KVM_DEV_ARM_VGIC_GRP_CTRL	4
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 907ba0e..89dca86 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2474,7 +2474,14 @@ static int vgic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 
 		return ret;
 	}
-
+	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			r = kvm_vgic_init(dev->kvm);
+			return r;
+		}
+		break;
+	}
 	}
 
 	return -ENXIO;
@@ -2553,6 +2560,11 @@ static int vgic_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		return vgic_has_attr_regs(vgic_cpu_ranges, offset);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		}
 	}
 	return -ENXIO;
 }
-- 
1.9.1

