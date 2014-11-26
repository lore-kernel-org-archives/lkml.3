Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaKZXHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:07:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbaKZXHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:07:33 -0500
Date: Wed, 26 Nov 2014 15:06:41 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-9d022961a12205a64c077d22312fb5832ccd6c72@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de, yinghai@kernel.org,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net, tony.luck@intel.com,
        jiang.liu@linux.intel.com, bp@alien8.de, rdunlap@infradead.org,
        joro@8bytes.org, bhelgaas@google.com, hpa@zytor.com
Reply-To: rjw@rjwysocki.net, joro@8bytes.org, bhelgaas@google.com,
        hpa@zytor.com, tony.luck@intel.com, jiang.liu@linux.intel.com,
        bp@alien8.de, rdunlap@infradead.org, benh@kernel.crashing.org,
        konrad.wilk@oracle.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <1416894816-23245-5-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-5-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, MSI: Use new irqdomain interfaces to allocate
 /free IRQ
Git-Commit-ID: 9d022961a12205a64c077d22312fb5832ccd6c72
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

Commit-ID:  9d022961a12205a64c077d22312fb5832ccd6c72
Gitweb:     http://git.kernel.org/tip/9d022961a12205a64c077d22312fb5832ccd6c72
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:13 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:24 +0100

x86, MSI: Use new irqdomain interfaces to allocate/free IRQ

Use new irqdomain interfaces to allocate/free IRQ for PCI MSI, so we
could kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

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
Link: http://lkml.kernel.org/r/1416894816-23245-5-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/msi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index d6ba2d6..76cc2c9 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -14,6 +14,7 @@
 #include <linux/dmar.h>
 #include <linux/hpet.h>
 #include <linux/msi.h>
+#include <linux/irqdomain.h>
 #include <asm/msidef.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
@@ -146,23 +147,20 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *msidesc;
-	unsigned int irq;
-	int node, ret;
+	int irq, ret;
 
 	/* Multiple MSI vectors only supported with interrupt remapping */
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
 
-	node = dev_to_node(&dev->dev);
-
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = irq_alloc_hwirq(node);
-		if (!irq)
+		irq = irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
+		if (irq <= 0)
 			return -ENOSPC;
 
 		ret = setup_msi_irq(dev, msidesc, irq, 0);
 		if (ret < 0) {
-			irq_free_hwirq(irq);
+			irq_domain_free_irqs(irq, 1);
 			return ret;
 		}
 
@@ -172,7 +170,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 void native_teardown_msi_irq(unsigned int irq)
 {
-	irq_free_hwirq(irq);
+	irq_domain_free_irqs(irq, 1);
 }
 
 #ifdef CONFIG_DMAR_TABLE
