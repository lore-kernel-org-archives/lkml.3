Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaKWShz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:37:55 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58837 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaKWShw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:37:52 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: [PATCH v3 8/8] KVM: arm: kvm-vfio: forwarding control
Date: Sun, 23 Nov 2014 19:36:00 +0100
Message-Id: <1416767760-14487-9-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets __KVM_HAVE_ARCH_KVM_VFIO_FORWARD and implements
kvm_arch_vfio_set_forward for ARM.

As a result the KVM-VFIO device now allows to forward/unforward a
VFIO device IRQ on ARM.

kvm_arch_vfio_set_forward programs both genirq and the VGIC to control
where the physical IRQ deactivation is initiated.
- forwarded case: deactivation is initiated by the guest; when it
  completes the virtual IRQ, the GIC automatically deactivates the
  physical IRQ.
- not forwarded case: the physical IRQ deactivation is handled by the host

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- renaming of kvm_arch_set_fwd_state into kvm_arch_vfio_set_forward
- takes a bool arg instead of kvm_fwd_irq_action enum
- removal of KVM_VFIO_IRQ_CLEANUP
- platform device check now happens here
- more precise errors returned
- irq_eoi handled externally to this patch (VGIC)
- correct enable_irq bug done twice
- reword the commit message
- correct check of platform_bus_type
- use raw_spin_lock_irqsave and check the validity of the handler
---
 arch/arm/include/asm/kvm_host.h |   2 +
 arch/arm/kvm/Makefile           |   2 +-
 arch/arm/kvm/kvm_vfio_arm.c     | 101 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/kvm/kvm_vfio_arm.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index bca5b79..447f90c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -27,6 +27,8 @@
 #include <asm/fpstate.h>
 #include <kvm/arm_arch_timer.h>
 
+#define __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
+
 #if defined(CONFIG_KVM_ARM_MAX_VCPUS)
 #define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
 #else
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index ea1fa76..26a5a42 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -19,7 +19,7 @@ kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vf
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
-obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
+obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o kvm_vfio_arm.o
 obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic.o
 obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic-v2.o
 obj-$(CONFIG_KVM_ARM_TIMER) += $(KVM)/arm/arch_timer.o
diff --git a/arch/arm/kvm/kvm_vfio_arm.c b/arch/arm/kvm/kvm_vfio_arm.c
new file mode 100644
index 0000000..af2c501
--- /dev/null
+++ b/arch/arm/kvm/kvm_vfio_arm.c
@@ -0,0 +1,101 @@
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
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/kvm_host.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/vfio.h>
+#include <linux/irq.h>
+#include <asm/kvm_host.h>
+#include <asm/kvm.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+
+/**
+ * kvm_arch_vfio_set_forward - Change the forward state of an IRQ
+ *
+ * @fwd_irq: handle to the forward irq struct
+ * @forward: target forwarding state
+ *
+ * If forward is true, programs genirq and VGIC so that physical IRQ
+ * deactivation ownership is transferred to the guest (using GIC HW feature).
+ * When forward is false, standard behavior is restored, ie. host
+ * deactivates the physical IRQ.
+ * returns:
+ * -EINVAL if the vfio device is not a platform device
+ * -ENOENT if the irq could not be identified
+ * -EBUSY if physical IRQ is in progress
+ * -ENOENT if the VGIC has a physical/virtual IRQ mapping that is not
+ *  consistent with the request.
+ */
+int kvm_arch_vfio_set_forward(struct kvm_fwd_irq *fwd_irq,
+			      bool forward)
+{
+	int hwirq;
+	int ret = -EBUSY;
+	struct irq_desc *desc;
+	struct irq_data *d;
+	struct platform_device *platdev;
+	struct device *dev = kvm_vfio_external_base_device(fwd_irq->vdev);
+	unsigned long flags;
+	/*
+	 * We don't have to garantee the vcpu handle is non void since the
+	 * vfio device holds a reference to the kvm struct
+	 */
+	struct kvm_vcpu *vcpu = kvm_get_vcpu(fwd_irq->kvm, 0);
+
+	if (dev->bus == &platform_bus_type) {
+		platdev = to_platform_device(dev);
+		hwirq = platform_get_irq(platdev, fwd_irq->index);
+		if (hwirq < 0)
+			return -EINVAL;
+	} else
+		return -ENOENT;
+	desc = irq_to_desc(hwirq);
+
+	/*
+	 * if VFIO handler is already set, forwarded state cannot be
+	 * changed anymore
+	 */
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	if (desc->action)
+		goto end;
+
+	d = &desc->irq_data;
+
+	if (forward) {
+		irqd_set_irq_forwarded(d);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+		ret = vgic_map_phys_irq(vcpu,
+					fwd_irq->gsi + VGIC_NR_PRIVATE_IRQS,
+					hwirq);
+	} else {
+		irqd_clr_irq_forwarded(d);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+		ret = vgic_unmap_phys_irq(vcpu,
+					  fwd_irq->gsi +
+						VGIC_NR_PRIVATE_IRQS,
+					  hwirq);
+	}
+	return ret;
+
+end:
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	return ret;
+}
-- 
1.9.1

