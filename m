Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaKKScZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:32:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39052 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKKScX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:32:23 -0500
Message-ID: <54625634.7000400@arm.com>
Date: Tue, 11 Nov 2014 18:32:20 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH 00/15] arm64: PCI/MSI: GICv3 ITS support (stacked domain
 edition)
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com> <546234FA.3060501@linux.intel.com> <546238FA.3040307@arm.com> <54623A10.9030705@linux.intel.com>
In-Reply-To: <54623A10.9030705@linux.intel.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 11 Nov 2014 18:32:21.0198 (UTC) FILETIME=[D482DEE0:01CFFDDD]
X-MC-Unique: 114111118322100201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerry,

On 11/11/14 16:32, Jiang Liu wrote:
> On 2014/11/12 0:27, Marc Zyngier wrote:
>> On 11/11/14 16:10, Jiang Liu wrote:
>>> Hi Marc,
>>> 	Sorry for the late notification. I have heavily reworked the
>>> interfaces for MSI irqdomain support based on review comments.
>>> Please refer to https://lkml.org/lkml/2014/11/9/88, please give your
>>> comments on the new interfaces:)
>>
>> Ah, I feel like I have more catch-up to do. Hopefully the changes are
>> simple enough to implement. Rebase time...
> The new interfaces are still RFC, so comments are warmly welcomed!

Just reworked my series, with the following changes:
- patch #2 is dropped entirely (which is good, as it was really making me feel rather uncomfortable)
- patch #3 becomes a bit cleaner (basically a simplified version of the x86 version, with the added feature of a configurable flow handler, see below).

So yes, definitely am improvement.  I'm still a bit worried about the flow handler being set by the top-level domain, which makes it the odd case on ARM (we always set it at the bottom level for all other use cases). It works, but having two different set of rules feels fragile to me.

Anyway, thanks for the heads up!

Thanks,

	M.

>From 2c1f591b06a5a3bef784bfb2a491158e44bf972f Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Tue, 11 Nov 2014 12:46:12 +0000
Subject: [PATCH 02/14] arm64: MSI: Add support for stacked MSI domain

In the spirit of the new x86 support for stacked domains and MSI,
add the minimum backend to support this feature on arm64.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/msi.h |  26 ++++++++++
 arch/arm64/kernel/Makefile   |   1 +
 arch/arm64/kernel/msi.c      | 114 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)
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
index 0000000..4e7847b
--- /dev/null
+++ b/arch/arm64/kernel/msi.c
@@ -0,0 +1,114 @@
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
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
+
+#include <asm/msi.h>
+
+static struct irq_domain *pci_msi_default_domain;
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
+static struct irq_chip pci_msi_irq_chip = {
+	.name			= "PCI-MSI",
+	.irq_unmask		= arm64_unmask_msi_irq,
+	.irq_mask		= arm64_mask_msi_irq,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_set_affinity	= irq_chip_set_affinity_parent,
+	.irq_write_msi_msg	= pci_msi_write_msg,
+};
+
+static void pci_msi_generate_hwirq(struct msi_domain_info *minfo, void *arg,
+				   struct msi_desc *desc)
+{
+	struct arm64_msi_info *info = arg;
+
+	info->msi_hwirq = pci_msi_calc_hwirq(info->pdev, desc);
+}
+
+static irq_hw_number_t pci_msi_get_hwirq(struct msi_domain_info *minfo,
+					 void *arg)
+{
+	struct arm64_msi_info *info = arg;
+
+	return info->msi_hwirq;
+}
+
+static int pci_msi_init(struct irq_domain *domain,
+			struct msi_domain_info *minfo, unsigned int virq,
+			irq_hw_number_t hwirq, void *arg)
+{
+	irq_domain_set_info(domain, virq, hwirq, minfo->chip, NULL,
+			    minfo->data, NULL, NULL);
+
+	return 0;
+}
+
+static void pci_msi_free(struct irq_domain *domain,
+			 struct msi_domain_info *info, unsigned int virq)
+{
+	struct msi_desc *desc = irq_get_msi_desc(virq);
+
+	if (desc)
+		desc->irq = 0;
+}
+
+static struct msi_domain_ops pci_msi_ops = {
+	.calc_hwirq = pci_msi_generate_hwirq,
+	.get_hwirq = pci_msi_get_hwirq,
+	.msi_init = pci_msi_init,
+	.msi_free = pci_msi_free,
+};
+
+static struct msi_domain_info pci_msi_info = {
+	.ops	= &pci_msi_ops,
+	.chip	= &pci_msi_irq_chip,
+	/* .data is used to contain our flow handler */
+};
+
+void arm64_init_msi_domain(struct irq_domain *parent, irq_flow_handler_t handle)
+{
+	WARN_ON(pci_msi_default_domain);
+	WARN_ON(pci_msi_info.data);
+	pci_msi_info.data = handle;
+	pci_msi_default_domain = msi_create_irq_domain(NULL,
+						       &pci_msi_info,
+						       parent);
+	if (!pci_msi_default_domain)
+		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
+}
+
+/* Override the weak version from drivers/pci/msi.c */
+int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
+{
+	struct arm64_msi_info info;
+
+	info.pdev = pdev;
+	info.nvec = nvec;
+
+	return pci_msi_irq_domain_alloc_irqs(pci_msi_default_domain,
+					     type, pdev, &info);
+}
-- 
2.0.4


-- 
Jazz is not dead. It just smells funny...

