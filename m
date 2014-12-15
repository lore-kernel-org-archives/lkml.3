Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950AbaLORpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:45:34 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46626 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaLORp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:45:27 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH v3 2/2] KVM: arm/arm64: vgic: add init entry to VGIC KVM device
Date: Mon, 15 Dec 2014 18:43:33 +0100
Message-Id: <1418665413-31521-3-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418665413-31521-1-git-send-email-eric.auger@linaro.org>
References: <1418665413-31521-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the advent of VGIC dynamic initialization, this latter is
initialized quite late on the first vcpu run or "on-demand", when
injecting an IRQ or when the guest sets its registers.

This initialization could be initiated explicitly much earlier
by the users-space, as soon as it has provided the requested
dimensioning parameters.

This patch adds a new entry to the VGIC KVM device that allows
the user to manually request the VGIC init:
- a new KVM_DEV_ARM_VGIC_GRP_CTRL group is introduced.
- Its first attribute is KVM_DEV_ARM_VGIC_CTRL_INIT

The rationale behind introducing a group is to be able to add other
controls later on, if needed.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- kvm_vgic_init replaced vgic_init. This means the target state now
  is initialized and no more "ready"

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
index 09ee408..0db25bc 100644
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
index 8e38878..480af34 100644
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
index d61a61f..f7acda0 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2302,7 +2302,14 @@ static int vgic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 
 		return ret;
 	}
-
+	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			r = vgic_init(dev->kvm);
+			return r;
+		}
+		break;
+	}
 	}
 
 	return -ENXIO;
@@ -2381,6 +2388,11 @@ static int vgic_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
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

