Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaHLHEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:04:44 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:42454 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbaHLHD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:03:29 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, <linux-pci@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <arnab.basu@freescale.com>,
        <x86@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 18/20] Sparc/MSI: Use msi_chip instead of arch func to configure MSI/MSI-X
Date: Tue, 12 Aug 2014 15:26:11 +0800
Message-ID: <1407828373-24322-19-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407828373-24322-1-git-send-email-wangyijing@huawei.com>
References: <1407828373-24322-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new struct msi_chip sparc_msi_chip instead of weak arch
functions to configure MSI/MSI-X.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/sparc/kernel/pci.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 857ad77..9eabd22 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -839,18 +839,18 @@ int pci_domain_nr(struct pci_bus *pbus)
 EXPORT_SYMBOL(pci_domain_nr);
 
 #ifdef CONFIG_PCI_MSI
-int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
+int sparc_setup_msi_irq(struct device *dev, struct msi_desc *desc)
 {
-	struct pci_pbm_info *pbm = pdev->dev.archdata.host_controller;
+	struct pci_pbm_info *pbm = dev->archdata.host_controller;
 	unsigned int irq;
 
 	if (!pbm->setup_msi_irq)
 		return -EINVAL;
 
-	return pbm->setup_msi_irq(&irq, pdev, desc);
+	return pbm->setup_msi_irq(&irq, to_pci_dev(dev), desc);
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+void sparc_teardown_msi_irq(unsigned int irq)
 {
 	struct msi_desc *entry = irq_get_msi_desc(irq);
 	struct pci_dev *pdev = entry->dev;
@@ -859,6 +859,16 @@ void arch_teardown_msi_irq(unsigned int irq)
 	if (pbm->teardown_msi_irq)
 		pbm->teardown_msi_irq(irq, pdev);
 }
+
+struct msi_chip sparc_msi_chip = {
+	.setup_irq = sparc_setup_msi_irq,
+	.teardown_irq = sparc_teardown_msi_irq,
+};
+
+struct msi_chip *arch_get_match_msi_chip(struct device *dev)
+{
+	return &sparc_msi_chip;
+}
 #endif /* !(CONFIG_PCI_MSI) */
 
 static void ali_sound_dma_hack(struct pci_dev *pdev, int set_bit)
-- 
1.7.1

