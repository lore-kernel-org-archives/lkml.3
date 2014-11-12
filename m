Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaKLNp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:45:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:41682 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaKLNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:07 -0500
Message-Id: <20141112134120.664976447@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Subject: [patch 10/16] PCI/MSI: Move cached entry functions to irq core
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=PCI-MSI-Move-cached-entry-functions-to-irq-core.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Required to support non PCI based MSI.

[ tglx: Extracted from Jiangs patch series ]

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/pci/Kconfig |    1 +
 drivers/pci/msi.c   |   18 ------------------
 kernel/irq/msi.c    |   13 +++++++++++++
 3 files changed, 14 insertions(+), 18 deletions(-)

Index: tip/drivers/pci/Kconfig
===================================================================
--- tip.orig/drivers/pci/Kconfig
+++ tip/drivers/pci/Kconfig
@@ -4,6 +4,7 @@
 config PCI_MSI
 	bool "Message Signaled Interrupts (MSI and MSI-X)"
 	depends on PCI
+	select GENERIC_MSI_IRQ
 	help
 	   This allows device drivers to enable MSI (Message Signaled
 	   Interrupts).  Message Signaled Interrupts enable a device to
Index: tip/drivers/pci/msi.c
===================================================================
--- tip.orig/drivers/pci/msi.c
+++ tip/drivers/pci/msi.c
@@ -286,24 +286,6 @@ void read_msi_msg(unsigned int irq, stru
 	__read_msi_msg(entry, msg);
 }
 
-void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
-{
-	/* Assert that the cache is valid, assuming that
-	 * valid messages are not all-zeroes. */
-	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
-		 entry->msg.data));
-
-	*msg = entry->msg;
-}
-
-void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
-{
-	struct msi_desc *entry = irq_get_msi_desc(irq);
-
-	__get_cached_msi_msg(entry, msg);
-}
-EXPORT_SYMBOL_GPL(get_cached_msi_msg);
-
 void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 {
 	if (entry->dev->current_state != PCI_D0) {
Index: tip/kernel/irq/msi.c
===================================================================
--- tip.orig/kernel/irq/msi.c
+++ tip/kernel/irq/msi.c
@@ -13,6 +13,19 @@
 #include <linux/irqdomain.h>
 #include <linux/msi.h>
 
+void __get_cached_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
+{
+	*msg = entry->msg;
+}
+
+void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct msi_desc *entry = irq_get_msi_desc(irq);
+
+	__get_cached_msi_msg(entry, msg);
+}
+EXPORT_SYMBOL_GPL(get_cached_msi_msg);
+
 #ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
 int msi_domain_set_affinity(struct irq_data *irq_data,
 			    const struct cpumask *mask, bool force)


