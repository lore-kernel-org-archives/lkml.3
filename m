Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483Ab3BHT3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:29:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33663 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463Ab3BHT3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:29:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 04/26] x86, irq: Show MSI-X in /proc/interrupt
Date: Fri,  8 Feb 2013 11:28:01 -0800
Message-Id: <1360351703-20571-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now MSI-X is shown as MSI in /proc/interrupt.

We could use new added irq_print_chip() interface to append -X for MSI-X.

-v2: do not need to check if msi_desc is null in msi_irq_print_chip().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c |    7 +++++++
 drivers/iommu/irq_remapping.c  |    5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 059589f..f8d4d8d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3087,6 +3087,12 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
+static void msi_irq_print_chip(struct irq_data *data, struct seq_file *p)
+{
+	seq_printf(p, " %s%s", data->chip->name,
+			data->msi_desc->msi_attrib.is_msix ? "-X" : "");
+}
+
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
@@ -3098,6 +3104,7 @@ struct irq_chip msi_chip = {
 	.irq_ack		= ack_apic_edge,
 	.irq_set_affinity	= msi_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.irq_print_chip		= msi_irq_print_chip,
 };
 
 int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 33918c3..e245ab0 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -365,7 +365,10 @@ static void ir_ack_apic_level(struct irq_data *data)
 
 static void ir_print_prefix(struct irq_data *data, struct seq_file *p)
 {
-	seq_printf(p, " IR-%s", data->chip->name);
+	seq_printf(p, " IR-%s%s", data->chip->name,
+			data->msi_desc ?
+			 (data->msi_desc->msi_attrib.is_msix ? "-X" : "")
+			 : "");
 }
 
 static void __init irq_remap_modify_chip_defaults(struct irq_chip *chip)
-- 
1.7.10.4

