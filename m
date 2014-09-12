Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaILOCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:02:07 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64285 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaILOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:01:59 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 14/18] ARM64 / ACPI: Add GICv2 specific ACPI boot support
Date: Fri, 12 Sep 2014 22:00:12 +0800
Message-Id: <1410530416-30200-15-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Nowicki <tomasz.nowicki@linaro.org>

ACPI kernel uses MADT table for proper GIC initialization. It needs to
parse GIC related subtables, collect CPU interface and distributor
addresses and call driver initialization function (which is hardware
abstraction agnostic). In a similar way, FDT initialize GICv1/2.

NOTE: This commit allow to initialize GICv1/2 basic functionality.
GICv2 vitalization extension, GICv3/4 and ITS are considered as next
steps.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/kernel/acpi.c             |   23 ++++++++
 drivers/irqchip/irq-gic.c            |  106 ++++++++++++++++++++++++++++++++++
 drivers/irqchip/irqchip.c            |    3 +
 include/linux/irqchip/arm-gic-acpi.h |   31 ++++++++++
 4 files changed, 163 insertions(+)
 create mode 100644 include/linux/irqchip/arm-gic-acpi.h

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 5b3546b..9869377 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -23,6 +23,7 @@
 #include <linux/irqdomain.h>
 #include <linux/bootmem.h>
 #include <linux/smp.h>
+#include <linux/irqchip/arm-gic-acpi.h>
 
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
@@ -312,6 +313,28 @@ void __init acpi_boot_table_init(void)
 		pr_err("Can't find FADT or error happened during parsing FADT\n");
 }
 
+void __init acpi_gic_init(void)
+{
+	struct acpi_table_header *table;
+	acpi_status status;
+	acpi_size tbl_size;
+	int err;
+
+	status = acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table, &tbl_size);
+	if (ACPI_FAILURE(status)) {
+		const char *msg = acpi_format_exception(status);
+
+		pr_err("Failed to get MADT table, %s\n", msg);
+		return;
+	}
+
+	err = gic_v2_acpi_init(table);
+	if (err)
+		pr_err("Failed to initialize GIC IRQ controller");
+
+	early_acpi_os_unmap_memory((char *)table, tbl_size);
+}
+
 static int __init parse_acpi(char *arg)
 {
 	if (!arg)
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4b959e6..8aba096 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -33,12 +33,14 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/acpi.h>
 #include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/arm-gic-acpi.h>
 
 #include <asm/cputype.h>
 #include <asm/irq.h>
@@ -1029,3 +1031,107 @@ IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
 IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
 
 #endif
+
+#ifdef CONFIG_ACPI
+static phys_addr_t dist_phy_base, cpu_phy_base;
+static int cpu_base_assigned;
+
+static int __init
+gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
+			const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *processor;
+	phys_addr_t gic_cpu_base;
+
+	processor = (struct acpi_madt_generic_interrupt *)header;
+
+	if (BAD_MADT_ENTRY(processor, end))
+		return -EINVAL;
+
+	/*
+	 * There is no support for non-banked GICv1/2 register in ACPI spec.
+	 * All CPU interface addresses have to be the same.
+	 */
+	gic_cpu_base = processor->base_address;
+	if (cpu_base_assigned && gic_cpu_base != cpu_phy_base)
+		return -EFAULT;
+
+	cpu_phy_base = gic_cpu_base;
+	cpu_base_assigned = 1;
+	return 0;
+}
+
+static int __init
+gic_acpi_parse_madt_distributor(struct acpi_subtable_header *header,
+				const unsigned long end)
+{
+	struct acpi_madt_generic_distributor *dist;
+
+	dist = (struct acpi_madt_generic_distributor *)header;
+
+	if (BAD_MADT_ENTRY(dist, end))
+		return -EINVAL;
+
+	dist_phy_base = dist->base_address;
+	return 0;
+}
+
+int __init
+gic_v2_acpi_init(struct acpi_table_header *table)
+{
+	void __iomem *cpu_base, *dist_base;
+	int count;
+
+	/* Collect CPU base addresses */
+	count = acpi_parse_entries(sizeof(struct acpi_table_madt),
+				   gic_acpi_parse_madt_cpu, table,
+				   ACPI_MADT_TYPE_GENERIC_INTERRUPT, 0);
+	if (count < 0) {
+		pr_err("Error during GICC entries parsing\n");
+		return -EFAULT;
+	} else if (!count) {
+		pr_err("No valid GICC entries exist\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Find distributor base address. We expect one distributor entry since
+	 * ACPI 5.1 spec neither support multi-GIC instances nor GIC cascade.
+	 */
+	count = acpi_parse_entries(sizeof(struct acpi_table_madt),
+				   gic_acpi_parse_madt_distributor, table,
+				   ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR, 0);
+	if (count <= 0) {
+		pr_err("Error during GICD entries parsing\n");
+		return -EFAULT;
+	} else if (!count) {
+		pr_err("No valid GICD entries exist\n");
+		return -EINVAL;
+	} else if (count > 1) {
+		pr_err("More than one GICD entry detected\n");
+		return -EINVAL;
+	}
+
+	cpu_base = ioremap(cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
+	if (!cpu_base) {
+		pr_err("Unable to map GICC registers\n");
+		return -ENOMEM;
+	}
+
+	dist_base = ioremap(dist_phy_base, ACPI_GICV2_DIST_MEM_SIZE);
+	if (!dist_base) {
+		pr_err("Unable to map GICD registers\n");
+		iounmap(cpu_base);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Initialize zero GIC instance (no multi-GIC support). Also, set GIC
+	 * as default IRQ domain to allow for GSI registration and GSI to IRQ
+	 * number translation (see acpi_register_gsi() and acpi_gsi_to_irq()).
+	 */
+	gic_init_bases(0, -1, dist_base, cpu_base, 0, NULL);
+	irq_set_default_host(gic_data[0].domain);
+	return 0;
+}
+#endif
diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index 0fe2f71..9106c6d 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/of_irq.h>
 #include <linux/irqchip.h>
+#include <linux/irqchip/arm-gic-acpi.h>
 
 /*
  * This special of_device_id is the sentinel at the end of the
@@ -26,4 +27,6 @@ extern struct of_device_id __irqchip_of_table[];
 void __init irqchip_init(void)
 {
 	of_irq_init(__irqchip_of_table);
+
+	acpi_gic_init();
 }
diff --git a/include/linux/irqchip/arm-gic-acpi.h b/include/linux/irqchip/arm-gic-acpi.h
new file mode 100644
index 0000000..ad5b577
--- /dev/null
+++ b/include/linux/irqchip/arm-gic-acpi.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2014, Linaro Ltd.
+ *	Author: Tomasz Nowicki <tomasz.nowicki@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ARM_GIC_ACPI_H_
+#define ARM_GIC_ACPI_H_
+
+#ifdef CONFIG_ACPI
+
+/*
+ * Hard code here, we can not get memory size from MADT (but FDT does),
+ * Actually no need to do that, because this size can be inferred
+ * from GIC spec.
+ */
+#define ACPI_GICV2_DIST_MEM_SIZE	(SZ_4K)
+#define ACPI_GIC_CPU_IF_MEM_SIZE	(SZ_8K)
+
+struct acpi_table_header;
+
+void acpi_gic_init(void);
+int gic_v2_acpi_init(struct acpi_table_header *table);
+#else
+static inline void acpi_gic_init(void) { }
+#endif
+
+#endif /* ARM_GIC_ACPI_H_ */
-- 
1.7.9.5

