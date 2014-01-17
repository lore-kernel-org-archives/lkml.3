Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaAQMoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:44:10 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51446 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaAQMoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:44:08 -0500
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
Subject: [PATCH 10/20] ARM64 / ACPI: Enumerate possible/present CPU set and map logical cpu id to APIC id
Date: Fri, 17 Jan 2014 20:25:04 +0800
Message-Id: <1389961514-13562-11-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When boot the kernel with MADT, the cpu possible and present sets should
be enumerated for later smp initialization.

The logic cpu id maps to APIC id (GIC id) is also implemented, it is
needed for acpi processor drivers.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h |    7 ++--
 drivers/acpi/plat/arm-core.c  |   83 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index c335c6d..7edd39e 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -76,9 +76,6 @@ static inline void acpi_disable_pci(void)
 /* FIXME: this function should be moved to topology.h when it's ready */
 void arch_fix_phys_package_id(int num, u32 slot);
 
-/* temperally define -1 to make acpi core compilerable */
-#define cpu_physical_id(cpu) -1
-
 /* Low-level suspend routine. */
 extern int (*acpi_suspend_lowlevel)(void);
 #define acpi_wakeup_address (0)
@@ -86,6 +83,10 @@ extern int (*acpi_suspend_lowlevel)(void);
 #define MAX_GIC_CPU_INTERFACE 256
 #define MAX_GIC_DISTRIBUTOR   1		/* should be the same as MAX_GIC_NR */
 
+/* map logic cpu id to physical GIC id */
+extern int arm_cpu_to_apicid[NR_CPUS];
+#define cpu_physical_id(cpu) arm_cpu_to_apicid[cpu]
+
 #else	/* !CONFIG_ACPI */
 #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
 #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 8ba3e6f..1d9b789 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -31,6 +31,7 @@
 #include <linux/smp.h>
 
 #include <asm/pgtable.h>
+#include <asm/cputype.h>
 
 /*
  * We never plan to use RSDT on arm/arm64 as its deprecated in spec but this
@@ -52,6 +53,13 @@ EXPORT_SYMBOL(acpi_pci_disabled);
  */
 static u64 acpi_lapic_addr __initdata;
 
+/* available_cpus here means enabled cpu in MADT */
+static int available_cpus;
+
+/* Map logic cpu id to physical GIC id (physical CPU id). */
+int arm_cpu_to_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = -1 };
+static int boot_cpu_apic_id = -1;
+
 #define BAD_MADT_ENTRY(entry, end) (					\
 	(!entry) || (unsigned long)entry + sizeof(*entry) > end ||	\
 	((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
@@ -132,6 +140,55 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
  * Please refer to chapter5.2.12.14/15 of ACPI 5.0
  */
 
+/**
+ * acpi_register_gic_cpu_interface - register a gic cpu interface and
+ * generates a logic cpu number
+ * @id: gic cpu interface id to register
+ * @enabled: this cpu is enabled or not
+ *
+ * Returns the logic cpu number which maps to the gic cpu interface
+ */
+static int acpi_register_gic_cpu_interface(int id, u8 enabled)
+{
+	int cpu;
+
+	if (id >= MAX_GIC_CPU_INTERFACE) {
+		pr_info(PREFIX "skipped apicid that is too big\n");
+		return -EINVAL;
+	}
+
+	total_cpus++;
+	if (!enabled)
+		return -EINVAL;
+
+	if (available_cpus >=  NR_CPUS) {
+		pr_warn(PREFIX "NR_CPUS limit of %d reached,"
+		" Processor %d/0x%x ignored.\n", NR_CPUS, total_cpus, id);
+		return -EINVAL;
+	}
+
+	available_cpus++;
+
+	/* allocate a logic cpu id for the new comer */
+	if (boot_cpu_apic_id == id) {
+		/*
+		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
+		 * for BSP, no need to allocte again.
+		 */
+		cpu = 0;
+	} else {
+		cpu = cpumask_next_zero(-1, cpu_present_mask);
+	}
+
+	/* map the logic cpu id to APIC id */
+	arm_cpu_to_apicid[cpu] = id;
+
+	set_cpu_present(cpu, true);
+	set_cpu_possible(cpu, true);
+
+	return cpu;
+}
+
 static int __init
 acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
 {
@@ -144,6 +201,16 @@ acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
 
 	acpi_table_print_madt_entry(header);
 
+	/*
+	 * We need to register disabled CPU as well to permit
+	 * counting disabled CPUs. This allows us to size
+	 * cpus_possible_map more accurately, to permit
+	 * to not preallocating memory for all NR_CPUS
+	 * when we use CPU hotplug.
+	 */
+	acpi_register_gic_cpu_interface(processor->gic_id,
+			processor->flags & ACPI_MADT_ENABLED);
+
 	return 0;
 }
 
@@ -186,6 +253,19 @@ static int __init acpi_parse_madt_gic_entries(void)
 		return count;
 	}
 
+#ifdef CONFIG_SMP
+	if (available_cpus == 0) {
+		pr_info(PREFIX "Found 0 CPUs; assuming 1\n");
+		arm_cpu_to_apicid[available_cpus] =
+			read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
+		available_cpus = 1;	/* We've got at least one of these */
+	}
+#endif
+
+	/* Make boot-up look pretty */
+	pr_info("%d CPUs available, %d CPUs total\n", available_cpus,
+		total_cpus);
+
 	return 0;
 }
 
@@ -321,6 +401,9 @@ int __init early_acpi_boot_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
+	/* Get the boot CPU's GIC cpu interface id before MADT parsing */
+	boot_cpu_apic_id = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
+
 	/*
 	 * Process the Multiple APIC Description Table (MADT), if present
 	 */
-- 
1.7.9.5

