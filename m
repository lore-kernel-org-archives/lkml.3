Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaHLHDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:03:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:42415 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaHLHD0 (ORCPT
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
Subject: [RFC PATCH 17/20] IA64/MSI: Use msi_chip instead of arch func to configure MSI/MSI-X
Date: Tue, 12 Aug 2014 15:26:10 +0800
Message-ID: <1407828373-24322-18-git-send-email-wangyijing@huawei.com>
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

Introduce a new struct msi_chip ia64_msi_chip instead of weak arch
functions to configure MSI/MSI-X.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/ia64/kernel/msi_ia64.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index c430f91..6e527c4 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -112,15 +112,15 @@ static struct irq_chip ia64_msi_chip = {
 };
 
 
-int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
+static int arch_ia64_setup_msi_irq(struct device *dev, struct msi_desc *desc)
 {
 	if (platform_setup_msi_irq)
-		return platform_setup_msi_irq(pdev, desc);
+		return platform_setup_msi_irq(to_pci_dev(dev), desc);
 
-	return ia64_setup_msi_irq(pdev, desc);
+	return ia64_setup_msi_irq(to_pci_dev(dev), desc);
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+static void arch_ia64_teardown_msi_irq(unsigned int irq)
 {
 	if (platform_teardown_msi_irq)
 		return platform_teardown_msi_irq(irq);
@@ -128,6 +128,16 @@ void arch_teardown_msi_irq(unsigned int irq)
 	return ia64_teardown_msi_irq(irq);
 }
 
+static struct msi_chip chip = {
+	.setup_irq = arch_ia64_setup_msi_irq,
+	.teardown_irq = arch_ia64_teardown_msi_irq,
+};
+
+struct msi_chip *arch_get_match_msi_chip(struct device *dev)
+{
+	return &chip;
+}
+
 #ifdef CONFIG_INTEL_IOMMU
 #ifdef CONFIG_SMP
 static int dmar_msi_set_affinity(struct irq_data *data,
-- 
1.7.1

