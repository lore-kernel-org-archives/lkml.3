Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaLBR3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:29:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36412 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaLBR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:29:09 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, gleb@kernel.org,
        pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: [PATCH] KVM: arm/arm64: vgic: add init entry to VGIC KVM device
Date: Tue,  2 Dec 2014 18:27:31 +0100
Message-Id: <1417541251-20761-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the advent of dynamic initialization of VGIC, this latter is
initialized very late, on the first vcpu run. This initialization
could be initiated much earlier by the user, as soon as it has
provided the requested dimensioning parameters:
- number of IRQs and number of vCPUs,
- DIST and CPU interface base address.

One motivation behind being able to initialize the VGIC sooner is
related to the setup of IRQ injection in VFIO use case. The VFIO
signaling, especially when used along with irqfd must be set *after*
vgic initialization to prevent any virtual IRQ injection before
VGIC initialization. If virtual IRQ injection occurs before the VGIC
init, the IRQ cannot be injected and subsequent injection is blocked
due to VFIO completion mechanism (unmask/mask or forward/unforward).

This patch adds a new entry to the VGIC KVM device that allows
the user to manually request the VGIC init:
- a new KVM_DEV_ARM_VGIC_GRP_CTRL group is introduced.
- Its first attribute is KVM_DEV_ARM_VGIC_CTRL_INIT

The rationale behind introducing a group is to be able to add other
controls later on, if needed.

Obviously, as soon as the init is done, the dimensioning parameters
cannot be changed.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 11 +++++++++++
 arch/arm/include/uapi/asm/kvm.h                |  2 ++
 arch/arm64/include/uapi/asm/kvm.h              |  2 ++
 virt/kvm/arm/vgic.c                            | 14 +++++++++++++-
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index df8b0c7..80db43f 100644
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
+    -ENXIO: distributor or CPU interface base address were not set prior
+            to that call
+    -EINVAL: number of vcpus is not known
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
index b76c38c..2fe5bdb 100644
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

