Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaFYAIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:08:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41370 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaFYAGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:06:31 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [RFC/PATCH 11/12] cpufreq: Add module to register cpufreq-krait device
Date: Tue, 24 Jun 2014 17:06:22 -0700
Message-Id: <1403654783-7176-12-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a cpufreq-krait device whenever we detect that a
"qcom,krait" compatible CPU is present in DT.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/cpufreq/Kconfig.arm    |  8 +++++++
 drivers/cpufreq/Makefile       |  1 +
 drivers/cpufreq/qcom-cpufreq.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)
 create mode 100644 drivers/cpufreq/qcom-cpufreq.c

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index ebac67115009..cbc5643b3ecf 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -128,6 +128,14 @@ config ARM_OMAP2PLUS_CPUFREQ
 	depends on ARCH_OMAP2PLUS
 	default ARCH_OMAP2PLUS
 
+config ARM_QCOM_CPUFREQ
+	tristate "Qualcomm based"
+	depends on ARCH_QCOM
+	help
+	  This adds the CPUFreq driver for Qualcomm SoC based boards.
+
+	  If in doubt, say N.
+
 config ARM_S3C_CPUFREQ
 	bool
 	help
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index f5c9f68dcc0f..6b8917ba4b6e 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 obj-$(CONFIG_ARM_INTEGRATOR)		+= integrator-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
+obj-$(CONFIG_ARM_QCOM_CPUFREQ)		+= qcom-cpufreq.o
 obj-$(CONFIG_PXA25x)			+= pxa2xx-cpufreq.o
 obj-$(CONFIG_PXA27x)			+= pxa2xx-cpufreq.o
 obj-$(CONFIG_PXA3xx)			+= pxa3xx-cpufreq.o
diff --git a/drivers/cpufreq/qcom-cpufreq.c b/drivers/cpufreq/qcom-cpufreq.c
new file mode 100644
index 000000000000..71f4387734d0
--- /dev/null
+++ b/drivers/cpufreq/qcom-cpufreq.c
@@ -0,0 +1,48 @@
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
+
+static int qcom_cpufreq_driver_init(void)
+{
+	struct platform_device_info devinfo = { .name = "cpufreq-krait", };
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

