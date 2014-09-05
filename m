Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaIEWuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:50:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43571 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaIEWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:44 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 14/15] cpufreq: Add module to register cpufreq on Krait CPUs
Date: Fri,  5 Sep 2014 15:47:34 -0700
Message-Id: <1409957256-23729-16-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a cpufreq-generic device whenever we detect that a
"qcom,krait" compatible CPU is present in DT.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/cpufreq/Kconfig.arm    |   9 ++
 drivers/cpufreq/Makefile       |   1 +
 drivers/cpufreq/qcom-cpufreq.c | 199 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 209 insertions(+)
 create mode 100644 drivers/cpufreq/qcom-cpufreq.c

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index b0b0ca1e9aac..5eb3bbce2f58 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -129,6 +129,15 @@ config ARM_OMAP2PLUS_CPUFREQ
 	depends on ARCH_OMAP2PLUS
 	default ARCH_OMAP2PLUS
 
+config ARM_QCOM_CPUFREQ
+	tristate "Qualcomm based"
+	depends on ARCH_QCOM
+	select PM_OPP
+	help
+	  This adds the CPUFreq driver for Qualcomm SoC based boards.
+
+	  If in doubt, say N.
+
 config ARM_S3C_CPUFREQ
 	bool
 	help
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index e8efe9b8d55f..b345bca5fa09 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 obj-$(CONFIG_ARM_INTEGRATOR)		+= integrator-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
+obj-$(CONFIG_ARM_QCOM_CPUFREQ)		+= qcom-cpufreq.o
 obj-$(CONFIG_PXA25x)			+= pxa2xx-cpufreq.o
 obj-$(CONFIG_PXA27x)			+= pxa2xx-cpufreq.o
 obj-$(CONFIG_PXA3xx)			+= pxa3xx-cpufreq.o
diff --git a/drivers/cpufreq/qcom-cpufreq.c b/drivers/cpufreq/qcom-cpufreq.c
new file mode 100644
index 000000000000..aa8eb97144b6
--- /dev/null
+++ b/drivers/cpufreq/qcom-cpufreq.c
@@ -0,0 +1,199 @@
+/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/cpu.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/pm_opp.h>
+#include <linux/init.h>
+
+static void __init get_krait_bin_format_a(int *speed, int *pvs, int *pvs_ver)
+{
+	void __iomem *base;
+	u32 pte_efuse;
+
+	*speed = *pvs = *pvs_ver = 0;
+
+	base = ioremap(0x007000c0, 4);
+	if (!base) {
+		pr_warn("Unable to read efuse data. Defaulting to 0!\n");
+		return;
+	}
+
+	pte_efuse = readl_relaxed(base);
+	iounmap(base);
+
+	*speed = pte_efuse & 0xf;
+	if (*speed == 0xf)
+		*speed = (pte_efuse >> 4) & 0xf;
+
+	if (*speed == 0xf) {
+		*speed = 0;
+		pr_warn("Speed bin: Defaulting to %d\n", *speed);
+	} else {
+		pr_info("Speed bin: %d\n", *speed);
+	}
+
+	*pvs = (pte_efuse >> 10) & 0x7;
+	if (*pvs == 0x7)
+		*pvs = (pte_efuse >> 13) & 0x7;
+
+	if (*pvs == 0x7) {
+		*pvs = 0;
+		pr_warn("PVS bin: Defaulting to %d\n", *pvs);
+	} else {
+		pr_info("PVS bin: %d\n", *pvs);
+	}
+}
+
+static void __init get_krait_bin_format_b(int *speed, int *pvs, int *pvs_ver)
+{
+	u32 pte_efuse, redundant_sel;
+	void __iomem *base;
+
+	*speed = 0;
+	*pvs = 0;
+	*pvs_ver = 0;
+
+	base = ioremap(0xfc4b80b0, 8);
+	if (!base) {
+		pr_warn("Unable to read efuse data. Defaulting to 0!\n");
+		return;
+	}
+
+	pte_efuse = readl_relaxed(base);
+	redundant_sel = (pte_efuse >> 24) & 0x7;
+	*speed = pte_efuse & 0x7;
+	/* 4 bits of PVS are in efuse register bits 31, 8-6. */
+	*pvs = ((pte_efuse >> 28) & 0x8) | ((pte_efuse >> 6) & 0x7);
+	*pvs_ver = (pte_efuse >> 4) & 0x3;
+
+	switch (redundant_sel) {
+	case 1:
+		*speed = (pte_efuse >> 27) & 0xf;
+		break;
+	case 2:
+		*pvs = (pte_efuse >> 27) & 0xf;
+		break;
+	}
+
+	/* Check SPEED_BIN_BLOW_STATUS */
+	if (pte_efuse & BIT(3)) {
+		pr_info("Speed bin: %d\n", *speed);
+	} else {
+		pr_warn("Speed bin not set. Defaulting to 0!\n");
+		*speed = 0;
+	}
+
+	/* Check PVS_BLOW_STATUS */
+	pte_efuse = readl_relaxed(base + 0x4) & BIT(21);
+	if (pte_efuse) {
+		pr_info("PVS bin: %d\n", *pvs);
+	} else {
+		pr_warn("PVS bin not set. Defaulting to 0!\n");
+		*pvs = 0;
+	}
+
+	pr_info("PVS version: %d\n", *pvs_ver);
+	iounmap(base);
+}
+
+static int __init qcom_cpufreq_populate_opps(void)
+{
+	int len, num_rows, i, k;
+	char table_name[] = "qcom,speedXX-pvsXX-bin-vXX";
+	struct device_node *np;
+	struct device *dev;
+	int cpu = 0;
+	int speed, pvs, pvs_ver;
+	int cols;
+
+	np = of_find_node_by_name(NULL, "qcom,pvs");
+	if (!np)
+		pr_warn("Can't find PVS node\n");
+
+	if (of_property_read_bool(np, "qcom,pvs-format-a")) {
+		get_krait_bin_format_a(&speed, &pvs, &pvs_ver);
+		cols = 2;
+	} else {
+		get_krait_bin_format_b(&speed, &pvs, &pvs_ver);
+		cols = 3;
+	}
+
+	snprintf(table_name, sizeof(table_name),
+			"qcom,speed%d-pvs%d-bin-v%d", speed, pvs, pvs_ver);
+again:
+	dev = get_cpu_device(cpu);
+	if (!dev)
+		return -ENODEV;
+
+	if (!of_find_property(np, table_name, &len))
+		return -EINVAL;
+
+	len /= sizeof(u32);
+	if (len % cols || len == 0)
+		return -EINVAL;
+
+	num_rows = len / cols;
+
+	for (i = 0, k = 0; i < num_rows; i++) {
+		u32 freq, volt;
+
+		of_property_read_u32_index(np, table_name, k++, &freq);
+		of_property_read_u32_index(np, table_name, k++, &volt);
+		while (k % cols)
+			k++; /* Skip uA entries if present */
+		if (dev_pm_opp_add(dev, freq, volt))
+			pr_warn("failed to add OPP %u\n", freq);
+	}
+
+	if (cpu++ < num_possible_cpus())
+		goto again;
+
+	return 0;
+}
+
+static int __init qcom_cpufreq_driver_init(void)
+{
+	struct platform_device_info devinfo = { .name = "cpufreq-generic", };
+	struct device *cpu_dev;
+	struct device_node *np;
+	struct platform_device *pdev;
+
+	cpu_dev = get_cpu_device(0);
+	if (!cpu_dev)
+		return -ENODEV;
+
+	np = of_node_get(cpu_dev->of_node);
+	if (!np)
+		return -ENOENT;
+
+	if (!of_device_is_compatible(np, "qcom,krait")) {
+		of_node_put(np);
+		return -ENODEV;
+	}
+	of_node_put(np);
+
+	qcom_cpufreq_populate_opps();
+	pdev = platform_device_register_full(&devinfo);
+
+	return PTR_ERR_OR_ZERO(pdev);
+}
+module_init(qcom_cpufreq_driver_init);
+
+MODULE_DESCRIPTION("Qualcomm CPUfreq driver");
+MODULE_LICENSE("GPL v2");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

