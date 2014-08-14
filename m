Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaHNT62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:58:28 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:36266 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaHNT57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:57:59 -0400
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, mike.turquette@linaro.org,
        morten.rasmussen@arm.com, arjan@linux.intel.com, mingo@kernel.org,
        peterz@infradead.org, len.brown@intel.com, rjw@rjwysocki.ne,
        linaro-acpi@lists.linaro.org, arnd@arndb.de,
        linux-acpi@vger.kernel.org, cpufreq@vger.kernel.org,
        patches@linaro.org, Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [RFC 3/3] CPPC: Add ACPI accessors to CPC registers
Date: Thu, 14 Aug 2014 15:57:10 -0400
Message-Id: <1408046230-16439-4-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the firmware supports CPPC natively in the firmware
then we can use the ACPI defined semantics to access
the CPPC specific registers.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
---
 drivers/cpufreq/Kconfig     |  9 +++++
 drivers/cpufreq/Makefile    |  1 +
 drivers/cpufreq/cppc.h      |  4 +--
 drivers/cpufreq/cppc_acpi.c | 80 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 2 deletions(-)
 create mode 100644 drivers/cpufreq/cppc_acpi.c

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index d8e8335..c5f3c0b 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -206,6 +206,15 @@ config CPPC_CPUFREQ
 	(e.g. BMC) interpret and optimize it for power and performance in a
 	platform specific manner.
 
+config CPPC_ACPI
+	bool "CPPC with ACPI accessors"
+	depends on ACPI && ACPI_PCC
+	default n
+	help
+	This driver implements the low level accessors to the registers as described
+	in the ACPI 5.1 spec. Select this driver if you know your platform supports CPPC
+	and PCC in the firmware.
+
 menu "x86 CPU frequency scaling drivers"
 depends on X86
 source "drivers/cpufreq/Kconfig.x86"
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index b392c8c..d49a999 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
 
 obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
 obj-$(CONFIG_CPPC_CPUFREQ)	+= cppc.o
+obj-$(CONFIG_CPPC_ACPI)	+= cppc_acpi.o
 
 ##################################################################################
 # x86 drivers.
diff --git a/drivers/cpufreq/cppc.h b/drivers/cpufreq/cppc.h
index 3adbd3d..a119c3b 100644
--- a/drivers/cpufreq/cppc.h
+++ b/drivers/cpufreq/cppc.h
@@ -175,7 +175,7 @@ struct cpc_funcs {
 };
 
 extern struct cpc_funcs *cppc_func_ops;
-extern u64 cpc_read64(struct cpc_register_resource *reg);
-extern int cpc_write64(u64 val, struct cpc_register_resource *reg);
+extern u64 cpc_read64(struct cpc_register_resource *reg, void __iomem *base_addr);
+extern int cpc_write64(u64 val, struct cpc_register_resource *reg, void __iomem *base_addr);
 
 #endif /* _CPPC_H */
diff --git a/drivers/cpufreq/cppc_acpi.c b/drivers/cpufreq/cppc_acpi.c
new file mode 100644
index 0000000..1835fe7
--- /dev/null
+++ b/drivers/cpufreq/cppc_acpi.c
@@ -0,0 +1,80 @@
+/*
+ *	Copyright (C) 2014 Linaro Ltd.
+ *	Author:	Ashwin Chaugule <ashwin.chaugule@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <linux/acpi.h>
+
+#include "cppc.h"
+
+static u32 acpi_get_highest_perf(struct cpudata *cpu)
+{
+	struct cpc_register_resource *high_perf = &cpu->cpc_desc->cpc_regs[HIGHEST_PERF];
+
+	return cpc_read64(high_perf, cpu->pcc_comm_address);
+}
+
+static u64 acpi_get_ref_perf_ctr(struct cpudata *cpu)
+{
+	struct cpc_register_resource *ref_perf = &cpu->cpc_desc->cpc_regs[REFERENCE_CTR];
+	return cpc_read64(ref_perf, cpu->pcc_comm_address);
+}
+
+static u32 acpi_get_lowest_perf(struct cpudata *cpu)
+{
+	struct cpc_register_resource *low_perf = &cpu->cpc_desc->cpc_regs[LOWEST_PERF];
+	return cpc_read64(low_perf, cpu->pcc_comm_address);
+}
+
+static void acpi_set_desired_perf(struct cpudata *cpu, u32 val)
+{
+	struct cpc_register_resource *desired_perf = &cpu->cpc_desc->cpc_regs[DESIRED_PERF];
+	cpc_write64(val, desired_perf, cpu->pcc_comm_address);
+}
+
+static u64 acpi_get_delivered_ctr(struct cpudata *cpu)
+{
+	struct cpc_register_resource *delivered_ctr = &cpu->cpc_desc->cpc_regs[DELIVERED_CTR];
+	return cpc_read64(delivered_ctr, cpu->pcc_comm_address);
+}
+
+struct cpc_funcs acpi_cppc_func_ops = {
+	.pid_policy = {
+		.sample_rate_ms = 10,
+		.deadband = 0,
+		.setpoint = 97,
+		.p_gain_pct = 20,
+		.d_gain_pct = 0,
+		.i_gain_pct = 0,
+	},
+	.get_highest_perf 	=	acpi_get_highest_perf,
+	.get_ref_perf_ctr	=	acpi_get_ref_perf_ctr,
+	.get_lowest_perf	=	acpi_get_lowest_perf,
+	.set_desired_perf	=	acpi_set_desired_perf,
+	.get_delivered_ctr	=	acpi_get_delivered_ctr,
+};
+
+static int __init acpi_cppc_init(void)
+{
+	if (acpi_disabled)
+		return 0;
+
+	cppc_func_ops = &acpi_cppc_func_ops;
+
+	pr_info("Registered ACPI CPPC function ops\n");
+
+	return 0;
+}
+early_initcall(acpi_cppc_init);
+
-- 
1.9.1

