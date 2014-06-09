Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaFIIW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:22:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:36758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338AbaFIIWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321627"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        sfi-devel@simplefirmware.org
Subject: [Patch V4 32/42] x86, irq, SFI: use common irqdomain map interface to program IOAPIC pins
Date: Mon,  9 Jun 2014 16:20:01 +0800
Message-Id: <1402302011-23642-33-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine SFI to use common irqdomain map interface to program IOAPIC pins,
so we can unify the callsite to progam IOAPIC pins.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/pci/intel_mid_pci.c      |   19 +++++-------
 arch/x86/platform/intel-mid/sfi.c |   58 ++++++++++++++++---------------------
 arch/x86/platform/sfi/sfi.c       |    4 ++-
 3 files changed, 35 insertions(+), 46 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index fcbdc5fac2c6..337d165c64f1 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -208,27 +208,22 @@ static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
 
 static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 {
-	u8 pin;
-	struct io_apic_irq_attr irq_attr;
+	int polarity;
 
-	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
+		polarity = 0; /* active high */
+	else
+		polarity = 1; /* active low */
 
 	/*
 	 * MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
 	 * IOAPIC RTE entries, so we just enable RTE for the device.
 	 */
+	if (mp_set_gsi_attr(dev->irq, 1, polarity, dev_to_node(&dev->dev)))
+		return -EBUSY;
 	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC) < 0)
 		return -EBUSY;
 
-	irq_attr.ioapic = mp_find_ioapic(dev->irq);
-	irq_attr.ioapic_pin = dev->irq;
-	irq_attr.trigger = 1; /* level */
-	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
-		irq_attr.polarity = 0; /* active high */
-	else
-		irq_attr.polarity = 1; /* active low */
-	io_apic_set_pci_routing(&dev->dev, dev->irq, &irq_attr);
-
 	return 0;
 }
 
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 7161395e7de7..3c53a90fdb18 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -432,9 +432,8 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 	struct sfi_table_simple *sb;
 	struct sfi_device_table_entry *pentry;
 	struct devs_id *dev = NULL;
-	int num, i;
-	int ioapic;
-	struct io_apic_irq_attr irq_attr;
+	int num, i, ret;
+	int polarity;
 
 	sb = (struct sfi_table_simple *)table;
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_device_table_entry);
@@ -448,37 +447,30 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 			 * devices, but they have separate RTE entry in IOAPIC
 			 * so we have to enable them one by one here
 			 */
-			ioapic = mp_find_ioapic(irq);
-			if (ioapic >= 0) {
-				irq_attr.ioapic = ioapic;
-				irq_attr.ioapic_pin = irq;
-				irq_attr.trigger = 1;
-				if (intel_mid_identify_cpu() ==
-						INTEL_MID_CPU_CHIP_TANGIER) {
-					if (!strncmp(pentry->name,
-							"r69001-ts-i2c", 13))
-						/* active low */
-						irq_attr.polarity = 1;
-					else if (!strncmp(pentry->name,
-							"synaptics_3202", 14))
-						/* active low */
-						irq_attr.polarity = 1;
-					else if (irq == 41)
-						/* fast_int_1 */
-						irq_attr.polarity = 1;
-					else
-						/* active high */
-						irq_attr.polarity = 0;
-				} else {
-					/* PNW and CLV go with active low */
-					irq_attr.polarity = 1;
-				}
-				WARN_ON(mp_map_gsi_to_irq(irq,
-						IOAPIC_MAP_ALLOC) < 0);
-				io_apic_set_pci_routing(NULL, irq, &irq_attr);
+			if (intel_mid_identify_cpu() ==
+					INTEL_MID_CPU_CHIP_TANGIER) {
+				if (!strncmp(pentry->name, "r69001-ts-i2c", 13))
+					/* active low */
+					polarity = 1;
+				else if (!strncmp(pentry->name,
+						"synaptics_3202", 14))
+					/* active low */
+					polarity = 1;
+				else if (irq == 41)
+					/* fast_int_1 */
+					polarity = 1;
+				else
+					/* active high */
+					polarity = 0;
+			} else {
+				/* PNW and CLV go with active low */
+				polarity = 1;
 			}
-		} else {
-			irq = 0; /* No irq */
+
+			ret = mp_set_gsi_attr(irq, 1, polarity, NUMA_NO_NODE);
+			if (ret == 0)
+				ret = mp_map_gsi_to_irq(irq, IOAPIC_MAP_ALLOC);
+			WARN_ON(ret < 0);
 		}
 
 		dev = get_device_id(pentry->type, pentry->name);
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index 1fdaa57f41a5..2a8a74f3bd76 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -71,7 +71,9 @@ static int __init sfi_parse_cpus(struct sfi_table_header *table)
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
-static struct irq_domain_ops sfi_ioapic_irqdomain_ops;
+static struct irq_domain_ops sfi_ioapic_irqdomain_ops = {
+	.map = mp_irqdomain_map,
+};
 
 static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 {
-- 
1.7.10.4

