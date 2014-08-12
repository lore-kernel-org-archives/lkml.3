Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaHLHDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:03:14 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:64829 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaHLHDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:03:08 -0400
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
Subject: [RFC PATCH 06/20] PCI/MSI: Introduce arch_get_match_msi_chip() to find the match msi_chip
Date: Tue, 12 Aug 2014 15:25:59 +0800
Message-ID: <1407828373-24322-7-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407828373-24322-1-git-send-email-wangyijing@huawei.com>
References: <1407828373-24322-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.53E9BC13.0072,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 72a3d6f8bb94c33bbdaf75d5b1c70beb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce __weak arch_get_match_msi_chip() to find the match msi_chip.
We prepare to use struct msi_chip to eliminate arch_xxx functions
in all platforms. The MSI device and the msi_chip binding is platform
specific. For instance, in x86, LAPICs receive all MSI irq, but in
arm, PCI device usually deliver their MSI to PCI hostbridge, if more
than one msi_chip found in system, DTS file will report the binding
between MSI devices and target msi_chip. So we need a platform implemented
interface to do that.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/msi.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7b7abe9..feba5dd 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -29,10 +29,22 @@ static int pci_msi_enable = 1;
 
 /* Arch hooks */
 
-int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+struct msi_chip * __weak arch_get_match_msi_chip(struct device *dev)
+{
+	if (dev_is_pci(dev)) {
+		struct pci_dev *pdev = to_pci_dev(dev);
+		struct msi_chip *chip = pdev->bus->msi;
+
+		return chip;
+	}
+
+	return NULL;
+}
+
+int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 {
-	struct msi_chip *chip = dev->bus->msi;
 	int err;
+	struct msi_chip *chip = arch_get_match_msi_chip(&dev->dev);
 
 	if (!chip || !chip->setup_irq)
 		return -EINVAL;
@@ -46,7 +58,8 @@ int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 
 void __weak arch_teardown_msi_irq(unsigned int irq)
 {
-	struct msi_chip *chip = irq_get_chip_data(irq);
+	struct msi_desc *entry = irq_get_msi_desc(irq);
+	struct msi_chip *chip = arch_get_match_msi_chip(&entry->dev->dev);
 
 	if (!chip || !chip->teardown_irq)
 		return;
@@ -56,7 +69,7 @@ void __weak arch_teardown_msi_irq(unsigned int irq)
 
 int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 {
-	struct msi_chip *chip = dev->bus->msi;
+	struct msi_chip *chip = arch_get_match_msi_chip(&dev->dev);
 
 	if (!chip || !chip->check_device)
 		return 0;
@@ -68,7 +81,12 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
 	int ret;
+	struct msi_chip *chip;
 
+	chip = arch_get_match_msi_chip(&dev->dev);
+	if (chip && chip->setup_irqs)
+		return chip->setup_irqs(&dev->dev, nvec, type);
+
 	/*
 	 * If an architecture wants to support multiple MSI, it needs to
 	 * override arch_setup_msi_irqs()
@@ -133,6 +151,10 @@ static void default_restore_msi_irq(struct pci_dev *dev, int irq)
 
 void __weak arch_restore_msi_irqs(struct pci_dev *dev)
 {
+	struct msi_chip *chip = arch_get_msi_chip(&dev->dev);
+	if (chip && chip->restore_irqs)
+		return chip->restore_irqs(&dev->dev);
+
 	return default_restore_msi_irqs(dev);
 }
 
-- 
1.7.1

