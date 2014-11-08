Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaKHSMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:12:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:52309 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaKHSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:12:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533308"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        David Cohen <david.a.cohen@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-pm@vger.kernel.org
Subject: [Patch Part3 v3 04/38] x86, irq: Prepare IOAPIC interfaces to support hierarchy irqdomain
Date: Sun,  9 Nov 2014 02:13:04 +0800
Message-Id: <1415470418-10874-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper functions to manipulate struct irq_alloc_info for IOAPIC.
Also add extra parameter to IOAPIC interfaces to prepare for hierarchy
irqdomain. Function mp_set_gsi_attr() will be killed once we have
switched to hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h                      |    2 +
 arch/x86/include/asm/io_apic.h                     |   14 ++++++-
 arch/x86/kernel/acpi/boot.c                        |    9 +++--
 arch/x86/kernel/apic/io_apic.c                     |   39 +++++++++++++-------
 arch/x86/pci/intel_mid_pci.c                       |    4 +-
 .../platform/intel-mid/device_libs/platform_wdt.c  |    4 +-
 arch/x86/platform/intel-mid/sfi.c                  |    9 +++--
 7 files changed, 58 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 0620d3b84707..a007dae5feaf 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -149,8 +149,10 @@ struct irq_alloc_info {
 		struct {
 			int		ioapic_id;
 			int		ioapic_pin;
+			int		ioapic_node;
 			u32		ioapic_trigger : 1;
 			u32		ioapic_polarity : 1;
+			u32		ioapic_valid : 1;
 			struct IO_APIC_route_entry *ioapic_entry;
 		};
 #endif
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 3207143f0a44..cdda8ed7592f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -95,6 +95,8 @@ struct IR_IO_APIC_route_entry {
 		index		: 15;
 } __attribute__ ((packed));
 
+struct irq_alloc_info;
+
 #define IOAPIC_AUTO     -1
 #define IOAPIC_EDGE     0
 #define IOAPIC_LEVEL    1
@@ -194,7 +196,8 @@ extern u32 gsi_top;
 extern int mp_find_ioapic(u32 gsi);
 extern int mp_find_ioapic_pin(int ioapic, u32 gsi);
 extern u32 mp_pin_to_gsi(int ioapic, int pin);
-extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
+extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
+			     struct irq_alloc_info *info);
 extern void mp_unmap_irq(int irq);
 extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 			      struct ioapic_domain_cfg *cfg);
@@ -203,6 +206,8 @@ extern int mp_ioapic_registered(u32 gsi_base);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
+extern void ioapic_set_alloc_attr(struct irq_alloc_info *info,
+				  int node, int trigger, int polarity);
 extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
 
 extern void mp_save_irq(struct mpc_intsrc *m);
@@ -253,7 +258,12 @@ static inline void print_IO_APICs(void) {}
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
-static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
+static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
+				    struct irq_alloc_info *info)
+{
+	return gsi;
+}
+
 static inline void mp_unmap_irq(int irq) { }
 
 static inline int save_ioapic_entries(void)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4433a4be8171..ca640b1dded6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -404,6 +404,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity)
 {
 	int irq, node;
+	struct irq_alloc_info info;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -416,7 +417,8 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 		return -1;
 	}
 
-	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
+	ioapic_set_alloc_attr(&info, node, trigger, polarity);
+	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC, &info);
 	if (irq < 0)
 		return irq;
 
@@ -434,7 +436,7 @@ static void mp_unregister_gsi(u32 gsi)
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return;
 
-	irq = mp_map_gsi_to_irq(gsi, 0);
+	irq = mp_map_gsi_to_irq(gsi, 0, NULL);
 	if (irq > 0)
 		mp_unmap_irq(irq);
 }
@@ -618,7 +620,8 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	} else {
 		mutex_lock(&acpi_ioapic_lock);
 		irq = mp_map_gsi_to_irq(gsi,
-					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK,
+					NULL);
 		mutex_unlock(&acpi_ioapic_lock);
 		if (irq < 0)
 			return -1;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 919afe772347..8b3b8560ebda 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -938,7 +938,19 @@ static int irq_trigger(int idx)
 	return trigger;
 }
 
-static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin)
+void ioapic_set_alloc_attr(struct irq_alloc_info *info, int node,
+			   int trigger, int polarity)
+{
+	init_irq_alloc_info(info, NULL);
+	info->type = X86_IRQ_ALLOC_TYPE_IOAPIC;
+	info->ioapic_node = node;
+	info->ioapic_trigger = trigger;
+	info->ioapic_polarity = polarity;
+	info->ioapic_valid = 1;
+}
+
+static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin,
+				 struct irq_alloc_info *info)
 {
 	int irq = -1;
 	int ioapic = (int)(long)domain->host_data;
@@ -971,11 +983,11 @@ static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin)
 }
 
 static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
-			     unsigned int flags)
+			     unsigned int flags, struct irq_alloc_info *info)
 {
 	int irq;
 	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
-	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
+	struct mp_pin_info *pinfo = mp_pin_info(ioapic, pin);
 
 	if (!domain)
 		return -1;
@@ -997,30 +1009,30 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	if (idx >= 0 && test_bit(mp_irqs[idx].srcbus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
 		if (flags & IOAPIC_MAP_ALLOC) {
-			if (info->count == 0 &&
+			if (pinfo->count == 0 &&
 			    mp_irqdomain_map(domain, irq, pin) != 0)
 				irq = -1;
 
 			/* special handling for timer IRQ0 */
 			if (irq == 0)
-				info->count++;
+				pinfo->count++;
 		}
 	} else {
 		irq = irq_find_mapping(domain, pin);
 		if (irq <= 0 && (flags & IOAPIC_MAP_ALLOC))
-			irq = alloc_irq_from_domain(domain, gsi, pin);
+			irq = alloc_irq_from_domain(domain, gsi, pin, info);
 	}
 
 	if (flags & IOAPIC_MAP_ALLOC) {
 		/* special handling for legacy IRQs */
-		if (irq < nr_legacy_irqs() && info->count == 1 &&
+		if (irq < nr_legacy_irqs() && pinfo->count == 1 &&
 		    mp_irqdomain_map(domain, irq, pin) != 0)
 			irq = -1;
 
 		if (irq > 0)
-			info->count++;
-		else if (info->count == 0)
-			info->set = 0;
+			pinfo->count++;
+		else if (pinfo->count == 0)
+			pinfo->set = 0;
 	}
 
 	mutex_unlock(&ioapic_mutex);
@@ -1058,10 +1070,11 @@ static int pin_2_irq(int idx, int ioapic, int pin, unsigned int flags)
 	}
 #endif
 
-	return  mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags);
+	return  mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags, NULL);
 }
 
-int mp_map_gsi_to_irq(u32 gsi, unsigned int flags)
+int mp_map_gsi_to_irq(u32 gsi, unsigned int flags,
+		      struct irq_alloc_info *info)
 {
 	int ioapic, pin, idx;
 
@@ -1074,7 +1087,7 @@ int mp_map_gsi_to_irq(u32 gsi, unsigned int flags)
 	if ((flags & IOAPIC_MAP_CHECK) && idx < 0)
 		return -1;
 
-	return mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags);
+	return mp_map_pin_to_irq(gsi, idx, ioapic, pin, flags, info);
 }
 
 void mp_unmap_irq(int irq)
diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 44b9271580b5..fd9c4223acba 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -208,6 +208,7 @@ static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
 
 static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 {
+	struct irq_alloc_info info;
 	int polarity;
 
 	if (dev->irq_managed && dev->irq > 0)
@@ -217,6 +218,7 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 		polarity = 0; /* active high */
 	else
 		polarity = 1; /* active low */
+	ioapic_set_alloc_attr(&info, dev_to_node(&dev->dev), 1, polarity);
 
 	/*
 	 * MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
@@ -224,7 +226,7 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	 */
 	if (mp_set_gsi_attr(dev->irq, 1, polarity, dev_to_node(&dev->dev)))
 		return -EBUSY;
-	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC) < 0)
+	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC, &info) < 0)
 		return -EBUSY;
 
 	dev->irq_managed = 1;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
index 0b283d4d0ad7..de0009f6d555 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
@@ -27,6 +27,7 @@ static struct platform_device wdt_dev = {
 static int tangier_probe(struct platform_device *pdev)
 {
 	int gsi;
+	struct irq_alloc_info info;
 	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
 
 	if (!pdata)
@@ -34,8 +35,9 @@ static int tangier_probe(struct platform_device *pdev)
 
 	/* IOAPIC builds identity mapping between GSI and IRQ on MID */
 	gsi = pdata->irq;
+	ioapic_set_alloc_attr(&info, cpu_to_node(0), 1, 0);
 	if (mp_set_gsi_attr(gsi, 1, 0, cpu_to_node(0)) ||
-	    mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC) <= 0) {
+	    mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC, &info) <= 0) {
 		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
 			 gsi);
 		return -EINVAL;
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 9a16749935d4..7d17355d820e 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -104,7 +104,7 @@ int __init sfi_parse_mtmr(struct sfi_table_header *table)
 		mp_irq.dstapic = MP_APIC_ALL;
 		mp_irq.dstirq = pentry->irq;
 		mp_save_irq(&mp_irq);
-		mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC);
+		mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC, NULL);
 	}
 
 	return 0;
@@ -175,7 +175,7 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 		mp_irq.dstapic = MP_APIC_ALL;
 		mp_irq.dstirq = pentry->irq;
 		mp_save_irq(&mp_irq);
-		mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC);
+		mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC, NULL);
 	}
 	return 0;
 }
@@ -434,6 +434,7 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 	struct devs_id *dev = NULL;
 	int num, i, ret;
 	int polarity;
+	struct irq_alloc_info info;
 
 	sb = (struct sfi_table_simple *)table;
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_device_table_entry);
@@ -467,9 +468,11 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 				polarity = 1;
 			}
 
+			ioapic_set_alloc_attr(&info, NUMA_NO_NODE, 1, polarity);
 			ret = mp_set_gsi_attr(irq, 1, polarity, NUMA_NO_NODE);
 			if (ret == 0)
-				ret = mp_map_gsi_to_irq(irq, IOAPIC_MAP_ALLOC);
+				ret = mp_map_gsi_to_irq(irq, IOAPIC_MAP_ALLOC,
+							&info);
 			WARN_ON(ret < 0);
 		}
 
-- 
1.7.10.4

