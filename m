Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaIZOzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:55:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:52099 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbaIZOzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:55:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597291977"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 02/28] x86, irq: Prepare IOAPIC interfaces to support hierarchy irqdomain
Date: Fri, 26 Sep 2014 22:57:32 +0800
Message-Id: <1411743478-31435-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper functions to manipulate struct irq_alloc_info for IOAPIC.
Also add extra parameter to IOAPIC interfaces to prepare for hierarchy
irqdomain. Function mp_set_gsi_attr() will be killed once we have
switched to hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h                      |    2 ++
 arch/x86/include/asm/io_apic.h                     |   14 +++++++++--
 arch/x86/kernel/acpi/boot.c                        |    8 ++++---
 arch/x86/kernel/apic/io_apic.c                     |   25 +++++++++++++++-----
 arch/x86/pci/intel_mid_pci.c                       |    4 +++-
 .../platform/intel-mid/device_libs/platform_wdt.c  |    4 +++-
 arch/x86/platform/intel-mid/sfi.c                  |    5 +++-
 7 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 1cb6687375f8..ceb0244c3454 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -147,8 +147,10 @@ struct irq_alloc_info {
 		struct {
 			int		ioapic_id;
 			int		ioapic_pin;
+			int		ioapic_node;
 			u32		ioapic_trigger : 1;
 			u32		ioapic_polarity : 1;
+			u32		ioapic_valid : 1;
 		};
 #endif
 #ifdef	CONFIG_DMAR_TABLE
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index f9a99bc28981..bfab460f6e2c 100644
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
@@ -254,7 +259,12 @@ static inline void print_IO_APICs(void) {}
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
 static inline bool mp_should_keep_irq(struct device *dev) { return 1; }
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0e54a67b5cd6..a3511606a40d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -404,6 +404,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 			   int polarity)
 {
 	int irq, node;
+	struct irq_alloc_info info;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -420,7 +421,8 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 		return -1;
 	}
 
-	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
+	ioapic_set_alloc_attr(&info, node, trigger, polarity);
+	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC, &info);
 	if (irq < 0)
 		return irq;
 
@@ -440,7 +442,7 @@ static void mp_unregister_gsi(u32 gsi)
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
 		return;
 
-	irq = mp_map_gsi_to_irq(gsi, 0);
+	irq = mp_map_gsi_to_irq(gsi, 0, NULL);
 	if (irq > 0)
 		mp_unmap_irq(irq);
 }
@@ -620,7 +622,7 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	int irq;
 
 	down_read(&acpi_ioapic_rwsem);
-	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK, NULL);
 	up_read(&acpi_ioapic_rwsem);
 	if (irq >= 0) {
 		*irqp = irq;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5cccf8989507..d17a71679775 100644
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
@@ -971,7 +983,7 @@ static int alloc_irq_from_domain(struct irq_domain *domain, u32 gsi, int pin)
 }
 
 static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
-			     unsigned int flags)
+			     unsigned int flags, struct irq_alloc_info *ainfo)
 {
 	int irq;
 	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
@@ -1008,7 +1020,7 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	} else {
 		irq = irq_find_mapping(domain, pin);
 		if (irq <= 0 && (flags & IOAPIC_MAP_ALLOC))
-			irq = alloc_irq_from_domain(domain, gsi, pin);
+			irq = alloc_irq_from_domain(domain, gsi, pin, ainfo);
 	}
 
 	if (flags & IOAPIC_MAP_ALLOC) {
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
index 3c53a90fdb18..5ae60c295fd8 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
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

