Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab3ICHib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:38:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:38061 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3ICHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:36:00 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/7] scsi/bfa: use pcie_capability_xxx to simplify code
Date: Tue, 3 Sep 2013 15:35:09 +0800
Message-ID: <1378193715-25328-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pcie_capability_xxx() interfaces were introudced to
simplify code to access PCIe Cap config space. And
because PCI core saves the PCIe Cap offset in
set_pcie_port_type() when device is enumerated.
So we can use pci_is_pcie() instead.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 9611195..d726b81 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -767,7 +767,6 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 
 	/* Adjust PCIe Maximum Read Request Size */
 	if (pcie_max_read_reqsz > 0) {
-		int pcie_cap_reg;
 		u16 pcie_dev_ctl;
 		u16 mask = 0xffff;
 
@@ -794,10 +793,8 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 			break;
 		}
 
-		pcie_cap_reg = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-		if (mask != 0xffff && pcie_cap_reg) {
-			pcie_cap_reg += 0x08;
-			pci_read_config_word(pdev, pcie_cap_reg, &pcie_dev_ctl);
+		if (mask != 0xffff && pci_is_pcie(pdev)) {
+			pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &pcie_dev_ctl);
 			if ((pcie_dev_ctl & 0x7000) != mask) {
 				printk(KERN_WARNING "BFA[%s]: "
 				"pcie_max_read_request_size is %d, "
@@ -806,7 +803,7 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 				pcie_max_read_reqsz);
 
 				pcie_dev_ctl &= ~0x7000;
-				pci_write_config_word(pdev, pcie_cap_reg,
+				pcie_capability_write_word(pdev, PCI_EXP_DEVCTL,
 						pcie_dev_ctl | mask);
 			}
 		}
-- 
1.7.1


