Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbbATDLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:11:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:54223 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbbATDLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:11:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442529501"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v7 24/38] x86/MSI: Simplify the way to deal with remapped MSI interrupts
Date: Tue, 20 Jan 2015 11:08:27 +0800
Message-Id: <1421723321-8386-25-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the way to deal with remapped MSI interrupts, so we could
kill irq_chip.irq_print_chip later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416894816-23245-25-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/msi.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 2bf13484fbfd..8e8f2435f25e 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -77,7 +77,6 @@ static struct irq_chip pci_msi_controller = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
-	.irq_print_chip		= irq_remapping_print_chip,
 	.irq_compose_msi_msg	= irq_msi_compose_msg,
 	.irq_write_msi_msg	= pci_msi_domain_write_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
@@ -143,7 +142,7 @@ static struct msi_domain_ops pci_msi_domain_ops = {
 
 static struct msi_domain_info pci_msi_domain_info = {
 	.flags		= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-			  MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX,
+			  MSI_FLAG_PCI_MSIX,
 	.ops		= &pci_msi_domain_ops,
 	.chip		= &pci_msi_controller,
 	.handler	= handle_edge_irq,
@@ -162,9 +161,29 @@ void arch_init_msi_domain(struct irq_domain *parent)
 }
 
 #ifdef CONFIG_IRQ_REMAP
+static struct irq_chip pci_msi_ir_controller = {
+	.name			= "IR-PCI-MSI",
+	.irq_unmask		= pci_msi_unmask_irq,
+	.irq_mask		= pci_msi_mask_irq,
+	.irq_ack		= irq_chip_ack_parent,
+	.irq_set_affinity	= msi_domain_set_affinity,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_write_msi_msg	= pci_msi_domain_write_msg,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
+static struct msi_domain_info pci_msi_ir_domain_info = {
+	.flags		= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
+			  MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX,
+	.ops		= &pci_msi_domain_ops,
+	.chip		= &pci_msi_ir_controller,
+	.handler	= handle_edge_irq,
+	.handler_name	= "edge",
+};
+
 struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 {
-	return msi_create_irq_domain(NULL, &pci_msi_domain_info, parent);
+	return pci_msi_create_irq_domain(NULL, &pci_msi_ir_domain_info, parent);
 }
 #endif
 
@@ -325,7 +344,6 @@ static struct irq_chip hpet_msi_controller = {
 	.irq_ack = irq_chip_ack_parent,
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
-	.irq_print_chip = irq_remapping_print_chip,
 	.irq_compose_msi_msg = irq_msi_compose_msg,
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
@@ -402,6 +420,8 @@ struct irq_domain *hpet_create_irq_domain(int hpet_id)
 	parent = irq_remapping_get_ir_irq_domain(&info);
 	if (parent == NULL)
 		parent = x86_vector_domain;
+	else
+		hpet_msi_controller.name = "IR-HPET-MSI";
 
 	return irq_domain_add_hierarchy(parent, 0, 0, NULL, &hpet_domain_ops,
 					(void *)(long)hpet_id);
-- 
1.7.10.4

