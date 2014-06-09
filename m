Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbaFIIYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:24:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:36977 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbaFIIYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352322027"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch V4 39/42] x86, irq, mpparse: release IOAPIC pin when PCI device is disabled
Date: Mon,  9 Jun 2014 16:20:08 +0800
Message-Id: <1402302011-23642-40-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release IOAPIC pin associated with PCI device when the PCI device
is disabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/mpparse.c |    1 +
 arch/x86/pci/irq.c        |   13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index faf503aa3b70..fde86d2b79f8 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -115,6 +115,7 @@ static void __init MP_bus_info(struct mpc_bus *m)
 
 static struct irq_domain_ops mp_ioapic_irqdomain_ops = {
 	.map = mp_irqdomain_map,
+	.unmap = mp_irqdomain_unmap,
 };
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index e4200e5e775e..748cfe8ab322 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -26,6 +26,7 @@ static int acer_tm360_irqrouting;
 static struct irq_routing_table *pirq_table;
 
 static int pirq_enable_irq(struct pci_dev *dev);
+static void pirq_disable_irq(struct pci_dev *dev);
 
 /*
  * Never use: 0, 1, 2 (timer, keyboard, and cascade)
@@ -53,7 +54,7 @@ struct irq_router_handler {
 };
 
 int (*pcibios_enable_irq)(struct pci_dev *dev) = pirq_enable_irq;
-void (*pcibios_disable_irq)(struct pci_dev *dev) = NULL;
+void (*pcibios_disable_irq)(struct pci_dev *dev) = pirq_disable_irq;
 
 /*
  *  Check passed address for the PCI IRQ Routing Table signature
@@ -1186,7 +1187,7 @@ void pcibios_penalize_isa_irq(int irq, int active)
 
 static int pirq_enable_irq(struct pci_dev *dev)
 {
-	u8 pin;
+	u8 pin = 0;
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin && !pcibios_lookup_irq(dev, 1)) {
@@ -1252,3 +1253,11 @@ static int pirq_enable_irq(struct pci_dev *dev)
 	}
 	return 0;
 }
+
+static void pirq_disable_irq(struct pci_dev *dev)
+{
+	if (io_apic_assign_pci_irqs && dev->irq) {
+		mp_unmap_irq(dev->irq);
+		dev->irq = 0;
+	}
+}
-- 
1.7.10.4

