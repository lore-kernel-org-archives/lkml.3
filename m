Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbaJ1IZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:25:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:53983 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399AbaJ1IZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:25:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,801,1406617200"; 
   d="scan'208";a="597493800"
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
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch Part2 v3 06/24] x86, MSI: Use new irqdomain interfaces to allocate/free IRQ
Date: Tue, 28 Oct 2014 16:26:24 +0800
Message-Id: <1414484803-10311-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new irqdomain interfaces to allocate/free IRQ for MSI, so we could
kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/msi.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 6916246294eb..7e45991c0e79 100644
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
-- 
1.7.10.4

