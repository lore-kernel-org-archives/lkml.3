Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaIAMxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:53:49 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:63646 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaIAMxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:53:45 -0400
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
Subject: [RFC v2 5/9] KVM: KVM-VFIO: update user API to program forwarded IRQ
Date: Mon,  1 Sep 2014 14:52:44 +0200
Message-Id: <1409575968-5329-6-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add new device group commands:
- KVM_DEV_VFIO_DEVICE_FORWARD_IRQ and
  KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ

which enable to turn forwarded IRQ mode on/off.

the kvm_arch_forwarded_irq struct embodies a forwarded IRQ

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- struct kvm_arch_forwarded_irq moved from arch/arm/include/uapi/asm/kvm.h
  to include/uapi/linux/kvm.h
  also irq_index renamed into index and guest_irq renamed into gsi
- ASSIGN/DEASSIGN renamed into FORWARD/UNFORWARD
---
 Documentation/virtual/kvm/devices/vfio.txt | 26 ++++++++++++++++++++++++++
 include/uapi/linux/kvm.h                   |  9 +++++++++
 2 files changed, 35 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
index ef51740..048baa0 100644
--- a/Documentation/virtual/kvm/devices/vfio.txt
+++ b/Documentation/virtual/kvm/devices/vfio.txt
@@ -13,6 +13,7 @@ VFIO-group is held by KVM.
 
 Groups:
   KVM_DEV_VFIO_GROUP
+  KVM_DEV_VFIO_DEVICE
 
 KVM_DEV_VFIO_GROUP attributes:
   KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
@@ -20,3 +21,28 @@ KVM_DEV_VFIO_GROUP attributes:
 
 For each, kvm_device_attr.addr points to an int32_t file descriptor
 for the VFIO group.
+
+KVM_DEV_VFIO_DEVICE attributes:
+  KVM_DEV_VFIO_DEVICE_FORWARD_IRQ
+  KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ
+
+For each, kvm_device_attr.addr points to a kvm_arch_forwarded_irq struct.
+This user API makes possible to create a special IRQ handling mode,
+where KVM and a VFIO platform driver collaborate to improve IRQ
+handling performance.
+
+fd represents the file descriptor of a valid VFIO device whose physical
+IRQ, referenced by its index, is injected into the VM guest irq (gsi).
+
+On FORWARD_IRQ, KVM-VFIO device programs:
+- the host, to not complete the physical IRQ itself.
+- the GIC, to automatically complete the physical IRQ when the guest
+  completes the virtual IRQ.
+This avoids trapping the end-of-interrupt for level sensitive IRQ.
+
+On UNFORWARD_IRQ, one returns to the mode where the host completes the
+physical IRQ and the guest completes the virtual IRQ.
+
+It is up to the caller of this API to make sure the IRQ is not
+outstanding when the FORWARD/UNFORWARD is called. This could lead to
+some inconsistency on who is going to complete the IRQ.
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index cf3a2ff..8cd7b0e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -947,6 +947,12 @@ struct kvm_device_attr {
 	__u64	addr;		/* userspace address of attr data */
 };
 
+struct kvm_arch_forwarded_irq {
+	__u32 fd; /* file desciptor of the VFIO device */
+	__u32 index; /* VFIO device IRQ index */
+	__u32 gsi; /* gsi, ie. virtual IRQ number */
+};
+
 #define KVM_DEV_TYPE_FSL_MPIC_20	1
 #define KVM_DEV_TYPE_FSL_MPIC_42	2
 #define KVM_DEV_TYPE_XICS		3
@@ -954,6 +960,9 @@ struct kvm_device_attr {
 #define  KVM_DEV_VFIO_GROUP			1
 #define   KVM_DEV_VFIO_GROUP_ADD			1
 #define   KVM_DEV_VFIO_GROUP_DEL			2
+#define  KVM_DEV_VFIO_DEVICE			2
+#define   KVM_DEV_VFIO_DEVICE_FORWARD_IRQ			1
+#define   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ			2
 #define KVM_DEV_TYPE_ARM_VGIC_V2	5
 #define KVM_DEV_TYPE_FLIC		6
 
-- 
1.9.1

