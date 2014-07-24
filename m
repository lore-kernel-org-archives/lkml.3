Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbaGXNDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:03:37 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42777 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645AbaGXNDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:03:32 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 14/19] ARM64 / ACPI: Add GICv2 specific ACPI boot support
Date: Thu, 24 Jul 2014 21:00:20 +0800
Message-Id: <1406206825-15590-15-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Nowicki <tomasz.nowicki@linaro.org>

ACPI kernel uses MADT table for proper GIC initialization. It needs to
parse GIC related subtables, collect CPU interface and distributor
addresses and call driver initialization function (which is hardware
abstraction agnostic). In a similar way, FDT initialize GICv1/2.

NOTE: This commit allow to initialize GICv1/2 only.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h        |    2 -
 arch/arm64/kernel/acpi.c             |   26 +++++++-
 arch/arm64/kernel/irq.c              |    5 ++
 drivers/irqchip/irq-gic.c            |  114 ++++++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-acpi.h |   36 +++++++++++
 5 files changed, 180 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/irqchip/arm-gic-acpi.h

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index f40e137..60497a6 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -85,8 +85,6 @@ static inline bool acpi_has_cpu_in_madt(void)
 extern int (*acpi_suspend_lowlevel)(void);
 #define acpi_wakeup_address 0
 
-#define MAX_GIC_CPU_INTERFACE 65535
-
 #endif /* CONFIG_ACPI */
 
 #endif /*_ASM_ACPI_H*/
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 3a078dc..1f28f1e 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -21,6 +21,7 @@
 #include <linux/irqdomain.h>
 #include <linux/bootmem.h>
 #include <linux/smp.h>
+#include <linux/irqchip/arm-gic-acpi.h>
 
 #include <asm/cputype.h>
 
@@ -173,7 +174,8 @@ static int __init acpi_parse_madt_gic_cpu_interface_entries(void)
 	 * we need for SMP init
 	 */
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
-			acpi_parse_gic_cpu_interface, MAX_GIC_CPU_INTERFACE);
+				      acpi_parse_gic_cpu_interface,
+				      ACPI_GIC_MAX_CPU_INTERFACE);
 
 	if (!count) {
 		pr_err("No GIC CPU interface entries present\n");
@@ -330,6 +332,28 @@ int __init acpi_boot_init(void)
 	return err;
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
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 0f08dfd..c074d60 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -28,6 +28,7 @@
 #include <linux/irqchip.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
+#include <linux/irqchip/arm-gic-acpi.h>
 
 unsigned long irq_err_count;
 
@@ -78,6 +79,10 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 void __init init_IRQ(void)
 {
 	irqchip_init();
+
+	if (!handle_arch_irq)
+		acpi_gic_init();
+
 	if (!handle_arch_irq)
 		panic("No interrupt controller found.");
 }
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 7c131cf..25860f0 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -35,12 +35,14 @@
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
@@ -1082,3 +1084,115 @@ IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
 IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
 
 #endif
+
+#ifdef CONFIG_ACPI
+static u64 dist_phy_base, cpu_phy_base = ULONG_MAX;
+
+static int __init
+gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
+			const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *processor;
+	u64 gic_cpu_base;
+
+	processor = (struct acpi_madt_generic_interrupt *)header;
+
+	if (BAD_MADT_ENTRY(processor, end))
+		return -EINVAL;
+
+	gic_cpu_base = processor->base_address;
+	if (!gic_cpu_base)
+		return -EFAULT;
+
+	/*
+	 * There is no support for non-banked GICv1/2 register in ACPI spec.
+	 * All CPU interface addresses have to be the same.
+	 */
+	if (cpu_phy_base != ULONG_MAX && gic_cpu_base != cpu_phy_base)
+		return -EFAULT;
+
+	cpu_phy_base = gic_cpu_base;
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
+	if (!dist_phy_base)
+		return -EFAULT;
+
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
+				   ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				   ACPI_GIC_MAX_CPU_INTERFACE);
+	if (count < 0) {
+		pr_err("Error during GICC entries parsing\n");
+		return -EFAULT;
+	} else if (!count) {
+		/* No GICC entries provided, use address from MADT header */
+		struct acpi_table_madt *madt = (struct acpi_table_madt *)table;
+
+		if (!madt->address)
+			return -EFAULT;
+
+		cpu_phy_base = (u64)madt->address;
+	}
+
+	/*
+	 * Find distributor base address. We expect one distributor entry since
+	 * ACPI 5.1 spec neither support multi-GIC instances nor GIC cascade.
+	 */
+	count = acpi_parse_entries(sizeof(struct acpi_table_madt),
+				   gic_acpi_parse_madt_distributor, table,
+				   ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+				   ACPI_GIC_MAX_DISTRIBUTOR);
+	if (count <= 0) {
+		pr_err("Error during GICD entries parsing\n");
+		return -EFAULT;
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
+	dist_base = ioremap(dist_phy_base, ACPI_GIC_DIST_MEM_SIZE);
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
diff --git a/include/linux/irqchip/arm-gic-acpi.h b/include/linux/irqchip/arm-gic-acpi.h
new file mode 100644
index 0000000..ffcfeb2
--- /dev/null
+++ b/include/linux/irqchip/arm-gic-acpi.h
@@ -0,0 +1,36 @@
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
+#include <linux/acpi.h>
+
+#ifdef CONFIG_ACPI
+#define ACPI_GIC_MAX_CPU_INTERFACE	65535
+#define ACPI_GIC_MAX_DISTRIBUTOR	1
+
+/*
+ * Hard code here, we can not get memory size from MADT (but FDT does),
+ * Actually no need to do that, because this size can be inferred
+ * from GIC spec.
+ */
+#define ACPI_GIC_DIST_MEM_SIZE		(SZ_64K)
+#define ACPI_GIC_CPU_IF_MEM_SIZE	(SZ_8K)
+
+void acpi_gic_init(void);
+int gic_v2_acpi_init(struct acpi_table_header *table);
+#else
+static inline void acpi_gic_init(void)
+{
+
+}
+#endif
+
+#endif /* ARM_GIC_ACPI_H_ */
-- 
1.7.9.5

