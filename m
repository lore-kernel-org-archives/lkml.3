Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaKIPJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 10:09:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:62888 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaKIPJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 10:09:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,346,1413270000"; 
   d="scan'208";a="604933151"
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
Subject: [RFC Part4 v1 09/17] x86, irq: Simplify MSI/DMAR/HPET implementation by using common code
Date: Sun,  9 Nov 2014 23:10:31 +0800
Message-Id: <1415545839-28263-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common code to simplify MSI/DMAR/HPET driver implementation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |   81 ++++----------------------------------------
 1 file changed, 6 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 842d71699912..f625c2f21377 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -140,23 +140,6 @@ struct irq_domain *arch_create_msi_irq_domain(struct irq_domain *parent)
 #endif
 
 #ifdef CONFIG_DMAR_TABLE
-static int
-dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		      bool force)
-{
-	struct irq_data *parent = data->parent_data;
-	struct msi_msg msg;
-	int ret;
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret >= 0) {
-		irq_chip_compose_msi_msg(data, &msg);
-		dmar_msi_write(data->irq, &msg);
-	}
-
-	return ret;
-}
-
 static void dmar_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	dmar_msi_write(data->irq, msg);
@@ -167,7 +150,7 @@ static struct irq_chip dmar_msi_type = {
 	.irq_unmask		= dmar_msi_unmask,
 	.irq_mask		= dmar_msi_mask,
 	.irq_ack		= irq_chip_ack_parent,
-	.irq_set_affinity	= dmar_msi_set_affinity,
+	.irq_set_affinity	= msi_domain_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg	= msi_compose_msg,
 	.irq_write_msi_msg	= dmar_msi_write_msg,
@@ -205,29 +188,11 @@ static void dmar_domain_free(struct irq_domain *domain, unsigned int virq,
 	irq_domain_free_irqs_top(domain, virq, nr_irqs);
 }
 
-static void dmar_domain_activate(struct irq_domain *domain,
-				 struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
-	dmar_msi_write(irq_data->irq, &msg);
-}
-
-static void dmar_domain_deactivate(struct irq_domain *domain,
-				   struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	memset(&msg, 0, sizeof(msg));
-	dmar_msi_write(irq_data->irq, &msg);
-}
-
 static struct irq_domain_ops dmar_domain_ops = {
 	.alloc = dmar_domain_alloc,
 	.free = dmar_domain_free,
-	.activate = dmar_domain_activate,
-	.deactivate = dmar_domain_deactivate,
+	.activate = msi_domain_activate,
+	.deactivate = msi_domain_deactivate,
 };
 
 static struct irq_domain *dmar_get_irq_domain(void)
@@ -277,22 +242,6 @@ static inline int hpet_dev_id(struct irq_domain *domain)
 	return (int)(long)domain->host_data;
 }
 
-static int hpet_msi_set_affinity(struct irq_data *data,
-				 const struct cpumask *mask, bool force)
-{
-	struct irq_data *parent = data->parent_data;
-	struct msi_msg msg;
-	int ret;
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
-		irq_chip_compose_msi_msg(data, &msg);
-		hpet_msi_write(data->handler_data, &msg);
-	}
-
-	return ret;
-}
-
 static void hpet_msi_write_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	hpet_msi_write(data->handler_data, msg);
@@ -303,7 +252,7 @@ static struct irq_chip hpet_msi_type = {
 	.irq_unmask = hpet_msi_unmask,
 	.irq_mask = hpet_msi_mask,
 	.irq_ack = irq_chip_ack_parent,
-	.irq_set_affinity = hpet_msi_set_affinity,
+	.irq_set_affinity = msi_domain_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_compose_msi_msg = msi_compose_msg,
 	.irq_write_msi_msg = hpet_msi_write_msg,
@@ -343,29 +292,11 @@ static void hpet_domain_free(struct irq_domain *domain, unsigned int virq,
 	irq_domain_free_irqs_top(domain, virq, nr_irqs);
 }
 
-static void hpet_domain_activate(struct irq_domain *domain,
-				struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	BUG_ON(irq_chip_compose_msi_msg(irq_data, &msg));
-	hpet_msi_write(irq_get_handler_data(irq_data->irq), &msg);
-}
-
-static void hpet_domain_deactivate(struct irq_domain *domain,
-				  struct irq_data *irq_data)
-{
-	struct msi_msg msg;
-
-	memset(&msg, 0, sizeof(msg));
-	hpet_msi_write(irq_get_handler_data(irq_data->irq), &msg);
-}
-
 static struct irq_domain_ops hpet_domain_ops = {
 	.alloc = hpet_domain_alloc,
 	.free = hpet_domain_free,
-	.activate = hpet_domain_activate,
-	.deactivate = hpet_domain_deactivate,
+	.activate = msi_domain_activate,
+	.deactivate = msi_domain_deactivate,
 };
 
 struct irq_domain *hpet_create_irq_domain(int hpet_id)
-- 
1.7.10.4

