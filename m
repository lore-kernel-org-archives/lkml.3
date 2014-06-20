Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967136AbaFTLnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:43:02 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55312 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966645AbaFTLnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:43:00 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com
Subject: [RFC v3] ARM: KVM: add irqfd and irq routing support
Date: Fri, 20 Jun 2014 13:41:55 +0200
Message-Id: <1403264515-21336-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables irqfd and irq routing on ARM.

It turns CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQ_ROUTING on.

irqfd framework enables to inject a virtual IRQ into a guest upon an
eventfd trigger.

1) user-side first needs to setup a GSI routing table using
KVM_SET_GSI_ROUTING ioctl. A routing entry defines an association
between an IRQ (aka GSI) and an irqchip pin. On ARM there is a single
irqchip, ie. the GIC. On ARM, natural choice is to set gsi = irqchip.pin.

2) user-side uses KVM_IRQFD VM ioctl to provide KVM with a kvm_irqfd struct
that associates a VM, an eventfd, an IRQ number (aka. the GSI). When an actor
signals the eventfd (typically a VFIO platform driver), the irqfd subsystem
injects a virtual IRQ correponding to the irqchip pin associated to that
GSI. irqchip.pin is computed from previous routing table. On ARM it is
assumed to by an SPI only.

This RFC applies on top of
https://lists.cs.columbia.edu/pipermail/kvmarm/2014-June/009979.html

All pieces can be found on git://git.linaro.org/people/eric.auger/linux.git
branch irqfd_integ_v3

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

GSI routing mostly is implemented in generic irqchip.c.
The tiny ARM specific part is directly implemented in the virtual interrupt
controller (vgic.c) as it is done for powerpc for instance. This option was
prefered compared to implementing other #ifdef in irq_comm.c (x86 and ia64).
Hence irq_comm.c is not used at all.

MSI routing is not supported yet. Edge sensitive IRQ injection was not tested
but should be OK (KVM_USERSPACE_IRQ_SOURCE_ID path).

This work was tested with Calxeda Midway xgmac main interrupt with
qemu-system-arm and QEMU VFIO platform device.

Known issues:
- static allocation of chip[][] in irqchip.c forces to statically dimension
the number of IRQS supported by the VGIC.
KVM_IRQCHIP_NUM_PINS still currently is set to VGIC_NR_IRQS, which may become
VGIC_NR_IRQS_LEGACY with the advent of:
http://www.spinics.net/lists/arm-kernel/msg277415.html

- if for some reason the IRQ is never EOI'ed, the notifier never is called.
  If its job typically consists in unmasking the physical IRQ as it is for
  VFIO, the IRQ might stay masked.

v3:
- correct misc style issues
- remove notifier call in clear pending MMIO write, now fixed by
  Christoffer VGIC clear pending correction:
  https://lists.cs.columbia.edu/pipermail/kvmarm/2014-June/009979.html
- remove allocation of identity routing table. It is assumed to be
  user-side's job to set it.
- vgic_set_assigned_irq now handles both levels in a symetrical way.
  dist lock issue fixed by defining finer lock regions in
  kvm_vgic_sync_hwstate()
- IRQFD implementation better documented in kvm/api.txt
- KVM_IRQCHIP_NUM_PINS set to VGIC_NR_IRQS_LEGACY as temporary solution
- check ue->u.irqchip.irqchip

v2:
2 fixes:
- v1 assumed gsi/irqchip.pin was already incremented by VGIC_NR_PRIVATE_IRQS.
  This is now vgic_set_assigned_irq that increments it before injection.
- v2 now handles the case where a pending assigned irq is cleared through
  MMIO access. The irq is properly acked allowing the resamplefd handler
  to possibly unmask the physical IRQ.
---
 Documentation/virtual/kvm/api.txt |  12 ++++-
 arch/arm/include/uapi/asm/kvm.h   |   9 ++++
 arch/arm/kvm/Kconfig              |   2 +
 arch/arm/kvm/Makefile             |   1 +
 arch/arm/kvm/irq.h                |  25 +++++++++
 virt/kvm/arm/vgic.c               | 108 ++++++++++++++++++++++++++++++++++++--
 6 files changed, 151 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/kvm/irq.h

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index b4f5365..326e382 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1339,7 +1339,7 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
 4.52 KVM_SET_GSI_ROUTING
 
 Capability: KVM_CAP_IRQ_ROUTING
-Architectures: x86 ia64 s390
+Architectures: x86 ia64 s390 arm
 Type: vm ioctl
 Parameters: struct kvm_irq_routing (in)
 Returns: 0 on success, -1 on error
@@ -2126,7 +2126,7 @@ into the hash PTE second double word).
 4.75 KVM_IRQFD
 
 Capability: KVM_CAP_IRQFD
-Architectures: x86 s390
+Architectures: x86 s390 arm
 Type: vm ioctl
 Parameters: struct kvm_irqfd (in)
 Returns: 0 on success, -1 on error
@@ -2152,6 +2152,14 @@ Note that closing the resamplefd is not sufficient to disable the
 irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
 and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
 
+On ARM/arm64 the virtual IRQ injection mandates the existence of a
+routing table, set through KVM_SET_GSI_ROUTING. this latter contains
+entries which associate a gsi with an irqchip pin. The injected virtual
+IRQ actually corresponds to the irqchip.pin. It is up to the user to
+define gsi = irqchip.pin or not. On ARM the single irqchip is the GIC.
+Then irqchip.pin is interpreted as the system shared peripheral
+interrupt number (SPI). Associated GIC interrupt ID is irqchip.pin + 32.
+
 4.76 KVM_PPC_ALLOCATE_HTAB
 
 Capability: KVM_CAP_PPC_ALLOC_HTAB
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index ef0c878..9b642a3 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -192,6 +192,15 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
+/*
+ * temporary solution until static allocation of chip[][] in irqchip.c
+ * is changed
+ */
+#define KVM_IRQCHIP_NUM_PINS    VGIC_NR_IRQS
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 4be5bb1..096692c 100644
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
@@ -56,6 +57,7 @@ config KVM_ARM_VGIC
 	bool "KVM support for Virtual GIC"
 	depends on KVM_ARM_HOST && OF
 	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQ_ROUTING
 	default y
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 789bca9..29de111 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -21,4 +21,5 @@ obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
 obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
 obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic.o
+obj-$(CONFIG_HAVE_KVM_EVENTFD) += $(KVM)/eventfd.o $(KVM)/irqchip.o
 obj-$(CONFIG_KVM_ARM_TIMER) += $(KVM)/arm/arch_timer.o
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
index 66fc48b..c06bed0 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -99,6 +99,7 @@ static struct device_node *vgic_node;
 #define ACCESS_WRITE_VALUE	(3 << 1)
 #define ACCESS_WRITE_MASK(x)	((x) & (3 << 1))
 
+static int vgic_set_default_irq_routing(struct kvm *kvm);
 static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
 static void vgic_update_state(struct kvm *kvm);
 static void vgic_kick_vcpus(struct kvm *kvm);
@@ -1259,7 +1260,10 @@ epilog:
 static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	bool level_pending = false;
+	struct kvm *kvm = vcpu->kvm;
+	int is_assigned_irq;
 
 	kvm_debug("MISR = %08x\n", vgic_cpu->vgic_misr);
 
@@ -1273,6 +1277,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 		for_each_set_bit(lr, (unsigned long *)vgic_cpu->vgic_eisr,
 				 vgic_cpu->nr_lr) {
 			irq = vgic_cpu->vgic_lr[lr] & GICH_LR_VIRTUALID;
+			spin_lock(&dist->lock);
 			BUG_ON(vgic_irq_is_edge(vcpu, irq));
 
 			vgic_irq_clear_queued(vcpu, irq);
@@ -1285,6 +1290,17 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
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
@@ -1305,6 +1321,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			 */
 			set_bit(lr, (unsigned long *)vgic_cpu->vgic_elrsr);
 			vgic_cpu->vgic_lr[lr] &= ~GICH_LR_ACTIVE_BIT;
+			spin_unlock(&dist->lock);
 		}
 	}
 
@@ -1344,8 +1361,10 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	/* Check if we still have something up our sleeve... */
 	pending = find_first_zero_bit((unsigned long *)vgic_cpu->vgic_elrsr,
 				      vgic_cpu->nr_lr);
+	spin_lock(&dist->lock);
 	if (level_pending || pending < vgic_cpu->nr_lr)
 		set_bit(vcpu->vcpu_id, &dist->irq_pending_on_cpu);
+	spin_unlock(&dist->lock);
 }
 
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
@@ -1362,14 +1381,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
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
@@ -1740,6 +1755,8 @@ int kvm_vgic_create(struct kvm *kvm)
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
 
+	vgic_set_default_irq_routing(kvm);
+
 out_unlock:
 	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
 		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
@@ -2130,3 +2147,86 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 	.get_attr = vgic_get_attr,
 	.has_attr = vgic_has_attr,
 };
+
+static int vgic_set_default_irq_routing(struct kvm *kvm)
+{
+	struct kvm_irq_routing_entry *routing;
+
+	/* Create a nop default map, so that dereferencing it still works */
+	routing = kzalloc((sizeof(*routing)), GFP_KERNEL);
+	if (!routing)
+		return -ENOMEM;
+
+	kvm_set_irq_routing(kvm, routing, 0, 0);
+
+	kfree(routing);
+	return 0;
+}
+
+
+/**
+ * vgic_set_assigned_irq - Inject a routed IRQ to the vgic
+ * @e: the routing entry describing how to route the IRQ
+ * @kvm: the kvm struct
+ * @irq_source_id: the irq source id (userspace or resample)
+ * @level: wire level
+ * @line_status: currently unused
+ * return 0
+ *
+ * This is the function that is eventually called by kvm_set_irq
+ * implemented in irqchip.c.
+ */
+static int vgic_set_assigned_irq(struct kvm_kernel_irq_routing_entry *e,
+			   struct kvm *kvm, int irq_source_id, int level,
+			   bool line_status)
+{
+	int r = -EINVAL;
+	unsigned int spi = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+
+	if (spi > KVM_ARM_IRQ_GIC_MAX)
+		return r;
+
+	kvm_debug("Inject irqchip routed vIRQ %d\n", e->irqchip.pin);
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
+
+/**
+ * Populates a kvm routing entry from a user routing entry
+ * and update the routing table chip array
+ * @rt: routing table
+ * @e: kvm internal formatted entry
+ * @ue: user api formatted entry
+ * return 0 on success, -EINVAL on errors.
+ */
+int kvm_set_routing_entry(struct kvm_irq_routing_table *rt,
+			  struct kvm_kernel_irq_routing_entry *e,
+			  const struct kvm_irq_routing_entry *ue)
+{
+	int r = -EINVAL;
+
+	switch (ue->type) {
+	case KVM_IRQ_ROUTING_IRQCHIP:
+		e->set = vgic_set_assigned_irq;
+		e->irqchip.irqchip = ue->u.irqchip.irqchip;
+		e->irqchip.pin = ue->u.irqchip.pin;
+		if (e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS)
+			goto out;
+		if (e->irqchip.irqchip >= KVM_NR_IRQCHIPS)
+			goto out;
+		rt->chip[e->irqchip.irqchip][e->irqchip.pin] = ue->gsi;
+		break;
+	default:
+		goto out;
+	}
+	r = 0;
+out:
+	return r;
+}
-- 
1.9.1

