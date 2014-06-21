Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbaFUVSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:18:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbaFUVSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:18:37 -0400
Date: Sat, 21 Jun 2014 14:17:37 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-c03b3b0738a56cf283b0d05256988d5e3c8bd719@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        hpa@zytor.com, jiang.liu@linux.intel.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, joro@8bytes.org,
        benh@kernel.crashing.org, bhelgaas@google.com, rjw@rjwysocki.net,
        paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-40-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-40-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, mpparse:
  Release IOAPIC pin when PCI device is disabled
Git-Commit-ID: c03b3b0738a56cf283b0d05256988d5e3c8bd719
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

Commit-ID:  c03b3b0738a56cf283b0d05256988d5e3c8bd719
Gitweb:     http://git.kernel.org/tip/c03b3b0738a56cf283b0d05256988d5e3c8bd719
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:20:08 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:44 +0200

x86, irq, mpparse: Release IOAPIC pin when PCI device is disabled

Release IOAPIC pin associated with PCI device when the PCI device
is disabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1402302011-23642-40-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/mpparse.c |  1 +
 arch/x86/pci/irq.c        | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index faf503a..fde86d2 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -115,6 +115,7 @@ static void __init MP_bus_info(struct mpc_bus *m)
 
 static struct irq_domain_ops mp_ioapic_irqdomain_ops = {
 	.map = mp_irqdomain_map,
+	.unmap = mp_irqdomain_unmap,
 };
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index e4200e5..748cfe8 100644
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
