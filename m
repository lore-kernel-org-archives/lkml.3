Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbbATDHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:07:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:33476 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbbATDHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:07:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442528482"
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
Subject: [Patch Part1 v7 06/38] x86/htirq: Use new irqdomain interfaces to allocate/free IRQ
Date: Tue, 20 Jan 2015 11:08:09 +0800
Message-Id: <1421723321-8386-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new irqdomain interfaces to allocate/free IRQ for HTIRQ, so we could
kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

This patch changes the interfaces between arch independent PCI driver
and arch specific code. Currently HT_IRQ is only enabled on x86, so it
shouldn't break other architectures.

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
Link: http://lkml.kernel.org/r/1416894816-23245-7-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/htirq.c |   26 +++++++++++++-------------
 drivers/pci/htirq.c          |    7 +++----
 include/linux/htirq.h        |    2 ++
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index 816f36e979ad..b307ee7a7148 100644
--- a/arch/x86/kernel/apic/htirq.c
+++ b/arch/x86/kernel/apic/htirq.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/pci.h>
 #include <linux/htirq.h>
+#include <linux/irqdomain.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
 #include <asm/hypertransport.h>
@@ -61,31 +62,30 @@ static struct irq_chip ht_irq_chip = {
 	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
+int arch_alloc_ht_irq(struct pci_dev *dev)
+{
+	return irq_domain_alloc_irqs(NULL, 1, dev_to_node(&dev->dev), NULL);
+}
+
+void arch_free_ht_irq(int irq)
+{
+	irq_domain_free_irqs(irq, 1);
+}
+
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
 	struct irq_cfg *cfg;
 	struct ht_irq_msg msg;
-	unsigned dest;
-	int err;
 
 	if (disable_apic)
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(cfg->domain,
-					   apic->target_cpus(), &dest);
-	if (err)
-		return err;
-
-	msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
+	msg.address_hi = HT_IRQ_HIGH_DEST_ID(cfg->dest_apicid);
 
 	msg.address_lo =
 		HT_IRQ_LOW_BASE |
-		HT_IRQ_LOW_DEST_ID(dest) |
+		HT_IRQ_LOW_DEST_ID(cfg->dest_apicid) |
 		HT_IRQ_LOW_VECTOR(cfg->vector) |
 		((apic->irq_dest_mode == 0) ?
 			HT_IRQ_LOW_DM_PHYSICAL :
diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index a94dd2c4183a..ceb0ebeb7b5f 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -117,8 +117,8 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
-	irq = irq_alloc_hwirq(dev_to_node(&dev->dev));
-	if (!irq) {
+	irq = arch_alloc_ht_irq(dev);
+	if (irq <= 0) {
 		kfree(cfg);
 		return -EBUSY;
 	}
@@ -163,8 +163,7 @@ void ht_destroy_irq(unsigned int irq)
 	cfg = irq_get_handler_data(irq);
 	irq_set_chip(irq, NULL);
 	irq_set_handler_data(irq, NULL);
-	irq_free_hwirq(irq);
-
+	arch_free_ht_irq(irq);
 	kfree(cfg);
 }
 EXPORT_SYMBOL(ht_destroy_irq);
diff --git a/include/linux/htirq.h b/include/linux/htirq.h
index 70a1dbbf2093..5caa51b7b95c 100644
--- a/include/linux/htirq.h
+++ b/include/linux/htirq.h
@@ -15,6 +15,8 @@ void unmask_ht_irq(struct irq_data *data);
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
+int arch_alloc_ht_irq(struct pci_dev *dev);
+void arch_free_ht_irq(int irq);
 
 /* For drivers of buggy hardware */
 typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
-- 
1.7.10.4

