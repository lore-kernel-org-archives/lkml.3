Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3LCQju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:39:50 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34280 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3LCQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:39:45 -0500
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
Subject: [RFC part2 PATCH 1/9] ARM64 / ACPI: Implement core functions for parsing MADT table
Date: Wed,  4 Dec 2013 00:39:05 +0800
Message-Id: <1386088753-2850-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement core functions for parsing MADT table to get the information
about GIC cpu interface and GIC distributor.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h |    3 +
 drivers/acpi/plat/arm-core.c  |  139 ++++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/tables.c         |   21 +++++++
 3 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index c830adc..be2951c 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -83,6 +83,9 @@ void arch_fix_phys_package_id(int num, u32 slot);
 extern int (*acpi_suspend_lowlevel)(void);
 #define acpi_wakeup_address (0)
 
+#define MAX_GIC_CPU_INTERFACE 256
+#define MAX_GIC_DISTRIBUTOR   1		/* should be the same as MAX_GIC_NR */
+
 #else	/* !CONFIG_ACPI */
 #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
 #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
index 2b6df56..45ff625 100644
--- a/drivers/acpi/plat/arm-core.c
+++ b/drivers/acpi/plat/arm-core.c
@@ -52,6 +52,16 @@ EXPORT_SYMBOL(acpi_disabled);
 int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
 EXPORT_SYMBOL(acpi_pci_disabled);
 
+/*
+ * Local interrupt controller address,
+ * GIC cpu interface base address on ARM/ARM64
+ */
+static u64 acpi_lapic_addr __initdata;
+
+#define BAD_MADT_ENTRY(entry, end) (					\
+	(!entry) || (unsigned long)entry + sizeof(*entry) > end ||	\
+	((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
+
 #define PREFIX			"ACPI: "
 
 /* FIXME: this function should be moved to topology.c when it is ready */
@@ -102,6 +112,115 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
 	return;
 }
 
+static int __init acpi_parse_madt(struct acpi_table_header *table)
+{
+	struct acpi_table_madt *madt = NULL;
+
+	madt = (struct acpi_table_madt *)table;
+	if (!madt) {
+		pr_warn(PREFIX "Unable to map MADT\n");
+		return -ENODEV;
+	}
+
+	if (madt->address) {
+		acpi_lapic_addr = (u64) madt->address;
+
+		pr_info(PREFIX "Local APIC address 0x%08x\n", madt->address);
+	}
+
+	return 0;
+}
+
+/*
+ * GIC structures on ARM are somthing like Local APIC structures on x86,
+ * which means GIC cpu interfaces for GICv2/v3. Every GIC structure in
+ * MADT table represents a cpu in the system.
+ *
+ * GIC distributor structures are somthing like IOAPIC on x86. GIC can
+ * be initialized with information in this structure.
+ *
+ * Please refer to chapter5.2.12.14/15 of ACPI 5.0
+ */
+
+static int __init
+acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *processor = NULL;
+
+	processor = (struct acpi_madt_generic_interrupt *)header;
+
+	if (BAD_MADT_ENTRY(processor, end))
+		return -EINVAL;
+
+	acpi_table_print_madt_entry(header);
+
+	return 0;
+}
+
+static int __init
+acpi_parse_gic_distributor(struct acpi_subtable_header *header,
+				const unsigned long end)
+{
+	struct acpi_madt_generic_distributor *distributor = NULL;
+
+	distributor = (struct acpi_madt_generic_distributor *)header;
+
+	if (BAD_MADT_ENTRY(distributor, end))
+		return -EINVAL;
+
+	acpi_table_print_madt_entry(header);
+
+	return 0;
+}
+
+/*
+ * Parse GIC cpu interface related entries in MADT
+ * returns 0 on success, < 0 on error
+ */
+static int __init acpi_parse_madt_gic_entries(void)
+{
+	int count;
+
+	/*
+	 * do a partial walk of MADT to determine how many CPUs
+	 * we have including disabled CPUs
+	 */
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				acpi_parse_gic, MAX_GIC_CPU_INTERFACE);
+
+	if (!count) {
+		pr_err(PREFIX "No GIC entries present\n");
+		return -ENODEV;
+	} else if (count < 0) {
+		pr_err(PREFIX "Error parsing GIC entry\n");
+		return count;
+	}
+
+	return 0;
+}
+
+/*
+ * Parse GIC distributor related entries in MADT
+ * returns 0 on success, < 0 on error
+ */
+static int __init acpi_parse_madt_gic_distributor_entries(void)
+{
+	int count;
+
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+			acpi_parse_gic_distributor, MAX_GIC_DISTRIBUTOR);
+
+	if (!count) {
+		pr_err(PREFIX "No GIC distributor entries present\n");
+		return -ENODEV;
+	} else if (count < 0) {
+		pr_err(PREFIX "Error parsing GIC distributor entry\n");
+		return count;
+	}
+
+	return 0;
+}
+
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
 {
 	*irq = gsi_to_irq(gsi);
@@ -132,11 +251,29 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 
 static void __init early_acpi_process_madt(void)
 {
-	return;
+	acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt);
 }
 
 static void __init acpi_process_madt(void)
 {
+	int error;
+
+	if (!acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt)) {
+
+		/*
+		 * Parse MADT GIC cpu interface entries
+		 */
+		error = acpi_parse_madt_gic_entries();
+		if (!error) {
+			/*
+			 * Parse MADT GIC distributor entries
+			 */
+			acpi_parse_madt_gic_distributor_entries();
+		}
+	}
+
+	pr_info("Using ACPI for processor (GIC) configuration information\n");
+
 	return;
 }
 
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index d67a1fe..b3e4615 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -191,6 +191,27 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		}
 		break;
 
+	case ACPI_MADT_TYPE_GENERIC_INTERRUPT:
+		{
+			struct acpi_madt_generic_interrupt *p =
+				(struct acpi_madt_generic_interrupt *)header;
+			printk(KERN_INFO PREFIX
+			       "GIC (acpi_id[0x%04x] gic_id[0x%04x] %s)\n",
+			       p->uid, p->gic_id,
+			       (p->flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
+		}
+		break;
+
+	case ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR:
+		{
+			struct acpi_madt_generic_distributor *p =
+				(struct acpi_madt_generic_distributor *)header;
+			printk(KERN_INFO PREFIX
+			       "GIC Distributor (id[0x%04x] address[0x%08llx] gsi_base[%d])\n",
+			       p->gic_id, p->base_address, p->global_irq_base);
+		}
+		break;
+
 	default:
 		printk(KERN_WARNING PREFIX
 		       "Found unsupported MADT entry (type = 0x%x)\n",
-- 
1.7.9.5

