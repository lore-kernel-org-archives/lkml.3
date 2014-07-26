Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaGZCno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:43:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:21119 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaGZCnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:41 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 01/11] PCI/MSI: Use pci_dev->msi_cap instead of msi_desc->msi_attrib.pos
Date: Sat, 26 Jul 2014 11:08:38 +0800
Message-ID: <1406344128-27055-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.53D315DB.00FE,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 58302deaf4bf45bec6723305c37a1377
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices save the msi and msix capability offset in pci_dev->msi_cap
and pci_dev->msix_cap. When we access PCI device MSI and MSIX
registers, we can use msi_cap and msix_cap in pci_dev directly.
Remove the pos member in msi_attrib.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/mips/pci/msi-octeon.c         |    4 ++--
 drivers/pci/host/pcie-designware.c |    2 +-
 drivers/pci/msi.c                  |    2 --
 include/linux/msi.h                |    1 -
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/mips/pci/msi-octeon.c b/arch/mips/pci/msi-octeon.c
index ab0c5d1..6a6a99f 100644
--- a/arch/mips/pci/msi-octeon.c
+++ b/arch/mips/pci/msi-octeon.c
@@ -73,7 +73,7 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 	 * wants.  Most devices only want 1, which will give
 	 * configured_private_bits and request_private_bits equal 0.
 	 */
-	pci_read_config_word(dev, desc->msi_attrib.pos + PCI_MSI_FLAGS,
+	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS,
 			     &control);
 
 	/*
@@ -176,7 +176,7 @@ msi_irq_allocated:
 	/* Update the number of IRQs the device has available to it */
 	control &= ~PCI_MSI_FLAGS_QSIZE;
 	control |= request_private_bits << 4;
-	pci_write_config_word(dev, desc->msi_attrib.pos + PCI_MSI_FLAGS,
+	pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS,
 			      control);
 
 	irq_set_msi_desc(irq, desc);
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 1eaf4df..04339cd 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -335,7 +335,7 @@ static int dw_msi_setup_irq(struct msi_chip *chip, struct pci_dev *pdev,
 		return -EINVAL;
 	}
 
-	pci_read_config_word(pdev, desc->msi_attrib.pos+PCI_MSI_FLAGS,
+	pci_read_config_word(pdev, pdev->msi_cap + PCI_MSI_FLAGS,
 				&msg_ctr);
 	msgvec = (msg_ctr&PCI_MSI_FLAGS_QSIZE) >> 4;
 	if (msgvec == 0)
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5a40516..e67acd1 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -595,7 +595,6 @@ static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
 	entry->msi_attrib.entry_nr	= 0;
 	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
 	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
-	entry->msi_attrib.pos		= dev->msi_cap;
 	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
 
 	if (control & PCI_MSI_FLAGS_64BIT)
@@ -699,7 +698,6 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.is_64		= 1;
 		entry->msi_attrib.entry_nr	= entries[i].entry;
 		entry->msi_attrib.default_irq	= dev->irq;
-		entry->msi_attrib.pos		= dev->msix_cap;
 		entry->mask_base		= base;
 
 		list_add_tail(&entry->list, &dev->msi_list);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8103f32..ce88c5b 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -29,7 +29,6 @@ struct msi_desc {
 		__u8	multi_cap : 3;	/* log2 num of messages supported */
 		__u8	maskbit	: 1;	/* mask-pending bit supported ? */
 		__u8	is_64	: 1;	/* Address size: 0=32bit 1=64bit */
-		__u8	pos;		/* Location of the msi capability */
 		__u16	entry_nr;	/* specific enabled entry */
 		unsigned default_irq;	/* default pre-assigned irq */
 	} msi_attrib;
-- 
1.7.1

