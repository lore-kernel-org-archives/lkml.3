Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaHDMJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:09:21 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43717 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaHDMJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:09:19 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        paulus@samba.org
Subject: [RFC PATCH] ARM: KVM: add irqfd support
Date: Mon,  4 Aug 2014 14:08:22 +0200
Message-Id: <1407154102-26459-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables irqfd on ARM.

irqfd framework enables to inject a virtual IRQ into a guest upon an
eventfd trigger. User-side uses KVM_IRQFD VM ioctl to provide KVM with
a kvm_irqfd struct that associates a VM, an eventfd, an IRQ number
(aka. the gsi). When an actor signals the eventfd (typically a VFIO
platform driver), the kvm irqfd subsystem injects the provided virtual
IRQ into the guest.

The gsi must correspond to a shared peripheral interrupt (SPI), ie the
GIC interrupt ID is gsi+32.

CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD are turned on.

No IRQ routing table is used thanks to Paul Mackerras' patch serie:
"IRQFD without IRQ routing, enabled for XICS"
(https://www.mail-archive.com/kvm@vger.kernel.org/msg104478.html)

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

This patch would deprecate the previous patch featuring GSI routing
(https://patches.linaro.org/32261/)

irqchip.c and irq_comm.c are not used at all.

This RFC applies on top of Christoffer Dall's serie
arm/arm64: KVM: Various VGIC cleanups and improvements
https://lists.cs.columbia.edu/pipermail/kvmarm/2014-June/009979.html

All pieces can be found on git://git.linaro.org/people/eric.auger/linux.git
branch irqfd_integ_v4

This work was tested with Calxeda Midway xgmac main interrupt with
qemu-system-arm and QEMU VFIO platform device.
---
 Documentation/virtual/kvm/api.txt |  5 +++-
 arch/arm/include/uapi/asm/kvm.h   |  3 +++
 arch/arm/kvm/Kconfig              |  3 ++-
 arch/arm/kvm/Makefile             |  2 +-
 arch/arm/kvm/irq.h                | 25 ++++++++++++++++++
 virt/kvm/arm/vgic.c               | 54 ++++++++++++++++++++++++++++++++++++---
 6 files changed, 85 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/kvm/irq.h

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 0fe3649..04310d9 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2132,7 +2132,7 @@ into the hash PTE second double word).
 4.75 KVM_IRQFD
 
 Capability: KVM_CAP_IRQFD
-Architectures: x86 s390
+Architectures: x86 s390 arm
 Type: vm ioctl
 Parameters: struct kvm_irqfd (in)
 Returns: 0 on success, -1 on error
@@ -2158,6 +2158,9 @@ Note that closing the resamplefd is not sufficient to disable the
 irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
 and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
 
+On ARM/arm64 the injected must be a shared peripheral interrupt (SPI).
+This means the programmed GIC interrupt ID is gsi+32.
+
 4.76 KVM_PPC_ALLOCATE_HTAB
 
 Capability: KVM_CAP_PPC_ALLOC_HTAB
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index e6ebdd3..3034c66 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -194,6 +194,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 4be5bb1..7800261 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select KVM_MMIO
 	select KVM_ARM_HOST
 	depends on ARM_VIRT_EXT && ARM_LPAE && !CPU_BIG_ENDIAN
+	select HAVE_KVM_EVENTFD
 	---help---
 	  Support hosting virtualized guest machines. You will also
 	  need to select one or more of the processor modules below.
@@ -55,7 +56,7 @@ config KVM_ARM_MAX_VCPUS
 config KVM_ARM_VGIC
 	bool "KVM support for Virtual GIC"
 	depends on KVM_ARM_HOST && OF
-	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQFD
 	default y
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 789bca9..2fa2f82 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
 AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
 
 KVM := ../../../virt/kvm
-kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
+kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
diff --git a/arch/arm/kvm/irq.h b/arch/arm/kvm/irq.h
new file mode 100644
index 0000000..1275d91
--- /dev/null
+++ b/arch/arm/kvm/irq.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2014 Linaro Ltd.
+ * Authors: Eric Auger <eric.auger@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __IRQ_H
+#define __IRQ_H
+
+#include <linux/kvm_host.h>
+/*
+ * Placeholder for irqchip and irq/msi routing declarations
+ * included in irqchip.c
+ */
+
+#endif
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 123030b..907e735 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1259,7 +1259,10 @@ epilog:
 static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	bool level_pending = false;
+	struct kvm *kvm = vcpu->kvm;
+	int is_assigned_irq;
 
 	kvm_debug("MISR = %08x\n", vgic_cpu->vgic_misr);
 
@@ -1273,6 +1276,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 		for_each_set_bit(lr, (unsigned long *)vgic_cpu->vgic_eisr,
 				 vgic_cpu->nr_lr) {
 			irq = vgic_cpu->vgic_lr[lr] & GICH_LR_VIRTUALID;
+			spin_lock(&dist->lock);
 			BUG_ON(vgic_irq_is_edge(vcpu, irq));
 
 			vgic_irq_clear_queued(vcpu, irq);
@@ -1285,6 +1289,17 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			 * interrupt.
 			 */
 			vgic_dist_irq_clear_soft_pend(vcpu, irq);
+			spin_unlock(&dist->lock);
+
+			is_assigned_irq = kvm_irq_has_notifier(kvm, 0,
+						irq - VGIC_NR_PRIVATE_IRQS);
+
+			if (is_assigned_irq) {
+				kvm_debug("EOI irqchip routed vIRQ %d\n", irq);
+				kvm_notify_acked_irq(kvm, 0,
+					irq - VGIC_NR_PRIVATE_IRQS);
+			}
+			spin_lock(&dist->lock);
 
 			/* Any additional pending interrupt? */
 			if (vgic_dist_irq_get_level(vcpu, irq)) {
@@ -1305,6 +1320,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			 */
 			set_bit(lr, (unsigned long *)vgic_cpu->vgic_elrsr);
 			vgic_cpu->vgic_lr[lr] &= ~GICH_LR_ACTIVE_BIT;
+			spin_unlock(&dist->lock);
 		}
 	}
 
@@ -1344,8 +1360,10 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	/* Check if we still have something up our sleeve... */
 	pending = find_first_zero_bit((unsigned long *)vgic_cpu->vgic_elrsr,
 				      vgic_cpu->nr_lr);
+	spin_lock(&dist->lock);
 	if (level_pending || pending < vgic_cpu->nr_lr)
 		set_bit(vcpu->vcpu_id, &dist->irq_pending_on_cpu);
+	spin_unlock(&dist->lock);
 }
 
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
@@ -1362,14 +1380,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
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
@@ -2146,3 +2160,35 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 	.get_attr = vgic_get_attr,
 	.has_attr = vgic_has_attr,
 };
+
+int kvm_irq_map_gsi(struct kvm *kvm,
+		    struct kvm_kernel_irq_routing_entry *entries, int gsi)
+{
+	return gsi;
+}
+
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+{
+	return pin;
+}
+
+int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
+		bool line_status)
+{
+	int r = -EINVAL;
+	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+
+	if (spi > KVM_ARM_IRQ_GIC_MAX)
+		return r;
+
+	kvm_debug("Inject irqchip routed vIRQ %d\n", irq);
+	r = kvm_vgic_inject_irq(kvm, 0, spi, level);
+	return r;
+}
+
+/* MSI not implemented yet */
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id, int level, bool line_status)
+{
+	return 0;
+}
-- 
1.9.1

