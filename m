Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaLCQJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:09:32 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44648 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbaLCQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:09:14 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, joel.schopp@amd.com,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: [PATCH v5 5/5] KVM: arm/arm64: add irqfd support
Date: Wed,  3 Dec 2014 17:07:12 +0100
Message-Id: <1417622832-5460-6-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables irqfd on arm/arm64.

Both irqfd and resamplefd are supported. Injection is implemented
in vgic.c without routing.

This patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.

KVM_CAP_IRQFD is now advertised. KVM_CAP_IRQFD_RESAMPLE capability
automatically is advertised as soon as CONFIG_HAVE_KVM_IRQFD is set.

Irqfd injection is restricted to SPI. The rationale behind not
supporting PPI irqfd injection is that any device using a PPI would
be a private-to-the-CPU device (timer for instance), so its state
would have to be context-switched along with the VCPU and would
require in-kernel wiring anyhow. It is not a relevant use case for
irqfds.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v4 -> v5:
- squash [PATCH v4 3/3] KVM: arm64: add irqfd support into this patch
- some rewording in Documentation/virtual/kvm/api.txt and in vgic
  vgic_process_maintenance unlock comment.
- move explanation of why not supporting PPI into commit message
- in case of injection before gic readiness, -ENODEV is returned. It is
  up to the user space to avoid this situation.

v3 -> v4:
- reword commit message
- explain why we unlock the distributor before calling kvm_notify_acked_irq
- rename is_assigned_irq into has_notifier
- change EOI and injection kvm_debug format string
- remove error local variable in kvm_set_irq
- Move HAVE_KVM_IRQCHIP unset in a separate patch
- handle case were the irqfd injection is attempted before the vgic is ready.
  in such a case the notifier, if any, is called immediatly
- use nr_irqs to test spi is within correct range

v2 -> v3:
- removal of irq.h from eventfd.c put in a separate patch to increase
  visibility
- properly expose KVM_CAP_IRQFD capability in arm.c
- remove CONFIG_HAVE_KVM_IRQCHIP meaningfull only if irq_comm.c is used

v1 -> v2:
- rebase on 3.17rc1
- move of the dist unlock in process_maintenance
- remove of dist lock in __kvm_vgic_sync_hwstate
- rewording of the commit message (add resamplefd reference)
- remove irq.h
---
 Documentation/virtual/kvm/api.txt |  6 +++-
 arch/arm/include/uapi/asm/kvm.h   |  3 ++
 arch/arm/kvm/Kconfig              |  2 ++
 arch/arm/kvm/Makefile             |  2 +-
 arch/arm/kvm/arm.c                |  3 ++
 arch/arm64/include/uapi/asm/kvm.h |  3 ++
 arch/arm64/kvm/Kconfig            |  2 ++
 arch/arm64/kvm/Makefile           |  2 +-
 virt/kvm/arm/vgic.c               | 63 ++++++++++++++++++++++++++++++++++++---
 9 files changed, 79 insertions(+), 7 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 7610eaa..8993556 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2206,7 +2206,7 @@ into the hash PTE second double word).
 4.75 KVM_IRQFD
 
 Capability: KVM_CAP_IRQFD
-Architectures: x86 s390
+Architectures: x86 s390 arm arm64
 Type: vm ioctl
 Parameters: struct kvm_irqfd (in)
 Returns: 0 on success, -1 on error
@@ -2232,6 +2232,10 @@ Note that closing the resamplefd is not sufficient to disable the
 irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
 and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
 
+On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
+Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
+given by gsi + 32.
+
 4.76 KVM_PPC_ALLOCATE_HTAB
 
 Capability: KVM_CAP_PPC_ALLOC_HTAB
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 09ee408..77547bb 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -196,6 +196,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 9f581b1..e519a40 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -24,6 +24,7 @@ config KVM
 	select KVM_MMIO
 	select KVM_ARM_HOST
 	depends on ARM_VIRT_EXT && ARM_LPAE
+	select HAVE_KVM_EVENTFD
 	---help---
 	  Support hosting virtualized guest machines. You will also
 	  need to select one or more of the processor modules below.
@@ -55,6 +56,7 @@ config KVM_ARM_MAX_VCPUS
 config KVM_ARM_VGIC
 	bool "KVM support for Virtual GIC"
 	depends on KVM_ARM_HOST && OF
+	select HAVE_KVM_IRQFD
 	default y
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index f7057ed..859db09 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
 AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
 
 KVM := ../../../virt/kvm
-kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
+kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 5309e4b..45681b4 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -172,6 +172,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IRQCHIP:
 		r = vgic_present;
 		break;
+#ifdef CONFIG_HAVE_KVM_IRQFD
+	case KVM_CAP_IRQFD:
+#endif
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 8e38878..1ed4417 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -182,6 +182,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 279e1a0..09c25c2 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select KVM_ARM_HOST
 	select KVM_ARM_VGIC
 	select KVM_ARM_TIMER
+	select HAVE_KVM_EVENTFD
 	---help---
 	  Support hosting virtualized guest machines.
 
@@ -50,6 +51,7 @@ config KVM_ARM_MAX_VCPUS
 config KVM_ARM_VGIC
 	bool
 	depends on KVM_ARM_HOST && OF
+	select HAVE_KVM_IRQFD
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 32a0961..2e6b827 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 3aaca49..6ab232a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1446,7 +1446,10 @@ epilog:
 static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 {
 	u32 status = vgic_get_interrupt_status(vcpu);
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	bool level_pending = false;
+	struct kvm *kvm = vcpu->kvm;
+	bool has_notifier;
 
 	kvm_debug("STATUS = %08x\n", status);
 
@@ -1463,6 +1466,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 			WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
 
+			spin_lock(&dist->lock);
 			vgic_irq_clear_queued(vcpu, vlr.irq);
 			WARN_ON(vlr.state & LR_STATE_MASK);
 			vlr.state = 0;
@@ -1481,6 +1485,24 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			 */
 			vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
 
+			/*
+			 * kvm_notify_acked_irq calls kvm_set_irq()
+			 * to reset the IRQ level. Need to release the
+			 * lock for kvm_set_irq to grab it.
+			 */
+			spin_unlock(&dist->lock);
+
+			has_notifier = kvm_irq_has_notifier(kvm, 0,
+						vlr.irq - VGIC_NR_PRIVATE_IRQS);
+
+			if (has_notifier) {
+				kvm_debug("Guest EOIed vIRQ %d on CPU %d\n",
+					  vlr.irq, vcpu->vcpu_id);
+				kvm_notify_acked_irq(kvm, 0,
+						vlr.irq - VGIC_NR_PRIVATE_IRQS);
+			}
+			spin_lock(&dist->lock);
+
 			/* Any additional pending interrupt? */
 			if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
 				vgic_cpu_irq_set(vcpu, vlr.irq);
@@ -1490,6 +1512,8 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 				vgic_cpu_irq_clear(vcpu, vlr.irq);
 			}
 
+			spin_unlock(&dist->lock);
+
 			/*
 			 * Despite being EOIed, the LR may not have
 			 * been marked as empty.
@@ -1554,14 +1578,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
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
@@ -2477,3 +2497,38 @@ out_free_irq:
 	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
 	return ret;
 }
+
+int kvm_irq_map_gsi(struct kvm *kvm,
+		    struct kvm_kernel_irq_routing_entry *entries,
+		    int gsi)
+{
+	return gsi;
+}
+
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+{
+	return pin;
+}
+
+int kvm_set_irq(struct kvm *kvm, int irq_source_id,
+		u32 irq, int level, bool line_status)
+{
+	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+
+	kvm_debug("irqfd sets vIRQ %d to %d\n", irq, level);
+
+	if (likely(vgic_initialized(kvm))) {
+		if (spi > kvm->arch.vgic.nr_irqs)
+			return -EINVAL;
+		return kvm_vgic_inject_irq(kvm, 0, spi, level);
+	} else
+		return -ENODEV;
+}
+
+/* MSI not implemented yet */
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id,
+		int level, bool line_status)
+{
+	return 0;
+}
-- 
1.9.1

