Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaHLHDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:03:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:42417 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaHLHD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:03:26 -0400
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
Subject: [RFC PATCH 15/20] s390/MSI: Use msi_chip instead of arch func to configure MSI/MSI-X
Date: Tue, 12 Aug 2014 15:26:08 +0800
Message-ID: <1407828373-24322-16-git-send-email-wangyijing@huawei.com>
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

Introduce a new struct msi_chip zpci_msi_chip instead of weak arch
functions to configure MSI/MSI-X.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/s390/pci/pci.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 9ddc51e..ee7b05c 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -398,8 +398,9 @@ static void zpci_irq_handler(struct airq_struct *airq)
 	}
 }
 
-int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
+int zpci_setup_msi_irqs(struct device *dev, int nvec, int type)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct zpci_dev *zdev = get_zdev(pdev);
 	unsigned int hwirq, msi_vecs;
 	unsigned long aisb;
@@ -474,8 +475,9 @@ out:
 	return rc;
 }
 
-void arch_teardown_msi_irqs(struct pci_dev *pdev)
+void zpci_teardown_msi_irqs(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct zpci_dev *zdev = get_zdev(pdev);
 	struct msi_desc *msi;
 	int rc;
@@ -501,6 +503,16 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
 	airq_iv_free_bit(zpci_aisb_iv, zdev->aisb);
 }
 
+struct msi_chip zpci_msi_chip = {
+	.setup_irqs = zpci_setup_msi_irqs,
+	.teardown_irqs = zpci_teardown_msi_irqs,
+};
+
+struct msi_chip *arch_get_match_msi_chip(struct device *dev)
+{
+	return &zpci_msi_chip;
+}
+
 static void zpci_map_resources(struct zpci_dev *zdev)
 {
 	struct pci_dev *pdev = zdev->pdev;
-- 
1.7.1

