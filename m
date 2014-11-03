Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaKCLBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:01:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaKCLA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:00:57 -0500
Date: Mon, 3 Nov 2014 02:59:45 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-5dfaa804e3e25317b4e55cd67117ac5b33e01004@git.kernel.org>
Cc: joro@8bytes.org, konrad.wilk@oracle.com, tglx@linutronix.de,
        bhelgaas@google.com, gregkh@linuxfoundation.org, yinghai@kernel.org,
        jiang.liu@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, rdunlap@infradead.org, mingo@kernel.org,
        bp@alien8.de, lenb@kernel.org, benh@kernel.crashing.org,
        rjw@rjwysocki.net
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, konrad.wilk@oracle.com,
        bhelgaas@google.com, tglx@linutronix.de, joro@8bytes.org,
        jiang.liu@linux.intel.com, gregkh@linuxfoundation.org,
        yinghai@kernel.org, bp@alien8.de, benh@kernel.crashing.org,
        lenb@kernel.org, rjw@rjwysocki.net, tony.luck@intel.com,
        rdunlap@infradead.org, mingo@kernel.org
In-Reply-To: <1414387308-27148-13-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-13-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Keep balance of IOAPIC pin reference count
Git-Commit-ID: 5dfaa804e3e25317b4e55cd67117ac5b33e01004
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dfaa804e3e25317b4e55cd67117ac5b33e01004
Gitweb:     http://git.kernel.org/tip/5dfaa804e3e25317b4e55cd67117ac5b33e01004
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:42 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:08 +0100

x86, irq: Keep balance of IOAPIC pin reference count

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
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <lenb@kernel.org>
Link: http://lkml.kernel.org/r/1414387308-27148-13-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/intel_mid_pci.c | 10 +++++++++-
 arch/x86/pci/irq.c           |  7 ++++++-
 drivers/acpi/pci_irq.c       | 11 +++++++++--
 include/linux/pci.h          |  1 +
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index b9958c3..44b9271 100644
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
@@ -224,13 +227,18 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	if (mp_map_gsi_to_irq(dev->irq, IOAPIC_MAP_ALLOC) < 0)
 		return -EBUSY;
 
+	dev->irq_managed = 1;
+
 	return 0;
 }
 
 static void intel_mid_pci_irq_disable(struct pci_dev *dev)
 {
-	if (!mp_should_keep_irq(&dev->dev) && dev->irq > 0)
+	if (!mp_should_keep_irq(&dev->dev) && dev->irq_managed &&
+	    dev->irq > 0) {
 		mp_unmap_irq(dev->irq);
+		dev->irq_managed = 0;
+	}
 }
 
 struct pci_ops intel_mid_pci_ops = {
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index eb500c2..a47e2de 100644
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
 	if (io_apic_assign_pci_irqs && !mp_should_keep_irq(&dev->dev) &&
-	    dev->irq) {
+	    dev->irq_managed && dev->irq) {
 		mp_unmap_irq(dev->irq);
 		dev->irq = 0;
+		dev->irq_managed = 0;
 	}
 }
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 6e6b80e..5f1fdca 100644
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
@@ -506,6 +510,9 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
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
index 5be8db4..2a8c405 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -348,6 +348,7 @@ struct pci_dev {
 	unsigned int	__aer_firmware_first:1;
 	unsigned int	broken_intx_masking:1;
 	unsigned int	io_window_1k:1;	/* Intel P2P bridge 1K I/O windows */
+	unsigned int	irq_managed:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
