Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaKDMFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:05:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:42742 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbaKDMFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:05:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616768168"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch Part2 v4 27/31] x86, irq: Clean up unused MSI related code and interfaces
Date: Tue,  4 Nov 2014 20:02:01 +0800
Message-Id: <1415102525-9898-28-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now MSI interrupt has been converted to new hierarchy irqdomain
interfaces, so kill legacy MSI related code and interfaces.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hpet.h     |    9 ------
 arch/x86/include/asm/x86_init.h |    4 ---
 arch/x86/kernel/apic/msi.c      |   61 +++++----------------------------------
 3 files changed, 7 insertions(+), 67 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index e87e9faf87a9..5fa9fb0f8809 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -85,15 +85,6 @@ extern struct irq_domain *hpet_create_irq_domain(int hpet_id);
 extern int hpet_assign_irq(struct irq_domain *domain,
 			   struct hpet_dev *dev, int dev_num);
 
-#ifdef CONFIG_PCI_MSI
-extern int default_setup_hpet_msi(unsigned int irq, unsigned int id);
-#else
-static inline int default_setup_hpet_msi(unsigned int irq, unsigned int id)
-{
-	return -EINVAL;
-}
-#endif
-
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 #include <linux/interrupt.h>
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e45e4da96bf1..9b53cb2acfbb 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -176,13 +176,9 @@ struct msi_desc;
 
 struct x86_msi_ops {
 	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
-	void (*compose_msi_msg)(struct pci_dev *dev, unsigned int irq,
-				unsigned int dest, struct msi_msg *msg,
-			       u8 hpet_id);
 	void (*teardown_msi_irq)(unsigned int irq);
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
 	void (*restore_msi_irqs)(struct pci_dev *dev);
-	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
 	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
 };
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 265178b30816..6bfe85e96c74 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -25,16 +25,12 @@
 
 static struct irq_domain *msi_default_domain;
 
-void native_compose_msi_msg(struct pci_dev *pdev,
-			    unsigned int irq, unsigned int dest,
-			    struct msi_msg *msg, u8 hpet_id)
+static void native_compose_msi_msg(struct irq_cfg *cfg, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
-
 	msg->address_hi = MSI_ADDR_BASE_HI;
 
 	if (x2apic_enabled())
-		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
+		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
 
 	msg->address_lo =
 		MSI_ADDR_BASE_LO |
@@ -44,7 +40,7 @@ void native_compose_msi_msg(struct pci_dev *pdev,
 		((apic->irq_delivery_mode != dest_LowestPrio) ?
 			MSI_ADDR_REDIRECTION_CPU :
 			MSI_ADDR_REDIRECTION_LOWPRI) |
-		MSI_ADDR_DEST_ID(dest);
+		MSI_ADDR_DEST_ID(cfg->dest_apicid);
 
 	msg->data =
 		MSI_DATA_TRIGGER_EDGE |
@@ -55,7 +51,7 @@ void native_compose_msi_msg(struct pci_dev *pdev,
 		MSI_DATA_VECTOR(cfg->vector);
 }
 
-static void irq_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
+static void msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 {
 	struct irq_cfg *cfg = irqd_cfg(data);
 
@@ -93,31 +89,6 @@ static void msi_update_msg(struct msi_msg *msg, struct irq_data *irq_data)
 	msg->address_lo |= MSI_ADDR_DEST_ID(cfg->dest_apicid);
 }
 
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
-			   struct msi_msg *msg, u8 hpet_id)
-{
-	struct irq_cfg *cfg;
-	int err;
-	unsigned dest;
-
-	if (disable_apic)
-		return -ENXIO;
-
-	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain,
-					   apic->target_cpus(), &dest);
-	if (err)
-		return err;
-
-	x86_msi.compose_msi_msg(pdev, irq, dest, msg, hpet_id);
-
-	return 0;
-}
-
 static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			    bool force)
 {
@@ -148,7 +119,7 @@ struct irq_chip msi_chip = {
 	.irq_set_affinity	= msi_set_affinity,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
 	.irq_print_chip		= irq_remapping_print_chip,
-	.irq_compose_msi_msg	= irq_msi_compose_msg,
+	.irq_compose_msi_msg	= msi_compose_msg,
  	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
@@ -253,7 +224,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 	struct msi_msg msg;
 	struct irq_cfg *cfg = irq_cfg(irq);
 
-	native_compose_msi_msg(NULL, irq, cfg->dest_apicid, &msg, -1);
+	native_compose_msi_msg(cfg, &msg);
 	dmar_msi_write(irq, &msg);
 	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
 				      "edge");
@@ -305,28 +276,10 @@ static struct irq_chip hpet_msi_type = {
 	.irq_set_affinity = hpet_msi_set_affinity,
 	.irq_retrigger = irq_chip_retrigger_hierarchy,
 	.irq_print_chip = irq_remapping_print_chip,
-	.irq_compose_msi_msg = irq_msi_compose_msg,
+	.irq_compose_msi_msg = msi_compose_msg,
  	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
-int default_setup_hpet_msi(unsigned int irq, unsigned int id)
-{
-	struct irq_chip *chip = &hpet_msi_type;
-	struct msi_msg msg;
-	int ret;
-
-	ret = msi_compose_msg(NULL, irq, &msg, id);
-	if (ret < 0)
-		return ret;
-
-	hpet_msi_write(irq_get_handler_data(irq), &msg);
-	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
-	setup_remapped_irq(irq, irq_cfg(irq), chip);
-
-	irq_set_chip_and_handler_name(irq, chip, handle_edge_irq, "edge");
-	return 0;
-}
-
 static int hpet_domain_alloc(struct irq_domain *domain, unsigned int virq,
 			     unsigned int nr_irqs, void *arg)
 {
-- 
1.7.10.4

