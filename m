Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaLOJzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 04:55:31 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:55967 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaLOJyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 04:54:52 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>,
        <billsumnerlinux@gmail.com>, <zhen-hual@hp.com>
Cc: <iommu@lists.linux-foundation.org>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>
Subject: [PATCH 09/10] iommu/vt-d: Copy functions for irte
Date: Mon, 15 Dec 2014 17:53:05 +0800
Message-Id: <1418637186-9988-10-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1418637186-9988-1-git-send-email-zhen-hual@hp.com>
References: <1418637186-9988-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions to copy the irte data from the old kernel into the kdump kernel.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel_irq_remapping.c | 57 +++++++++++++++++++++++++++++++++++++
 include/linux/intel-iommu.h         |  4 +++
 2 files changed, 61 insertions(+)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 27541d4..090ba32 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -8,6 +8,7 @@
 #include <linux/irq.h>
 #include <linux/intel-iommu.h>
 #include <linux/acpi.h>
+#include <linux/crash_dump.h>
 #include <asm/io_apic.h>
 #include <asm/smp.h>
 #include <asm/cpu.h>
@@ -17,6 +18,11 @@
 
 #include "irq_remapping.h"
 
+#ifdef CONFIG_CRASH_DUMP
+static int __iommu_load_old_irte(struct intel_iommu *iommu);
+static int __iommu_update_old_irte(struct intel_iommu *iommu, int index);
+#endif /* CONFIG_CRASH_DUMP */
+
 struct ioapic_scope {
 	struct intel_iommu *iommu;
 	unsigned int id;
@@ -1296,3 +1302,54 @@ int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
 
 	return ret;
 }
+
+#ifdef CONFIG_CRASH_DUMP
+
+static int __iommu_load_old_irte(struct intel_iommu *iommu)
+{
+	if ((!iommu)
+		|| (!iommu->ir_table)
+		|| (!iommu->ir_table->base)
+		|| (!iommu->ir_table->base_old_phys)
+		|| (!iommu->ir_table->base_old_virt))
+		return -1;
+
+	memcpy(iommu->ir_table->base,
+		iommu->ir_table->base_old_virt,
+		INTR_REMAP_TABLE_ENTRIES*sizeof(struct irte));
+
+	return 0;
+}
+
+static int __iommu_update_old_irte(struct intel_iommu *iommu, int index)
+{
+	int start;
+	unsigned long size;
+	void __iomem *to;
+	void *from;
+
+	if ((!iommu)
+		|| (!iommu->ir_table)
+		|| (!iommu->ir_table->base)
+		|| (!iommu->ir_table->base_old_phys)
+		|| (!iommu->ir_table->base_old_virt))
+		return -1;
+
+	if (index < -1 || index >= INTR_REMAP_TABLE_ENTRIES)
+		return -1;
+
+	if (index == -1) {
+		start = 0;
+		size = INTR_REMAP_TABLE_ENTRIES * sizeof(struct irte);
+	} else {
+		start = index * sizeof(struct irte);
+		size = sizeof(struct irte);
+	}
+
+	to = iommu->ir_table->base_old_virt;
+	from = iommu->ir_table->base;
+	memcpy(to + start, from + start, size);
+
+	return 0;
+}
+#endif /* CONFIG_CRASH_DUMP */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 8e29b97..76c6ea5 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -290,6 +290,10 @@ struct q_inval {
 struct ir_table {
 	struct irte *base;
 	unsigned long *bitmap;
+#ifdef CONFIG_CRASH_DUMP
+	void __iomem *base_old_virt;
+	unsigned long base_old_phys;
+#endif
 };
 #endif
 
-- 
2.0.0-rc0

