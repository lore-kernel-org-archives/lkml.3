Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaKKPs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:48:27 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56164 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaKKPs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:26 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 03/15] arm64: MSI: Add support for stacked MSI domain
Date: Tue, 11 Nov 2014 15:48:01 +0000
Message-Id: <1415720893-13371-4-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the spirit of the new x86 support for stacked domains and MSI,
add the minimum backend to support this feature on arm64.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/msi.h | 26 ++++++++++++++
 arch/arm64/kernel/Makefile   |  1 +
 arch/arm64/kernel/msi.c      | 80 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 arch/arm64/include/asm/msi.h
 create mode 100644 arch/arm64/kernel/msi.c

diff --git a/arch/arm64/include/asm/msi.h b/arch/arm64/include/asm/msi.h
new file mode 100644
index 0000000..d07dab7
--- /dev/null
+++ b/arch/arm64/include/asm/msi.h
@@ -0,0 +1,26 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __ARM64_MSI_H__
+#define __ARM64_MSI_H__
+
+struct arm64_msi_info {
+	struct pci_dev		*pdev;
+	irq_hw_number_t		msi_hwirq;
+	int			nvec;
+};
+
+void arm64_init_msi_domain(struct irq_domain *parent, irq_flow_handler_t handle);
+
+#endif /* __ARM64_MSI_H__ */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 5bd029b..33283b8 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -31,6 +31,7 @@ arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
 arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
 arm64-obj-$(CONFIG_PCI)			+= pci.o
+arm64-obj-$(CONFIG_PCI_MSI_IRQ_DOMAIN)	+= msi.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/msi.c b/arch/arm64/kernel/msi.c
new file mode 100644
index 0000000..82f6162
--- /dev/null
+++ b/arch/arm64/kernel/msi.c
@@ -0,0 +1,80 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/irq.h>
+#include <linux/msi.h>
+
+#include <asm/msi.h>
+
+static struct irq_domain *msi_default_domain;
+static irq_flow_handler_t msi_flow_handler;
+
+irq_hw_number_t arch_msi_irq_domain_get_hwirq(void *arg)
+{
+	struct arm64_msi_info *info = arg;
+
+	return info->msi_hwirq;
+}
+
+void arch_msi_irq_domain_set_hwirq(void *arg, irq_hw_number_t msi_hwirq)
+{
+	struct arm64_msi_info *info = arg;
+
+	info->msi_hwirq = msi_hwirq;
+}
+
+void arch_msi_irq_set_handler(unsigned int virq)
+{
+	__irq_set_handler(virq, msi_flow_handler, 0, NULL);
+}
+
+static void arm64_mask_msi_irq(struct irq_data *d)
+{
+	mask_msi_irq(d);
+	irq_chip_mask_parent(d);
+}
+
+static void arm64_unmask_msi_irq(struct irq_data *d)
+{
+	unmask_msi_irq(d);
+	irq_chip_unmask_parent(d);
+}
+
+static struct irq_chip msi_irq_chip = {
+	.name			= "PCI-MSI",
+	.irq_unmask		= arm64_unmask_msi_irq,
+	.irq_mask		= arm64_mask_msi_irq,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_set_affinity	= irq_chip_set_affinity_parent,
+};
+
+int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
+{
+	struct arm64_msi_info info;
+
+	info.pdev = pdev;
+	info.nvec = nvec;
+
+	return msi_irq_domain_alloc_irqs(msi_default_domain, type, pdev, &info);
+}
+
+void arm64_init_msi_domain(struct irq_domain *parent, irq_flow_handler_t handle)
+{
+	WARN_ON(msi_default_domain);
+	WARN_ON(msi_flow_handler);
+	msi_flow_handler = handle;
+	msi_default_domain = msi_create_irq_domain(NULL, &msi_irq_chip, parent);
+	if (!msi_default_domain)
+		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
+}
-- 
2.0.4

