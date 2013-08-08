Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934242Ab3HHNGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:06:02 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:8772 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab3HHNGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:06:00 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Mike Miller <mike.miller@hp.com>
CC: Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, <iss_storagedev@hp.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/16] cciss: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:05:32 +0800
Message-ID: <1375967132-32764-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI core will initialize device MSI/MSI-X capability in
pci_msi_init_pci_dev(). So device driver should use
pci_dev->msi_cap/msix_cap to determine whether the device
support MSI/MSI-X instead of using
pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
Access to PCIe device config space again will consume more time.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/block/cciss.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 62b6c2c..883715a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4078,7 +4078,7 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 	    (h->board_id == 0x40820E11) || (h->board_id == 0x40830E11))
 		goto default_int_mode;
 
-	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
+	if (h->pdev->msix_cap) {
 		err = pci_enable_msix(h->pdev, cciss_msix_entries, 4);
 		if (!err) {
 			h->intr[0] = cciss_msix_entries[0].vector;
@@ -4098,7 +4098,7 @@ static void cciss_interrupt_mode(ctlr_info_t *h)
 			goto default_int_mode;
 		}
 	}
-	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
+	if (h->pdev->msi_cap) {
 		if (!pci_enable_msi(h->pdev))
 			h->msi_vector = 1;
 		else
-- 
1.7.1


