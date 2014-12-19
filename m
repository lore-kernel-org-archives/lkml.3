Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaLSOE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:04:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaLSOE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:04:56 -0500
Date: Fri, 19 Dec 2014 06:04:03 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, lenb@kernel.org,
        gregkh@linuxfoundation.org, konrad.wilk@oracle.com, mingo@kernel.org,
        yinghai@kernel.org, rdunlap@infradead.org, hpa@zytor.com,
        rjw@rjwysocki.net, tglx@linutronix.de, tony.luck@intel.com,
        joro@8bytes.org, jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        bhelgaas@google.com
Reply-To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, bp@alien8.de, konrad.wilk@oracle.com,
        mingo@kernel.org, rdunlap@infradead.org, yinghai@kernel.org,
        hpa@zytor.com, rjw@rjwysocki.net, tglx@linutronix.de,
        benh@kernel.crashing.org, bhelgaas@google.com, joro@8bytes.org,
        tony.luck@intel.com, jiang.liu@linux.intel.com
In-Reply-To: <1414387308-27148-13-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-13-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Keep balance of IOAPIC pin reference count
Git-Commit-ID: cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687
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

Commit-ID:  cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687
Gitweb:     http://git.kernel.org/tip/cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:42 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:15 +0100

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
index cb50e28..9988458 100644
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
@@ -1269,8 +1273,9 @@ bool mp_should_keep_irq(struct device *dev)
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
index a523cee..c888c5e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -349,6 +349,7 @@ struct pci_dev {
 	unsigned int	__aer_firmware_first:1;
 	unsigned int	broken_intx_masking:1;
 	unsigned int	io_window_1k:1;	/* Intel P2P bridge 1K I/O windows */
+	unsigned int	irq_managed:1;
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
