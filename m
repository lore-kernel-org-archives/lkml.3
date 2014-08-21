Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaHUM0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:26:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35501 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbaHUMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:23:41 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv3 5/9] x86, acpi: Mark __init strings as such
Date: Thu, 21 Aug 2014 14:23:08 +0200
Message-Id: <1408623792-7973-6-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the pi_<level>() helpers to mark the strings printed during
initialization for automatic release. Do so for the strings used in
command line parsing as well, by using the __init_str() macro.

Also convert the remaining printk() calls to their pr_<level> /
pi_<level> counterparts.

This moves ~1.7 kB from the .rodata section to .init.rodata, marking it
for release after initialization.

Signed-off-by: Mathias Krause <minipli@googlemail.com>

---
v2: handle all of arch/x86/kernel/acpi/
---
 arch/x86/kernel/acpi/boot.c  |  155 +++++++++++++++++++-----------------------
 arch/x86/kernel/acpi/sleep.c |   17 +++--
 2 files changed, 79 insertions(+), 93 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b436fc735a..1be7b86424 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -23,6 +23,8 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#define pr_fmt(fmt) "ACPI: " fmt
+
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/acpi_pmtmr.h>
@@ -55,7 +57,7 @@ EXPORT_SYMBOL(acpi_disabled);
 # include <asm/proto.h>
 #endif				/* X86 */
 
-#define PREFIX			"ACPI: "
+#define _(x)	__init_str(x)
 
 int acpi_noirq;				/* skip ACPI IRQ initialization */
 int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
@@ -128,15 +130,14 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
 
 	madt = (struct acpi_table_madt *)table;
 	if (!madt) {
-		printk(KERN_WARNING PREFIX "Unable to map MADT\n");
+		pi_warn("Unable to map MADT\n");
 		return -ENODEV;
 	}
 
 	if (madt->address) {
 		acpi_lapic_addr = (u64) madt->address;
 
-		printk(KERN_DEBUG PREFIX "Local APIC address 0x%08x\n",
-		       madt->address);
+		pi_debug("Local APIC address 0x%08x\n", madt->address);
 	}
 
 	default_acpi_madt_oem_check(madt->header.oem_id,
@@ -157,7 +158,7 @@ static int acpi_register_lapic(int id, u8 enabled)
 	unsigned int ver = 0;
 
 	if (id >= MAX_LOCAL_APIC) {
-		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
+		pr_info("skipped apicid that is too big\n");
 		return -EINVAL;
 	}
 
@@ -197,11 +198,11 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 	 * when we use CPU hotplug.
 	 */
 	if (!apic->apic_id_valid(apic_id) && enabled)
-		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
+		pi_warn("x2apic entry ignored\n");
 	else
 		acpi_register_lapic(apic_id, enabled);
 #else
-	printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
+	pi_warn("x2apic entry ignored\n");
 #endif
 
 	return 0;
@@ -280,7 +281,7 @@ acpi_parse_x2apic_nmi(struct acpi_subtable_header *header,
 	acpi_table_print_madt_entry(header);
 
 	if (x2apic_nmi->lint != 1)
-		printk(KERN_WARNING PREFIX "NMI not connected to LINT 1!\n");
+		pi_warn("NMI not connected to LINT 1!\n");
 
 	return 0;
 }
@@ -298,7 +299,7 @@ acpi_parse_lapic_nmi(struct acpi_subtable_header * header, const unsigned long e
 	acpi_table_print_madt_entry(header);
 
 	if (lapic_nmi->lint != 1)
-		printk(KERN_WARNING PREFIX "NMI not connected to LINT 1!\n");
+		pi_warn("NMI not connected to LINT 1!\n");
 
 	return 0;
 }
@@ -514,14 +515,14 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 
 	if (intsrc->source_irq == 0) {
 		if (acpi_skip_timer_override) {
-			printk(PREFIX "BIOS IRQ0 override ignored.\n");
+			pi_info("BIOS IRQ0 override ignored.\n");
 			return 0;
 		}
 
 		if ((intsrc->global_irq == 2) && acpi_fix_pin2_polarity
 			&& (intsrc->inti_flags & ACPI_MADT_POLARITY_MASK)) {
 			intsrc->inti_flags &= ~ACPI_MADT_POLARITY_MASK;
-			printk(PREFIX "BIOS IRQ0 pin2 override: forcing polarity to high active.\n");
+			pi_info("BIOS IRQ0 pin2 override: forcing polarity to high active.\n");
 		}
 	}
 
@@ -597,7 +598,7 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 	if (old == new)
 		return;
 
-	printk(PREFIX "setting ELCR to %04x (from %04x)\n", new, old);
+	pi_info("setting ELCR to %04x (from %04x)\n", new, old);
 	outb(new, 0x4d0);
 	outb(new >> 8, 0x4d1);
 }
@@ -719,7 +720,7 @@ static int _acpi_map_lsapic(acpi_handle handle, int physid, int *pcpu)
 
 	cpu = acpi_register_lapic(physid, ACPI_MADT_ENABLED);
 	if (cpu < 0) {
-		pr_info(PREFIX "Unable to map lapic to logical cpu number\n");
+		pr_info("Unable to map lapic to logical cpu number\n");
 		return cpu;
 	}
 
@@ -775,7 +776,7 @@ static int __init acpi_parse_sbf(struct acpi_table_header *table)
 
 	sb = (struct acpi_table_boot *)table;
 	if (!sb) {
-		printk(KERN_WARNING PREFIX "Unable to map SBF\n");
+		pi_warn("Unable to map SBF\n");
 		return -ENODEV;
 	}
 
@@ -795,13 +796,12 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 
 	hpet_tbl = (struct acpi_table_hpet *)table;
 	if (!hpet_tbl) {
-		printk(KERN_WARNING PREFIX "Unable to map HPET\n");
+		pi_warn("Unable to map HPET\n");
 		return -ENODEV;
 	}
 
 	if (hpet_tbl->address.space_id != ACPI_SPACE_MEM) {
-		printk(KERN_WARNING PREFIX "HPET timers must be located in "
-		       "memory.\n");
+		pi_warn("HPET timers must be located in memory.\n");
 		return -1;
 	}
 
@@ -813,9 +813,8 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 	 * want to allocate a resource there.
 	 */
 	if (!hpet_address) {
-		printk(KERN_WARNING PREFIX
-		       "HPET id: %#x base: %#lx is invalid\n",
-		       hpet_tbl->id, hpet_address);
+		pi_warn("HPET id: %#x base: %#lx is invalid\n", hpet_tbl->id,
+			hpet_address);
 		return 0;
 	}
 #ifdef CONFIG_X86_64
@@ -826,21 +825,19 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 	 */
 	if (hpet_address == 0xfed0000000000000UL) {
 		if (!hpet_force_user) {
-			printk(KERN_WARNING PREFIX "HPET id: %#x "
-			       "base: 0xfed0000000000000 is bogus\n "
-			       "try hpet=force on the kernel command line to "
-			       "fix it up to 0xfed00000.\n", hpet_tbl->id);
+			pi_warn("HPET id: %#x base: %#lx is bogus\n",
+				hpet_tbl->id, 0xfed0000000000000UL);
+			pi_cont("try hpet=force on the kernel command line "
+				"to fix it up to 0xfed00000.\n"),
 			hpet_address = 0;
 			return 0;
 		}
-		printk(KERN_WARNING PREFIX
-		       "HPET id: %#x base: 0xfed0000000000000 fixed up "
-		       "to 0xfed00000.\n", hpet_tbl->id);
+		pi_warn("HPET id: %#x base: %#lx fixed up to 0xfed00000.\n",
+			hpet_tbl->id, 0xfed0000000000000UL);
 		hpet_address >>= 32;
 	}
 #endif
-	printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx\n",
-	       hpet_tbl->id, hpet_address);
+	pi_info("HPET id: %#x base: %#lx\n", hpet_tbl->id, hpet_address);
 
 	/*
 	 * Allocate and initialize the HPET firmware resource for adding into
@@ -851,7 +848,7 @@ static int __init acpi_parse_hpet(struct acpi_table_header *table)
 
 	hpet_res->name = (void *)&hpet_res[1];
 	hpet_res->flags = IORESOURCE_MEM;
-	snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE, "HPET %u",
+	snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE, _("HPET %u"),
 		 hpet_tbl->sequence);
 
 	hpet_res->start = hpet_address;
@@ -902,8 +899,7 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 		pmtmr_ioport = acpi_gbl_FADT.pm_timer_block;
 	}
 	if (pmtmr_ioport)
-		printk(KERN_INFO PREFIX "PM-Timer IO Port: %#x\n",
-		       pmtmr_ioport);
+		pi_info("PM-Timer IO Port: %#x\n", pmtmr_ioport);
 #endif
 	return 0;
 }
@@ -929,8 +925,7 @@ static int __init early_acpi_parse_madt_lapic_addr_ovr(void)
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
 				      acpi_parse_lapic_addr_ovr, 0);
 	if (count < 0) {
-		printk(KERN_ERR PREFIX
-		       "Error parsing LAPIC address override entry\n");
+		pi_err("Error parsing LAPIC address override entry\n");
 		return count;
 	}
 
@@ -955,8 +950,7 @@ static int __init acpi_parse_madt_lapic_entries(void)
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_OVERRIDE,
 				      acpi_parse_lapic_addr_ovr, 0);
 	if (count < 0) {
-		printk(KERN_ERR PREFIX
-		       "Error parsing LAPIC address override entry\n");
+		pi_err("Error parsing LAPIC address override entry\n");
 		return count;
 	}
 
@@ -972,11 +966,11 @@ static int __init acpi_parse_madt_lapic_entries(void)
 					acpi_parse_lapic, MAX_LOCAL_APIC);
 	}
 	if (!count && !x2count) {
-		printk(KERN_ERR PREFIX "No LAPIC entries present\n");
+		pi_err("No LAPIC entries present\n");
 		/* TBD: Cleanup to allow fallback to MPS */
 		return -ENODEV;
 	} else if (count < 0 || x2count < 0) {
-		printk(KERN_ERR PREFIX "Error parsing LAPIC entry\n");
+		pi_err("Error parsing LAPIC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
 		return count;
 	}
@@ -986,7 +980,7 @@ static int __init acpi_parse_madt_lapic_entries(void)
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI,
 				      acpi_parse_lapic_nmi, 0);
 	if (count < 0 || x2count < 0) {
-		printk(KERN_ERR PREFIX "Error parsing LAPIC NMI entry\n");
+		pi_err("Error parsing LAPIC NMI entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
 		return count;
 	}
@@ -1007,7 +1001,7 @@ static void __init mp_config_acpi_legacy_irqs(void)
 	mp_bus_id_to_type[MP_ISA_BUS] = MP_BUS_ISA;
 #endif
 	set_bit(MP_ISA_BUS, mp_bus_not_pci);
-	pr_debug("Bus #%d is ISA\n", MP_ISA_BUS);
+	pi_debug("Bus #%d is ISA\n", MP_ISA_BUS);
 
 	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
@@ -1045,7 +1039,7 @@ static void __init mp_config_acpi_legacy_irqs(void)
 		}
 
 		if (idx != mp_irq_entries) {
-			printk(KERN_DEBUG "ACPI: IRQ%d used by override.\n", i);
+			pi_debug("IRQ%d used by override.\n", i);
 			continue;	/* IRQ already used */
 		}
 
@@ -1085,26 +1079,24 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	 * if "noapic" boot option, don't look for IO-APICs
 	 */
 	if (skip_ioapic_setup) {
-		printk(KERN_INFO PREFIX "Skipping IOAPIC probe "
-		       "due to 'noapic' option.\n");
+		pi_info("Skipping IOAPIC probe due to 'noapic' option.\n");
 		return -ENODEV;
 	}
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_IO_APIC, acpi_parse_ioapic,
 				      MAX_IO_APICS);
 	if (!count) {
-		printk(KERN_ERR PREFIX "No IOAPIC entries present\n");
+		pi_err("No IOAPIC entries present\n");
 		return -ENODEV;
 	} else if (count < 0) {
-		printk(KERN_ERR PREFIX "Error parsing IOAPIC entry\n");
+		pi_err("Error parsing IOAPIC entry\n");
 		return count;
 	}
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE,
 				      acpi_parse_int_src_ovr, nr_irqs);
 	if (count < 0) {
-		printk(KERN_ERR PREFIX
-		       "Error parsing interrupt source overrides entry\n");
+		pi_err("Error parsing interrupt source overrides entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
 		return count;
 	}
@@ -1123,7 +1115,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE,
 				      acpi_parse_nmi_src, nr_irqs);
 	if (count < 0) {
-		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
+		pi_err("Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
 		return count;
 	}
@@ -1156,8 +1148,7 @@ static void __init early_acpi_process_madt(void)
 			/*
 			 * Dell Precision Workstation 410, 610 come here.
 			 */
-			printk(KERN_ERR PREFIX
-			       "Invalid BIOS MADT, disabling ACPI\n");
+			pi_err("Invalid BIOS MADT, disabling ACPI\n");
 			disable_acpi();
 		}
 	}
@@ -1192,8 +1183,7 @@ static void __init acpi_process_madt(void)
 			/*
 			 * Dell Precision Workstation 410, 610 come here.
 			 */
-			printk(KERN_ERR PREFIX
-			       "Invalid BIOS MADT, disabling ACPI\n");
+			pi_err("Invalid BIOS MADT, disabling ACPI\n");
 			disable_acpi();
 		}
 	} else {
@@ -1203,8 +1193,7 @@ static void __init acpi_process_madt(void)
  		 * Boot with "acpi=off" to use MPS on such a system.
  		 */
 		if (smp_found_config) {
-			printk(KERN_WARNING PREFIX
-				"No APIC-table, disabling MPS\n");
+			pi_warn("No APIC-table, disabling MPS\n");
 			smp_found_config = 0;
 		}
 	}
@@ -1214,11 +1203,11 @@ static void __init acpi_process_madt(void)
 	 * processors, where MPS only supports physical.
 	 */
 	if (acpi_lapic && acpi_ioapic)
-		printk(KERN_INFO "Using ACPI (MADT) for SMP configuration "
-		       "information\n");
+		pi_info("Using ACPI (MADT) for SMP configuration "
+			"information\n");
 	else if (acpi_lapic)
-		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
-		       "configuration information\n");
+		pi_info("Using ACPI for processor (LAPIC) configuration "
+			"information\n");
 #endif
 	return;
 }
@@ -1226,8 +1215,7 @@ static void __init acpi_process_madt(void)
 static int __init disable_acpi_irq(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
-		printk(KERN_NOTICE "%s detected: force use of acpi=noirq\n",
-		       d->ident);
+		pi_info("%s detected: force use of acpi=noirq\n", d->ident);
 		acpi_noirq_set();
 	}
 	return 0;
@@ -1236,8 +1224,7 @@ static int __init disable_acpi_irq(const struct dmi_system_id *d)
 static int __init disable_acpi_pci(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
-		printk(KERN_NOTICE "%s detected: force use of pci=noacpi\n",
-		       d->ident);
+		pi_notice("%s detected: force use of pci=noacpi\n", d->ident);
 		acpi_disable_pci();
 	}
 	return 0;
@@ -1246,11 +1233,11 @@ static int __init disable_acpi_pci(const struct dmi_system_id *d)
 static int __init dmi_disable_acpi(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
-		printk(KERN_NOTICE "%s detected: acpi off\n", d->ident);
+		pi_notice("%s detected: acpi off\n", d->ident);
 		disable_acpi();
 	} else {
-		printk(KERN_NOTICE
-		       "Warning: DMI blacklist says broken, but acpi forced\n");
+		pi_notice("Warning: DMI blacklist says broken, but acpi "
+			  "forced\n");
 	}
 	return 0;
 }
@@ -1261,8 +1248,8 @@ static int __init dmi_disable_acpi(const struct dmi_system_id *d)
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 {
 	if (!acpi_skip_timer_override) {
-		pr_notice("%s detected: Ignoring BIOS IRQ0 override\n",
-			d->ident);
+		pi_notice("%s detected: Ignoring BIOS IRQ0 override\n",
+			  d->ident);
 		acpi_skip_timer_override = 1;
 	}
 	return 0;
@@ -1445,9 +1432,9 @@ void __init acpi_boot_table_init(void)
 	 */
 	if (acpi_blacklisted()) {
 		if (acpi_force) {
-			printk(KERN_WARNING PREFIX "acpi=force override\n");
+			pi_warn("acpi=force override\n");
 		} else {
-			printk(KERN_WARNING PREFIX "Disabling ACPI support\n");
+			pi_warn("Disabling ACPI support\n");
 			disable_acpi();
 			return;
 		}
@@ -1507,32 +1494,32 @@ static int __init parse_acpi(char *arg)
 		return -EINVAL;
 
 	/* "acpi=off" disables both ACPI table parsing and interpreter */
-	if (strcmp(arg, "off") == 0) {
+	if (strcmp(arg, _("off")) == 0) {
 		disable_acpi();
 	}
 	/* acpi=force to over-ride black-list */
-	else if (strcmp(arg, "force") == 0) {
+	else if (strcmp(arg, _("force")) == 0) {
 		acpi_force = 1;
 		acpi_disabled = 0;
 	}
 	/* acpi=strict disables out-of-spec workarounds */
-	else if (strcmp(arg, "strict") == 0) {
+	else if (strcmp(arg, _("strict")) == 0) {
 		acpi_strict = 1;
 	}
 	/* acpi=rsdt use RSDT instead of XSDT */
-	else if (strcmp(arg, "rsdt") == 0) {
+	else if (strcmp(arg, _("rsdt")) == 0) {
 		acpi_gbl_do_not_use_xsdt = TRUE;
 	}
 	/* "acpi=noirq" disables ACPI interrupt routing */
-	else if (strcmp(arg, "noirq") == 0) {
+	else if (strcmp(arg, _("noirq")) == 0) {
 		acpi_noirq_set();
 	}
 	/* "acpi=copy_dsdt" copys DSDT */
-	else if (strcmp(arg, "copy_dsdt") == 0) {
+	else if (strcmp(arg, _("copy_dsdt")) == 0) {
 		acpi_gbl_copy_dsdt_locally = 1;
 	}
 	/* "acpi=nocmcff" disables FF mode for corrected errors */
-	else if (strcmp(arg, "nocmcff") == 0) {
+	else if (strcmp(arg, _("nocmcff")) == 0) {
 		acpi_disable_cmcff = 1;
 	} else {
 		/* Core will printk when we return error. */
@@ -1545,7 +1532,7 @@ early_param("acpi", parse_acpi);
 /* FIXME: Using pci= for an ACPI parameter is a travesty. */
 static int __init parse_pci(char *arg)
 {
-	if (arg && strcmp(arg, "noacpi") == 0)
+	if (arg && strcmp(arg, _("noacpi")) == 0)
 		acpi_disable_pci();
 	return 0;
 }
@@ -1556,9 +1543,9 @@ int __init acpi_mps_check(void)
 #if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_X86_MPPARSE)
 /* mptable code is not built-in*/
 	if (acpi_disabled || acpi_noirq) {
-		printk(KERN_WARNING "MPS support code is not built-in.\n"
-		       "Using acpi=off or acpi=noirq or pci=noacpi "
-		       "may have problem\n");
+		pi_warn("MPS support code is not built-in.\n");
+		pi_cont("Using acpi=off or acpi=noirq or pci=noacpi "
+			"may have problems.\n");
 		return 1;
 	}
 #endif
@@ -1585,16 +1572,16 @@ static int __init setup_acpi_sci(char *s)
 {
 	if (!s)
 		return -EINVAL;
-	if (!strcmp(s, "edge"))
+	if (!strcmp(s, _("edge")))
 		acpi_sci_flags =  ACPI_MADT_TRIGGER_EDGE |
 			(acpi_sci_flags & ~ACPI_MADT_TRIGGER_MASK);
-	else if (!strcmp(s, "level"))
+	else if (!strcmp(s, _("level")))
 		acpi_sci_flags = ACPI_MADT_TRIGGER_LEVEL |
 			(acpi_sci_flags & ~ACPI_MADT_TRIGGER_MASK);
-	else if (!strcmp(s, "high"))
+	else if (!strcmp(s, _("high")))
 		acpi_sci_flags = ACPI_MADT_POLARITY_ACTIVE_HIGH |
 			(acpi_sci_flags & ~ACPI_MADT_POLARITY_MASK);
-	else if (!strcmp(s, "low"))
+	else if (!strcmp(s, _("low")))
 		acpi_sci_flags = ACPI_MADT_POLARITY_ACTIVE_LOW |
 			(acpi_sci_flags & ~ACPI_MADT_POLARITY_MASK);
 	else
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 3136820783..dd75669104 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -114,27 +114,26 @@ int x86_acpi_suspend_lowlevel(void)
 static int __init acpi_sleep_setup(char *str)
 {
 	while ((str != NULL) && (*str != '\0')) {
-		if (strncmp(str, "s3_bios", 7) == 0)
+		if (strncmp(str, __init_str("s3_bios"), 7) == 0)
 			acpi_realmode_flags |= 1;
-		if (strncmp(str, "s3_mode", 7) == 0)
+		if (strncmp(str, __init_str("s3_mode"), 7) == 0)
 			acpi_realmode_flags |= 2;
-		if (strncmp(str, "s3_beep", 7) == 0)
+		if (strncmp(str, __init_str("s3_beep"), 7) == 0)
 			acpi_realmode_flags |= 4;
 #ifdef CONFIG_HIBERNATION
-		if (strncmp(str, "s4_nohwsig", 10) == 0)
+		if (strncmp(str, __init_str("s4_nohwsig"), 10) == 0)
 			acpi_no_s4_hw_signature();
 #endif
-		if (strncmp(str, "nonvs", 5) == 0)
+		if (strncmp(str, __init_str("nonvs"), 5) == 0)
 			acpi_nvs_nosave();
-		if (strncmp(str, "nonvs_s3", 8) == 0)
+		if (strncmp(str, __init_str("nonvs_s3"), 8) == 0)
 			acpi_nvs_nosave_s3();
-		if (strncmp(str, "old_ordering", 12) == 0)
+		if (strncmp(str, __init_str("old_ordering"), 12) == 0)
 			acpi_old_suspend_ordering();
 		str = strchr(str, ',');
 		if (str != NULL)
-			str += strspn(str, ", \t");
+			str += strspn(str, __init_str(", \t"));
 	}
 	return 1;
 }
-
 __setup("acpi_sleep=", acpi_sleep_setup);
-- 
1.7.10.4

