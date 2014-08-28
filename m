Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936337AbaH1CVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:21:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:27596 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936119AbaH1CVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,415,1406617200"; 
   d="scan'208";a="582676883"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch v4 09/16] x86, irq: Keep balance of IOAPIC pin reference count
Date: Thu, 28 Aug 2014 10:22:34 +0800
Message-Id: <1409192561-19744-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To keep balance of IOAPIC pin reference count, we need to protect
pirq_enable_irq(), acpi_pci_irq_enable() and intel_mid_pci_irq_enable()
from reentrance. There are two cases which will cause reentrance.

The first case is caused by suspend/hibernation. If pcibios_disable_irq
is called during suspending/hibernating, we don't release the assigned
IRQ number, otherwise it may break the suspend/hibernation. So late when
pcibios_enable_irq is called during resume, we shouldn't allocate IRQ
number again.

The second case is that function acpi_pci_irq_enable() may be called
twice for PCI devices present at boot time as below:
1) pci_acpi_init()
	--> acpi_pci_irq_enable() if pci_routeirq is true
2) pci_enable_device()
	--> pcibios_enable_device()
		--> acpi_pci_irq_enable()
We can't kill kernel parameter pci_routeirq yet because it's still
needed for debugging purpose.

So flag irq_managed is introduced to track whether IRQ number is
assigned by OS and to protect pirq_enable_irq(), acpi_pci_irq_enable()
and intel_mid_pci_irq_enable() from reentrance.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/pci/intel_mid_pci.c |    9 ++++++++-
 arch/x86/pci/irq.c           |    7 ++++++-
 drivers/acpi/pci_irq.c       |   11 +++++++++--
 include/linux/pci.h          |    1 +
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 3865116c51fb..6a855fef78fc 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -210,6 +210,9 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 {
 	int polarity;
 
+	if (dev->irq_managed && dev->irq > 0)
+		return 0;
+
 	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
 		polarity = 0; /* active high */
 	else
@@ -224,13 +227,17 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC) < 0)
 		return -EBUSY;
 
+	dev->irq_managed = 1;
+
 	return 0;
 }
 
 static void intel_mid_pci_irq_disable(struct pci_dev *dev)
 {
-	if (!dev->dev.power.is_prepared && dev->irq > 0)
+	if (!dev->dev.power.is_prepared && dev->irq_managed && dev->irq > 0) {
 		mp_unmap_irq(dev->irq);
+		dev->irq_managed = 0;
+	}
 }
 
 struct pci_ops intel_mid_pci_ops = {
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index bc1a2c341891..dd1369dbcc42 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1202,6 +1202,9 @@ static int pirq_enable_irq(struct pci_dev *dev)
 			int irq;
 			struct io_apic_irq_attr irq_attr;
 
+			if (dev->irq_managed && dev->irq > 0)
+				return 0;
+
 			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
 						PCI_SLOT(dev->devfn),
 						pin - 1, &irq_attr);
@@ -1228,6 +1231,7 @@ static int pirq_enable_irq(struct pci_dev *dev)
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
+				dev->irq_managed = 1;
 				dev->irq = irq;
 				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
 					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
@@ -1257,8 +1261,9 @@ static int pirq_enable_irq(struct pci_dev *dev)
 static void pirq_disable_irq(struct pci_dev *dev)
 {
 	if (io_apic_assign_pci_irqs && !dev->dev.power.is_prepared &&
-	    dev->irq) {
+	    dev->irq_managed && dev->irq > 0) {
 		mp_unmap_irq(dev->irq);
 		dev->irq = 0;
+		dev->irq_managed = 0;
 	}
 }
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index c96887d5289e..4a89701dfe36 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -413,6 +413,9 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		return 0;
 	}
 
+	if (dev->irq_managed && dev->irq > 0)
+		return 0;
+
 	entry = acpi_pci_irq_lookup(dev, pin);
 	if (!entry) {
 		/*
@@ -456,6 +459,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 		return rc;
 	}
 	dev->irq = rc;
+	dev->irq_managed = 1;
 
 	if (link)
 		snprintf(link_desc, sizeof(link_desc), " -> Link[%s]", link);
@@ -478,7 +482,7 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	u8 pin;
 
 	pin = dev->pin;
-	if (!pin)
+	if (!pin || !dev->irq_managed || dev->irq <= 0)
 		return;
 
 	/* Keep IOAPIC pin configuration when suspending */
@@ -502,6 +506,9 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	 */
 
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
-	if (gsi >= 0 && dev->irq > 0)
+	if (gsi >= 0) {
 		acpi_unregister_gsi(gsi);
+		dev->irq = 0;
+		dev->irq_managed = 0;
+	}
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 61978a460841..3e0b92715512 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -347,6 +347,7 @@ struct pci_dev {
 	unsigned int	__aer_firmware_first:1;
 	unsigned int	broken_intx_masking:1;
 	unsigned int	io_window_1k:1;	/* Intel P2P bridge 1K I/O windows */
+	unsigned int	irq_managed:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
-- 
1.7.10.4

