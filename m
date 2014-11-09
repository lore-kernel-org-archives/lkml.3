Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaKIPIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:08:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:12114 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaKIPH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:07:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604932858"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part4 v1 03/17] x86, PCI/MSI: Simplify the way to deal with remapped MSI interrupts
Date: Sun,  9 Nov 2014 23:10:25 +0800
Message-Id: <1415545839-28263-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the way to deal with remapped MSI interrupts, so we could
kill irq_chip.irq_print_chip later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index adc76eba59bd..12919b3c6cf4 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -95,7 +95,6 @@ static struct irq_chip msi_chip = {
 	.irq_ack		= irq_chip_ack_parent,
 	.irq_set_affinity	= msi_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
-	.irq_print_chip		= irq_remapping_print_chip,
 	.irq_compose_msi_msg	= msi_compose_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
@@ -153,9 +152,19 @@ void arch_init_msi_domain(struct irq_domain *parent)
 }
 
 #ifdef CONFIG_IRQ_REMAP
+static struct irq_chip msi_ir_chip = {
+	.name			= "IR-PCI-MSI",
+	.irq_unmask		= unmask_msi_irq,
+	.irq_mask		= mask_msi_irq,
+	.irq_ack		= irq_chip_ack_parent,
+	.irq_set_affinity	= msi_set_affinity,
+	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
+};
+
 struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 {
-	return msi_create_irq_domain(NULL, &msi_chip, parent);
+	return msi_create_irq_domain(NULL, &msi_ir_chip, parent);
 }
 #endif
 
@@ -316,7 +325,6 @@ static struct irq_chip hpet_msi_type = {
 	.irq_ack = irq_chip_ack_parent,
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
-	.irq_print_chip = irq_remapping_print_chip,
 	.irq_compose_msi_msg = msi_compose_msg,
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
@@ -397,6 +405,8 @@ struct irq_domain *hpet_create_irq_domain(int hpet_id)
 		domain->parent = irq_remapping_get_ir_irq_domain(&info);
 		if (!domain->parent)
 			domain->parent = x86_vector_domain;
+		else
+			hpet_msi_type.name = "IR-HPET-MSI";
 	}
 
 	return domain;
-- 
1.7.10.4

