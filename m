Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbaGXNBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:01:54 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56554 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127AbaGXNBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:01:52 -0400
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
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 06/19] ARM64 / ACPI: Parse FADT table to get PSCI flags for PSCI init
Date: Thu, 24 Jul 2014 21:00:12 +0800
Message-Id: <1406206825-15590-7-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two flags: PSCI_COMPLIANT and PSCI_USE_HVC. When set,
the former signals to the OS that the hardware is PSCI compliant.
The latter selects the appropriate conduit for PSCI calls by
toggling between Hypervisor Calls (HVC) and Secure Monitor Calls
(SMC).

FADT table contains such information, parse FADT to get the flags
for PSCI init. Since ACPI 5.1 doesn't support self defined PSCI
function IDs, which means that only PSCI 0.2+ is supported in ACPI.

At the same time, only ACPI 5.1 or higher verison supports PSCI,
and FADT Major.Minor version was introduced in ACPI 5.1, so we
will check the version and only parse FADT table with version >= 5.1.

If firmware provides ACPI tables with ACPI version less than 5.1,
OS will be messed up with those information and have no way to
bring up secondery CPUs, so disable ACPI if we get an FADT table
with version less that 5.1.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
---
 arch/arm64/include/asm/acpi.h |    2 +
 arch/arm64/kernel/acpi.c      |   50 ++++++++++++++++++++++
 arch/arm64/kernel/psci.c      |   95 +++++++++++++++++++++++++++++------------
 arch/arm64/kernel/setup.c     |    2 +
 4 files changed, 121 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 44b617f..67dac90 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -18,6 +18,8 @@ extern int acpi_disabled;
 extern int acpi_noirq;
 extern int acpi_pci_disabled;
 extern int acpi_strict;
+extern int acpi_psci_present;
+extern int acpi_psci_use_hvc;
 
 static inline void disable_acpi(void)
 {
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index f5a10b5..374926f 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -11,6 +11,8 @@
  *  published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) "ACPI: " fmt
+
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/cpumask.h>
@@ -34,6 +36,12 @@ EXPORT_SYMBOL(acpi_disabled);
 int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
 EXPORT_SYMBOL(acpi_pci_disabled);
 
+/* 1 to indicate PSCI is implemented */
+int acpi_psci_present;
+
+/* 1 to indicate HVC must be used instead of SMC as the PSCI conduit */
+int acpi_psci_use_hvc;
+
 /*
  * __acpi_map_table() will be called before page_init(), so early_ioremap()
  * or early_memremap() should be called here to for ACPI table mapping.
@@ -54,6 +62,33 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
 	early_iounmap(map, size);
 }
 
+static int __init acpi_parse_fadt(struct acpi_table_header *table)
+{
+	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
+
+	/*
+	 * Revision in table header is the FADT Major version,
+	 * and there is a minor version of FADT which was introduced
+	 * by ACPI 5.1, we only deal with ACPI 5.1 or higher version
+	 * to get arm boot flags, or we will disable ACPI.
+	 */
+	if (table->revision < 5 || fadt->minor_version < 1) {
+		pr_info("FADT version is %d.%d, no PSCI support, should be 5.1 or higher\n",
+			table->revision, fadt->minor_version);
+		acpi_psci_present = 0;
+		disable_acpi();
+		return -EINVAL;
+	}
+
+	if (acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT)
+		acpi_psci_present = 1;
+
+	if (acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
+		acpi_psci_use_hvc = 1;
+
+	return 0;
+}
+
 /*
  * acpi_boot_table_init() called from setup_arch(), always.
  *	1. find RSDP and get its address, and then find XSDT
@@ -75,6 +110,21 @@ void __init acpi_boot_table_init(void)
 	}
 }
 
+int __init acpi_boot_init(void)
+{
+	int err = 0;
+
+	/* If acpi_disabled, bail out */
+	if (acpi_disabled)
+		return -ENODEV;
+
+	err = acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt);
+	if (err)
+		pr_err("Can't find FADT\n");
+
+	return err;
+}
+
 static int __init parse_acpi(char *arg)
 {
 	if (!arg)
diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
index 9e9798f..adb25f3 100644
--- a/arch/arm64/kernel/psci.c
+++ b/arch/arm64/kernel/psci.c
@@ -15,6 +15,7 @@
 
 #define pr_fmt(fmt) "psci: " fmt
 
+#include <linux/acpi.h>
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/smp.h>
@@ -231,6 +232,33 @@ static void psci_sys_poweroff(void)
 	invoke_psci_fn(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
 }
 
+static void psci_0_2_set_functions(void)
+{
+	pr_info("Using standard PSCI v0.2 function IDs\n");
+	psci_function_id[PSCI_FN_CPU_SUSPEND] = PSCI_0_2_FN64_CPU_SUSPEND;
+	psci_ops.cpu_suspend = psci_cpu_suspend;
+
+	psci_function_id[PSCI_FN_CPU_OFF] = PSCI_0_2_FN_CPU_OFF;
+	psci_ops.cpu_off = psci_cpu_off;
+
+	psci_function_id[PSCI_FN_CPU_ON] = PSCI_0_2_FN64_CPU_ON;
+	psci_ops.cpu_on = psci_cpu_on;
+
+	psci_function_id[PSCI_FN_MIGRATE] = PSCI_0_2_FN64_MIGRATE;
+	psci_ops.migrate = psci_migrate;
+
+	psci_function_id[PSCI_FN_AFFINITY_INFO] = PSCI_0_2_FN64_AFFINITY_INFO;
+	psci_ops.affinity_info = psci_affinity_info;
+
+	psci_function_id[PSCI_FN_MIGRATE_INFO_TYPE] =
+		PSCI_0_2_FN_MIGRATE_INFO_TYPE;
+	psci_ops.migrate_info_type = psci_migrate_info_type;
+
+	arm_pm_restart = psci_sys_reset;
+
+	pm_power_off = psci_sys_poweroff;
+}
+
 /*
  * PSCI Function IDs for v0.2+ are well defined so use
  * standard values.
@@ -264,29 +292,7 @@ static int psci_0_2_init(struct device_node *np)
 		}
 	}
 
-	pr_info("Using standard PSCI v0.2 function IDs\n");
-	psci_function_id[PSCI_FN_CPU_SUSPEND] = PSCI_0_2_FN64_CPU_SUSPEND;
-	psci_ops.cpu_suspend = psci_cpu_suspend;
-
-	psci_function_id[PSCI_FN_CPU_OFF] = PSCI_0_2_FN_CPU_OFF;
-	psci_ops.cpu_off = psci_cpu_off;
-
-	psci_function_id[PSCI_FN_CPU_ON] = PSCI_0_2_FN64_CPU_ON;
-	psci_ops.cpu_on = psci_cpu_on;
-
-	psci_function_id[PSCI_FN_MIGRATE] = PSCI_0_2_FN64_MIGRATE;
-	psci_ops.migrate = psci_migrate;
-
-	psci_function_id[PSCI_FN_AFFINITY_INFO] = PSCI_0_2_FN64_AFFINITY_INFO;
-	psci_ops.affinity_info = psci_affinity_info;
-
-	psci_function_id[PSCI_FN_MIGRATE_INFO_TYPE] =
-		PSCI_0_2_FN_MIGRATE_INFO_TYPE;
-	psci_ops.migrate_info_type = psci_migrate_info_type;
-
-	arm_pm_restart = psci_sys_reset;
-
-	pm_power_off = psci_sys_poweroff;
+	psci_0_2_set_functions();
 
 out_put_node:
 	of_node_put(np);
@@ -333,6 +339,33 @@ out_put_node:
 	return err;
 }
 
+#ifdef CONFIG_ACPI
+static int get_set_conduit_method_acpi(void)
+{
+	if (acpi_psci_use_hvc)
+		invoke_psci_fn = __invoke_psci_fn_hvc;
+	else
+		invoke_psci_fn = __invoke_psci_fn_smc;
+
+	return 0;
+}
+
+/* We use PSCI 0.2+ when ACPI is deployed */
+static int psci_0_2_init_acpi(void)
+{
+	get_set_conduit_method_acpi();
+
+	psci_0_2_set_functions();
+
+	return 0;
+}
+#else
+static inline int psci_0_2_init_acpi(void)
+{
+	return -ENODEV;
+}
+#endif
+
 static const struct of_device_id psci_of_match[] __initconst = {
 	{ .compatible = "arm,psci",	.data = psci_0_1_init},
 	{ .compatible = "arm,psci-0.2",	.data = psci_0_2_init},
@@ -345,13 +378,19 @@ int __init psci_init(void)
 	const struct of_device_id *matched_np;
 	psci_initcall_t init_fn;
 
-	np = of_find_matching_node_and_match(NULL, psci_of_match, &matched_np);
+	if (acpi_disabled) {
+		np = of_find_matching_node_and_match(NULL,
+				psci_of_match, &matched_np);
 
-	if (!np)
-		return -ENODEV;
+		if (!np)
+			return -ENODEV;
+
+		init_fn = (psci_initcall_t)matched_np->data;
+
+		return init_fn(np);
+	}
 
-	init_fn = (psci_initcall_t)matched_np->data;
-	return init_fn(np);
+	return psci_0_2_init_acpi();
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 9dedb0b..e00d40c 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -394,6 +394,8 @@ void __init setup_arch(char **cmdline_p)
 
 	efi_idmap_init();
 
+	acpi_boot_init();
+
 	unflatten_device_tree();
 
 	psci_init();
-- 
1.7.9.5

