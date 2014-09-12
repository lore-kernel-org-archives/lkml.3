Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaILOE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:04:27 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36760 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbaILOBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:01:31 -0400
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
        Hanjun Guo <hanjun.guo@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v4 09/18] ARM64 / ACPI: Parse FADT table to get PSCI flags for PSCI init
Date: Fri, 12 Sep 2014 22:00:07 +0800
Message-Id: <1410530416-30200-10-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two flags: PSCI_COMPLIANT and PSCI_USE_HVC. When set,
the former signals to the OS that the firmware is PSCI compliant.
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
OS will be messed up with those information and have no way to init
smp and GIC, so disable ACPI if we get an FADT table with version
less that 5.1.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/arm64/include/asm/acpi.h |   17 +++++++++
 arch/arm64/include/asm/psci.h |    3 +-
 arch/arm64/kernel/acpi.c      |   31 +++++++++++++++-
 arch/arm64/kernel/psci.c      |   78 ++++++++++++++++++++++++++++-------------
 arch/arm64/kernel/setup.c     |    8 +++--
 5 files changed, 108 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 8b837ab..ecba671 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -19,6 +19,18 @@ extern int acpi_disabled;
 extern int acpi_noirq;
 extern int acpi_pci_disabled;
 
+/* 1 to indicate PSCI 0.2+ is implemented */
+static inline bool acpi_psci_present(void)
+{
+	return acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT;
+}
+
+/* 1 to indicate HVC must be used instead of SMC as the PSCI conduit */
+static inline bool acpi_psci_use_hvc(void)
+{
+	return acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_USE_HVC;
+}
+
 static inline void disable_acpi(void)
 {
 	acpi_disabled = 1;
@@ -40,6 +52,11 @@ static inline bool acpi_has_cpu_in_madt(void)
 
 static inline void arch_fix_phys_package_id(int num, u32 slot) { }
 
+#else
+
+static inline bool acpi_psci_present(void) { return false; }
+static inline bool acpi_psci_use_hvc(void) { return false; }
+
 #endif /* CONFIG_ACPI */
 
 #endif /*_ASM_ACPI_H*/
diff --git a/arch/arm64/include/asm/psci.h b/arch/arm64/include/asm/psci.h
index e5312ea..2454bc5 100644
--- a/arch/arm64/include/asm/psci.h
+++ b/arch/arm64/include/asm/psci.h
@@ -14,6 +14,7 @@
 #ifndef __ASM_PSCI_H
 #define __ASM_PSCI_H
 
-int psci_init(void);
+int psci_dt_init(void);
+int psci_acpi_init(void);
 
 #endif /* __ASM_PSCI_H */
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 693da7f..9e1ae37 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -13,6 +13,8 @@
  *  published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) "ACPI: " fmt
+
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/cpumask.h>
@@ -49,10 +51,32 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
 	early_memunmap(map, size);
 }
 
+static int __init acpi_parse_fadt(struct acpi_table_header *table)
+{
+	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
+
+	/*
+	 * Revision in table header is the FADT Major revision,
+	 * and there is a minor revision of FADT which was introduced
+	 * by ACPI 5.1, we only deal with ACPI 5.1 or higher revision
+	 * to get arm boot flags, or we will disable ACPI.
+	 */
+	if (table->revision > 5 ||
+	    (table->revision == 5 && fadt->minor_revision >= 1))
+		return 0;
+
+	pr_warn("Unsupported FADT revision %d.%d, should be 5.1+, will disable ACPI\n",
+		table->revision, fadt->minor_revision);
+	disable_acpi();
+
+	return -EINVAL;
+}
+
 /*
  * acpi_boot_table_init() called from setup_arch(), always.
  *	1. find RSDP and get its address, and then find XSDT
  *	2. extract all tables and checksums them all
+ *	3. check ACPI FADT revisoin
  *
  * We can parse ACPI boot-time tables such as MADT after
  * this function is called.
@@ -64,8 +88,13 @@ void __init acpi_boot_table_init(void)
 		return;
 
 	/* Initialize the ACPI boot-time table parser. */
-	if (acpi_table_init())
+	if (acpi_table_init()) {
 		disable_acpi();
+		return;
+	}
+
+	if (acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt))
+		pr_err("Can't find FADT or error happened during parsing FADT\n");
 }
 
 static int __init parse_acpi(char *arg)
diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
index 5539547..15ba470 100644
--- a/arch/arm64/kernel/psci.c
+++ b/arch/arm64/kernel/psci.c
@@ -15,6 +15,7 @@
 
 #define pr_fmt(fmt) "psci: " fmt
 
+#include <linux/acpi.h>
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/smp.h>
@@ -23,6 +24,7 @@
 #include <linux/delay.h>
 #include <uapi/linux/psci.h>
 
+#include <asm/acpi.h>
 #include <asm/compiler.h>
 #include <asm/cpu_ops.h>
 #include <asm/errno.h>
@@ -231,6 +233,33 @@ static void psci_sys_poweroff(void)
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
@@ -264,29 +293,7 @@ static int __init psci_0_2_init(struct device_node *np)
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
@@ -339,7 +346,7 @@ static const struct of_device_id psci_of_match[] __initconst = {
 	{},
 };
 
-int __init psci_init(void)
+int __init psci_dt_init(void)
 {
 	struct device_node *np;
 	const struct of_device_id *matched_np;
@@ -354,6 +361,29 @@ int __init psci_init(void)
 	return init_fn(np);
 }
 
+/*
+ * We use PSCI 0.2+ when ACPI is deployed on ARM64 and it's
+ * explicitly clarified in SBBR
+ */
+int __init psci_acpi_init(void)
+{
+	if (!acpi_psci_present()) {
+		pr_info("is not implemented in ACPI.\n");
+		return -EOPNOTSUPP;
+	}
+
+	pr_info("probing for conduit method from ACPI.\n");
+
+	if (acpi_psci_use_hvc())
+		invoke_psci_fn = __invoke_psci_fn_hvc;
+	else
+		invoke_psci_fn = __invoke_psci_fn_smc;
+
+	psci_0_2_set_functions();
+
+	return 0;
+}
+
 #ifdef CONFIG_SMP
 
 static int __init cpu_psci_cpu_init(struct device_node *dn, unsigned int cpu)
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 5796734..7ba20d4 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -398,10 +398,12 @@ void __init setup_arch(char **cmdline_p)
 	efi_idmap_init();
 
 	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
-	if (acpi_disabled)
+	if (acpi_disabled) {
 		unflatten_device_tree();
-
-	psci_init();
+		psci_dt_init();
+	} else {
+		psci_acpi_init();
+	}
 
 	cpu_read_bootcpu_ops();
 #ifdef CONFIG_SMP
-- 
1.7.9.5

