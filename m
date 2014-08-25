Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaHYNao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:30:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58215 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaHYN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:28:46 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: [RFC 4/9] KVM: KVM-VFIO: update user API to program forwarded IRQ
Date: Mon, 25 Aug 2014 15:27:39 +0200
Message-Id: <1408973264-30384-5-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>
References: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add new device group commands:
- KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ and
  KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ

which enable to turn forwarded IRQ mode on/off.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 Documentation/virtual/kvm/devices/vfio.txt | 25 +++++++++++++++++++++++++
 arch/arm/include/uapi/asm/kvm.h            |  6 ++++++
 include/uapi/linux/kvm.h                   |  3 +++
 3 files changed, 34 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
index ef51740..c8b3fa1 100644
--- a/Documentation/virtual/kvm/devices/vfio.txt
+++ b/Documentation/virtual/kvm/devices/vfio.txt
@@ -13,6 +13,7 @@ VFIO-group is held by KVM.
 
 Groups:
   KVM_DEV_VFIO_GROUP
+  KVM_DEV_VFIO_DEVICE
 
 KVM_DEV_VFIO_GROUP attributes:
   KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
@@ -20,3 +21,27 @@ KVM_DEV_VFIO_GROUP attributes:
 
 For each, kvm_device_attr.addr points to an int32_t file descriptor
 for the VFIO group.
+
+KVM_DEV_VFIO_DEVICE attributes:
+  KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ
+  KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ
+
+For each, kvm_device_attr.addr points to an kvm_arch_forwarded_irq.
+This user API makes possible to create a special IRQ handling mode,
+currently supported only on ARM, where KVM and a VFIO platform driver
+collaborate to improve IRQ handling performance.
+fd represents the file descriptor of a valid VFIO device whose physical
+IRQ, referenced by its irq_index is injected to the VM guest_irq.
+
+On ASSIGN_IRQ, KVM-VFIO device programs:
+- the host, to not complete the physical IRQ itself.
+- the GIC, to automatically complete the physical IRQ when the guest
+  completes the virtual IRQ
+This avoid trapping the end-of-interrupt for level sensitive IRQ.
+
+On DEASSIGN_IRQ, one come back to the mode where the host completes the
+physical IRQ and the guest only completes the virtual IRQ.
+
+It is up to the caller of this API to get the assurance the IRQ is not
+outstanding when the ASSIGN/DEASSIGN is called. This could lead to some
+inconsistency on who is going to complete the IRQ.
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 3034c66..1920b33 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -109,6 +109,12 @@ struct kvm_sync_regs {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_arch_forwarded_irq {
+	__u32 fd; /* file desciptor of the VFIO device */
+	__u32 irq_index; /* platform device index of the IRQ */
+	__u32 guest_irq; /* virtual IRQ number */
+};
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index cf3a2ff..b149ba8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -954,6 +954,9 @@ struct kvm_device_attr {
 #define  KVM_DEV_VFIO_GROUP			1
 #define   KVM_DEV_VFIO_GROUP_ADD			1
 #define   KVM_DEV_VFIO_GROUP_DEL			2
+#define  KVM_DEV_VFIO_DEVICE			2
+#define   KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ			1
+#define   KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ			2
 #define KVM_DEV_TYPE_ARM_VGIC_V2	5
 #define KVM_DEV_TYPE_FLIC		6
 
-- 
1.9.1

