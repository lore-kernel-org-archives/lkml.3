Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3LCQkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:40:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3LCQkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:40:00 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [RFC part2 PATCH 2/9] ARM64 / ACPI: Prefill cpu possible/present maps and map logical cpu id to APIC id
Date: Wed,  4 Dec 2013 00:39:06 +0800
Message-Id: <1386088753-2850-3-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When boot the kernel with MADT, the cpu possible and present maps should be
prefilled for cpu topology and acpi based cpu hot-plug.

The logic cpu id maps to APIC id (GIC id) is also implemented, it is needed
for acpi processor drivers.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h |   10 ++--
 arch/arm64/kernel/setup.c     |    2 +
 arch/arm64/kernel/smp.c       |    2 +
 drivers/acpi/plat/arm-core.c  |  118 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index be2951c..423a32c 100644
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
@@ -86,6 +83,13 @@ extern int (*acpi_suspend_lowlevel)(void);
 #define MAX_GIC_CPU_INTERFACE 256
 #define MAX_GIC_DISTRIBUTOR   1		/* should be the same as MAX_GIC_NR */
 
+/* map logic cpu id to physical GIC id */
+extern int arm_cpu_to_apicid[NR_CPUS];
+extern int boot_cpu_apic_id;
+#define cpu_physical_id(cpu) arm_cpu_to_apicid[cpu]
+
+extern void prefill_possible_map(void);
+
 #else	/* !CONFIG_ACPI */
 #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
 #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 8199360..08f11e2 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -231,7 +231,9 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_table_init();
 	early_acpi_boot_init();
+	boot_cpu_apic_id = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
 	acpi_boot_init();
+	prefill_possible_map();
 
 	paging_init();
 	request_standard_resources();
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index a0c2ca6..1428024 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -420,7 +420,9 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		if (err)
 			continue;
 
+#ifndef CONFIG_ACPI
 		set_cpu_present(cpu, true);
+#endif
 		max_cpus--;
 	}
 }
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 45ff625..8527ecc 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -58,6 +58,13 @@ EXPORT_SYMBOL(acpi_pci_disabled);
  */
 static u64 acpi_lapic_addr __initdata;
 
+/* available_cpus here means enabled cpu in MADT */
+int available_cpus;
+
+/* Map logic cpu id to physical GIC id. */
+int arm_cpu_to_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = -1 };
+int boot_cpu_apic_id = -1;
+
 #define BAD_MADT_ENTRY(entry, end) (					\
 	(!entry) || (unsigned long)entry + sizeof(*entry) > end ||	\
 	((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
@@ -142,6 +149,39 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
  * Please refer to chapter5.2.12.14/15 of ACPI 5.0
  */
 
+static void acpi_register_gic_cpu_interface(int id, u8 enabled)
+{
+	int cpu;
+
+	if (id >= MAX_GIC_CPU_INTERFACE) {
+		pr_info(PREFIX "skipped apicid that is too big\n");
+		return;
+	}
+
+	total_cpus++;
+	if (!enabled)
+		return;
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
+}
+
 static int __init
 acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
 {
@@ -154,6 +194,16 @@ acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
 
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
 
@@ -196,6 +246,19 @@ static int __init acpi_parse_madt_gic_entries(void)
 		return count;
 	}
 
+#ifdef CONFIG_SMP
+	if (available_cpus == 0) {
+		pr_info(PREFIX "Found 0 CPUs; assuming 1\n");
+		/* FIXME: should be the real GIC id read from hardware */
+		arm_cpu_to_apicid[available_cpus] = 0;
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
 
@@ -221,6 +284,61 @@ static int __init acpi_parse_madt_gic_distributor_entries(void)
 	return 0;
 }
 
+static int setup_possible_cpus __initdata = -1;
+static int __init _setup_possible_cpus(char *str)
+{
+	get_option(&str, &setup_possible_cpus);
+	return 0;
+}
+early_param("possible_cpus", _setup_possible_cpus);
+
+/*
+ * cpu_possible_mask should be static, it cannot change as cpu's
+ * are onlined, or offlined. The reason is per-cpu data-structures
+ * are allocated by some modules at init time, and dont expect to
+ * do this dynamically on cpu arrival/departure.
+ * cpu_present_mask on the other hand can change dynamically.
+ * In case when cpu_hotplug is not compiled, then we resort to current
+ * behaviour, which is cpu_possible == cpu_present.
+ * - Ashok Raj
+ *
+ * Three ways to find out the number of additional hotplug CPUs:
+ * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
+ * - The user can overwrite it with possible_cpus=NUM
+ * - Otherwise don't reserve additional CPUs.
+ * We do this because additional CPUs waste a lot of memory.
+ * -AK
+ */
+void __init prefill_possible_map(void)
+{
+	int i;
+	int possible, disabled_cpus;
+
+	disabled_cpus = total_cpus - available_cpus;
+
+	if (setup_possible_cpus == -1) {
+		if (disabled_cpus > 0)
+			setup_possible_cpus = disabled_cpus;
+		else
+			setup_possible_cpus = 0;
+	}
+
+	possible = available_cpus + setup_possible_cpus;
+
+	pr_info("SMP: the system is limited to %d CPUs\n", nr_cpu_ids);
+
+	if (possible > nr_cpu_ids)
+		possible = nr_cpu_ids;
+
+	pr_info("SMP: Allowing %d CPUs, %d hotplug CPUs\n",
+		possible, max((possible - available_cpus), 0));
+
+	for (i = 0; i < possible; i++)
+		set_cpu_possible(i, true);
+	for (; i < NR_CPUS; i++)
+		set_cpu_possible(i, false);
+}
+
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
 	*irq = gsi_to_irq(gsi);
-- 
1.7.9.5

