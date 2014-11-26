Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaKZXII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:08:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaKZXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:08:06 -0500
Date: Wed, 26 Nov 2014 15:07:14 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-f30152929529a63ac7935b50116d0183f82b289d@git.kernel.org>
Cc: gregkh@linuxfoundation.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, jiang.liu@linux.intel.com, rdunlap@infradead.org,
        bp@alien8.de, rjw@rjwysocki.net, benh@kernel.crashing.org,
        mingo@kernel.org, bhelgaas@google.com, konrad.wilk@oracle.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, joro@8bytes.org
Reply-To: hpa@zytor.com, tony.luck@intel.com, jiang.liu@linux.intel.com,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, yinghai@kernel.org,
        bhelgaas@google.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, joro@8bytes.org,
        rjw@rjwysocki.net, bp@alien8.de, benh@kernel.crashing.org,
        mingo@kernel.org
In-Reply-To: <1416894816-23245-7-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-7-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, htirq:
  Use new irqdomain interfaces to allocate/free IRQ
Git-Commit-ID: f30152929529a63ac7935b50116d0183f82b289d
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

Commit-ID:  f30152929529a63ac7935b50116d0183f82b289d
Gitweb:     http://git.kernel.org/tip/f30152929529a63ac7935b50116d0183f82b289d
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:15 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:24 +0100

x86, htirq: Use new irqdomain interfaces to allocate/free IRQ

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
 arch/x86/kernel/apic/htirq.c | 26 +++++++++++++-------------
 drivers/pci/htirq.c          |  7 +++----
 include/linux/htirq.h        |  2 ++
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/apic/htirq.c b/arch/x86/kernel/apic/htirq.c
index 816f36e..b307ee7 100644
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
index a94dd2c..ceb0ebe 100644
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
index 70a1dbb..5caa51b 100644
--- a/include/linux/htirq.h
+++ b/include/linux/htirq.h
@@ -15,6 +15,8 @@ void unmask_ht_irq(struct irq_data *data);
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
+int arch_alloc_ht_irq(struct pci_dev *dev);
+void arch_free_ht_irq(int irq);
 
 /* For drivers of buggy hardware */
 typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
