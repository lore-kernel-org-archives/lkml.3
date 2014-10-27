Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaJ0IJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:09:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:13492 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaJ0IJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:09:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="621212629"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ryan Desfosses <ryan@desfo.org>,
        Quentin Lambert <lambert.quentin@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v3 03/20] x86, irq: Kill fourth parameter of IO_APIC_get_PCI_irq_vector()
Date: Mon, 27 Oct 2014 16:11:54 +0800
Message-Id: <1414397531-28254-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the fourth parameter of IO_APIC_get_PCI_irq_vector() is useless,
so kill it.  Assume it's only used by ibmphp PCI hotplug driver
though IO_APIC_get_PCI_irq_vector() has been exported,

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h     |    2 +-
 arch/x86/kernel/apic/io_apic.c    |   13 +++----------
 arch/x86/pci/irq.c                |    6 ++----
 drivers/pci/hotplug/ibmphp_core.c |    5 +----
 4 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 4615906d83df..64330c2e172e 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -158,7 +158,7 @@ extern void send_cleanup_vector(struct irq_cfg *);
 struct irq_data;
 int __ioapic_set_affinity(struct irq_data *, const struct cpumask *,
 			  unsigned int *dest_id);
-extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin, struct io_apic_irq_attr *irq_attr);
+extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin);
 extern void setup_ioapic_dest(void);
 
 extern void enable_IO_APIC(void);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index df3858de3031..117ec58fff02 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1179,8 +1179,7 @@ void mp_unmap_irq(int irq)
  * Find a specific PCI IRQ entry.
  * Not an __init, possibly needed by modules
  */
-int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
-				struct io_apic_irq_attr *irq_attr)
+int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 {
 	int irq, i, best_ioapic = -1, best_idx = -1;
 
@@ -1234,14 +1233,8 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 		return -1;
 
 out:
-	irq = pin_2_irq(best_idx, best_ioapic, mp_irqs[best_idx].dstirq,
-			IOAPIC_MAP_ALLOC);
-	if (irq > 0)
-		set_io_apic_irq_attr(irq_attr, best_ioapic,
-				     mp_irqs[best_idx].dstirq,
-				     irq_trigger(best_idx),
-				     irq_polarity(best_idx));
-	return irq;
+	return pin_2_irq(best_idx, best_ioapic, mp_irqs[best_idx].dstirq,
+			 IOAPIC_MAP_ALLOC);
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index a47e2dea0972..7765b3facd4b 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1200,14 +1200,12 @@ static int pirq_enable_irq(struct pci_dev *dev)
 #ifdef CONFIG_X86_IO_APIC
 			struct pci_dev *temp_dev;
 			int irq;
-			struct io_apic_irq_attr irq_attr;
 
 			if (dev->irq_managed && dev->irq > 0)
 				return 0;
 
 			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
-						PCI_SLOT(dev->devfn),
-						pin - 1, &irq_attr);
+						PCI_SLOT(dev->devfn), pin - 1);
 			/*
 			 * Busses behind bridges are typically not listed in the MP-table.
 			 * In this case we have to look up the IRQ based on the parent bus,
@@ -1221,7 +1219,7 @@ static int pirq_enable_irq(struct pci_dev *dev)
 				pin = pci_swizzle_interrupt_pin(dev, pin);
 				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 						PCI_SLOT(bridge->devfn),
-						pin - 1, &irq_attr);
+						pin - 1);
 				if (irq >= 0)
 					dev_warn(&dev->dev, "using bridge %s "
 						 "INT %c to get IRQ %d\n",
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 3efaf4c38528..d261e623541f 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -155,13 +155,10 @@ int ibmphp_init_devno(struct slot **cur_slot)
 	for (loop = 0; loop < len; loop++) {
 		if ((*cur_slot)->number == rtable->slots[loop].slot &&
 		    (*cur_slot)->bus == rtable->slots[loop].bus) {
-			struct io_apic_irq_attr irq_attr;
-
 			(*cur_slot)->device = PCI_SLOT(rtable->slots[loop].devfn);
 			for (i = 0; i < 4; i++)
 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
-						(int) (*cur_slot)->device, i,
-						&irq_attr);
+						(int) (*cur_slot)->device, i);
 
 			debug("(*cur_slot)->irq[0] = %x\n",
 					(*cur_slot)->irq[0]);
-- 
1.7.10.4

