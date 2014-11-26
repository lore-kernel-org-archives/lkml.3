Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaKZXLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:11:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58373 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaKZXLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:11:12 -0500
Date: Wed, 26 Nov 2014 15:10:19 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-052a2081707e21677516602c573f6136de6ab077@git.kernel.org>
Cc: joro@8bytes.org, benh@kernel.crashing.org, bp@alien8.de,
        yinghai@kernel.org, konrad.wilk@oracle.com, tony.luck@intel.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        rdunlap@infradead.org, rjw@rjwysocki.net, wangyijing@huawei.com,
        gregkh@linuxfoundation.org, bhelgaas@google.com,
        jiang.liu@linux.intel.com, tglx@linutronix.de
Reply-To: rjw@rjwysocki.net, wangyijing@huawei.com, bhelgaas@google.com,
        gregkh@linuxfoundation.org, jiang.liu@linux.intel.com,
        tglx@linutronix.de, bp@alien8.de, joro@8bytes.org,
        benh@kernel.crashing.org, tony.luck@intel.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, rdunlap@infradead.org
In-Reply-To: <1416894816-23245-19-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-19-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Clean up unused MSI related code and interfaces
Git-Commit-ID: 052a2081707e21677516602c573f6136de6ab077
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

Commit-ID:  052a2081707e21677516602c573f6136de6ab077
Gitweb:     http://git.kernel.org/tip/052a2081707e21677516602c573f6136de6ab077
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:27 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:25 +0100

x86, irq: Clean up unused MSI related code and interfaces

Now MSI interrupt has been converted to new hierarchy irqdomain
interfaces, so kill legacy MSI related code and interfaces.

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
Cc: Yijing Wang <wangyijing@huawei.com>
Link: http://lkml.kernel.org/r/1416894816-23245-19-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hpet.h     |  9 -------
 arch/x86/include/asm/x86_init.h |  4 ---
 arch/x86/kernel/apic/msi.c      | 55 +++--------------------------------------
 3 files changed, 4 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index e87e9fa..5fa9fb0 100644
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
index f58a9c7..1649bb9 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -175,13 +175,9 @@ struct msi_msg;
 
 struct x86_msi_ops {
 	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
-	void (*compose_msi_msg)(struct pci_dev *dev, unsigned int irq,
-				unsigned int dest, struct msi_msg *msg,
-			       u8 hpet_id);
 	void (*teardown_msi_irq)(unsigned int irq);
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
 	void (*restore_msi_irqs)(struct pci_dev *dev);
-	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 };
 
 struct IO_APIC_route_entry;
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index fa2dd6e..afaaa11 100644
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
 /*
  * IRQ Chip for MSI PCI/PCI-X/PCI-Express Devices,
  * which implement the MSI or MSI-X Capability Structure.
@@ -262,7 +233,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 	struct msi_msg msg;
 	struct irq_cfg *cfg = irq_cfg(irq);
 
-	native_compose_msi_msg(NULL, irq, cfg->dest_apicid, &msg, -1);
+	native_compose_msi_msg(cfg, &msg);
 	dmar_msi_write(irq, &msg);
 	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
 				      "edge");
@@ -318,24 +289,6 @@ static struct irq_chip hpet_msi_controller = {
 	.flags = IRQCHIP_SKIP_SET_WAKE,
 };
 
-int default_setup_hpet_msi(unsigned int irq, unsigned int id)
-{
-	struct irq_chip *chip = &hpet_msi_controller;
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
