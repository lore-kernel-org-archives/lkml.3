Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbbATF4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:56:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:33293 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbbATF4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:56:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664448550"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        sfi-devel@simplefirmware.org
Subject: [Patch Part2 v4 31/33] x86: Cleanup irq_domain ops
Date: Tue, 20 Jan 2015 13:51:51 +0800
Message-Id: <1421733113-15704-32-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

We have 3 identical copies of the ioapic domain ops for acpi, mpparse,
and sfi. Have a global one in the io_apic code and be done with it.

To avoid include hell in io_apic.h, create a private irqdomain header
and include the generic irqdomain header from there.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: x86@kernel.org
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h   |   29 ++---------------------------
 arch/x86/include/asm/irqdomain.h |   34 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/acpi/boot.c      |   13 +++----------
 arch/x86/kernel/apic/io_apic.c   |    9 ++++++++-
 arch/x86/kernel/devicetree.c     |   12 ++++++------
 arch/x86/kernel/mpparse.c        |    9 +--------
 arch/x86/platform/sfi/sfi.c      |   10 ++--------
 7 files changed, 56 insertions(+), 60 deletions(-)
 create mode 100644 arch/x86/include/asm/irqdomain.h

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index c7aa7cd90d3f..e4fd3cea0fab 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -96,7 +96,7 @@ struct IR_IO_APIC_route_entry {
 } __attribute__ ((packed));
 
 struct irq_alloc_info;
-struct irq_data;
+struct ioapic_domain_cfg;
 
 #define IOAPIC_AUTO			-1
 #define IOAPIC_EDGE			0
@@ -163,23 +163,6 @@ extern int restore_ioapic_entries(void);
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
-enum ioapic_domain_type {
-	IOAPIC_DOMAIN_INVALID,
-	IOAPIC_DOMAIN_LEGACY,
-	IOAPIC_DOMAIN_STRICT,
-	IOAPIC_DOMAIN_DYNAMIC,
-};
-
-struct device_node;
-struct irq_domain;
-struct irq_domain_ops;
-
-struct ioapic_domain_cfg {
-	enum ioapic_domain_type		type;
-	const struct irq_domain_ops	*ops;
-	struct device_node		*dev;
-};
-
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
@@ -189,15 +172,7 @@ extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 			      struct ioapic_domain_cfg *cfg);
 extern int mp_unregister_ioapic(u32 gsi_base);
 extern int mp_ioapic_registered(u32 gsi_base);
-extern int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
-			      unsigned int nr_irqs, void *arg);
-extern void mp_irqdomain_free(struct irq_domain *domain, unsigned int virq,
-			      unsigned int nr_irqs);
-extern void mp_irqdomain_activate(struct irq_domain *domain,
-				  struct irq_data *irq_data);
-extern void mp_irqdomain_deactivate(struct irq_domain *domain,
-				    struct irq_data *irq_data);
-extern int mp_irqdomain_ioapic_idx(struct irq_domain *domain);
+
 extern void ioapic_set_alloc_attr(struct irq_alloc_info *info,
 				  int node, int trigger, int polarity);
 
diff --git a/arch/x86/include/asm/irqdomain.h b/arch/x86/include/asm/irqdomain.h
new file mode 100644
index 000000000000..fe0d4c6636ec
--- /dev/null
+++ b/arch/x86/include/asm/irqdomain.h
@@ -0,0 +1,34 @@
+#ifndef _ASM_IRQDOMAIN_H
+#define _ASM_IRQDOMAIN_H
+
+#include <linux/irqdomain.h>
+
+enum ioapic_domain_type {
+	IOAPIC_DOMAIN_INVALID,
+	IOAPIC_DOMAIN_LEGACY,
+	IOAPIC_DOMAIN_STRICT,
+	IOAPIC_DOMAIN_DYNAMIC,
+};
+
+struct device_node;
+struct irq_data;
+
+struct ioapic_domain_cfg {
+	enum ioapic_domain_type		type;
+	const struct irq_domain_ops	*ops;
+	struct device_node		*dev;
+};
+
+extern const struct irq_domain_ops mp_ioapic_irqdomain_ops;
+
+extern int mp_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs, void *arg);
+extern void mp_irqdomain_free(struct irq_domain *domain, unsigned int virq,
+			      unsigned int nr_irqs);
+extern void mp_irqdomain_activate(struct irq_domain *domain,
+				  struct irq_data *irq_data);
+extern void mp_irqdomain_deactivate(struct irq_domain *domain,
+				    struct irq_data *irq_data);
+extern int mp_irqdomain_ioapic_idx(struct irq_domain *domain);
+
+#endif
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 5d91ceb248f0..581af1a36b21 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -31,12 +31,12 @@
 #include <linux/module.h>
 #include <linux/dmi.h>
 #include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
 
+#include <asm/irqdomain.h>
 #include <asm/pci_x86.h>
 #include <asm/pgtable.h>
 #include <asm/io_apic.h>
@@ -400,20 +400,13 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	return 0;
 }
 
-static struct irq_domain_ops acpi_irqdomain_ops = {
-	.alloc = mp_irqdomain_alloc,
-	.free = mp_irqdomain_free,
-	.activate = mp_irqdomain_activate,
-	.deactivate = mp_irqdomain_deactivate,
-};
-
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 {
 	struct acpi_madt_io_apic *ioapic = NULL;
 	struct ioapic_domain_cfg cfg = {
 		.type = IOAPIC_DOMAIN_DYNAMIC,
-		.ops = &acpi_irqdomain_ops,
+		.ops = &mp_ioapic_irqdomain_ops,
 	};
 
 	ioapic = (struct acpi_madt_io_apic *)header;
@@ -758,7 +751,7 @@ int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 	u64 addr;
 	struct ioapic_domain_cfg cfg = {
 		.type = IOAPIC_DOMAIN_DYNAMIC,
-		.ops = &acpi_irqdomain_ops,
+		.ops = &mp_ioapic_irqdomain_ops,
 	};
 
 	ioapic_id = acpi_get_ioapic_id(handle, gsi_base, &addr);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 32f37445980d..03fdb945886f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -41,13 +41,13 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/syscore_ops.h>
-#include <linux/irqdomain.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 
+#include <asm/irqdomain.h>
 #include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/smp.h>
@@ -2992,3 +2992,10 @@ int mp_irqdomain_ioapic_idx(struct irq_domain *domain)
 {
 	return (int)(long)domain->host_data;
 }
+
+const struct irq_domain_ops mp_ioapic_irqdomain_ops = {
+	.alloc		= mp_irqdomain_alloc,
+	.free		= mp_irqdomain_free,
+	.activate	= mp_irqdomain_activate,
+	.deactivate	= mp_irqdomain_deactivate,
+};
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 9ca73a700912..421375b1efd5 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -4,7 +4,6 @@
 #include <linux/bootmem.h>
 #include <linux/export.h>
 #include <linux/io.h>
-#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/of.h>
@@ -17,6 +16,7 @@
 #include <linux/of_pci.h>
 #include <linux/initrd.h>
 
+#include <asm/irqdomain.h>
 #include <asm/hpet.h>
 #include <asm/apic.h>
 #include <asm/pci_x86.h>
@@ -216,11 +216,11 @@ static int dt_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 	return mp_irqdomain_alloc(domain, virq, nr_irqs, &tmp);
 }
 
-const struct irq_domain_ops ioapic_irq_domain_ops = {
-	.alloc = dt_irqdomain_alloc,
-	.free = mp_irqdomain_free,
-	.activate = mp_irqdomain_activate,
-	.deactivate = mp_irqdomain_deactivate,
+static const struct irq_domain_ops ioapic_irq_domain_ops = {
+	.alloc		= dt_irqdomain_alloc,
+	.free		= mp_irqdomain_free,
+	.activate	= mp_irqdomain_activate,
+	.deactivate	= mp_irqdomain_deactivate,
 };
 
 static void __init dtb_add_ioapic(struct device_node *dn)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index aa4feee74dbe..30ca7607cbbb 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -19,8 +19,8 @@
 #include <linux/module.h>
 #include <linux/smp.h>
 #include <linux/pci.h>
-#include <linux/irqdomain.h>
 
+#include <asm/irqdomain.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/pgalloc.h>
@@ -113,13 +113,6 @@ static void __init MP_bus_info(struct mpc_bus *m)
 		pr_warn("Unknown bustype %s - ignoring\n", str);
 }
 
-static struct irq_domain_ops mp_ioapic_irqdomain_ops = {
-	.alloc = mp_irqdomain_alloc,
-	.free = mp_irqdomain_free,
-	.activate = mp_irqdomain_activate,
-	.deactivate = mp_irqdomain_deactivate,
-};
-
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
 	struct ioapic_domain_cfg cfg = {
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index b66b194f9900..6c7111bbd1e9 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -25,8 +25,8 @@
 #include <linux/init.h>
 #include <linux/sfi.h>
 #include <linux/io.h>
-#include <linux/irqdomain.h>
 
+#include <asm/irqdomain.h>
 #include <asm/io_apic.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
@@ -71,12 +71,6 @@ static int __init sfi_parse_cpus(struct sfi_table_header *table)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
-static struct irq_domain_ops sfi_ioapic_irqdomain_ops = {
-	.alloc = mp_irqdomain_alloc,
-	.free = mp_irqdomain_free,
-	.activate = mp_irqdomain_activate,
-	.deactivate = mp_irqdomain_deactivate,
-};
 
 static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 {
@@ -85,7 +79,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	int i, num;
 	struct ioapic_domain_cfg cfg = {
 		.type = IOAPIC_DOMAIN_STRICT,
-		.ops = &sfi_ioapic_irqdomain_ops,
+		.ops = &mp_ioapic_irqdomain_ops,
 	};
 
 	sb = (struct sfi_table_simple *)table;
-- 
1.7.10.4

