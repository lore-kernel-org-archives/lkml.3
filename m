Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaKZXMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:12:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaKZXMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:12:39 -0500
Date: Wed, 26 Nov 2014 15:11:51 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-7fa48d748b0871b91263b57a0ca119a7e972d29a@git.kernel.org>
Cc: hpa@zytor.com, bp@alien8.de, rdunlap@infradead.org, mingo@kernel.org,
        gregkh@linuxfoundation.org, tony.luck@intel.com, joro@8bytes.org,
        konrad.wilk@oracle.com, bhelgaas@google.com, rjw@rjwysocki.net,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, yinghai@kernel.org
Reply-To: tony.luck@intel.com, joro@8bytes.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, rjw@rjwysocki.net, bhelgaas@google.com,
        hpa@zytor.com, bp@alien8.de, rdunlap@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, benh@kernel.crashing.org
In-Reply-To: <1416894816-23245-25-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-25-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, PCI/MSI:
  Simplify the way to deal with remapped MSI interrupts
Git-Commit-ID: 7fa48d748b0871b91263b57a0ca119a7e972d29a
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

Commit-ID:  7fa48d748b0871b91263b57a0ca119a7e972d29a
Gitweb:     http://git.kernel.org/tip/7fa48d748b0871b91263b57a0ca119a7e972d29a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:33 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:26 +0100

x86, PCI/MSI: Simplify the way to deal with remapped MSI interrupts

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
 arch/x86/kernel/apic/msi.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 2bf1348..8e8f243 100644
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
