Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbaGZCoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6656 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaGZCnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:49 -0400
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
Subject: [RFC PATCH 04/11] PCI/MSI: Move MSIX table address mapping out of msix_capability_init
Date: Sat, 26 Jul 2014 11:08:41 +0800
Message-ID: <1406344128-27055-5-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move MSIX table address mapping work to PCI MSIX layer.
Some Non-PCI MSI device will do their address mapping work before
enable MSIX capability or their MSIX table address is within
device address block. So Move address mapping stuff out of the
generic MSIX core. This is prepartion for generic MSI drvier.

Suggested-by: Yun Wu <wuyun.wu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/msi.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d5c8e56..116383c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -668,8 +668,8 @@ static void __iomem *msix_map_region(struct pci_dev *dev, unsigned nr_entries)
 	u32 table_offset;
 	u8 bir;
 
-	pci_read_config_dword(dev, dev->msix_cap + PCI_MSIX_TABLE,
-			      &table_offset);
+	pci_read_config_dword(dev, dev->msix_cap + PCI_MSIX_TABLE, 
+				&table_offset);
 	bir = (u8)(table_offset & PCI_MSIX_TABLE_BIR);
 	table_offset &= PCI_MSIX_TABLE_OFFSET;
 	phys_addr = pci_resource_start(dev, bir) + table_offset;
@@ -734,22 +734,14 @@ static void msix_program_entries(struct pci_dev *dev,
  * single MSI-X irq. A return of zero indicates the successful setup of
  * requested MSI-X entries with allocated irqs or non-zero for otherwise.
  **/
-static int msix_capability_init(struct pci_dev *dev,
+static int msix_capability_init(struct pci_dev *dev, void __iomem *base,
 				struct msix_entry *entries, int nvec)
 {
 	int ret;
-	u16 control;
-	void __iomem *base;
 
 	/* Ensure MSI-X is disabled while it is set up */
 	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
 
-	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
-	/* Request & Map MSI-X table region */
-	base = msix_map_region(dev, msix_table_size(control));
-	if (!base)
-		return -ENOMEM;
-
 	ret = msix_setup_entries(dev, base, entries, nvec);
 	if (ret)
 		return ret;
@@ -948,6 +940,8 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 {
 	int status, nr_entries;
 	int i, j;
+	void __iomem *base;
+	u16 control;
 
 	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
 		return -EINVAL;
@@ -978,7 +972,14 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 		dev_info(&dev->dev, "can't enable MSI-X (MSI IRQ already assigned)\n");
 		return -EINVAL;
 	}
-	status = msix_capability_init(dev, entries, nvec);
+
+	/* Request & Map MSI-X table region */
+	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
+	base = msix_map_region(dev, msix_table_size(control));
+	if (!base)
+		return -ENOMEM;
+
+	status = msix_capability_init(dev, base, entries, nvec);
 	return status;
 }
 EXPORT_SYMBOL(pci_enable_msix);
-- 
1.7.1

