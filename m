Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519Ab3IEH5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:57:25 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:27994 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763506Ab3IEH5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:57:22 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: Gavin Shan <shangw@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH v2 4/6] x86/pci: use pcie_cap to simplify code
Date: Thu, 5 Sep 2013 15:55:28 +0800
Message-ID: <1378367730-25996-4-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2: use pci_bus_set_ops to replace pci_ops
        and add a dev_info() to notify user that
        the pci_ops was replaced suggested by Bjorn.

PCI core saves PCIe Cap offset in pcie_cap,
use pcie_cap to simplify code. Also we should
use pci_bus_set_ops() to replace pci_ops for
safety and add a dev_info to notify user that
the pci_ops was replaced.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/x86/pci/fixup.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index f5809fa..edd7879 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -252,7 +252,7 @@ static struct pci_ops quirk_pcie_aspm_ops = {
  */
 static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 {
-	int cap_base, i;
+	int i;
 	struct pci_bus  *pbus;
 	struct pci_dev *dev;
 
@@ -278,7 +278,7 @@ static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 		for (i = GET_INDEX(pdev->device, 0); i <= GET_INDEX(pdev->device, 7); ++i)
 			quirk_aspm_offset[i] = 0;
 
-		pbus->ops = pbus->parent->ops;
+		pci_bus_set_ops(pbus, pbus->parent->ops);
 	} else {
 		/*
 		 * If devices are attached to the root port at power-up or
@@ -286,13 +286,16 @@ static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 		 * each root port to save the register offsets and replace the
 		 * bus ops.
 		 */
-		list_for_each_entry(dev, &pbus->devices, bus_list) {
+		list_for_each_entry(dev, &pbus->devices, bus_list)
 			/* There are 0 to 8 devices attached to this bus */
-			cap_base = pci_find_capability(dev, PCI_CAP_ID_EXP);
-			quirk_aspm_offset[GET_INDEX(pdev->device, dev->devfn)] = cap_base + 0x10;
-		}
-		pbus->ops = &quirk_pcie_aspm_ops;
+			quirk_aspm_offset[GET_INDEX(pdev->device, dev->devfn)] =
+				dev->pcie_cap + PCI_EXP_LNKCTL;
+
+		pci_bus_set_ops(pbus, &quirk_pcie_aspm_ops);
+		dev_info(&pbus->dev, "pci_ops is replaced by quirk_pcie_aspm_ops, "
+				"any writes to ASPM control bits will be ignored.\n");
 	}
+
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PA,	pcie_rootport_aspm_quirk);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_MCH_PA1,	pcie_rootport_aspm_quirk);
-- 
1.7.1


