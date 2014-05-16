Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaEPIGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:06:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:9318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbaEPIGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540107607"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        Tony Lindgren <tony@atomide.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Ingo Molnar <mingo@kernel.org>, linux-pm@vger.kernel.org
Subject: [RFC Patch Part1 V1 20/30] x86, irq: enhance mp_register_ioapic() to support irqdomain
Date: Fri, 16 May 2014 16:05:40 +0800
Message-Id: <1400227550-5935-21-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add extra arguments to function mp_register_ioapic() to support
irqdomain. When registering IOAPIC, caller may provide a callback
and corresponding argument to create irqdomain for this IOAPIC.
The callback will be called later when initializing IOAPIC subsystem.

We also provide a common implementation mp_create_irqdomain()
to create irqdomain for IOAPICs, which may be used by platform drivers.

Global variable ioapic_dynirq_base is provided for platform drivers
to override return value of arch_dynirq_lower_bound(), thus enable
or disable dynamic IRQ allocation for IOAPIC.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    9 +++++++-
 arch/x86/kernel/acpi/boot.c    |    3 ++-
 arch/x86/kernel/apic/io_apic.c |   48 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/devicetree.c   |    2 +-
 arch/x86/kernel/mpparse.c      |    2 +-
 arch/x86/platform/sfi/sfi.c    |    2 +-
 6 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 13209bdf318d..f3afa86e5bb6 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -130,6 +130,9 @@ extern int noioapicquirk;
 /* -1 if "noapic" boot option passed */
 extern int noioapicreroute;
 
+/* Build identity mapping for GSIs below it */
+extern int ioapic_dynirq_base;
+
 /*
  * If we use the IO-APIC for IRQ routing, disable automatic
  * assignment of PCI IRQ's.
@@ -169,12 +172,16 @@ struct mp_ioapic_gsi{
 };
 extern u32 gsi_top;
 
+struct irq_domain_ops;
 typedef struct irq_domain *(*ioapic_create_domain_fn)(int idx, void *arg);
 
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern int mp_map_pin_to_irq(int idx, int ioapic, int pin, int alloc);
-extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base);
+extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
+				      ioapic_create_domain_fn cb, void *arg);
+extern struct irq_domain *mp_irqdomain_create(int ioapic,
+		struct device_node *np, const struct irq_domain_ops *ops);
 extern void __init pre_init_apic_IRQ0(void);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index cdf6908e9f75..f70f4f318316 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -344,7 +344,8 @@ acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
 	acpi_table_print_madt_entry(header);
 
 	mp_register_ioapic(ioapic->id,
-			   ioapic->address, ioapic->global_irq_base);
+			   ioapic->address, ioapic->global_irq_base,
+			   NULL, NULL);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fb87bdbb4307..0bdf50988d75 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -166,6 +166,15 @@ DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 int skip_ioapic_setup;
 
+/*
+ * If not zero:
+ * . build identity mapping for GSIs below it.
+ * . must be bigger than or equal to max(NR_IRQS_LEGACY, pins_on_ioapic0).
+ * If zero:
+ * . build identity mapping for all GSIs
+ */
+int ioapic_dynirq_base;
+
 /**
  * disable_ioapic_support() - disables ioapic support at runtime
  */
@@ -2938,15 +2947,28 @@ out:
  */
 #define PIC_IRQS	(1UL << PIC_CASCADE_IR)
 
-void __init setup_IO_APIC(void)
+static void ioapic_create_irqdomains(void)
 {
+	int i;
+	struct ioapic *ip;
 
+	for_each_ioapic(i) {
+		ip = &ioapics[i];
+		if (ip->irqdomain_cb)
+			ip->irqdomain = ip->irqdomain_cb(i, ip->irqdomain_arg);
+	}
+}
+
+void __init setup_IO_APIC(void)
+{
 	/*
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
 	io_apic_irqs = legacy_pic->nr_legacy_irqs ? ~PIC_IRQS : ~0UL;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
+	ioapic_create_irqdomains();
+
 	/*
          * Set up IO-APIC IRQ routing.
          */
@@ -3508,6 +3530,9 @@ unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
 	unsigned int min = gsi_top + NR_IRQS_LEGACY;
 
+	if (ioapic_dynirq_base)
+		return ioapic_dynirq_base;
+
 	return from < min ? min : from;
 }
 
@@ -3886,7 +3911,8 @@ static __init int bad_ioapic_register(int idx)
 	return 0;
 }
 
-void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
+void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
+			       ioapic_create_domain_fn cb, void *arg)
 {
 	int idx = 0;
 	int entries;
@@ -3900,6 +3926,9 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	ioapics[idx].mp_config.type = MP_IOAPIC;
 	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
 	ioapics[idx].mp_config.apicaddr = address;
+	ioapics[idx].irqdomain_cb = cb;
+	ioapics[idx].irqdomain_arg = arg;
+	ioapics[idx].irqdomain = NULL;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 
@@ -3936,6 +3965,21 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	nr_ioapics++;
 }
 
+struct irq_domain *mp_irqdomain_create(int ioapic, struct device_node *np,
+				       const struct irq_domain_ops *ops)
+{
+	struct irq_domain *domain;
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+	int hwirqs = mp_ioapic_pin_count(ioapic);
+
+	domain = irq_domain_add_linear(np, hwirqs, ops, (void *)(long)ioapic);
+	BUG_ON(!domain);
+	if (gsi_cfg->gsi_base == 0)
+		irq_set_default_host(domain);
+
+	return domain;
+}
+
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index d35078ea1446..1ab002c045c9 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -176,7 +176,7 @@ static void __init dtb_add_ioapic(struct device_node *dn)
 				dn->full_name);
 		return;
 	}
-	mp_register_ioapic(++ioapic_id, r.start, gsi_top);
+	mp_register_ioapic(++ioapic_id, r.start, gsi_top, NULL, NULL);
 }
 
 static void __init dtb_ioapic_setup(void)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 24da837389b7..6cb9a43ecde1 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -115,7 +115,7 @@ static void __init MP_bus_info(struct mpc_bus *m)
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
 	if (m->flags & MPC_APIC_USABLE)
-		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top);
+		mp_register_ioapic(m->apicid, m->apicaddr, gsi_top, NULL, NULL);
 }
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index bcd1a703e3e6..3bd7cf642680 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -82,7 +82,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 	pentry = (struct sfi_apic_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++) {
-		mp_register_ioapic(i, pentry->phys_addr, gsi_top);
+		mp_register_ioapic(i, pentry->phys_addr, gsi_top, NULL, NULL);
 		pentry++;
 	}
 
-- 
1.7.10.4

