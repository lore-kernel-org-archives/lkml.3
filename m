Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbaGXNCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:02:11 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56439 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169AbaGXNCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:02:08 -0400
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
        Hanjun Guo <hanjun.guo@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 07/19] ARM64 / ACPI: Parse MADT to map logical cpu to MPIDR and get cpu_possible/present_map
Date: Thu, 24 Jul 2014 21:00:13 +0800
Message-Id: <1406206825-15590-8-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADT contains the information for MPIDR which is essential for
SMP initialization, parse the GIC cpu interface structures to
get the MPIDR value and map it to cpu_logical_map(), and add
enabled cpu with valid MPIDR into cpu_possible_map and
cpu_present_map.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/arm64/include/asm/acpi.h |    2 +
 arch/arm64/kernel/acpi.c      |  127 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/smp.c       |   10 +++-
 3 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 67dac90..5ce85f8 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -50,6 +50,8 @@ static inline bool acpi_has_cpu_in_madt(void)
 extern int (*acpi_suspend_lowlevel)(void);
 #define acpi_wakeup_address 0
 
+#define MAX_GIC_CPU_INTERFACE 65535
+
 #endif /* CONFIG_ACPI */
 
 #endif /*_ASM_ACPI_H*/
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 374926f..801e268 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -22,6 +22,9 @@
 #include <linux/bootmem.h>
 #include <linux/smp.h>
 
+#include <asm/smp_plat.h>
+#include <asm/cputype.h>
+
 /*
  * We never plan to use RSDT on arm/arm64 as its deprecated in spec but this
  * variable is still required by the ACPI core
@@ -42,6 +45,9 @@ int acpi_psci_present;
 /* 1 to indicate HVC must be used instead of SMC as the PSCI conduit */
 int acpi_psci_use_hvc;
 
+/* Processors (GICC) with enabled flag in MADT */
+static int enabled_cpus;
+
 /*
  * __acpi_map_table() will be called before page_init(), so early_ioremap()
  * or early_memremap() should be called here to for ACPI table mapping.
@@ -62,6 +68,122 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
 	early_iounmap(map, size);
 }
 
+/**
+ * acpi_register_gic_cpu_interface - register a gic cpu interface and
+ * generates a logic cpu number
+ * @mpidr: CPU's hardware id to register, MPIDR represented in MADT
+ * @enabled: this cpu is enabled or not
+ *
+ * Returns the logic cpu number which maps to the gic cpu interface
+ */
+static int acpi_register_gic_cpu_interface(u64 mpidr, u8 enabled)
+{
+	int cpu;
+
+	if (mpidr == INVALID_HWID) {
+		pr_info("Skip invalid cpu hardware ID\n");
+		return -EINVAL;
+	}
+
+	total_cpus++;
+	if (!enabled)
+		return -EINVAL;
+
+	if (enabled_cpus >=  NR_CPUS) {
+		pr_warn("NR_CPUS limit of %d reached, Processor %d/0x%llx ignored.\n",
+			NR_CPUS, total_cpus, mpidr);
+		return -EINVAL;
+	}
+
+	/* If it is the first CPU, no need to check duplicate MPIDRs */
+	if (!enabled_cpus)
+		goto skip_mpidr_check;
+
+	/*
+	 * Duplicate MPIDRs are a recipe for disaster. Scan
+	 * all initialized entries and check for
+	 * duplicates. If any is found just ignore the CPU.
+	 */
+	for_each_present_cpu(cpu) {
+		if (cpu_logical_map(cpu) == mpidr) {
+			pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
+			       mpidr);
+			return -EINVAL;
+		}
+	}
+
+skip_mpidr_check:
+	enabled_cpus++;
+
+	/* allocate a logic cpu id for the new comer */
+	if (cpu_logical_map(0) == mpidr) {
+		/*
+		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
+		 * for BSP, no need to allocte again.
+		 */
+		cpu = 0;
+	} else {
+		cpu = cpumask_next_zero(-1, cpu_present_mask);
+	}
+
+	/* map the logic cpu id to cpu MPIDR */
+	cpu_logical_map(cpu) = mpidr;
+
+	set_cpu_possible(cpu, true);
+	set_cpu_present(cpu, true);
+
+	return cpu;
+}
+
+static int __init
+acpi_parse_gic_cpu_interface(struct acpi_subtable_header *header,
+				const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *processor;
+
+	processor = (struct acpi_madt_generic_interrupt *)header;
+
+	if (BAD_MADT_ENTRY(processor, end))
+		return -EINVAL;
+
+	acpi_table_print_madt_entry(header);
+
+	acpi_register_gic_cpu_interface(processor->mpidr,
+		processor->flags & ACPI_MADT_ENABLED);
+
+	return 0;
+}
+
+/*
+ * Parse GIC cpu interface related entries in MADT
+ * returns 0 on success, < 0 on error
+ */
+static int __init acpi_parse_madt_gic_cpu_interface_entries(void)
+{
+	int count;
+
+	/*
+	 * do a partial walk of MADT to determine how many CPUs
+	 * we have including disabled CPUs, and get information
+	 * we need for SMP init
+	 */
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+			acpi_parse_gic_cpu_interface, MAX_GIC_CPU_INTERFACE);
+
+	if (!count) {
+		pr_err("No GIC CPU interface entries present\n");
+		return -ENODEV;
+	} else if (count < 0) {
+		pr_err("Error parsing GIC CPU interface entry\n");
+		return count;
+	}
+
+	/* Make boot-up look pretty */
+	pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
+
+	return 0;
+}
+
 static int __init acpi_parse_fadt(struct acpi_table_header *table)
 {
 	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
@@ -122,6 +244,11 @@ int __init acpi_boot_init(void)
 	if (err)
 		pr_err("Can't find FADT\n");
 
+	/* Get the boot CPU's MPIDR before MADT parsing */
+	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
+
+	err = acpi_parse_madt_gic_cpu_interface_entries();
+
 	return err;
 }
 
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 40f38f4..8f1d37c 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -36,6 +36,7 @@
 #include <linux/completion.h>
 #include <linux/of.h>
 #include <linux/irq_work.h>
+#include <linux/acpi.h>
 
 #include <asm/atomic.h>
 #include <asm/cacheflush.h>
@@ -458,7 +459,14 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		if (err)
 			continue;
 
-		set_cpu_present(cpu, true);
+		/*
+		 * In ACPI mode, cpu_present_map was initialised when
+		 * MADT table was parsed which before this function
+		 * is called.
+		 */
+		if (acpi_disabled)
+			set_cpu_present(cpu, true);
+
 		max_cpus--;
 	}
 }
-- 
1.7.9.5

