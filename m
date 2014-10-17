Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaJQNj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:39:59 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48231 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaJQNj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:39:56 -0400
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
        Kangkang.Shen@huawei.com, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v5 11/18] ARM64 / ACPI: Parse MADT for SMP initialization
Date: Fri, 17 Oct 2014 21:37:07 +0800
Message-Id: <1413553034-20956-12-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADT contains the information for MPIDR which is essential for
SMP initialization, parse the GIC cpu interface structures to
get the MPIDR value and map it to cpu_logical_map(), and add
enabled cpu with valid MPIDR into cpu_possible_map.

ACPI 5.1 only has two explicit methods to boot up SMP, PSCI and
Parking protocol, but the Parking protocol is only specified for
ARMv7 now, so make PSCI as the only way for the SMP boot protocol
before some updates for the ACPI spec or the Parking protocol spec.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/arm64/include/asm/acpi.h    |    2 +
 arch/arm64/include/asm/cpu_ops.h |    1 +
 arch/arm64/include/asm/smp.h     |    5 +-
 arch/arm64/kernel/acpi.c         |  150 +++++++++++++++++++++++++++++++++++++-
 arch/arm64/kernel/cpu_ops.c      |    4 +-
 arch/arm64/kernel/setup.c        |    7 +-
 arch/arm64/kernel/smp.c          |    2 +-
 7 files changed, 162 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 221ff15..c82d4a1 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -58,11 +58,13 @@ static inline bool acpi_has_cpu_in_madt(void)
 }
 
 static inline void arch_fix_phys_package_id(int num, u32 slot) { }
+void __init acpi_smp_init_cpus(void);
 
 #else
 static inline void disable_acpi(void) { }
 static inline bool acpi_psci_present(void) { return false; }
 static inline bool acpi_psci_use_hvc(void) { return false; }
+static inline void acpi_smp_init_cpus(void) { }
 #endif /* CONFIG_ACPI */
 
 #endif /*_ASM_ACPI_H*/
diff --git a/arch/arm64/include/asm/cpu_ops.h b/arch/arm64/include/asm/cpu_ops.h
index d7b4b38..d149580 100644
--- a/arch/arm64/include/asm/cpu_ops.h
+++ b/arch/arm64/include/asm/cpu_ops.h
@@ -61,6 +61,7 @@ struct cpu_operations {
 };
 
 extern const struct cpu_operations *cpu_ops[NR_CPUS];
+const struct cpu_operations *cpu_get_ops(const char *name);
 extern int __init cpu_read_ops(struct device_node *dn, int cpu);
 extern void __init cpu_read_bootcpu_ops(void);
 
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index a498f2c..c877adc 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -39,9 +39,10 @@ extern void show_ipi_list(struct seq_file *p, int prec);
 extern void handle_IPI(int ipinr, struct pt_regs *regs);
 
 /*
- * Setup the set of possible CPUs (via set_cpu_possible)
+ * Discover the set of possible CPUs and determine their
+ * SMP operations.
  */
-extern void smp_init_cpus(void);
+extern void of_smp_init_cpus(void);
 
 /*
  * Provide a function to raise an IPI cross call on CPUs in callmap.
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index e713236..34837e0 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -24,6 +24,10 @@
 #include <linux/bootmem.h>
 #include <linux/smp.h>
 
+#include <asm/smp_plat.h>
+#include <asm/cputype.h>
+#include <asm/cpu_ops.h>
+
 int acpi_noirq;			/* skip ACPI IRQ initialization */
 int acpi_disabled;
 EXPORT_SYMBOL(acpi_disabled);
@@ -31,6 +35,8 @@ EXPORT_SYMBOL(acpi_disabled);
 int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
 EXPORT_SYMBOL(acpi_pci_disabled);
 
+static int enabled_cpus;	/* Processors (GICC) with enabled flag in MADT */
+
 /*
  * __acpi_map_table() will be called before page_init(), so early_ioremap()
  * or early_memremap() should be called here to for ACPI table mapping.
@@ -51,6 +57,134 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
 	early_memunmap(map, size);
 }
 
+/**
+ * acpi_map_gic_cpu_interface - generates a logical cpu number
+ * and map to MPIDR represented by GICC structure
+ * @mpidr: CPU's hardware id to register, MPIDR represented in MADT
+ * @enabled: this cpu is enabled or not
+ *
+ * Returns the logical cpu number which maps to MPIDR
+ */
+static int acpi_map_gic_cpu_interface(u64 mpidr, u8 enabled)
+{
+	int cpu;
+
+	if (mpidr == INVALID_HWID) {
+		pr_info("Skip MADT cpu entry with invalid MPIDR\n");
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
+	/* No need to check duplicate MPIDRs for the first CPU */
+	if (enabled_cpus) {
+		/*
+		 * Duplicate MPIDRs are a recipe for disaster. Scan
+		 * all initialized entries and check for
+		 * duplicates. If any is found just ignore the CPU.
+		 */
+		for_each_possible_cpu(cpu) {
+			if (cpu_logical_map(cpu) == mpidr) {
+				pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
+				       mpidr);
+				return -EINVAL;
+			}
+		}
+		
+		/* allocate a logical cpu id for the new comer */
+		cpu = cpumask_next_zero(-1, cpu_possible_mask);
+	} else {
+		/*
+		 * First GICC entry must be BSP as ACPI spec said
+		 * in section 5.2.12.15
+		 */
+		if  (cpu_logical_map(0) != mpidr) {
+			pr_err("First GICC entry with MPIDR 0x%llx is not BSP\n",
+			       mpidr);
+			return -EINVAL;
+		}
+
+		/*
+		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
+		 * for BSP, no need to allocate again.
+		 */
+		cpu = 0;
+	}
+
+	/* CPU 0 was already initialized */
+	if (cpu) {
+		cpu_ops[cpu] = cpu_get_ops(acpi_psci_present() ? "psci" : NULL);
+		if (!cpu_ops[cpu])
+			return -EINVAL;
+
+		if (cpu_ops[cpu]->cpu_init(NULL, cpu))
+			return -EOPNOTSUPP;
+
+		/* map the logical cpu id to cpu MPIDR */
+		cpu_logical_map(cpu) = mpidr;
+
+		set_cpu_possible(cpu, true);
+	} else {
+		/* get cpu0's ops, no need to return if ops is null */
+		cpu_ops[0] = cpu_get_ops(acpi_psci_present() ? "psci" : NULL);
+	}
+
+	enabled_cpus++;
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
+	acpi_map_gic_cpu_interface(processor->arm_mpidr & MPIDR_HWID_BITMASK,
+		processor->flags & ACPI_MADT_ENABLED);
+
+	return 0;
+}
+
+/* Parse GIC cpu interface entries in MADT for SMP init */
+void __init acpi_smp_init_cpus(void)
+{
+	int count;
+
+	/*
+	 * do a partial walk of MADT to determine how many CPUs
+	 * we have including disabled CPUs, and get information
+	 * we need for SMP init
+	 */
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+			acpi_parse_gic_cpu_interface, 0);
+
+	if (!count) {
+		pr_err("No GIC CPU interface entries present\n");
+		return;
+	} else if (count < 0) {
+		pr_err("Error parsing GIC CPU interface entry\n");
+		return;
+	}
+
+	/* Make boot-up look pretty */
+	pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
+}
+
 static int __init acpi_parse_fadt(struct acpi_table_header *table)
 {
 	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
@@ -62,8 +196,20 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 	 * to get arm boot flags, or we will disable ACPI.
 	 */
 	if (table->revision > 5 ||
-	    (table->revision == 5 && fadt->minor_revision >= 1))
-		return 0;
+	    (table->revision == 5 && fadt->minor_revision >= 1)) {
+		/*
+		 * ACPI 5.1 only has two explicit methods to boot up SMP,
+		 * PSCI and Parking protocol, but the Parking protocol is
+		 * only specified for ARMv7 now, so make PSCI as the only
+		 * way for the SMP boot protocol before some updates for
+		 * the ACPI spec or the Parking protocol spec.
+		 */
+		if (acpi_psci_present())
+			return 0;
+
+		pr_warn("No PSCI support, will not bring up secondary CPUs\n");
+		return -EOPNOTSUPP;
+	}
 
 	pr_warn("Unsupported FADT revision %d.%d, should be 5.1+, will disable ACPI\n",
 		table->revision, fadt->minor_revision);
diff --git a/arch/arm64/kernel/cpu_ops.c b/arch/arm64/kernel/cpu_ops.c
index cce9524..1a04deb 100644
--- a/arch/arm64/kernel/cpu_ops.c
+++ b/arch/arm64/kernel/cpu_ops.c
@@ -27,7 +27,7 @@ extern const struct cpu_operations cpu_psci_ops;
 
 const struct cpu_operations *cpu_ops[NR_CPUS];
 
-static const struct cpu_operations *supported_cpu_ops[] __initconst = {
+static const struct cpu_operations *supported_cpu_ops[] = {
 #ifdef CONFIG_SMP
 	&smp_spin_table_ops,
 #endif
@@ -35,7 +35,7 @@ static const struct cpu_operations *supported_cpu_ops[] __initconst = {
 	NULL,
 };
 
-static const struct cpu_operations * __init cpu_get_ops(const char *name)
+const struct cpu_operations *cpu_get_ops(const char *name)
 {
 	const struct cpu_operations **ops = supported_cpu_ops;
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index d448d6a..eb00f01 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -404,13 +404,16 @@ void __init setup_arch(char **cmdline_p)
 	if (acpi_disabled) {
 		unflatten_device_tree();
 		psci_dt_init();
+		cpu_read_bootcpu_ops();
+#ifdef CONFIG_SMP
+		of_smp_init_cpus();
+#endif
 	} else {
 		psci_acpi_init();
+		acpi_smp_init_cpus();
 	}
 
-	cpu_read_bootcpu_ops();
 #ifdef CONFIG_SMP
-	smp_init_cpus();
 	smp_build_mpidr_hash();
 #endif
 
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 4743397..4e390ac 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -321,7 +321,7 @@ void __init smp_prepare_boot_cpu(void)
  * cpu logical map array containing MPIDR values related to logical
  * cpus. Assumes that cpu_logical_map(0) has already been initialized.
  */
-void __init smp_init_cpus(void)
+void __init of_smp_init_cpus(void)
 {
 	struct device_node *dn = NULL;
 	unsigned int i, cpu = 1;
-- 
1.7.9.5

