Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaLCHwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:52:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:15093 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbaLCHuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852477"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 19/25] KVM: x86: kvm-vfio: VT-d posted-interrupts setup
Date: Wed,  3 Dec 2014 15:39:48 +0800
Message-Id: <1417592394-24343-20-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines macro __KVM_HAVE_ARCH_KVM_VFIO_POSTING and
implement kvm_arch_vfio_update_pi_irte for x86 architecture.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/Makefile           |    2 +-
 arch/x86/kvm/kvm_vfio_x86.c     |   68 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kvm/kvm_vfio_x86.c

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b45b78..6878429 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -82,6 +82,8 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 		(base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
 }
 
+#define __KVM_HAVE_ARCH_KVM_VFIO_POSTING
+
 #define SELECTOR_TI_MASK (1 << 2)
 #define SELECTOR_RPL_MASK 0x03
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 25d22b2..8809d58 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= $(KVM)/assigned-dev.o $(KVM)/iommu.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
-			   i8254.o cpuid.o pmu.o
+			   i8254.o cpuid.o pmu.o kvm_vfio_x86.o
 kvm-intel-y		+= vmx.o
 kvm-amd-y		+= svm.o
 
diff --git a/arch/x86/kvm/kvm_vfio_x86.c b/arch/x86/kvm/kvm_vfio_x86.c
new file mode 100644
index 0000000..c59a31a
--- /dev/null
+++ b/arch/x86/kvm/kvm_vfio_x86.c
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2014 Intel Corporation.
+ * Authors: Feng Wu <feng.wu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/irq_remapping.h>
+
+/*
+ * kvm_arch_vfio_update_pi_irte - set IRTE for Posted-Interrupts
+ *
+ * @kvm: kvm
+ * @host_irq: host irq of the interrupt
+ * @guest_irq: gsi of the interrupt
+ * returns 0 on success, < 0 on failure
+ */
+int kvm_arch_vfio_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
+				 uint32_t guest_irq)
+{
+	struct kvm_kernel_irq_routing_entry *e;
+	struct kvm_irq_routing_table *irq_rt;
+	struct kvm_lapic_irq irq;
+	struct kvm_vcpu *vcpu;
+	struct vcpu_data vcpu_info;
+	int idx, ret = -EINVAL;
+
+	idx = srcu_read_lock(&kvm->irq_srcu);
+	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
+	BUG_ON(guest_irq >= irq_rt->nr_rt_entries);
+
+	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
+		if (e->type != KVM_IRQ_ROUTING_MSI)
+			continue;
+		/*
+		 * VT-d PI cannot support posting multicast/broadcast
+		 * interrupts to a VCPU, we still use interrupt remapping
+		 * for these kind of interrupts.
+		 */
+
+		kvm_set_msi_irq(e, &irq);
+		if (!kvm_find_dest_vcpu(kvm, &irq, &vcpu))
+			continue;
+
+		vcpu_info.pi_desc_addr = kvm_x86_ops->get_pi_desc_addr(vcpu);
+		vcpu_info.vector = irq.vector;
+
+		if (irq_set_vcpu_affinity(host_irq, &vcpu_info) < 0) {
+			printk(KERN_INFO "%s: failed to update PI IRTE\n",
+					__func__);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	ret = 0;
+out:
+	srcu_read_unlock(&kvm->irq_srcu, idx);
+	return ret;
+}
-- 
1.7.1

