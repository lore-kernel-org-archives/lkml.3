Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaAQMqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:46:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56361 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaAQMqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:46:44 -0500
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
Subject: [PATCH 12/20] ARM64 / ACPI: Use Parked Address in GIC structure for spin table SMP initialisation
Date: Fri, 17 Jan 2014 20:25:06 +0800
Message-Id: <1389961514-13562-13-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parked Address in GIC structure can be used as cpu release address
for spin table SMP initialisation.

This patch gets parked address from MADT and use it for SMP
initialisation when DT is not available.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h      |    7 +++++++
 arch/arm64/kernel/smp_spin_table.c |   12 ++++++++----
 drivers/acpi/plat/arm-core.c       |   24 +++++++++++++++++++++++-
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 097394c..856a2e7 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -89,6 +89,8 @@ extern int arm_cpu_to_apicid[NR_CPUS];
 
 extern const char *acpi_get_enable_method(int cpu);
 
+extern int acpi_get_cpu_release_address(int cpu, u64 *release_address);
+
 #else	/* !CONFIG_ACPI */
 #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
 #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
@@ -100,6 +102,11 @@ static inline const char *acpi_get_enable_method(int cpu)
 	return NULL;
 }
 
+static inline int acpi_get_cpu_release_address(int cpu, u64 *release_address)
+{
+	return -ENODEV;
+}
+
 #endif
 
 #endif /*_ASM_ARM64_ACPI_H*/
diff --git a/arch/arm64/kernel/smp_spin_table.c b/arch/arm64/kernel/smp_spin_table.c
index 44c2280..ce86189 100644
--- a/arch/arm64/kernel/smp_spin_table.c
+++ b/arch/arm64/kernel/smp_spin_table.c
@@ -25,6 +25,7 @@
 #include <asm/cpu_ops.h>
 #include <asm/cputype.h>
 #include <asm/smp_plat.h>
+#include <asm/acpi.h>
 
 extern void secondary_holding_pen(void);
 volatile unsigned long secondary_holding_pen_release = INVALID_HWID;
@@ -47,7 +48,6 @@ static void write_pen_release(u64 val)
 	__flush_dcache_area(start, size);
 }
 
-
 static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
 {
 	/*
@@ -55,10 +55,14 @@ static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
 	 */
 	if (of_property_read_u64(dn, "cpu-release-addr",
 				 &cpu_release_addr[cpu])) {
-		pr_err("CPU %d: missing or invalid cpu-release-addr property\n",
-		       cpu);
 
-		return -1;
+		/* try ACPI way */
+		if (acpi_get_cpu_release_address(cpu, &cpu_release_addr[cpu])) {
+			pr_err("CPU %d: missing or invalid cpu-release-addr property\n",
+				cpu);
+
+			return -1;
+		}
 	}
 
 	return 0;
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 2704633..7f1d709 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -60,6 +60,9 @@ static int available_cpus;
 int arm_cpu_to_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = -1 };
 static int boot_cpu_apic_id = -1;
 
+/* Parked Address in ACPI GIC structure */
+static u64 parked_address[NR_CPUS];
+
 #define BAD_MADT_ENTRY(entry, end) (					\
 	(!entry) || (unsigned long)entry + sizeof(*entry) > end ||	\
 	((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
@@ -193,6 +196,7 @@ static int __init
 acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_generic_interrupt *processor = NULL;
+	int cpu;
 
 	processor = (struct acpi_madt_generic_interrupt *)header;
 
@@ -208,9 +212,16 @@ acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	acpi_register_gic_cpu_interface(processor->gic_id,
+	cpu = acpi_register_gic_cpu_interface(processor->gic_id,
 			processor->flags & ACPI_MADT_ENABLED);
 
+	/*
+	 * We need the parked address for SMP initialization with
+	 * spin-table enable method
+	 */
+	if (cpu >= 0 && processor->parked_address)
+		parked_address[cpu] = processor->parked_address;
+
 	return 0;
 }
 
@@ -269,6 +280,17 @@ static int __init acpi_parse_madt_gic_entries(void)
 	return 0;
 }
 
+/* Parked Address in ACPI GIC structure can be used as cpu release addr */
+int acpi_get_cpu_release_address(int cpu, u64 *release_address)
+{
+	if (!release_address || !parked_address[cpu])
+		return -EINVAL;
+
+	*release_address = parked_address[cpu];
+
+	return 0;
+}
+
 /*
  * Parse GIC distributor related entries in MADT
  * returns 0 on success, < 0 on error
-- 
1.7.9.5

