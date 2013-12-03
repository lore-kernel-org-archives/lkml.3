Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3LCQk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:40:28 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50658 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3LCQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:40:23 -0500
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
Subject: [RFC part2 PATCH 4/9] ARM64 / ACPI: Use Parked Address in GIC structure for spin table SMP initialisation
Date: Wed,  4 Dec 2013 00:39:08 +0800
Message-Id: <1386088753-2850-5-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parked Address in GIC structure can be used as cpu release address
for spin table SMP initialisation.

This patch gets parked address from MADT and use it for SMP
initialisation when DT is not available.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h      |    3 +++
 arch/arm64/kernel/smp_spin_table.c |   16 +++++++++---
 drivers/acpi/plat/arm-core.c       |   50 ++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 423a32c..180de4a 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -90,6 +90,9 @@ extern int boot_cpu_apic_id;
 
 extern void prefill_possible_map(void);
 
+extern int acpi_get_parked_address_with_gic_id(u32 gic_id,
+			u64 *parked_address);
+
 #else	/* !CONFIG_ACPI */
 #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
 #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
diff --git a/arch/arm64/kernel/smp_spin_table.c b/arch/arm64/kernel/smp_spin_table.c
index 44c2280..7997873 100644
--- a/arch/arm64/kernel/smp_spin_table.c
+++ b/arch/arm64/kernel/smp_spin_table.c
@@ -25,6 +25,7 @@
 #include <asm/cpu_ops.h>
 #include <asm/cputype.h>
 #include <asm/smp_plat.h>
+#include <asm/acpi.h>
 
 extern void secondary_holding_pen(void);
 volatile unsigned long secondary_holding_pen_release = INVALID_HWID;
@@ -47,6 +48,11 @@ static void write_pen_release(u64 val)
 	__flush_dcache_area(start, size);
 }
 
+static int get_cpu_release_addr_acpi(unsigned int cpu, u64 *parked_address)
+{
+	return acpi_get_parked_address_with_gic_id(arm_cpu_to_apicid[cpu],
+						parked_address);
+}
 
 static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
 {
@@ -55,10 +61,14 @@ static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
 	 */
 	if (of_property_read_u64(dn, "cpu-release-addr",
 				 &cpu_release_addr[cpu])) {
-		pr_err("CPU %d: missing or invalid cpu-release-addr property\n",
-		       cpu);
 
-		return -1;
+		/* try ACPI way */
+		if (get_cpu_release_addr_acpi(cpu, &cpu_release_addr[cpu])) {
+			pr_err("CPU %d: missing or invalid cpu-release-addr property\n",
+				cpu);
+
+			return -1;
+		}
 	}
 
 	return 0;
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 8527ecc..c4c8c68 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -262,6 +262,56 @@ static int __init acpi_parse_madt_gic_entries(void)
 	return 0;
 }
 
+/* Parked Address in ACPI GIC structure can be used as cpu release addr */
+int acpi_get_parked_address_with_gic_id(u32 gic_id, u64 *parked_address)
+{
+	struct acpi_table_header *table_header = NULL;
+	struct acpi_subtable_header *entry;
+	int err = 0;
+	unsigned long table_end;
+	acpi_size tbl_size;
+	struct acpi_madt_generic_interrupt *processor = NULL;
+
+	if (!parked_address)
+		return -EINVAL;
+
+	acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table_header, &tbl_size);
+	if (!table_header) {
+		pr_warn(PREFIX "MADT table not present\n");
+		return -ENODEV;
+	}
+
+	table_end = (unsigned long)table_header + table_header->length;
+
+	/* Parse all entries looking for a match. */
+	entry = (struct acpi_subtable_header *)
+	    ((unsigned long)table_header + sizeof(struct acpi_table_madt));
+
+	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
+	       table_end) {
+		if (entry->type != ACPI_MADT_TYPE_GENERIC_INTERRUPT
+			|| BAD_MADT_ENTRY(entry, table_end))
+			continue;
+
+		processor = (struct acpi_madt_generic_interrupt *)entry;
+
+		if (processor->gic_id == gic_id) {
+			*parked_address = processor->parked_address;
+			goto out;
+		}
+
+		entry = (struct acpi_subtable_header *)
+		    ((unsigned long)entry + entry->length);
+	}
+
+	err = -ENODEV;
+out:
+	if (!acpi_gbl_permanent_mmap)
+		__acpi_unmap_table((char *)table_header, tbl_size);
+
+	return err;
+}
+
 /*
  * Parse GIC distributor related entries in MADT
  * returns 0 on success, < 0 on error
-- 
1.7.9.5

