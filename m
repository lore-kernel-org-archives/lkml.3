Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaAQMpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:45:45 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48690 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaAQMpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:45:43 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Charles.Garcia-Tobin@arm.com, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 11/20] ARM64 / ACPI: Get the enable method for SMP initialization
Date: Fri, 17 Jan 2014 20:25:05 +0800
Message-Id: <1389961514-13562-12-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI has no flag to indicate different enable methods for SMP
initialization, but it indicates that spin-table is supported
at now because of the Parked Protocol shows that there is
parked address in GIC structure.

In order to boot the system with ACPI if DT is not available,
we set the default enable method as spin-table since PSCI is
not available in ACPI spec at now.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h    |    8 ++++++++
 arch/arm64/include/asm/cpu_ops.h |    1 +
 arch/arm64/include/asm/smp.h     |    2 +-
 arch/arm64/kernel/cpu_ops.c      |    2 +-
 arch/arm64/kernel/smp.c          |   42 ++++++++++++++++++++++++++++++++++++--
 drivers/acpi/plat/arm-core.c     |   26 +++++++++++++++++++++++
 6 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 7edd39e..097394c 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -87,11 +87,19 @@ extern int (*acpi_suspend_lowlevel)(void);
 extern int arm_cpu_to_apicid[NR_CPUS];
 #define cpu_physical_id(cpu) arm_cpu_to_apicid[cpu]
 
+extern const char *acpi_get_enable_method(int cpu);
+
 #else	/* !CONFIG_ACPI */
 #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
 #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
 #define acpi_pci_disabled 1	/* ACPI PCI sometimes enabled on ARM */
 #define acpi_strict 1		/* no ACPI spec workarounds on ARM */
+
+static inline const char *acpi_get_enable_method(int cpu)
+{
+	return NULL;
+}
+
 #endif
 
 #endif /*_ASM_ARM64_ACPI_H*/
diff --git a/arch/arm64/include/asm/cpu_ops.h b/arch/arm64/include/asm/cpu_ops.h
index c4cdb5e..08c8f07 100644
--- a/arch/arm64/include/asm/cpu_ops.h
+++ b/arch/arm64/include/asm/cpu_ops.h
@@ -53,6 +53,7 @@ struct cpu_operations {
 };
 
 extern const struct cpu_operations *cpu_ops[NR_CPUS];
+extern const struct cpu_operations * __init cpu_get_ops(const char *name);
 extern int __init cpu_read_ops(struct device_node *dn, int cpu);
 extern void __init cpu_read_bootcpu_ops(void);
 
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index a498f2c..a5cea56 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -39,7 +39,7 @@ extern void show_ipi_list(struct seq_file *p, int prec);
 extern void handle_IPI(int ipinr, struct pt_regs *regs);
 
 /*
- * Setup the set of possible CPUs (via set_cpu_possible)
+ * Platform specific SMP operations
  */
 extern void smp_init_cpus(void);
 
diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
index d62d12f..531f2cc 100644
--- a/arch/arm64/kernel/cpu_ops.c
+++ b/arch/arm64/kernel/cpu_ops.c
@@ -35,7 +35,7 @@ static const struct cpu_operations *supported_cpu_ops[] __initconst = {
 	NULL,
 };
 
-static const struct cpu_operations * __init cpu_get_ops(const char *name)
+const struct cpu_operations * __init cpu_get_ops(const char *name)
 {
 	const struct cpu_operations **ops = supported_cpu_ops;
 
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index a0c2ca6..7719d46 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -48,6 +48,7 @@
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 #include <asm/ptrace.h>
+#include <asm/acpi.h>
 
 /*
  * as from 2.5, kernels no longer have an init_tasks structure
@@ -280,7 +281,7 @@ static void (*smp_cross_call)(const struct cpumask *, unsigned int);
  * cpu logical map array containing MPIDR values related to logical
  * cpus. Assumes that cpu_logical_map(0) has already been initialized.
  */
-void __init smp_init_cpus(void)
+static int __init of_smp_init_cpus(void)
 {
 	struct device_node *dn = NULL;
 	unsigned int i, cpu = 1;
@@ -364,6 +365,10 @@ next:
 		cpu++;
 	}
 
+	/* No device tree or no CPU node in DT */
+	if (cpu == 1 && !bootcpu_valid)
+		return -ENODEV;
+
 	/* sanity check */
 	if (cpu > NR_CPUS)
 		pr_warning("no. of cores (%d) greater than configured maximum of %d - clipping\n",
@@ -371,7 +376,7 @@ next:
 
 	if (!bootcpu_valid) {
 		pr_err("DT missing boot CPU MPIDR, not enabling secondaries\n");
-		return;
+		return -EINVAL;
 	}
 
 	/*
@@ -381,6 +386,39 @@ next:
 	for (i = 0; i < NR_CPUS; i++)
 		if (cpu_logical_map(i) != INVALID_HWID)
 			set_cpu_possible(i, true);
+
+	return 0;
+}
+
+/*
+ * In ACPI mode, the cpu possible map was enumerated before SMP
+ * initialization when MADT table was parsed, so we can get the
+ * possible map here to initialize CPUs.
+ */
+static void __init acpi_smp_init_cpus(void)
+{
+	int cpu;
+	const char *enable_method;
+
+	for_each_possible_cpu(cpu) {
+		enable_method = acpi_get_enable_method(cpu);
+		if (!enable_method)
+			continue;
+
+		cpu_ops[cpu] = cpu_get_ops(enable_method);
+		if (!cpu_ops[cpu])
+			continue;
+
+		cpu_ops[cpu]->cpu_init(NULL, cpu);
+	}
+}
+
+void __init smp_init_cpus(void)
+{
+	if (!of_smp_init_cpus())
+		return;
+
+	acpi_smp_init_cpus();
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 1d9b789..2704633 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -367,6 +367,32 @@ static void __init acpi_process_madt(void)
 }
 
 /*
+ * To see PCSI is enabled or not.
+ *
+ * PSCI is not available for ACPI 5.0, return FALSE for now.
+ *
+ * FIXME: should we introduce early_param("psci", func) for test purpose?
+ */
+static bool acpi_psci_smp_available(int cpu)
+{
+	return FALSE;
+}
+
+static const char *enable_method[] = {
+	"psci",
+	"spin-table",
+	NULL
+};
+
+const char *acpi_get_enable_method(int cpu)
+{
+	if (acpi_psci_smp_available(cpu))
+		return enable_method[0];
+	else
+		return enable_method[1];
+}
+
+/*
  * acpi_boot_table_init() and acpi_boot_init()
  *  called from setup_arch(), always.
  *	1. checksums all tables
-- 
1.7.9.5

