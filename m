Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaHLHFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:05:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51417 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbaHLHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:03:23 -0400
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
Subject: [RFC PATCH 09/20] irq_remapping/MSI: Use msi_chip instead of arch func to configure MSI/MSI-X
Date: Tue, 12 Aug 2014 15:26:02 +0800
Message-ID: <1407828373-24322-10-git-send-email-wangyijing@huawei.com>
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

Introduce a new struct msi_chip remap_msi_chip instead of weak arch
functions to configure irq remapping MSI/MSI-X in x86.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/irq_remapping.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 33c4395..f494b51 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -139,15 +139,20 @@ error:
 	return ret;
 }
 
-static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
+static int irq_remapping_setup_msi_irqs(struct device *dev,
 					int nvec, int type)
 {
 	if (type == PCI_CAP_ID_MSI)
-		return do_setup_msi_irqs(dev, nvec);
+		return do_setup_msi_irqs(to_pci_dev(dev), nvec);
 	else
-		return do_setup_msix_irqs(dev, nvec);
+		return do_setup_msix_irqs(to_pci_dev(dev), nvec);
 }
 
+struct msi_chip remap_msi_chip = {
+	.setup_irqs = irq_remapping_setup_msi_irqs,
+	.teardown_irq = native_teardown_msi_irq,
+};
+
 static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 {
 	/*
@@ -165,9 +170,9 @@ static void __init irq_remapping_modify_x86_ops(void)
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
-	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
+	x86_msi_chip = &remap_msi_chip;
 }
 
 static __init int setup_nointremap(char *str)
-- 
1.7.1

