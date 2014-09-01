Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaIAMyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:54:06 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:49480 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbaIAMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:53:57 -0400
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
Subject: [RFC v2 9/9] KVM: KVM-VFIO: ARM forwarding control
Date: Mon,  1 Sep 2014 14:52:48 +0200
Message-Id: <1409575968-5329-10-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables forwarding control for ARM. By defining
__KVM_HAVE_ARCH_KVM_VFIO_FORWARD the patch enables
KVM_DEV_VFIO_DEVICE_FORWARD/UNFORWARD_IRQ command on ARM. As a
result it brings an optimized injection/completion handling for
forwarded IRQ. The ARM specific part is implemented in a new module,
kvm_vfio_arm.c

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 arch/arm/include/asm/kvm_host.h |  2 +
 arch/arm/kvm/Makefile           |  2 +-
 arch/arm/kvm/kvm_vfio_arm.c     | 85 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/kvm/kvm_vfio_arm.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 1aee6bb..dfd3b05 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -25,6 +25,8 @@
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
index 0000000..0d316b1
--- /dev/null
+++ b/arch/arm/kvm/kvm_vfio_arm.c
@@ -0,0 +1,85 @@
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
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+
+/**
+ * kvm_arch_set_fwd_state - change the forwarded state of an IRQ
+ * @pfwd: the forwarded irq struct
+ * @action: action to perform (set forward, set back normal, cleanup)
+ *
+ * programs the GIC and VGIC
+ * returns the VGIC map/unmap return status
+ * It is the responsability of the caller to make sure the physical IRQ
+ * is not active. there is a critical section between the start of the
+ * VFIO IRQ handler and LR programming.
+ */
+int kvm_arch_set_fwd_state(struct kvm_fwd_irq *pfwd,
+			   enum kvm_fwd_irq_action action)
+{
+	int ret;
+	struct irq_desc *desc = irq_to_desc(pfwd->hwirq);
+	struct irq_data *d = &desc->irq_data;
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	disable_irq(pfwd->hwirq);
+	/* no fwd state change can happen if the IRQ is in progress */
+	if (irqd_irq_inprogress(d)) {
+		kvm_err("%s cannot change fwd state (IRQ %d in progress\n",
+			__func__, pfwd->hwirq);
+		enable_irq(pfwd->hwirq);
+		return -1;
+	}
+
+	if (action == KVM_VFIO_IRQ_SET_FORWARD) {
+		irqd_set_irq_forwarded(d);
+		ret = vgic_map_phys_irq(pfwd->vcpu,
+					pfwd->gsi + VGIC_NR_PRIVATE_IRQS,
+					pfwd->hwirq);
+	} else if (action == KVM_VFIO_IRQ_SET_NORMAL) {
+		irqd_clr_irq_forwarded(d);
+		ret = vgic_unmap_phys_irq(pfwd->vcpu,
+					  pfwd->gsi +
+						VGIC_NR_PRIVATE_IRQS,
+					  pfwd->hwirq);
+	} else if (action == KVM_VFIO_IRQ_CLEANUP) {
+		irqd_clr_irq_forwarded(d);
+		/*
+		 * in case the guest did not complete the
+		 * virtual IRQ, let's do it for him.
+		 * when cleanup is called, VCPU have already
+		 * been freed, do not manipulate VGIC
+		 */
+		chip->irq_eoi(d);
+		ret = 0;
+	} else {
+		enable_irq(pfwd->hwirq);
+		ret = -EINVAL;
+	}
+
+	enable_irq(pfwd->hwirq);
+	return ret;
+}
-- 
1.9.1

